Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055756C371A
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 17:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCUQk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 12:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjCUQkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 12:40:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB38A4484;
        Tue, 21 Mar 2023 09:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45A45B818E2;
        Tue, 21 Mar 2023 16:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E701DC4339B;
        Tue, 21 Mar 2023 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679416818;
        bh=ldWpBNnr4qmFL77lev/coFUi1C+rOctqD9HBEAO/K3M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oUOhoVZa7vRYH3Z5xq2ESZCtwOzg+y2BYzhkT+2hPiCfJNU/oN5O23AG7ohUiR9eN
         JY3qMbhBWisixw9jjSdZT3Wap7Nt931CkHbHPzWpwa73wzouPFg8Rs0huODaqfI3Yo
         pAYI8Y4BqAlQ9rv812CyeYOPE3gI37wqJ4KkIIIE5KzDp8EmAXxzDQsNRBnKDNF+uA
         rSYEx8uBKDxSgLkk6tdXWZyK4J2yn3xHEHcgBWWGFpvWiXAZk6NQgb3FKAoqxP+tKW
         Q84vyJYejVq0vrllQnIpc620ZuI1lVHmFMoCIn3kiBNZyxgGXnlyNaQeayHTnyhYK/
         8xCdJDzKLVSpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0F08E4F0DA;
        Tue, 21 Mar 2023 16:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: factor out victim_entry usage from
 general rb_tree use
From:   patchwork-bot+f2fs@kernel.org
Message-Id: <167941681878.25004.6451264587497952126.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 16:40:18 +0000
References: <20230310210454.2350881-1-jaegeuk@kernel.org>
In-Reply-To: <20230310210454.2350881-1-jaegeuk@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Fri, 10 Mar 2023 13:04:52 -0800 you wrote:
> Let's reduce the complexity of mixed use of rb_tree in victim_entry from
> extent_cache and discard_cmd.
> 
> This should fix arm32 memory alignment issue caused by shared rb_entry.
> 
> [struct victim_entry]              [struct rb_entry]
> [0] struct rb_node rb_node;        [0] struct rb_node rb_node;
>                                        union {
>                                          struct {
>                                            unsigned int ofs;
>                                            unsigned int len;
>                                          };
> [16] unsigned long long mtime;     [12] unsigned long long key;
>                                        } __packed;
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,1/3] f2fs: factor out victim_entry usage from general rb_tree use
    (no matching commit)
  - [f2fs-dev,2/3] f2fs: factor out discard_cmd usage from general rb_tree use
    (no matching commit)
  - [f2fs-dev,3/3] f2fs: remove entire rb_entry sharing
    https://git.kernel.org/jaegeuk/f2fs/c/6b40bc364c10

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


