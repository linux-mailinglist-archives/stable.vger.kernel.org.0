Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD7D3A8932
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 21:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFOTI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 15:08:26 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:52587 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229749AbhFOTI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 15:08:26 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 01CA816BF;
        Tue, 15 Jun 2021 15:06:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 15 Jun 2021 15:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=A/aaGMWFGZ2Bau4QDRpBps+jvw5
        3hglCBdw4WtZRV1g=; b=k0D3mqjyfwPE5G7i6QauQw1e9chZZGE5grNG0eToCOp
        pxc9sA9N3+Z/1G7DvyMg/c9dyutiY5bLGN1nAHP/7fHqzr7ATjIc6gW00VlpLtso
        Xq/urilWHRTDoGlb7G4upmIShR/IwU26vwTHkEMGG97P8m1e+vYcyBAs5p+A95zd
        9jRfvBevb/YCAKgy3uxvmGtb0KmW8fnVfWv3wuztfzOfsS8cGh0HGCcqx3pjIUN5
        2ka59ld9YBaJYeOxoL52//4FTeulLd39g+2LfUIrnkvo9Tq/p8qW9Xmx1T3c1yfq
        /oPMOO5Wr2WbKhb1ht6eo4MakZhYNHkBpD16YAX3f2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A/aaGM
        WFGZ2Bau4QDRpBps+jvw53hglCBdw4WtZRV1g=; b=m1X0COef4Wh/KQm9R7md13
        s1nD+YxMjQyGdiGMKbkkCjBu237o6KR233R734lGyw/551ohTEh0HeUFdTjkahpT
        aF30Q5TUbQye8HYTKevmPzmkIl+R6vZqI0eMh/FKk463nEwOqNb08/Ie9QCi6MNH
        GF6lJlqZdp+E7MhSUhzbBIPE+FkJjdYU/tFvlCxv5robKNtqkJmDwDxjnQcDRlte
        Bvma/hO2AnWImfU576UqwYc6NY+sBmjtBtbzSsv57sHlPqTYHLdYibAb14Xnt0bi
        XzR7v+i8jklghjMz7qo4gDKrs0UmJiZ+n9mXbjiM2EYY/uLAw2neNdAUPNdn86fw
        ==
X-ME-Sender: <xms:K_rIYKwznbyxVxx8X_ZFi4Z1goldtRSKO1O5w7MOwcDm5zflca3iJA>
    <xme:K_rIYGSk4Z0KR5RSqUaggAYm8tgYxgvWpuX-6Cx7TVYLZ2S7IPDnnJkNpZcRoc7nP
    NbPMa9cxDIvYw>
X-ME-Received: <xmr:K_rIYMUuVS4tUvv_NFmaRDOU0Hhj_EVXLghXqFWGlRJcUuHl1I4KGB3NMixgHN8GCZ3uOdv6lCXFZU4KZtLyg0kwwufdB7c1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvjedgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:K_rIYAhUyXrSQL-7mFhaKdXADQPLgA8xZiY4_e5R3XsySGRo3hFepw>
    <xmx:K_rIYMC728wvLj5B9ESkZoRPgNkQvm6vsMi_FHdgSd8EwAVTFvlR3Q>
    <xmx:K_rIYBINJLp-lDOcP2MNyLxOgQCM2hbkSh2fvgb5M_H_e8Jf6aGptg>
    <xmx:K_rIYGyhaFoK14gMKeJ1Uv5tEN2xWfK-Tcy_O-AmGv5elJxE4F2Fk4ybloE>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Jun 2021 15:06:19 -0400 (EDT)
Date:   Tue, 15 Jun 2021 21:06:16 +0200
From:   Greg KH <greg@kroah.com>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 2/4] remoteproc: core: Move validate before device add
Message-ID: <YMj6KOb2uNdA9Tpj@kroah.com>
References: <1623783824-13395-1-git-send-email-sidgup@codeaurora.org>
 <1623783824-13395-3-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623783824-13395-3-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 12:03:42PM -0700, Siddharth Gupta wrote:
> We can validate whether the remoteproc is correctly setup before
> making the cdev_add and device_add calls. This saves us the
> trouble of cleaning up later on.
> 
> Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/remoteproc/remoteproc_core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Why is this relevant for stable?  What commit does this fix?  Please put
a Fixes: tag for that.

thanks,

greg k-h
