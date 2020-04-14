Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5931A75FC
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436762AbgDNIZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 04:25:56 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:50163 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436753AbgDNIZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:25:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 74719BF9;
        Tue, 14 Apr 2020 04:25:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 04:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=NZ/7zZHYIJZ5ql3n4paH7viuRi+
        0+/CccSjboCtwclM=; b=Mm5YGY6qa98VOl75AotoU/rPFAlRoeRme71etpCXJ1a
        jCok+vr+jsub7N+dydrDcholijT+g72EVEaMtDHptOjAnHjhoEuoz+NOamT9mB4H
        rHopftJuMtVz/Au6mLasdTdoQz5YCnbwos6sGdst/UMDJyAMSVt8znyugonM4t6l
        MhKYSOncnWjXzYOSTt5cGRQAWEgs7wFraie0bTciIiVB39U0Nu9lXrO9kkugKL4W
        j6sGJfj4bOaL33iiq+pTQIX2BLmoc2CRFFsZrW7tjsBRHCQB8iSgBEajWKLkrW2L
        erdryKm3C0OV7i21l8W90GLzo/MU67uT7papxMJKzNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NZ/7zZ
        HYIJZ5ql3n4paH7viuRi+0+/CccSjboCtwclM=; b=W1bFCt18+sLd7pSSPxuju4
        c4SON0Gy0Bs4QtPWDiKKU4RYJ1j9adyA2kMwMlWcWfN3qBeR9nwxEQ2YDZv4MKbo
        STtRGHo7TE9UBNWZIiPBWfz8q13VIbsacIvF5GvynLmgpSe6OXqRD7paL5InxrnL
        jPYb4gbUSIKAf9tFVqd1OAeRlh29EW6f0cZdlrf3x6uLGVUQFiGw/WJI1gpl7u70
        0kv3PlN+lLNgVO+0wc+NR2et1vJhrs/PqC0gL3ew3h3807f6XLvOHB5Aru+3F/Dp
        Go+gGTEQQVy9mLAFlecN9jiIthBB3GDq28SkNEzyI0yyTaQdO8hY8mekfCY9Lc2A
        ==
X-ME-Sender: <xms:inOVXuIqhYdOT4StLZ4hW5QBdfY8KKIdfeuCoSuZLWUzXv2NdK6tVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:inOVXmnGpPvyc22juJLHBv29JjhSm7tAgoFadHPxM91OKMucdMu2Mw>
    <xmx:inOVXgJnmdJCQujiA5RYKYPtnlKkCB4ZDdMH2fOVMHWIM8XOrUvJtg>
    <xmx:inOVXjbPX1wRu6buvv99ZofclYA-Ja7a9FiXv5kZSMR9yylxUcduPA>
    <xmx:i3OVXpNFrf5py2tWEtliwjZ0kZk8VH0pkDkOiw_QULL6_3AjusHUHQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 646153280063;
        Tue, 14 Apr 2020 04:25:46 -0400 (EDT)
Date:   Tue, 14 Apr 2020 10:25:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Gyeongtaek Lee <gt82.lee@samsung.com>
Cc:     stable@vger.kernel.org, broonie@kernel.org, tiwai@suse.com,
        tkjung@samsung.com, hmseo@samsung.com, kimty@samsung.com
Subject: Re: [PATCH 0/4] Fixes for ASoC DPCM and topology
Message-ID: <20200414082545.GC10645@kroah.com>
References: <CGME20200414014858epcas2p3e9028454a601cd9852ba6444f183d8c9@epcas2p3.samsung.com>
 <000401d611fe$dd1589f0$97409dd0$@samsung.com>
 <20200414081643.GB4149624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414081643.GB4149624@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 10:16:43AM +0200, Greg KH wrote:
> On Tue, Apr 14, 2020 at 10:48:57AM +0900, Gyeongtaek Lee wrote:
> > Hi,
> > 
> > I'd like to request cherry-picking some fixes for ALSA SoC to stable branch.
> > Those patches are fix or add couple of functions which are essential when ALSA topology and Compress offload is used with Dynamic
> > PCM.
> > All fixes are tested on 4.19 and 5.4.
> > 
> > 1. Fix overflow of register mask when shift value is set to 32.
> > 2. Default value setting for virtual kcontrol
> > 3. Error on offload playback start or stop after pause
> > 4. Prefix missing when a kcontrol is created with ASoC component with name prefix.
> > 
> > Commit ID:
> >   0ab070917afdc93670c2d0ea02ab6defb6246a7c
> >   3bbbb7728fc853d71dbce4073fef9f281fbfb4dd
> >   21fca8bdbb64df1297e8c65a746c4c9f4a689751
> >   abca9e4a04fbe9c6df4d48ca7517e1611812af25
> > 
> > Kernel version wish it to be applied:
> >   5.4
> 
> Wait, you say 5.4, but you tested on 4.19?  What about older kernels,
> some of these seem relevant there too.

Looks like it builds everywhere, so I've now done that.  If I should
drop this from any specific kernel version, please let me know.

thanks,

greg k-h
