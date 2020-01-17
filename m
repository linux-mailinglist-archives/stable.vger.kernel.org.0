Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1735A140F78
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 17:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgAQQ7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 11:59:15 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38723 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726559AbgAQQ7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 11:59:15 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8947122022;
        Fri, 17 Jan 2020 11:59:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 Jan 2020 11:59:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=NBrDhIy8eEyYhuxfQaqDFlK5PD1
        nOIBhbHxOQiXIM/A=; b=EN2yOUmjgN0bvAvLK+0GRYiokaf/38It9Hh5+pOCRC6
        CO48owweftGksIgxq18Ru9qqKqqVBAGyAHkRwVSyYy5XbIHV0YJIXIO/dk8k2eVx
        8pD+8R25WeiEdEiSV4NDfNRWYfiYe9Gn0gDTIING967LA2yDFAjYMk5Vk/YYBDeV
        uQQd6zxHacpB7MnFSuVTHVvOu1DW2f7ZO4eeKsyp7q78opgZrMfDh4ezqBCBqtdW
        WT/eR5UDlGwJupSQrhT0gV+xBP2DE6gi3zhTd+12e6duYTG9qqNLLUBiW8rTiuaB
        SXupCEpFgGMMktVlSH05XXTRiUw2rbJSY31aKUtOoXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NBrDhI
        y8eEyYhuxfQaqDFlK5PD1nOIBhbHxOQiXIM/A=; b=iAHrtXXO58x3KevYTmn+Nu
        yqJvL5VY1yUNQdCACdVct00zYFkL4o3uSZaJ1D4pXWiRdEqruinGdXEIxB5I0w/H
        0YZbxsdQeCedyYeE2saAlzjclvLLpkFR3/Tj1xK+nxjN+eQINp+3J88fm/2d6oV5
        jcWFDugu/OA0l8S2u1+ovGnKpw9W3Bf3tVk4loTP1RXvdHxthVfKNb0LsSjJik1N
        0jlCpt5QILgQiGNAo6wwAc211QPYYI1w+H+LovUZpzc9EkIbJuj/BbO2CspenW3I
        D9fw9D19riyawJsU8vfWrG6r8Wj4XVNyyqwW629Pq9T0P/gJ0hSXoxTTQm1w4sQw
        ==
X-ME-Sender: <xms:4OchXiiJk837b64CCO8FEtGGWsRjocvuWoMiW8nbRLFVrL-HzaEn0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdekgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehl
    uhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:4OchXvrdke6JP-2FvNqh9RM5U-tcGGKUaPiG0ejiVt6axHOs9Tnd9g>
    <xmx:4OchXtt5R1wbtnKou18ponl7pXSNKLSqCGiy3pgLN31WZOlNcEQTQw>
    <xmx:4OchXhY7zfE9xUMpAiTsWLFJnrMqdudHcvHeQJBaIYcIoa7_bCSACw>
    <xmx:4OchXlbuhvmcjrgt4ESEJOcdUkyLxFSAE5JmpiiA4L9jA2hTP3f3Xg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2C073060AEC;
        Fri, 17 Jan 2020 11:59:11 -0500 (EST)
Date:   Fri, 17 Jan 2020 17:59:09 +0100
From:   Greg KH <greg@kroah.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Herring <robh@kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH AUTOSEL 5.4 002/205] drm/panfrost: Add missing check for
 pfdev->regulator
Message-ID: <20200117165909.GA1949937@kroah.com>
References: <20200116164300.6705-1-sashal@kernel.org>
 <20200116164300.6705-2-sashal@kernel.org>
 <20200117161226.GA8472@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117161226.GA8472@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 04:12:27PM +0000, Steven Price wrote:
> On Thu, Jan 16, 2020 at 04:39:37PM +0000, Sasha Levin wrote:
> > From: Steven Price <steven.price@arm.com>
> > 
> > [ Upstream commit 52282163dfa651849e905886845bcf6850dd83c2 ]
> 
> This commit is effectively already in 5.4. Confusingly there were two
> versions of this upstream:
> 
> 52282163dfa6 ("drm/panfrost: Add missing check for pfdev->regulator")
> c90f30812a79 ("drm/panfrost: Add missing check for pfdev->regulator")
> 
> It got merged both through a -fixes branch and through the normal merge
> window. The two copies caused a bad merge in mainline and this was
> effectively reverted in commit 603e398a3db2 ("drm/panfrost: Remove NULL
> check for regulator").
> 
> c90f30812a79 is included in v5.4 so should already be in any v5.4.y
> release.

Have I mentioned this month just how much I hate the way the DRM tree
handles stable patches like this?  This kind of fallout is a pain for
stable maintainers, I dred every time I see a drm patch tagged for
stable.

But we've been over this all before :(

greg k-h
