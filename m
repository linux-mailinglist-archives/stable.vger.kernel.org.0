Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121A4F8185
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 21:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKKUrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 15:47:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40917 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726927AbfKKUrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 15:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573505272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6NJwVi2NI/sBw6trNj+HTVN2CAuYE6eWBR8JVVFs2RM=;
        b=TzAgq8O3lYlaf+6rcGI3KcOo/j7oiebGgd31U7pmICOvHPcSkTQyp02KF+urM2NNQkCvkg
        zl31vZ9dh7PD8kluIBWoRypwJRieeLRe3AW9WdNjsrijTuXAUfR8saoAutsSYPTy7YVisI
        c81tRh/C/myzQ2MMIzehtd5VsNyXMh0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-m8y-Y2yXM0eEpuX5pvgZ2Q-1; Mon, 11 Nov 2019 15:47:51 -0500
Received: by mail-qk1-f200.google.com with SMTP id k145so8657995qke.11
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 12:47:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BI+fDkOkjC0FoeMpKBXgUh0AWpXMlMsvE5XGg0bfzNQ=;
        b=UjQO/YEux0OSFWiN2gaZ5Pf1SrA+4KS+ti8jTRokMuL1JkyucoTIsw1FlHb2AdEvpg
         U2kDufNkIyP190pmtedBf4il0MxPwourL+auUSGu3vmyGcfJeWAyp45NKPsUQ/Rukm2n
         b1ahDdcRlT5VYvFspAUlQSSry40GXDcTIIAieVuJXcb58BqlGlBQMOHWR+lsew8irZXP
         x5xxFRHHQSjKMyWQhrBtrnORKI4A+1LdPERiKm/DdE8jmDs5Lzg9uey6rDkR20pOPS9C
         o6qrmnVUzAGs4KLHb8dlA9VSx7McsAqTdRDUESg6fcRhcFPAzTzVvFj7EPUJmMPV2b0G
         e3TA==
X-Gm-Message-State: APjAAAUWHhXzET1MwtANcyCHGAAywnlAme3I+oh3hkJWoj7ZIJ6hHqpd
        z4tL9yuDjUX+Hdkwk13oxXBVd5Vw6ItVbmG25CINY0bsXpbiesQKX+TL9TzyiyE+PWF0rhXlBF5
        yP/0Z+F/VPszCYrVk
X-Received: by 2002:ac8:25ac:: with SMTP id e41mr28270414qte.149.1573505270584;
        Mon, 11 Nov 2019 12:47:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJIe9FnTZQTn6SXrbb0hlGZRHLvFpny1fB27EGWRX0wGO511oEcyxLcA8tnBoSgj0r61bmHQ==
X-Received: by 2002:ac8:25ac:: with SMTP id e41mr28270371qte.149.1573505270075;
        Mon, 11 Nov 2019 12:47:50 -0800 (PST)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id h44sm12380931qtc.1.2019.11.11.12.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 12:47:49 -0800 (PST)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Stable_queue=3a_queue-5=2e3?=
To:     Rachel Sibley <rasibley@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Jakub Krysl <jkrysl@redhat.com>, Milos Malik <mmalik@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
References: <cki.C34AD886D0.GOVZS0HRY7@redhat.com>
 <8dbab9ad-3993-eeb5-13a7-c820c8f49426@redhat.com>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <d0d410b5-11b9-6264-dc6f-194adb1916ac@redhat.com>
Date:   Mon, 11 Nov 2019 15:47:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8dbab9ad-3993-eeb5-13a7-c820c8f49426@redhat.com>
Content-Language: en-US
X-MC-Unique: m8y-Y2yXM0eEpuX5pvgZ2Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/19 3:10 PM, Rachel Sibley wrote:
> See https://lore.kernel.org/stable/120fa5fd-a82f-443e-156e-a9a11937a9ca@r=
edhat.com/
> for selinux-policy failures, there was also a panic on the mustang board =
(aarch64) when
> installing the dependencies for thinp sanity test:
> https://artifacts.cki-project.org/pipelines/278447/logs/aarch64_host_2_co=
nsole.log
>=20
> [ 1168.041811] restraintd[838]: ** Fetching task: 101902649 [/mnt/tests/g=
ithub.com/CKI-project/tests-beaker/archive/master.zip/storage/lvm/thinp/san=
ity]
> ...
> [ 1265.060278] Unable to handle kernel write to read-only memory at virtu=
al address 0000300000000020
> [ 1265.069118] Mem abort info:
> [ 1265.071897]=C2=A0=C2=A0 ESR =3D 0x96000044
> [ 1265.074936]=C2=A0=C2=A0 Exception class =3D DABT (current EL), IL =3D =
32 bits
> [ 1265.080825]=C2=A0=C2=A0 SET =3D 0, FnV =3D 0
> [ 1265.083862]=C2=A0=C2=A0 EA =3D 0, S1PTW =3D 0
> [ 1265.086985] Data abort info:
> [ 1265.089849]=C2=A0=C2=A0 ISV =3D 0, ISS =3D 0x00000044
> [ 1265.093663]=C2=A0=C2=A0 CM =3D 0, WnR =3D 1
> [ 1265.096614] user pgtable: 4k pages, 48-bit VAs, pgdp=3D00000041e643600=
0
> [ 1265.103023] [0000300000000020] pgd=3D0000000000000000
> [ 1265.107878] Internal error: Oops: 96000044 [#1] SMP
> [ 1265.112730] Modules linked in: sctp sunrpc vfat fat xgene_enet at803x =
mdio_xgene xgene_hwmon xgene_edac xgene_rng mailbox_xgene_slimpro crct10dif=
_ce ip_tables xfs libcrc32c sdhci_of_arasan sdhci_pltfm i2c_xgene_slimpro s=
dhci cqhci gpio_dwapb gpio_xgene_sb xhci_plat_hcd gpio_keys
> [ 1265.137307] CPU: 3 PID: 454 Comm: kworker/3:1H Not tainted 5.3.10-b260=
a08.cki #1
> [ 1265.144666] Hardware name: AppliedMicro X-Gene Mustang Board/X-Gene Mu=
stang Board, BIOS 3.06.25 Oct 17 2016
> [ 1265.154366] Workqueue: kblockd blk_mq_run_work_fn
> [ 1265.159048] pstate: 20400085 (nzCv daIf +PAN -UAO)
> [ 1265.163816] pc : rb_erase+0x9c/0x3a8
> [ 1265.167373] lr : bfq_idle_extract+0x58/0xc0
> [ 1265.171534] sp : ffff000011d4bb60
> [ 1265.174830] x29: ffff000011d4bb60 x28: ffff8001ef4ac100
> [ 1265.180115] x27: ffff00001174dae8 x26: ffff000011727000
> [ 1265.185399] x25: ffff8001fcface00 x24: 0000000000000030
> [ 1265.190684] x23: ffff8001fcfaec00 x22: 0000000000000008
> [ 1265.195968] x21: ffff8001fae05d50 x20: ffff8001b56b3010
> [ 1265.201253] x19: ffff8001b56b3098 x18: 00000000fffffffa
> [ 1265.206537] x17: 0000000000000000 x16: 0000000000000000
> [ 1265.211821] x15: 0000000000000001 x14: ffffffffffffffff
> [ 1265.217106] x13: ffff000011d4bc20 x12: ffff000011d4bc14
> [ 1265.222390] x11: ffff000010f3f6d0 x10: ffff000011d4bbc0
> [ 1265.227674] x9 : 00000000ffffffd8 x8 : 000000000000359a
> [ 1265.232959] x7 : 0000000000000018 x6 : 0000000000000004
> [ 1265.238243] x5 : 0000000000000000 x4 : 0000300000000020
> [ 1265.243527] x3 : ffff000011d4bc19 x2 : 0000000000000000
> [ 1265.248812] x1 : ffff8001fae05d58 x0 : ffff8001b56b3098
> [ 1265.254096] Call trace:
> [ 1265.256530]=C2=A0 rb_erase+0x9c/0x3a8
> [ 1265.259741]=C2=A0 bfq_put_idle_entity+0x28/0x50
> [ 1265.263816]=C2=A0 bfq_forget_idle+0x74/0x80
> [ 1265.267545]=C2=A0 bfq_bfqq_served+0xb4/0x180
> [ 1265.271361]=C2=A0 bfq_dispatch_request+0x184/0x6d8
> [ 1265.275696]=C2=A0 blk_mq_do_dispatch_sched+0xc4/0x108
> [ 1265.280290]=C2=A0 blk_mq_sched_dispatch_requests+0x114/0x190
> [ 1265.285487]=C2=A0 __blk_mq_run_hw_queue+0x9c/0x128
> [ 1265.289821]=C2=A0 blk_mq_run_work_fn+0x28/0x38
> [ 1265.293810]=C2=A0 process_one_work+0x1bc/0x3e8
> [ 1265.297798]=C2=A0 worker_thread+0x54/0x440
> [ 1265.301441]=C2=A0 kthread+0x104/0x130
> [ 1265.304653]=C2=A0 ret_from_fork+0x10/0x18
> [ 1265.308211] Code: b2400042 f90000e2 d65f03c0 f9400002 (f9000082)
> [ 1265.314275] ---[ end trace 3c2a926246d30ab0 ]---
>=20

The panic looks like another issue we've been tracking in Fedora
https://bugzilla.redhat.com/show_bug.cgi?id=3D1767539
The bfq maintainer has given a possible fix.

> On 11/11/19 10:36 AM, CKI Project wrote:
>> Hello,
>>
>> We ran automated tests on a patchset that was proposed for merging into =
this
>> kernel tree. The patches were applied to:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Kernel repo: https://git.kern=
el.org/pub/scm/linux/kernel/git/stable/linux.git
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 Commit: 81584694bb70 - Linux 5.3.10
>>
>> The results of these automated tests are provided below.
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 Overall result: FAILED (see details below)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 Merge: OK
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Compi=
le: OK
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 Tests: FAILED
>>
>> All kernel binaries, config files, and logs are available for download h=
ere:
>>
>> =C2=A0=C2=A0 https://artifacts.cki-project.org/pipelines/278447
>>
>> One or more kernel tests failed:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 ppc64le:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9D=8C selinux-policy: serge-testsuite
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 aarch64:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9D=8C selinux-policy: serge-testsuite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9D=8C lvm thinp sanity
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 x86_64:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9D=8C selinux-policy: serge-testsuite
>>
>> We hope that these logs can help you find the problem quickly. For the f=
ull
>> detail on our testing procedures, please scroll to the bottom of this me=
ssage.
>>
>> Please reply to this email if you have any questions about the tests tha=
t we
>> ran or if you have any suggestions on how to make future tests more effe=
ctive.
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ,-.=C2=A0=C2=A0 ,-.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ( C ) ( K )=C2=A0 Continuous
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 `-',-.`-'=C2=A0=C2=A0 K=
ernel
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ( I )=C2=A0=
=C2=A0=C2=A0=C2=A0 Integration
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 `-'
>> ________________________________________________________________________=
______
>>
>> Merge testing
>> -------------
>>
>> We cloned this repository and checked out the following commit:
>>
>> =C2=A0=C2=A0 Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stabl=
e/linux.git
>> =C2=A0=C2=A0 Commit: 81584694bb70 - Linux 5.3.10
>>
>>
>> We grabbed the 92daf91c1099 commit of the stable queue repository.
>>
>> We then merged the patchset with `git am`:
>>
>> =C2=A0=C2=A0 bonding-fix-state-transition-issue-in-link-monitoring.patch
>> =C2=A0=C2=A0 cdc-ncm-handle-incomplete-transfer-of-mtu.patch
>> =C2=A0=C2=A0 ipv4-fix-table-id-reference-in-fib_sync_down_addr.patch
>> =C2=A0=C2=A0 net-ethernet-octeon_mgmt-account-for-second-possible-vlan-h=
eader.patch
>> =C2=A0=C2=A0 net-fix-data-race-in-neigh_event_send.patch
>> =C2=A0=C2=A0 net-qualcomm-rmnet-fix-potential-uaf-when-unregistering.pat=
ch
>> =C2=A0=C2=A0 net-tls-fix-sk_msg-trim-on-fallback-to-copy-mode.patch
>> =C2=A0=C2=A0 net-usb-qmi_wwan-add-support-for-dw5821e-with-esim-support.=
patch
>> =C2=A0=C2=A0 nfc-fdp-fix-incorrect-free-object.patch
>> =C2=A0=C2=A0 nfc-netlink-fix-double-device-reference-drop.patch
>> =C2=A0=C2=A0 nfc-st21nfca-fix-double-free.patch
>> =C2=A0=C2=A0 qede-fix-null-pointer-deref-in-__qede_remove.patch
>> =C2=A0=C2=A0 net-mscc-ocelot-don-t-handle-netdev-events-for-other-netdev=
s.patch
>> =C2=A0=C2=A0 net-mscc-ocelot-fix-null-pointer-on-lag-slave-removal.patch
>> =C2=A0=C2=A0 net-tls-don-t-pay-attention-to-sk_write_pending-when-pushin=
g-partial-records.patch
>> =C2=A0=C2=A0 net-tls-add-a-tx-lock.patch
>> =C2=A0=C2=A0 selftests-tls-add-test-for-concurrent-recv-and-send.patch
>> =C2=A0=C2=A0 ipv6-fixes-rt6_probe-and-fib6_nh-last_probe-init.patch
>> =C2=A0=C2=A0 net-hns-fix-the-stray-netpoll-locks-causing-deadlock-in-nap=
i-path.patch
>> =C2=A0=C2=A0 net-prevent-load-store-tearing-on-sk-sk_stamp.patch
>> =C2=A0=C2=A0 net-sched-prevent-duplicate-flower-rules-from-tcf_proto-des=
troy-race.patch
>> =C2=A0=C2=A0 net-smc-fix-ethernet-interface-refcounting.patch
>> =C2=A0=C2=A0 vsock-virtio-fix-sock-refcnt-holding-during-the-shutdown.pa=
tch
>> =C2=A0=C2=A0 r8169-fix-page-read-in-r8168g_mdio_read.patch
>> =C2=A0=C2=A0 alsa-timer-fix-incorrectly-assigned-timer-instance.patch
>> =C2=A0=C2=A0 alsa-bebob-fix-to-detect-configured-source-of-sampling-cloc=
k-for-focusrite-saffire-pro-i-o-series.patch
>> =C2=A0=C2=A0 alsa-hda-ca0132-fix-possible-workqueue-stall.patch
>> =C2=A0=C2=A0 mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patc=
h
>> =C2=A0=C2=A0 mm-memcontrol-fix-network-errors-from-failing-__gfp_atomic-=
charges.patch
>> =C2=A0=C2=A0 mm-meminit-recalculate-pcpu-batch-and-high-limits-after-ini=
t-completes.patch
>> =C2=A0=C2=A0 mm-thp-handle-page-cache-thp-correctly-in-pagetranscompound=
map.patch
>> =C2=A0=C2=A0 mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch
>> =C2=A0=C2=A0 dump_stack-avoid-the-livelock-of-the-dump_lock.patch
>> =C2=A0=C2=A0 mm-slab-make-page_cgroup_ino-to-recognize-non-compound-slab=
-pages-properly.patch
>> =C2=A0=C2=A0 btrfs-consider-system-chunk-array-size-for-new-system-chunk=
s.patch
>> =C2=A0=C2=A0 btrfs-tree-checker-fix-wrong-check-on-max-devid.patch
>> =C2=A0=C2=A0 btrfs-save-i_size-to-avoid-double-evaluation-of-i_size_read=
-in-compress_file_range.patch
>> =C2=A0=C2=A0 tools-gpio-use-building_out_of_srctree-to-determine-srctree=
.patch
>> =C2=A0=C2=A0 pinctrl-intel-avoid-potential-glitches-if-pin-is-in-gpio-mo=
de.patch
>> =C2=A0=C2=A0 perf-tools-fix-time-sorting.patch
>> =C2=A0=C2=A0 perf-map-use-zalloc-for-map_groups.patch
>> =C2=A0=C2=A0 drm-radeon-fix-si_enable_smc_cac-failed-issue.patch
>> =C2=A0=C2=A0 hid-wacom-generic-treat-serial-number-and-related-fields-as=
-unsigned.patch
>> =C2=A0=C2=A0 mm-khugepaged-fix-might_sleep-warn-with-config_highpte-y.pa=
tch
>> =C2=A0=C2=A0 soundwire-depend-on-acpi.patch
>> =C2=A0=C2=A0 soundwire-depend-on-acpi-of.patch
>> =C2=A0=C2=A0 soundwire-bus-set-initial-value-to-port_status.patch
>> =C2=A0=C2=A0 blkcg-make-blkcg_print_stat-print-stats-only-for-online-blk=
gs.patch
>> =C2=A0=C2=A0 arm64-do-not-mask-out-pte_rdonly-in-pte_same.patch
>> =C2=A0=C2=A0 asoc-rsnd-dma-fix-ssi9-4-5-6-7-busif-dma-address.patch
>> =C2=A0=C2=A0 ceph-fix-use-after-free-in-__ceph_remove_cap.patch
>> =C2=A0=C2=A0 ceph-fix-rcu-case-handling-in-ceph_d_revalidate.patch
>> =C2=A0=C2=A0 ceph-add-missing-check-in-d_revalidate-snapdir-handling.pat=
ch
>> =C2=A0=C2=A0 ceph-don-t-try-to-handle-hashed-dentries-in-non-o_creat-ato=
mic_open.patch
>> =C2=A0=C2=A0 ceph-don-t-allow-copy_file_range-when-stripe_count-1.patch
>> =C2=A0=C2=A0 iio-adc-stm32-adc-fix-stopping-dma.patch
>> =C2=A0=C2=A0 iio-imu-adis16480-make-sure-provided-frequency-is-positive.=
patch
>> =C2=A0=C2=A0 iio-imu-inv_mpu6050-fix-no-data-on-mpu6050.patch
>> =C2=A0=C2=A0 iio-srf04-fix-wrong-limitation-in-distance-measuring.patch
>> =C2=A0=C2=A0 arm-sunxi-fix-cpu-powerdown-on-a83t.patch
>> =C2=A0=C2=A0 arm-dts-imx6-logicpd-re-enable-snvs-power-key.patch
>> =C2=A0=C2=A0 cpufreq-intel_pstate-fix-invalid-epb-setting.patch
>> =C2=A0=C2=A0 clone3-validate-stack-arguments.patch
>> =C2=A0=C2=A0 netfilter-nf_tables-align-nft_expr-private-data-to-64-bit.p=
atch
>> =C2=A0=C2=A0 netfilter-ipset-fix-an-error-code-in-ip_set_sockfn_get.patc=
h
>> =C2=A0=C2=A0 intel_th-gth-fix-the-window-switching-sequence.patch
>> =C2=A0=C2=A0 intel_th-pci-add-comet-lake-pch-support.patch
>> =C2=A0=C2=A0 intel_th-pci-add-jasper-lake-pch-support.patch
>> =C2=A0=C2=A0 x86-dumpstack-64-don-t-evaluate-exception-stacks-before-set=
up.patch
>> =C2=A0=C2=A0 x86-apic-32-avoid-bogus-ldr-warnings.patch
>> =C2=A0=C2=A0 smb3-fix-persistent-handles-reconnect.patch
>> =C2=A0=C2=A0 can-usb_8dev-fix-use-after-free-on-disconnect.patch
>> =C2=A0=C2=A0 can-flexcan-disable-completely-the-ecc-mechanism.patch
>> =C2=A0=C2=A0 can-c_can-c_can_poll-only-read-status-register-after-status=
-irq.patch
>> =C2=A0=C2=A0 can-peak_usb-fix-a-potential-out-of-sync-while-decoding-pac=
kets.patch
>> =C2=A0=C2=A0 can-rx-offload-can_rx_offload_queue_sorted-fix-error-handli=
ng-avoid-skb-mem-leak.patch
>> =C2=A0=C2=A0 can-gs_usb-gs_can_open-prevent-memory-leak.patch
>> =C2=A0=C2=A0 can-dev-add-missing-of_node_put-after-calling-of_get_child_=
by_name.patch
>> =C2=A0=C2=A0 can-mcba_usb-fix-use-after-free-on-disconnect.patch
>> =C2=A0=C2=A0 can-peak_usb-fix-slab-info-leak.patch
>> =C2=A0=C2=A0 configfs-fix-a-deadlock-in-configfs_symlink.patch
>>
>> Compile testing
>> ---------------
>>
>> We compiled the kernel for 3 architectures:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 aarch64:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 make options: -j30 INSTALL_MOD_STRI=
P=3D1 targz-pkg
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 ppc64le:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 make options: -j30 INSTALL_MOD_STRI=
P=3D1 targz-pkg
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 x86_64:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 make options: -j30 INSTALL_MOD_STRI=
P=3D1 targz-pkg
>>
>>
>> Hardware testing
>> ----------------
>> We booted each kernel and ran the following tests:
>>
>> =C2=A0=C2=A0 aarch64:
>> =C2=A0=C2=A0=C2=A0=C2=A0 Host 1:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Boot test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Podman system integ=
ration test (as root)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Podman system integ=
ration test (as user)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 LTP lite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Loopdev Sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 jvm test suite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 AMTU (Abstract Mach=
ine Test Utility)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 LTP: openposix test=
 suite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Ethernet drivers sa=
nity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking socket: =
fuzz
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route: p=
mtu
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route_fu=
nc: local
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route_fu=
nc: forward
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 audit: audit testsu=
ite test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 httpd: mod_ssl smok=
e sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 iotop: sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 tuned: tune-process=
es-through-perf
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 ALSA PCM loopback t=
est
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 ALSA Control (mixer=
) Userspace Element test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Usex - version 1.9-=
29
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9C=85 CIFS C=
onnectathon
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9C=85 POSIX =
pjd-fstest suites
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 Host 2:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Boot test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9D=8C selinux-policy: ser=
ge-testsuite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9D=8C lvm thinp sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9A=A1=E2=9A=A1=E2=9A=A1 s=
torage: software RAID testing
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9A=A1=E2=9A=
=A1=E2=9A=A1 Storage blktests
>>
>> =C2=A0=C2=A0 ppc64le:
>> =C2=A0=C2=A0=C2=A0=C2=A0 Host 1:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Boot test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Podman system integ=
ration test (as root)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Podman system integ=
ration test (as user)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 LTP lite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Loopdev Sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 jvm test suite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 AMTU (Abstract Mach=
ine Test Utility)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 LTP: openposix test=
 suite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Ethernet drivers sa=
nity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking socket: =
fuzz
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route: p=
mtu
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route_fu=
nc: local
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route_fu=
nc: forward
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 audit: audit testsu=
ite test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 httpd: mod_ssl smok=
e sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 iotop: sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 tuned: tune-process=
es-through-perf
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 ALSA PCM loopback t=
est
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 ALSA Control (mixer=
) Userspace Element test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Usex - version 1.9-=
29
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9C=85 CIFS C=
onnectathon
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9C=85 POSIX =
pjd-fstest suites
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 Host 2:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Boot test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9D=8C selinux-policy: ser=
ge-testsuite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 lvm thinp sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 storage: software R=
AID testing
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9C=85 Storag=
e blktests
>>
>> =C2=A0=C2=A0 x86_64:
>> =C2=A0=C2=A0=C2=A0=C2=A0 Host 1:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Boot test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9D=8C selinux-policy: ser=
ge-testsuite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 lvm thinp sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 storage: software R=
AID testing
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9C=85 Storag=
e blktests
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 Host 2:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Boot test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Podman system integ=
ration test (as root)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Podman system integ=
ration test (as user)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 LTP lite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Loopdev Sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 jvm test suite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 AMTU (Abstract Mach=
ine Test Utility)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 LTP: openposix test=
 suite
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Ethernet drivers sa=
nity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking socket: =
fuzz
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route: p=
mtu
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route_fu=
nc: local
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Networking route_fu=
nc: forward
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 audit: audit testsu=
ite test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 httpd: mod_ssl smok=
e sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 iotop: sanity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 tuned: tune-process=
es-through-perf
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 pciutils: sanity sm=
oke test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 ALSA PCM loopback t=
est
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 ALSA Control (mixer=
) Userspace Element test
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 Usex - version 1.9-=
29
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =E2=9C=85 stress: stress-ng
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9C=85 CIFS C=
onnectathon
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=9A=A7 =E2=9C=85 POSIX =
pjd-fstest suites
>>
>> =C2=A0=C2=A0 Test sources: https://github.com/CKI-project/tests-beaker
>> =C2=A0=C2=A0=C2=A0=C2=A0 =F0=9F=92=9A Pull requests are welcome for new =
tests or improvements to existing tests!
>>
>> Waived tests
>> ------------
>> If the test run included waived tests, they are marked with =F0=9F=9A=A7=
. Such tests are
>> executed but their results are not taken into account. Tests are waived =
when
>> their results are not reliable enough, e.g. when they're just introduced=
 or are
>> being fixed.
>>
>> Testing timeout
>> ---------------
>> We aim to provide a report within reasonable timeframe. Tests that haven=
't
>> finished running are marked with =E2=8F=B1. Reports for non-upstream ker=
nels have
>> a Beaker recipe linked to next to each host.
>>
>=20

