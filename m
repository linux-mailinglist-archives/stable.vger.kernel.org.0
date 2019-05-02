Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22B711852
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 13:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEBLqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 07:46:25 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44923 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfEBLqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 07:46:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AB99525AC4;
        Thu,  2 May 2019 07:46:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 02 May 2019 07:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=rKgpGaeCu0sPpgsDi5ecs9OoJOP
        E3K93zFQ6qhFU1XE=; b=KuFNCmP26pjxv9fgA1IzozS01i6MUrUKMBqC1Yx7Y0P
        DcpagR1QfuI35iSvTT9w4T/gyIJ7W5p43evcRCoYZvSsicTbUOrZZq5iCojoC8WM
        FwzijSHQYwZ9DXQn2KJDxTod1aK3Gpu4SzR7SYKzWxyaMb/zn/mQGipfMVRC3iQb
        ERA2JB+Z2xMAtP91w8/sN6EaepQa4aI7/UaOK6KmVRFUrKcfPbLk8IZ+dLrkN3mf
        ke6eWFl/rKWHk60DVsdztq+rpYezp6YfMBmP/YbMxHveo7vGAqNi3ez3mqsMDLOK
        0E7HQrSbJNi1xFXjyv3PvZBb4EFnUS9s04QuF/AsMPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rKgpGa
        eCu0sPpgsDi5ecs9OoJOPE3K93zFQ6qhFU1XE=; b=wL/HmGBXyyorTYT7w7UwjI
        Pvjez3j9u4jJsKwXyR+2ySFtOfhk1sP4tACypEc9O3ir23NvCm72U46OY8iUULDv
        j5tUyNmj0PFHoXtpQkDVnHC5/EYBJqzYbmww5sTIwgutuBzk3kVqvFcmNGi+yStc
        rEwtaY178JXxBPE+brAAAv2BAazbHPpQfsl0ukoE7+QjDh6RDnrq84i7LGynVKfE
        w9bZc7BBOeCMDqPK7zYaSlz713dodYEXH+iVum/27b4SDAxQCM4S6Xx7nmwl7lY6
        +r2BvufhefuOtcr/W0zfAI5xYxtPqLWszZc9oQBwK+ndntmt17lcz5gFV5gUaqJw
        ==
X-ME-Sender: <xms:j9jKXA4wO5Y1uijLSGmIVzBFCsD5648XEj_XZQfOCoXOG51F51p9Dg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:j9jKXOhV5NF5YEUmQ1iEad0HnrNJfRYYi5LCKqqj4RMH_dh0aY7NfA>
    <xmx:j9jKXF1pZ4l1dKtQ6DPyrQMQiC012yLiPqRpsBwERPIavNK-QAffjw>
    <xmx:j9jKXPAA-w7u889bWhrQGkV8TGADcCPcePHxXRN1B7XSTyQHn-b0zA>
    <xmx:j9jKXOA4QravYzq3bX71o6YalxxmDnnBSC7lxmqkM4Z5UQQ0-PXZKQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE7C210369;
        Thu,  2 May 2019 07:46:22 -0400 (EDT)
Date:   Thu, 2 May 2019 13:46:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 4.9] media: vivid: check if the cec_adapter is valid
Message-ID: <20190502114621.GA24696@kroah.com>
References: <20190502051546.12515-1-naresh.kamboju@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502051546.12515-1-naresh.kamboju@linaro.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 06:15:46AM +0100, Naresh Kamboju wrote:
> commit ed356f110403f6acc64dcbbbfdc38662ab9b06c2 upstream.
> 
> If CEC is not enabled for the vivid driver, then the adap pointer is NULL
> and 'adap->phys_addr' will fail.
> 
> Cc: <stable@vger.kernel.org> # v4.9
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> [ Naresh: Fixed rebase conflict ]
> Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> ---
>  drivers/media/platform/vivid/vivid-vid-common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
> index f9a810e3f521..d380c2da1926 100644
> --- a/drivers/media/platform/vivid/vivid-vid-common.c
> +++ b/drivers/media/platform/vivid/vivid-vid-common.c
> @@ -841,6 +841,7 @@ int vidioc_g_edid(struct file *file, void *_fh,
>  	if (edid->start_block + edid->blocks > dev->edid_blocks)
>  		edid->blocks = dev->edid_blocks - edid->start_block;
>  	memcpy(edid->edid, dev->edid, edid->blocks * 128);
> -	cec_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
> +        if (adap)

No tabs?

I'll go fix that up by hand :(

