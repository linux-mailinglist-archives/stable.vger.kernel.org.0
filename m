Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0BF566152
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 04:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiGECkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 22:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiGECkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 22:40:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E2111153
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 19:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C840B8129F
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 02:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C61C3411E;
        Tue,  5 Jul 2022 02:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656988849;
        bh=2vpdBnbSxNoDHIuYnWskaqjOue0mcYSqHZRb8YwmDxY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iZ8TUNB7ybOjHgRyEAYe7bnLTDdQfZkrckBP2KdtvyWk5EF45bwY6sSldAyGM9F2l
         qK88wnnIYpD6chXO2Ty1E2BWYONRnL2R0ruYAzdflUIGoQsSAbwSNUysFiNKJ9Swla
         dPVHNeBg4H9wUZBTtD10dMpcbNkR+fvTNkw0d0mTF6Zzz5+TsYcb+DTnhHeFt1AwMt
         sQH8kONsW7iVr9hm29YoVO/44kTc7Ur4xlQmY75RxwH/34o561kk8I4vwZmBf71J9n
         gFQJxHNWhsNBia1L2ltB+uDsfn0dW5fJCj1nxgc8Q+XPxnxG1eKb+rskSlG1r2p0Ue
         ziIJLLLqQlPrg==
Date:   Mon, 4 Jul 2022 19:40:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <gregkh@linuxfoundation.org>
Cc:     katrinzhou@tencent.com, dsahern@kernel.org, edumazet@google.com,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ipv6/sit: fix ipip6_tunnel_get_prl
 return value" failed to apply to 4.9-stable tree
Message-ID: <20220704194048.47867c80@kernel.org>
In-Reply-To: <16569413791787@kroah.com>
References: <16569413791787@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 04 Jul 2022 15:29:39 +0200 gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From adabdd8f6acabc0c3fdbba2e7f5a2edd9c5ef22d Mon Sep 17 00:00:00 2001
> From: katrinzhou <katrinzhou@tencent.com>
> Date: Tue, 28 Jun 2022 11:50:30 +0800
> Subject: [PATCH] ipv6/sit: fix ipip6_tunnel_get_prl return value

FWIW you just need to pull in the nop refactor from commit 284fda1eff8a
("sit: use min") for this one to apply.
