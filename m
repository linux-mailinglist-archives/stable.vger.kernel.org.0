Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7885C360B1A
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 15:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhDONyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 09:54:41 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55711 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233134AbhDONyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 09:54:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 776875C0187;
        Thu, 15 Apr 2021 09:54:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 15 Apr 2021 09:54:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=p
        cDbXdDnBqVYW4ApTB9wnBYvardjt3qEr0faBV3zNiA=; b=XjZlxXOz2LIKbgFZ8
        +tPXw7AmWTu/rfBcnatBUA8rfL7mXSOKnxDHcIci0pKBc1LXhatSV2krY89dnB8d
        bAV7mHQMNoaavJexxMnLKwlQp/qSos9DRWfu8gs88B6goCwSUvXvDyPzS9OtNMmg
        rB9BxPnRqFjG3uPu+RXVT6iysg5SnBwnxp7iDCifY23oTearobERaqtLJ1kxAJTh
        dcjDiIavPGh6NZUB8fRjYGEm58mPVvS4hOr1dxa3Ozb0yhgM7DpItXrDatlKoDd1
        ljXHxK8KXWbbHpCs4ST0617gtw/NbEcqMJMIv64MU4fhqzX2dcx2bNeF5LUhwJTa
        wO90Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=pcDbXdDnBqVYW4ApTB9wnBYvardjt3qEr0faBV3zN
        iA=; b=b5lSr+qU/MfU3eBXJo8QoxBNb2Tvrat9FpuC5jLlJdgQA9taweSSdZcly
        jw9Ev1a/5eoFiQz6NSnFO3OLCeO+b+O2fDHGQmcIr7l8tQAPniGxJO9ZnQENzuvn
        svDnVR5Tv75DHJ/xbwI2tpqD8tTWQvg5GTcU/FroTSUlqGorGVP7HohhGDhl9VdN
        QN+bveng0Gv8OYZZnYVFQBy0UzGlN2tViWhyH0iWq1wqlsmgmTAOflMXHHBu0cR0
        1RhtX+uDN5hn7Lu14Q2kllGwp5Yh7DrXspkWhHLRYvDUSsZ8u5iGSW5qBDtp9pHy
        lNsYWmbXJC/m00k1tVJgchK+Jytpw==
X-ME-Sender: <xms:iEV4YMHEOPIq_rJ4qgk6Kn1nNo6Y70rWt3ZI5qesbqD1_0kWlAujyg>
    <xme:iEV4YFVI0yoWhr7MUcJHdyugn-nstiTiUk-KOZhcdKqmvlJQeUNcbKQ3-HaQt5pIv
    _VBvhUUitHhmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelfedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:iEV4YGKCrmrD6S687HQUt-HnpcSif2ZAQv8-Dvk4noLB9OUoLyVyRw>
    <xmx:iEV4YOH7rKjRgBvcVEWfVdXrJKqAcc_jxQ8LsmVu0tqgPGSHOYwGgQ>
    <xmx:iEV4YCUpo8mvERaTMQqoWsInCXALUasWrIVYzM4O8GyR6HYDIvLhKg>
    <xmx:iUV4YPhVuv5xr2yc_nL1HUWVBk5KCtNDAvMI5vCIqjTGB9E1ieQ3Cw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 156591080063;
        Thu, 15 Apr 2021 09:54:15 -0400 (EDT)
Date:   Thu, 15 Apr 2021 15:54:13 +0200
From:   Greg KH <greg@kroah.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: sfp: relax bitrate-derived mode check
Message-ID: <YHhFhS3rlC3KZpqj@kroah.com>
References: <20210412162611.17441-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210412162611.17441-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 06:26:11PM +0200, Pali Rohár wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> [ Upstream commit 7a77233ec6d114322e2c4f71b4e26dbecd9ea8a7 ]
> 
> Do not check the encoding when deriving 1000BASE-X from the bitrate
> when no other modes are discovered. Some GPON modules (VSOL V2801F
> and CarlitoxxPro CPGOS03-0490 v2.0) indicate NRZ encoding with a
> 1200Mbaud bitrate, but should be driven with 1000BASE-X on the host
> side.
> 
> Tested-by: Pali Rohár <pali@kernel.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> Please apply this commit to all stable releases where was already
> backported commit 0d035bed2a4a6c4878518749348be61bf082d12a
> ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
> as it depends on this commit. If I checked it correctly patch should
> go into 5.10 release.

Now applied, thanks.

greg k-h
