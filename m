Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2B26AD373
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 01:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCGAtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 19:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCGAtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 19:49:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416C832E4D;
        Mon,  6 Mar 2023 16:49:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFF9FB81201;
        Tue,  7 Mar 2023 00:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 805A1C433EF;
        Tue,  7 Mar 2023 00:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678150138;
        bh=zQIEMnEBtNLscoBzoZrW13CYG48psh/0hSKscCNvEQI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BoSkQJyOAuQAbEdPtt9KI0jx3jogk0TeILp/i9CmU/ARmQxR4JepdbtAp1USgmpwg
         kvw/9Q3OO4pZE+7zyViBl3bx2fV3YHsC3UDNJqM5MQmwaKLDDhC35YbTq2Ds7XMJ8A
         8feUN195WkQuz94VJxDLRWSzRljW6F9hv4S+2Za5/foBrlHj6nqhZVPKUblGzzyMgJ
         IKskGioZNpG8ow+rh8uDur5Fk7gD2avyM5J9Qp4kxAKFLrsy9ytDBlXN85G3ekIk3K
         GiKhCVTr9wW1APyvE3BoZ8WlCIJQIrSb6ll88GVYa+rAD3XckooymuyDlYoXubY5bV
         HbZ4pbJoz0R8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 600A0E4FC50;
        Tue,  7 Mar 2023 00:48:58 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 02/10] cpuidle, riscv: Push RCU-idle into driver
From:   patchwork-bot+linux-riscv@kernel.org
Message-Id: <167815013838.19612.5396346808460094460.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 00:48:58 +0000
References: <20230303092347.4825-3-cheng-jui.wang@mediatek.com>
In-Reply-To: <20230303092347.4825-3-cheng-jui.wang@mediatek.com>
To:     Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     linux-riscv@lists.infradead.org, stable@vger.kernel.org,
        anup@brainfault.org, rafael@kernel.org, daniel.lezcano@linaro.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, matthias.bgg@gmail.com,
        peterz@infradead.org, mingo@kernel.org, surenb@google.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Ingo Molnar <mingo@kernel.org>:

On Fri, 3 Mar 2023 17:23:24 +0800 you wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit 8e9ab9e8da1eae61fdff35690d998eaf8cd527dc upstream.
> 
> Doing RCU-idle outside the driver, only to then temporarily enable it
> again, at least twice, before going idle is suboptimal.
> 
> [...]

Here is the summary with links:
  - [02/10] cpuidle, riscv: Push RCU-idle into driver
    https://git.kernel.org/riscv/c/8e9ab9e8da1e
  - [10/10] cpuidle: Fix ct_idle_*() usage
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


