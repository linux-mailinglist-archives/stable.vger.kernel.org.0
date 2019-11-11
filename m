Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16472F80D7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 21:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKKUKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 15:10:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26842 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727133AbfKKUKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 15:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573503046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oxdj6hZUhW9f7JMrWRjQtCwt0HOlbNeWiG8RsEI5V0M=;
        b=Up11D3OlNgGfyv9AxMciSkgRmokplgoF4hDrkaXoLuDysE8h2qIXEDQdArrq+Q69UIcKRB
        igRc+ltZyhM4ROO4ZAadVAde/4fKXtCyhIWk7/vTf5e1a840VHpLknX/CcIA3oG8CMxWNK
        /JWsvm40pIYn2JwoSeE4xuyaLmUWRpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-IHma9AsqN-q65jdJ7tkcCA-1; Mon, 11 Nov 2019 15:10:44 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A1E9107ACC4
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 20:10:44 +0000 (UTC)
Received: from localhost.localdomain (ovpn-122-199.rdu2.redhat.com [10.10.122.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FC06100EBAC;
        Mon, 11 Nov 2019 20:10:38 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Stable_queue=3a_queue-5=2e3?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Jakub Krysl <jkrysl@redhat.com>, Milos Malik <mmalik@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
References: <cki.C34AD886D0.GOVZS0HRY7@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <8dbab9ad-3993-eeb5-13a7-c820c8f49426@redhat.com>
Date:   Mon, 11 Nov 2019 15:10:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <cki.C34AD886D0.GOVZS0HRY7@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: IHma9AsqN-q65jdJ7tkcCA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

See=20
https://lore.kernel.org/stable/120fa5fd-a82f-443e-156e-a9a11937a9ca@redhat.=
com/
for selinux-policy failures, there was also a panic on the mustang board=20
(aarch64) when
installing the dependencies for thinp sanity test:
https://artifacts.cki-project.org/pipelines/278447/logs/aarch64_host_2_cons=
ole.log

[ 1168.041811] restraintd[838]: ** Fetching task: 101902649 [/mnt/tests/git=
hub.com/CKI-project/tests-beaker/archive/master.zip/storage/lvm/thinp/sanit=
y]
...
[ 1265.060278] Unable to handle kernel write to read-only memory at virtual=
 address 0000300000000020
[ 1265.069118] Mem abort info:
[ 1265.071897]   ESR =3D 0x96000044
[ 1265.074936]   Exception class =3D DABT (current EL), IL =3D 32 bits
[ 1265.080825]   SET =3D 0, FnV =3D 0
[ 1265.083862]   EA =3D 0, S1PTW =3D 0
[ 1265.086985] Data abort info:
[ 1265.089849]   ISV =3D 0, ISS =3D 0x00000044
[ 1265.093663]   CM =3D 0, WnR =3D 1
[ 1265.096614] user pgtable: 4k pages, 48-bit VAs, pgdp=3D00000041e6436000
[ 1265.103023] [0000300000000020] pgd=3D0000000000000000
[ 1265.107878] Internal error: Oops: 96000044 [#1] SMP
[ 1265.112730] Modules linked in: sctp sunrpc vfat fat xgene_enet at803x md=
io_xgene xgene_hwmon xgene_edac xgene_rng mailbox_xgene_slimpro crct10dif_c=
e ip_tables xfs libcrc32c sdhci_of_arasan sdhci_pltfm i2c_xgene_slimpro sdh=
ci cqhci gpio_dwapb gpio_xgene_sb xhci_plat_hcd gpio_keys
[ 1265.137307] CPU: 3 PID: 454 Comm: kworker/3:1H Not tainted 5.3.10-b260a0=
8.cki #1
[ 1265.144666] Hardware name: AppliedMicro X-Gene Mustang Board/X-Gene Must=
ang Board, BIOS 3.06.25 Oct 17 2016
[ 1265.154366] Workqueue: kblockd blk_mq_run_work_fn
[ 1265.159048] pstate: 20400085 (nzCv daIf +PAN -UAO)
[ 1265.163816] pc : rb_erase+0x9c/0x3a8
[ 1265.167373] lr : bfq_idle_extract+0x58/0xc0
[ 1265.171534] sp : ffff000011d4bb60
[ 1265.174830] x29: ffff000011d4bb60 x28: ffff8001ef4ac100
[ 1265.180115] x27: ffff00001174dae8 x26: ffff000011727000
[ 1265.185399] x25: ffff8001fcface00 x24: 0000000000000030
[ 1265.190684] x23: ffff8001fcfaec00 x22: 0000000000000008
[ 1265.195968] x21: ffff8001fae05d50 x20: ffff8001b56b3010
[ 1265.201253] x19: ffff8001b56b3098 x18: 00000000fffffffa
[ 1265.206537] x17: 0000000000000000 x16: 0000000000000000
[ 1265.211821] x15: 0000000000000001 x14: ffffffffffffffff
[ 1265.217106] x13: ffff000011d4bc20 x12: ffff000011d4bc14
[ 1265.222390] x11: ffff000010f3f6d0 x10: ffff000011d4bbc0
[ 1265.227674] x9 : 00000000ffffffd8 x8 : 000000000000359a
[ 1265.232959] x7 : 0000000000000018 x6 : 0000000000000004
[ 1265.238243] x5 : 0000000000000000 x4 : 0000300000000020
[ 1265.243527] x3 : ffff000011d4bc19 x2 : 0000000000000000
[ 1265.248812] x1 : ffff8001fae05d58 x0 : ffff8001b56b3098
[ 1265.254096] Call trace:
[ 1265.256530]  rb_erase+0x9c/0x3a8
[ 1265.259741]  bfq_put_idle_entity+0x28/0x50
[ 1265.263816]  bfq_forget_idle+0x74/0x80
[ 1265.267545]  bfq_bfqq_served+0xb4/0x180
[ 1265.271361]  bfq_dispatch_request+0x184/0x6d8
[ 1265.275696]  blk_mq_do_dispatch_sched+0xc4/0x108
[ 1265.280290]  blk_mq_sched_dispatch_requests+0x114/0x190
[ 1265.285487]  __blk_mq_run_hw_queue+0x9c/0x128
[ 1265.289821]  blk_mq_run_work_fn+0x28/0x38
[ 1265.293810]  process_one_work+0x1bc/0x3e8
[ 1265.297798]  worker_thread+0x54/0x440
[ 1265.301441]  kthread+0x104/0x130
[ 1265.304653]  ret_from_fork+0x10/0x18
[ 1265.308211] Code: b2400042 f90000e2 d65f03c0 f9400002 (f9000082)
[ 1265.314275] ---[ end trace 3c2a926246d30ab0 ]---

On 11/11/19 10:36 AM, CKI Project wrote:
> Hello,
>
> We ran automated tests on a patchset that was proposed for merging into t=
his
> kernel tree. The patches were applied to:
>
>         Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux.git
>              Commit: 81584694bb70 - Linux 5.3.10
>
> The results of these automated tests are provided below.
>
>      Overall result: FAILED (see details below)
>               Merge: OK
>             Compile: OK
>               Tests: FAILED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>    https://artifacts.cki-project.org/pipelines/278447
>
> One or more kernel tests failed:
>
>      ppc64le:
>       =E2=9D=8C selinux-policy: serge-testsuite
>
>      aarch64:
>       =E2=9D=8C selinux-policy: serge-testsuite
>       =E2=9D=8C lvm thinp sanity
>
>      x86_64:
>       =E2=9D=8C selinux-policy: serge-testsuite
>
> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this mes=
sage.
>
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more effec=
tive.
>
>          ,-.   ,-.
>         ( C ) ( K )  Continuous
>          `-',-.`-'   Kernel
>            ( I )     Integration
>             `-'
> _________________________________________________________________________=
_____
>
> Merge testing
> -------------
>
> We cloned this repository and checked out the following commit:
>
>    Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>    Commit: 81584694bb70 - Linux 5.3.10
>
>
> We grabbed the 92daf91c1099 commit of the stable queue repository.
>
> We then merged the patchset with `git am`:
>
>    bonding-fix-state-transition-issue-in-link-monitoring.patch
>    cdc-ncm-handle-incomplete-transfer-of-mtu.patch
>    ipv4-fix-table-id-reference-in-fib_sync_down_addr.patch
>    net-ethernet-octeon_mgmt-account-for-second-possible-vlan-header.patch
>    net-fix-data-race-in-neigh_event_send.patch
>    net-qualcomm-rmnet-fix-potential-uaf-when-unregistering.patch
>    net-tls-fix-sk_msg-trim-on-fallback-to-copy-mode.patch
>    net-usb-qmi_wwan-add-support-for-dw5821e-with-esim-support.patch
>    nfc-fdp-fix-incorrect-free-object.patch
>    nfc-netlink-fix-double-device-reference-drop.patch
>    nfc-st21nfca-fix-double-free.patch
>    qede-fix-null-pointer-deref-in-__qede_remove.patch
>    net-mscc-ocelot-don-t-handle-netdev-events-for-other-netdevs.patch
>    net-mscc-ocelot-fix-null-pointer-on-lag-slave-removal.patch
>    net-tls-don-t-pay-attention-to-sk_write_pending-when-pushing-partial-r=
ecords.patch
>    net-tls-add-a-tx-lock.patch
>    selftests-tls-add-test-for-concurrent-recv-and-send.patch
>    ipv6-fixes-rt6_probe-and-fib6_nh-last_probe-init.patch
>    net-hns-fix-the-stray-netpoll-locks-causing-deadlock-in-napi-path.patc=
h
>    net-prevent-load-store-tearing-on-sk-sk_stamp.patch
>    net-sched-prevent-duplicate-flower-rules-from-tcf_proto-destroy-race.p=
atch
>    net-smc-fix-ethernet-interface-refcounting.patch
>    vsock-virtio-fix-sock-refcnt-holding-during-the-shutdown.patch
>    r8169-fix-page-read-in-r8168g_mdio_read.patch
>    alsa-timer-fix-incorrectly-assigned-timer-instance.patch
>    alsa-bebob-fix-to-detect-configured-source-of-sampling-clock-for-focus=
rite-saffire-pro-i-o-series.patch
>    alsa-hda-ca0132-fix-possible-workqueue-stall.patch
>    mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch
>    mm-memcontrol-fix-network-errors-from-failing-__gfp_atomic-charges.pat=
ch
>    mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes=
.patch
>    mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap.patch
>    mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch
>    dump_stack-avoid-the-livelock-of-the-dump_lock.patch
>    mm-slab-make-page_cgroup_ino-to-recognize-non-compound-slab-pages-prop=
erly.patch
>    btrfs-consider-system-chunk-array-size-for-new-system-chunks.patch
>    btrfs-tree-checker-fix-wrong-check-on-max-devid.patch
>    btrfs-save-i_size-to-avoid-double-evaluation-of-i_size_read-in-compres=
s_file_range.patch
>    tools-gpio-use-building_out_of_srctree-to-determine-srctree.patch
>    pinctrl-intel-avoid-potential-glitches-if-pin-is-in-gpio-mode.patch
>    perf-tools-fix-time-sorting.patch
>    perf-map-use-zalloc-for-map_groups.patch
>    drm-radeon-fix-si_enable_smc_cac-failed-issue.patch
>    hid-wacom-generic-treat-serial-number-and-related-fields-as-unsigned.p=
atch
>    mm-khugepaged-fix-might_sleep-warn-with-config_highpte-y.patch
>    soundwire-depend-on-acpi.patch
>    soundwire-depend-on-acpi-of.patch
>    soundwire-bus-set-initial-value-to-port_status.patch
>    blkcg-make-blkcg_print_stat-print-stats-only-for-online-blkgs.patch
>    arm64-do-not-mask-out-pte_rdonly-in-pte_same.patch
>    asoc-rsnd-dma-fix-ssi9-4-5-6-7-busif-dma-address.patch
>    ceph-fix-use-after-free-in-__ceph_remove_cap.patch
>    ceph-fix-rcu-case-handling-in-ceph_d_revalidate.patch
>    ceph-add-missing-check-in-d_revalidate-snapdir-handling.patch
>    ceph-don-t-try-to-handle-hashed-dentries-in-non-o_creat-atomic_open.pa=
tch
>    ceph-don-t-allow-copy_file_range-when-stripe_count-1.patch
>    iio-adc-stm32-adc-fix-stopping-dma.patch
>    iio-imu-adis16480-make-sure-provided-frequency-is-positive.patch
>    iio-imu-inv_mpu6050-fix-no-data-on-mpu6050.patch
>    iio-srf04-fix-wrong-limitation-in-distance-measuring.patch
>    arm-sunxi-fix-cpu-powerdown-on-a83t.patch
>    arm-dts-imx6-logicpd-re-enable-snvs-power-key.patch
>    cpufreq-intel_pstate-fix-invalid-epb-setting.patch
>    clone3-validate-stack-arguments.patch
>    netfilter-nf_tables-align-nft_expr-private-data-to-64-bit.patch
>    netfilter-ipset-fix-an-error-code-in-ip_set_sockfn_get.patch
>    intel_th-gth-fix-the-window-switching-sequence.patch
>    intel_th-pci-add-comet-lake-pch-support.patch
>    intel_th-pci-add-jasper-lake-pch-support.patch
>    x86-dumpstack-64-don-t-evaluate-exception-stacks-before-setup.patch
>    x86-apic-32-avoid-bogus-ldr-warnings.patch
>    smb3-fix-persistent-handles-reconnect.patch
>    can-usb_8dev-fix-use-after-free-on-disconnect.patch
>    can-flexcan-disable-completely-the-ecc-mechanism.patch
>    can-c_can-c_can_poll-only-read-status-register-after-status-irq.patch
>    can-peak_usb-fix-a-potential-out-of-sync-while-decoding-packets.patch
>    can-rx-offload-can_rx_offload_queue_sorted-fix-error-handling-avoid-sk=
b-mem-leak.patch
>    can-gs_usb-gs_can_open-prevent-memory-leak.patch
>    can-dev-add-missing-of_node_put-after-calling-of_get_child_by_name.pat=
ch
>    can-mcba_usb-fix-use-after-free-on-disconnect.patch
>    can-peak_usb-fix-slab-info-leak.patch
>    configfs-fix-a-deadlock-in-configfs_symlink.patch
>
> Compile testing
> ---------------
>
> We compiled the kernel for 3 architectures:
>
>      aarch64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>      ppc64le:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>      x86_64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>
>    aarch64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9D=8C selinux-policy: serge-testsuite
>         =E2=9D=8C lvm thinp sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>
>    ppc64le:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9D=8C selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>
>    x86_64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9D=8C selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 pciutils: sanity smoke test
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 Usex - version 1.9-29
>         =E2=9C=85 stress: stress-ng
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>
>    Test sources: https://github.com/CKI-project/tests-beaker
>      =F0=9F=92=9A Pull requests are welcome for new tests or improvements=
 to existing tests!
>
> Waived tests
> ------------
> If the test run included waived tests, they are marked with =F0=9F=9A=A7.=
 Such tests are
> executed but their results are not taken into account. Tests are waived w=
hen
> their results are not reliable enough, e.g. when they're just introduced =
or are
> being fixed.
>
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that haven'=
t
> finished running are marked with =E2=8F=B1. Reports for non-upstream kern=
els have
> a Beaker recipe linked to next to each host.
>

