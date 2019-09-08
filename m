Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBFAACA62
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 04:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfIHCfM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 7 Sep 2019 22:35:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfIHCfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Sep 2019 22:35:12 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 01CC58E2B8D
        for <stable@vger.kernel.org>; Sun,  8 Sep 2019 02:35:12 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5E035D6B0;
        Sun,  8 Sep 2019 02:35:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
CC:     Memory Management <mm-qe@redhat.com>
Message-ID: <cki.1147A3E1B7.MAKVSOYCLK@redhat.com>
X-Gitlab-Pipeline-ID: 150888
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/150888
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Sun, 08 Sep 2019 02:35:12 +0000 (UTC)
Date:   Sat, 7 Sep 2019 22:35:12 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 218ca2e5affe - Linux 5.2.13

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/150888

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
  Commit: 218ca2e5affe - Linux 5.2.13


We grabbed the ba155668e45f commit of the stable queue repository.

We then merged the patchset with `git am`:

  batman-adv-fix-netlink-dumping-of-all-mcast_flags-bu.patch
  libbpf-fix-erroneous-multi-closing-of-btf-fd.patch
  libbpf-set-btf-fd-for-prog-only-when-there-is-suppor.patch
  netfilter-nf_flow_table-fix-offload-for-flows-that-a.patch
  net-mlx5e-fix-error-flow-of-cqe-recovery-on-tx-repor.patch
  clk-samsung-change-signature-of-exynos5_subcmus_init.patch
  clk-samsung-exynos5800-move-mau-subsystem-clocks-to-.patch
  clk-samsung-exynos542x-move-mscl-subsystem-clocks-to.patch
  net-tundra-tsi108-use-spin_lock_irqsave-instead-of-s.patch
  netfilter-nf_tables-use-after-free-in-failing-rule-w.patch
  netfilter-nf_flow_table-conntrack-picks-up-expired-f.patch
  netfilter-nf_flow_table-teardown-flow-timeout-race.patch
  tools-bpftool-fix-error-message-prog-object.patch
  ixgbe-fix-possible-deadlock-in-ixgbe_service_task.patch
  hv_netvsc-fix-a-warning-of-suspicious-rcu-usage.patch
  net-tc35815-explicitly-check-net_ip_align-is-not-zer.patch
  bluetooth-btqca-add-a-short-delay-before-downloading.patch
  bluetooth-hci_qca-send-vs-pre-shutdown-command.patch
  bluetooth-hidp-let-hidp_send_message-return-number-o.patch
  s390-qeth-serialize-cmd-reply-with-concurrent-timeou.patch
  ibmveth-convert-multicast-list-size-for-little-endia.patch
  gpio-fix-build-error-of-function-redefinition.patch
  netfilter-nft_flow_offload-skip-tcp-rst-and-fin-pack.patch
  drm-mediatek-use-correct-device-to-import-prime-buff.patch
  drm-mediatek-set-dma-max-segment-size.patch
  scsi-qla2xxx-fix-gnl.l-memory-leak-on-adapter-init-f.patch
  scsi-target-tcmu-avoid-use-after-free-after-command-.patch
  cxgb4-fix-a-memory-leak-bug.patch
  selftests-kvm-do-not-try-running-the-vm-in-vmx_set_n.patch
  selftests-kvm-provide-common-function-to-enable-evmc.patch
  selftests-kvm-fix-vmx_set_nested_state_test.patch
  liquidio-add-cleanup-in-octeon_setup_iq.patch
  net-myri10ge-fix-memory-leaks.patch
  clk-fix-falling-back-to-legacy-parent-string-matchin.patch
  clk-fix-potential-null-dereference-in-clk_fetch_pare.patch
  lan78xx-fix-memory-leaks.patch
  vfs-fix-page-locking-deadlocks-when-deduping-files.patch
  cx82310_eth-fix-a-memory-leak-bug.patch
  net-kalmia-fix-memory-leaks.patch
  ibmvnic-unmap-dma-address-of-tx-descriptor-buffers-a.patch
  net-cavium-fix-driver-name.patch
  wimax-i2400m-fix-a-memory-leak-bug.patch
  ravb-fix-use-after-free-ravb_tstamp_skb.patch
  sched-core-schedule-new-worker-even-if-pi-blocked.patch
  kprobes-fix-potential-deadlock-in-kprobe_optimizer.patch
  hid-intel-ish-hid-ipc-add-ehl-device-id.patch
  hid-cp2112-prevent-sleeping-function-called-from-inv.patch
  x86-boot-compressed-64-fix-boot-on-machines-with-bro.patch
  scsi-lpfc-mitigate-high-memory-pre-allocation-by-scs.patch
  input-hyperv-keyboard-use-in-place-iterator-api-in-t.patch
  tools-hv-kvp-eliminate-may-be-used-uninitialized-war.patch
  nvme-multipath-fix-possible-i-o-hang-when-paths-are-.patch
  nvme-fix-cntlid-validation-when-not-using-nvmeof.patch
  rdma-cma-fix-null-ptr-deref-read-in-cma_cleanup.patch
  ib-mlx4-fix-memory-leaks.patch
  infiniband-hfi1-fix-a-memory-leak-bug.patch
  infiniband-hfi1-fix-memory-leaks.patch
  selftests-kvm-fix-state-save-load-on-processors-with.patch
  selftests-kvm-make-platform_info_test-pass-on-amd.patch
  drm-amdgpu-prevent-memory-leaks-in-amdgpu_cs-ioctl.patch
  ceph-fix-buffer-free-while-holding-i_ceph_lock-in-__.patch
  ceph-fix-buffer-free-while-holding-i_ceph_lock-in-__.patch
  ceph-fix-buffer-free-while-holding-i_ceph_lock-in-fi.patch
  kvm-arm-arm64-only-skip-mmio-insn-once.patch
  afs-fix-leak-in-afs_lookup_cell_rcu.patch
  afs-fix-possible-oops-in-afs_lookup-trace-event.patch
  afs-use-correct-afs_call_type-in-yfs_fs_store_opaque.patch
  rdma-bnxt_re-fix-stack-out-of-bounds-in-bnxt_qplib_r.patch
  gpio-fix-irqchip-initialization-order.patch
  kvm-arm-arm64-vgic-properly-initialise-private-irq-a.patch
  x86-boot-compressed-64-fix-missing-initialization-in.patch
  libceph-allow-ceph_buffer_put-to-receive-a-null-ceph.patch
  revert-x86-apic-include-the-ldr-when-clearing-out-ap.patch

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

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.


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
         ✅ audit: audit testsuite test [8]
         ✅ httpd: mod_ssl smoke sanity [9]
         ✅ iotop: sanity [10]
         ✅ tuned: tune-processes-through-perf [11]
         ✅ Usex - version 1.9-29 [12]
         🚧 ✅ LTP lite [13]
         🚧 ✅ Memory function: kaslr [14]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: xfs [15]
         ✅ selinux-policy: serge-testsuite [16]
         🚧 ✅ Storage blktests [17]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: xfs [15]
         ✅ selinux-policy: serge-testsuite [16]
         🚧 ✅ Storage blktests [17]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ Networking socket: fuzz [7]
         ✅ audit: audit testsuite test [8]
         ✅ httpd: mod_ssl smoke sanity [9]
         ✅ iotop: sanity [10]
         ✅ tuned: tune-processes-through-perf [11]
         ✅ pciutils: sanity smoke test [18]
         ✅ Usex - version 1.9-29 [12]
         ✅ storage: SCSI VPD [19]
         ✅ stress: stress-ng [20]
         🚧 ✅ LTP lite [13]
         🚧 ❌ Memory function: kaslr [14]


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
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#memory/function/kaslr
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
