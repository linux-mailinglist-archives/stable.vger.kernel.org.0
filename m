Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCDEF69C2
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 16:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKJPek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 10:34:40 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33281 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726653AbfKJPej (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 10:34:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9B091412;
        Sun, 10 Nov 2019 10:34:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 10 Nov 2019 10:34:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=jIDeH2sJ/VlBR52JL2i1+2RenUQ
        AFXoezfuK16AoBEA=; b=jPdQZNljeEryoxvh73Z7lBW20p+qALIczcbTBZom5OL
        bRrYMgs63R8t21/tP4J3yQA7TOtntChgRcAZwdOokb/nJvA/FKeH3RT2Vijs94R4
        B111es/697CgXiom77b+RKzRFbkID+kQkXhUbcMtKW2h1FyjB1lYrFSvzcfqizGk
        dLU6P/yvjWtdek0BLWj2yR4hOE7VEBjqaRfWIFFVEeWmg+AMMdwpqp278RROedOG
        On2RAW3vlYlSdl6NwXk1LNnxAI41C1SmGsNIgjCM3KPMMunSpHwhGa9y+nAjbSHv
        qd3J/QAM+XJCNqMjTgP7BlmLxoBejxZP8FiD8A7jFcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jIDeH2
        sJ/VlBR52JL2i1+2RenUQAFXoezfuK16AoBEA=; b=tXCWWH5EpEn+Z/wg93ykPn
        4L0qaEwHkk1uvY6OvBZJQ+WE64SWQpuC1keHJKzyTTElUWEAjV+2118hxfjgGIiX
        +CcsdqE6bb9AzR5+z58C1EXKZbk0vbmhSGlyjqTglv/gl7ys5j1hWXFBTguUP2tz
        OjdvjJ2BRW4Q14fajKJjv1oGJPKAYJrpDIPhof6g3WQiQGJPxLsIbvoMS6LQqfnk
        hHRAWVIV0myEMwygaZibgK3wEUs1vcbC+YK6wO52Wm2E0eOxsFbWCp048hGVLVxv
        XjG7gKd0RHpUgdCXEeJlEm7f0WTDV48hyeSprKmG1ewzT86coTnpocLypYhJCLXQ
        ==
X-ME-Sender: <xms:Di7IXW3DWNTjP4o_r2FKzpyeN92uJ9V3UuO0IrCDn8HtSLRtvHnH1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvhedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Di7IXb-FZsZ_kN8xWzp50Ut0xZk64CjGBWiVdjppSjNA_hR_QUcE4g>
    <xmx:Di7IXfsrWGVPctjwiBHI_y2V41QZ21Q4zrVilJnV8tp9o1qNXWg_6w>
    <xmx:Di7IXZoRL8V1WiTHfSYNp7cALuXfvo1SjKtzfl3BgSvFbYdwXY8RAw>
    <xmx:Di7IXdnHOiGAyiyDCgc6CvlX_Lku3ajgCEQtIYZTV_7uJ9_3TS_9Aw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A081980059;
        Sun, 10 Nov 2019 10:34:37 -0500 (EST)
Date:   Sun, 10 Nov 2019 16:34:36 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191110153436.GA2865851@kroah.com>
References: <20191109.214709.2055803887587817489.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109.214709.2055803887587817489.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 09, 2019 at 09:47:09PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and v5.3
> stable, respectively.

All now queued up, thanks!

greg k-h
