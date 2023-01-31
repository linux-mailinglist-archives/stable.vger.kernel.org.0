Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4732A682250
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 03:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjAaCmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 21:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjAaCmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 21:42:14 -0500
Received: from out28-64.mail.aliyun.com (out28-64.mail.aliyun.com [115.124.28.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC498AD02;
        Mon, 30 Jan 2023 18:42:10 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.04436261|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.00301661-0.000241039-0.996742;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047213;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.R5YhiLO_1675132925;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.R5YhiLO_1675132925)
          by smtp.aliyun-inc.com;
          Tue, 31 Jan 2023 10:42:07 +0800
Date:   Tue, 31 Jan 2023 10:42:07 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>
References: <20230130181611.883327545@linuxfoundation.org>
Message-Id: <20230131104206.0E8A.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,


> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

fstests btrfs/056 triggered a panic for 6.1.9-rc2, but the panic does not happen
on 6.1.8 and 6.2.0-rc4.

reproduce frequency: 100%

dmesg output:
[  255.065317] BTRFS info (device sda1): using crc32c (crc32c-intel) checksum algorithm
[  255.073122] BTRFS info (device sda1): using free space tree
[  255.082258] BTRFS info (device sda1): enabling ssd optimizations
[  255.816218] BTRFS: device fsid 9b909f4f-253e-48dc-b4a2-2ade4c9af8c7 devid 1 transid 6 /dev/sda2 scanned by systemd-udevd (2797)
[  255.846173] BTRFS info (device sda2): using crc32c (crc32c-intel) checksum algorithm
[  255.853966] BTRFS info (device sda2): using free space tree
[  255.861240] BTRFS info (device sda2): enabling ssd optimizations
[  255.867491] BTRFS info (device sda2): checking UUID tree
[  255.995931] BTRFS info (device sda1): using crc32c (crc32c-intel) checksum algorithm
[  256.003727] BTRFS info (device sda1): using free space tree
[  256.012402] BTRFS info (device sda1): enabling ssd optimizations
[  256.042824] run fstests btrfs/056 at 2023-01-31 09:49:32
[  256.284245] BTRFS info (device sda1): using crc32c (crc32c-intel) checksum algorithm
[  256.292044] BTRFS info (device sda1): using free space tree
[  256.300444] BTRFS info (device sda1): enabling ssd optimizations
[  256.865578] BTRFS: device fsid f955e05d-83e4-46c8-a5f4-fc7c4d3f7c02 devid 1 transid 6 /dev/sda2 scanned by systemd-udevd (3119)
[  256.947543] BTRFS info (device dm-0): using crc32c (crc32c-intel) checksum algorithm
[  256.955335] BTRFS info (device dm-0): using free space tree
[  256.962595] BTRFS info (device dm-0): enabling ssd optimizations
[  256.968801] BTRFS info (device dm-0): checking UUID tree
[  257.041467] BTRFS info: devid 1 device path /dev/mapper/flakey-test changed to /dev/dm-0 scanned by systemd-udevd (3194)
[  257.053007] BTRFS info: devid 1 device path /dev/dm-0 changed to /dev/mapper/flakey-test scanned by systemd-udevd (3194)
[  257.141752] BTRFS info (device dm-0): using crc32c (crc32c-intel) checksum algorithm
[  257.149566] BTRFS info (device dm-0): using free space tree
[  257.157642] BTRFS info (device dm-0): enabling ssd optimizations
[  257.163683] BTRFS info (device dm-0): start tree-log replay
[  257.184645] BTRFS info (device dm-0): checking UUID tree
[  257.253420] BUG: kernel NULL pointer dereference, address: 0000000000000058
[  257.254357] #PF: supervisor read access in kernel mode
[  257.254357] #PF: error_code(0x0000) - not-present page
[  257.254357] PGD 0 P4D 0
[  257.254357] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  257.254357] Hardware name: Dell Inc. Precision T7610/0NK70N, BIOS A18 09/11/2019
[  257.254357] RIP: 0010:blk_mq_wait_quiesce_done (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/block/blk-mq.c:264) 
[ 257.254357] Code: 00 00 00 e8 96 48 ff ff 4c 89 e6 5b 48 89 ef 5d 41 5c e9 47 cd 66 00 0f 1f 80 00 00 00 00 0f 1f 44 00 00 48 8b 87 18 03 00 00 <f6> 40 58 20 74 0c 48 8b b8 a8 00 00 00 e9 d2 6d c4 ff e9 bd e8 c4
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 e8                	add    %ch,%al
   4:	96                   	xchg   %eax,%esi
   5:	48 ff                	rex.W (bad) 
   7:	ff 4c 89 e6          	decl   -0x1a(%rcx,%rcx,4)
   b:	5b                   	pop    %rbx
   c:	48 89 ef             	mov    %rbp,%rdi
   f:	5d                   	pop    %rbp
  10:	41 5c                	pop    %r12
  12:	e9 47 cd 66 00       	jmpq   0x66cd5e
  17:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  1e:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  23:	48 8b 87 18 03 00 00 	mov    0x318(%rdi),%rax
  2a:*	f6 40 58 20          	testb  $0x20,0x58(%rax)		<-- trapping instruction
  2e:	74 0c                	je     0x3c
  30:	48 8b b8 a8 00 00 00 	mov    0xa8(%rax),%rdi
  37:	e9 d2 6d c4 ff       	jmpq   0xffffffffffc46e0e
  3c:	e9                   	.byte 0xe9
  3d:	bd                   	.byte 0xbd
  3e:	e8                   	.byte 0xe8
  3f:	c4                   	.byte 0xc4

Code starting with the faulting instruction
===========================================
   0:	f6 40 58 20          	testb  $0x20,0x58(%rax)
   4:	74 0c                	je     0x12
   6:	48 8b b8 a8 00 00 00 	mov    0xa8(%rax),%rdi
   d:	e9 d2 6d c4 ff       	jmpq   0xffffffffffc46de4
  12:	e9                   	.byte 0xe9
  13:	bd                   	.byte 0xbd
  14:	e8                   	.byte 0xe8
  15:	c4                   	.byte 0xc4
[  257.254357] RSP: 0018:ffffa1120f9cbc18 EFLAGS: 00010286
[  257.254357] RAX: 0000000000000000 RBX: ffff8ed619076800 RCX: 0000000000000000
[  257.254357] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff8eb68a76a260
[  257.254357] RBP: ffff8eb68a76a260 R08: ffff8ed6514cb380 R09: ffff8ed652867000
[  257.254357] R10: 0000000000000001 R11: ffff8ed619073400 R12: 0000000000000000
[  257.254357] R13: ffff8eb69750b840 R14: ffff8eb691b94e00 R15: ffffffffc1be2570
[  257.254357] FS:  00007f6ef8b0b580(0000) GS:ffff8ee5afc40000(0000) knlGS:0000000000000000
[  257.254357] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  257.254357] CR2: 0000000000000058 CR3: 000000207afa0003 CR4: 00000000001706e0
[  257.254357] Call Trace:
[  257.254357]  <TASK>
[  257.254357] del_gendisk (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/block/genhd.c:654) 

    blk_mq_quiesce_queue(q);
654:    if (q->elevator) {
        mutex_lock(&q->sysfs_lock);
        elevator_exit(q);
        mutex_unlock(&q->sysfs_lock);
    }

[  257.254357] cleanup_mapped_device (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/drivers/md/dm.c:1991) dm_mod
[  257.254357] __dm_destroy (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/drivers/md/dm.c:840 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/drivers/md/dm.c:2140 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/drivers/md/dm.c:2491) dm_mod
[  257.254357] ? remove_all (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/drivers/md/dm-ioctl.c:953) dm_mod
[  257.254357] dev_remove (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/drivers/md/dm-ioctl.c:1004) dm_mod
[  257.254357] ctl_ioctl (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/drivers/md/dm-ioctl.c:1999) dm_mod
[  257.254357] dm_ctl_ioctl (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/drivers/md/dm-ioctl.c:2021) dm_mod
[  257.254357] __x64_sys_ioctl (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/fs/ioctl.c:51 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/fs/ioctl.c:870 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/fs/ioctl.c:856 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/fs/ioctl.c:856) 
[  257.254357] do_syscall_64 (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/entry/common.c:50 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/entry/common.c:80) 
[  257.254357] ? do_syscall_64 (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/entry/common.c:87) 
[  257.254357] ? syscall_exit_to_user_mode (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/include/asm/jump_label.h:27 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/include/linux/context_tracking_state.h:106 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/include/linux/context_tracking.h:41 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/kernel/entry/common.c:134 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/kernel/entry/common.c:298) 
[  257.254357] ? do_syscall_64 (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/entry/common.c:87) 
[  257.254357] ? syscall_exit_to_user_mode (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/include/asm/jump_label.h:27 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/include/linux/context_tracking_state.h:106 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/include/linux/context_tracking.h:41 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/kernel/entry/common.c:134 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/kernel/entry/common.c:298) 
[  257.254357] ? do_syscall_64 (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/entry/common.c:87) 
[  257.254357] ? exc_page_fault (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/include/asm/irqflags.h:40 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/include/asm/irqflags.h:75 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/mm/fault.c:1527 /usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/mm/fault.c:1575) 
[  257.254357] entry_SYSCALL_64_after_hwframe (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/arch/x86/entry/entry_64.S:120) 
[  257.254357] RIP: 0033:0x7f6ef6c397cb
[ 257.254357] Code: 73 01 c3 48 8b 0d bd 66 38 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8d 66 38 00 f7 d8 64 89 01 48
All code
========
   0:	73 01                	jae    0x3
   2:	c3                   	retq   
   3:	48 8b 0d bd 66 38 00 	mov    0x3866bd(%rip),%rcx        # 0x3866c7
   a:	f7 d8                	neg    %eax
   c:	64 89 01             	mov    %eax,%fs:(%rcx)
   f:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
  13:	c3                   	retq   
  14:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1b:	00 00 00 
  1e:	90                   	nop
  1f:	f3 0f 1e fa          	endbr64 
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq   
  33:	48 8b 0d 8d 66 38 00 	mov    0x38668d(%rip),%rcx        # 0x3866c7
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	retq   
   9:	48 8b 0d 8d 66 38 00 	mov    0x38668d(%rip),%rcx        # 0x38669d
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[  257.254357] RSP: 002b:00007ffe2ea1a9a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[  257.254357] RAX: ffffffffffffffda RBX: 00007f6ef840e1f0 RCX: 00007f6ef6c397cb
[  257.254357] RDX: 000055d26db3ab40 RSI: 00000000c138fd04 RDI: 0000000000000003
[  257.254357] RBP: 00007f6ef844a143 R08: 00007f6ef844ad38 R09: 00007ffe2ea1a800
[  257.254357] R10: 0000000000000006 R11: 0000000000000202 R12: 000055d26db3ab40
[  257.254357] R13: 000055d26db3abf0 R14: 000055d26db3a940 R15: 0000000000000001
[  257.254357]  </TASK>
[  257.254357] Modules linked in: dm_flakey rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache netfs rpcrdma rdma_cm iw_cm ib_cm bridge stp llc rfkill ib_core dm_multipath dm_mod intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel btrfs snd_hda_codec_realtek kvm snd_hda_codec_generic snd_hda_codec_hdmi ledtrig_audio snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec irqbypass crct10dif_pclmul snd_hda_core crc32_pclmul blake2b_generic snd_hwdep ghash_clmulni_intel xor snd_seq raid6_pq snd_seq_device rapl zstd_compress snd_pcm mei_wdt dcdbas intel_cstate iTCO_wdt snd_timer iTCO_vendor_support dell_smm_hwmon mei_me pcspkr intel_uncore i2c_i801 snd mei i2c_smbus soundcore lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc xfs sd_mod t10_pi amdgpu iommu_v2 gpu_sched drm_buddy sr_mod cdrom sg radeon ahci video libahci drm_ttm_helper ttm bnx2x mpt3sas libata drm_display_helper e1000e crc32c_intel mdio raid_class cec scsi_transport_sas 
 wmi
[  257.254357]  i2c_dev
[  257.254357] CR2: 0000000000000058
[  257.611818] ---[ end trace 0000000000000000 ]---
[  257.779407] RIP: 0010:blk_mq_wait_quiesce_done (/usr/src/debug/kernel-6.1.9/linux-6.1.9-0.1.el7.x86_64/block/blk-mq.c:264) 
[ 257.784665] Code: 00 00 00 e8 96 48 ff ff 4c 89 e6 5b 48 89 ef 5d 41 5c e9 47 cd 66 00 0f 1f 80 00 00 00 00 0f 1f 44 00 00 48 8b 87 18 03 00 00 <f6> 40 58 20 74 0c 48 8b b8 a8 00 00 00 e9 d2 6d c4 ff e9 bd e8 c4
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 e8                	add    %ch,%al
   4:	96                   	xchg   %eax,%esi
   5:	48 ff                	rex.W (bad) 
   7:	ff 4c 89 e6          	decl   -0x1a(%rcx,%rcx,4)
   b:	5b                   	pop    %rbx
   c:	48 89 ef             	mov    %rbp,%rdi
   f:	5d                   	pop    %rbp
  10:	41 5c                	pop    %r12
  12:	e9 47 cd 66 00       	jmpq   0x66cd5e
  17:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  1e:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  23:	48 8b 87 18 03 00 00 	mov    0x318(%rdi),%rax
  2a:*	f6 40 58 20          	testb  $0x20,0x58(%rax)		<-- trapping instruction
  2e:	74 0c                	je     0x3c
  30:	48 8b b8 a8 00 00 00 	mov    0xa8(%rax),%rdi
  37:	e9 d2 6d c4 ff       	jmpq   0xffffffffffc46e0e
  3c:	e9                   	.byte 0xe9
  3d:	bd                   	.byte 0xbd
  3e:	e8                   	.byte 0xe8
  3f:	c4                   	.byte 0xc4

Code starting with the faulting instruction
===========================================
   0:	f6 40 58 20          	testb  $0x20,0x58(%rax)
   4:	74 0c                	je     0x12
   6:	48 8b b8 a8 00 00 00 	mov    0xa8(%rax),%rdi
   d:	e9 d2 6d c4 ff       	jmpq   0xffffffffffc46de4
  12:	e9                   	.byte 0xe9
  13:	bd                   	.byte 0xbd
  14:	e8                   	.byte 0xe8
  15:	c4                   	.byte 0xc4
[  257.803515] RSP: 0018:ffffa1120f9cbc18 EFLAGS: 00010286
[  257.808767] RAX: 0000000000000000 RBX: ffff8ed619076800 RCX: 0000000000000000
[  257.815937] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff8eb68a76a260
[  257.823107] RBP: ffff8eb68a76a260 R08: ffff8ed6514cb380 R09: ffff8ed652867000
[  257.830277] R10: 0000000000000001 R11: ffff8ed619073400 R12: 0000000000000000
[  257.837444] R13: ffff8eb69750b840 R14: ffff8eb691b94e00 R15: ffffffffc1be2570
[  257.844623] FS:  00007f6ef8b0b580(0000) GS:ffff8ee5afc40000(0000) knlGS:0000000000000000
[  257.852751] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  257.858525] CR2: 0000000000000058 CR3: 000000207afa0003 CR4: 00000000001706e0
[  257.865694] Kernel panic - not syncing: Fatal exception
[  257.866690] Kernel Offset: 0x1ee00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)


Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/01/31


