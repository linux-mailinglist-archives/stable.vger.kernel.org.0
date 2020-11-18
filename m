Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BFC2B86F0
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 22:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgKRVlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 16:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKRVlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 16:41:51 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A12C0613D4;
        Wed, 18 Nov 2020 13:41:50 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id c17so3640722wrc.11;
        Wed, 18 Nov 2020 13:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gjo4l7jEqfgUaEJTViB3FcmDbvAZcSujHdYlxEFDeHw=;
        b=V58gjjNxTRjOOuSvM8oz4SRLNgcz4ELwhVa98lKi2j3r85iTchKqAqJ7jjMxZ41ghU
         x+bNr55IxJVzPNY/MNtidNvHFZ0m0/YkoKT2o2tNXXOgaeytt9Bt4E37pnGchcEZo5jB
         C0X2qxWBM2CqNwXITyXH+I/c5Ohnu/XcYDewKkgfi6884iBxsZX64DaNDf9EpQosqGU1
         nqyElaNhkBToPJUpS8HOOs6uyESJZR0cbyTQrN5fOEVvaT0znpW5DYQypXJWOg6jzOBZ
         gg7/XBGdyPYCzyG6gWFq9iCCUg4RJ9xmvo36VftyP2LbgmcPAb+8pg9M+ap5jcTqElfe
         Tr/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gjo4l7jEqfgUaEJTViB3FcmDbvAZcSujHdYlxEFDeHw=;
        b=TYu1f03C17HlAGTxcqZcWJPl4YcbFkMAuJsnmrRrjDrIPo9nF53MwDMh1zpfjk9eGm
         d+Gg7rR+G360PYwPeby+S9zWlG6q79qW9YHafUxLJ1edoHY6/D1V3TJ8LmimASv30PA3
         p/KQpWsdZ4rkXiDU3uoXshrDfZRDTFUHB4oZJZoD5IeADwR9AYnAMx1vDVWyhEqq2iU3
         fl/J+BOE57CPWqEMIFIpqz1/6D0OwvesVnN+iLHqhD6YGz4d5E4zurY7BZe9R4LsiWjn
         wVuO1nfp89KOM3FU6IruKBwEJst3iCCOi6gPVSFrLdg/9T8Pho0H/ZFZt/A6ug8zsezX
         wtBQ==
X-Gm-Message-State: AOAM533TFvQV6v2DpzJ/VgmPP98u832ynb/uZmpFfmZmySplIpwngmBf
        KFqbiQDXrsZ+F3DdfTbtZpc=
X-Google-Smtp-Source: ABdhPJy9ee/dgg3f2T9n0yWRJmyR6W8Gb0KA8VeUzMnlnShqSnAd5OFBZpApYyKOM58j9YFclFZQbA==
X-Received: by 2002:adf:eb47:: with SMTP id u7mr6678174wrn.163.1605735709702;
        Wed, 18 Nov 2020 13:41:49 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id o197sm5480589wme.17.2020.11.18.13.41.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Nov 2020 13:41:49 -0800 (PST)
Date:   Wed, 18 Nov 2020 21:41:47 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org
Subject: Re: [PATCH 5.4 140/203] MIPS: PCI: remember nasid changed by set
 interrupt affinity
Message-ID: <20201118214147.5ghn6gtzu3jlksre@debian>
References: <20200116231745.218684830@linuxfoundation.org>
 <20200116231757.243032912@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116231757.243032912@linuxfoundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jan 17, 2020 at 12:17:37AM +0100, Greg Kroah-Hartman wrote:
> From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> 
> commit 37640adbefd66491cb8083a438f7bf366ac09bc7 upstream.
> 

<snip>

> 
> ---
>  arch/mips/pci/pci-xtalk-bridge.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> --- a/arch/mips/pci/pci-xtalk-bridge.c
> +++ b/arch/mips/pci/pci-xtalk-bridge.c
> @@ -279,16 +279,15 @@ static int bridge_set_affinity(struct ir
>  	struct bridge_irq_chip_data *data = d->chip_data;
>  	int bit = d->parent_data->hwirq;
>  	int pin = d->hwirq;
> -	nasid_t nasid;
>  	int ret, cpu;
>  
>  	ret = irq_chip_set_affinity_parent(d, mask, force);
>  	if (ret >= 0) {
>  		cpu = cpumask_first_and(mask, cpu_online_mask);
> -		nasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));
> +		data->nnasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));

This will be 'data->nasid' and its causing mips builds to fail.

-- 
Regards
Sudip
