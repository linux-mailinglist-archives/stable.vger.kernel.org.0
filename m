Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9D632D455
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbhCDNkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:40:03 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:34773 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241366AbhCDNjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:39:43 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 93360146D;
        Thu,  4 Mar 2021 08:38:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 04 Mar 2021 08:38:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=J
        sFUfI9vnI/Wxuxff2nIgP3PmFr/du9RijU5zDv93Dk=; b=eYDWsfhZKKhgLGxok
        zn8OSZl9MF6zF72m1eiXURmektCiV9rZUhtXBj+uzpejXsaiqgm7mmMQguFVKdx9
        0kHL8RgtBVvUFntes8wMZQvJ8jDlu5uwTs33nDyqocuVs6xN+UnqxeMmUvsoybYQ
        gNy9N3u/sddxfwM+oi4X2hSDVyTxS3vQVD2AgDbmYLCvVs5keX24SwUiv98e/QXy
        BAQxcjagn/GI8Liohohrwk+bxo0Dz4tTLuYI2VBXimevo6t0qAtBxdI0ggQeK+gd
        e8GSHSp6xoo5CB1mytny+zu9aL2nY1NhhVndisCE43zZqDomzXQlSLgT821YcZ4K
        hE75Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=JsFUfI9vnI/Wxuxff2nIgP3PmFr/du9RijU5zDv93
        Dk=; b=Znl3FP9KToo6nhMPq3DaiupDD5g4ncDY2kLNPuVNmZrtkbUy8h5psPmsr
        NMJvQObrTsxmcPFNKHBbGgEjrdUj4jCFK8nyj+1k6rxTJ4phhSQIqa4u8QaH/n6F
        c4O+HuYfSF+Wn1OpaJzmvJ8dXslZxkdd7IilDhGLeY+hDClYsn8vog6P+GouKXu3
        CVIal+vZk4bj6o9cYa4LT1CRW0XD06F/GRVDsDTttVrk/+7v05S8r8UYcxITMm4z
        UlJ1yOkbzE0w9Q52nRPKaRe6kIoUH3JEJRDL7Ue4+CsdMY8Ve8uY/MsR5YCAXRmn
        +eXLgtFFz0UiXzaQQXeVUiKj9+P3g==
X-ME-Sender: <xms:7uJAYDTm1EACWXpdYavK4Qj1fGPJumTQgFD70ysrjaUL_2FjbZvUcA>
    <xme:7uJAYEs93plkLsxnZcDrmYVhmW6wTXs0N828lyeMHtZyhIESiO9sMRN-vTqDHeX_F
    5iyTGeWTFSb3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeeije
    euvdffuedvffdtteefuefhkeehgfeuffejveettdelgfeuudffffetfedtnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:7uJAYFtw-lqdcTWM1YGy9VvdobGXL81prVOO0Mmn4BNT8bBEVOm1Zg>
    <xmx:7uJAYKyFIv1vENbECzPQukANtMftTa4uWk1tDH-Gfl9YJipgdTB3rg>
    <xmx:7uJAYLh7Wj3roGP27iWmXZA0iGJ24UH7R3jCJhQh-UPW6I90hKzLGw>
    <xmx:8eJAYHmlWwwXq-tShdAz7P0K2py1rbzErCtv-TAivTHBBpotXkhfDw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A48D324005B;
        Thu,  4 Mar 2021 08:38:54 -0500 (EST)
Date:   Thu, 4 Mar 2021 14:38:52 +0100
From:   Greg KH <greg@kroah.com>
To:     Nikolai Kostrigin <nickel@basealt.ru>
Cc:     stable@vger.kernel.org, jingle <jingle.wu@emc.com.tw>,
        kernel@pengutronix.de, linux-input@vger.kernel.org,
        'Dmitry Torokhov' <dmitry.torokhov@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: Re: elan_i2c: failed to read report data: -71
Message-ID: <YEDi7H9uIxk6Gb4x@kroah.com>
References: <20210302210934.iro3a6chigx72r4n@pengutronix.de>
 <016d01d70fdb$2aa48b00$7feda100$@emc.com.tw>
 <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
 <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
 <YEA9oajb7qj6LGPD@google.com>
 <20210304065958.n3u5ewoby6rjsdvj@pengutronix.de>
 <15cb57ba-9188-51a1-b931-da45932e199f@basealt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15cb57ba-9188-51a1-b931-da45932e199f@basealt.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 11:49:59AM +0300, Nikolai Kostrigin wrote:
> Hi,
> 
> 04.03.2021 09:59, Uwe Kleine-König пишет:
> > Hello,
> > 
> > On Wed, Mar 03, 2021 at 05:53:37PM -0800, 'Dmitry Torokhov' wrote:
> >> On Wed, Mar 03, 2021 at 09:03:30PM +0100, Uwe Kleine-König wrote:
> >>> On Wed, Mar 03, 2021 at 07:32:23PM +0100, Uwe Kleine-König wrote:
> >>>> On Wed, Mar 03, 2021 at 11:13:21AM +0800, jingle wrote:
> >>>>> Please updates this patchs.
> >>>>>
> >>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=056115daede8d01f71732bc7d778fb85acee8eb6
> >>>>>
> >>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=e4c9062717feda88900b566463228d1c4910af6d
> >>>>
> >>>> The first was one of the two patches I already tried, but the latter
> >>>> indeed fixes my problem \o/.
> >>>>
> >>>> @Dmitry: If you don't consider your tree stable, feel free to add a
> >>>>
> >>>> 	Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >>>>
> >>>> to e4c9062717feda88900b566463228d1c4910af6d.
> >>>
> >>> Do you consider this patch for stable? I'd like to see it in Debian's
> >>> 5.10 kernel and I guess I'm not the only one who would benefit from such
> >>> a backport.
> >>
> >> When I was applying the patches I did not realize that there was already
> >> hardware in the wild that needed it. The patches are now in mainline, so
> >> I can no longer adjust the tags, but I will not object if you propose
> >> them for stable.
> > 
> > I want to propose to backport commit
> > 
> > e4c9062717fe ("Input: elantech - fix protocol errors for some trackpoints in SMBus mode")
> > 
> > to the active stable kernels. This commit repairs the track point and
> > the touch pad buttons on a Lenovo Thinkpad E15 here. Without this change
> > I don't get any events apart from an error message for each button press
> > or move of the track point in the kernel log. (Also the error message is
> > the same for all buttons and the track point, so I cannot create a new
> > input event driver in userspace that emulates the right event depending
> > on the error message :-)
> > 
> > At least to 5.10.x it applies cleanly, I didn't try the older stable
> > branches.
> > 
> > Best regards and thanks
> > Uwe
> > 
> 
> I'd like to propose to backport [1] also as it was checked along with
> previously proposed patch and fixes Elan Trackpoint operation on
> Thinkpad L13.
> 
> Both patches apply cleanly to 5.10.17 in my case.
> 
> I also tried to apply to 5.4.x, but failed.
> 
> [1] 056115daede8 Input: elan_i2c - add new trackpoint report type 0x5F

Applied to 5.10.y now, thanks.

greg k-h
