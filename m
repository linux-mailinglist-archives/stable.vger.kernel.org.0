Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE18DD69C
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 06:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfJSEa2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 19 Oct 2019 00:30:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfJSEa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Oct 2019 00:30:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F20B3308212D
        for <stable@vger.kernel.org>; Sat, 19 Oct 2019 04:30:27 +0000 (UTC)
Received: from [172.54.99.2] (cpt-1058.paas.prod.upshift.rdu2.redhat.com [10.0.19.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E77F5DA5B;
        Sat, 19 Oct 2019 04:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Message-ID: <cki.47FFA146B4.T2C1GHRICD@redhat.com>
X-Gitlab-Pipeline-ID: 234049
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/234049
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Sat, 19 Oct 2019 04:30:28 +0000 (UTC)
Date:   Sat, 19 Oct 2019 00:30:28 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 365dab61f74e - Linux 5.3.7

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/234049

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
  Commit: 365dab61f74e - Linux 5.3.7


We grabbed the 8790a8b4e158 commit of the stable queue repository.

We then merged the patchset with `git am`:

  drm-free-the-writeback_job-when-it-with-an-empty-fb.patch
  drm-clear-the-fence-pointer-when-writeback-job-signa.patch
  clk-ti-dra7-fix-mcasp8-clock-bits.patch
  arm-dts-fix-wrong-clocks-for-dra7-mcasp.patch
  nvme-pci-fix-a-race-in-controller-removal.patch
  scsi-ufs-skip-shutdown-if-hba-is-not-powered.patch
  scsi-megaraid-disable-device-when-probe-failed-after.patch
  scsi-qla2xxx-silence-fwdump-template-message.patch
  scsi-qla2xxx-fix-unbound-sleep-in-fcport-delete-path.patch
  scsi-qla2xxx-fix-stale-mem-access-on-driver-unload.patch
  scsi-qla2xxx-fix-n2n-link-reset.patch
  scsi-qla2xxx-fix-n2n-link-up-fail.patch
  arm-dts-fix-gpio0-flags-for-am335x-icev2.patch
  arm-omap2-fix-missing-reset-done-flag-for-am3-and-am.patch
  arm-omap2-add-missing-lcdc-midlemode-for-am335x.patch
  arm-omap2-fix-warnings-with-broken-omap2_set_init_vo.patch
  nvme-tcp-fix-wrong-stop-condition-in-io_work.patch
  nvme-pci-save-pci-state-before-putting-drive-into-de.patch
  nvme-fix-an-error-code-in-nvme_init_subsystem.patch
  nvme-rdma-fix-max_hw_sectors-calculation.patch
  added-quirks-for-adata-xpg-sx8200-pro-512gb.patch
  nvme-add-quirk-for-kingston-nvme-ssd-running-fw-e8fk.patch
  nvme-allow-64-bit-results-in-passthru-commands.patch
  drm-komeda-prevent-memory-leak-in-komeda_wb_connecto.patch
  nvme-rdma-fix-possible-use-after-free-in-connect-tim.patch
  blk-mq-honor-io-scheduler-for-multiqueue-devices.patch
  ieee802154-ca8210-prevent-memory-leak.patch
  arm-dts-am4372-set-memory-bandwidth-limit-for-dispc.patch
  net-dsa-qca8k-use-up-to-7-ports-for-all-operations.patch
  mips-dts-ar9331-fix-interrupt-controller-size.patch
  xen-efi-set-nonblocking-callbacks.patch
  loop-change-queue-block-size-to-match-when-using-dio.patch
  nl80211-fix-null-pointer-dereference.patch
  mac80211-fix-txq-null-pointer-dereference.patch
  netfilter-nft_connlimit-disable-bh-on-garbage-collec.patch
  net-mscc-ocelot-add-missing-of_node_put-after-callin.patch
  net-dsa-rtl8366rb-add-missing-of_node_put-after-call.patch
  net-stmmac-xgmac-not-all-unicast-addresses-may-be-av.patch
  net-stmmac-dwmac4-always-update-the-mac-hash-filter.patch
  net-stmmac-correctly-take-timestamp-for-ptpv2.patch
  net-stmmac-do-not-stop-phy-if-wol-is-enabled.patch
  net-ag71xx-fix-mdio-subnode-support.patch
  risc-v-clear-load-reservations-while-restoring-hart-.patch
  riscv-fix-memblock-reservation-for-device-tree-blob.patch
  drm-amdgpu-fix-multiple-memory-leaks-in-acp_hw_init.patch
  drm-amd-display-memory-leak.patch
  mips-loongson-fix-the-link-time-qualifier-of-serial_.patch
  net-hisilicon-fix-usage-of-uninitialized-variable-in.patch
  net-stmmac-avoid-deadlock-on-suspend-resume.patch
  selftests-kvm-fix-libkvm-build-error.patch
  lib-textsearch-fix-escapes-in-example-code.patch
  s390-mm-fix-wunused-but-set-variable-warnings.patch
  r8152-set-macpassthru-in-reset_resume-callback.patch
  net-phy-allow-for-reset-line-to-be-tied-to-a-sleepy-.patch
  net-phy-fix-write-to-mii-ctrl1000-register.patch
  namespace-fix-namespace.pl-script-to-support-relativ.patch
  convert-filldir-64-from-__put_user-to-unsafe_put_use.patch
  elf-don-t-use-map_fixed_noreplace-for-elf-executable.patch

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
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

      Host 2:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ LTP lite
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ LTP: openposix test suite
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         ✅ storage: SCSI VPD
         ✅ stress: stress-ng
         🚧 ✅ POSIX pjd-fstest suites

  ppc64le:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ LTP lite
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ LTP: openposix test suite
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         🚧 ✅ POSIX pjd-fstest suites

      Host 2:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

  x86_64:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ LTP lite
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ LTP: openposix test suite
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ pciutils: sanity smoke test
         ✅ Usex - version 1.9-29
         ✅ storage: SCSI VPD
         ✅ stress: stress-ng
         🚧 ✅ POSIX pjd-fstest suites

      Host 2:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running are marked with ⏱. Reports for non-upstream kernels have
a Beaker recipe linked to next to each host.
