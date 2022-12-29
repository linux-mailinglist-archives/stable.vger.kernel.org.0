Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D358D65894A
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 04:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiL2D52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 22:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiL2D51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 22:57:27 -0500
Received: from out20-85.mail.aliyun.com (out20-85.mail.aliyun.com [115.124.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CDF12A98;
        Wed, 28 Dec 2022 19:57:24 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.04443898|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00661763-0.000755731-0.992627;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047208;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.Qg8Xn.3_1672286227;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.Qg8Xn.3_1672286227)
          by smtp.aliyun-inc.com;
          Thu, 29 Dec 2022 11:57:08 +0800
Date:   Thu, 29 Dec 2022 11:57:09 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        yukuai3@huawei.com, hch@lst.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
Message-Id: <20221229115707.098A.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

fstests(btrfs/056) hit a panic with the patch-6.1.2-rc1.

[  926.026568] run fstests btrfs/056 at 2022-12-29 08:35:25
[  926.254689] BTRFS info (device sdb1): using crc32c (crc32c-intel) checksum algorithm
[  926.263606] BTRFS info (device sdb1): using free space tree
[  926.273951] BTRFS info (device sdb1): enabling ssd optimizations
[  926.842618] BTRFS: device fsid 4c66cb1b-1661-4b5e-9446-1c610b079eb4 devid 1 transid 6 /dev/sdb2 scanned by systemd-udevd (342727)
[  926.924311] BTRFS info (device dm-0): using crc32c (crc32c-intel) checksum algorithm
[  926.933217] BTRFS info (device dm-0): using free space tree
[  926.941727] BTRFS info (device dm-0): enabling ssd optimizations
[  926.949066] BTRFS info (device dm-0): checking UUID tree
[  927.025958] BTRFS info: devid 1 device path /dev/mapper/flakey-test changed to /dev/dm-0 scanned by systemd-udevd (342802)
[  927.038851] BTRFS info: devid 1 device path /dev/dm-0 changed to /dev/mapper/flakey-test scanned by systemd-udevd (342802)
[  927.130611] BTRFS info (device dm-0): using crc32c (crc32c-intel) checksum algorithm
[  927.139316] BTRFS info (device dm-0): using free space tree
[  927.148273] BTRFS info (device dm-0): enabling ssd optimizations
[  927.155220] BTRFS info (device dm-0): start tree-log replay
[  927.177434] BTRFS info (device dm-0): checking UUID tree
[  927.239312] BUG: kernel NULL pointer dereference, address: 0000000000000058
[  927.246268] #PF: supervisor read access in kernel mode
[  927.253259] #PF: error_code(0x0000) - not-present page
[  927.259256] PGD 0 P4D 0
[  927.262261] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  927.267251] CPU: 29 PID: 342867 Comm: dmsetup Not tainted 6.1.2-0.3.el7.x86_64 #1
[  927.275253] Hardware name: Dell Inc. Precision T7610/0NK70N, BIOS A18 09/11/2019
[  927.283253] RIP: 0010:blk_mq_wait_quiesce_done+0xc/0x30
[  927.290262] Code: 00 00 00 e8 c6 48 ff ff 4c 89 e6 5b 48 89 ef 5d 41 5c e9 f7 c5 66 00 0f 1f 80 00 00 00 00 0f 1f 44 00 00 48 8b 87 18 03 00 00 <f6> 40 58 20 74 0c 48 8b b8 a8 00 00 00 e9 f2 74 c4 ff e9 dd ef c4
[  927.311254] RSP: 0018:ffffbc5a8e41bc60 EFLAGS: 00010286
[  927.317255] RAX: 0000000000000000 RBX: ffffa0cf2a2fb000 RCX: 0000000000000000
[  927.325274] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffffa0cfa08e2260
[  927.333257] RBP: ffffa0cfa08e2260 R08: ffffa0b048488000 R09: ffffa0ceca2e5000
[  927.341253] R10: 0000000000000001 R11: ffffa0cf2a2fa800 R12: 0000000000000000
[  927.350258] R13: ffffa0cf9e4d0c80 R14: ffffa0d0130ab200 R15: ffffffffc19dc560
[  927.358261] FS:  00007f16c58cc580(0000) GS:ffffa0ce2fcc0000(0000) knlGS:0000000000000000
[  927.367251] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  927.373265] CR2: 0000000000000058 CR3: 00000001a0b8c005 CR4: 00000000001706e0
[  927.382265] Call Trace:
[  927.385256]  <TASK>
[  927.388264]  del_gendisk+0x1ec/0x2c0
[  927.393254]  cleanup_mapped_device+0x130/0x140 [dm_mod]
[  927.399253]  __dm_destroy+0x13d/0x1e0 [dm_mod]
[  927.403254]  ? remove_all+0x30/0x30 [dm_mod]
[  927.410259]  dev_remove+0x117/0x190 [dm_mod]
[  927.415253]  ctl_ioctl+0x1ee/0x520 [dm_mod]
[  927.419258]  ? ipc_addid+0x37c/0x460
[  927.423252]  dm_ctl_ioctl+0xa/0x20 [dm_mod]
[  927.430291]  __x64_sys_ioctl+0x89/0xc0
[  927.434263]  do_syscall_64+0x58/0x80
[  927.439268]  ? syscall_exit_to_user_mode+0x12/0x30
[  927.445257]  ? do_syscall_64+0x67/0x80
[  927.449255]  ? exc_page_fault+0x64/0x140
[  927.454262]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  927.459253] RIP: 0033:0x7f16c3a397cb
[  927.465253] Code: 73 01 c3 48 8b 0d bd 66 38 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8d 66 38 00 f7 d8 64 89 01 48
[  927.485254] RSP: 002b:00007fffd5f91a98 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[  927.494267] RAX: ffffffffffffffda RBX: 00007f16c520e1f0 RCX: 00007f16c3a397cb
[  927.502268] RDX: 000055bace7bbb40 RSI: 00000000c138fd04 RDI: 0000000000000003
[  927.510263] RBP: 00007f16c524a143 R08: 00007f16c524ad38 R09: 00007fffd5f918f0
[  927.518262] R10: 0000000000000006 R11: 0000000000000206 R12: 000055bace7bbb40
[  927.526266] R13: 000055bace7bbbf0 R14: 000055bace7bb940 R15: 0000000000000001
[  927.535253]  </TASK>
[  927.538260] Modules linked in: dm_flakey ext4 mbcache jbd2 loop rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache netfs rpcrdma rdma_cm iw_cm ib_cm rfkill ib_core dm_multipath dm_mod intel_rapl_msr intel_rapl_common snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi snd_hda_intel sb_edac snd_intel_dspcfg x86_pkg_temp_thermal intel_powerclamp snd_intel_sdw_acpi coretemp snd_hda_codec kvm_intel snd_hda_core mei_wdt snd_hwdep dcdbas iTCO_wdt btrfs iTCO_vendor_support kvm dell_smm_hwmon snd_seq irqbypass snd_seq_device crct10dif_pclmul crc32_pclmul blake2b_generic xor ghash_clmulni_intel snd_pcm raid6_pq snd_timer rapl zstd_compress intel_cstate snd mei_me i2c_i801 intel_uncore pcspkr lpc_ich i2c_smbus mei soundcore nfsd auth_rpcgss nfs_acl lockd grace sunrpc xfs sd_mod t10_pi amdgpu iommu_v2 gpu_sched drm_buddy sr_mod cdrom sg radeon video ahci drm_ttm_helper ttm libahci bnx2x mpt3sas libata drm_display_helper e1000e crc32c_intel mdio raid_class cec
[  927.538260]  scsi_transport_sas wmi i2c_dev
[  927.637256] CR2: 0000000000000058
[  927.642269] ---[ end trace 0000000000000000 ]---
[  927.822578] RIP: 0010:blk_mq_wait_quiesce_done+0xc/0x30
[  927.828966] Code: 00 00 00 e8 c6 48 ff ff 4c 89 e6 5b 48 89 ef 5d 41 5c e9 f7 c5 66 00 0f 1f 80 00 00 00 00 0f 1f 44 00 00 48 8b 87 18 03 00 00 <f6> 40 58 20 74 0c 48 8b b8 a8 00 00 00 e9 f2 74 c4 ff e9 dd ef c4
[  927.850187] RSP: 0018:ffffbc5a8e41bc60 EFLAGS: 00010286
[  927.856631] RAX: 0000000000000000 RBX: ffffa0cf2a2fb000 RCX: 0000000000000000
[  927.864996] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffffa0cfa08e2260
[  927.873366] RBP: ffffa0cfa08e2260 R08: ffffa0b048488000 R09: ffffa0ceca2e5000
[  927.881735] R10: 0000000000000001 R11: ffffa0cf2a2fa800 R12: 0000000000000000
[  927.890105] R13: ffffa0cf9e4d0c80 R14: ffffa0d0130ab200 R15: ffffffffc19dc560
[  927.898477] FS:  00007f16c58cc580(0000) GS:ffffa0ce2fcc0000(0000) knlGS:0000000000000000
[  927.907809] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  927.914794] CR2: 0000000000000058 CR3: 00000001a0b8c005 CR4: 00000000001706e0
[  927.923182] Kernel panic - not syncing: Fatal exception
[  927.928253] Kernel Offset: 0x15800000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  927.928253] Rebooting in 15 seconds..

the reason is yet not clear.

It still happen without these 4 patches.
dm-cleanup-open_table_device.patch
dm-cleanup-close_table_device.patch
dm-make-sure-create-and-remove-dm-device-won-t-race-.patch
dm-track-per-add_disk-holder-relations-in-dm.patch

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/12/29


