Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF512F9CCE
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389680AbhARK0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:36 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:40843 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388669AbhARJWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 04:22:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 84F5D134E;
        Mon, 18 Jan 2021 04:13:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 04:13:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=lMfhbFrjpnMks7zyT+E4yoLZ4Hr
        AxUV2FFuElv9y3Ds=; b=ASWuSES4BLTr6bdtoVZMbbJENKNRK1v0ctYn2f5saUJ
        aNBFnnPyIDjNoCGYmhO3PTVGUpkuvOC5zatg7lOfHiGmpilCdB1h3LQA+2bZ9Kiw
        dnR7RQ5nyhXsR+SqdXCl4uckOI6EwVGGJ30MY5me6jhhxrg1mK4xpHrp2Y5cUhCo
        gxxviewtTIgrOHZfaEKRg3y4rdw3x6F8MrRfutVnpoEZ6AGHqHZr/CFyfhyspQty
        pnXZXNLzPR+7JyPWw3swFWuUFzKew5weLnuVSjWo6DTsquQoWac2yNUZxGs2MuLY
        TFlWiolmIsCOMxQAqKiAR7NbSRYb2a2hQ5q0Q07MB6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lMfhbF
        rjpnMks7zyT+E4yoLZ4HrAxUV2FFuElv9y3Ds=; b=luXZcOu2Ga6xwZf7c93PyN
        nSKLP5k30H/rRJEjrQ+7RjPdVgUtx88VQJjArcrVoyMrp0jbMbblLNBmXD3sc9Gd
        EIEoqgRnCHU/m4w9dGTKX7jmvV2FikWEvoeeumhIhxqx/vmQRRyHpHDJ0YKgVhSG
        nx5itMVmYLHnNnMxvxx3EA4l2KoVxTL1YBTiazAicG0T+lhaSBq2hNkWAcQ6Iqdb
        fTXMU/Gu+H1AFrLboXtiGQHZzV66+Oko5LYk09dJqwqxj3xVDSurDXcQeSLp/3BA
        Smi1AInc8m0c5brX39szq4Bv5bxJtZax8ElLiPOATVkD8UuY5jK3IdFViVXCaOmQ
        ==
X-ME-Sender: <xms:HlEFYJPnrrvCQdKid40X8lYfTI4ZrYc4bG7sCD2yaT7X70DAbp6-8w>
    <xme:HlEFYL_HAEuGz10uCYX3zxDXH-MYJjqqf2IXsWuQUAoe0-IAOVqwIFKhIX2wkARvs
    lqe4wkAuozlvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveehgfejie
    dtffefhfdvgeelieegjeegieffkeeiffejfeelhfeigeethfdujeeunecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:H1EFYIT-PmCxPOtiKr09NcvBWxgx2iI5R-5iRks3awFwJNVTSqFvQg>
    <xmx:H1EFYFtiEPK-IWCGT9U-EBx43ipbD-oxjERVdXsm6e9lEXnJIC7Biw>
    <xmx:H1EFYBdnf5tMMSFEi8-cj5bEW60pA6KcCSfoQm3v1dw6_MuBAFNrqQ>
    <xmx:H1EFYHqTiBZJBw309wZ-9TfHNkJiWoi-vgxHgkVI1-6u6wga6_J1FQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA90F24005A;
        Mon, 18 Jan 2021 04:13:02 -0500 (EST)
Date:   Mon, 18 Jan 2021 10:13:00 +0100
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Please add feb889fb40fa ("mm: don't put pinned pages into the
 swap cache")
Message-ID: <YAVRHEmVqGBBwGUD@kroah.com>
References: <CAHk-=whCEy=fVcCZ+s6JABgKGrGTTue4pJCV8Z5GDvcjVyipaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whCEy=fVcCZ+s6JABgKGrGTTue4pJCV8Z5GDvcjVyipaw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 17, 2021 at 12:28:06PM -0800, Linus Torvalds wrote:
> It's missing a stable tag only because I initially committed it
> without confirmation from the reporter that it actually fixed the
> problem. I did that because I didn't think I'd get a test result back
> on a Sunday before doing rc4.
> 
> But the reporter came back and confirmed it fixed things, and because
> I hadn't pushed out yet, I amended the commit to have that
> "Reported-and-tested-by".
> 
> ... but I didn't think to add the Cc: stable until after I _had_ pushed it out.
> 
> So here's a slightly belated note that commit
> 
>   feb889fb40fafc6933339cf1cca8f770126819fb
>   ("mm: don't put pinned pages into the swap cache")
> 
> should go into any v5.9+ stable kernels.

Thanks for letting us know, Sasha queued this up last night.

greg k-h
