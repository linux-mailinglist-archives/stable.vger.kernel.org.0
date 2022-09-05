Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BD35AD3C1
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiIENVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 09:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiIENVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 09:21:22 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Sep 2022 06:21:21 PDT
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D783A4AC
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 06:21:21 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1662383084; bh=eH707P4TN/fM2MtJqfQYRqonc2BUxeTlHnNhqTzypkE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=C7XRLBCzXFfhtlqubjhTHQvGaZw8becoKiteP0BFuiV788QJEgFikSawFgzwlRNGF
         9mUy7luDaWBy9f1bQtnzIsiwOUNowM4gFsypYDu132qMlNvJkss52I1jijWVgTsacq
         I714iX6GOWarDr5X7j3iCBjg+CV7f6ukVsY1yJKdPfF3UKEEyS+dR6trk2VOL4Nzc6
         +37XbA48PrCooiTUbZY+VW9cmqMUmUYuhScGZ2Eq2BK8eBJT8KugeXJP9wIPHI4ma1
         K/KdaD7qRN5OTPjuSg/LL85kL7PTxdNijDEpNFQzwq3lnrE/dffhJBLrHW7p8x00d1
         wdVo/X2Bl/IUQ==
To:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: Patch "sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb" has been added to the 4.19-stable tree
In-Reply-To: <20220905125828.1042711-1-sashal@kernel.org>
References: <20220905125828.1042711-1-sashal@kernel.org>
Date:   Mon, 05 Sep 2022 15:04:43 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87sfl6yntg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> This is a note to let you know that I've just added the patch titled
>
>     sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
>
> to the 4.19-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      sch_cake-return-__net_xmit_stolen-when-consuming-enq.patch
> and it can be found in the queue-4.19 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

This patch was subsequently reverted; please drop it from all the stable
trees. The patch to be backported instead is this one:

9efd23297cca ("sch_sfb: Don't assume the skb is still around after enqueueing to child")

-Toke
