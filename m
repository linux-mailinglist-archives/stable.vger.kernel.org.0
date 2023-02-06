Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE8C68B489
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 04:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBFDkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 22:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFDkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 22:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3AE1421A;
        Sun,  5 Feb 2023 19:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA822B80CC3;
        Mon,  6 Feb 2023 03:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CE4FC4339C;
        Mon,  6 Feb 2023 03:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675654819;
        bh=cuUmVlIvx0t/MTXG+vkVHRIKWFYI/gJMPubicUdPKKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YXXH2KDrW8jrh5RZGN6u9Xcr8BONEkidH9bc9pqDZaJll0PjgcwqONAwyrQ0m4qU/
         T9/eQhSlXZcuQEF+qrVnwoWOUpP+9zaw+V0voBmvm+d2TVvpuRTjZMIJ5v94WhsH0e
         0r5rD6AierG0r0UMM8LYAQ5r8bYbrxqiLnjb+1P6oZ/67qXmi4U4F/FZaYp1PHs/Ho
         s720UgbRaG8lhRLDX/JMf1qS8fENc3JeyODENlQh3b1zGbBC3aylDX+KAIQXdnirHA
         cMgttt5cF1Y5DhFxnarywKSxB5PLEe6g9L+ZOnXQa4cqFnz8WyUmaK6b55cfASQlWr
         DZCQCc4x1n95w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61924E55F00;
        Mon,  6 Feb 2023 03:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix cgroup writeback accounting with
 fs-layer encryption
From:   patchwork-bot+f2fs@kernel.org
Message-Id: <167565481939.5323.10753252080244168478.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 03:40:19 +0000
References: <20230203010239.216421-1-ebiggers@kernel.org>
In-Reply-To: <20230203010239.216421-1-ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        tj@kernel.org, linux-fscrypt@vger.kernel.org, willy@infradead.org,
        linux-fsdevel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Thu,  2 Feb 2023 17:02:39 -0800 you wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When writing a page from an encrypted file that is using
> filesystem-layer encryption (not inline encryption), f2fs encrypts the
> pagecache page into a bounce page, then writes the bounce page.
> 
> It also passes the bounce page to wbc_account_cgroup_owner().  That's
> incorrect, because the bounce page is a newly allocated temporary page
> that doesn't have the memory cgroup of the original pagecache page.
> This makes wbc_account_cgroup_owner() not account the I/O to the owner
> of the pagecache page as it should.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] f2fs: fix cgroup writeback accounting with fs-layer encryption
    https://git.kernel.org/jaegeuk/f2fs/c/844545c51a5b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


