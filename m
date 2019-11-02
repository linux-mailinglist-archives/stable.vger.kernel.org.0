Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286CAECE82
	for <lists+stable@lfdr.de>; Sat,  2 Nov 2019 12:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfKBLoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Nov 2019 07:44:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24627 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726163AbfKBLoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Nov 2019 07:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572695058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=o59kYf0ZCyLjrsiXPHo5U4Doyv/7+WWF6cEBEfL2ZJc=;
        b=Epb4j2d6VGVslh4s9+fS0p2kcQSfGDF8m7D5I3r5OGw4EQEzoh2r1zayBQTZXBWpLBwJLh
        OcvbsNQt7pW2uW9Jb8KW3kQrvwy0YfczRsb3zA06N6RRZLSixqFut+TZjpOCVD2i0bo/V4
        +E20dDPVSheuqymC3Z/lKeJ6nvKQ7cQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-2yN1LigSMO613loitBZtFA-1; Sat, 02 Nov 2019 07:44:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92EB0801E7D
        for <stable@vger.kernel.org>; Sat,  2 Nov 2019 11:44:15 +0000 (UTC)
Received: from [172.54.37.191] (cpt-1013.paas.prod.upshift.rdu2.redhat.com [10.0.19.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 883FA60878;
        Sat,  2 Nov 2019 11:44:12 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Date:   Sat, 02 Nov 2019 11:44:12 -0000
CC:     Zhaojuan Guo <zguo@redhat.com>
Message-ID: <cki.2F29B05F7E.U2HIGWY288@redhat.com>
X-Gitlab-Pipeline-ID: 261488
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/261488
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 2yN1LigSMO613loitBZtFA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into thi=
s
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux.git
            Commit: 95180e47e77a - Linux 5.3.8

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/261488

Please reply to this email if you have any questions about the tests that w=
e
ran or if you have any suggestions on how to make future tests more effecti=
ve.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
___________________________________________________________________________=
___

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 95180e47e77a - Linux 5.3.8


We grabbed the ae4b15aa39ba commit of the stable queue repository.

We then merged the patchset with `git am`:

  io_uring-fix-up-o_nonblock-handling-for-sockets.patch
  dm-snapshot-introduce-account_start_copy-and-account.patch
  dm-snapshot-rework-cow-throttling-to-fix-deadlock.patch
  btrfs-fix-inode-cache-block-reserve-leak-on-failure-.patch
  btrfs-qgroup-always-free-prealloc-meta-reserve-in-bt.patch
  iio-adc-meson_saradc-fix-memory-allocation-order.patch
  iio-fix-center-temperature-of-bmc150-accel-core.patch
  libsubcmd-make-_fortify_source-defines-dependent-on-.patch
  perf-tests-avoid-raising-segv-using-an-obvious-null-.patch
  perf-map-fix-overlapped-map-handling.patch
  perf-script-brstackinsn-fix-recovery-from-lbr-binary.patch
  perf-jevents-fix-period-for-intel-fixed-counters.patch
  perf-tools-propagate-get_cpuid-error.patch
  perf-annotate-propagate-perf_env__arch-error.patch
  perf-annotate-fix-the-signedness-of-failure-returns.patch
  perf-annotate-propagate-the-symbol__annotate-error-r.patch
  perf-annotate-fix-arch-specific-init-failure-errors.patch
  perf-annotate-return-appropriate-error-code-for-allo.patch
  perf-annotate-don-t-return-1-for-error-when-doing-bp.patch
  staging-rtl8188eu-fix-null-dereference-when-kzalloc-.patch
  rdma-siw-fix-serialization-issue-in-write_space.patch
  rdma-hfi1-prevent-memory-leak-in-sdma_init.patch
  rdma-iw_cxgb4-fix-srq-access-from-dump_qp.patch
  rdma-iwcm-fix-a-lock-inversion-issue.patch
  hid-hyperv-use-in-place-iterator-api-in-the-channel-.patch
  kselftest-exclude-failed-targets-from-runlist.patch
  selftests-kselftest-runner.sh-add-45-second-timeout-.patch
  nfs-fix-nfsi-nrequests-count-error-on-nfs_inode_remo.patch
  arm64-cpufeature-effectively-expose-frint-capability.patch
  arm64-fix-incorrect-irqflag-restore-for-priority-mas.patch
  arm64-ftrace-ensure-synchronisation-in-plt-setup-for.patch
  tty-serial-owl-fix-the-link-time-qualifier-of-owl_ua.patch
  tty-serial-rda-fix-the-link-time-qualifier-of-rda_ua.patch
  serial-sifive-select-serial_earlycon.patch
  tty-n_hdlc-fix-build-on-sparc.patch
  misc-fastrpc-prevent-memory-leak-in-fastrpc_dma_buf_.patch
  rdma-core-fix-an-error-handling-path-in-res_get_comm.patch
  rdma-cm-fix-memory-leak-in-cm_add-remove_one.patch
  rdma-nldev-reshuffle-the-code-to-avoid-need-to-rebin.patch
  rdma-mlx5-do-not-allow-rereg-of-a-odp-mr.patch
  rdma-mlx5-order-num_pending_prefetch-properly-with-s.patch
  rdma-mlx5-add-missing-synchronize_srcu-for-mw-cases.patch
  gpio-max77620-use-correct-unit-for-debounce-times.patch
  fs-cifs-mute-wunused-const-variable-message.patch
  arm64-vdso32-fix-broken-compat-vdso-build-warnings.patch
  arm64-vdso32-detect-binutils-support-for-dmb-ishld.patch
  serial-mctrl_gpio-check-for-null-pointer.patch
  serial-8250_omap-fix-gpio-check-for-auto-rts-cts.patch
  arm64-default-to-building-compat-vdso-with-clang-whe.patch
  arm64-vdso32-don-t-use-kbuild_cppflags-unconditional.patch
  efi-cper-fix-endianness-of-pcie-class-code.patch
  efi-x86-do-not-clean-dummy-variable-in-kexec-path.patch
  mips-include-mark-__cmpxchg-as-__always_inline.patch
  riscv-avoid-kernel-hangs-when-trapped-in-bug.patch
  riscv-avoid-sending-a-sigtrap-to-a-user-thread-trapp.patch
  riscv-correct-the-handling-of-unexpected-ebreak-in-d.patch
  x86-xen-return-from-panic-notifier.patch
  ocfs2-clear-zero-in-unaligned-direct-io.patch
  fs-ocfs2-fix-possible-null-pointer-dereferences-in-o.patch
  fs-ocfs2-fix-a-possible-null-pointer-dereference-in-.patch
  fs-ocfs2-fix-a-possible-null-pointer-dereference-in-.patch
  btrfs-silence-maybe-uninitialized-warning-in-clone_r.patch
  arm64-armv8_deprecated-checking-return-value-for-mem.patch
  x86-cpu-add-comet-lake-to-the-intel-cpu-models-heade.patch
  sched-fair-scale-bandwidth-quota-and-period-without-.patch
  sched-vtime-fix-guest-system-mis-accounting-on-task-.patch
  perf-core-rework-memory-accounting-in-perf_mmap.patch
  perf-core-fix-corner-case-in-perf_rotate_context.patch
  perf-x86-amd-change-fix-nmi-latency-mitigation-to-us.patch
  drm-amdgpu-fix-memory-leak.patch
  iio-imu-adis16400-release-allocated-memory-on-failur.patch
  iio-imu-adis16400-fix-memory-leak.patch
  iio-imu-st_lsm6dsx-fix-waitime-for-st_lsm6dsx-i2c-co.patch
  mips-include-mark-__xchg-as-__always_inline.patch
  mips-fw-sni-fix-out-of-bounds-init-of-o32-stack.patch
  s390-cio-fix-virtio-ccw-dma-without-pv.patch
  virt-vbox-fix-memory-leak-in-hgcm_call_preprocess_li.patch
  nbd-fix-possible-sysfs-duplicate-warning.patch
  nfsv4-fix-leak-of-clp-cl_acceptor-string.patch
  sunrpc-fix-race-to-sk_err-after-xs_error_report.patch
  s390-uaccess-avoid-false-positive-compiler-warnings.patch
  tracing-initialize-iter-seq-after-zeroing-in-tracing.patch
  perf-annotate-fix-multiple-memory-and-file-descripto.patch
  perf-aux-fix-tracking-of-auxiliary-trace-buffer-allo.patch
  usb-legousbtower-fix-a-signedness-bug-in-tower_probe.patch
  nbd-verify-socket-is-supported-during-setup.patch
  arm64-dts-qcom-add-lenovo-miix-630.patch
  arm64-dts-qcom-add-hp-envy-x2.patch
  arm64-dts-qcom-add-asus-novago-tp370ql.patch
  rtw88-fix-misuse-of-genmask-macro.patch
  s390-pci-fix-msi-message-data.patch
  thunderbolt-correct-path-indices-for-pcie-tunnel.patch
  thunderbolt-use-32-bit-writes-when-writing-ring-prod.patch
  ath6kl-fix-a-null-ptr-deref-bug-in-ath6kl_usb_alloc_.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 xfstests: xfs
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 storage: dm/common

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 xfstests: xfs
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 storage: dm/common

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 pciutils: sanity smoke test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 stress: stress-ng
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 storage: dm/common

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 xfstests: xfs
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

    Host 3:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9D=8C /kernel/infiniband/env_setup
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 /kernel/infiniband/sanity

    Host 4:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9D=8C /kernel/infiniband/env_setup
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 /kernel/infiniband/sanity

    Host 5:
       =E2=8F=B1  Boot test
       =E2=8F=B1  /kernel/infiniband/env_setup
       =E2=8F=B1  /kernel/infiniband/sanity

    Host 6:
       =E2=8F=B1  Boot test
       =E2=8F=B1  /kernel/infiniband/env_setup
       =E2=8F=B1  /kernel/infiniband/sanity

  Test sources: https://github.com/CKI-project/tests-beaker
    =F0=9F=92=9A Pull requests are welcome for new tests or improvements to=
 existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with =F0=9F=9A=A7. S=
uch tests are
executed but their results are not taken into account. Tests are waived whe=
n
their results are not reliable enough, e.g. when they're just introduced or=
 are
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running are marked with =E2=8F=B1. Reports for non-upstream kernel=
s have
a Beaker recipe linked to next to each host.

