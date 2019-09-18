Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571D2B5A8F
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 06:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfIRE5Z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 18 Sep 2019 00:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfIRE5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 00:57:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 266F7C058CA4
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 04:57:24 +0000 (UTC)
Received: from [172.54.124.190] (cpt-1056.paas.prod.upshift.rdu2.redhat.com [10.0.19.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A712600C8;
        Wed, 18 Sep 2019 04:57:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.D77C165E74.IA9K2OU6S7@redhat.com>
X-Gitlab-Pipeline-ID: 170952
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/170952
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 18 Sep 2019 04:57:24 +0000 (UTC)
Date:   Wed, 18 Sep 2019 00:57:25 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 6e282ba6ff6b - Linux 5.2.15

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/170952

Please reply to this email if you have any questions about the tests that we
ran or if you have any suggestions on how to make future tests more effective.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
______________________________________________________________________________

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 6e282ba6ff6b - Linux 5.2.15


We grabbed the 88ed4e4e9249 commit of the stable queue repository.

We then merged the patchset with `git am`:

  bridge-mdb-remove-wrong-use-of-nlm_f_multi.patch
  cdc_ether-fix-rndis-support-for-mediatek-based-smartphones.patch
  ipv6-fix-the-link-time-qualifier-of-ping_v6_proc_exit_net.patch
  isdn-capi-check-message-length-in-capi_write.patch
  ixgbe-fix-secpath-usage-for-ipsec-tx-offload.patch
  ixgbevf-fix-secpath-usage-for-ipsec-tx-offload.patch
  net-fix-null-de-reference-of-device-refcount.patch
  net-gso-fix-skb_segment-splat-when-splitting-gso_size-mangled-skb-having-linear-headed-frag_list.patch
  net-phylink-fix-flow-control-resolution.patch
  net-sched-fix-reordering-issues.patch
  sch_hhf-ensure-quantum-and-hhf_non_hh_weight-are-non-zero.patch
  sctp-fix-the-link-time-qualifier-of-sctp_ctrlsock_exit.patch
  sctp-use-transport-pf_retrans-in-sctp_do_8_2_transport_strike.patch
  tcp-fix-tcp_ecn_withdraw_cwr-to-clear-tcp_ecn_queue_cwr.patch
  tipc-add-null-pointer-check-before-calling-kfree_rcu.patch
  tun-fix-use-after-free-when-register-netdev-failed.patch
  net-ipv6-fix-excessive-rtf_addrconf-flag-on-1-128-local-route-and-others.patch
  ipv6-addrconf_f6i_alloc-fix-non-null-pointer-check-to-is_err.patch
  net-fixed_phy-add-forward-declaration-for-struct-gpio_desc.patch
  sctp-fix-the-missing-put_user-when-dumping-transport-thresholds.patch
  net-sock_map-fix-missing-ulp-check-in-sock-hash-case.patch
  gpiolib-acpi-add-gpiolib_acpi_run_edge_events_on_boot-option-and-blacklist.patch
  gpio-mockup-add-missing-single_release.patch
  gpio-fix-line-flag-validation-in-linehandle_create.patch
  gpio-fix-line-flag-validation-in-lineevent_create.patch
  btrfs-fix-assertion-failure-during-fsync-and-use-of-stale-transaction.patch
  cgroup-freezer-fix-frozen-state-inheritance.patch
  revert-mmc-bcm2835-terminate-timeout-work-synchronously.patch
  revert-mmc-sdhci-remove-unneeded-quirk2-flag-of-o2-sd-host-controller.patch
  mmc-tmio-fixup-runtime-pm-management-during-probe.patch
  mmc-tmio-fixup-runtime-pm-management-during-remove.patch
  drm-lima-fix-lima_gem_wait-return-value.patch
  drm-i915-limit-mst-to-8bpc-once-again.patch
  drm-i915-restore-relaxed-padding-ocl_oob_suppres_enable-for-skl.patch
  ipc-fix-semtimedop-for-generic-32-bit-architectures.patch
  ipc-fix-sparc64-ipc-wrapper.patch
  ixgbe-fix-double-clean-of-tx-descriptors-with-xdp.patch
  ixgbe-prevent-u8-wrapping-of-itr-value-to-something-less-than-10us.patch
  revert-rt2800-enable-tx_pin_cfg_lna_pe_-bits-per-band.patch
  mt76-mt76x0e-disable-5ghz-band-for-mt7630e.patch
  genirq-prevent-null-pointer-dereference-in-resend_irqs.patch
  regulator-twl-voltage-lists-for-vdd1-2-on-twl4030.patch
  kvm-s390-kvm_s390_vm_start_migration-check-dirty_bitmap-before-using-it-as-target-for-memset.patch
  kvm-s390-do-not-leak-kernel-stack-data-in-the-kvm_s390_interrupt-ioctl.patch
  kvm-x86-work-around-leak-of-uninitialized-stack-contents.patch
  kvm-x86-mmu-reintroduce-fast-invalidate-zap-for-flushing-memslot.patch
  kvm-nvmx-handle-page-fault-in-vmread.patch
  x86-purgatory-change-compiler-flags-from-mcmodel-kernel-to-mcmodel-large-to-fix-kexec-relocation-errors.patch
  powerpc-add-barrier_nospec-to-raw_copy_in_user.patch
  kernel-module-fix-mem-leak-in-module_add_modinfo_attrs.patch
  x86-boot-use-efi_setup_data-for-searching-rsdp-on-kexec-ed-kernels.patch
  x86-ima-check-efi-setupmode-too.patch
  drm-meson-add-support-for-xbgr8888-abgr8888-formats.patch
  clk-fix-debugfs-clk_possible_parents-for-clks-without-parent-string-names.patch
  clk-simplify-debugfs-printing-and-add-a-newline.patch
  mt76-fix-a-signedness-bug-in-mt7615_add_interface.patch
  mt76-mt7615-use-after-free-in-mt7615_mcu_set_bcn.patch
  clk-rockchip-don-t-yell-about-bad-mmc-phases-when-getting.patch
  mtd-rawnand-mtk-fix-wrongly-assigned-oob-buffer-pointer-issue.patch
  pci-always-allow-probing-with-driver_override.patch
  ubifs-correctly-use-tnc_next-in-search_dh_cookie.patch
  driver-core-fix-use-after-free-and-double-free-on-glue-directory.patch
  crypto-talitos-check-aes-key-size.patch
  crypto-talitos-fix-ctr-alg-blocksize.patch
  crypto-talitos-check-data-blocksize-in-ablkcipher.patch
  crypto-talitos-fix-ecb-algs-ivsize.patch
  crypto-talitos-do-not-modify-req-cryptlen-on-decryption.patch
  crypto-talitos-hmac-snoop-no-afeu-mode-requires-sw-icv-checking.patch
  firmware-ti_sci-always-request-response-from-firmware.patch
  drm-panel-orientation-quirks-add-extra-quirk-table-entry-for-gpd-micropc.patch
  drm-mediatek-mtk_drm_drv.c-add-of_node_put-before-goto.patch
  mm-z3fold.c-remove-z3fold_migration-trylock.patch
  mm-z3fold.c-fix-lock-unlock-imbalance-in-z3fold_page_isolate.patch
  revert-bluetooth-btusb-driver-to-enable-the-usb-wakeup-feature.patch
  iio-adc-stm32-dfsdm-fix-output-resolution.patch
  iio-adc-stm32-dfsdm-fix-data-type.patch
  modules-fix-bug-when-load-module-with-rodata-n.patch
  modules-fix-compile-error-if-don-t-have-strict-module-rwx.patch
  modules-always-page-align-module-section-allocations.patch
  kvm-nvmx-remove-unnecessary-sync_roots-from-handle_invept.patch
  kvm-svm-fix-detection-of-amd-errata-1096.patch
  platform-x86-pmc_atom-add-cb4063-beckhoff-automation-board-to-critclk_systems-dmi-table.patch
  platform-x86-pcengines-apuv2-use-key_restart-for-front-button.patch
  rsi-fix-a-double-free-bug-in-rsi_91x_deinit.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [2]
         ✅ Podman system integration test (as user) [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Ethernet drivers sanity [7]
         ✅ Networking socket: fuzz [8]
         ✅ Networking sctp-auth: sockopts test [9]
         ✅ Networking TCP: keepalive test [10]
         ✅ audit: audit testsuite test [11]
         ✅ httpd: mod_ssl smoke sanity [12]
         ✅ iotop: sanity [13]
         ✅ tuned: tune-processes-through-perf [14]
         ✅ Usex - version 1.9-29 [15]
         🚧 ✅ LTP lite [17]
         🚧 ✅ Memory function: kaslr [18]
         🚧 ✅ Networking bridge: sanity [19]
         🚧 ✅ Networking route: pmtu [20]
         🚧 ✅ Networking route_func: local [21]
         🚧 ✅ Networking route_func: forward [21]

  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [2]
         ✅ Podman system integration test (as user) [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Ethernet drivers sanity [7]
         ✅ Networking socket: fuzz [8]
         ✅ Networking sctp-auth: sockopts test [9]
         ✅ Networking TCP: keepalive test [10]
         ✅ audit: audit testsuite test [11]
         ✅ httpd: mod_ssl smoke sanity [12]
         ✅ iotop: sanity [13]
         ✅ tuned: tune-processes-through-perf [14]
         ✅ Usex - version 1.9-29 [15]
         🚧 ✅ LTP lite [17]
         🚧 ✅ Memory function: kaslr [18]
         🚧 ✅ Networking bridge: sanity [19]
         🚧 ✅ Networking route: pmtu [20]
         🚧 ✅ Networking route_func: local [21]
         🚧 ✅ Networking route_func: forward [21]

  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [2]
         ✅ Podman system integration test (as user) [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Ethernet drivers sanity [7]
         ✅ Networking socket: fuzz [8]
         ✅ Networking sctp-auth: sockopts test [9]
         ✅ Networking TCP: keepalive test [10]
         ✅ audit: audit testsuite test [11]
         ✅ httpd: mod_ssl smoke sanity [12]
         ✅ iotop: sanity [13]
         ✅ tuned: tune-processes-through-perf [14]
         ✅ pciutils: sanity smoke test [22]
         ✅ Usex - version 1.9-29 [15]
         ✅ stress: stress-ng [16]
         🚧 ✅ LTP lite [17]
         🚧 ✅ Memory function: kaslr [18]
         🚧 ✅ Networking bridge: sanity [19]
         🚧 ✅ Networking route: pmtu [20]
         🚧 ✅ Networking route_func: local [21]
         🚧 ✅ Networking route_func: forward [21]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#memory/function/kaslr
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/bridge/sanity_check
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
