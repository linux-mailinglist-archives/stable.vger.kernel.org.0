Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6957E34D656
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 19:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhC2RwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 13:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231218AbhC2Rvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 13:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECFC760238;
        Mon, 29 Mar 2021 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617040302;
        bh=21vkGsP/dFjXJTcIqCD6I/h6THfSK/n6JqFd5l6v3yo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XeHSZRl/3QRiINxFO5wZNzY5smzMGsdY1UtUEIBPLKE0XOBq6mEPgR9Gyjq2Nq1D4
         qsT3tWXdyfhz5xML5hd3M8Z8kDAcTnheEQQhzCwnLp+2kQvQ9S97CqQtqaExwWmXPj
         eX2Q65D+q3top56qfn3miNP6sigLtooX1mEm/06G5aOrkmyV6yM38D3BF/NnJYNGxW
         NXx50dryERyFinXSxqTGiJExj2S/oyuxi1qFDVw2fUtT43xK9aroJxlQ8p4QjyEhfV
         ld6cLPCqX16wHYmuRHqYRlXmBdLu4QpxGrx4cYamrnsJ/CrHaPrtUI94xKpoD+KBxx
         oQWrRNbcizgEA==
Date:   Mon, 29 Mar 2021 13:51:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stable@vger.kernel.org, Sunyi Shao <sunyishao@fb.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: FAILED: Patch "ipv6: weaken the v4mapped source check" failed to
 apply to 5.4-stable tree
Message-ID: <YGITrBHLOcm5X1ky@sashalap>
References: <20210329165039.2358464-1-sashal@kernel.org>
 <20210329101957.4189475e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210329101957.4189475e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 10:19:57AM -0700, Jakub Kicinski wrote:
>On Mon, 29 Mar 2021 12:50:39 -0400 Sasha Levin wrote:
>> The patch below does not apply to the 5.4-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From dcc32f4f183ab8479041b23a1525d48233df1d43 Mon Sep 17 00:00:00 2001
>> From: Jakub Kicinski <kuba@kernel.org>
>> Date: Wed, 17 Mar 2021 09:55:15 -0700
>> Subject: [PATCH] ipv6: weaken the v4mapped source check
>
>Hi Sasha! MPTCP did not exist in older trees, you'd just need to drop
>that chunk:
>
>$ git rm net/mptcp/subflow.c
>
>and the rest should apply cleanly. Would you mind trying that? Thanks!

Will do, thanks!

-- 
Thanks,
Sasha
