Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDCC6B829A
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 21:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCMUUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 16:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCMUUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 16:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5873934011;
        Mon, 13 Mar 2023 13:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEA7A614BC;
        Mon, 13 Mar 2023 20:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45CE9C433D2;
        Mon, 13 Mar 2023 20:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678738818;
        bh=elXHeg8+AQHHggRDBtDTTIbhG+p7aTNbqwRm6zAaP9s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YuvOpqSS/Gel/YSDIJEDVtiuBv2BDVT2ixpm6vIGeNk3/IukRNDUmLLNJc8iKHuI2
         XEojSo+n2aEd1kXJ4rPxd7nbU6q9AFu8DZyrm2ulUJAYu3VSFb4r8XK3pFsn4bNr8S
         9uXucOpyrhO42RR6MVxUT4QltshHC8nLSAed4OXAUHpx2hjYKBEAcq9fXCytenm4I8
         eo3ctz6OLA0y1bpAxZhylhszgHNYZvG5+1G3n0gIw+RNJ9Ac+DYo6JEKpP8pHA+JoM
         361rkgtGy/740PMpBMVe0zPWjVEBv1e9eZxbo8laPsmaFgVqts9+jxiFgTg44BDhoI
         yhAuoSPIMFSng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 26DE3E66CBD;
        Mon, 13 Mar 2023 20:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: fix uninitialized skipped_gc_rwsem
From:   patchwork-bot+f2fs@kernel.org
Message-Id: <167873881815.1608.4070724001980966812.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 20:20:18 +0000
References: <20230216074427epcms2p49a3d71b08d356530b40e34e750cc2366@epcms2p4>
In-Reply-To: <20230216074427epcms2p49a3d71b08d356530b40e34e750cc2366@epcms2p4>
To:     Yonggil Song <yonggil.song@samsung.com>
Cc:     chao@kernel.org, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, daehojeong@google.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
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

On Thu, 16 Feb 2023 16:44:27 +0900 you wrote:
> When f2fs skipped a gc round during victim migration, there was a bug which
> would skip all upcoming gc rounds unconditionally because skipped_gc_rwsem
> was not initialized. It fixes the bug by correctly initializing the
> skipped_gc_rwsem inside the gc loop.
> 
> Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yonggil Song <yonggil.song@samsung.com>

Here is the summary with links:
  - [f2fs-dev,v2] f2fs: fix uninitialized skipped_gc_rwsem
    https://git.kernel.org/jaegeuk/f2fs/c/196036c45f8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


