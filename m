Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC998622BFE
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiKIM6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKIM6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:58:20 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2A62CE3B;
        Wed,  9 Nov 2022 04:58:17 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id BD89F3200A99;
        Wed,  9 Nov 2022 07:58:14 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Wed, 09 Nov 2022 07:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1667998694; x=1668085094; bh=wA42gsmfP+
        zft1TKNKp6DGunIHjMi0fHjQktK73RxFc=; b=EhSXKP/ZuNHV+iTVJjk/Sv8FSU
        nN/eZjsogZPE+0edsuN89Z6vy/RcDFDYmeWIwvFILY13oCtVRiFTqrUBxKln2YN0
        llfYWen3wHGU/57fmrvi2+tE84KIL0UW9qm5jtdm2i0b21ujfgFMbiPOegIFdDKt
        iDmj4xaeux4hRvaMie+6G3ZZpkHEUesqw/g164r5tCLfQu3hry5wjdAyOcNRxdEt
        jB54qLVz5zhK+6JPnJT8wYydq8HJ/nGlNR4joTisSCq63vUgbCasB4Z2eRa7fZdu
        tEcv0/UYcGibIDK1XBeSAoKsgcndIBqtq3AEHKp2IWv5Lrb13ttMVdHinJGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667998694; x=1668085094; bh=wA42gsmfP+zft1TKNKp6DGunIHjM
        i0fHjQktK73RxFc=; b=CTrPcziBRGiUFfVD6wp3rIn3hx6Q5N5K/ImW0K3UgcPT
        9KI/ehEMIT1o/XDdhgtdYANk8PxlACHtin3PpmKzAcHjbu4LWqM8DSO4wnKFpdys
        2rtRoLlPcFef9QFPgy6daHDACIa8K28Xq6n5+9h2Rnt3PfnEciVWTnMgVXTqQ/IH
        +FVu94R3XwjgyBW0E4tefy2TG/9OxHR/+RcWORVt4t6LcEt8KKss4lrThy6UeoJN
        measWq3zAtoop2PShO7HUc3LdwdB3P2h/XZC4+pmdPNUp56bIp78TS+gqri4E0bn
        Qlfr+nF8IBaU0BxQaAfVX8aiLuTwLYcOGwQycYxBUQ==
X-ME-Sender: <xms:5qNrY-stcmZrUMLYPJGTq0i7v2qMiTwJ7NnERaddZ8QfgDaXkqpNpg>
    <xme:5qNrYzfLeJrCJBZxO66PrbVUL3MHkRyz2ZDXHuKsXUw6Yg-X8m9h7_T-SmQNRpd-Y
    D1LmElNLlsmZzeSvhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedvgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:5qNrY5xIFky1Yymi0eLeL9Wf_UlX-3iR_bJ35S6LyE32x8pWlbIO8Q>
    <xmx:5qNrY5N-bOccqePZ27QE_q0PhI9qhFtpe9TWH9cBp-sTDZAWZNa2RA>
    <xmx:5qNrY--6sWjkxaozIlGpIkqZmNb2SCcM-jV3IQ_ob2ujZZxmg1uokw>
    <xmx:5qNrYzORl9GnOGQJNomQPnVtA2x5Ei2toRx8SIGJRL-AkYgYpkK7DQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1B1B4B60086; Wed,  9 Nov 2022 07:58:13 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <29824864-f076-401f-bfb4-bc105bb2d38f@app.fastmail.com>
In-Reply-To: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
References: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
Date:   Wed, 09 Nov 2022 13:57:53 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <sashal@kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>
Subject: Re: arm: TI BeagleBoard X15 : Unable to handle kernel NULL pointer dereference
 at virtual address 00000369 - Internal error: Oops: 5 [#1] SMP ARM
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 9, 2022, at 12:10, Naresh Kamboju wrote:
> Following kernel oops found while booting arm 32 bit x15 device with
> kselftest configs enabled on stable-rc linux-5.15. This is specific
> to kselftest merge config build booting on arm TI BeagleBoard X15
> device.
>
> This is an intermittent issue and not specific to current stable rc
> release.

I've done an analysis here, and mostly understand the problem, but
don't have a good solution yet.
> [    5.414093] PC is at do_page_fault+0x94/0x464
> [    5.418487] LR is at do_translation_fault+0xc0/0xc4
> [    5.423400] pc : [<c15cdbb0>]    lr : [<c15ce040>]    psr: 20000193

I looked up do_page_fault+0x94/0x464, this is "current->mm":

c15cdb98:       e1a0300d        mov     r3, sp
c15cdb9c:       e3c33d7f        bic     r3, r3, #8128   ; 0x1fc0
c15cdba0:       e5942040        ldr     r2, [r4, #64]   ; 0x40
c15cdba4:       e3c3303f        bic     r3, r3, #63     ; 0x3f
c15cdba8:       e3120080        tst     r2, #128        ; 0x80
c15cdbac:       e5932008        ldr     r2, [r3, #8]
c15cdbb0:       e5927368        ldr     r7, [r2, #872]  ; 0x368 <== crash

> [    5.429687] sp : c31ce020  ip : ffffe000  fp : c31ce06c
> [    5.434936] r10: 00003b9a  r9 : c31ce000  r8 : 00000000
> [    5.440216] r7 : c2110e10  r6 : 00000665  r5 : 00000005  r4 : c31ce0c8
> [    5.446777] r3 : c31ce000  r2 : 00000001  r1 : 2ca6c000  r0 : 00000665

So r3 is the current stack bottom, which holds "current", and it's
also the stack pointer, so the entire 8KB stack has been
exhausted at this point, and the thread_info been overwritten
as a result.

> [    5.530273] Register r12 information: non-paged memory
> [    5.535430] Process kworker/0:0H (pid: 8, stack limit = 0x(ptrval))
> [    5.541748] Stack: (0xc31ce020 to 0xc31ce000)
> [    5.546142] Backtrace:
> ...
> [    7.896820] Code: e5942040 e3c3303f e3120080 e5932008 (e5927368)
> [    7.902954] ---[ end trace 86f7fd8d70b6f6f9 ]---

Unfortunately you have skipped the interesting bit, but I found
it in the log download:

[    5.546142] Backtrace: 
[    5.548583] [<c15cdb1c>] (do_page_fault) from [<c15ce040>] (do_translation_fault+0xc0/0xc4)
[    5.557006]  r10:00003b9a r9:c31ce000 r8:00000000 r7:c2110e10 r6:c31ce0c8 r5:00000665
[    5.564880]  r4:00000005
[    5.567413] [<c15cdf80>] (do_translation_fault) from [<c0319c14>] (do_DataAbort+0x4c/0xcc)
[    5.575744]  r7:c2110e10 r6:c31ce0c8 r5:00000665 r4:00000005
[    5.581451] [<c0319bc8>] (do_DataAbort) from [<c0300b2c>] (__dabt_svc+0x4c/0x80)
[    5.588897] Exception stack(0xc31ce0c8 to 0xc31ce110)
[    5.593963] e0c0:                   00000000 00000001 c209e5e0 ffffe000 c29e2338 00000000
[    5.602203] e0e0: c209e5e0 ffffffff 00000000 c219be88 00003b9a c31ce144 c31ce148 c31ce118
[    5.610412] e100: c0427874 c15c142c 60000193 ffffffff
[    5.615509]  r8:00000000 r7:c31ce0fc r6:ffffffff r5:60000193 r4:c15c142c
[    5.622253] [<c15c13bc>] (lock_is_held_type) from [<c0427874>] (timekeeping_advance+0x7dc/0x93c)
[    5.631103]  r10:00003b9a r9:ca000000 r8:00000000 r7:00003b9a r6:ca000000 r5:00000000
[    5.638977]  r4:c29e2338 r3:c219bc80
[    5.642547] [<c0427098>] (timekeeping_advance) from [<c042a720>] (update_wall_time+0x1c/0x2c)
[    5.651153]  r10:c2105d44 r9:00000000 r8:00000000 r7:00989680 r6:00000001 r5:c2105d44
[    5.659027]  r4:c29e2ee0
[    5.661560] [<c042a704>] (update_wall_time) from [<c043b19c>] (tick_do_update_jiffies64+0x210/0x310)
[    5.670776] [<c043af8c>] (tick_do_update_jiffies64) from [<c043b480>] (tick_sched_timer+0xf0/0x100)
[    5.679870]  r10:c31ce000 r9:eeb0ba40 r8:eeb0baa0 r7:c31ce430 r6:3ee3574e r5:00000001
[    5.687744]  r4:eeb0bfe0
[    5.690277] [<c043b390>] (tick_sched_timer) from [<c042436c>] (__hrtimer_run_queues+0x2b8/0x5b4)
[    5.699127]  r9:eeb0ba40 r8:eeb0baa0 r7:00000000 r6:c236d9e0 r5:c2108f90 r4:eeb0bfe0
[    5.706909] [<c04240b4>] (__hrtimer_run_queues) from [<c0425054>] (hrtimer_interrupt+0x148/0x2dc)
[    5.715850]  r10:eeb0bb98 r9:eeb0bb58 r8:eeb0bb18 r7:eeb0bb60 r6:eeb0bba0 r5:20000193
[    5.723724]  r4:eeb0ba40
[    5.726257] [<c0424f0c>] (hrtimer_interrupt) from [<c123bdbc>] (dmtimer_clockevent_interrupt+0x34/0x3c)
[    5.735717]  r10:0000001a r9:c318b800 r8:00000000 r7:c2108f90 r6:c31ce000 r5:c31ce000
[    5.743591]  r4:c31af0c0
[    5.746154] [<c123bd88>] (dmtimer_clockevent_interrupt) from [<c03ee960>] (__handle_irq_event_percpu+0x140/0x380)
[    5.756469] [<c03ee820>] (__handle_irq_event_percpu) from [<c03eec94>] (handle_irq_event+0x6c/0xcc)
[    5.765594]  r10:00000064 r9:c31ce430 r8:fa21200c r7:c318b86c r6:c221c994 r5:c31ce000
[    5.773468]  r4:c318b800
[    5.776000] [<c03eec28>] (handle_irq_event) from [<c03f4120>] (handle_fasteoi_irq+0xac/0x198)
[    5.784606]  r7:000000be r6:c221c994 r5:c318b86c r4:c318b800
[    5.790283] [<c03f4074>] (handle_fasteoi_irq) from [<c03edfe8>] (handle_domain_irq+0x6c/0x88)
[    5.798858]  r7:000000be r6:00000000 r5:00000000 r4:c20a5998
[    5.804565] [<c03edf7c>] (handle_domain_irq) from [<c03018ac>] (gic_handle_irq+0x9c/0xbc)
[    5.812805]  r7:c20a59bc r6:fa212000 r5:c221b400 r4:c2109b58
[    5.818481] [<c0301810>] (gic_handle_irq) from [<c0300bc0>] (__irq_svc+0x60/0x80)
[    5.826019] Exception stack(0xc31ce430 to 0xc31ce478)
[    5.831085] e420:                                     9af0c982 9af0c982 00000001 0004545b
[    5.839324] e440: 00000000 eeb13440 eeb13450 00000000 c3582dc0 00000001 00000064 c31ce4bc
[    5.847534] e460: c31ce458 c31ce480 c049a668 c03965e4 60000013 ffffffff
[    5.854187]  r9:c31ce000 r8:c3582dc0 r7:c31ce464 r6:ffffffff r5:60000013 r4:c03965e4
[    5.861968] [<c03964f8>] (finish_task_switch) from [<c15c4018>] (__schedule+0x470/0xed0)
[    5.870117]  r10:00000064 r9:c2109acc r8:00000000 r7:eeb13450 r6:c3210000 r5:c210e240
[    5.877990]  r4:eeb13440
[    5.880554] [<c15c3ba8>] (__schedule) from [<c15c4b04>] (schedule+0x8c/0x160)
[    5.887725]  r10:00000064 r9:c2108f90 r8:c236d900 r7:c31ce548 r6:c2105d00 r5:c3210000
[    5.895599]  r4:c31ce000
[    5.898162] [<c15c4a78>] (schedule) from [<c15cbc24>] (schedule_timeout+0xd8/0x254)
[    5.905853]  r5:c31ce000 r4:ffff8d4a
[    5.909454] [<c15cbb4c>] (schedule_timeout) from [<c15c56cc>] (do_wait_for_common+0xb0/0x168)
[    5.918060]  r10:00000064 r9:c31ce000 r8:00000000 r7:c15cbb4c r6:00000002 r5:c4ca7850
[    5.925903]  r4:c4ca7854
[    5.928466] [<c15c561c>] (do_wait_for_common) from [<c15c5834>] (wait_for_completion_timeout+0x54/0x68)
[    5.937927]  r10:fa0700a4 r9:00000190 r8:00000001 r7:00000000 r6:c4ca7854 r5:00000064
[    5.945800]  r4:c4ca7850
[    5.948333] [<c15c57e0>] (wait_for_completion_timeout) from [<c1120758>] (omap_i2c_xfer_common+0x430/0x650)
[    5.958160]  r7:00000000 r6:00000001 r5:c31ce720 r4:c4ca7840
[    5.963836] [<c1120328>] (omap_i2c_xfer_common) from [<c11209b4>] (omap_i2c_xfer_irq+0x1c/0x20)
[    5.972595]  r10:c2108f40 r9:c2105d00 r8:c31ce714 r7:00000000 r6:00000002 r5:ffff8ce6
[    5.980468]  r4:c4ca78a8
[    5.983032] [<c1120998>] (omap_i2c_xfer_irq) from [<c1106fe0>] (__i2c_transfer+0x19c/0xa68)
[    5.991424] [<c1106e44>] (__i2c_transfer) from [<c1107958>] (i2c_transfer+0xac/0x148)
[    5.999298]  r10:c4e4a888 r9:00000001 r8:c0d55f98 r7:c2108f90 r6:c31ce714 r5:00000002
[    6.007171]  r4:c4ca78a8
[    6.009735] [<c11078ac>] (i2c_transfer) from [<c0d56008>] (regmap_i2c_read+0x70/0xa0)
[    6.017608]  r6:00000001 r5:00000000 r4:c31ce000
[    6.022247] [<c0d55f98>] (regmap_i2c_read) from [<c0d508f8>] (_regmap_raw_read+0x148/0x440)
[    6.030670]  r5:c23723e0 r4:c4eb9c00
[    6.034271] [<c0d507b0>] (_regmap_raw_read) from [<c0d50c44>] (_regmap_bus_read+0x54/0x80)
[    6.042602]  r10:c4e4a888 r9:00000001 r8:c31ce843 r7:c31ce810 r6:c4e7fa41 r5:00000054
[    6.050476]  r4:c4eb9c00
[    6.053009] [<c0d50bf0>] (_regmap_bus_read) from [<c0d4f2e8>] (_regmap_read+0x74/0x23c)
[    6.061065]  r7:c31ce810 r6:c4eb9c00 r5:00000054 r4:c4eb9c00
[    6.066741] [<c0d4f274>] (_regmap_read) from [<c0d4f4fc>] (regmap_read+0x4c/0x70)
[    6.074279]  r10:c4e4a888 r9:00000001 r8:c31ce843 r7:c31ce000 r6:c31ce810 r5:00000054
[    6.082153]  r4:c4eb9c00
[    6.084716] [<c0d4f4b0>] (regmap_read) from [<c0bcbba4>] (palmas_is_enabled_ldo+0x68/0x8c)
[    6.093048]  r7:c31ce000 r6:c31ce83c r5:0000000d r4:c31ce000
[    6.098724] [<c0bcbb3c>] (palmas_is_enabled_ldo) from [<c0bbb170>] (print_constraints_debug+0x374/0x4b4)
[    6.108276]  r5:c4e4a800 r4:00000098
[    6.111877] [<c0bbadfc>] (print_constraints_debug) from [<c0bbd418>] (set_machine_constraints+0x2cc/0xadc)
[    6.121582]  r10:00000000 r9:001b7740 r8:001b7740 r7:c4e8e100 r6:c4e89680 r5:c31ce000
[    6.129455]  r4:c4e4a800
[    6.132019] [<c0bbd14c>] (set_machine_constraints) from [<c0bbe634>] (regulator_register+0xa0c/0xc8c)
[    6.141296]  r10:c362dc40 r9:00000000 r8:00000000 r7:c362ac40 r6:c4e4a800 r5:c31cea90
[    6.149169]  r4:c23804d8
[    6.151702] [<c0bbdc28>] (regulator_register) from [<c0bc09d4>] (devm_regulator_register+0x5c/0x98)
[    6.160797]  r10:c362dc40 r9:00000104 r8:c362dc74 r7:c31cea90 r6:c4ebb010 r5:c31b4cac
[    6.168670]  r4:c4e89640
[    6.171234] [<c0bc0978>] (devm_regulator_register) from [<c0bcd1b8>] (palmas_ldo_registration+0x168/0x510)
[    6.180938]  r7:c22e37b4 r6:c22e36d4 r5:0000000d r4:c31b4ca4
[    6.186645] [<c0bcd050>] (palmas_ldo_registration) from [<c0bccaa8>] (palmas_regulators_probe+0x3ec/0x484)
[    6.196350]  r10:c22e37b4 r9:c22e394c r8:00000208 r7:c362dc40 r6:c31b4040 r5:c0bcc238
[    6.204223]  r4:c0bcd050
[    6.206787] [<c0bcc6bc>] (palmas_regulators_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
[    6.215545]  r10:eeb705b4 r9:c2a12044 r8:0000004d r7:c2382248 r6:c22e35b0 r5:c4ebb010
[    6.223419]  r4:00000000
[    6.225952] [<c0d291f0>] (platform_probe) from [<c0d25e80>] (really_probe+0xe8/0x4a0)
[    6.233856]  r7:c2382248 r6:c22e35b0 r5:00000000 r4:c4ebb010
[    6.239532] [<c0d25d98>] (really_probe) from [<c0d262e8>] (__driver_probe_device+0xb0/0x214)
[    6.248016]  r7:c4ebb010 r6:c2382248 r5:c22e35b0 r4:c4ebb010
[    6.253723] [<c0d26238>] (__driver_probe_device) from [<c0d26490>] (driver_probe_device+0x44/0xd4)
[    6.262725]  r9:c2a12044 r8:0000004d r7:c4ebb010 r6:c31cec24 r5:c2a120b4 r4:c2a120b0
[    6.270507] [<c0d2644c>] (driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
[    6.279724]  r9:c2a12044 r8:00000001 r7:c4ebb010 r6:c31cec24 r5:c22e35b0 r4:00000001
[    6.287506] [<c0d26ae4>] (__device_attach_driver) from [<c0d236bc>] (bus_for_each_drv+0x94/0xd8)
[    6.296356]  r7:c0d26ae4 r6:c31ce000 r5:c31cec24 r4:00000000
[    6.302032] [<c0d23628>] (bus_for_each_drv) from [<c0d2678c>] (__device_attach+0xc4/0x224)
[    6.310363]  r7:c4ebb0a0 r6:c4ebb010 r5:c31ce000 r4:c4ebb010
[    6.316040] [<c0d266c8>] (__device_attach) from [<c0d26e30>] (device_initial_probe+0x1c/0x20)
[    6.324615]  r8:c2381fc0 r7:c4eb9020 r6:c4ebb010 r5:c22f8650 r4:c4ebb010
[    6.331359] [<c0d26e14>] (device_initial_probe) from [<c0d24c0c>] (bus_probe_device+0x98/0xa0)
[    6.340026] [<c0d24b74>] (bus_probe_device) from [<c0d21db8>] (device_add+0x404/0x970)
[    6.347991]  r7:c4eb9020 r6:c31ce000 r5:00000000 r4:c4ebb010
[    6.353698] [<c0d219b4>] (device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
[    6.361236]  r10:00000000 r9:00000001 r8:eeb705fc r7:00000000 r6:00000000 r5:c4eb9020
[    6.369110]  r4:c4ebb000
[    6.371643] [<c1254b64>] (of_device_add) from [<c12552c4>] (of_platform_device_create_pdata+0xa4/0xd4)
[    6.381011] [<c1255220>] (of_platform_device_create_pdata) from [<c12554fc>] (of_platform_bus_create+0x1e4/0x544)
[    6.391357]  r9:00000001 r8:c4eb9020 r7:00000000 r6:c31ce000 r5:00000000 r4:eeb70598
[    6.399139] [<c1255318>] (of_platform_bus_create) from [<c1255a68>] (of_platform_populate+0xa8/0x144)
[    6.408416]  r10:c1d7e250 r9:00000001 r8:c4eb9020 r7:00000000 r6:00000000 r5:eeb70290
[    6.416290]  r4:eeb70598
[    6.418823] [<c12559c0>] (of_platform_populate) from [<c1255b94>] (devm_of_platform_populate+0x60/0xa8)
[    6.428283]  r10:c1d7e250 r9:c183be94 r8:00000002 r7:c4e7abc0 r6:00000000 r5:c4e30240
[    6.436157]  r4:c4eb9020
[    6.438690] [<c1255b34>] (devm_of_platform_populate) from [<c0d8218c>] (palmas_i2c_probe+0x4a4/0x61c)
[    6.447967]  r6:00000000 r5:00000000 r4:c4de0740
[    6.452606] [<c0d81ce8>] (palmas_i2c_probe) from [<c1106e14>] (i2c_device_probe+0x304/0x334)
[    6.461120]  r10:eeb702ac r9:c2a12044 r8:c0d81ce8 r7:c4eb9004 r6:c4eb9000 r5:00000000
[    6.468994]  r4:c4eb9020
[    6.471527] [<c1106b10>] (i2c_device_probe) from [<c0d25e80>] (really_probe+0xe8/0x4a0)
[    6.479583]  r9:c2a12044 r8:0000004b r7:c2382248 r6:c22ff95c r5:00000000 r4:c4eb9020
[    6.487365] [<c0d25d98>] (really_probe) from [<c0d262e8>] (__driver_probe_device+0xb0/0x214)
[    6.495880]  r7:c4eb9020 r6:c2382248 r5:c22ff95c r4:c4eb9020
[    6.501556] [<c0d26238>] (__driver_probe_device) from [<c0d26490>] (driver_probe_device+0x44/0xd4)
[    6.510589]  r9:c2a12044 r8:0000004b r7:c4eb9020 r6:c31cef5c r5:c2a120b4 r4:c2a120b0
[    6.518371] [<c0d2644c>] (driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
[    6.527557]  r9:c2a12044 r8:00000001 r7:c4eb9020 r6:c31cef5c r5:c22ff95c r4:00000001
[    6.535339] [<c0d26ae4>] (__device_attach_driver) from [<c0d236bc>] (bus_for_each_drv+0x94/0xd8)
[    6.544189]  r7:c0d26ae4 r6:c31ce000 r5:c31cef5c r4:00000000
[    6.549865] [<c0d23628>] (bus_for_each_drv) from [<c0d2678c>] (__device_attach+0xc4/0x224)
[    6.558197]  r7:c4eb90b0 r6:c4eb9020 r5:c31ce000 r4:c4eb9020
[    6.563873] [<c0d266c8>] (__device_attach) from [<c0d26e30>] (device_initial_probe+0x1c/0x20)
[    6.572448]  r8:c2381fc0 r7:c4ca7950 r6:c4eb9020 r5:c23278cc r4:c4eb9020
[    6.579193] [<c0d26e14>] (device_initial_probe) from [<c0d24c0c>] (bus_probe_device+0x98/0xa0)
[    6.587860] [<c0d24b74>] (bus_probe_device) from [<c0d21db8>] (device_add+0x404/0x970)
[    6.595825]  r7:c4ca7950 r6:c31ce000 r5:00000000 r4:c4eb9020
[    6.601531] [<c0d219b4>] (device_add) from [<c0d22348>] (device_register+0x24/0x28)
[    6.609252]  r10:c2329274 r9:c4eb9020 r8:c4eb9004 r7:00000000 r6:c4ca78a8 r5:c31cf074
[    6.617095]  r4:c4eb9020
[    6.619659] [<c0d22324>] (device_register) from [<c1107cbc>] (i2c_new_client_device+0x170/0x2b0)
[    6.628509]  r5:c31cf074 r4:c4eb9000
[    6.632110] [<c1107b4c>] (i2c_new_client_device) from [<c110c1a4>] (of_i2c_register_device+0x8c/0xd0)
[    6.641387]  r9:c2392550 r8:c4ca78a8 r7:c4ca7950 r6:eeb70290 r5:c31ce000 r4:00000000
[    6.649169] [<c110c118>] (of_i2c_register_device) from [<c110c5d8>] (of_i2c_register_devices+0x90/0x104)
[    6.658721]  r8:c1dea1d8 r7:c4ca78a8 r6:eeb70018 r5:eeb702f4 r4:eeb70290
[    6.665435] [<c110c548>] (of_i2c_register_devices) from [<c1108714>] (i2c_register_adapter+0x2d4/0x768)
[    6.674896]  r9:c2392550 r8:c2329274 r7:c4ca7950 r6:c2a1e5ac r5:00000000 r4:c4ca78a8
[    6.682678] [<c1108440>] (i2c_register_adapter) from [<c1108c08>] (__i2c_add_numbered_adapter+0x60/0xa8)
[    6.692230]  r10:00000009 r9:00000009 r8:00000000 r7:c4d26010 r6:c31ce000 r5:c4ca78a8
[    6.700103]  r4:00000000
[    6.702636] [<c1108ba8>] (__i2c_add_numbered_adapter) from [<c1108cf8>] (i2c_add_adapter+0xa8/0xe0)
[    6.711761]  r5:c4ca78a8 r4:c4ca7840
[    6.715332] [<c1108c50>] (i2c_add_adapter) from [<c1108dbc>] (i2c_add_numbered_adapter+0x2c/0x30)
[    6.724273]  r5:c4d26000 r4:c4ca7840
[    6.727874] [<c1108d90>] (i2c_add_numbered_adapter) from [<c111ff04>] (omap_i2c_probe+0x39c/0x710)
[    6.736877] [<c111fb68>] (omap_i2c_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
[    6.744873]  r10:eeb70034 r9:c2a12044 r8:0000004b r7:c2382248 r6:c2329220 r5:c4d26010
[    6.752716]  r4:00000000
[    6.755279] [<c0d291f0>] (platform_probe) from [<c0d25e80>] (really_probe+0xe8/0x4a0)
[    6.763153]  r7:c2382248 r6:c2329220 r5:00000000 r4:c4d26010
[    6.768859] [<c0d25d98>] (really_probe) from [<c0d262e8>] (__driver_probe_device+0xb0/0x214)
[    6.777343]  r7:c4d26010 r6:c2382248 r5:c2329220 r4:c4d26010
[    6.783020] [<c0d26238>] (__driver_probe_device) from [<c0d26490>] (driver_probe_device+0x44/0xd4)
[    6.792053]  r9:c2a12044 r8:0000004b r7:c4d26010 r6:c31cf2d4 r5:c2a120b4 r4:c2a120b0
[    6.799835] [<c0d2644c>] (driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
[    6.809020]  r9:c2a12044 r8:00000001 r7:c4d26010 r6:c31cf2d4 r5:c2329220 r4:00000001
[    6.816802] [<c0d26ae4>] (__device_attach_driver) from [<c0d236bc>] (bus_for_each_drv+0x94/0xd8)
[    6.825653]  r7:c0d26ae4 r6:c31ce000 r5:c31cf2d4 r4:00000000
[    6.831329] [<c0d23628>] (bus_for_each_drv) from [<c0d2678c>] (__device_attach+0xc4/0x224)
[    6.839660]  r7:c4d260a0 r6:c4d26010 r5:c31ce000 r4:c4d26010
[    6.845336] [<c0d266c8>] (__device_attach) from [<c0d26e30>] (device_initial_probe+0x1c/0x20)
[    6.853942]  r8:c2381fc0 r7:c4d24810 r6:c4d26010 r5:c22f8650 r4:c4d26010
[    6.860656] [<c0d26e14>] (device_initial_probe) from [<c0d24c0c>] (bus_probe_device+0x98/0xa0)
[    6.869323] [<c0d24b74>] (bus_probe_device) from [<c0d21db8>] (device_add+0x404/0x970)
[    6.877319]  r7:c4d24810 r6:c31ce000 r5:00000000 r4:c4d26010
[    6.882995] [<c0d219b4>] (device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
[    6.890533]  r10:c2125be0 r9:c2125d40 r8:eeb7007c r7:00000000 r6:00000000 r5:c4d24810
[    6.898406]  r4:c4d26000
[    6.900939] [<c1254b64>] (of_device_add) from [<c12552c4>] (of_platform_device_create_pdata+0xa4/0xd4)
[    6.910308] [<c1255220>] (of_platform_device_create_pdata) from [<c12554fc>] (of_platform_bus_create+0x1e4/0x544)
[    6.920654]  r9:c2125d40 r8:c2125be0 r7:00000000 r6:c31ce000 r5:00000000 r4:eeb70018
[    6.928436] [<c1255318>] (of_platform_bus_create) from [<c1255a68>] (of_platform_populate+0xa8/0x144)
[    6.937713]  r10:0000021f r9:00000001 r8:c4d24810 r7:c2125be0 r6:c1670da0 r5:eeb6fc88
[    6.945587]  r4:eeb70018
[    6.948120] [<c12559c0>] (of_platform_populate) from [<c09f8e4c>] (sysc_probe+0x1094/0x17b4)
[    6.956634]  r10:0000021f r9:c4d24810 r8:00000000 r7:c4d24810 r6:c31ce000 r5:c29fde30
[    6.964477]  r4:c4bf4440
[    6.967041] [<c09f7db8>] (sysc_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
[    6.974670]  r10:eeb6fca4 r9:c2a12044 r8:0000004b r7:c2382248 r6:c221e450 r5:c4d24810
[    6.982543]  r4:00000000
[    6.985076] [<c0d291f0>] (platform_probe) from [<c0d25e80>] (really_probe+0xe8/0x4a0)
[    6.992980]  r7:c2382248 r6:c221e450 r5:00000000 r4:c4d24810
[    6.998657] [<c0d25d98>] (really_probe) from [<c0d262e8>] (__driver_probe_device+0xb0/0x214)
[    7.007141]  r7:c4d24810 r6:c2382248 r5:c221e450 r4:c4d24810
[    7.012847] [<c0d26238>] (__driver_probe_device) from [<c0d26490>] (driver_probe_device+0x44/0xd4)
[    7.021850]  r9:c2a12044 r8:0000004b r7:c4d24810 r6:c31cf5f4 r5:c2a120b4 r4:c2a120b0
[    7.029632] [<c0d2644c>] (driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
[    7.038818]  r9:c2a12044 r8:00000001 r7:c4d24810 r6:c31cf5f4 r5:c221e450 r4:00000001
[    7.046600] [<c0d26ae4>] (__device_attach_driver) from [<c0d236bc>] (bus_for_each_drv+0x94/0xd8)
[    7.055450]  r7:c0d26ae4 r6:c31ce000 r5:c31cf5f4 r4:00000000
[    7.061157] [<c0d23628>] (bus_for_each_drv) from [<c0d2678c>] (__device_attach+0xc4/0x224)
[    7.069458]  r7:c4d248a0 r6:c4d24810 r5:c31ce000 r4:c4d24810
[    7.075164] [<c0d266c8>] (__device_attach) from [<c0d26e30>] (device_initial_probe+0x1c/0x20)
[    7.083740]  r8:c2381fc0 r7:c4eb6010 r6:c4d24810 r5:c22f8650 r4:c4d24810
[    7.090454] [<c0d26e14>] (device_initial_probe) from [<c0d24c0c>] (bus_probe_device+0x98/0xa0)
[    7.099121] [<c0d24b74>] (bus_probe_device) from [<c0d21db8>] (device_add+0x404/0x970)
[    7.107116]  r7:c4eb6010 r6:c31ce000 r5:00000000 r4:c4d24810
[    7.112792] [<c0d219b4>] (device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
[    7.120330]  r10:c2125be0 r9:c2125d40 r8:eeb6fcec r7:c2125d6c r6:00000000 r5:c4eb6010
[    7.128204]  r4:c4d24800
[    7.130737] [<c1254b64>] (of_device_add) from [<c12552c4>] (of_platform_device_create_pdata+0xa4/0xd4)
[    7.140106] [<c1255220>] (of_platform_device_create_pdata) from [<c12554fc>] (of_platform_bus_create+0x1e4/0x544)
[    7.150451]  r9:c2125d40 r8:c2125d10 r7:00000000 r6:c31ce000 r5:00000000 r4:eeb6fc88
[    7.158233] [<c1255318>] (of_platform_bus_create) from [<c1255a68>] (of_platform_populate+0xa8/0x144)
[    7.167510]  r10:00000000 r9:00000001 r8:c4eb6010 r7:c2125be0 r6:00000000 r5:eeb68c24
[    7.175384]  r4:eeb6fc88
[    7.177917] [<c12559c0>] (of_platform_populate) from [<c09f5dd4>] (simple_pm_bus_probe+0xb4/0xd8)
[    7.186859]  r10:eeb68c40 r9:c2a12044 r8:0000002c r7:c2382248 r6:c2125be0 r5:eeb68c24
[    7.194732]  r4:c4eb6010
[    7.197265] [<c09f5d20>] (simple_pm_bus_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
[    7.205688]  r7:c2382248 r6:c221e3dc r5:c4eb6010 r4:00000000
[    7.211364] [<c0d291f0>] (platform_probe) from [<c0d25e80>] (really_probe+0xe8/0x4a0)
[    7.219238]  r7:c2382248 r6:c221e3dc r5:00000000 r4:c4eb6010
[    7.224945] [<c0d25d98>] (really_probe) from [<c0d262e8>] (__driver_probe_device+0xb0/0x214)
[    7.233428]  r7:c4eb6010 r6:c2382248 r5:c221e3dc r4:c4eb6010
[    7.239135] [<c0d26238>] (__driver_probe_device) from [<c0d26490>] (driver_probe_device+0x44/0xd4)
[    7.248138]  r9:c2a12044 r8:0000002c r7:c4eb6010 r6:c31cf8bc r5:c2a120b4 r4:c2a120b0
[    7.255920] [<c0d2644c>] (driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
[    7.265106]  r9:c2a12044 r8:00000001 r7:c4eb6010 r6:c31cf8bc r5:c221e3dc r4:00000001
[    7.272918] [<c0d26ae4>] (__device_attach_driver) from [<c0d236bc>] (bus_for_each_drv+0x94/0xd8)
[    7.281738]  r7:c0d26ae4 r6:c31ce000 r5:c31cf8bc r4:00000000
[    7.287445] [<c0d23628>] (bus_for_each_drv) from [<c0d2678c>] (__device_attach+0xc4/0x224)
[    7.295745]  r7:c4eb60a0 r6:c4eb6010 r5:c31ce000 r4:c4eb6010
[    7.301452] [<c0d266c8>] (__device_attach) from [<c0d26e30>] (device_initial_probe+0x1c/0x20)
[    7.310028]  r8:c2381fc0 r7:c4eb4410 r6:c4eb6010 r5:c22f8650 r4:c4eb6010
[    7.316772] [<c0d26e14>] (device_initial_probe) from [<c0d24c0c>] (bus_probe_device+0x98/0xa0)
[    7.325439] [<c0d24b74>] (bus_probe_device) from [<c0d21db8>] (device_add+0x404/0x970)
[    7.333404]  r7:c4eb4410 r6:c31ce000 r5:00000000 r4:c4eb6010
[    7.339080] [<c0d219b4>] (device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
[    7.346618]  r10:c2125be0 r9:c2125d00 r8:eeb68c88 r7:c2125be0 r6:00000000 r5:c4eb4410
[    7.354492]  r4:c4eb6000
[    7.357055] [<c1254b64>] (of_device_add) from [<c12552c4>] (of_platform_device_create_pdata+0xa4/0xd4)
[    7.366394] [<c1255220>] (of_platform_device_create_pdata) from [<c12554fc>] (of_platform_bus_create+0x1e4/0x544)
[    7.376739]  r9:c2125d00 r8:c2125be0 r7:00000000 r6:c31ce000 r5:00000000 r4:eeb68c24
[    7.384521] [<c1255318>] (of_platform_bus_create) from [<c1255a68>] (of_platform_populate+0xa8/0x144)
[    7.393798]  r10:eeb6892c r9:00000001 r8:c4eb4410 r7:c2125be0 r6:00000000 r5:eeb68910
[    7.401672]  r4:eeb68c24
[    7.404205] [<c12559c0>] (of_platform_populate) from [<c09f5dd4>] (simple_pm_bus_probe+0xb4/0xd8)
[    7.413146]  r10:eeb6892c r9:c2a12044 r8:0000002c r7:c2382248 r6:c2125be0 r5:eeb68910
[    7.421020]  r4:c4eb4410
[    7.423553] [<c09f5d20>] (simple_pm_bus_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
[    7.431976]  r7:c2382248 r6:c221e3dc r5:c4eb4410 r4:00000000
[    7.437652] [<c0d291f0>] (platform_probe) from [<c0d25e80>] (really_probe+0xe8/0x4a0)
[    7.445556]  r7:c2382248 r6:c221e3dc r5:00000000 r4:c4eb4410
[    7.451232] [<c0d25d98>] (really_probe) from [<c0d262e8>] (__driver_probe_device+0xb0/0x214)
[    7.459716]  r7:c4eb4410 r6:c2382248 r5:c221e3dc r4:c4eb4410
[    7.465423] [<c0d26238>] (__driver_probe_device) from [<c0d26490>] (driver_probe_device+0x44/0xd4)
[    7.474426]  r9:c2a12044 r8:0000002c r7:c4eb4410 r6:c31cfb84 r5:c2a120b4 r4:c2a120b0
[    7.482208] [<c0d2644c>] (driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
[    7.491394]  r9:c2a12044 r8:00000001 r7:c4eb4410 r6:c31cfb84 r5:c221e3dc r4:00000001
[    7.499176] [<c0d26ae4>] (__device_attach_driver) from [<c0d236bc>] (bus_for_each_drv+0x94/0xd8)
[    7.508026]  r7:c0d26ae4 r6:c31ce000 r5:c31cfb84 r4:00000000
[    7.513732] [<c0d23628>] (bus_for_each_drv) from [<c0d2678c>] (__device_attach+0xc4/0x224)
[    7.522033]  r7:c4eb44a0 r6:c4eb4410 r5:c31ce000 r4:c4eb4410
[    7.527709] [<c0d266c8>] (__device_attach) from [<c0d26e30>] (device_initial_probe+0x1c/0x20)
[    7.536315]  r8:c2381fc0 r7:c330a410 r6:c4eb4410 r5:c22f8650 r4:c4eb4410
[    7.543029] [<c0d26e14>] (device_initial_probe) from [<c0d24c0c>] (bus_probe_device+0x98/0xa0)
[    7.551696] [<c0d24b74>] (bus_probe_device) from [<c0d21db8>] (device_add+0x404/0x970)
[    7.559692]  r7:c330a410 r6:c31ce000 r5:00000000 r4:c4eb4410
[    7.565368] [<c0d219b4>] (device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
[    7.572906]  r10:c2125be0 r9:c2125d40 r8:eeb68974 r7:c2125be0 r6:00000000 r5:c330a410
[    7.580780]  r4:c4eb4400
[    7.583312] [<c1254b64>] (of_device_add) from [<c12552c4>] (of_platform_device_create_pdata+0xa4/0xd4)
[    7.592681] [<c1255220>] (of_platform_device_create_pdata) from [<c12554fc>] (of_platform_bus_create+0x1e4/0x544)
[    7.603027]  r9:c2125d40 r8:c2125d00 r7:00000000 r6:c31ce000 r5:00000000 r4:eeb68910
[    7.610809] [<c1255318>] (of_platform_bus_create) from [<c1255a68>] (of_platform_populate+0xa8/0x144)
[    7.620086]  r10:00000000 r9:00000001 r8:c330a410 r7:c2125be0 r6:00000000 r5:eeb32944
[    7.627960]  r4:eeb68910
[    7.630493] [<c12559c0>] (of_platform_populate) from [<c09f5dd4>] (simple_pm_bus_probe+0xb4/0xd8)
[    7.639434]  r10:c330a410 r9:c1d718b8 r8:00000001 r7:c2382248 r6:c2125be0 r5:eeb32944
[    7.647308]  r4:c330a410
[    7.649841] [<c09f5d20>] (simple_pm_bus_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
[    7.658264]  r7:c2382248 r6:c221e3dc r5:c330a410 r4:00000000
[    7.663940] [<c0d291f0>] (platform_probe) from [<c0d25e80>] (really_probe+0xe8/0x4a0)
[    7.671813]  r7:c2382248 r6:c221e3dc r5:00000000 r4:c330a410
[    7.677520] [<c0d25d98>] (really_probe) from [<c0d262e8>] (__driver_probe_device+0xb0/0x214)
[    7.686004]  r7:c330a410 r6:c2382248 r5:c221e3dc r4:c330a410
[    7.691680] [<c0d26238>] (__driver_probe_device) from [<c0d26490>] (driver_probe_device+0x44/0xd4)
[    7.700714]  r9:c1d718b8 r8:00000001 r7:c330a410 r6:c31cfe4c r5:c2a120b4 r4:c2a120b0
[    7.708496] [<c0d2644c>] (driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
[    7.717681]  r9:c1d718b8 r8:00000001 r7:c330a410 r6:c31cfe4c r5:c221e3dc r4:00000001
[    7.725463] [<c0d26ae4>] (__device_attach_driver) from [<c0d236bc>] (bus_for_each_drv+0x94/0xd8)
[    7.734313]  r7:c0d26ae4 r6:c31ce000 r5:c31cfe4c r4:00000000
[    7.739990] [<c0d23628>] (bus_for_each_drv) from [<c0d2678c>] (__device_attach+0xc4/0x224)
[    7.748321]  r7:c330a4a0 r6:c330a410 r5:c31ce000 r4:c330a410
[    7.753997] [<c0d266c8>] (__device_attach) from [<c0d26e30>] (device_initial_probe+0x1c/0x20)
[    7.762603]  r8:00000000 r7:c2382248 r6:c330a410 r5:c22f8650 r4:c3487df4
[    7.769317] [<c0d26e14>] (device_initial_probe) from [<c0d24c0c>] (bus_probe_device+0x98/0xa0)
[    7.777984] [<c0d24b74>] (bus_probe_device) from [<c0d2566c>] (deferred_probe_work_func+0xb8/0x100)
[    7.787109]  r7:c2382248 r6:c22f8238 r5:c22f8178 r4:c3487df4
[    7.792785] [<c0d255b4>] (deferred_probe_work_func) from [<c037d4e0>] (process_one_work+0x298/0x7dc)
[    7.802001]  r10:c2108f90 r9:c31ce000 r8:c236d0c0 r7:c3114000 r6:c3110000 r5:c31e3000
[    7.809875]  r4:c22f81e8 r3:c0d255b4
[    7.813446] [<c037d248>] (process_one_work) from [<c037da90>] (worker_thread+0x6c/0x554)
[    7.821594]  r10:00000088 r9:c31ce000 r8:c2105d00 r7:c3110038 r6:c31e3018 r5:c3110000
[    7.829467]  r4:c31e3000
[    7.832031] [<c037da24>] (worker_thread) from [<c0388000>] (kthread+0x16c/0x190)
[    7.839477]  r10:c31e30c0 r9:c31bfe2c r8:c31e3000 r7:c037da24 r6:c31e3080 r5:c31ce000
[    7.847351]  r4:c31df180
[    7.849884] [<c0387e94>] (kthread) from [<c030015c>] (ret_from_fork+0x14/0x38)
[    7.857177] Exception stack(0xc31cffb0 to 0xc31cfff8)
[    7.862243] ffa0:                                     00000000 00000000 00000000 00000000
[    7.870483] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.878692] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    7.885345]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0387e94
[    7.893218]  r4:c31df180 r3:c31ce000
[    7.896820] Code: e5942040 e3c3303f e3120080 e5932008 (e5927368) 
[    7.902954] ---[ end trace 86f7fd8d70b6f6f9 ]---

Stripping that down for readability, I can see that this happens
while processing timer interrupts (without IRQ stacks, because
5.15 didn't have them on arch/arm) in a deeply (6 levels)
nested device probe where one probe() function adds the
child device:

(do_page_fault) from [<c15ce040>] (do_translation_fault+0xc0/0xc4)
(do_translation_fault) from [<c0319c14>] (do_DataAbort+0x4c/0xcc)
(do_DataAbort) from [<c0300b2c>] (__dabt_svc+0x4c/0x80)
(lock_is_held_type) from [<c0427874>] (timekeeping_advance+0x7dc/0x93c)
(timekeeping_advance) from [<c042a720>] (update_wall_time+0x1c/0x2c)
(tick_sched_timer) from [<c042436c>] (__hrtimer_run_queues+0x2b8/0x5b4)
(gic_handle_irq) from [<c0300bc0>] (__irq_svc+0x60/0x80)
(schedule_timeout) from [<c15c56cc>] (do_wait_for_common+0xb0/0x168)
(do_wait_for_common) from [<c15c5834>] (wait_for_completion_timeout+0x54/0x68)
(i2c_transfer) from [<c0d56008>] (regmap_i2c_read+0x70/0xa0) 
(regmap_i2c_read) from [<c0d508f8>] (_regmap_raw_read+0x148/0x440)
(palmas_is_enabled_ldo) from [<c0bbb170>] (print_constraints_debug+0x374/0x4b4)
(print_constraints_debug) from [<c0bbd418>] (set_machine_constraints+0x2cc/0xadc)
(set_machine_constraints) from [<c0bbe634>] (regulator_register+0xa0c/0xc8c)
(regulator_register) from [<c0bc09d4>] (devm_regulator_register+0x5c/0x98)
(palmas_regulators_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
(driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
(device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
(devm_of_platform_populate) from [<c0d8218c>] (palmas_i2c_probe+0x4a4/0x61c)
(palmas_i2c_probe) from [<c1106e14>] (i2c_device_probe+0x304/0x334)
(driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
(device_add) from [<c0d22348>] (device_register+0x24/0x28) 
(i2c_register_adapter) from [<c1108c08>] (__i2c_add_numbered_adapter+0x60/0xa8)
(omap_i2c_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
(driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
(device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
(sysc_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
(driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
(device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
(simple_pm_bus_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
(driver_probe_device) from [<c0d26ba0>] (__device_attach_driver+0xbc/0x138)
(device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
(simple_pm_bus_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
(device_add) from [<c1254ba8>] (of_device_add+0x44/0x4c)
(simple_pm_bus_probe) from [<c0d2925c>] (platform_probe+0x6c/0xc8)
(device_initial_probe) from [<c0d24c0c>] (bus_probe_device+0x98/0xa0)
(worker_thread) from [<c0388000>] (kthread+0x16c/0x190)

Most of these functions are probably fine by themselves, there
are just so many of them that it overruns the stack in the end.

One thing that sticks out is the print_constraints_debug() function
in the regulator framework, which uses a larger-than-average stack
to hold a string buffer, and then calls into the low-level
driver to get the actual data (regulator_get_voltage_rdev,
_regulator_is_enabled). Splitting the device access out into a
different function from the string handling might reduce the
stack usage enough to stay just under the 8KB limit, though it's
probably not a complete fix. I added the regulator maintainers
to Cc for thoughts on this.

Enabling both IRQ stacks and VMAP_STACK on mainline kernels
would at least make this easier to identify, but neither of
those are available on 5.15.

Is there a way to tell the driver core to intentionally defer
device probing when a new device gets added inside of a probe()
function? I don't think we can change the default behavior
this fundamentally without causing regressions, but if there
is a compile-time or boot-time flag to change it, that may
be enough to avoid the specific problem on the X15 test setup.

     Arnd
