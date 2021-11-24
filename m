Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF2D45CF86
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242558AbhKXWEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhKXWEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 17:04:37 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D30C061574;
        Wed, 24 Nov 2021 14:01:27 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id c4so6989293wrd.9;
        Wed, 24 Nov 2021 14:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=p820C+oziTSytDTq6zguczJmLLkCvz7rvM+1yaFOxM8=;
        b=YGIzoJZzWRoZbZOFNu+VYNd00bNVzesuoFZpUPswfKBwcGNqG7b+K5jw4jIYYEloXt
         Ezin5x4+4Ee9vqAgyy7PwThd6iEw7eW7FTiSvSJ7eohlo6S9/TkdPrCWGT1lj4Ddu08y
         9HzQNP665x8iU78UrDGZ8+8+UlUrwjmH6LqkveiVyjhseEU6ktiAQPVdig17p1Gsg4BW
         EoQ8BQ4TulYN9siQGfHxvi/EoYe5Mo1kELmlp0BKSD19TLrf4ffg+AGOBWJwogfLHb1E
         T5AM5I8O8D0+72KSJCR43L2+991Z/2k5ZnVuMZdIjO8R1Ycfg2uA8DdE01Q6TJ9QdDoq
         ixGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=p820C+oziTSytDTq6zguczJmLLkCvz7rvM+1yaFOxM8=;
        b=E/QVNWGhCw5CWvTIoSJyhNqG6yfnQeigUTVPUgk5RLIolXszHtCUMnli9gKKWvHzgq
         idLnVxH2sm2wUi3v+Mq8IuZIwjWmBrw0b9fdtfy4GERahiNnLu2oPhkheCJZRdZq4qtV
         oKDKUjMuOG023L5AvMfZUhDWYn+4TVPa+De+qnpLiuW6VhPB2VJ/mH6/UNhEQmiM0e6w
         ZoOFDfDuf5o8va/dRsKgDqDOBa1RBfUXYPZzXxXwZ4ke0Kg3kb9ooIxj0s3Tz5EiiJ7K
         wOTwAT+8GUja7/t+4gdN9fcDF+jfR2hei+TWzb9J6f/kuzz4niESgc5m5sz9KfeRDcAD
         vw/A==
X-Gm-Message-State: AOAM531BBjTSAY8VDybqtssDhi9XHpcDVoYRMwO4hrFZtCAQlz9p/gJT
        iA+Ijs4T5ZKj06dWsIOng6E=
X-Google-Smtp-Source: ABdhPJw2Ps3o+sNpv5LJqBNekayWCzdmT/NUaJ7PzBrjsGrSfqNgsNE9wlCD/bhbbwm8f+Ww6Dg8Ng==
X-Received: by 2002:a5d:6d88:: with SMTP id l8mr490047wrs.270.1637791285533;
        Wed, 24 Nov 2021 14:01:25 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id g198sm957168wme.23.2021.11.24.14.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 14:01:25 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 24 Nov 2021 23:01:24 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 028/154] ASoC: Intel: sof_sdw: add missing quirk for
 Dell SKU 0A45
Message-ID: <YZ62NH7krtupEhTa@eldamar.lan>
References: <20211124115702.361983534@linuxfoundation.org>
 <20211124115703.278367629@linuxfoundation.org>
 <YZ60vklYVessSxeU@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZ60vklYVessSxeU@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 10:55:10PM +0100, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Wed, Nov 24, 2021 at 12:57:04PM +0100, Greg Kroah-Hartman wrote:
> > From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > 
> > [ Upstream commit 64ba6d2ce72ffde70dc5a1794917bf1573203716 ]
> > 
> > This device is based on SDCA codecs but with a single amplifier
> > instead of two.
> > 
> > BugLink: https://github.com/thesofproject/linux/issues/3161
> > Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > Reviewed-by: Rander Wang <rander.wang@intel.com>
> > Reviewed-by: Bard Liao <bard.liao@intel.com>
> > Link: https://lore.kernel.org/r/20211004213512.220836-6-pierre-louis.bossart@linux.intel.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> > index 25548555d8d79..d9b864856be19 100644
> > --- a/sound/soc/intel/boards/sof_sdw.c
> > +++ b/sound/soc/intel/boards/sof_sdw.c
> > @@ -187,6 +187,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
> >  					SOF_RT715_DAI_ID_FIX |
> >  					SOF_SDW_FOUR_SPK),
> >  	},
> > +	{
> > +		.callback = sof_sdw_quirk_cb,
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
> > +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A45")
> > +		},
> > +		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
> > +					RT711_JD2 |
> > +					SOF_RT715_DAI_ID_FIX),
> > +	},
> >  	/* AlderLake devices */
> >  	{
> >  		.callback = sof_sdw_quirk_cb,
> 
> This one causes a build failure:
> 
> sound/soc/intel/boards/sof_sdw.c:197:41: error: ‘RT711_JD2’ undeclared here (not in a function)
>   197 |                                         RT711_JD2 |
>       |                                         ^~~~~~~~~
>   CC      lib/mpi/mpicoder.o
> make[7]: *** [scripts/Makefile.build:280: sound/soc/intel/boards/sof_sdw.o] Error 1
> make[6]: *** [scripts/Makefile.build:497: sound/soc/intel/boards] Error 2
> make[5]: *** [scripts/Makefile.build:497: sound/soc/intel] Error 2
> make[4]: *** [scripts/Makefile.build:497: sound/soc] Error 2
> make[3]: *** [Makefile:1822: sound] Error 2
> 
> We do not have for instance 8e6c00f1fdea ("ASoC: Intel: sof_sdw: include
> rt711.h for RT711 JD mode") for stable series. 

Should have added: [...] before 5.15-rc1.

Regards,
Salvatore
