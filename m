Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E94478EBB
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbhLQO7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:59:33 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36947 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237697AbhLQO7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:59:30 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 1B4EF5C01FC;
        Fri, 17 Dec 2021 09:59:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 17 Dec 2021 09:59:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=5JbWehbjU2RrCkQ68nnZZClgrWd
        7Qgwe4atencd9qEs=; b=Dei68WGt8pBS1so2Q49jPagSIHd70J/3vZ4Oe332WDV
        DC0dysQeOaRAPQqz+HuFYI0/OYfxWg9IfQup1hSnYYsDV0XRPXnPn3LnPvHqcUmz
        BEQs09yAeR61YCMNtFr03/PNVs58TALXVrOsRJr61DJSGerYDjuvUrFTtIbvZFVC
        Od02ZJ7d/huhH+ulWp07E+gSMoNYKGFuNUeR3gInuPj/DEvjRKX89TTrf9CezSry
        BHsCqNJBDMdzkRAbD9YUYAULH/4WiKNoaXQ51PyOLvK+81XAcm+MBJrdOPAMk0AW
        QECZK/AdFHFRiakF8JCY6yqhNRAVgU+DgaLlysZRo+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5JbWeh
        bjU2RrCkQ68nnZZClgrWd7Qgwe4atencd9qEs=; b=R/Y5kNULzZ15MjmFtYdxEQ
        1+ayMDnK2kKgl6lY2NvEK6iT85K4JsGpIltBoHfIGDm9aw5oytrR9mQduZaylwvZ
        1m68z2QDYQNPVxJ4D6OY1uUMXO+HLTnXQ1mIcJy5kgst2P9cc0HvNb0VcSUh4QPy
        X/v9OdD+Y/0MxBDUjCiduTbCQsEkvo/VGuf1lS3HPwqbdrLCE92ppk9kiqFvjn98
        1nNSZVKsDpIvC8GndFjPd91zz0zbJMC2kXShJ2a0CAikfmocgyeGaYydAV8oVpap
        rEmdR/FyskruRnduepKLLuipFM4EZccwPC8ylFk3EHyFYgNEMOKUtCekyRmAVNuA
        ==
X-ME-Sender: <xms:0aW8YfZ0QclsqSf4FMibUNZvzBYJGjJwYE0zGl3ZfYsiOW5_zOC1-w>
    <xme:0aW8Yebsse6ZUVNXF7F8QXZivsE1wthAsbftE-oFoeuMiVl_XjLnVkpfH8nRmUz6X
    pXaAeZM8H3V0w>
X-ME-Received: <xmr:0aW8YR_aAEzNDb2ePqYsw8f_WralbpiDs8K4jl0Oo5AN2Xkgr_yLj_J6ihZTt87dZtwpEazOc4s5rVYGgXRG6gvltTnYhNCP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrleeigdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:0aW8YVolzFv1r2aHPkFkWTVecjMQacN4KBjHkaiEfXnauoh54qx_Gw>
    <xmx:0aW8YaqHtjbHSX9aDl3Fe1r--SxRqi9JUdGkuzG_DhrQeuUoWXDr3w>
    <xmx:0aW8YbQbOUcSqxO1ycLtANdRmnLyWG-XLHbm9MPVs29vzxTipli1vw>
    <xmx:0qW8YR0gJ1oOIa6YZSTY8eUWk_ZusrofZyXBVSfpfUSWgQ91B4DSmQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Dec 2021 09:59:29 -0500 (EST)
Date:   Fri, 17 Dec 2021 15:59:28 +0100
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: pinctrl: amd: Fix wakeups when IRQ is shared with SCI
Message-ID: <Ybyl0JQAXsesNV/B@kroah.com>
References: <SA0PR12MB4510B2B719F0088CD98DA17FE2769@SA0PR12MB4510.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA0PR12MB4510B2B719F0088CD98DA17FE2769@SA0PR12MB4510.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 08:18:17PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Can you please apply
> commit 2d54067fcd23aae61e23508425ae5b29e973573d ("pinctrl: amd: Fix wakeups when IRQ is shared with SCI") to 5.15.y?
> 
> This commit helps s2idle wakeup from internal wake sources on several shipping Lenovo laptops.

Now queued up, thanks.

greg k-h
