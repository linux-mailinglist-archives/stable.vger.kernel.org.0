Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98100FA42
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfD3N2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 09:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfD3NZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 09:25:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6086921707;
        Tue, 30 Apr 2019 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556630725;
        bh=HVMmC5sVHgkcsl22a0sJavWbalQlXmGpxIF+hfE4eLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=00XvEI9HOx/1hfpaSHD4CY9l1ivd757ZHhFjqGDEKFUM/9IScpI49ZHrpJxSXSPXP
         XVnyDMUcmcaEPrRNZQ/t2zxHla2//rB1fv/y2JpB5sa+WvWw5XVPO6njS39kRE64sd
         GDp/3ykYDA7SS70O0huqpMYZ9bMExir6lnbjYtCU=
Date:   Tue, 30 Apr 2019 15:25:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diana Craciun <diana.craciun@nxp.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org, mpe@ellerman.id.au
Subject: Re: [PATCH v2 stable v4.4 2/2] Documentation: Add nospectre_v1
 parameter
Message-ID: <20190430132523.GB5327@kroah.com>
References: <1556628147-15687-1-git-send-email-diana.craciun@nxp.com>
 <1556628147-15687-2-git-send-email-diana.craciun@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556628147-15687-2-git-send-email-diana.craciun@nxp.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 03:42:27PM +0300, Diana Craciun wrote:
> commit 26cb1f36c43ee6e89d2a9f48a5a7500d5248f836 upstream.
> 
> Currently only supported on powerpc.
> 
> Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  Documentation/kernel-parameters.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index f0bdf78420a0..3ff87d5d6fea 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2449,6 +2449,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			legacy floating-point registers on task switch.
>  
>  	nohugeiomap	[KNL,x86] Disable kernel huge I/O mappings.
> +	
> +	nospectre_v1	[PPC] Disable mitigations for Spectre Variant 1 (bounds
> +			check bypass). With this option data leaks are possible
> +			in the system.
>  
>  	nospectre_v2	[X86,PPC_FSL_BOOK3E] Disable all mitigations for the Spectre variant 2
>  			(indirect branch prediction) vulnerability. System may
> -- 
> 2.17.1
>

Both of these patches needed to be added to a bunch of the stable trees,
so I've now done that.

thanks,

greg k-h
