Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21E02D469B
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 17:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgLIQT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 11:19:26 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59849 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730122AbgLIQTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 11:19:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D5EEC5C018F;
        Wed,  9 Dec 2020 11:18:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 11:18:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=wvV5Bk3hSpEUj5cK5QvtkWDLPx9
        h3Rp2bDovW3FEcWU=; b=VsT8fM52DQ86349YCfrewzron9FXYk5MNI7+2ioR2nV
        6SLL731tXzMfyuWsIN/moqvCzii0Gd/EeliAzVSxN1yKYorBHJEg8Y81x9WjTybR
        Up5k3D/PecTH+zZ7EdS0WXPxXZJCQVDgG1k3bjXZEW8d+jdrjZWHxjQGveABPK3P
        18uIJPt6neVHxe4wX1nCwoGrDFh8jQa/9WkLdtuMaPkQTvJ4jtLnWQByQ7Tbyif0
        fWtztyTEQ0E3noUnrgrDcDT5UrGNeMNgj1uRbapBnYY6a7uaNkSw3taxOMiGxGkj
        nPCZK+VoAifMRNVQffPqin0icAkHrVZhfbI+anYX+5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wvV5Bk
        3hSpEUj5cK5QvtkWDLPx9h3Rp2bDovW3FEcWU=; b=c/8X3ovHvGw8/kXga9dqu+
        Tp3aSz9/W2tOfIqseTfemJQKSHCda8Fn92SaPfipHkCD+9pD/IVkAJtoCEnoAG4w
        AdYZtZCM7fbcRPt6KztTUItZUX2RXRppqNOfJywe4Dh0ZThD2iwMmNSHZH4NQ7RQ
        +XXJFr6utOjln0CR65MqB9kqaAO7F8poWygQAB+xRPL28Y7vqnzL2MVV2Z2lOCvT
        0hEgatxhH8NYxbA8wa5B1zi9GhPnb0E+V1pSFOj8bcWfz399IZ44iY7my3xO6ri5
        NrvjMpMb9VGJcxf18ZDYwWXygjcDVWtw3lL1YDv57+FgzMPfnn32yuVovWBRz5Jg
        ==
X-ME-Sender: <xms:wvjQX7osAxPXXY8rZzuz06w4vHziVcuAtWI2U5t6y4ERvDz1FbAufw>
    <xme:wvjQX1pD98HaAFMHomKkI6NlKi6STTpO48OGgpU-4g2PXna7iDvFcNOevj7m3ReNN
    lLzz1KIvxfc7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefguddvhf
    dvueegieeuvdduledtgedvteehtefhkeevkeehgfdtledvhfefvdeigeenucffohhmrghi
    nhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wvjQX4PhItfQ3ZmESuNsN_KmKUoIi_CXMPGFvKjJ8hJUGkwT_RIaOg>
    <xmx:wvjQX-4iHbRdtJfzAWAiPLE8zSPHfTz5jwCYyPgCp61YNY-EC72-5w>
    <xmx:wvjQX653dbHuqTBSYXsdTBN5ernyk5IrVUsCR3BXQSiFkul9XEysTA>
    <xmx:wvjQXwReMEoty55AaRgfBz01l3xrpjh75m3CRo0F4JWcZgB_1Qn_qQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10EAD108005C;
        Wed,  9 Dec 2020 11:18:09 -0500 (EST)
Date:   Wed, 9 Dec 2020 17:19:27 +0100
From:   Greg KH <greg@kroah.com>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] Revert "amd/amdgpu: Disable VCN DPG mode for Picasso"
Message-ID: <X9D5D/DpVrPrpEFy@kroah.com>
References: <20201209154222.1069043-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209154222.1069043-1-alexander.deucher@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:42:22AM -0500, Alex Deucher wrote:
> This patch should not have been applied to stable.  It depends
> on changes in newer drivers.
> 
> This reverts commit 756fec062e4b823bbbe10b95cbcfa84f948131c6.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1402
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/amd/amdgpu/soc15.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
> index 254ab2ada70a..c28ebf41530a 100644
> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> @@ -1220,7 +1220,8 @@ static int soc15_common_early_init(void *handle)
>  
>  			adev->pg_flags = AMD_PG_SUPPORT_SDMA |
>  				AMD_PG_SUPPORT_MMHUB |
> -				AMD_PG_SUPPORT_VCN;
> +				AMD_PG_SUPPORT_VCN |
> +				AMD_PG_SUPPORT_VCN_DPG;
>  		} else {
>  			adev->cg_flags = AMD_CG_SUPPORT_GFX_MGCG |
>  				AMD_CG_SUPPORT_GFX_MGLS |
> -- 
> 2.25.4
> 

Now queued up, thanks.

greg k-h
