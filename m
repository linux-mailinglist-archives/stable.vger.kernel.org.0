Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C662634D2A9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhC2Oqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:46:37 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:40545 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231208AbhC2OqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 10:46:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 3B59816FB;
        Mon, 29 Mar 2021 10:46:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 29 Mar 2021 10:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=eKkpDu759GNYQmLWPNJwPs2ZcJZ
        sZ+svCF5iPlOlHnc=; b=nnvKxeXB41Gr/pETVeWGaZCKG4jao+vt/P+GGv8lS2t
        YzibKW/Iw+3sdiGotGsTqVxjnM0rH6DVe54hJFH3VGVXuFjqdieJVEO/ir9E6zpx
        exsFyj1Xh4b/KAODauPJfmQdNsXHpvpElMMttkw4O9TODzMFB8/osHbWvagGIjC8
        kH7Irad3X4G2CUPtPlfIfzheewwo16zGkIel6ac8NkTB9GGyToTpWQzN7M1HHPg3
        Ze7VO0kS+ZK/IM3er83MsmK/4svc1VMFLx6f3slf0it57bon0o6jQvk+PQgSTZs1
        ShK5wpQ3zw/jVlUPxHbadms8Ptlw8UUiC6+CGjVHCkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eKkpDu
        759GNYQmLWPNJwPs2ZcJZsZ+svCF5iPlOlHnc=; b=IwGxRNZDCTHJo7jA7e8I8q
        hu30CzoZkKuenczUXk4JpL4wIc7H5s+DjAZMHHKlo9K7FMLZyzilRSJDT6DU0Vth
        a0MU5nKtuqL0jOVjdLelglAJEdmNotQ0YqdmboXAwvBKUObHDwx63emEIC7WNSvs
        a68MTzK0+LN3BJCe6oE0F07W8zNPCBS4LnuMWWeb2EEFyJotqiGBNauFRPE1sjcl
        BnuhXzqBoTg+AzrvsTolWA6lN9l9x6UwOygUgOoipK3zcxCxEENDjXjsMlvhirOq
        gpqhvLvrjMB0clxel4gjMkWbqlpGTrvtl+NedSgz+p3Rqk1VLhKt674h62pJ/xPg
        ==
X-ME-Sender: <xms:QOhhYCzoG2-faUB1pFLierDyWavKaUheBvh-BuA2YppA-G9FiH0U-A>
    <xme:QOhhYOR-_9kCJk47LGIr6nGvRdid-tGlut4qSSYJPo8wTJkxvHoRhMhcjQcX6AHbO
    HRBSMgtbP1F5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QOhhYEU3WgcEEtmFQ_csxjzM6THrhAeoqP2W8877A4lWk53bmQfK3w>
    <xmx:QOhhYIjykD2QFJZ0zEqowI4i8xDdWcHXpSu9fZYkQbWFcZdlMeSztQ>
    <xmx:QOhhYEA4QTIrm78JA8ssgahRFqUktn7_I3kBeChLNaMmLy7Z5uBHJg>
    <xmx:QOhhYPoXO_vWdEhRn-3dh9PkvbaZdez27lNG9iUrhnTxqLrePrbIlQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EE4281080057;
        Mon, 29 Mar 2021 10:46:23 -0400 (EDT)
Date:   Mon, 29 Mar 2021 16:46:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Ronald Warsow <rwarsow@gmx.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.11 000/252] 5.11.11-rc2 review
Message-ID: <YGHoPbwu3D9DXnCB@kroah.com>
References: <d11fe153-b3a3-94f0-a425-ad4881a82412@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d11fe153-b3a3-94f0-a425-ad4881a82412@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 04:40:00PM +0200, Ronald Warsow wrote:
> hello
> 
> 5.11.11-rc2 compiles, boots and run fine here (on an i7-6700 with Fedora
> 34 Beta)
> 
> Thanks.
> 
> but I see some error's/warning's with the new gcc-11.0.1 compared to the
> elder gcc-10.2.1-11

Do you also see those gcc-11 warnings on Linus's tree?  I don't think
I've started to backport any gcc-11 fixes like this to older kernels
just yet.

thanks,

greg k-h
