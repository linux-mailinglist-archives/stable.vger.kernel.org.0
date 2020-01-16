Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A7713D6DE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 10:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgAPJ2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 04:28:55 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34029 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbgAPJ2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 04:28:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2ED7D7B2;
        Thu, 16 Jan 2020 04:28:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 16 Jan 2020 04:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=2GIf0TjyF/6aCSmmcMlr32Uicwz
        tDniWsyrkL8bxe/0=; b=cDi7xaImoYTwSj7yAh1qSPHaklRV/dEbFS23zc70FHe
        4NYulVlKVhQg10jNm6Hvrcxn2hS3436Jq4Zmui/01kyFku+M4y/Zl4yUNBpaaf/t
        +5gJ2wDrEOgERth528fLyaFZs8+qJRacviHVXBFZJurBbBiEx8GNo6Tp5oHVI0Xs
        i7a+HSGu4vGvuuwTerJEGoC2NTydEZvgRqbQiNATEXcPTMnik0+Qstv8D0kjP4jl
        Z8F+tW5rO6WdVL/OytjOnA+d9bI6bm5o+XCt54B71yn1QEch70N/fLzmIAFJrIIV
        H54E0vo5+5d7UFvrQ5ifuZWgRgcbe/DsjIoftbZsZTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2GIf0T
        jyF/6aCSmmcMlr32UicwztDniWsyrkL8bxe/0=; b=Fn8H3BVY/UcnABDaUQ+8vO
        84I6eJJy4xSEQKWc6DZdkRNHgPnxzqAD2nghlcsIXedO48AjgcKDJnbuepXvCPK+
        gzYZLfOPqdMTxNNgDXCbRjPGnIR8jPQv7SnAbDIyY6AEW7f5XOzU9/LPpNV4yVKS
        9DXNgD5/0eJIC3tSTS1dyIZ/PILde1UzoCkNsnu69//Q/LxLpQV7804PNXUgbSXJ
        9q1LTB1HUYToL5KAH+4S0//Aq3LN4FtSf5YqC3tYA4Ed34YDR9ip8FdExcKE2Yrj
        VOGDTKU+9f8tTLSZm/iGjytphC90bLS2Mxi2E64Frd+iPm+MenmSk5rO8mZrDOsw
        ==
X-ME-Sender: <xms:1SwgXpV_vEWqvNqOzWtUHvKDvfqmlmPror60Sorq3Ld9Lcqj4AyI5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdehgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppedvuddvrdejkedrvddtkedrud
    egtdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:1SwgXl4d6aBIgPkCQnFcnX7LOr1qLZgjAocXNeKm5g49lglv5UQ70A>
    <xmx:1SwgXoL-SpmJWNT67zBQTNxGXIsaprWpTOmRGoRKJkOqe1agSfMUTw>
    <xmx:1SwgXuLIAtqD9bfDMfUoMSOKNJDJw4JXWqayJoIjXjHPwEJ_YGyRcw>
    <xmx:1SwgXtlciK_v70j8zk4zuVwCfnpkLtQP8r2MRc0xXoGygz2My5YvNg>
Received: from localhost (static-140-208-78-212.thenetworkfactory.nl [212.78.208.140])
        by mail.messagingengine.com (Postfix) with ESMTPA id 516C930607D0;
        Thu, 16 Jan 2020 04:28:53 -0500 (EST)
Date:   Thu, 16 Jan 2020 10:28:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     stable@vger.kernel.org, Juerg Haefliger <juergh@canonical.com>
Subject: Re: [PATCH 4.14 0/2] arm64 KPTI fixes
Message-ID: <20200116092851.GB84509@kroah.com>
References: <20200116091422.8413-1-juergh@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116091422.8413-1-juergh@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 10:14:20AM +0100, Juerg Haefliger wrote:
> Please consider the following two patches for inclusion in 4.14.
> 
> The second patch fixes a boot issue on ThunderX when erratum 27456 is
> enabled. Without it, KPTI is not turned off due to the incorrect order
> of evaluating features and errata which leads to all sorts of problems.
> 
> Dirk Mueller (1):
>   arm64: Check for errata before evaluating cpu features
> 
> Mark Rutland (1):
>   arm64: add sentinel to kpti_safe_list
> 
>  arch/arm64/kernel/cpufeature.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Both now queued up, thanks.

greg k-h
