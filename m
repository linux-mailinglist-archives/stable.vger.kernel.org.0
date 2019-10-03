Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B2CC9BF4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 12:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfJCKQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 06:16:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:44434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbfJCKQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 06:16:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 52210AD63;
        Thu,  3 Oct 2019 10:16:00 +0000 (UTC)
Date:   Thu, 3 Oct 2019 12:15:58 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Sanyog Kale <sanyog.r.kale@intel.com>
Subject: Re: [alsa-devel] [PATCH 2/2] soundwire: depend on ACPI || OF
Message-ID: <20191003101558.GG17916@kitsune.suse.cz>
References: <20191002081717.GA4015@kitsune.suse.cz>
 <91e2fc425e0dea92d7f131da890e52af273de36c.1570005196.git.msuchanek@suse.de>
 <c0b00292-2529-135d-8282-974684508396@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0b00292-2529-135d-8282-974684508396@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 11:06:14AM -0500, Pierre-Louis Bossart wrote:
> On 10/2/19 3:33 AM, Michal Suchanek wrote:
> > Now devicetree is supposrted for probing sondwire as well.
> 
> typos...
> 
> also it'd be simpler to squash the two patches together and add in the

Except we have kernels with one or both of the patches these patches
fix.

> commit message a mention that the s390 builds without ACPI and without OF.
Makes sense.

Thanks

Michal
> 
> > 
> > Fixes: a2e484585ad3 ("soundwire: core: add device tree support for slave devices")
> > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > ---
> >   drivers/soundwire/Kconfig | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/soundwire/Kconfig b/drivers/soundwire/Kconfig
> > index c73bfbaa2659..c8c80df090d1 100644
> > --- a/drivers/soundwire/Kconfig
> > +++ b/drivers/soundwire/Kconfig
> > @@ -5,7 +5,7 @@
> >   menuconfig SOUNDWIRE
> >   	tristate "SoundWire support"
> > -	depends on ACPI
> > +	depends on ACPI || OF
> >   	help
> >   	  SoundWire is a 2-Pin interface with data and clock line ratified
> >   	  by the MIPI Alliance. SoundWire is used for transporting data
> > 
> 
