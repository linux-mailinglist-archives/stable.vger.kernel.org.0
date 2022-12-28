Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2089A65873C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 23:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiL1WLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 17:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiL1WKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 17:10:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5071740D;
        Wed, 28 Dec 2022 14:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F7A7B818C8;
        Wed, 28 Dec 2022 22:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D069C433F2;
        Wed, 28 Dec 2022 22:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672265415;
        bh=MeR9j/cmIt9uaY3svYNjr58bocyoGbZmb2YMoE//58s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ROi45159QDNZO1hDflueUiB9tf4rcCUGUT9ysje19VpGabAnEV+5U4/SrxbWwHR/z
         mFzlrCQ1OezK9FIrv/KsDzir96wTtvEVOOUa4I0rkTIGQwzbukE6QXxV+zBJ/2YOM3
         wO9Z+atqRvRIPTALcGHZmr79zgN/G8TT41ywsf+IulaVWjE5b2qU3rm1fY1rN7rGja
         oyXrYzstMZDiwdWEHPlhZydJRP0okGDYE5YnjIJokfDFJMX2FTh5eetzIfLGt6KKAI
         mvfLZRtvCUBVHGUAZ1NxG85buVel7mtXF2bRTW2YFSzpz6AW9in5dzFkdtu09PzCi6
         WTd9SsC0rwj2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30269C395DF;
        Wed, 28 Dec 2022 22:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Fix panic due to wrong pageattr of im->image
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167226541519.8452.10536194221890799528.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 22:10:15 +0000
References: <20221224133146.780578-1-nashuiliang@gmail.com>
In-Reply-To: <20221224133146.780578-1-nashuiliang@gmail.com>
To:     Chuang Wang <nashuiliang@gmail.com>
Cc:     stable@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sat, 24 Dec 2022 21:31:46 +0800 you wrote:
> In the scenario where livepatch and kretfunc coexist, the pageattr of
> im->image is rox after arch_prepare_bpf_trampoline in
> bpf_trampoline_update, and then modify_fentry or register_fentry returns
> -EAGAIN from bpf_tramp_ftrace_ops_func, the BPF_TRAMP_F_ORIG_STACK flag
> will be configured, and arch_prepare_bpf_trampoline will be re-executed.
> 
> At this time, because the pageattr of im->image is rox,
> arch_prepare_bpf_trampoline will read and write im->image, which causes
> a fault. as follows:
> 
> [...]

Here is the summary with links:
  - bpf: Fix panic due to wrong pageattr of im->image
    https://git.kernel.org/bpf/bpf/c/9ed1d9aeef58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


