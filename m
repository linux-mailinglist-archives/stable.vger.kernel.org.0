Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02BE96D35
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 01:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfHTXU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 19:20:27 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44299 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbfHTXU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 19:20:27 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6427F20EB0;
        Tue, 20 Aug 2019 19:20:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 20 Aug 2019 19:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Kx0mzzuILKHqzUzZSm7lpeV3USR
        iEQKJDW/MKBtMmss=; b=V5MJrSxrL7tGBj8fUZADV7kCEKCVkgZGZDtva1Uco8D
        eI3U+Y6X00TfyoEhHyuI5JekuGzR1RDqluDsUidU3Cu1qYDwnPpY70n3UorC8MCs
        RsNcDl0VJxPm4EFmLT5Y3DmZw9uQefBAodKNP7V44hBEiRkf9vdVF+bry4g/AwpC
        moTYxtfCJOxe8+iS80fOt6HzluCkIoDWoYSbHNCU+jtE9n9Dol3TdvFlvCcOG+XK
        vnm2wNBpCyJZxlmQXZOwTbTHmi+1yjYkLw572ugIyPkmb98Ngcf7E5pibeBGqO84
        sqsE0C3JVEsiOwAKCgwi+FEQZfAxizjvT13zmNKB0Fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Kx0mzz
        uILKHqzUzZSm7lpeV3USRiEQKJDW/MKBtMmss=; b=cZ+iMj/0EwGb4FUe8W5WTn
        MikDFhY3p+z9mc/hSOD70W1Nxd9GsT4MXVluAU/zntZ1L39G/HhLFpZvEJy8Sk+j
        02JUSKL2FQXyPFdk75UOLiqvTv5RYEMZyM4/YLGyho3oZx4ggIjhsRS+xHmctQd3
        NQvSEyJn+U2Dph8oAD1wW26/Qmu40XH+xjQZSfNqXTtMf/MIbvvDdrbbLgae2Zah
        cWjA7ejXKcnlMK9Q6P8UYOs+wcug+XnSqGRTniM+lPhtiF+lhTi2gyRHbRlfJ3CJ
        JhYhNSUVv86Kr591R8kPqx+4aWzwsSCB4LlWDR/ZWd8p/zgm3DOZ/ogfBcWl1ySg
        ==
X-ME-Sender: <xms:OoBcXciZbEy4FieZ9vcciKe1L07Gq-Ly5LQeEBuJ1rMZFBtPIeWwJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegvddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppedujedvrddutdegrddvge
    ekrdeggeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:OoBcXeMzeKBkXTvumLiQcedkUpzUtCcUpHZcx3GLMCa0PFefuZumnw>
    <xmx:OoBcXePqvf5swpiOnekYPPNertdXa1oiQwhm6e_0fO_q29DDTmw_aA>
    <xmx:OoBcXeJHTLjRsdgaq_XiPbgGazNdc78rjungeRy-SdxmkSL-QsZ6Ng>
    <xmx:OoBcXRGb7UTzofvv0fz6eldB1Qs7Cl0k9CHcaRYrP_-mICIY9w2Vjw>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id DBC978005C;
        Tue, 20 Aug 2019 19:20:24 -0400 (EDT)
Date:   Tue, 20 Aug 2019 16:19:18 -0700
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190820231918.GA7361@kroah.com>
References: <20190820.160155.1535852678654846372.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820.160155.1535852678654846372.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 04:01:55PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and
> v5.2 -stable, respectively.

thanks, now queued up!

greg k-h
