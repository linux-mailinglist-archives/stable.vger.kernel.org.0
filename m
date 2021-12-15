Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D243475A06
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbhLON40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:56:26 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42667 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237608AbhLON40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:56:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 528DB320091B;
        Wed, 15 Dec 2021 08:56:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Dec 2021 08:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=6XUgNn1O5IRfHhgXXFLNHM6V69b
        lpy9ZfuCeSFymZGc=; b=pgwIugzcOWI2KBDZjPxZFeFnEYZy5kmRgYSP0hffND5
        43P8DhJWoYoMQGNOf4RB3vW85K65CGRqEidnGI+PMgxHtM79YUuyG2GZ8Sjj1MaV
        N7XwBGS4NA1mkK0yDBpV8D1lkkXSPCP78b94w2b7IL6OoIBQsl2fvcffN+SlQDYm
        LYqdZv5YzgNvyICbiItEjaH8cHZSnYhlYQ61lVHkdkf828thiFhmlfFpdslRmOzY
        8HlPXS+I7v5zlX61xPMlzGyXsttKh0reBnC/uwh680yj2KWuEHwaqCa8YiOxStRG
        sW7pTAfmRzOUTNFNk/Ee8mgkg+/YPD6jhtOrTYDB05Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6XUgNn
        1O5IRfHhgXXFLNHM6V69blpy9ZfuCeSFymZGc=; b=eUnH51e4wbS7XKDZAz/tdu
        krSMrPJMKV3Z4MmlulsCVFE6UTV9BaMg1iYMl/DEOdSy1ArMQQh79uUwJyMzypit
        VDH27DzeTS9XkoHEej+NHTtz7pu42sJQefoMjlKB8GTUARJdLgqDgfNqDUrnL48c
        3tw4pIuMqi6ZnE3rLVh9TIRS5rQPdyDCNBBETsIPS32dlsz44cm95185Z6jHdsS5
        ceOXoHvzF2of1SaS/woYzEjx1tz4fBvYjsrf2eensLVAkGyFTTJwgaQdVWRAQJKi
        7jscMKjzjml9plRBr/zE5Vzcg1zBg/utjuBQ/nRzrKjv2l8YHf24wS9jQYfJAL3w
        ==
X-ME-Sender: <xms:CPS5YcDB-HGkDE0dfotgZbDibwOblDybpJpc_GmCM5gGzIfzl4fnkw>
    <xme:CPS5Yega82l3ZzshqVcfTT8x1O8wvodD1VnkMwOnXZForahdvxdo13oC90BM_TXLc
    BnzM6Cfjcn6ag>
X-ME-Received: <xmr:CPS5Yfk873u1HIcRFc-f-7ba6b72Y9tb7CtJ53fN2ljQ6OrvD_Wchuy_d2DEgrGyl-Erne48D6GvWD-K7gpuffhHoloLJZru>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrledvgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CPS5YSwYFB6HVJXbBflBcBVbbxYIF7GxuUDV4F22x57eQrZ8DbcEOA>
    <xmx:CPS5YRSXGYnZPCiQBgdu2s6HJeScrHlW5zlNOwEy6jSBx2A1cj2wuA>
    <xmx:CPS5Ydbn93xZfKKaJjSivTFZvtA5EIQnSzStiulY9Aqvui1OnpB3Ng>
    <xmx:CPS5Ycfy0I8CY7UGreCZ9hfYLIclAZZKnKf03AohSufUhUg4Le-m7A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Dec 2021 08:56:24 -0500 (EST)
Date:   Wed, 15 Dec 2021 14:56:22 +0100
From:   Greg KH <greg@kroah.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.15] perf inject: Fix itrace space allowed for new
 attributes
Message-ID: <Ybn0BsCEXqdccckE@kroah.com>
References: <20211214061641.125977-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214061641.125977-1-adrian.hunter@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 08:16:41AM +0200, Adrian Hunter wrote:
> commit c29d9792607e67ed8a3f6e9db0d96836d885a8c5 upstream.
> 
> The space allowed for new attributes can be too small if existing header
> information is large. That can happen, for example, if there are very
> many CPUs, due to having an event ID per CPU per event being stored in the
> header information.
> 
> Fix by adding the existing header.data_offset. Also increase the extra
> space allowed to 8KiB and align to a 4KiB boundary for neatness.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Link: http://lore.kernel.org/lkml/20211125071457.2066863-1-adrian.hunter@intel.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> [Adrian: Backport to v5.15]
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/builtin-inject.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 6ad191e731fc..d454f5a7af93 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -819,7 +819,7 @@ static int __cmd_inject(struct perf_inject *inject)
>  		inject->tool.ordered_events = true;
>  		inject->tool.ordering_requires_timestamps = true;
>  		/* Allow space in the header for new attributes */
> -		output_data_offset = 4096;
> +		output_data_offset = roundup(8192 + session->header.data_offset, 4096);
>  		if (inject->strip)
>  			strip_init(inject);
>  	}
> -- 
> 2.25.1
> 

Now queued up, thanks.

greg k-h
