Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F30F7046
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 10:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKKJQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 04:16:31 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47113 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726768AbfKKJQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 04:16:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D10C34BB;
        Mon, 11 Nov 2019 04:16:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 04:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=767pSBRJ5shuYMbgPGJ/NNfiJLw
        uGxahyROFUAPFCyc=; b=QL7E7y/EkKZiIaXtSdO5xlErh7sWmESOBvYArr7CVfp
        eQzc3UERDa9ID9hdy2lFIlSKG6qxAErTf3njeANYlVShDy6UuKgA7ijVOvSazPcr
        g3wjoXv9ZEYeqkbXvf0xTRSWRhXoa1JYrOQt2QjNXGY0UjKrpaPoCwunhc7kKjpb
        /frGGcTi8OBPNTf8rvHE3WO9zkj3pDCRuchNBLsC22DpVKVMK6qSAL+QAJF0ZvId
        utlEu3dYSA+MdZeJj/OfIlrYwLTu+kHwKlBxe0T/sjFJirwbVVtvZg9tz2skBtgb
        uIRhrA1vAjindtTZDdMuPzbNunRo9atznS0r8/pQOhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=767pSB
        RJ5shuYMbgPGJ/NNfiJLwuGxahyROFUAPFCyc=; b=bDztKrrAvA8V+7wLK3MLVe
        m8W/bcOJD8KxIyKB8OkXlQb0Y3RFA6OsgJx61wa5oIIG5+hDfQVPgsl7LWhb0p/+
        CT+mslvrBRj7y02GVeqDbQxbQquw6kAu7SXKQrHIr36J5XLqTphRRnaHX2zJKrLw
        3Du7MBVCEO7FZh58iviSUnQ9aA2j/QYYn9KDTo4a3JdK/+Z3yrKKPdciuyhU5crQ
        3LWP5KfWvJZ4dxW4zBxAXjNSxkKfjlqolNIGNH/8oH88a1nWMsEoD8yWATMpcd8X
        A+gaQo3VAbFQXhxOkPn9ubd42Yyj/3VBXnDOW/SoYSsYkQGIgiRVKAFeL6ey8jVw
        ==
X-ME-Sender: <xms:6ybJXeu0x1QJJObgsILvHQe3sOcXCVOvVrYyrT1UytIqV59h2uVRsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvjedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6ybJXZfJyvDt3neyds_yxO2il2OqimVf6hPU5EQM6QAV3J2PtmykCA>
    <xmx:6ybJXXZ18rQyPBzQhbADNALFi019tBRuNUERxXgmFmzdQVC9g2o3Ww>
    <xmx:6ybJXUVQZqXp4-UBlASkwi0BVT8d-IaH2XgMqMnhdOezzcBG0xRdbg>
    <xmx:7CbJXe0xMG9EQdfRsehkw-9hE_MmqmKB8aUY2nxGKil6KH1KfHK83w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FF8F3060060;
        Mon, 11 Nov 2019 04:16:26 -0500 (EST)
Date:   Mon, 11 Nov 2019 10:16:24 +0100
From:   Greg KH <greg@kroah.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     "# 4 . 7" <stable@vger.kernel.org>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [BACKPORT 4.14.y 04/18] usb: dwc3: Allow disabling of
 metastability workaround
Message-ID: <20191111091624.GA4139389@kroah.com>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
 <20190905161759.28036-5-mathieu.poirier@linaro.org>
 <20190910143601.GD3362@kroah.com>
 <CANLsYkwkq2fLWsGXHxr2tSBLHdfe4JXgu8ehuD1FOEQeDAPNnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkwkq2fLWsGXHxr2tSBLHdfe4JXgu8ehuD1FOEQeDAPNnA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 08:01:40AM -0600, Mathieu Poirier wrote:
> On Tue, 10 Sep 2019 at 08:36, Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Sep 05, 2019 at 10:17:45AM -0600, Mathieu Poirier wrote:
> > > From: Roger Quadros <rogerq@ti.com>
> > >
> > > commit 42bf02ec6e420e541af9a47437d0bdf961ca2972 upstream
> > >
> > > Some platforms (e.g. TI's DRA7 USB2 instance) have more trouble
> > > with the metastability workaround as it supports only
> > > a High-Speed PHY and the PHY can enter into an Erratic state [1]
> > > when the controller is set in SuperSpeed mode as part of
> > > the metastability workaround.
> > >
> > > This causes upto 2 seconds delay in enumeration on DRA7's USB2
> > > instance in gadget mode.
> > >
> > > If these platforms can be better off without the workaround,
> > > provide a device tree property to suggest that so the workaround
> > > is avoided.
> > >
> > > [1] Device mode enumeration trace showing PHY Erratic Error.
> > >      irq/90-dwc3-969   [000] d...    52.323145: dwc3_event: event (00000901): Erratic Error [U0]
> > >      irq/90-dwc3-969   [000] d...    52.560646: dwc3_event: event (00000901): Erratic Error [U0]
> > >      irq/90-dwc3-969   [000] d...    52.798144: dwc3_event: event (00000901): Erratic Error [U0]
> >
> > Does the DT also need to get updated with this new id for this?  Is that
> > a separate patch somewhere?
> 
> The upstream commit is:
> 
> b8c9c6fa2002 ARM: dts: dra7: Disable USB metastability workaround for USB2
> 
> Should I just send the latter or you prefer a resend with both patches?

I've queued this up now, along with the rest of this series, thanks.

greg k-h
