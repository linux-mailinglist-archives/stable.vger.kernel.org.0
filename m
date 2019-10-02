Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E23BC49A2
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 10:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfJBIgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 04:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfJBIgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 04:36:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 737A1206C0;
        Wed,  2 Oct 2019 08:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570005409;
        bh=Fz3G6JDNACXQd2RhNujXk869SixEzsjL+NkZV4Cq0F8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H/cyj4XQuDZuUnYggEFCdOaT7QbbspwnS2Z+e4L/x6JPny9+x8KuJ/grHK9Tcn3UG
         uZ24/Ko13j82XZps2OqX7mJDgI6Q8bz6dllZ73XqRfTJWv899MzPCAJPs5Bp7oTX6s
         RVq3R17S8RhweG9EeeoVQrCLW6iZmAJivn5SeHWE=
Date:   Wed, 2 Oct 2019 10:36:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     alsa-devel@alsa-project.org, Vinod Koul <vkoul@kernel.org>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] soundwire: depend on ACPI || OF
Message-ID: <20191002083646.GB1687317@kroah.com>
References: <20191002081717.GA4015@kitsune.suse.cz>
 <91e2fc425e0dea92d7f131da890e52af273de36c.1570005196.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91e2fc425e0dea92d7f131da890e52af273de36c.1570005196.git.msuchanek@suse.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 10:33:30AM +0200, Michal Suchanek wrote:
> Now devicetree is supposrted for probing sondwire as well.
> 
> Fixes: a2e484585ad3 ("soundwire: core: add device tree support for slave devices")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  drivers/soundwire/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/soundwire/Kconfig b/drivers/soundwire/Kconfig
> index c73bfbaa2659..c8c80df090d1 100644
> --- a/drivers/soundwire/Kconfig
> +++ b/drivers/soundwire/Kconfig
> @@ -5,7 +5,7 @@
>  
>  menuconfig SOUNDWIRE
>  	tristate "SoundWire support"
> -	depends on ACPI
> +	depends on ACPI || OF
>  	help
>  	  SoundWire is a 2-Pin interface with data and clock line ratified
>  	  by the MIPI Alliance. SoundWire is used for transporting data
> -- 
> 2.23.0
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
