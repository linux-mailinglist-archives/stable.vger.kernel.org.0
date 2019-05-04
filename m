Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461C613822
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 09:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbfEDHes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 03:34:48 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:45577 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbfEDHes (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 03:34:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 811EC42B;
        Sat,  4 May 2019 03:34:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 04 May 2019 03:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=v8VtG9rvvDICXJSc0W6/4YIWGKm
        nk5JLEsMJhhz3cmM=; b=ARinJMyIHwYR+tfIixB1W/Lb2r20XruAu+2XnWubukG
        dXPp7zJ3h1e/rgU8rmpp1APzHF1iL9Slhzi0BPzqTYpEndQCepYXPYMUg6EOHUY8
        WzWNSRw+Zu1oBvHoPnx6Q26SoiE4GTpkFC7tgnPeGbDbeluK1Gjp2hWjaimDPsBy
        57BJ93EfVho5gfqrNWZdMf/UWv8UCMD00Qo4fPn2cZj6kKsRPbg+i6rCWTWFNwGF
        WBzFa4vnivFuMFJ3L9iKWNNtWiq1fv3T4bi5MmwsfsA/FcTzL3adewXicLG6FQ0l
        nNz15vNeF3Sds6vo9nBBul7yY/9HBzc4BoLaO/nJ4Kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=v8VtG9
        rvvDICXJSc0W6/4YIWGKmnk5JLEsMJhhz3cmM=; b=PN4cgB/x+lWBKBmIrBrbA6
        WPq5UqPRC7za9eChibriNG9Hh2+TSP7MWgtenLNV5WngJ9uFloXhjI45iQLVGwku
        /OEmRBt5EQLfgy394xcI8SB7TDtkXaX0wKykmJqfNUYuFv6lTvb3ZqwRtW/JKWxO
        vHZpUS2nZ2BQ1Ck/j60QEoJxlTgDCo1gUZhZcpuLiYKNkIctArJoQGh2auRIzMVI
        B0DEKOOU+S3eTAT5HtiXbelBFuhXAY7NndbNh/PxszCjZqYhgmbD8nv7wSpoKJT/
        MnDrncbtEYhyIzb+98PmHJPoloh3NTcIeiVSe/8e7ykIxRQY5dOuS5s47ZSl98Tg
        ==
X-ME-Sender: <xms:lkDNXFQETGDqTFk6I_82DfR_UCOWyFaOhIMcAoirGQA3zk5lkzBWtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjedvgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:lkDNXHaT_xgW9nTISghWMZ1Af2iv_j91EPkfiwXQgge09DYovyZUxA>
    <xmx:lkDNXCSg-n42JhcUCPXZDTatkVlrVzmSiJ20e-oR9Vg8Bm1ZVptiGw>
    <xmx:lkDNXG-ikeUgh7sQrXk9WPCHQvv91uu0pf5g28PYRVeKyvke74BfvA>
    <xmx:l0DNXEFr8uePMtU2rcqG1xRcN8MVUAtVzrIbwmbxqXqOwI0G2MZ8wA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F19BAE448F;
        Sat,  4 May 2019 03:34:45 -0400 (EDT)
Date:   Sat, 4 May 2019 09:34:44 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190504073444.GA6294@kroah.com>
References: <20190504.030118.1910958754445226665.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504.030118.1910958754445226665.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 04, 2019 at 03:01:18AM -0400, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and
> v5.0 -stable, respectively.
> 
> Thank you.

Thanks for these, all now queued up.

greg k-h

