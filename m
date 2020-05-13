Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374641D0C70
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgEMJiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:38:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54691 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbgEMJiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:38:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BDEF5C010A;
        Wed, 13 May 2020 05:38:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 13 May 2020 05:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=80tHEHi0lTTB5ZO/mxfAt2WMh78
        rd+EM8kjSKPgorto=; b=LDBw18g6O5INOJmbRNyjmeMxIjIDZmuOwJ5jPYbuZgV
        gIJK5FTVnd3ieaMsFoMvQW2DRHL92ypIzxjLeTDIGMWPUhSnVjyQ+tIlmQNXLAnm
        Am0zNMo2wwY7EJjbXXj7XiP8kxsVnSroraYW+8zswL8N1Sr/zbQ5+dUXKtFEaxk7
        v9KebsKuM5s/5lEgoB30d4v5rFx+qawesmbwZUuUeB1TLukEMpcrvsEb+vfUAYFJ
        SsOoAbeosd1djkQguED6vhjLnfxDWMeK4QKwDrtG1kMCa54DeJCUzRpTkiTifrQX
        zOdaXefUwEL7zrWw3f1DVy9Tj8PHeM3FV1Xeo792c+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=80tHEH
        i0lTTB5ZO/mxfAt2WMh78rd+EM8kjSKPgorto=; b=gux27IyLuDIEYEjJAngHpA
        jav8zzrBPM02t0oxqkHpn7hPs3SaCZvwhEdhQYEP0etMqlkOfmyFpZp8lifSzejH
        fW+mJorakZoByJf5iAtLkihskVpipm65KdgIsDJ1Xo73awWtbvGc+10Xmk7O3mnm
        9ZvvNRA9RqicPkoYkUf7JTc1R4V3oabOr/rqKMxbTbyz6OXl5yxbKV1HSGOzPwk4
        zVe8EnqrfkqI09GLHGgcbv5RXE/Bg0eRKJwlKsetuVaAttPMBbd+mIleRQPOiRwz
        8pktlsazhnUG7pcLhenpeQucnG7Wo7cN66USDopf5+1ftdpeewpRnb72WMGs6jWQ
        ==
X-ME-Sender: <xms:JMC7XuQDCg2rfjujy6pvGkTsdA4Rh8Smw7Fdhbfm6YFm3cck2Yq74A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:JMC7Xjyc6CLe_hvLpKG4OZQyOXPjauY5ZLjBALGLaMtPGgTU_A8aHw>
    <xmx:JMC7Xr3FGODhWfNgAOej67CZgsLNqNEl0vQN9-g_B7QiE1xttlIb0w>
    <xmx:JMC7XqBrUyFFaq9PiqIi4XqtGTAK7iosNqqOiNsjg0b6mpEDyDMH-Q>
    <xmx:JcC7XnL9n2Wg95e39vbnjHBNZvLNmxFUaELtUxThqUANy4IZosck_g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A1F6D3280064;
        Wed, 13 May 2020 05:38:44 -0400 (EDT)
Date:   Wed, 13 May 2020 11:38:42 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH 4.9 01/21] clk: qcom: rcg: Return failure for RCG update
Message-ID: <20200513093842.GB831267@kroah.com>
References: <20200422111957.569589-1-lee.jones@linaro.org>
 <20200422111957.569589-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422111957.569589-2-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 12:19:37PM +0100, Lee Jones wrote:
> From: Taniya Das <tdas@codeaurora.org>
> 
> [ Upstream commit 21ea4b62e1f3dc258001a68da98c9663a9dbd6c7 ]
> 
> In case of update config failure, return -EBUSY, so that consumers could
> handle the failure gracefully.
> 
> Signed-off-by: Taniya Das <tdas@codeaurora.org>
> Link: https://lkml.kernel.org/r/1557339895-21952-2-git-send-email-tdas@codeaurora.org
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/clk/qcom/clk-rcg2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Already in 4.9.219
