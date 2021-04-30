Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444E836FB99
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhD3Ngf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 09:36:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37581 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhD3Ngf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 09:36:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CE90F5C0181;
        Fri, 30 Apr 2021 09:35:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 30 Apr 2021 09:35:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=K3z5V1hxFx0Xgj+uX52x8LaC4ff
        XI/MT4G13ryQANEs=; b=rMcR+OIbZnRqqco1eCz2f2qvV81Uyge9StwYpAKg8M3
        8kILrz6sHYX4H020i9UcTI3ZKkGdlT0/sYzoI4QI/gAfObGdjtiOAVz/4bPA9mDu
        3KY2YXXm57PvbvxFigti2WvoG7g952VSLLPHUCTPjmDVYCyMJIy1FolFvlOuv5BB
        ZgB2XlyfM0ZhGzj4iR3MhfvqAP5mUVvyj/9KE5/LUHXLqTmXuSKj0m25f1xvDNnS
        Hu/tsnzUtmkjMSqv+Igw2yj2Eqlnqqt6/lRLrqmM16lWqS3sHnUTp4ezKzBB7fDe
        JatwR1q8InoxcqRCHaYGlU2ZQSJLaLQH9YCxZHBjs8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=K3z5V1
        hxFx0Xgj+uX52x8LaC4ffXI/MT4G13ryQANEs=; b=cY2Mr+0qher7laZI0AaTkE
        gjE0Me9SWCImjf14lYn5bIBo3p9m3vQr+gReIWbaSNQ54HnRNwJ3BPnbFHjBC1cq
        plWIUU7OCEjTJdWqUCKmACeLyc9q8J0Ir67VmZUghDSnCj8QBv7YcqoWGW0JPH6R
        wFRwdKk8inL6ctNDwBPItgBgaNPrmi/etyMPfqD928yXSbatVND7PhC/RWriT3LW
        xJ000GQ0lhzyFt/wiRzPTA73Bp2rNYRWh7sTowIMz7lmfwFh/IEdcbx70/Gkbe2/
        adMvG8JyyKz/eaMcFhlh7LOb71fmbrhvJHdDmA1zHpDzmG3CIAITsfO1qH4XEGpA
        ==
X-ME-Sender: <xms:sgeMYHDRECpvk3WVsKLMCHOfGctGG3MPYypBCypMeyjiCcbX-G51ZQ>
    <xme:sgeMYNjoiYBmj04ZXWXMDiS_uBZdvPF7F0W6eISgPOEQSdgH3Ygl3T0zkk_d_b10S
    e2hF4ggGU7fhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddviedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sgeMYCmMapA4lkCLXK5k_m6HrjMQZnHSgEgxUoYqYYKABG4uLnW3xQ>
    <xmx:sgeMYJzv-T9TGDtJZJt3GyItXSpuo-RMG8LUdGOv76OxJrHP4fS9uA>
    <xmx:sgeMYMTxxDLiuIEq4boeKV5-4PWuV4ets4ngVKf1sJx_4uYcehPsow>
    <xmx:sgeMYBIOPdVcj_jX4eAmD_Fwv1BoWHd6SHzVbn30Lp44hBO3PG7JIQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 30 Apr 2021 09:35:45 -0400 (EDT)
Date:   Fri, 30 Apr 2021 15:35:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Subject: Re: [PATCH] drm/amd/display: Update modifier list for gfx10_3
Message-ID: <YIwHsD/MNVf3J6Z7@kroah.com>
References: <20210430043650.1317075-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430043650.1317075-1-alexander.deucher@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 12:36:50AM -0400, Alex Deucher wrote:
> From: Qingqing Zhuo <qingqing.zhuo@amd.com>
> 
> [Why]
> Current list supports modifiers that have DCC_MAX_COMPRESSED_BLOCK
> set to AMD_FMT_MOD_DCC_BLOCK_128B, while AMD_FMT_MOD_DCC_BLOCK_64B
> is used instead by userspace.
> 
> [How]
> Replace AMD_FMT_MOD_DCC_BLOCK_128B with AMD_FMT_MOD_DCC_BLOCK_64B
> for modifiers with DCC supported.
> 
> Fixes: faa37f54ce0462 ("drm/amd/display: Expose modifiers")
> Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
> Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Tested-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> (cherry picked from commit 6d638b3ffd27036c062d32cb4efd4be172c2a65e)
> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Queued up, thanks!

greg k-h
