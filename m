Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3C434D5EE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 19:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhC2RUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 13:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhC2RT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 13:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEEAA6195D;
        Mon, 29 Mar 2021 17:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617038399;
        bh=DwlH2s78jbtszkLIJg0pNpsXUGl+N9SZZlZqWLXtdcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sH4kxTZL9unZgBIJJe6IJigeYkfDqy9omNyDeT6zNchT3rjLucuQW2plXeJotwMJ7
         zrXQLTc45nk1nFeAB6g+kIhM+sXQU/1B3r460vRbWk4p2dvasmo5Wp3Ac6ClPwCTbX
         Fj0Dsr/YceSCrwrqsJr1pi3JMTrxCsXnP/JbGKdXbQsBma+Rdh0Vs1eUYVJd8AVk09
         QYs94oD0JQJEnE9THyRv+6Cv//Ga+cHwEA4p5kdVDm7zLKVJPnU3TxqfKhO6ffS3f1
         rZSjyHfwvyd1eFfh2QyvhLK5N5eyhsrS2f1V1JfiPgbgGd4X49fsde/0Sgq0kHXEjY
         /6p2kMl0NWeiQ==
Date:   Mon, 29 Mar 2021 10:19:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Sunyi Shao <sunyishao@fb.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: FAILED: Patch "ipv6: weaken the v4mapped source check" failed
 to apply to 5.4-stable tree
Message-ID: <20210329101957.4189475e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210329165039.2358464-1-sashal@kernel.org>
References: <20210329165039.2358464-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 12:50:39 -0400 Sasha Levin wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

> ------------------ original commit in Linus's tree ------------------
> 
> From dcc32f4f183ab8479041b23a1525d48233df1d43 Mon Sep 17 00:00:00 2001
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Wed, 17 Mar 2021 09:55:15 -0700
> Subject: [PATCH] ipv6: weaken the v4mapped source check

Hi Sasha! MPTCP did not exist in older trees, you'd just need to drop
that chunk:

$ git rm net/mptcp/subflow.c

and the rest should apply cleanly. Would you mind trying that? Thanks!
