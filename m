Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9601465D2C8
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239162AbjADMfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbjADMfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:35:04 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA481ADBE;
        Wed,  4 Jan 2023 04:35:02 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 2D87E320085B;
        Wed,  4 Jan 2023 07:35:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 04 Jan 2023 07:35:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1672835700; x=1672922100; bh=SXc8ZEz6U0
        GgUuXK0HIz/oLBUfR7nGW8kjeVugLNhI8=; b=Z/gfOocRZfcLHAl+DE4ckNpyXI
        4YDdLIMC6ZR3wDhHfOw7wO0W/7peHo0r1G7ddWkbAPETKhrm7wBA+e7JEjZ3+jbv
        TYYv9Q8MyXlJqH3aD0FruT/c2MO7WnYwkqsVt39fWIAAmObOo0YVL0z9reM9bxKG
        LLwbb7BLaNJ/HjPcp05QSmhywp1qtMCoiSzP44vaOemLpXcaTjJy0tThHImSfXv7
        l2NTFZdQ7ARkI6ktuzGljBY8tr/4ojaybIkwNEog7M7rv5FYj7JlErWzI00kt84w
        W4Sk+CA1GLPE0ow2xQ1NjhqQ0YtnED7QBXDzo8Q0S+zVB2/6paHQ+6Agc38g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1672835700; x=1672922100; bh=SXc8ZEz6U0GgUuXK0HIz/oLBUfR7
        nGW8kjeVugLNhI8=; b=Tsig7tRMgL15ZlPnAolQR4cur7tNuKaIPFYTnTLKMQYm
        tfQLPOMG6Jock/+eoK48CmpxNrIZlzxPqKJW6jdDHnlszB/PCmIUWmRgQ3fo1gZt
        m1iLFnV7MNAQwDHvebL4KbltcDeB8078NQXdn1E4kTNjV035TGr/PQoCVhk3w5zJ
        yLAdrpMzygVvoamUNaLzfKZ9lvoZ2RlsMMXKSpASWP2vTd4Kgs3ArKRunNDq4V5X
        uQ37LpNS2zKouuXB2jiHXqc+dqhzquex+cSEf/3gUHP/JtepLlfqgqJglJzxAuZQ
        gnrbaQRR0ZOQxVlgsI1M189PrKk2XabBCI36RPbElA==
X-ME-Sender: <xms:dHK1Y5rYUm9DEg5cLOp4ymIyKVN-u0wDPdqmqMWTESiutUDfFYa3Sg>
    <xme:dHK1Y7qxzlYYAcb5V1JsOvQCQKFJE9uW-PBcdru7wXRkN937ENLAlVE11LK-2_TC1
    Hx-wdzPDvnNmg>
X-ME-Received: <xmr:dHK1Y2Mgh8SqF8Mv3R3ZMqzm23IfS55dSNOECPPCrMFxEf1IVhwOQ7CrgJWyNdIAk8Jir6B1kD33BYKVQUHpfehQYk2krXctyjIy-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrjeeigdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeejgfekff
    ekhedtteetudefgfelueegudfglefhffeileeugfeijeehvedttdfhffenucffohhmrghi
    nhepjhhovghlfhgvrhhnrghnuggvshdrohhrghdphhgrshhtvggsihhnrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehk
    rhhorghhrdgtohhm
X-ME-Proxy: <xmx:dHK1Y04oyQ7Kpu2Ix84vMbagi0YgqWlM_qLRac4_lV6vs26iCvPHgA>
    <xmx:dHK1Y44BCA75yuqKmLZ6WwX9_-sNa_HCCwWB7qxATKNurNCvEAtFdQ>
    <xmx:dHK1Y8jZnD6rK2pzbxrWUv9appCZxNEehJS4o-zlnGJUqVaHwqa8Rg>
    <xmx:dHK1Y1uY73q-0Jh3Gg-lLJBDnEVuFxzOSreV7-eZbuS_6xds-JgA2Q>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Jan 2023 07:34:59 -0500 (EST)
Date:   Wed, 4 Jan 2023 13:34:52 +0100
From:   Greg KH <greg@kroah.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     stable@vger.kernel.org, paulmck@kernel.org, rcu@vger.kernel.org
Subject: Re: Please apply to v5.15 stable: 96017bf90397 ("rcu-tasks: Simplify
 trc_read_check_handler() atomic operations")
Message-ID: <Y7VybOrgufZLFcp5@kroah.com>
References: <Y6ugLOSaqylFlRjZ@google.com>
 <CAEXW_YRRws7fAZfK_Um1F9LQBE5WOM_cE_TOk5s39C597HxeoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YRRws7fAZfK_Um1F9LQBE5WOM_cE_TOk5s39C597HxeoA@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,WEIRD_PORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 04:30:30AM +0000, Joel Fernandes wrote:
> On Wed, Dec 28, 2022 at 1:47 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > Hello,
> >
> > Please apply 96017bf90397 ("rcu-tasks: Simplify trc_read_check_handler()
> > atomic operations") to the stable v5.15 stable kernel. It made it in v5.16.
> >
> > I confirmed the patch fixes the following splat which happens twice on TRACE02:
> >
> > [  765.941351] WARNING: CPU: 0 PID: 80 at kernel/rcu/tasks.h:895 trc_read_check_handler+0x61/0xe0
> > [  765.949880] Modules linked in:
> > [  765.953006] CPU: 0 PID: 80 Comm: rcu_torture_rea Not tainted 5.15.86-rc1+ #25
> > [  765.959982] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
> > [  765.967964] RIP: 0010:trc_read_check_handler+0x61/0xe0
> > [  765.973050] Code: 01 00 89 c0 48 03 2c c5 80 f8 a5 ae c6 45 00 00 [..]
> > [  765.991768] RSP: 0000:ffffa64ac0003fb0 EFLAGS: 00010047
> > [  765.997042] RAX: ffffffffad4f8610 RBX: ffffa26b41bd3000 RCX: ffffa26b5f4ac8c0
> > [  766.004418] RDX: 0000000000000000 RSI: ffffffffae978121 RDI: ffffa26b41bd3000
> > [  766.011502] RBP: ffffa26b41bd6000 R08: ffffa26b41bd3000 R09: 0000000000000000
> > [  766.018778] R10: 0000000000000000 R11: ffffa64ac0003ff8 R12: 0000000000000000
> > [  766.025943] R13: ffffa26b5f4ac8c0 R14: 0000000000000000 R15: 0000000000000000
> > [  766.034383] FS:  0000000000000000(0000) GS:ffffa26b5f400000(0000) knlGS:0000000000000000
> > [  766.042925] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  766.048775] CR2: 0000000000000000 CR3: 0000000001924000 CR4: 00000000000006f0
> > [  766.055991] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  766.063135] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  766.070711] Call Trace:
> > [  766.073515]  <IRQ>
> > [  766.075807]  flush_smp_call_function_queue+0xec/0x1a0
> > [  766.081087]  __sysvec_call_function_single+0x3e/0x1d0
> > [  766.086466]  sysvec_call_function_single+0x89/0xc0
> > [  766.091431]  </IRQ>
> > [  766.093713]  <TASK>
> > [  766.095930]  asm_sysvec_call_function_single+0x16/0x20
> >
> > Full kernel logs:
> > http://box.joelfernandes.org:9080/job/rcutorture_stable/job/Linux%20Stable%20RC%205.15/lastFailedBuild/artifact/tools/testing/selftests/rcutorture/res/2022.12.27-20.43.34/TRACE02/console.log
> 
> Updated link to full kernel log: https://hastebin.com/raw/uvoholebol


Now queued up, thanks.

greg k-h
