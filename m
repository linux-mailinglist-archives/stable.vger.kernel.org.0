Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1611B2EA5
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgDUR6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:58:08 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52483 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbgDUR6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:58:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 768395C0127;
        Tue, 21 Apr 2020 13:58:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=fLCimqtcSdbEDDw8m0g6g5QbmSh
        xNWrkVZy/vYOHByc=; b=qwZxa6pzc8Ec2iIInMqXsa6u/qxoMk6IrfBZJCvQCSN
        jhoehECIc6L8LKhWFkNPr04FNuWwY7JuG6nWMYLloofyEgoAcDtXLK6zOi8QadT7
        h4b/MqshSCvovjBLZwGR2WL0aws5UaeikrqYXzQS7oIE2sHC4ZJGiquLS5WAXeeQ
        GBGRES9pymG/swHOLsRHNY9RZjVob9Mnw/sE0WICe5hvUHDL81HFBNC7nfHkV/8m
        tHhv34v78wjdgyEN80b3QDk5nPOw6cB/2gVFhHOuB9R/hCGUiibCouNiQfs/xxmy
        PvgDv7A+OMnMocWMATLNx1+AxzYIXQdpsqRbY8qUUCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fLCimq
        tcSdbEDDw8m0g6g5QbmShxNWrkVZy/vYOHByc=; b=ciTezsNQopW8Ldi8BLNDQc
        9QMe+w0VyupfeN4B+zpsmhWFjI/q/gGr7T9hkqj1m421fZ+HT99mTumIsfwVhYh/
        AG1f9MEyT2bSGPRBSn/PVtZbOd/IKeXsAZDcVn6erorum/TLZr/hnWZf7kNbH9ad
        FumkFk5j3qAgyQqeYXsVaDTyNeTs0RdPnepwYxWUO6Kp+ctWapWbN4JHl5A+voWB
        JSXrJK+P1Mou7uJ43joM8KwZyWqgxpYejkI9Y/9cIjkT9g6LshRq1qkkwUVRbF+R
        9bqonLtt3he2G2RUO7BvOrvyMUe/ucKOKNHdV8dL1YCgo4ekpb6NedrMEDsbDWyA
        ==
X-ME-Sender: <xms:LjSfXpaDUA6uHq6Gj2fJXEXmZku7NuI3CFEDq77QtQBXS8ru2dFe8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:LjSfXjsPoiXHWGJMmZb3LSEsje3_1G2GLx9MHLA9wYMB7e9XVDgRFg>
    <xmx:LjSfXnxspcodgmOYVEOt8bGmOWX9R01pK-xGRSKdmgonAzkhWa_lBQ>
    <xmx:LjSfXq1CboB5UphE1dAS51BvWt7KxgY9wd6terwdAijFbv_nCrElfA>
    <xmx:LjSfXjaZOkQQoFALvLvzZ8MAfhCb_pe2CZZgRhkPzh1LHogJbJrk_A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DEA16328006C;
        Tue, 21 Apr 2020 13:58:05 -0400 (EDT)
Date:   Tue, 21 Apr 2020 19:58:04 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/24] Backported fixes taken from Sony's Vendor tree
Message-ID: <20200421175804.GA1358460@kroah.com>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 01:39:53PM +0100, Lee Jones wrote:
> A recent review of the Sony Xperia Development kernel tree [0] resulted
> in the discovery of various patches which have been backported from
> Mainline in order to fix an array of issues.  These patches should be
> applied to Stable such that everyone can benefit from them.
> 
> Note: The review is still on-going (~50%) - more to follow.

Thanks for these, most queued up here, and in some older kernel trees as
well.

greg k-h
