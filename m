Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B264268D537
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBGLN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjBGLN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:13:27 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0009D4EFA;
        Tue,  7 Feb 2023 03:13:25 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6BE7B5C01D3;
        Tue,  7 Feb 2023 06:13:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 07 Feb 2023 06:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1675768405; x=
        1675854805; bh=WZYs1x/UavoQa71ZB115k4i1sskLTybkOJUP/M2lHOc=; b=m
        E8rni/2wxR7gVqO0cf1LUpVxjxKPi+JRZBZRQRdJNYc9vd3CDBtBQ5jfsZcCi60K
        LHRaSCQs7QAcd1V2io1nVUkdLe8ZJs97Q6dgjqOxJWfAZ5hHmYXvka9Etc8tIFtd
        vZMy5g/U6n3b7LqT30ODJ/Pv9LwLxSPEF+1P6uCpwwf6z6HuzGgpEkdG4CPol62H
        p+4D9r2SrOjy+nZ8rJ6fVUGZxyObxzB3HiEsIHK+SVuKzCblS3bdWRWxXgIfb9OJ
        J1pwzQAXi3Z0WPbfKD8Brd5n4vdoc7M3FBI4AZwVsRFBsh+T/jHoxkwvLltELbNK
        f98leM/lbUZEr8PXdUkIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1675768405; x=
        1675854805; bh=WZYs1x/UavoQa71ZB115k4i1sskLTybkOJUP/M2lHOc=; b=O
        N+n4aUn5b8/hezdJ+s/QxjXVcByseJEYkCVc0MXHbA9WraKPtwOQgqBV1FbcRk1p
        QiZQ3X3SeAEk+tb3jf/Bo9U4A7uFtmPQSkGWqmvj12JC01TMVhGQqrjgiOBynMiD
        OqasEaWIJvD7pCyfUJpQd8Hiu2wOQtWWFWf0qJIi7mqeK3Cs2vorPS73m5iQOOhT
        G/PetqrBIjEU48ZPxOXOYILmjrKHuU6fqih2RhSAjJEJjO5EZhgUn5WaRq7PmzrV
        0kgiTinOI3nLm5ghL9HvzbKxOGg5RDFaR+szfYTw+3yBaJpXoxfCoYpYQ8Prf0eJ
        reA/BTDNMj1JG/pX4jzHw==
X-ME-Sender: <xms:VDLiY4GkVJOUGmGmCI3Cf2ECiml70meLbUzpf2IRmrbCMgUBgI4VhQ>
    <xme:VDLiYxUNuJO1NWDb9BZ1q3gPNhKifjwu-4KTxoDAt8tHjKY28kz8KOPcbRzjFhhMZ
    t45czKQH6IPdw>
X-ME-Received: <xmr:VDLiYyLI2n2mJehYWylrLl7kOOSK4dHf0861838XHVyamJduJrU1C4nf78JNA6kzP6F2StgYkNEyVeorNNmRQ5MEZb7ZD0ucf9j02g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeelke
    ehjeejieehjedvteehjeevkedugeeuiefgfedufefgfffhfeetueeikedufeenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:VDLiY6EuMWYQz5qMAo_OBz6PzJjl5C8QO9-xZVTKLeVeDD2bZCtKRw>
    <xmx:VDLiY-VEhYm7xU-SE6sasUC0rhL9_Yh6qWwMegnjmk0vKqCcTpy2tg>
    <xmx:VDLiY9OvpuM90_LaYM-7TffvhyOIj8tCkbI_en5HX3mPcPZH1HTQ5w>
    <xmx:VTLiY8P0ubta7rl-5AeWK7LIG0Ph6kgaaNoDinQiPZVVIXcPTT1gKg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Feb 2023 06:13:23 -0500 (EST)
Date:   Tue, 7 Feb 2023 12:13:17 +0100
From:   Greg KH <greg@kroah.com>
To:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     stable-commits@vger.kernel.org, yuancan@huawei.com,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Subject: Re: Patch "bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()"
 has been added to the 5.10-stable tree
Message-ID: <Y+IyTebz+i9PVi1s@kroah.com>
References: <20230206134506.1652464-1-sashal@kernel.org>
 <12145054.O9o76ZdvQC@jernej-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12145054.O9o76ZdvQC@jernej-laptop>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 06, 2023 at 05:13:49PM +0100, Jernej Škrabec wrote:
> Hi Sasha!
> 
> Dne ponedeljek, 06. februar 2023 ob 14:45:06 CET je Sasha Levin napisal(a):
> > This is a note to let you know that I've just added the patch titled
> > 
> >     bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()
> > 
> > to the 5.10-stable tree which can be found at:
> >    
> > http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=sum
> > mary
> > 
> > The filename of the patch is:
> >      bus-sunxi-rsb-fix-error-handling-in-sunxi_rsb_init.patch
> > and it can be found in the queue-5.10 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > 
> > commit ad954fdfb62b7541a93ce1a12da025a8f698d8a8
> > Author: Yuan Can <yuancan@huawei.com>
> > Date:   Wed Nov 23 09:42:00 2022 +0000
> > 
> >     bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()
> > 
> >     [ Upstream commit f71eaf2708be7831428eacae7db25d8ec6b8b4c5 ]
> > 
> >     The sunxi_rsb_init() returns the platform_driver_register() directly
> >     without checking its return value, if platform_driver_register() failed,
> > the sunxi_rsb_bus is not unregistered.
> >     Fix by unregister sunxi_rsb_bus when platform_driver_register() failed.
> > 
> >     Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced
> > Serial Bus") Signed-off-by: Yuan Can <yuancan@huawei.com>
> >     Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> >     Link:
> > https://lore.kernel.org/r/20221123094200.12036-1-yuancan@huawei.com
> > Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> >     Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
> > index f8c29b888e6b..98cbb18f17fa 100644
> > --- a/drivers/bus/sunxi-rsb.c
> > +++ b/drivers/bus/sunxi-rsb.c
> > @@ -781,7 +781,13 @@ static int __init sunxi_rsb_init(void)
> >  		return ret;
> >  	}
> > 
> > -	return platform_driver_register(&sunxi_rsb_driver);
> > +	ret = platform_driver_register(&sunxi_rsb_driver);
> > +	if (ret) {
> > +		bus_unregister(&sunxi_rsb_bus);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> >  }
> >  module_init(sunxi_rsb_init);
> > 
> > diff --git a/sound/soc/intel/boards/bytcr_rt5651.c
> > b/sound/soc/intel/boards/bytcr_rt5651.c index bf8b87d45cb0..2c76f0abeeca
> > 100644
> > --- a/sound/soc/intel/boards/bytcr_rt5651.c
> > +++ b/sound/soc/intel/boards/bytcr_rt5651.c
> > @@ -918,7 +918,6 @@ static int snd_byt_rt5651_mc_probe(struct
> > platform_device *pdev) if (adev) {
> >  		snprintf(byt_rt5651_codec_name, 
> sizeof(byt_rt5651_codec_name),
> >  			 "i2c-%s", acpi_dev_name(adev));
> > -		put_device(&adev->dev);
> >  		byt_rt5651_dais[dai_index].codecs->name = 
> byt_rt5651_codec_name;
> >  	} else {
> >  		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", 
> mach->id);
> > @@ -927,6 +926,7 @@ static int snd_byt_rt5651_mc_probe(struct
> > platform_device *pdev)
> > 
> >  	codec_dev = bus_find_device_by_name(&i2c_bus_type, NULL,
> >  					    
> byt_rt5651_codec_name);
> > +	acpi_dev_put(adev);
> >  	if (!codec_dev)
> >  		return -EPROBE_DEFER;
> 
> Above bytcr_rt5651.c changes are unrelated to original commit. Did you merge 
> two commits by mistake?

Yes, something went wrong, I've dropped that chunk now.

thanks for the review!

greg k-h
