Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370735ABB62
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 01:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiIBXsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 19:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiIBXsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 19:48:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B8A106DA4;
        Fri,  2 Sep 2022 16:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E63CCB82E0A;
        Fri,  2 Sep 2022 23:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3B4EC433C1;
        Fri,  2 Sep 2022 23:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662162492;
        bh=qhfsEkifW71IEPGW+0CPZfPYtHJyIl9VFVZwDOlc9wg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=r/CouHhll325bB+sNBgV8dKlmcMwqMpQHrzND4UfYX00PK8DiNthiVB2NzgwCU7ez
         uwfPBtKFRLGlPJnTN6CiQTKFCdXa95X3oIGMWAosohyEsxlpLjiUQsbxJ8iGnE5ML1
         pEYXxv3qav18KsXHMEzUPhyn+dkRqslpe/aaxCeEpFLd93GjQr1UT//4RWo/ug0Hj6
         jllzUdPaQkRq1Ixfx0MqseGyHFY/pgagr5rTG+6cZgBRQHgADqJXjEu8KcutNG2jcN
         JyZNqx+qed0GpNq/7FmRKnRho03uPjgCiJ1RKcuO2gLl4Y8z3krssU/6I34APdoyWa
         I83SZ8+lZCKMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A13F8E924E4;
        Fri,  2 Sep 2022 23:48:12 +0000 (UTC)
Subject: Re: [GIT PULL] Landlock fix for v6.0
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220902140400.1617323-1-mic@digikod.net>
References: <20220902140400.1617323-1-mic@digikod.net>
X-PR-Tracked-List-Id: <stable.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220902140400.1617323-1-mic@digikod.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git tags/landlock-6.0-rc4
X-PR-Tracked-Commit-Id: 55e55920bbe3ccf516022c51f5527e7d026b8f1d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0c95f02269a1ef6c3fae4f46bbdd7a4578d44b8f
Message-Id: <166216249265.12135.11311488938314646464.pr-tracker-bot@kernel.org>
Date:   Fri, 02 Sep 2022 23:48:12 +0000
To:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
        Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pull request you sent on Fri,  2 Sep 2022 16:04:00 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git tags/landlock-6.0-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0c95f02269a1ef6c3fae4f46bbdd7a4578d44b8f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
