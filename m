Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03AEA614E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfICGXg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 3 Sep 2019 02:23:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45911 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbfICGXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 02:23:34 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0339020260
        for <stable@vger.kernel.org>; Tue,  3 Sep 2019 06:23:34 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC8AC57AA;
        Tue,  3 Sep 2019 06:23:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
CC:     William Gomeringer <wgomeringer@redhat.com>
Message-ID: <cki.47ABBC3BA3.WG6V7ALEK9@redhat.com>
X-Gitlab-Pipeline-ID: 140276
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/140276
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 03 Sep 2019 06:23:34 +0000 (UTC)
Date:   Tue, 3 Sep 2019 02:23:34 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: c3915fe1bf12 - Linux 5.2.11

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/140276

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
  Commit: c3915fe1bf12 - Linux 5.2.11


We grabbed the a72cf2e32965 commit of the stable queue repository.

We then merged the patchset with `git am`:

  dmaengine-ste_dma40-fix-unneeded-variable-warning.patch
  nvme-multipath-revalidate-nvme_ns_head-gendisk-in-nv.patch
  afs-fix-the-cb.probeuuid-service-handler-to-reply-co.patch
  afs-fix-loop-index-mixup-in-afs_deliver_vl_get_entry.patch
  fs-afs-fix-a-possible-null-pointer-dereference-in-af.patch
  afs-fix-off-by-one-in-afs_rename-expected-data-versi.patch
  afs-only-update-d_fsdata-if-different-in-afs_d_reval.patch
  afs-fix-missing-dentry-data-version-updating.patch
  nvmet-fix-use-after-free-bug-when-a-port-is-removed.patch
  nvmet-loop-flush-nvme_delete_wq-when-removing-the-po.patch
  nvmet-file-fix-nvmet_file_flush-always-returning-an-.patch
  nvme-core-fix-extra-device_put-call-on-error-path.patch
  nvme-fix-a-possible-deadlock-when-passthru-commands-.patch
  nvme-rdma-fix-possible-use-after-free-in-connect-err.patch
  nvme-fix-controller-removal-race-with-scan-work.patch
  nvme-pci-fix-async-probe-remove-race.patch
  soundwire-cadence_master-fix-register-definition-for.patch
  soundwire-cadence_master-fix-definitions-for-intstat.patch
  auxdisplay-panel-need-to-delete-scan_timer-when-misc.patch
  btrfs-trim-check-the-range-passed-into-to-prevent-ov.patch
  ib-mlx5-fix-implicit-mr-release-flow.patch
  dmaengine-stm32-mdma-fix-a-possible-null-pointer-der.patch
  omap-dma-omap_vout_vrfb-fix-off-by-one-fi-value.patch
  iommu-dma-handle-sg-length-overflow-better.patch
  dma-direct-don-t-truncate-dma_required_mask-to-bus-a.patch
  usb-gadget-composite-clear-suspended-on-reset-discon.patch
  usb-gadget-mass_storage-fix-races-between-fsg_disabl.patch
  habanalabs-fix-dram-usage-accounting-on-context-tear.patch
  habanalabs-fix-endianness-handling-for-packets-from-.patch
  habanalabs-fix-completion-queue-handling-when-host-i.patch
  habanalabs-fix-endianness-handling-for-internal-qman.patch
  habanalabs-fix-device-irq-unmasking-for-be-host.patch
  xen-blkback-fix-memory-leaks.patch
  arm64-cpufeature-don-t-treat-granule-sizes-as-strict.patch
  riscv-fix-flush_tlb_range-end-address-for-flush_tlb_.patch
  i2c-rcar-avoid-race-when-unregistering-slave-client.patch
  i2c-emev2-avoid-race-when-unregistering-slave-client.patch
  drm-scheduler-use-job-count-instead-of-peek.patch
  drm-ast-fixed-reboot-test-may-cause-system-hanged.patch
  usb-host-fotg2-restart-hcd-after-port-reset.patch
  tools-hv-fixed-python-pep8-flake8-warnings-for-lsvmb.patch
  tools-hv-fix-kvp-and-vss-daemons-exit-code.patch
  locking-rwsem-add-missing-acquire-to-read_slowpath-e.patch
  lcoking-rwsem-add-missing-acquire-to-read_slowpath-s.patch
  watchdog-bcm2835_wdt-fix-module-autoload.patch
  selftests-bpf-install-files-test_xdp_vlan.sh.patch
  drm-bridge-tfp410-fix-memleak-in-get_modes.patch
  mt76-usb-fix-rx-a-msdu-support.patch
  ipv6-addrconf-allow-adding-multicast-addr-if-ifa_f_mcautojoin-is-set.patch
  ipv6-fix-return-value-of-ipv6_mc_may_pull-for-malformed-packets.patch
  net-cpsw-fix-null-pointer-exception-in-the-probe-error-path.patch
  net-fix-__ip_mc_inc_group-usage.patch
  net-smc-make-sure-epollout-is-raised.patch
  tcp-make-sure-epollout-wont-be-missed.patch
  ipv4-mpls-fix-mpls_xmit-for-iptunnel.patch
  openvswitch-fix-conntrack-cache-with-timeout.patch
  ipv4-icmp-fix-rt-dst-dev-null-pointer-dereference.patch
  xfrm-xfrm_policy-fix-dst-dev-null-pointer-dereference-in-collect_md-mode.patch
  mm-zsmalloc.c-fix-build-when-config_compaction-n.patch
  alsa-usb-audio-check-mixer-unit-bitmap-yet-more-strictly.patch
  alsa-hda-ca0132-add-new-sbz-quirk.patch
  alsa-line6-fix-memory-leak-at-line6_init_pcm-error-path.patch
  alsa-hda-fixes-inverted-conexant-gpio-mic-mute-led.patch
  alsa-seq-fix-potential-concurrent-access-to-the-deleted-pool.patch
  alsa-usb-audio-fix-invalid-null-check-in-snd_emuusb_set_samplerate.patch
  alsa-usb-audio-add-implicit-fb-quirk-for-behringer-ufx1604.patch
  kvm-x86-skip-populating-logical-dest-map-if-apic-is-not-sw-enabled.patch
  kvm-x86-hyper-v-don-t-crash-on-kvm_get_supported_hv_cpuid-when-kvm_intel.nested-is-disabled.patch
  kvm-x86-don-t-update-rip-or-do-single-step-on-faulting-emulation.patch
  uprobes-x86-fix-detection-of-32-bit-user-mode.patch
  x86-mm-cpa-prevent-large-page-split-when-ftrace-flips-rw-on-kernel-text.patch
  x86-apic-do-not-initialize-ldr-and-dfr-for-bigsmp.patch
  x86-apic-include-the-ldr-when-clearing-out-apic-registers.patch

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
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ Networking socket: fuzz [7]
         ✅ Networking: igmp conformance test [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [14]
         🚧 ✅ LTP lite [15]
         🚧 ✅ Memory function: kaslr [16]
         🚧 ✅ Networking ipsec: basic netns transport [17]
         🚧 ✅ Networking ipsec: basic netns tunnel [17]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [18]
         🚧 ✅ Storage blktests [19]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [18]
         🚧 ✅ Storage blktests [19]

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
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]
         🚧 ✅ LTP lite [15]
         🚧 ✅ Memory function: kaslr [16]
         🚧 ✅ Networking ipsec: basic netns tunnel [17]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [18]
         🚧 ✅ Storage blktests [19]
         🚧 ❌ IOMMU boot test [20]

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
         ✅ Networking: igmp conformance test [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ pciutils: sanity smoke test [21]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [14]
         🚧 ✅ LTP lite [15]
         🚧 ✅ Memory function: kaslr [16]
         🚧 ✅ Networking ipsec: basic netns transport [17]
         🚧 ✅ Networking ipsec: basic netns tunnel [17]


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
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#memory/function/kaslr
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
