Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A071A75A7
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407100AbgDNIQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 04:16:49 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:57023 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407098AbgDNIQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:16:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D7B5EB81;
        Tue, 14 Apr 2020 04:16:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 04:16:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=e7496xE/XvE2kl76yd1XDlfJrWO
        KhhQVlRS/d+FlTNI=; b=YckGWgTOPL8w6XJ8wkWiMJsmLmT5oI1sLPPH6jl2Vi3
        xkyTgb0apeO1x/VBBr5ni45y2ETbapY1oE8fasa8z/tCitXgBQmWZHl3ZqmKSaEU
        UcgSpEVE3YzhH2oE1liCpVn69gU9sLuFAOEotNCMGzYCGwYRbQzEwmt0DRxdoEK3
        9mW157JHDwThUPBg8PrPKQzW/Vx4u/LcXrPOYylCw6+RgsQ7w1G5xCFZHdw4U03r
        oDg6fw5ulRtMAyHEuuXzKSEZa7fk/c985SCoYc2xRpAQwL4SRm/6EQCy4Z9mnDlU
        bNkkrkDoFoicQmBdvF26CA7svp5lrCelR7gdoCWdx0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e7496x
        E/XvE2kl76yd1XDlfJrWOKhhQVlRS/d+FlTNI=; b=eIBMARsY5WS6A74ZnRyPnI
        z6Gd4HkXIfegKS4k8y3bhdFSxJf0VzbRwzE8mbdsK9tsl0lH8h7x+MkkdbGhXreh
        puhcuJhBOPYVDKFtTKVeo6b/UEMkpsOIPiBm8+epOuTZUoe9ApP7G4aReB0wXfRN
        LgBiBbrtBq35/2NXUw/Y3BCrZ9U5FY4Ktwv/lZUxUx+raTd8gACBBVKIC4tzxa8T
        7crY2SOPnYMiR7P9IxZ7H0+ARLC/SgqMTYYqD2oqaDt5mbkXd3gP2QDLSpUv8vA4
        TGl8pYF92Lm0Gd639pqaDnTTdyC/fafOp8PtnxOOQ0wPVA/fcExK5Mi/40evxGbw
        ==
X-ME-Sender: <xms:bXGVXnWIVNijZeA05p6xVDR13oZ7Cj0n0L3IDtyBMZMd_lwCSNp7Eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:bXGVXpBttP2z3x8O6oJN5LUZJo74zaFykrSnJERABCFl-yv17CqIOA>
    <xmx:bXGVXi9UmE8thCaHRC6AJEauln09Q4LBu3Sx-9mCENgqYdItI9D-Wg>
    <xmx:bXGVXoElvaQ6P5sLsjohoRc30wseRiJvgD-4gsrqfku2a4b3hhS2qQ>
    <xmx:bXGVXnZ4QEevR7lUaUa2Y9kdS9tAuZ29d21nz0fk-82Yf2XngH5bTA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 090F73060069;
        Tue, 14 Apr 2020 04:16:44 -0400 (EDT)
Date:   Tue, 14 Apr 2020 10:16:43 +0200
From:   Greg KH <greg@kroah.com>
To:     Gyeongtaek Lee <gt82.lee@samsung.com>
Cc:     stable@vger.kernel.org, broonie@kernel.org, tiwai@suse.com,
        tkjung@samsung.com, hmseo@samsung.com, kimty@samsung.com
Subject: Re: [PATCH 0/4] Fixes for ASoC DPCM and topology
Message-ID: <20200414081643.GB4149624@kroah.com>
References: <CGME20200414014858epcas2p3e9028454a601cd9852ba6444f183d8c9@epcas2p3.samsung.com>
 <000401d611fe$dd1589f0$97409dd0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401d611fe$dd1589f0$97409dd0$@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 10:48:57AM +0900, Gyeongtaek Lee wrote:
> Hi,
> 
> I'd like to request cherry-picking some fixes for ALSA SoC to stable branch.
> Those patches are fix or add couple of functions which are essential when ALSA topology and Compress offload is used with Dynamic
> PCM.
> All fixes are tested on 4.19 and 5.4.
> 
> 1. Fix overflow of register mask when shift value is set to 32.
> 2. Default value setting for virtual kcontrol
> 3. Error on offload playback start or stop after pause
> 4. Prefix missing when a kcontrol is created with ASoC component with name prefix.
> 
> Commit ID:
>   0ab070917afdc93670c2d0ea02ab6defb6246a7c
>   3bbbb7728fc853d71dbce4073fef9f281fbfb4dd
>   21fca8bdbb64df1297e8c65a746c4c9f4a689751
>   abca9e4a04fbe9c6df4d48ca7517e1611812af25
> 
> Kernel version wish it to be applied:
>   5.4

Wait, you say 5.4, but you tested on 4.19?  What about older kernels,
some of these seem relevant there too.

greg k-h
