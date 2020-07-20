Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753E022605C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 15:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgGTNCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 09:02:38 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58433 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728001AbgGTNCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 09:02:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 478D85C006F;
        Mon, 20 Jul 2020 09:02:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 09:02:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=CLW2GDE4+Z1GSlrw+VURTi2K0WW
        O0xw86tlMWKYJ+iU=; b=BJ5AIDrA4uet1pQ410Ax6bsm5s7+IEHTVoImfrGqWqo
        kX3WnAq8SjjaBPqJ4uuM8rp+Ryq4ZFeJIM9dXZL4/kFA3uySgGMJ2Sa6bdntxHEp
        Igcf705vhWB9TyCGpkkFc5x3Pdm1jokm4OgBRknGTeibFBrcuVScj94rQ6as+B8x
        h4nO8M14qka/qatH5bKjXgSxIF0uNOnF3JSEHOT5SslZBjERceydornP/dOgEykG
        /+SM0KCVd4unJ7fPdB4uLRbNqmc/au1ucWpZm15DmHXrPBeNmQDkRqz7ZJBq/IAt
        qDCt5YmpOxLgWmJOtFWRswOMZM6BS0npOhO4nbrb5Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CLW2GD
        E4+Z1GSlrw+VURTi2K0WWO0xw86tlMWKYJ+iU=; b=Sdbq7GK8zKoqstxtHYDv2p
        MDMa02RlnKxSZSj5agAvwnT61/lBp/3cj1HtoxaRguXb2v6EEkb3KrxxpjMvu6iP
        DR7G12G1mQp/OCkT7sZwpC/vRndpLPLZ5PUf/poGAT1s3qzV+ZpkQoieDaATKO0/
        UYvuDKVfkvRA9FsuvRVBhq7r1qQBJeC4rJN97iWEqC7l2+ai4/4Qq5gXYrgQiaGK
        iwYKaDkbPhdqbM4Za4rIF90aFaS8xV3JPu88ovfVNKE4conXD4We7WvGbb22IdJa
        kbQVpiBx9B31XzvJoIF0IjL8sRCTFNdL5x/3wErfLZ2O2qcPlEBOjCKgAREC0e3g
        ==
X-ME-Sender: <xms:65UVX0JMW2f6s3Lh6J3MiekFJlXMkbxbAJmgTunJl7WgfY-B4esbFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:65UVX0LgMNn6iKCYPLHzwC_MZ0qvnYZnnc727l4wq0lXXpCc1zgihg>
    <xmx:65UVX0sgg1OsnEU_2I1QpkJgv5GdcyoLIR6Gxo_cCknpC4NIMwHHWQ>
    <xmx:65UVXxaO33FVyPEMrJwibpVWi4wdD43IvKy-N-_YmOUAHn-aTEpfrg>
    <xmx:7JUVXywGltVatdi1x7zwKrnGl5tCp4mv1f1WsxB2T01zGxQNKGNe3g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7331B3280064;
        Mon, 20 Jul 2020 09:02:35 -0400 (EDT)
Date:   Mon, 20 Jul 2020 15:02:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     stable@vger.kernel.org, sjitindarsingh@gmail.com,
        Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Frank van der Linden <fllinden@amazon.com>
Subject: Re: [PATCH 4.9 4.14] x86/cpu: Move x86_cache_bits settings
Message-ID: <20200720130245.GA494210@kroah.com>
References: <20200714220528.32534-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714220528.32534-1-surajjs@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 10:05:28PM +0000, Suraj Jitindar Singh wrote:
> This patch is to fix the backport of the upstream patch:
> cc51e5428ea5 x86/speculation/l1tf: Increase l1tf memory limit for Nehalem+
> 
> When this was backported to the 4.9 and 4.14 stable branches the line
> +       c->x86_cache_bits = c->x86_phys_bits;
> was applied in the wrong place, being added to the
> identify_cpu_without_cpuid() function instead of the get_cpu_cap()
> function which it was correctly applied to in the 4.4 backport.
> 
> This means that x86_cache_bits is not set correctly resulting in the
> following warning due to the cache bits being left uninitalised (zero).
> 
>  WARNING: CPU: 0 PID: 7566 at arch/x86/kvm/mmu.c:284 kvm_mmu_set_mmio_spte_mask+0x4e/0x60 [kvm
>  Modules linked in: kvm_intel(+) kvm irqbypass ipv6 crc_ccitt binfmt_misc evdev lpc_ich mfd_core ioatdma pcc_cpufreq dca ena acpi_power_meter hwmon acpi_pad button ext4 crc16 mbcache jbd2 fscrypto nvme nvme_core dm_mirror dm_region_hash dm_log dm_mod dax
>  Hardware name: Amazon EC2 i3.metal/Not Specified, BIOS 1.0 10/16/2017
>  task: ffff88ff77704c00 task.stack: ffffc9000edac000
>  RIP: 0010:kvm_mmu_set_mmio_spte_mask+0x4e/0x60 [kvm
>  RSP: 0018:ffffc9000edafc60 EFLAGS: 00010206
>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffff45
>  RDX: 000000000000002e RSI: 0008000000000001 RDI: 0008000000000001
>  RBP: ffffffffa036f000 R08: ffffffffffffff80 R09: ffffe8ffffccb3c0
>  R10: 0000000000000038 R11: 0000000000000000 R12: 0000000000005b80
>  R13: ffffffffa0370e40 R14: 0000000000000001 R15: ffff88bf7c0927e0
>  FS:  00007fa316f24740(0000) GS:ffff88bf7f600000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007fa316ea0000 CR3: 0000003f7e986004 CR4: 00000000003606f0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   kvm_mmu_module_init+0x166/0x230 [kvm
>   kvm_arch_init+0x5d/0x150 [kvm
>   kvm_init+0x1c/0x2d0 [kvm
>   ? hardware_setup+0x4a6/0x4a6 [kvm_intel
>   vmx_init+0x23/0x6aa [kvm_intel
>   ? hardware_setup+0x4a6/0x4a6 [kvm_intel
>   do_one_initcall+0x3e/0x15d
>   do_init_module+0x5b/0x1e5
>   load_module+0x19e6/0x1dc0
>   ? SYSC_init_module+0x13b/0x170
>   SYSC_init_module+0x13b/0x170
>   do_syscall_64+0x67/0x110
>   entry_SYSCALL_64_after_hwframe+0x41/0xa6
>  RIP: 0033:0x7fa316828f3a
>  RSP: 002b:00007ffc9d65c1f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
>  RAX: ffffffffffffffda RBX: 00007fa316b08849 RCX: 00007fa316828f3a
>  RDX: 00007fa316b08849 RSI: 0000000000071328 RDI: 00007fa316e37000
>  RBP: 0000000000b47e80 R08: 0000000000000003 R09: 0000000000000000
>  R10: 00007fa316822dba R11: 0000000000000246 R12: 0000000000b46340
>  R13: 0000000000b464c0 R14: 0000000000000000 R15: 0000000000040000
>  Code: e9 65 06 00 75 25 48 b8 00 00 00 00 00 00 00 40 48 09 c6 48 09 c7 48 89 35 f8 65 06 00 48 89 3d f9 65 06 00 c3 0f 0b 0f 0b eb d2 <0f> 0b eb d7 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
> 
> Fixes: 4.9.x  ef3d45c95764 x86/speculation/l1tf: Increase l1tf memory limit for Nehalem+
> Fixes: 4.14.x ec4034835eaf x86/speculation/l1tf: Increase l1tf memory limit for Nehalem+
> Cc: stable@vger.kernel.org # 4.9.x-4.14.x
> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
> Reviewed-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> Reviewed-by: Frank van der Linden <fllinden@amazon.com>
> ---
>  arch/x86/kernel/cpu/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Wonderful, thanks for this, now queued up.

greg k-h
