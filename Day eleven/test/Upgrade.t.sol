// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "forge-std/Test.sol";
import "../src/BoxV1.sol";
import "../src/BoxV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract UpgradeTest is Test {
    BoxV1 public boxV1;
    BoxV2 public boxV2;
    ERC1967Proxy public proxy;

    address public owner = address(0x1);

    function setUp() public {
        vm.startPrank(owner);

        // 1. Deploy Implementation V1
        boxV1 = new BoxV1();

        // 2. Deploy Proxy dan panggil initialize(42)
        bytes memory initData = abi.encodeWithSelector(BoxV1.initialize.selector, 42);
        proxy = new ERC1967Proxy(address(boxV1), initData);

        vm.stopPrank();
    }

    function test_UpgradeToV2() public {
        // Akses kontrak lewat alamat Proxy
        BoxV1 proxyBox = BoxV1(address(proxy));
        assertEq(proxyBox.getValue(), 42);

        // Proses Upgrade ke V2
        vm.startPrank(owner);
        boxV2 = new BoxV2();
        
        // Melakukan upgrade alamat implementation pada proxy
        BoxV1(address(proxy)).upgradeToAndCall(address(boxV2), "");
        vm.stopPrank();

        // Cast Proxy ke tipe BoxV2
        BoxV2 proxyBoxV2 = BoxV2(address(proxy));

        // Panggil fungsi baru increment()
        proxyBoxV2.increment();
        
        // Nilai bertambah dari 42 menjadi 43, sementara alamat proxy tetap sama
        assertEq(proxyBoxV2.getValue(), 43);
    }
}
