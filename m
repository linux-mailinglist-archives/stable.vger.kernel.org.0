Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072591A75A1
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407053AbgDNIPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 04:15:19 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:60455 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407079AbgDNIPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:15:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id E31F8B62;
        Tue, 14 Apr 2020 04:15:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 04:15:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=KAYDgP2+3ERuysKzdTJbxKkrCC4
        kHgtMsrMB+yrniB4=; b=I9K5EgOCWSrgTD4qM5u0YxHKS++v3MYgOVQmNM90/su
        PCf2Ngd/mvKclIeyJX72OvwdDjKUpOjI+ze5lsf5lc6udyzVUTuO6kLTJQiwROyH
        /RlDYJFiaCsMpYaFXC9Py31UIdiphKuqn3rlLKgWbsv+3vwvuMArKEpR/OFmUw8I
        uDeHCCPTBrFo3YLP1MYCvNddDIHFZuu4X86ZS3XvZnfw4AWvs5Sw6t2g6l4N+U9Y
        Nu235s53W3XTzke94VdQik06pzRGdg9Qr+USOpudZBrvtDHvIkmikY41INalGSmR
        2Lk9rD3FmYd8Hw5EVPdyV7lojHPCAJ1ogyuqgmavTJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KAYDgP
        2+3ERuysKzdTJbxKkrCC4kHgtMsrMB+yrniB4=; b=RAr25LuYfyvtWIwI01cUFs
        fVYO2TRRlqMQvUcedGqAidQsiEbki1w+CvLVa+oy25mlP4lHC/Fy+0C3Qdp9+0ql
        YHYqW0B0yAFA0u+wN/O11w2coETljrHvM9GdYFOpYgITf7geh0EZYxricsu5SGWz
        2NbLepEUN+4MUXjR21sfciy9tp9FZPzq/OpumSHPoNzz4Qgoz5+h4pefp9Kn0JyY
        eD23sGvYcRN9vH15aiPD6yFcqP/+x7hoPrfLdl42+TvmFR8qkfGbVJHPl3KIGvvj
        suHmVmQlT5i6t2BGt+uc+/TLOdv+pq2pqxaXOCCQmWTL1lGT1yYO5HPlN4F6mseg
        ==
X-ME-Sender: <xms:EHGVXvj5dbFtR7DKhzpfmU1z30WHm_lOZSaWyvL7GTR8kD2A1fQDRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EHGVXgTbatx_e_HlUEz-bKsuh_WYDJy0vQ5VZqGK2MRV-gA_-ATWkw>
    <xmx:EHGVXirMRTyDdeTQU4fiOWN-BcD1B1MXftEsC_myLCkie4FqVMTP5Q>
    <xmx:EHGVXra6CVpK6-nUT92EmXXf2qRXPTOZmhY29kehfTtihwGi38xWvQ>
    <xmx:EHGVXhDkuLpbfhWuRS3S7top2nmUh-kYun1rxSeOSns1KZ__SOKhlg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04EC23060060;
        Tue, 14 Apr 2020 04:15:11 -0400 (EDT)
Date:   Tue, 14 Apr 2020 10:15:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Gyeongtaek Lee <gt82.lee@samsung.com>
Cc:     stable@vger.kernel.org, broonie@kernel.org, tiwai@suse.com,
        tkjung@samsung.com, hmseo@samsung.com, kimty@samsung.com
Subject: Re: [PATCH 0/4] Fixes for ASoC DPCM and topology
Message-ID: <20200414081510.GA4149624@kroah.com>
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

Given these showed up in 5.7-rc1, they also need to go to 5.5.y and
5.6.y as those trees are currently active.  You can not have someone
upgrade from one stable release to another one and have a regression.

thanks,

greg k-h
