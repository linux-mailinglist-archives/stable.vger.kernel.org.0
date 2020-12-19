Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23ECD2DEED4
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgLSMmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:42:25 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53971 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbgLSMmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 07:42:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5F2865BF;
        Sat, 19 Dec 2020 07:41:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 19 Dec 2020 07:41:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=8DD38pMm2X8PsQknQ+BBDlZ62uL
        KEHBncukr792Rblc=; b=negH9Zdyo8aH4Yzb4txrltKqx6FnKP1CCslsjW9Ncld
        LUf7Rq34p9ferCE8WnPzIMev77FyW4gstCgKuBwXS/hd4fGQIhlXpbfAJP7r3tew
        Qsq8pkVia5oURvJ/3ae83NUgTbdk1bofn5tNtoq9HysYjNGVFVOY13SgJHuQ0nFq
        Agh89SalrEKj92KmoDuF/MYMBN87AUCp6rPcAKpbMW9xlWAVw7Fanu7489OPQOt1
        gHJJ44RKbezsnVkb3xSXvHxcvl1BYGM7uR5Ron+K5CWoJC/vKQObB0hxv5y1WKGk
        QUTa2njWMNntAskwsWuNpQ5d+rcl4Xp4L/nGI92Tj7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8DD38p
        Mm2X8PsQknQ+BBDlZ62uLKEHBncukr792Rblc=; b=B2gMmMhml6FTnlzSkuE/R7
        qjKATYQU8UJ2h7BiFVF4eupvp2zvCGA9rJLgrv+O3rSKB13KsyRzHECsp7ZjrdaQ
        bE8ky2PHddO36XWvb68+rPZE1x2ziZOf1aKMSO/5WTCVcNX2Ms7bZgDGooeH+JW/
        ComKHAm30cYG7BmU4uD7Lmlbz/4lss+5j2Yx1+9VT5RkqLQWpLT3y+HtIe3sz8BY
        4/y4kwfAQnQTX68i4HK000cvqdoCxwHbme8zkfRNKdbOswUOZOyegA2W56o3fM9A
        ZQKVjosZS5HaMfvzE6YfgCMJbqm02hL7TMSj41AN50r1YBMozY6QIqex0Q3P93cg
        ==
X-ME-Sender: <xms:AvXdX2AdpZhkeNpUpbQHcWRdC_czUhROje0qlSGP8qiug4jeleuvQA>
    <xme:AvXdXwjeJ_N6EB42ew-Hnc79rATcxksAVYnGp2Yrm5mbZxRyidxI_vdxbzrBXJbjG
    qAGBpMLLx8n0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudelkedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:AvXdX5kRNfAEEk10VR7q_P7vdz6EnAjnRWx1rxZBhgLFnfDBMACgWw>
    <xmx:AvXdX0xgVyCB0khKuGxPgd6owQGy-yuL3ikud5_RNqY5kOUY7L2XQw>
    <xmx:AvXdX7QMDDAL42yhBhQ_NR-ZPXaTBV1G-7BkWMOC-6HyjKOQVI-wrA>
    <xmx:A_XdXyKpZaoqT3LArWIn0JXwJ1e9h5k156WRsyl9HkaJH1Qge8_xhQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2EFA0240062;
        Sat, 19 Dec 2020 07:41:38 -0500 (EST)
Date:   Sat, 19 Dec 2020 13:42:59 +0100
From:   Greg KH <greg@kroah.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     stable <stable@vger.kernel.org>,
        "Wilson, Chris" <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@linux.intel.com>
Subject: Re: Backport request
Message-ID: <X931U4HJVsA5jUx3@kroah.com>
References: <CAKMK7uFUbZ53RCDrYPJpmxYjevSB11NSqRVLNSX+XbzrojxaeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFUbZ53RCDrYPJpmxYjevSB11NSqRVLNSX+XbzrojxaeQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 05:02:41PM +0100, Daniel Vetter wrote:
> Dear stable team (aka Greg)
> 
> Please backport
> 
> a04ac8273665 ("drm/i915/gt: Fixup tgl mocs for PTE tracking")
> 
> Note that this needs
> 
> 4d8a5cfe3b13 ("drm/i915/gt: Initialize reserved and unspecified MOCS indices")
> 
> but that one has already a cc: stable, unfortunately the bugfix didn't.

Backport to where exactly?

These all seem to be in the 5.9.y tree already, do they need to go
further back?

thanks,

greg k-h
