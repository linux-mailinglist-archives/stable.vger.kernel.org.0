Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A1362168B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiKHO25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbiKHO1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:27:39 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5D054B3D;
        Tue,  8 Nov 2022 06:26:20 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 68ED35C0068;
        Tue,  8 Nov 2022 09:26:17 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Tue, 08 Nov 2022 09:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1667917577; x=1668003977; bh=t31C4GN6S4
        sVE3UlVhPI7zAlW4okDBRwpyOThXNzhrU=; b=CXM8d56FQRKJjch6O7e8n/H/Wa
        pTG64nLZ6t2XTjCWTISh45J3vi/TiurXtOmqdiC8hJgbjavWTfOUfhlUHhNP5Mfm
        hqeJiyb5hPjMnxmR4bkrI8tWGNAm4D8ie6sKwbmcCUmcr5H3ZWab4aIFYzG2jwI5
        IVuZJ8J+NG/eZ0nwU6toPm95qM8ZMwq9+vvHJyBZ7iLkPNn/ptvokT4laJyU3YTy
        Bn3U3EukDS/7PLvWwIrh9+V1nFJICZZuA6npJIXBqpgYxcWfZfCO2Y4Qde4rQNLo
        XFQSZ1r3V0NGf729HAwE3EWXZ/i4YZFgoCnke7Ko0RM4WFg04knxLf79u57w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667917577; x=1668003977; bh=t31C4GN6S4sVE3UlVhPI7zAlW4ok
        DBRwpyOThXNzhrU=; b=j+iHmmzJEe+7vBq9dN+i8q8rTl2w1nuC+ZospCVlMQFx
        iHW3bIkMC0XG3lju0sIKj0puI1vwRAvaVoBy25Tmb3OEzKd4qaYGC55uMijHa8gn
        GDu6FFYja6ShNJ1f0IwG9fmOjKnoDKfj3RGKH7hxER0sGjMC6rOgoWY9XrWNG0ZJ
        oUTF9i2ITwtQrp+IjJvcdGeVQ7kbknvzM10tdXSt4qxxufPKzKHPEnedf17xuWcm
        c3l9UkAAtI11hr9+nQiYd1G7n4jpCujKMvLSDEY7ApbNJy2ZlnKcg02tiD+uUA0u
        jx4Xa65rdo9m9VQg3lXSo+J5iQdKe2Zf87s0Ea4o9g==
X-ME-Sender: <xms:CGdqY-wrOEW1jYsMrvO9oeIrtJBG008ENsQLvxfnFkomruMX8dQFxA>
    <xme:CGdqY6TX5l1JU-4gSL0ghvl4kH8CrLM_kx4OhTnkWjBld4NFbtwZYQcCyjObxbkjG
    0U53TF0AHQTBWXnfKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedtgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpefhtdelhfettdetvdetvdeuueegvdeuleeuudevhfeuhfeugfdvtdevvedvfffh
    udenucffohhmrghinheplhhinhgrrhhordhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:CWdqYwWBl1uaEV5bSzOx8gDoEQK_UBhUGWqH6hwWzNfXMgPL_Vtpfw>
    <xmx:CWdqY0jZ66gJZlX27kSjzZb6zpHYhlRYcS73CO5cLlQ-mfZzmWxbEg>
    <xmx:CWdqYwD4Rcx3ZZ9DYv9AhYZsWagIjptsJmzwNJSzS1bg7u__NLeCZg>
    <xmx:CWdqYy1k-BUjK2ckG6_TsGPnuZJ8EMqX0IVZc7K0rW2Ve72W9QDidg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id DDA82B60086; Tue,  8 Nov 2022 09:26:16 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <660da7ca-4fd8-459a-8d9b-cace5d9e5ad3@app.fastmail.com>
In-Reply-To: <CACRpkdb8ynRrXZ0O4cxoGSn2zQ1rr7zkDiTz78Pm+GPc30p_Nw@mail.gmail.com>
References: <CA+G9fYv5-og6kr8PgGCg-wYUK3PGCQmvbY1YYews5-C8XwxSww@mail.gmail.com>
 <CACRpkdb8ynRrXZ0O4cxoGSn2zQ1rr7zkDiTz78Pm+GPc30p_Nw@mail.gmail.com>
Date:   Tue, 08 Nov 2022 15:25:53 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Linus Walleij" <linus.walleij@linaro.org>,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc:     "open list" <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "Kees Cook" <keescook@chromium.org>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "David Gow" <davidgow@google.com>,
        "Gwan-gyeong Mun" <gwan-gyeong.mun@intel.com>,
        "Vitor Massaru Iha" <vitor@massaru.org>
Subject: Re: KASAN / KUNIT: testing ran on qemu-arm and list of failures
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 8, 2022, at 14:51, Linus Walleij wrote:
> On Wed, Nov 2, 2022 at 3:15 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
>> This is a report to get a quick update on kasan on qemu-arm.
>>
>> The KASAN / KUNIT testing ran on qemu-arm and the following test cases failed
>> and the kernel crashed.
>>
>> Following tests failed,
>>     kasan_strings - FAILED
>>     vmalloc_oob - FAILED
>>     kasan_memchr - FAILED
>>     kasan - FAILED
>>     kasan_bitops_generic - FAILED
>>
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Which isn't very strange since:
>
>> [  429.920201] Insufficient stack space to handle exception!
>
> the system ran out of stack. With VMAP stack and IRQSTACKS
> there is really not much more memory we can provide.
>
> When I discussed this with syzbot it seemed they were using some
> really big userspace program written in Go that just used up all
> the virtual memory :P
>
> I don't know the nature of this test though. Using a lot of memory??

From the log file[1], I see that the actual problem is a
recursive data abort. The problem is not that any particular
piece uses too much memory, it's that each time it tries to
handle the fault, it causes a new fault:

Citing more of the output:

[  429.920201] Insufficient stack space to handle exception!
[  429.920232] Task stack:     [0xfa000000..0xfa004000]
[  429.925226] IRQ stack:      [0xf0808000..0xf080c000]
[  429.927424] Overflow stack: [0xc4190000..0xc4191000]
[  429.929785] Internal error: kernel stack overflow: 0 [#1] SMP ARM
[  429.933101] Modules linked in: usbtest pci_endpoint_test pci_epf_test preemptirq_delay_test soc_utils_test(N) snd_soc_core ac97_bus snd_pcm_dmaengine snd_pcm snd_timer snd soundcore cfg80211 bluetooth crc32_arm_ce sha2_arm_ce sha256_arm sha1_arm_ce sha1_arm aes_arm_ce crypto_simd
[  429.946324] CPU: 1 PID: 3390 Comm: grep Tainted: G    B            N 6.0.7-rc1 #1
[  429.950389] Hardware name: Generic DT based system
[  429.952979] PC is at trace_hardirqs_off+0x0/0x16c
[  429.955349] LR is at __dabt_svc+0x48/0x80
[  429.957676] pc : [<c04c98fc>]    lr : [<c0300b28>]    psr: 400f0193
[  429.961073] sp : fa000008  ip : 00000051  fp : fa003a54
[  429.963850] r10: c44f6c80  r9 : cc7aa100  r8 : fa0000b8
[  429.966725] r7 : fa00003c  r6 : ffffffff  r5 : 200f0193  r4 : c05eb00c
[  429.970284] r3 : c1b29438  r2 : fa000054  r1 : be40001f  r0 : 00000051
[  429.973596] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  429.977644] Control: 10c5383d  Table: 4df4406a  DAC: 00000051
...
[  430.032192] Process grep (pid: 3390, stack limit = 0xfab94337)
[  430.035496] Stack: (0xfa000008 to 0xfa004000)
[  430.037882] 0000:                   fa0000f8 be40001f fa0000f8 00000003 be400035 fa0000b8
[  430.041998] 0020: c31192e0 00000005 fa0000b8 c3119330 c44f6c80 fa003a54 00000051 fa000054
...
[  432.224241] 3fc0: 00000001 aeca02b0 00000000 000000f8 aec9ee5c 00000001 00000000 aec9f384
[  432.228111] 3fe0: 000000f8 b6669814 aec16049 aebb1ae6 600b0030 00000000 00000000 00000000
[  432.232008]  trace_hardirqs_off from __dabt_svc+0x48/0x80
[  432.234649] Exception stack(0xfa000008 to 0xfa000050)
[  432.237101] 0000:                   fa0000f8 be40001f fa0000f8 00000003 be400035 fa0000b8
[  432.240995] 0020: c31192e0 00000005 fa0000b8 c3119330 c44f6c80 fa003a54 00000051 fa000054
[  432.244861] 0040: c1b29438 c05eb00c 200f0193 ffffffff
[  432.247286]  __dabt_svc from __asan_load4+0x30/0x88
[  432.249665]  __asan_load4 from do_translation_fault+0x34/0x124
[  432.252456]  do_translation_fault from do_DataAbort+0x54/0xf4
[  432.255278]  do_DataAbort from __dabt_svc+0x50/0x80
[  432.258226] Exception stack(0xfa0000b8 to 0xfa000100)
[  432.260998] 00a0:                                                       fa0001a8 be400035
[  432.265219] 00c0: fa0001a8 00000003 be40004b fa000168 c31192e0 00000005 fa000168 c3119330
[  432.269670] 00e0: c44f6c80 fa003a54 00000051 fa000104 c1b29438 c05eb00c 200f0193 ffffffff
[  432.273872]  __dabt_svc from __asan_load4+0x30/0x88
[  432.276409]  __asan_load4 from do_translation_fault+0x34/0x124
[  432.279577]  do_translation_fault from do_DataAbort+0x54/0xf4
[  432.282646]  do_DataAbort from __dabt_svc+0x50/0x80
...
[  434.328344] Exception stack(0xfa0037b8 to 0xfa003800)
[  434.331100] 37a0:                                                       fa0038a8 be400715
[  434.335411] 37c0: fa0038a8 00000003 be40072b fa003868 c31192e0 00000005 fa003868 c3119330
[  434.339676] 37e0: c44f6c80 fa003a54 00000051 fa003804 c1b29438 c05eb00c 200f0193 ffffffff
[  434.344067]  __dabt_svc from __asan_load4+0x30/0x88
[  434.346673]  __asan_load4 from do_translation_fault+0x34/0x124
[  434.350064]  do_translation_fault from do_DataAbort+0x54/0xf4
[  434.353242]  do_DataAbort from __dabt_svc+0x50/0x80
[  434.355711] Exception stack(0xfa003868 to 0xfa0038b0)
[  434.358544] 3860:                   fa003958 be40072b fa003958 00000003 be400738 fa003918
[  434.362770] 3880: c31192e0 00000805 fa003918 c3119330 c44f6c80 fa003a54 00000051 fa0038b4
[  434.366943] 38a0: c1b29438 c05eb00c 200f0193 ffffffff
[  434.369838]  __dabt_svc from __asan_load4+0x30/0x88
[  434.372308]  __asan_load4 from do_translation_fault+0x34/0x124
[  434.375566]  do_translation_fault from do_DataAbort+0x54/0xf4
[  434.378889]  do_DataAbort from __dabt_svc+0x50/0x80
[  434.381535] Exception stack(0xfa003918 to 0xfa003960)
[  434.384064] 3900:                                                       e8476d80 00000000
[  434.388732] 3920: be400738 00000000 c30f2044 cb4f0b00 cc7aa100 2537d000 ca86ca00 ca86ca00
[  434.393063] 3940: c44f6c80 fa003a54 fa003968 fa003968 c03a81ac c1b1d4c4 200f0113 ffffffff
[  434.397387]  __dabt_svc from __schedule+0x590/0xfc0
[  434.399943]  __schedule from __cond_resched+0x50/0x6c
[  434.402576]  __cond_resched from zap_pte_range+0x56c/0xa08
[  434.405862]  zap_pte_range from unmap_page_range+0x12c/0x364
[  434.409044]  unmap_page_range from unmap_vmas+0x124/0x178
[  434.411851]  unmap_vmas from exit_mmap+0x128/0x304
[  434.414529]  exit_mmap from __mmput+0x34/0x188
[  434.416946]  __mmput from do_exit+0x508/0xef8
[  434.419338]  do_exit from do_group_exit+0x50/0x108
[  434.421858]  do_group_exit from __wake_up_parent+0x0/0x34
[  434.424729] Code: e2840d41 e2800030 e8bd41f0 eaff8cce (e92d47f0) 
[  434.428055] ---[ end trace 0000000000000000 ]---
[  434.430356] Fixing recursive fault but reboot is needed!

Note the "Exception stack(0xfa003918 to 0xfa003960)" values slightly
shrinking with each iteration. I can see that both
__schedule+0x590/0xfc0 and __asan_load4+0x30/0x88 trigger an
unexpected exception here. The latter of those is what causes
the recursion. Presumably both them try to access the same
invalid pointer, but I have not disassembled the vmlinux
yet to see what it's actually trying to do here.

     Arnd

[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.6-241-g436175d0f780/testrun/12809413/suite/log-parser-test/test/check-kernel-bug/log
