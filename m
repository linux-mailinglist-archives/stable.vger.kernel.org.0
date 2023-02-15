Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F106982C9
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 19:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBOSAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 13:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjBOSAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 13:00:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C157F27996;
        Wed, 15 Feb 2023 10:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 705A6B82335;
        Wed, 15 Feb 2023 18:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06137C433D2;
        Wed, 15 Feb 2023 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676484020;
        bh=UB6g6f76xAmdWGxPMMVT+GkA0BVI+b2dW+DWv+0yrko=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kQpcRKwU/eR9BB7oqPSpWVEqLxWzTCzLgsTDMmL8XuEHgl8YUKpXlkoesHJinDnPc
         gJse11kORQzh6V2PZHDVDRi4tN6DyWCyy9U6Tnds+/DMR5pdFiYMEzGe9u4/a+qYHw
         yLXuPXM7KdB86lPqvMi/hI9yPo49pBR2khHYYSvMGfTZLN5ClZQ4VzlW1RG4Htkfb9
         jIwSfAJxoEEj40PrNHCh3z9sCLbHegL04hdItpB0wbfvHM4hit24kkRjpZQvH5SVXW
         apUOn/V9Lpe85Bvt0iZcRPavsD6rd8OFYuVw87YEwCJ+L9a0JgPraF6xWbj98uE5v/
         fG+5qQJrU9sBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB60BC41677;
        Wed, 15 Feb 2023 18:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] f2fs: Revert "f2fs: truncate blocks in batch in
 __complete_revoke_list()"
From:   patchwork-bot+f2fs@kernel.org
Message-Id: <167648401981.12560.5377751239465561928.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 18:00:19 +0000
References: <20230214235719.799831-1-jaegeuk@kernel.org>
In-Reply-To: <20230214235719.799831-1-jaegeuk@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Tue, 14 Feb 2023 15:57:19 -0800 you wrote:
> We should not truncate replaced blocks, and were supposed to truncate the first
> part as well.
> 
> This reverts commit 78a99fe6254cad4be310cd84af39f6c46b668c72.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] f2fs: Revert "f2fs: truncate blocks in batch in __complete_revoke_list()"
    https://git.kernel.org/jaegeuk/f2fs/c/c7dbc0668829

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


