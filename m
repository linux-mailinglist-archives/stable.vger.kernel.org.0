Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93478A9DB6
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 11:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfIEJDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 05:03:43 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:44917 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731660AbfIEJDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 05:03:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 817F068C;
        Thu,  5 Sep 2019 05:03:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 05 Sep 2019 05:03:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=H
        C9eg9snVfiloyfXDdAH6KobugN4wqDmlyk9BxglEuU=; b=Fi1NuvnZZT5YDlmi7
        SqQOc6IxK3PoFZmKP0GgIeX1gmEyxFSxG9ODPsp/i4G6u9pPGihm40wrV7IZBZ/G
        M3GfNmpOfrB5TBTuqQwpZXpYqhzpPtNuB5IXTPUxLx9kUWq71pL8xYrCbSjn0G+i
        N2fXhvPuEYLiqPSo9xjoE+n3mHtMJys4xV3z0hFbRRpJTXk2Tsqjygr/jgr31FpS
        eHncLLG2/APdyNII8FIc1FrO+MZTxamcTBGeMysrbBwUCuWMkUQ0/bCg9YsIY12Y
        STVtV+tlf5UrlDpw8ILAPX+zmnbm7Vl/XZIyAKnNFmTIMPFvsI9pR4wUndMN7ACI
        YAFUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=HC9eg9snVfiloyfXDdAH6KobugN4wqDmlyk9BxglE
        uU=; b=AjxgRNI59JEhqgVHho8N/+Sw94ZaRpBtVHFAoyaoniN3hn16EgqoSHEoh
        hzCFUaj5gODsfp8Ay5FeZYAhwjymehVHs5Fjty7tBa0MOsg7jtyG1iz7i+RZgQHb
        RZEMyWE61YHCdEuJ6yZffpPIWxQORsm55HPScUUfkNnrou626DJ7saZrX8zJUG0c
        f1/zAgSZlx1l6vZgSUcjuJoJhgTils+cAPqUR4npolT9Xox9Wjz/0BkWqDw5tt4j
        SzbzcQFHGnF3zXMlgOfROEg/618LKeScLMuGPYAAbYIdgaMkM7NoP/pRhI4P6pgT
        8JdDjlwl54BW6d3edMuiIYCM7/KiQ==
X-ME-Sender: <xms:as9wXdZVJ28oIMBKMmH6H42UWu5GB4HH5TjZtLzWvcXt7mn6BkTNVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejjedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtredunecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepfhhrvggvug
    gvshhkthhophdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiii
    gvpedt
X-ME-Proxy: <xmx:as9wXU2Xknu5tcRdzFhoUE0LYM5oxQMFcjnmYzl2kgDR1PBKnPBrYg>
    <xmx:as9wXVbdE2fg4jQvNrTs7RIYBMUPTv9wdBXgSi7cZ11rqNJX2KhRtQ>
    <xmx:as9wXZnY0HHUkEh7GA7TVKtHVZo45BFzZUSAJzb47fpGXp_OwGUJfw>
    <xmx:a89wXSHBolyaNyxOrhNO46JMbDvBDjaCQlPZk8encT_3K8Zw0XIGYA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DF7FD6005A;
        Thu,  5 Sep 2019 05:03:38 -0400 (EDT)
Date:   Thu, 5 Sep 2019 11:03:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?iso-8859-1?Q?S=E9bastien?= Szymanski 
        <sebastien.szymanski@armadeus.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 147/167] drm/panel: Add support for Armadeus
 ST0700 Adapt
Message-ID: <20190905090336.GA29020@kroah.com>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-147-sashal@kernel.org>
 <CAL_JsqJrwwsp1wjCBnNmx45ZiLTXVY_nCfN6OrJ5o9dLbc+_2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJrwwsp1wjCBnNmx45ZiLTXVY_nCfN6OrJ5o9dLbc+_2w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 09:55:58AM +0100, Rob Herring wrote:
> On Tue, Sep 3, 2019 at 5:31 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
> >
> > [ Upstream commit c479450f61c7f1f248c9a54aedacd2a6ca521ff8 ]
> >
> > This patch adds support for the Armadeus ST0700 Adapt. It comes with a
> > Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
> > that it can be connected on the TFT header of Armadeus Dev boards.
> >
> > Cc: stable@vger.kernel.org # v4.19
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20190507152713.27494-1-sebastien.szymanski@armadeus.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  .../display/panel/armadeus,st0700-adapt.txt   |  9 ++++++
> >  drivers/gpu/drm/panel/panel-simple.c          | 29 +++++++++++++++++++
> >  2 files changed, 38 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/display/panel/armadeus,st0700-adapt.txt
> 
> Looks like a new feature, not stable material. Not sure why it got
> tagged for stable.

New device ids/tables are able to be added to stable kernels, since,
well, forever :)

thanks,

greg k-h
