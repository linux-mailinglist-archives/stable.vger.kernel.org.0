Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE9A626290
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 21:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbiKKUKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 15:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiKKUKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 15:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6AB845C1;
        Fri, 11 Nov 2022 12:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A36A9B82615;
        Fri, 11 Nov 2022 20:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41162C433D6;
        Fri, 11 Nov 2022 20:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668197416;
        bh=9ZvXetzw+91Fgm1dOLURSzTHjBfK/S906d1KMXN2hSM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iFkcPE4OEoKEVZJKYVHLfyzWLnIeyc46j24DE4NU71Pc/6KRw58QVJFo0W+tLzbDB
         ktBhltmHAHhybo063ganPEu3aLHExuEw1+tx38yXkpr3z52+PewFJmE7frmbH0XpBP
         sEiPvtdLvTw4TEGNadffhq+HFigik2TKJWmES9Xukyd5SeFChIQi1yb+k1DsmRISh4
         uGmHKHle78bPN39e855xJSXT3LTmdguiYB7VIke3tF7eZhi/8gzQ0p4nAzU+dwfxm/
         qlEZFajJACVVGcmUhrNMk2w0ufzeKbxg9AiSLC2zYmKr+6yZzAZzIYGdpuzqQIl8Mn
         QZhM9CNwQreVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12306E270EF;
        Fri, 11 Nov 2022 20:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2 0/2] Fix offset when fault occurs in
 strncpy_from_kernel_nofault()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166819741604.18746.14256287708522363196.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 20:10:16 +0000
References: <20221110085614.111213-1-albancrequy@linux.microsoft.com>
In-Reply-To: <20221110085614.111213-1-albancrequy@linux.microsoft.com>
To:     Alban Crequy <albancrequy@linux.microsoft.com>
Cc:     bpf@vger.kernel.org, stable@vger.kernel.org,
        flaniel@linux.microsoft.com, akpm@linux-foundation.org,
        andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        haoluo@google.com, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        martin.lau@linux.dev, mykolal@fb.com, sdf@google.com,
        shuah@kernel.org, song@kernel.org, yhs@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 10 Nov 2022 09:56:12 +0100 you wrote:
> Hi,
> 
> This is v2 of the fix & selftest previously sent at:
> https://lore.kernel.org/linux-mm/20221108195211.214025-1-flaniel@linux.microsoft.com/
> 
> Changes v1 to v2:
> - add 'cc:stable', 'Fixes:' and review/ack tags
> - update commitmsg and fix my email
> - rebase on bpf tree and tag for bpf tree
> 
> [...]

Here is the summary with links:
  - [bpf,v2,1/2] maccess: fix writing offset in case of fault in strncpy_from_kernel_nofault()
    https://git.kernel.org/bpf/bpf/c/8678ea06852c
  - [bpf,v2,2/2] selftests: bpf: add a test when bpf_probe_read_kernel_str() returns EFAULT
    https://git.kernel.org/bpf/bpf/c/9cd094829dae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


