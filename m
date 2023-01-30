Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A55681F72
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 00:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjA3XNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 18:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjA3XNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 18:13:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3352B14495
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 15:13:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F9C2B8171F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 23:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09E99C433A0;
        Mon, 30 Jan 2023 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675119618;
        bh=mm+Hb+et6414G2nBmTQgnn6P2DF44wq1TLfITcp8GUs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S+mO+DaQb28EkVhH3xbJdk4WcVS65gbBZajh62Xve5s9YtSr7oY6i1jKcTAF6m3pn
         X/O4Md0+6I/c3u/IzlSXuU9n5A5AOzOLhqC6q325PAFspFi7bxtAnYZFKKYOw+uZVK
         M457n+3YDLCmKpSSy/ElUD9NR2cD6HCo0sIB93YHURuJcm0YCVbG/MHQ6ggNKpIsoo
         xK6+XQ5Ew/X85kIvVQWBQyIZfaYvJz/rQUDNOMh6W5tN2gK8Pe3QnPPq3+oh2co+qI
         hUQOaPiWQqeJnSBOlxYrNHNy2AxLlNzdW9k5qwYNVz5uGA9UgQAUV6UXRYgdAiDXF5
         R37SWA7cTiWQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3778E52559;
        Mon, 30 Jan 2023 23:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix information leak in
 f2fs_move_inline_dirents()
From:   patchwork-bot+f2fs@kernel.org
Message-Id: <167511961786.12751.10866509734206630885.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 23:00:17 +0000
References: <20230123070414.138052-1-ebiggers@kernel.org>
In-Reply-To: <20230123070414.138052-1-ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org,
        chao@kernel.org, glider@google.com, stable@vger.kernel.org
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

On Sun, 22 Jan 2023 23:04:14 -0800 you wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When converting an inline directory to a regular one, f2fs is leaking
> uninitialized memory to disk because it doesn't initialize the entire
> directory block.  Fix this by zero-initializing the block.
> 
> This bug was introduced by commit 4ec17d688d74 ("f2fs: avoid unneeded
> initializing when converting inline dentry"), which didn't consider the
> security implications of leaking uninitialized memory to disk.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] f2fs: fix information leak in f2fs_move_inline_dirents()
    https://git.kernel.org/jaegeuk/f2fs/c/638ce5437867

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


