Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA014D7EE4
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiCNJol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiCNJol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:44:41 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1432BC87;
        Mon, 14 Mar 2022 02:43:31 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CCF083201F32;
        Mon, 14 Mar 2022 05:43:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 14 Mar 2022 05:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=rJASCHSYYgVb9BFHNfNzV+AT7ib80gn5MNJDrZ
        LkXCg=; b=hf4awhxY6xVbOOCUTdqbioJqLvnq4/0GZPNanCO8k2PPsJGT60tdDn
        FHSqcjL4HaEyG6rfx0M5z4Dhm1z81RZtt5O+3UqEtn+QlhJ3PddmjZ21QSx1nZBt
        TG5euPt9JjFcyD9sjwMFi2i36MqbS0L7JSd43yiv/U75JU27sLMzIMVUP0+ZaoU9
        QRwMzJ/eGJ02q0pCnc5VYWqT1VJbx6MjuDbGOkU+y8hlstQDooXZJ0NaxiKn6Msd
        4wxvpUVeaTFixC2crvvFhN15w9EFzZCuw8u/3v4ruPr6D0pXcsK+cB3yPhSQsn7V
        T6GBqzRiL8n9aHqa1YxhtNWVySIt4qJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rJASCHSYYgVb9BFHN
        fNzV+AT7ib80gn5MNJDrZLkXCg=; b=Y674Ni4rlRUdgxhlZz8pjCyOfqGpKtbzy
        QGQboV28wf2HMgkoZPHgA/m5fUjg2lBsMkSVkJYSPI4xi9vi/Tf+2rkOuEHqxXSL
        0+kp/6LEUrg52/H95WbjJ2+Q8H5nYJksEzAkJH17MhCapkcFgdKI8HUrienGVPKd
        c3okDAPifiTBshx6h9hKYH5UnH6d0oMffdTmHDglFbwh8MRdEWZlw0PNkKWo2obI
        CFtMyCaEnjPezkvDxkfWT017Qee39G5bPiSWTyXrSPyPsBRVGWPq9JW1m8SSuRHk
        lGqUS8u8DtteJ6LzZXzTYQF5QzhdOWFf9AuFKb3u9GOz00vcYkibg==
X-ME-Sender: <xms:QA4vYqeF9nKUzKgFVY0h-Uc4EL0oGngjJRqT2WrGq8ZMOagXMp2xLg>
    <xme:QA4vYkMO9b6yIFK9yZvoBEEIeg64IkMofm3EPWCMJiF9jCalzV2CKv18pFsKxAl-v
    lFM1FMorygBaw>
X-ME-Received: <xmr:QA4vYricS7CrRh0git_Zx6czqkqNe2PgPBNON44eTq91MsVVV4CtOjpRaXg9uzaTSY3i6BLoF2jhUFMpZvnDivvE94P4WM-N>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvkedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:QA4vYn92gk2fMH6mtFCQlowuS1KL_b-cYjjKh8bXt_kBvnmbsDLBVg>
    <xmx:QA4vYmtSWtIU_EMHOQWkeaQ5DjKSFAPtJLeFlOMEKFJbLvPg7ANzQA>
    <xmx:QA4vYuHVC_wVWDG5102vAzsZkv9PH-nJVZQsh_VMOFD52sEWIMyUSA>
    <xmx:QQ4vYhkdmVbF49LuOO4KCoZUMRw2rB_WHS_9kxFVTd4OFQ8lLsJgNw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Mar 2022 05:43:28 -0400 (EDT)
Date:   Mon, 14 Mar 2022 10:43:26 +0100
From:   Greg KH <greg@kroah.com>
To:     Liam Merwick <liam.merwick@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        bp@alien8.de, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        krish.sadhukhan@oracle.com
Subject: Re: [PATCH 5.4 0/4] Backport fixes to avoid SEV guest with 380GB+
 memory causing host cpu softhang
Message-ID: <Yi8OPqQgYKwwzVnb@kroah.com>
References: <20220311112927.8400-1-liam.merwick@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311112927.8400-1-liam.merwick@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 11:29:23AM +0000, Liam Merwick wrote:
> [ patch series targeting linux-5.4.y stable branch. ]
> 
> Creating a SEV-enabled guest with 380GB or more of memory causes a
> cpu soft-hang in the host running 5.4 with the following stacktrace:
> 
> kernel: watchdog: BUG: soft lockup - CPU#214 stuck for 22s! [qemu-kvm:6424]
> ...
> kernel: CPU: 214 PID: 6424 Comm: qemu-kvm Not tainted 5.4.183.stable #1
> kernel: Hardware name: Oracle Corporation ORACLE SERVER E4-2c/Asm,MB
> Tray,2U,E4-2c, BIOS 78014000 01/05/2022
> kernel: RIP: 0010:clflush_cache_range+0x35/0x40
> kernel: Code: f0 0f b7 15 63 53 99 01 89 f6 48 89 d0 48 f7 d8 48 21 f8 48 01 f7
> 48 39 f8 73 0c 66 0f ae 38 48 01 d0 48 39 c7 77 f4 0f ae f0 <5d> c3 66 0f 1f 84
> 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 0f ae
> kernel: RSP: 0018:ffffacba5e98fc30 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> kernel: RAX: ffffa1193cfbc000 RBX: ffffacbba4701000 RCX: 0000000000000000
> kernel: RDX: 0000000000000040 RSI: 0000000000001000 RDI: ffffa1193cfbc000
> kernel: RBP: ffffacba5e98fc30 R08: ffffacba5f44aca0 R09: ffffacbac3701000
> kernel: R10: 0000000000000080 R11: ffff9f8500000af0 R12: ffffa18074a22f80
> kernel: R13: ffffacbaf6889dd8 R14: ffffacba5f41d960 R15: ffffacba5f44aca0
> kernel: FS:  00007fbe04321f00(0000) GS:ffffa1814ed80000(0000)
> knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 00007dfbebd7d000 CR3: 000801fb93d68002 CR4: 0000000000760ee0
> kernel: PKRU: 55555554
> kernel: Call Trace:
> kernel: sev_clflush_pages.part.56+0x50/0x70 [kvm_amd]
> kernel: svm_register_enc_region+0xe2/0x120 [kvm_amd]
> kernel: kvm_arch_vm_ioctl+0x524/0xbd0 [kvm]
> kernel: ? release_pages+0x212/0x430
> kernel: ? __pagevec_lru_add_fn+0x192/0x2f0
> kernel: kvm_vm_ioctl+0x9c/0x9d0 [kvm]
> kernel: ? __lru_cache_add+0x59/0x70
> kernel: ? lru_cache_add_active_or_unevictable+0x39/0xb0
> kernel: ? __handle_mm_fault+0xa74/0xfd0
> kernel: ? __switch_to_asm+0x34/0x70
> kernel: do_vfs_ioctl+0xa9/0x640
> kernel: ? __audit_syscall_entry+0xdd/0x130
> kernel: ksys_ioctl+0x67/0x90
> kernel: __x64_sys_ioctl+0x1a/0x20
> kernel: do_syscall_64+0x60/0x1d0
> kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
> kernel: RIP: 0033:0x7fbe0086563b
> kernel: Code: 0f 1e fa 48 8b 05 4d b8 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
> ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff
> 73 01 c3 48 8b 0d 1d b8 2c 00 f7 d8 64 89 01 48
> kernel: RSP: 002b:00007ffedf577418 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> kernel: RAX: ffffffffffffffda RBX: 00007dfbebe00000 RCX: 00007fbe0086563b
> kernel: RDX: 00007ffedf577490 RSI: ffffffff8010aebb RDI: 000000000000000d
> kernel: RBP: 000001c200000000 R08: ffffffffffffffff R09: ffffffffffffffff
> kernel: R10: ffffffffffffffff R11: 0000000000000246 R12: 000001c200000000
> kernel: R13: 00007dfbebe00000 R14: 0000000000000000 R15: 0000000000000000
> 
> The problem is the time spent flushing the caches when pinning memory for
> SEV but it's unnecessary as it turns out - it is resolved by backporting
> the following commits from Linux 5.10
> 
> e1ebb2b49048 KVM: SVM: Don't flush cache if hardware enforces cache coherency
> across encryption domains
> (conflict due to the function it fixed being moved in a refactoring in 5.7).
> 
> along with 3 other commits needed as dependencies.
> (fbd5969d1ff2 avoids a conflict in 5866e9205b47)
> 
> fbd5969d1ff2 x86/cpufeatures: Mark two free bits in word 3
> 5866e9205b47 x86/cpu: Add hardware-enforced cache coherency as a CPUID feature
> 75d1cc0e05af x86/mm/pat: Don't flush cache if hardware enforces cache coherency across encryption domnains                                                                                                        
> 
> Tested by creating various sized guests up to 1.8TB, with and without SEV enabled,
> running a few benchmarks and passing kvm-unit-tests.
> 
> 
> Borislav Petkov (1):
>   x86/cpufeatures: Mark two free bits in word 3
> 
> Krish Sadhukhan (3):
>   x86/cpu: Add hardware-enforced cache coherency as a CPUID feature
>   x86/mm/pat: Don't flush cache if hardware enforces cache coherency
>     across encryption domnains
>   KVM: SVM: Don't flush cache if hardware enforces cache coherency
>     across encryption domains
> 
>  arch/x86/include/asm/cpufeatures.h | 2 ++
>  arch/x86/kernel/cpu/scattered.c    | 1 +
>  arch/x86/kvm/svm.c                 | 3 ++-
>  arch/x86/mm/pageattr.c             | 2 +-
>  4 files changed, 6 insertions(+), 2 deletions(-)
> 
> -- 
> 2.27.0
> 

All now queued up, thanks!

greg k-h
