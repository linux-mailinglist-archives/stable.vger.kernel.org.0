Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5659629335
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 09:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiKOIXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 03:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKOIXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 03:23:19 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BA711828;
        Tue, 15 Nov 2022 00:23:17 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id AFEFA32009CA;
        Tue, 15 Nov 2022 03:23:14 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Tue, 15 Nov 2022 03:23:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1668500594; x=1668586994; bh=H5y7W61lqF
        YUGE6TQj7c/3Zmp9mShTInI16ioHw7osE=; b=Mm/Xft4g8RRygI97bABRS/8b8N
        tZ88eNgxPm16JNnD8wRgHMlhbDWhqdvfsJZVSbqwotARd8SYga5pBniQ4vpkyCUv
        xqlC2OrUtsnj5umUQDdd4b50E+OEZDz+87ewHy+WGeVRyHpmVEAm0iICnwW2sQq5
        9lBZgqLoVMDIhjD/vqilZj7NjmmMtRImDO9mI/b2adgsgu03BBERNuYf09VO2//h
        ShCG3KmM8jadFbzLnEabK72ks9qKF9LxqWqQuXlL5JkRY9WrZaIPXY/IElckXuvy
        BkRsJh6tCaqd+X9kVZVG9zrgR4s+2vgtahdsc6Hi2gyCfMjX7E8o6hYMpQsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668500594; x=1668586994; bh=H5y7W61lqFYUGE6TQj7c/3Zmp9mS
        hTInI16ioHw7osE=; b=VhwQBu5MxlURgb2su1hxRr2IlhVfrCbbhU/T1+PMDuO4
        2zZrY3ROp666Z64feWZeD9IDBDOrDHFTZ3td8eMyYLkUetAjsqMXrkvcDO7Cr7xl
        mNVDbxeptLR/CYBzBfP7Tkzbmcp3adaAmQrRJthTJkqBgKDESK4oX3oxPoXPa9fJ
        QJPZymbC9xqIuT92whcyRq7jN7o8M0VGdiN+uVqcIn4YT+Cp91ZjdRJZ6pp9O7mu
        LIjBNJfhQwQEEDJ7aM3dzn29yIiPmWj0lt50cfxGRhGKkrW/E7bV7RCKVpboF36E
        Fv8zKZqjnKusth52yMt9VWIVGVB0gvWTqf4Vf7U2Cg==
X-ME-Sender: <xms:ckxzY4q3Bpm_2pes40f0tgqf8QdyilXJF--HmzgjQcmKS8q6uXXz4A>
    <xme:ckxzY-o98FeAeFxngSyDRbiVL_uSbkrsnL0MkJxjtcjbjOQ3zLYNGE_ndp1pln0I9
    zBXDbRBIYvB7nS79ic>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeefgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhephfdtlefhtedttedvtedvueeugedvueelueduvefhuefhuefgvddtveevvdff
    hfdunecuffhomhgrihhnpehlihhnrghrohdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:ckxzY9PwAkDb5qk8c-GpLVsDSphyE5mTpMV_1TM19pdRhjXCdFLrXg>
    <xmx:ckxzY_6HBSfxcq8LUZ2XKIaqhddJLegePHQBP-h-sfwaTgQUDc1j3A>
    <xmx:ckxzY37f9HOypzwIup6RdvpGqqKoGyYb8nnfo2wGa8PnJzix-YJSHA>
    <xmx:ckxzY9TYtD_z2CKhnVuF0Uh5QYjsRNHWfydYbNqRRgXSVVEde_sPZA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 05600B60086; Tue, 15 Nov 2022 03:23:14 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <97c413be-1a24-4447-b7ea-fa81a3170765@app.fastmail.com>
In-Reply-To: <CA+G9fYuXG7Rh_A8W1NRVWbgWjozwzxzQY7tYw7bA4NsCuSovMg@mail.gmail.com>
References: <CA+G9fYuXG7Rh_A8W1NRVWbgWjozwzxzQY7tYw7bA4NsCuSovMg@mail.gmail.com>
Date:   Tue, 15 Nov 2022 09:22:53 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Ard Biesheuvel" <ardb@kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 1111 at arch/arm64/kernel/fpsimd.c:464
 fpsimd_save+0x170/0x1b0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022, at 08:27, Naresh Kamboju wrote:
> Following kernel warning noticed while running kselftest arm64 sve-ptrace
> on qemu-arm64 on ampere-altra server.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
>  /usr/bin/qemu-system-aarch64 -cpu max,pauth-impdef=on \
>  -machine virt-2.10 \
>  -nographic \
>  -net nic,model=virtio,macaddr=BA:DD:AD:FC:09:12 \
>  -net tap -m 4096 -monitor none \
>  -kernel Image.gz --append "console=ttyAMA0 root=/dev/vda rw"
>  -hda lkft-kselftest-image-juno-20221114150409.rootfs.ext4
>  -smp 4 -nographic

Hi Naresh,

Have you tried what happens if you run the same thing on an x86
machine? I would expect them to behave the same way, but it's
possible something goes wrong with the guest CPU if this ends
up using some (but not all) of the logic from KVM that would
use '-cpu host' instead of '-cpu max'. Note that the Neoverse
CPU in the Altra machine does not support SVE.

Other things you could easily try would use the same command
line as above, with the possible combinations of '-cpu host'
(replacing -cpu max) and '-enable-kvm'. Do you always get
the same result?

>
> Boot log:
> ---------
> [    0.000000] Linux version 6.0.9-rc1 (tuxmake@tuxmake)
> (aarch64-linux-gnu-gcc (Debian 11.3.0-6) 11.3.0, GNU ld (GNU Binutils
> for Debian) 2.39) #1 SMP PREEMPT @1668438377
> [    0.000000] random: crng init done
> [    0.000000] Machine model: linux,dummy-virt
>
>
> # selftests: arm64: sve-ptrace
> # ok 680 # SKIP SVE set FPSIMD get SVE for VL 2704
> # ok 681 Set SVE VL 2720
>
> [  422.607034] ------------[ cut here ]------------
> [  422.615382] WARNING: CPU: 0 PID: 1111 at
> arch/arm64/kernel/fpsimd.c:464 fpsimd_save+0x170/0x1b0
> [  422.617588] Modules linked in: cfg80211 bluetooth rfkill
> crct10dif_ce sm3_ce sm3 sha3_ce sha512_ce sha512_arm64 fuse drm
> [  422.619758] CPU: 0 PID: 1111 Comm: sve-ptrace Not tainted 6.0.9-rc1 #1
> [  422.620402] Hardware name: linux,dummy-virt (DT)
> [  422.620958] pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  422.621614] pc : fpsimd_save+0x170/0x1b0
> [  422.621988] lr : fpsimd_save+0xd8/0x1b0
> [  422.622307] sp : ffff800008f3bb00
> [  422.622612] x29: ffff800008f3bb00 x28: ffffae14dd664bc0 x27: 0000000000000001
> [  422.623519] x26: ffff0000ff773858 x25: 0000000000000000 x24: ffff0000c0994fa8
> [  422.624102] x23: 0000000000000001 x22: 0000000000000100 x21: ffff0000ff75f0b0
> [  422.624706] x20: ffff51ec22a8b000 x19: ffffae14dccd40b0 x18: 0000000000000000
> [  422.625292] x17: ffff51ec22a8b000 x16: 0000000000000000 x15: 0000000000000000
> [  422.626041] x14: 0000000000000003 x13: 0000000000000000 x12: 0000000000000002
> [  422.626647] x11: ffffae14ddbee840 x10: 0000000000000312 x9 : ffffae14da818210
> [  422.627326] x8 : ffff0000c09935c0 x7 : ffffae14de2b8d08 x6 : 0000000000000000
> [  422.627889] x5 : 000000c91075a4a8 x4 : 0000000000000000 x3 : 0000000000000001
> [  422.628487] x2 : ffff51ec22a8b000 x1 : 0000000000000204 x0 : 0000000000000010
> [  422.629203] Call trace:
> [  422.629579]  fpsimd_save+0x170/0x1b0
> [  422.630014]  fpsimd_thread_switch+0x2c/0xc4


This is the location of the WARN_ON(), it tests that the
vector size matches. If for some reason it takes the vector
size of the host CPU, this would warn.

        if (IS_ENABLED(CONFIG_ARM64_SVE) && save_sve_regs) {
                /* Get the configured VL from RDVL, will account for SM */
                if (WARN_ON(sve_get_vl() != vl)) {
                        /*


> [  422.630431]  __switch_to+0x20/0x160
> [  422.630745]  __schedule+0x380/0xb90
> [  422.631038]  preempt_schedule_irq+0x4c/0x130
> [  422.631386]  el1_interrupt+0x4c/0x64
> [  422.631689]  el1h_64_irq_handler+0x18/0x24
> [  422.632037]  el1h_64_irq+0x64/0x68
> [  422.632335]  do_page_fault+0x31c/0x4d0
> [  422.632660]  do_translation_fault+0xd8/0x100
> [  422.632993]  do_mem_abort+0x58/0xb0
> [  422.633311]  el0_ia+0x8c/0x134
> [  422.633685]  el0t_64_sync_handler+0x134/0x140
> [  422.634061]  el0t_64_sync+0x18c/0x190
> [  422.634580] irq event stamp: 654
> [  422.634923] hardirqs last  enabled at (653): [<ffffae14dbeafc94>]
> exit_to_kernel_mode+0x34/0x130
> [  422.635713] hardirqs last disabled at (654): [<ffffae14dbeb7700>]
> __schedule+0x3f0/0xb90
> [  422.636309] softirqs last  enabled at (650): [<ffffae14da810be4>]
> __do_softirq+0x514/0x62c
> [  422.636877] softirqs last disabled at (637): [<ffffae14da8b4f58>]
> __irq_exit_rcu+0x164/0x19c
> [  422.637446] ---[ end trace 0000000000000000 ]---
>
> Full test log:
> https://lkft.validation.linaro.org/scheduler/job/5847349#L2206
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.8-191-gf8896c3ebbcf/testrun/13007451/suite/log-parser-test/test/check-kernel-exception/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.8-191-gf8896c3ebbcf/testrun/13007451/suite/log-parser-test/test/check-kernel-exception/details/
