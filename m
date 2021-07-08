Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87723C191E
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhGHSYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:24:02 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39737 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhGHSX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 14:23:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A6D4A5C0056;
        Thu,  8 Jul 2021 14:21:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 08 Jul 2021 14:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=e+ZyVySYo4vbYSgNjDenOeGfzGI
        oq/rBjWYGA6SQjAk=; b=cE33Zlk40W9/dvEcEywNrA9uVDqgcAadCvuOSD11ZfI
        XcJoxCEnWMaCA3GK3rdtpABdDJvsG+QCTErRVXiWjKChc5/kNIHQnQTFUdvTT8Dl
        FXmlLktl5gxv0COirM6tA3mvgb3hFMeh7d1eo2KE73ax2r4OvSrs/0lM+opwgMDF
        M3+MGRrrfWdo0C3WXYxGA3WXRg+AD6kt2pHvdjO8uenp+UzZt055QXCyYlxKD6Xb
        Zm9tvcWNlTNaLyHbs8faLIBJJO/nYzGrfaHmcvGdKQmHt4u4SrZ3XebHt6HAP52U
        41w58CQ3UEzv1mkyzR8VQKgr9AEDoqQ8lwUuRkPjqtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=e+ZyVy
        SYo4vbYSgNjDenOeGfzGIoq/rBjWYGA6SQjAk=; b=c5roLcRevVnmlJiwl6+U3z
        rFEtxmLkLpZNIB2vzZuBcXr81WgzpB8Y+9VWapq7mPb1wlPlQwh+YbyK1xGHKwpu
        /Pt+LaBWt315SsHmLlLPOQdn4ORTu2rvtkdZBASpRFDohjINVMmiS2Dlp37pTqti
        XU0A7NdymvsIqfCY+OVCvRcQo0WaTP47ZieEeat6KLkJgiVJcdLHgR+Z2DLXG+L3
        OYcR+bye70oJpgm0p/kFORgmyOoLzQyaXEWQ3LGI2kyA9fWu0uPBanJTfT04+ANo
        AEafyIaT1UMDiLkmtx44nNOKV5CQwkmxgxmbrqFeAau7TAyrIqLn70MNDSFWuVXg
        ==
X-ME-Sender: <xms:HELnYLDNp7cFYXjAV1KU6XNYy1EtTtU77IyDzuyt8ARzK78dsHAG9g>
    <xme:HELnYBjQdHtyV-h-lWyqi2-J7hqKeE86NwZ2m1HYtHL91Y6wUegOYNKd0Y2xwhhpF
    Ql7algiLOB6Xg>
X-ME-Received: <xmr:HELnYGmCMiGir9TPNtqHZXftZn4S9SyUnORKvUuOTpi_416db1yIO97VhaZM1aqVmzKpOlrfV6nGt7A53UCWepHQkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeggdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:HELnYNxIWw_vFMUEBQ-r0qb2GJddPnZrKJDbkVHhj2dHpX86IOe-VA>
    <xmx:HELnYARyZ7ywuh7mwO9mAcv4E2p3XAtaBFzugpmFtP2DtsA05pNVcQ>
    <xmx:HELnYAbAET2RtazcT7TNYuLS84Lmvc-FH8cppBuH8bEHzfzpIRyh-g>
    <xmx:HELnYDHXGoIyNZBniG3Bkg074Jh4Ww-iaofCsb0LdiznfLmoNcGfrg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 14:21:15 -0400 (EDT)
Date:   Thu, 8 Jul 2021 20:21:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH for 5.10.y] media: uvcvideo: Support devices that report
 an OT as an entity source
Message-ID: <YOdCGmezKmqDnQlr@kroah.com>
References: <20210708141404.14826-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708141404.14826-1-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 04:14:04PM +0200, Hans de Goede wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> [ Upstream commit 4ca052b4ea621d0002a5e5feace51f60ad5e6b23 ]
> 
> Some devices reference an output terminal as the source of extension
> units. This is incorrect, as output terminals only have an input pin,
> and thus can't be connected to any entity in the forward direction. The
> resulting topology would cause issues when registering the media
> controller graph. To avoid this problem, connect the extension unit to
> the source of the output terminal instead.
> 
> While at it, and while no device has been reported to be affected by
> this issue, also handle forward scans where two output terminals would
> be connected together, and skip the terminals found through such an
> invalid connection.
> 
> Cc: stable@vger.kernel.org # v5.10
> Reported-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 32 ++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)

now applied, thanks.

greg k-h
