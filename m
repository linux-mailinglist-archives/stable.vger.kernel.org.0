Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339B34A8B17
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 19:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbiBCSBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 13:01:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34012 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiBCSBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 13:01:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A616186E
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 18:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87072C340E8;
        Thu,  3 Feb 2022 18:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643911270;
        bh=pSRQMdvARTbpbEqEosu8RhL8Y5qylnQzGiQx+1ild3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CMvJawk6TrbBRBf5nQ+9oQ/AWwpKpCv/7AA9cCIeRWw2nd3+vsG/zjwArT7WLwJ1Z
         MU04UUw7RCRG8hXaUP2GBVns8BxhdePCxPCD9ZhFLTmG3sAiJfYL9hBsf/kGE4+tcY
         3J2sCgwWJx9CgCsBkBlIDrXKyXarQgYAcqTXcII8=
Date:   Thu, 3 Feb 2022 19:01:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tony Luck <tony.luck@intel.com>
Cc:     stable@vger.kernel.org, bp@suse.de, ailin.xu@intel.com
Subject: Re: [v5.10 stable PATCH 2/2] x86/cpu: Add Xeon Icelake-D to list of
 CPUs that support PPIN
Message-ID: <YfwYYxasVcTFvcEV@kroah.com>
References: <Yfgd+nHcTbNcSHY0@kroah.com>
 <20220131174333.2000647-1-tony.luck@intel.com>
 <20220131174333.2000647-2-tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131174333.2000647-2-tony.luck@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 09:43:33AM -0800, Tony Luck wrote:
> commit e464121f2d40eabc7d11823fb26db807ce945df4 upstream
> 
> Missed adding the Icelake-D CPU to the list. It uses the same MSRs
> to control and read the inventory number as all the other models.
> 
> Fixes: dc6b025de95b ("x86/mce: Add Xeon Icelake to list of CPUs that support PPIN")
> Reported-by: Ailin Xu <ailin.xu@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20220121174743.1875294-2-tony.luck@intel.com
> ---
>  arch/x86/kernel/cpu/mce/intel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
> index 7cf08c1f082e..886d4648c9dd 100644
> --- a/arch/x86/kernel/cpu/mce/intel.c
> +++ b/arch/x86/kernel/cpu/mce/intel.c
> @@ -486,6 +486,7 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
>  	case INTEL_FAM6_BROADWELL_X:
>  	case INTEL_FAM6_SKYLAKE_X:
>  	case INTEL_FAM6_ICELAKE_X:
> +	case INTEL_FAM6_ICELAKE_D:
>  	case INTEL_FAM6_SAPPHIRERAPIDS_X:
>  	case INTEL_FAM6_XEON_PHI_KNL:
>  	case INTEL_FAM6_XEON_PHI_KNM:
> -- 
> 2.31.1
> 

Both now queued up, thanks!

greg k-h
