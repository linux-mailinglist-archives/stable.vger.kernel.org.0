Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873A8F77D7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 16:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfKKPgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 10:36:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50516 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726832AbfKKPgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 10:36:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573486598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qBXXNULBXajP2sAwAYLMh45t1y7qwkjKCQJVu0QzDB8=;
        b=OELsHeypb/st5PJK72rhJT/NXIPF+K+9ws7VpthE8x/SX9703VpEHrq+VqwLHqwX6974R0
        r/eX1XGOz7nCsgmZdJQfIj1mSbpal/RooO/RkMnsJXE62NGEGq47H+7fiRwZM1mzy6dF/t
        Hb7g+FrCgKdB3SKssJW1GGlZpjHPu2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-JCRKhuDyMtiQ1qlR3wPTIw-1; Mon, 11 Nov 2019 10:36:36 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17CCD800C61
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 15:36:36 +0000 (UTC)
Received: from [172.54.37.191] (cpt-1013.paas.prod.upshift.rdu2.redhat.com [10.0.19.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3FBF5D6A3;
        Mon, 11 Nov 2019 15:36:29 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.3
Date:   Mon, 11 Nov 2019 15:36:29 -0000
CC:     Milos Malik <mmalik@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Jakub Krysl <jkrysl@redhat.com>
Message-ID: <cki.C34AD886D0.GOVZS0HRY7@redhat.com>
X-Gitlab-Pipeline-ID: 278447
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/278447
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: JCRKhuDyMtiQ1qlR3wPTIw-1
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
            Commit: 81584694bb70 - Linux 5.3.10

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/278447

One or more kernel tests failed:

    ppc64le:
     =E2=9D=8C selinux-policy: serge-testsuite

    aarch64:
     =E2=9D=8C selinux-policy: serge-testsuite
     =E2=9D=8C lvm thinp sanity

    x86_64:
     =E2=9D=8C selinux-policy: serge-testsuite

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this messa=
ge.

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
  Commit: 81584694bb70 - Linux 5.3.10


We grabbed the 92daf91c1099 commit of the stable queue repository.

We then merged the patchset with `git am`:

  bonding-fix-state-transition-issue-in-link-monitoring.patch
  cdc-ncm-handle-incomplete-transfer-of-mtu.patch
  ipv4-fix-table-id-reference-in-fib_sync_down_addr.patch
  net-ethernet-octeon_mgmt-account-for-second-possible-vlan-header.patch
  net-fix-data-race-in-neigh_event_send.patch
  net-qualcomm-rmnet-fix-potential-uaf-when-unregistering.patch
  net-tls-fix-sk_msg-trim-on-fallback-to-copy-mode.patch
  net-usb-qmi_wwan-add-support-for-dw5821e-with-esim-support.patch
  nfc-fdp-fix-incorrect-free-object.patch
  nfc-netlink-fix-double-device-reference-drop.patch
  nfc-st21nfca-fix-double-free.patch
  qede-fix-null-pointer-deref-in-__qede_remove.patch
  net-mscc-ocelot-don-t-handle-netdev-events-for-other-netdevs.patch
  net-mscc-ocelot-fix-null-pointer-on-lag-slave-removal.patch
  net-tls-don-t-pay-attention-to-sk_write_pending-when-pushing-partial-reco=
rds.patch
  net-tls-add-a-tx-lock.patch
  selftests-tls-add-test-for-concurrent-recv-and-send.patch
  ipv6-fixes-rt6_probe-and-fib6_nh-last_probe-init.patch
  net-hns-fix-the-stray-netpoll-locks-causing-deadlock-in-napi-path.patch
  net-prevent-load-store-tearing-on-sk-sk_stamp.patch
  net-sched-prevent-duplicate-flower-rules-from-tcf_proto-destroy-race.patc=
h
  net-smc-fix-ethernet-interface-refcounting.patch
  vsock-virtio-fix-sock-refcnt-holding-during-the-shutdown.patch
  r8169-fix-page-read-in-r8168g_mdio_read.patch
  alsa-timer-fix-incorrectly-assigned-timer-instance.patch
  alsa-bebob-fix-to-detect-configured-source-of-sampling-clock-for-focusrit=
e-saffire-pro-i-o-series.patch
  alsa-hda-ca0132-fix-possible-workqueue-stall.patch
  mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch
  mm-memcontrol-fix-network-errors-from-failing-__gfp_atomic-charges.patch
  mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.pa=
tch
  mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap.patch
  mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch
  dump_stack-avoid-the-livelock-of-the-dump_lock.patch
  mm-slab-make-page_cgroup_ino-to-recognize-non-compound-slab-pages-properl=
y.patch
  btrfs-consider-system-chunk-array-size-for-new-system-chunks.patch
  btrfs-tree-checker-fix-wrong-check-on-max-devid.patch
  btrfs-save-i_size-to-avoid-double-evaluation-of-i_size_read-in-compress_f=
ile_range.patch
  tools-gpio-use-building_out_of_srctree-to-determine-srctree.patch
  pinctrl-intel-avoid-potential-glitches-if-pin-is-in-gpio-mode.patch
  perf-tools-fix-time-sorting.patch
  perf-map-use-zalloc-for-map_groups.patch
  drm-radeon-fix-si_enable_smc_cac-failed-issue.patch
  hid-wacom-generic-treat-serial-number-and-related-fields-as-unsigned.patc=
h
  mm-khugepaged-fix-might_sleep-warn-with-config_highpte-y.patch
  soundwire-depend-on-acpi.patch
  soundwire-depend-on-acpi-of.patch
  soundwire-bus-set-initial-value-to-port_status.patch
  blkcg-make-blkcg_print_stat-print-stats-only-for-online-blkgs.patch
  arm64-do-not-mask-out-pte_rdonly-in-pte_same.patch
  asoc-rsnd-dma-fix-ssi9-4-5-6-7-busif-dma-address.patch
  ceph-fix-use-after-free-in-__ceph_remove_cap.patch
  ceph-fix-rcu-case-handling-in-ceph_d_revalidate.patch
  ceph-add-missing-check-in-d_revalidate-snapdir-handling.patch
  ceph-don-t-try-to-handle-hashed-dentries-in-non-o_creat-atomic_open.patch
  ceph-don-t-allow-copy_file_range-when-stripe_count-1.patch
  iio-adc-stm32-adc-fix-stopping-dma.patch
  iio-imu-adis16480-make-sure-provided-frequency-is-positive.patch
  iio-imu-inv_mpu6050-fix-no-data-on-mpu6050.patch
  iio-srf04-fix-wrong-limitation-in-distance-measuring.patch
  arm-sunxi-fix-cpu-powerdown-on-a83t.patch
  arm-dts-imx6-logicpd-re-enable-snvs-power-key.patch
  cpufreq-intel_pstate-fix-invalid-epb-setting.patch
  clone3-validate-stack-arguments.patch
  netfilter-nf_tables-align-nft_expr-private-data-to-64-bit.patch
  netfilter-ipset-fix-an-error-code-in-ip_set_sockfn_get.patch
  intel_th-gth-fix-the-window-switching-sequence.patch
  intel_th-pci-add-comet-lake-pch-support.patch
  intel_th-pci-add-jasper-lake-pch-support.patch
  x86-dumpstack-64-don-t-evaluate-exception-stacks-before-setup.patch
  x86-apic-32-avoid-bogus-ldr-warnings.patch
  smb3-fix-persistent-handles-reconnect.patch
  can-usb_8dev-fix-use-after-free-on-disconnect.patch
  can-flexcan-disable-completely-the-ecc-mechanism.patch
  can-c_can-c_can_poll-only-read-status-register-after-status-irq.patch
  can-peak_usb-fix-a-potential-out-of-sync-while-decoding-packets.patch
  can-rx-offload-can_rx_offload_queue_sorted-fix-error-handling-avoid-skb-m=
em-leak.patch
  can-gs_usb-gs_can_open-prevent-memory-leak.patch
  can-dev-add-missing-of_node_put-after-calling-of_get_child_by_name.patch
  can-mcba_usb-fix-use-after-free-on-disconnect.patch
  can-peak_usb-fix-slab-info-leak.patch
  configfs-fix-a-deadlock-in-configfs_symlink.patch

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
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

    Host 2:
       =E2=9C=85 Boot test
       =E2=9D=8C selinux-policy: serge-testsuite
       =E2=9D=8C lvm thinp sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests

  ppc64le:
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
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

    Host 2:
       =E2=9C=85 Boot test
       =E2=9D=8C selinux-policy: serge-testsuite
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9D=8C selinux-policy: serge-testsuite
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
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
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 pciutils: sanity smoke test
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

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

