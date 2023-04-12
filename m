Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC5F6DFB21
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 18:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDLQUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 12:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDLQUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 12:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27D6659E;
        Wed, 12 Apr 2023 09:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF4A662D5E;
        Wed, 12 Apr 2023 16:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 473BCC4339C;
        Wed, 12 Apr 2023 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681316419;
        bh=VcYMUlalEo67BcQfGfo22Iw4VPxLqADA39fwd9YNUkQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iV5EEBNBOCmXcMsQVF+4xczLZcWmuwKkYjiv4kSm5qesS+eCR+lOwQe4EoQSnpoJb
         MrMejLpfRFtj51qF0nzP6JSVKb+S9aWrlgGsSd5I7Or6pdlMkj7YiH1GexIWMX1Xwi
         E88v8eq37u9u3+P/AyvGCH28YFC060hkPwuzO7yhMLaAVQtVkhBkXXI+egacj1+JNA
         KbQn3dj+iAtv35qCe3AIgkD0cBlVHYOQ9ti6FDv42ec6GAzPBZ0HtDsgouawZ5xlQw
         BKODCp90T7GjKPaNVh0zhzrWHKD/MX9SN++06GxfAzhWBZEbHnCScRu3DPxp4JBmoJ
         VK2EFbPOB8HSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D09EE4508E;
        Wed, 12 Apr 2023 16:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix potential corruption when moving a
 directory
From:   patchwork-bot+f2fs@kernel.org
Message-Id: <168131641911.15557.3644141537765854955.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 16:20:19 +0000
References: <20230406195122.3917650-1-jaegeuk@kernel.org>
In-Reply-To: <20230406195122.3917650-1-jaegeuk@kernel.org>
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

On Thu,  6 Apr 2023 12:51:22 -0700 you wrote:
> F2FS has the same issue in ext4_rename causing crash revealed by
> xfstests/generic/707.
> 
> See also commit 0813299c586b ("ext4: Fix possible corruption when moving a directory")
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] f2fs: fix potential corruption when moving a directory
    https://git.kernel.org/jaegeuk/f2fs/c/004620a236bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


