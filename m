Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48B6659E3
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 12:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjAKLTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 06:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjAKLSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 06:18:43 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19961081;
        Wed, 11 Jan 2023 03:18:41 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 99BD33200893;
        Wed, 11 Jan 2023 06:18:37 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 11 Jan 2023 06:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1673435917; x=1673522317; bh=wj7dokJE/o
        CdRPfLLEKd/DR8ZKUiRt18pjl/CZgIeIM=; b=UgCf6ZrzKNXwISE0Ija02CCvza
        L510RcV9qYo3FTIaPK3xOCQqFBIbs/pki5WgEYSgEsiqb//l+Z0q/LBo4IxVhdL6
        zYkhkQg34Thsmkpvv0R/pnjizlimfVldxR/dp7fVQM0s09uqjjNmIUzpWf8mPswQ
        dB9MgNLJDPsAhlz+fiSo26SIOnCHactXdIjI7DL6f0MBou6mZuOYVNwjRudaFfhU
        hXxfPSe/wypgaC+AP7CQHBPj6OiS67Kw6t0JQeSoI+mPVx27IOU4W4uWPc6GlNW0
        /gb+VMzk4dYiq7GnrpKH3BkrgAam+GZXXMm21wPUco8/JbOMxre6EIxrc9NQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1673435917; x=1673522317; bh=wj7dokJE/oCdRPfLLEKd/DR8ZKUi
        Rt18pjl/CZgIeIM=; b=Rbrxzcnz4/WPxoyDUpdJK4mHalKFqw3975pXeL+TlvhL
        EHl0ZarhXT8Ff8z4JxlBivxL374YDlsjtfJpx63xTX5DsYf5bGuC4y+KZtm+XKhe
        JDYOU0WlcLbmccVA1yYasGQdOH61kG6O45kRXuUNP8Jss6UUz85TIVmgOr6Bcq7H
        qt9BtgZyXITTVaoNDOov5jrman+z4Z1gyafNzNMzaOe+BLOGBNYPDYFQy5JMr8N0
        Ya6lOx1KmRZuW6w67CTTj4QmFt+Op3djRezqRlgBBkI9SnK2Ctlll9mZfHH3bWnm
        ldhzH0BLBGT2zjwVx3UGojYnbudKK2nLr8s6VxHy3A==
X-ME-Sender: <xms:DJu-YxCxaDAIEwRiDwQygzv95STscWgQzcCd7FBt5BpV69nvsWlg_Q>
    <xme:DJu-Y_jfXQ6i-LDd5vXBqVGTjI2_rM_ihauN90WiqiDT4vReFXUHrwr4BMA7PaRfO
    KRZF22VkxmryHL1qOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleeggddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeeghffgieejjeekhfeiuddvudfgudeuheelffekhffgtdduieffhfeigefhgfdu
    ueenucffohhmrghinhepthhugihsuhhithgvrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:DJu-Y8mEMfUo1UAsUl8wwe6YBhs_Ju6xdTq0xZJ6h7tyEUx46BOLsA>
    <xmx:DJu-Y7yLkd_O58p86bbWXW5I9GGXaZ7Q9cNukkN7djvrBkPSVSoprA>
    <xmx:DJu-Y2QrFwp0j3nOCRWqOGeIgtZ5WJaHDpasimfm8pK455zBI3eQYw>
    <xmx:DZu-Y7i2dCcP9hc9bhoyzZw4NcCynlMX5D1K8HH6ZuD3pAgWYr-BAg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A36BEB60086; Wed, 11 Jan 2023 06:18:36 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <45e6c885-3035-4cd7-a4d0-69127814ef32@app.fastmail.com>
In-Reply-To: <CA+G9fYsChy=HzEwkBVydPW4gJhDjkB87dY9FA833H2tZLfSh-w@mail.gmail.com>
References: <20230110180017.145591678@linuxfoundation.org>
 <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
 <bd62bccb-6970-4cdb-ae23-792b5867705d@app.fastmail.com>
 <CA+G9fYsChy=HzEwkBVydPW4gJhDjkB87dY9FA833H2tZLfSh-w@mail.gmail.com>
Date:   Wed, 11 Jan 2023 12:18:16 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        "Pavel Machek" <pavel@denx.de>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        "Mark Brown" <broonie@kernel.org>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023, at 10:31, Naresh Kamboju wrote:
> On Wed, 11 Jan 2023 at 13:48, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wed, Jan 11, 2023, at 07:16, Naresh Kamboju wrote:
>> > On Tue, 10 Jan 2023 at 23:36, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> Yes, it ran successfully on 6.0.18.
>
> On the same kernel 6.0.19-rc1 built with gcc-12 did not find this panic.
> The reported issue is specific to clang-15 build.

Ok, and was the 6.0.18 build using the exact same clang-15 toolchain,
or could there have been an update to any of the tools?

Have you seen results with older clang releases?

>> > [ 2893.044339] Insufficient stack space to handle exception!
>> > [ 2893.044351] ESR: 0x0000000096000047 -- DABT (current EL)
>> > [ 2893.044360] FAR: 0xffff8000128180d0
>> > [ 2893.044364] Task stack:     [0xffff800012a18000..0xffff800012a1c000]
>> > [ 2893.044370] IRQ stack:      [0xffff80000a798000..0xffff80000a79c000]
>> > [ 2893.044375] Overflow stack: [0xffff0000f77c4310..0xffff0000f77c5310]
>> ...
>> > [ 2893.044413] pc : el1h_64_sync+0x0/0x68
>> > [ 2893.044430] lr : wp_page_copy+0xf8/0x90c
>> > [ 2893.044445] sp : ffff8000128180d0
>> ...
>> > [ 2893.044646]  panic+0x168/0x374
>> > [ 2893.044658]  test_taint+0x0/0x38
>> > [ 2893.044667]  panic_bad_stack+0x110/0x124
>> > [ 2893.044675]  handle_bad_stack+0x34/0x48
>> > [ 2893.044685]  __bad_stack+0x78/0x7c
>> > [ 2893.044692]  el1h_64_sync+0x0/0x68
>> > [ 2893.044700]  do_wp_page+0x4a0/0x5c8
>> > [ 2893.044708]  handle_mm_fault+0x7fc/0x14dc
>> > [ 2893.044718]  do_page_fault+0x29c/0x450
>> > [ 2893.044727]  do_mem_abort+0x4c/0xf8
>> > [ 2893.044741]  el0_da+0x48/0xa8
>> > [ 2893.044750]  el0t_64_sync_handler+0xcc/0xf0
>> > [ 2893.044759]  el0t_64_sync+0x18c/0x190
>>
>> It claims that the stack overflow happened in do_wp_page(),
>> but that has a really short call chain. It would be good
>> to have the source line for do_wp_page+0x4a0/0x5c8 and
>> wp_page_copy+0xf8/0x90c to see where exactly it was.
>>
>> >   artifact-location:
>> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYRjNkBef3oR5JT
>>
>
> Adding " / " at end works.
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYRjNkBef3oR5JT/

Ok, I disassembled the image to see what happened.

do_wp_page+0x4a0/0x5c8 is the call to wp_page_copy(), so I would
guess the el1h_64_sync fault actually happened in that function.

lr : wp_page_copy+0xf8/0x90c the return address from
__mem_cgroup_charge(), but I suspect it's not where the fault
happened either, just the last address that was in the
link register.

el1h_64_sync+0x0/0x68 is a "paciasp" pointer authentication
instruction.

__bad_stack is actually called from 'vectors', which has this
code for calling el1h_64_sync, from kernel_ventry:

ffff800008011200:       d10543ff        sub     sp, sp, #0x150
ffff800008011204:       8b2063ff        add     sp, sp, x0
ffff800008011208:       cb2063e0        sub     x0, sp, x0
ffff80000801120c:       37700080        tbnz    w0, #14, ffff80000801121c <vectors+0x21c>
ffff800008011210:       cb2063e0        sub     x0, sp, x0
ffff800008011214:       cb2063ff        sub     sp, sp, x0
ffff800008011218:       14000201        b       ffff800008011a1c <el1h_64_sync>
ffff80000801121c:       d51bd040        msr     tpidr_el0, x0
ffff800008011220:       cb2063e0        sub     x0, sp, x0
ffff800008011224:       d51bd060        msr     tpidrro_el0, x0
ffff800008011228:       f0010a80        adrp    x0, ffff80000a164000 <overflow_stack+0xcf0>
ffff80000801122c:       910c401f        add     sp, x0, #0x310
ffff800008011230:       d538d080        mrs     x0, tpidr_el1
ffff800008011234:       8b2063ff        add     sp, sp, x0
ffff800008011238:       d53bd040        mrs     x0, tpidr_el0
ffff80000801123c:       cb2063e0        sub     x0, sp, x0
ffff800008011240:       f274cc1f        tst     x0, #0xfffffffffffff000
ffff800008011244:       54002de1        b.ne    ffff800008011800 <__bad_stack>  // b.any
ffff800008011248:       cb2063ff        sub     sp, sp, x0
ffff80000801124c:       d53bd060        mrs     x0, tpidrro_el0
ffff800008011250:       140001f3        b       ffff800008011a1c <el1h_64_sync>

and here I'm lost now.

      Arnd
