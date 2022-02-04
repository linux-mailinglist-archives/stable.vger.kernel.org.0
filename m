Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEDA4A9E6F
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377254AbiBDR60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377243AbiBDR60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:58:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0987CC061714;
        Fri,  4 Feb 2022 09:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D91E61B56;
        Fri,  4 Feb 2022 17:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A287C340FB;
        Fri,  4 Feb 2022 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643997505;
        bh=zFYkm4VCUhyoKFnTtqkYM6XxiGZCvCrd3LFuBN4ldLo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fPrSZDGIMsZ5Vn7vOTJFNcO9I1qqKNVaf/ZPRLQJA8PULl6ysteDJyHveLXCuVItT
         XGHOd5ifepY/rfqNqQrD2OJgCD7UuyJJFmQ9INtCmtG4Cl1sUeI1fOmpM03Xm2ljZG
         5K0I0hWXjhuBYWrXohH05jc2DcEaq7wicXfCkPCQlxPzZrmJN5aVccFooVhxzckvJ5
         rhGGCKeUt7qW1c3mtB0CzA+g7qqYdQ2eKoO+J5PHc/GzvuBDCQ5zeLoOPlx5fIuVah
         xa6rSjMzPdSQrNfDzQugz1hFYXXntQiuF89ZBRoaPWNU6nKQ6Zfes+WctcyccooLM2
         v8VmdyRgtQ5Bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D67FAE6BBD2;
        Fri,  4 Feb 2022 17:58:24 +0000 (UTC)
Subject: Re: [GIT PULL] 9p for 5.17-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Yf0Fh7xIgJuoxuSB@codewreck.org>
References: <20220130130651.712293-1-asmadeus@codewreck.org> <Yf0Fh7xIgJuoxuSB@codewreck.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Yf0Fh7xIgJuoxuSB@codewreck.org>
X-PR-Tracked-Remote: git://github.com/martinetd/linux tags/9p-for-5.17-rc3
X-PR-Tracked-Commit-Id: 22e424feb6658c5d6789e45121830357809c59cb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1eb7de177d4073085e3a1cebf19d5d538d171f10
Message-Id: <164399750487.18890.15053692534783051413.pr-tracker-bot@kernel.org>
Date:   Fri, 04 Feb 2022 17:58:24 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pull request you sent on Fri, 4 Feb 2022 19:52:55 +0900:

> git://github.com/martinetd/linux tags/9p-for-5.17-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1eb7de177d4073085e3a1cebf19d5d538d171f10

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
