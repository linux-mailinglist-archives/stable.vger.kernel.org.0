Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAF0373583
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 09:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhEEHY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 03:24:29 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:50569 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhEEHY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 03:24:28 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id C7B2E17D9;
        Wed,  5 May 2021 03:23:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 05 May 2021 03:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Tq/vZnUTX445wRB9AFDPlOInbe4
        Vq/BsUfD5XqQu3Gw=; b=mgVgRARj+jjKXbfko1oIuzID9WEBslhWLjQvSSz7ppG
        UTJngxONP/cSO0vCxNEjt2sTs4o3Hn3yRRofdtN1K3FhUYolmMefICJu0ouoEWcl
        bLNKGzhT2yAzgX6cdvITvPsDACBGVTnb4wFalB4f2mBD+OkMpoHYX/fuZ7OaoGMP
        /0eCaJ1NQ35crsI/8A1dYGBFnx/l4wkt3O/n0bEhl+igMIuffibNGs+B1maDI9GL
        9Kufxi/w/EubPPR1WL+43oAKNtWQWke1Czn13LET7sD8XY6LAVLmMR3a+Rnok2nQ
        CHY1zMZzHgXb23qYVSWO3XsUTU1n9y0WYpucZQQBX0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Tq/vZn
        UTX445wRB9AFDPlOInbe4Vq/BsUfD5XqQu3Gw=; b=vqhL+B+VIQdyL0PNczjrc/
        z6ntpnEhz0B5lUMlQxzGUEa33nrz+gwrIeBfy8ApxkISNy+nm/xY06erHRmrChJW
        bovSObLTPMAZCpnUvJajPJtM+smmayXCDHTr/He2avThAJnsU1WYvqzivlgWjK5o
        odF8wsbTztlcv5VhhNokY/yQ8vwYfYjvQmfJxgVV3LSKglB0CgjNfWK4OGtnX+Ix
        +xO6+9GavIXZW6yTivgM2LU9NwaCVmvT9QB01INszEEzAH2Jn5W7R21h/97wMqh9
        OKcoXIXY7DCOFMHLfcJ8/TFBm1/79Ro7aXkzZTBaN81X5+C5aIpad/lPVnmKLJrw
        ==
X-ME-Sender: <xms:8keSYFSnaemIUlvhrhHOkH8xcOc2Au0sVrCN48JeEGKDsNV09Sv-_A>
    <xme:8keSYOzSt68B8bQBovMBThTqtLk_Jk4KS10fwXFQ0lgQ7OV4dtwd2rL-VbzAv5F45
    h0uqL-r2pYH1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:8keSYK0utQknmIzeoo8qBeQ4szU18AXgAyQKeN6LXOgxY8BuejrepQ>
    <xmx:8keSYNC5czyYck8HN5X_hgJs9GDP_zrevCsl8dSxRnjcNS_gCWgnSA>
    <xmx:8keSYOjBOp4LU52iUD7zwqwEFDWXJz26QonobLVRekjXdoPI4X8bUA>
    <xmx:80eSYCjwqxJ4gMPA2FgnxCHCHCRMnZrtD9wGJXto_OFTisAClXT7JA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 03:23:30 -0400 (EDT)
Date:   Wed, 5 May 2021 09:23:28 +0200
From:   Greg KH <greg@kroah.com>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Subject: Re: [PATCH v2 5.10 0/9] preserve DMA offsets when using swiotlb
Message-ID: <YJJH8Jy8VjFmR2AL@kroah.com>
References: <20210429173315.1252465-1-jxgao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 29, 2021 at 05:33:06PM +0000, Jianxiong Gao wrote:
> We observed several NVMe failures when running with SWIOTLB. The root
> cause of the issue is that when data is mapped via SWIOTLB, the address
> offset is not preserved. Several device drivers including the NVMe
> driver relies on this offset to function correctly.
> 
> Even though we discovered the error when running using AMD SEV, we have
> reproduced the same error in Rhel 8 without SEV. By adding swiotlb=force
> option to the boot command line parameter, NVMe funcionality is
> impacted. For example formatting a disk into xfs format returns an
> error.
> 
> 
> ----
> Changes in v2:
> Rebased patches to 5.10.33

It looks like if I were to take these now, we need to also have a
version for 5.11.y because you can not upgrade from an older kernel and
have a "regression" like this, right?

5.11.y will still be alive for at least a week or so, let me see if your
backports work there or not...

thanks,

greg k-h
