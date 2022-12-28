Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C04265728A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 05:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiL1Eat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 23:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiL1Eap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 23:30:45 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F2AB07
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 20:30:44 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id v23so5403349ljj.9
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 20:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zAbCtfdPfaYMrExY4lpiWaKCOXboxETCkUKtIWB8Cqg=;
        b=vy8h0KIneEmgRWXBIdDQRy0NAg7PKJIc8KSJ3Z58MN1iQel+qS0GcU29xCN8nLRn7b
         4kQCVpEwc3QQ+DZffCTDl/8v6HzRnYMf4LdA5VrusMKppAuMpeHDgjapY7orOs98Svh5
         nShaR1UuBACybnrysSB7AISkD6v0WTcszjFUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAbCtfdPfaYMrExY4lpiWaKCOXboxETCkUKtIWB8Cqg=;
        b=m2ZIkOUpIukuUJXt16wtcDVsyn+6p5M0fUQgy8ESGTv6bOu55oMp/j/DDuUIw4v5fI
         BVD9OUCR0UstV/oRe4pYQsRfCPlP5txEgAcYq+azTNjmgQpUlI4ty6uawHabXa0jV05P
         WKijkMsuJg8O0KHDM+dyGy3lcd5B4zyQjLp3I6CM6q+fxZzctC65sfwqwpnBI2yMRRq5
         lyTV7JGRZ6aaY5T3qjb5hX+WVRSyHc9QoBtPvjryvo3Iwk6Bd6r9vk24RTh7DJfw6nQx
         38NOCZIoxWWtO2wWKaPVL3MUG2xsKXdaxo/Rm9Q/Y6knfmUGmGZfX2M+tGRup7f/cKfL
         Iiww==
X-Gm-Message-State: AFqh2kqVcjfT9yajSHeHl1O/740rN68mSJya2aUpk8fQ2AguynfVQ2cW
        gRGd9luanc6QhcWvzCcLwtfeOU1IxuCE2H57cr78krVGymvjViNhBDE=
X-Google-Smtp-Source: AMrXdXsDj9lsoTFA4arOzWmLCz2Ypk4gsu/vZmT52rz/ixAKFLMTpFffOhj29czzEQ1yhBWIOSnevD8sUAmOPkKSuz8=
X-Received: by 2002:a2e:be89:0:b0:27f:b85b:3e26 with SMTP id
 a9-20020a2ebe89000000b0027fb85b3e26mr514437ljr.382.1672201841859; Tue, 27 Dec
 2022 20:30:41 -0800 (PST)
MIME-Version: 1.0
References: <Y6ugLOSaqylFlRjZ@google.com>
In-Reply-To: <Y6ugLOSaqylFlRjZ@google.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Wed, 28 Dec 2022 04:30:30 +0000
Message-ID: <CAEXW_YRRws7fAZfK_Um1F9LQBE5WOM_cE_TOk5s39C597HxeoA@mail.gmail.com>
Subject: Re: Please apply to v5.15 stable: 96017bf90397 ("rcu-tasks: Simplify
 trc_read_check_handler() atomic operations")
To:     stable@vger.kernel.org
Cc:     paulmck@kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,WEIRD_PORT autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 1:47 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> Hello,
>
> Please apply 96017bf90397 ("rcu-tasks: Simplify trc_read_check_handler()
> atomic operations") to the stable v5.15 stable kernel. It made it in v5.16.
>
> I confirmed the patch fixes the following splat which happens twice on TRACE02:
>
> [  765.941351] WARNING: CPU: 0 PID: 80 at kernel/rcu/tasks.h:895 trc_read_check_handler+0x61/0xe0
> [  765.949880] Modules linked in:
> [  765.953006] CPU: 0 PID: 80 Comm: rcu_torture_rea Not tainted 5.15.86-rc1+ #25
> [  765.959982] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
> [  765.967964] RIP: 0010:trc_read_check_handler+0x61/0xe0
> [  765.973050] Code: 01 00 89 c0 48 03 2c c5 80 f8 a5 ae c6 45 00 00 [..]
> [  765.991768] RSP: 0000:ffffa64ac0003fb0 EFLAGS: 00010047
> [  765.997042] RAX: ffffffffad4f8610 RBX: ffffa26b41bd3000 RCX: ffffa26b5f4ac8c0
> [  766.004418] RDX: 0000000000000000 RSI: ffffffffae978121 RDI: ffffa26b41bd3000
> [  766.011502] RBP: ffffa26b41bd6000 R08: ffffa26b41bd3000 R09: 0000000000000000
> [  766.018778] R10: 0000000000000000 R11: ffffa64ac0003ff8 R12: 0000000000000000
> [  766.025943] R13: ffffa26b5f4ac8c0 R14: 0000000000000000 R15: 0000000000000000
> [  766.034383] FS:  0000000000000000(0000) GS:ffffa26b5f400000(0000) knlGS:0000000000000000
> [  766.042925] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  766.048775] CR2: 0000000000000000 CR3: 0000000001924000 CR4: 00000000000006f0
> [  766.055991] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  766.063135] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  766.070711] Call Trace:
> [  766.073515]  <IRQ>
> [  766.075807]  flush_smp_call_function_queue+0xec/0x1a0
> [  766.081087]  __sysvec_call_function_single+0x3e/0x1d0
> [  766.086466]  sysvec_call_function_single+0x89/0xc0
> [  766.091431]  </IRQ>
> [  766.093713]  <TASK>
> [  766.095930]  asm_sysvec_call_function_single+0x16/0x20
>
> Full kernel logs:
> http://box.joelfernandes.org:9080/job/rcutorture_stable/job/Linux%20Stable%20RC%205.15/lastFailedBuild/artifact/tools/testing/selftests/rcutorture/res/2022.12.27-20.43.34/TRACE02/console.log

Updated link to full kernel log: https://hastebin.com/raw/uvoholebol

Thanks.
