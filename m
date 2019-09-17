Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67ADEB56D9
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 22:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfIQUX4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 17 Sep 2019 16:23:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28729 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbfIQUXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 16:23:55 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A74E18C426E
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 20:23:55 +0000 (UTC)
Received: from [172.54.124.190] (cpt-1056.paas.prod.upshift.rdu2.redhat.com [10.0.19.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1B2A600C4;
        Tue, 17 Sep 2019 20:23:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.428D409B22.KWSWR5ESO2@redhat.com>
X-Gitlab-Pipeline-ID: 170508
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/170508
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Tue, 17 Sep 2019 20:23:55 +0000 (UTC)
Date:   Tue, 17 Sep 2019 16:23:55 -0400
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

  https://artifacts.cki-project.org/pipelines/170508

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


We grabbed the 5f932ae10f6f commit of the stable queue repository.

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

Compile testing
---------------

We compiled the kernel for 4 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    s390x:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ Networking socket: fuzz [7]
         ✅ Networking sctp-auth: sockopts test [8]
         ✅ Networking TCP: keepalive test [9]
         ✅ audit: audit testsuite test [10]
         ✅ httpd: mod_ssl smoke sanity [11]
         ✅ iotop: sanity [12]
         ✅ tuned: tune-processes-through-perf [13]
         ✅ Usex - version 1.9-29 [14]
         ✅ stress: stress-ng [15]
         🚧 ✅ LTP lite [16]
         🚧 ✅ Memory function: kaslr [17]
         🚧 ✅ Networking bridge: sanity [18]
         🚧 ✅ Networking route: pmtu [19]
         🚧 ✅ Networking route_func: local [20]
         🚧 ✅ Networking route_func: forward [20]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [21]

  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ Networking socket: fuzz [7]
         ✅ Networking sctp-auth: sockopts test [8]
         ✅ Networking TCP: keepalive test [9]
         ✅ audit: audit testsuite test [10]
         ✅ httpd: mod_ssl smoke sanity [11]
         ✅ iotop: sanity [12]
         ✅ tuned: tune-processes-through-perf [13]
         ✅ Usex - version 1.9-29 [14]
         🚧 ✅ LTP lite [16]
         🚧 ✅ Memory function: kaslr [17]
         🚧 ✅ Networking bridge: sanity [18]
         🚧 ✅ Networking route: pmtu [19]
         🚧 ✅ Networking route_func: local [20]
         🚧 ✅ Networking route_func: forward [20]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [21]

  s390x:

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.

  x86_64:
      Host 1:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ Networking socket: fuzz [7]
         ✅ Networking sctp-auth: sockopts test [8]
         ✅ Networking TCP: keepalive test [9]
         ✅ audit: audit testsuite test [10]
         ✅ httpd: mod_ssl smoke sanity [11]
         ✅ iotop: sanity [12]
         ✅ tuned: tune-processes-through-perf [13]
         ✅ pciutils: sanity smoke test [22]
         ✅ Usex - version 1.9-29 [14]
         ✅ stress: stress-ng [15]
         🚧 ⚡⚡⚡ LTP lite [16]
         🚧 ✅ Memory function: kaslr [17]
         🚧 ✅ Networking bridge: sanity [18]
         🚧 ✅ Networking route: pmtu [19]
         🚧 ✅ Networking route_func: local [20]
         🚧 ✅ Networking route_func: forward [20]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [21]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#memory/function/kaslr
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/bridge/sanity_check
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
