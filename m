Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D6033F09E
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 13:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhCQMlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 08:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhCQMlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 08:41:09 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0FEC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 05:40:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dx17so2365133ejb.2
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 05:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YdntaPYw8CT+RFNUSHAdGtRw13NnDShconWHlcJZljI=;
        b=Jqcc4ESSN6KCS4bJmcFuVxrx177lqHiPLm5kBJl4DQQw4LivIBNW3eoBmXD8JTAMSZ
         CLMEEIrwLetPubU3szxx354fic2+yhDS4P5ZDCyk/BdmSVvzYZ9pi0e/xvr4GZdkG6jl
         /wCn9zX8/zhp4Pv8350A32SNOKrrukQ1iCoe+qooREIHFm0NzpHgnxHcmTfvQCsbVx1q
         ybkBpIFN2dRAvpmaleCwxKTfIlZvLOCvXnGhNUjZb9PIqjDLkFxEo2si8EMqE/VTBw2M
         OZCX+Z0G8NQFQ1+6sPVjC/MR1Ujk0KL69ulat1z51eqnn0DHocDWcL6ct+7A5N9LfkX9
         JBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=YdntaPYw8CT+RFNUSHAdGtRw13NnDShconWHlcJZljI=;
        b=oA7ERgwzhcaOohGrxowqk2OIlSGjHcU/8qTyAGZtdqcGZHID2cQ36vvWsjaom3dROH
         xAksXEQkvSPz3ZzB4tmmCxIJrwwaOZOscVYWUw67uFJ8L8hu92BrCdmDNXbBU6o0J6BF
         W8LWWjJLm1GNSZJrL0Ynmvbo7wF55Wqm3m8EpdVEBDi90a6I0lfLN0cOtg4yxKYMYYyY
         6QZzsb6tgJgpZSxEF8Q4hX6NO2enu9Or6wRnJlnZuMBD88CF42JDyeL5h6OlaGDyt3XV
         M25aHEWE8u0NUog14C4zwLi875PGubooMZGEo8R2DKoTqitQ6LS/CYZsVsGj642ElZZn
         1aYg==
X-Gm-Message-State: AOAM530R6+a9u0/HqLorF2au2fiVsLatc47++plzRQZTJHHiV2W45eK+
        WsHJWSp9OmTJJCq6H44C4cwxMsVj3PVSCg==
X-Google-Smtp-Source: ABdhPJxh8KNd1c0sbzxePx+D9Zn/SeQWpviTXd/QfpJ8Ot+opjAOnuF0hIcT0iQ4OfA650MrXBhBUg==
X-Received: by 2002:a17:907:20f5:: with SMTP id rh21mr35072174ejb.27.1615984857355;
        Wed, 17 Mar 2021 05:40:57 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id o20sm5273095eds.65.2021.03.17.05.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 05:40:56 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 17 Mar 2021 13:40:55 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     oss-security@lists.openwall.com
Cc:     Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Lukas Czerner <lczerner@redhat.com>,
        Wolfgang Frisch <wolfgang.frisch@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [oss-security] CVE-2021-3428 Linux kernel: integer overflow in
 ext4_es_cache_extent
Message-ID: <YFH414+hBOyl1Bw7@eldamar.lan>
References: <CAKx+4-oZ3YabEpWXYSs8LccRc8PcC_o2fbg7V5FpLT+nVBn66w@mail.gmail.com>
 <YFHVuDKj+oMwxBZX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFHVuDKj+oMwxBZX@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Mar 17, 2021 at 11:11:04AM +0100, Greg KH wrote:
> On Wed, Mar 17, 2021 at 11:21:23AM +0530, Rohit Keshri wrote:
> > Hello Team,
> > 
> > A flaw was found in the Linux kernel. A denial of service problem is
> > identified if an extent tree is corrupted in a crafted ext4 filesystem in
> > fs/ext4/extents.c in ext4_es_cache_extent. Fabricating an integer overflow,
> > A local attacker with a special user privilege may cause a system crash
> > problem which can lead to an availability threat.
> 
> Please include what kernel version things like this were "found in" and
> when it was fixed, otherwise you force everyone to go scramble just to
> find that this was reported in July of 2020 and fixed then in the 5.9
> kernel release and has already been backported to all relevant stable
> kernel releases in August of last year.
> 
> In other words, no one running an updated kernel version from kernel.org
> is vulnerable today, right?  Are you saying that specific distro kernels
> are vulnerable to this?  If so, which ones?

It might be missing in some stable trees from a quick check. I just
checked the SUSE bug and it lists the following three relevant
commits, whilst the last one seems the relevant one:

d176b1f62f24 "ext4: handle error of ext4_setup_system_zone() on remount"
bf9a379d0980 "ext4: don't allow overlapping system zones"
ce9f24cccdc0 "ext4: check journal inode extents more carefully"

ce9f24cccdc0 was indeed included in 5.9-rc2, and backported to

v5.7.18: 3b654d118548ef2bb212dca361a5d1d19707822d ext4: check journal inode extents more carefully
v5.8.4: cfa678021a1bb6b5ce4aa45c865f2d3167646f89 ext4: check journal inode extents more carefully
v5.9-rc2: ce9f24cccdc019229b70a5c15e2b09ad9c0ab5d1 ext4: check journal inode extents more carefully

Then though it has 

Fixes: 0a944e8a6c66 ("ext4: don't perform block validity checks on the journal inode")

and 0a944e8a6c66 itself was backported to some of the stable series as
well, I found:

v3.16.85: 71bfaf9e30125ec5b408fd328e412abf3b23214d ext4: don't perform block validity checks on the journal inode
v4.14.178: fc3293a80acc469fbabc91bfbf2e65dc84377dc7 ext4: don't perform block validity checks on the journal inode
v4.19.73: 97fbf573460e56ddf172614f70cdfa2af03b20ea ext4: don't perform block validity checks on the journal inode
v4.4.221: 571fa68cacdf5fa70a6fdb71bda051f822d3cfb6 ext4: don't perform block validity checks on the journal inode
v4.9.221: 2130aae807893cff163404bf6f6f6a4906dd14a1 ext4: don't perform block validity checks on the journal inode
v5.2-rc2: 0a944e8a6c66ca04c7afbaa17e22bf208a8b37f0 ext4: don't perform block validity checks on the journal inode

So in the current still supported stable series, in 4.9.221, 4.14.178 and
4.19.73.

I just tried the reproducer from
https://bugzilla.suse.com/show_bug.cgi?id=1173485 on a system with 4.19.177
which so has not yet the 0a944e8a6c66 ("ext4: don't perform block validity
checks on the journal inode") fix backported and it indeed causes:

[  224.003978] ------------[ cut here ]------------
[  224.005052] kernel BUG at fs/ext4/extents_status.c:762!
[  224.006659] invalid opcode: 0000 [#1] SMP PTI
[  224.008378] CPU: 0 PID: 594 Comm: mount Not tainted 4.19.0-15-amd64 #1 Debian 4.19.177-1
[  224.011292] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[  224.014043] RIP: 0010:ext4_es_cache_extent+0xfe/0x100 [ext4]
[  224.015770] Code: 48 8b 45 00 48 8b 7d 08 48 83 c5 18 48 89 e2 4c 89 e6 e8 a5 15 d8 d2 48 8b 45 00 48 85 c0 75 e4 e9 54 ff ff ff e8 a2 65 3f d2 <0f> 0b 0f 1f 44 00 00 41 55 49 89 fd 41 54 55 48 89 d5 53 89 f3 0f
[  224.019834] RSP: 0018:ffffa7a840b8f958 EFLAGS: 00010213
[  224.021034] RAX: 07ffffffffffffff RBX: 0000000000007ffd RCX: 0000ffffffffffff
[  224.022658] RDX: 0000000000007fff RSI: 00000000ffffffff RDI: ffff940d78a78968
[  224.024283] RBP: 0000000000007fff R08: 1000ffffffffffff R09: 00000000000002c9
[  224.025913] R10: 00000000000002c9 R11: 0000000000000041 R12: ffff940d78a78968
[  224.027549] R13: 00000000ffffffff R14: ffffffffffffffff R15: 00000000ffffffff
[  224.029179] FS:  00007fe8d33fb100(0000) GS:ffff940d7ba00000(0000) knlGS:0000000000000000
[  224.031011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  224.032354] CR2: 000056074c755878 CR3: 0000000135184001 CR4: 00000000001606f0
[  224.033990] Call Trace:
[  224.034634]  ext4_cache_extents+0x63/0xd0 [ext4]
[  224.035712]  __read_extent_tree_block+0x111/0x160 [ext4]
[  224.036665]  ? __kmalloc+0x180/0x220
[  224.037343]  ? ext4_find_extent+0x144/0x320 [ext4]
[  224.038247]  ext4_find_extent+0x144/0x320 [ext4]
[  224.039144]  ext4_ext_map_blocks+0x6a/0xda0 [ext4]
[  224.040063]  ? schedule+0x28/0x80
[  224.040747]  ? __wait_on_bit+0x58/0x90
[  224.041476]  ext4_map_blocks+0x2e4/0x5f0 [ext4]
[  224.042350]  ? ext4_data_block_valid+0x1d/0x20 [ext4]
[  224.043313]  ? __ext4_ext_check+0x238/0x3a0 [ext4]
[  224.044261]  _ext4_get_block+0x8e/0x110 [ext4]
[  224.045158]  ? unlock_new_inode+0x4e/0x60
[  224.045960]  generic_block_bmap+0x4b/0x70
[  224.046765]  jbd2_journal_init_inode+0x11/0xb0 [jbd2]
[  224.047794]  ext4_fill_super+0x3052/0x3c70 [ext4]
[  224.048730]  ? bdev_name.isra.6+0x2a/0xa0
[  224.049530]  ? ext4_calculate_overhead+0x490/0x490 [ext4]
[  224.050555]  ? snprintf+0x49/0x60
[  224.051234]  ? ext4_calculate_overhead+0x490/0x490 [ext4]
[  224.052309]  ? mount_bdev+0x177/0x1b0
[  224.053074]  ? ext4_calculate_overhead+0x490/0x490 [ext4]
[  224.054146]  mount_bdev+0x177/0x1b0
[  224.054858]  mount_fs+0x3e/0x150
[  224.055533]  vfs_kern_mount.part.36+0x54/0x120
[  224.056394]  do_mount+0x20e/0xcc0
[  224.057022]  ? _copy_from_user+0x37/0x60
[  224.057781]  ? memdup_user+0x4b/0x70
[  224.058530]  ksys_mount+0xb6/0xd0
[  224.059231]  __x64_sys_mount+0x21/0x30
[  224.059949]  do_syscall_64+0x53/0x110
[  224.060631]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  224.061531] RIP: 0033:0x7fe8d35f9fea
[  224.062255] Code: 48 8b 0d a9 0e 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 76 0e 0c 00 f7 d8 64 89 01 48
[  224.065741] RSP: 002b:00007ffcd2022e38 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[  224.067223] RAX: ffffffffffffffda RBX: 000056074c748fb0 RCX: 00007fe8d35f9fea
[  224.068620] RDX: 000056074c751050 RSI: 000056074c7491e0 RDI: 000056074c7491c0
[  224.069987] RBP: 00007fe8d39471c4 R08: 0000000000000000 R09: 0000000000000000
[  224.071399] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  224.072764] R13: 0000000000000000 R14: 000056074c7491c0 R15: 000056074c751050
[  224.074101] Modules linked in: loop sctp binfmt_misc crct10dif_pclmul crc32_pclmul ghash_clmulni_intel button virtio_console virtio_balloon evdev qemu_fw_cfg joydev pcspkr serio_raw nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb hid_generic usbhid hid btrfs xor zstd_decompress zstd_compress xxhash raid6_pq libcrc32c crc32c_generic dm_mod ata_generic virtio_net net_failover failover virtio_blk crc32c_intel ata_piix libata uhci_hcd ehci_pci ehci_hcd scsi_mod floppy aesni_intel usbcore psmouse aes_x86_64 crypto_simd cryptd glue_helper i2c_piix4 virtio_pci virtio_ring virtio usb_common
[  224.084374] ---[ end trace a93d957244af62ea ]---
[  224.085298] RIP: 0010:ext4_es_cache_extent+0xfe/0x100 [ext4]
[  224.086402] Code: 48 8b 45 00 48 8b 7d 08 48 83 c5 18 48 89 e2 4c 89 e6 e8 a5 15 d8 d2 48 8b 45 00 48 85 c0 75 e4 e9 54 ff ff ff e8 a2 65 3f d2 <0f> 0b 0f 1f 44 00 00 41 55 49 89 fd 41 54 55 48 89 d5 53 89 f3 0f
[  224.089834] RSP: 0018:ffffa7a840b8f958 EFLAGS: 00010213
[  224.090832] RAX: 07ffffffffffffff RBX: 0000000000007ffd RCX: 0000ffffffffffff
[  224.092181] RDX: 0000000000007fff RSI: 00000000ffffffff RDI: ffff940d78a78968
[  224.093539] RBP: 0000000000007fff R08: 1000ffffffffffff R09: 00000000000002c9
[  224.094899] R10: 00000000000002c9 R11: 0000000000000041 R12: ffff940d78a78968
[  224.096264] R13: 00000000ffffffff R14: ffffffffffffffff R15: 00000000ffffffff
[  224.097586] FS:  00007fe8d33fb100(0000) GS:ffff940d7ba00000(0000) knlGS:0000000000000000
[  224.099144] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  224.100284] CR2: 000056074c755878 CR3: 0000000135184001 CR4: 00000000001606f0

So likely the 4.9.y, 4.14.y and 4.19.y still have the bug?  Is this correct? I
only quickly skimmed over the report, but this seems to be the case.

Regards,
Salvatore
