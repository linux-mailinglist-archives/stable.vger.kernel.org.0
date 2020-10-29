Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A5F29E9EC
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgJ2LD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:03:28 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46093 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727343AbgJ2LDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 07:03:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 326735C0158;
        Thu, 29 Oct 2020 07:03:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 07:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=si3VcKCCINYmfNF9xb5sz8w+QZZ
        Vc2xOX9g1CxSO5Rs=; b=JMugcI2Vo5HW95fz38JfDgpKswtehcePku3GtxboPvn
        5aZJg02A/aOgXCDViM/DV65NlKmwECaqsADttwvdyNcsWq5UMh38ZxtDg37TU7St
        4uMk/RpWiOi3gMByOFr3g6XaINOK1XVWO+t6fs8YzZXYUiAzQhBmLpUXIBdQpOiG
        J40EXnregzNfTtygtDCOc+LbkXJyNE1SiG/JveRunW+iA1YcFDAiiKBk9uNp4hvD
        Ktu2XUPuZ5j1KU2s24NVyrL3joX04pBHNOgu7rX6q824jNCNDGI0zUBBo85RE1dS
        yLt0SEQWu0uFo+4U1/Pepjf1jP0ZCjSc+Aj/kX2NwoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=si3VcK
        CCINYmfNF9xb5sz8w+QZZVc2xOX9g1CxSO5Rs=; b=gGLpWRiur7WOlM/VJSNX9h
        ztS6OU+eTNraCqF1ketw/JPXHih/8HBwprS8l/gnH08AIPvC3tQrfqMv59I+eq23
        c2VOuKNYlaNj325Wwp+25CPOPtEOEjmEgL7ALww2u/6qz3ky2WJ2sqMVs5M4WXOC
        c+6aI5Mu6ut1AulmIkx0++JWUaYw5NmsCYrbNkfQJjZFXRopsdWy85pnCm1P4W7V
        nkql9HQGL6nfybP9hQxatNtKSaZ7sSksAEFo5bUYkF6tWCMpLrpwgiohBAOPk/EC
        sYBe/gmX9vPZdf+0aErJEtbZyiFVsOvvwQYscmqcqkla5HRbgqcxdufCCXS6h5lQ
        ==
X-ME-Sender: <xms:e6GaX3Bx8A4FUOIAeNk5nV5zEcKrtK6CZJFclb-pFyKL8dpwEtc8og>
    <xme:e6GaX9gIgV11NeYov6iJAtpcCcK80Mc1fAuUAdksrIJJoFRifMww7wKzRgJmaUMbc
    gUnLD9gnsPcIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:e6GaXyksYywy7hI5867p66wd5ASQJU9N2CKjdnN2QI7m3Ttmo35i2Q>
    <xmx:e6GaX5wPlogZfCGBduN-386k9F9-oNcXpIcveW_6wxcdV6kvtxbmHw>
    <xmx:e6GaX8SR_uE5FIO0PR2aTPgrxGs9oB1qLXb4gI1DmThZQVNHK7wkbA>
    <xmx:fKGaX3Ly7A9ebsv6pvEMJ48ZD0q-dk4l5g-tGTDVDCcW9GRRQ_p2Ug>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FB0E3280060;
        Thu, 29 Oct 2020 07:03:23 -0400 (EDT)
Date:   Thu, 29 Oct 2020 12:04:14 +0100
From:   Greg KH <greg@kroah.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH] socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS
 is disabled
Message-ID: <20201029110414.GD3840801@kroah.com>
References: <20201027171526.23151-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027171526.23151-1-ceggers@arri.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 06:15:26PM +0100, Christian Eggers wrote:
> [ Upstream commit 4e3bbb33e6f36e4b05be1b1b9b02e3dd5aaa3e69 ]
> 
> SOCK_TSTAMP_NEW (timespec64 instead of timespec) is also used for
> hardware time stamps (configured via SO_TIMESTAMPING_NEW).
> 
> User space (ptp4l) first configures hardware time stamping via
> SO_TIMESTAMPING_NEW which sets SOCK_TSTAMP_NEW. In the next step, ptp4l
> disables SO_TIMESTAMPNS(_NEW) (software time stamps), but this must not
> switch hardware time stamps back to "32 bit mode".
> 
> This problem happens on 32 bit platforms were the libc has already
> switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
> socket options). ptp4l complains with "missing timestamp on transmitted
> peer delay request" because the wrong format is received (and
> discarded).
> 
> Fixes: 887feae36aee ("socket: Add SO_TIMESTAMP[NS]_NEW")
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
> ---
> Hi Greg,
> 
> I just got your E-mail(s) that this patch has been applied to 5.8 and 5.9.
> This is a back port for the same problem on 5.4. It does the same as the
> upstream patch, only the affected code is at another position here. Please
> decide yourself whether the Acked-by: tags (from the upstream patch) should
> be kept or removed.
> 
> This back port is only required for 5.4, older kernels like 4.19 are not
> affected.
> 
> regards
> Christian

Now queued up, thanks.

greg k-h
