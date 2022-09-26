Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887895E98C9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 07:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiIZF07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 01:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiIZF06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 01:26:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435EB22B15;
        Sun, 25 Sep 2022 22:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCFC061707;
        Mon, 26 Sep 2022 05:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BF7C433D6;
        Mon, 26 Sep 2022 05:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664170017;
        bh=273XhwOEyPWVYl3VCbxmXBs1JmTUU2NZXqQijQb2v8g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eIPcs8q+du0LaFSczlj7yEJu+bWoxSvi+UT4TwzVYA+e8Eli5jdHX73OcUqx5Zluh
         UauSsXCek1cOFiZNj4JlZVKhthdg8Bpe22q/hO/T2rdxHUF6rFT88ZUvLUmKUDmujR
         s2Hos1c9FPJwBF/MP/iEVkjCs+Fhq4/SmHCmeUfVdp9Uih5Jpyw7JhT72ySvlTZNCw
         vMqMTpWA4WIjLwu5cUGGriFmMy7+0Jvnhu/xW6MgVztUi5Mbg5kV2LjtmhqwNTcMbL
         Iho1I5zwBhN9wJOm1D7PsgrjE3RumXMqEIjA/40RaJA0xh+6E9uisBG5JcZGuRt45E
         cOHRJlRlQ17WQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <Larry.Finger@lwfinger.net>, <stable@vger.kernel.org>,
        <phhuang@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6.0-rc] wifi: rtw89: free unused skb to prevent memory leak
References: <20220926021513.5029-1-pkshih@realtek.com>
Date:   Mon, 26 Sep 2022 08:26:44 +0300
In-Reply-To: <20220926021513.5029-1-pkshih@realtek.com> (Ping-Ke Shih's
        message of "Mon, 26 Sep 2022 10:15:13 +0800")
Message-ID: <87illa7lkb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> writes:

> From: Po-Hao Huang <phhuang@realtek.com>
>
> This avoid potential memory leak under power saving mode.
>
> Fixes: fc5f311fce74 ("rtw89: don't flush hci queues and send h2c if power is off")
> Cc: stable@vger.kernel.org
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Kalle Valo <kvalo@kernel.org>
> Link: https://lore.kernel.org/r/20220916033811.13862-6-pkshih@realtek.com
> ---
> Hi Kalle,
>
> We want this patch go to v6.0-rc, because it can fix memleak caused by another
> patch. For users, this driver eats memory and could lead out-of-memory
> finally.
>
> This patch has been merged into wireless-next, but I forget to add "Fixes"
> tag and Cc stable, so I add them to commit messages. If this works, I will
> prepare another patch for v5.19.

-rc7 is already released, so we are quite late in the cycle, and I'm not
planning to submit another pull request for v6.0 unless something really
major happens. So I think it's better that you wait for the -next commit
to reach Linus' tree (should happen in next two weeks or so) and then
submit a patch to stable releases.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
