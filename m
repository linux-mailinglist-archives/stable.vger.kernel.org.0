Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDD81D1453
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 15:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbgEMNQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 09:16:28 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57979 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725967AbgEMNQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 09:16:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id E08344F3;
        Wed, 13 May 2020 09:16:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 13 May 2020 09:16:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=nBC29QCni1mBgl9h5doeUHwXa4v
        NwTEDYCUNesF25Jc=; b=ZzSkalI9/AkbyaUrVCggH6RLrq+MiWmlppnzLqtp2om
        ykx+Z2G5wNUBibwUsQFlT/ajWkPeXiVt02KDSUoRQzzLNUTxnDEzHZfADUGUSGA8
        SLpukqjYaWXKxKPIp3Y01StmKOxLEYC7jqi0rnLRsKj2b58lwL9aFBcxrB0bMBiV
        WMWMum8Lg+FJGKoz/ApDnguyxwiLOd4lfr87kTifYEt5MGNqTxzYsoaxrTn/1H24
        xyeS5HZLsUxkqpwGydLSP3Xk6jeDD2TiGkHjcSYGrOyO5IWjZfsWxfJ1d8d9DO3T
        WCjrfM+NzdW2sJZ/7udKXsatgb4E1pQb4tqogAj4I/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nBC29Q
        Cni1mBgl9h5doeUHwXa4vNwTEDYCUNesF25Jc=; b=M257GhdqDPYRqpPDsFWBV8
        V3IWzOEczgeXK/WaeL1rA/bSCmkSLtA17a+Qdzmh06+g3iA5CmqRQI3qdFROn2YV
        84hnyVrlfMORBXelz4TL/F4bUPI2Tg1hJQUnjSrBbS3iYlPcqWvvDCxYGpCbdqe9
        S3zKsQh5AatCTmCaxqFKeIS8YBHvpZOAAMx0HaQdXsZVs2VrsTdHQj1XZCvSFmQW
        M2oetxk0sI0knzhZSM4m0ccSTWCYpxv23BQ8I0gl/EJr3eRJKdXBuAJ3DOG7OHwh
        ND1R1NEjRjDALthYuaHt4+tUoWj16c8DT6qbHuJFX0snFDNXFlPNeexmvW4iKNsw
        ==
X-ME-Sender: <xms:K_O7XnwXJUFWr3Ywv-8G2-QOB4yOWLPSBqevJOoVDAlgbCsR0lMUNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:K_O7XvSDKoZbFmtT2UT6fmUtQDb6Cb5v0kP9pa_y7TRv-pRLtso2-Q>
    <xmx:K_O7XhW_94Z3c6yxvnbQU4yyRdVkKMHpO1fPkDLBEhwARViJ4vgOUQ>
    <xmx:K_O7XhimaK8Hc79EmFO-isP_e-8l8GLqPR4Lgw7cWwkH8OKXqWpiHA>
    <xmx:K_O7XsN1mmTdb392ZwyUTb5UnnOiCPPk9ISs_xYoxVRGAs2ELVPFEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CC2A30662FE;
        Wed, 13 May 2020 09:16:27 -0400 (EDT)
Date:   Wed, 13 May 2020 15:16:24 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/21] Backported fixes taken from Sony's Vendor tree
Message-ID: <20200513131624.GA1085938@kroah.com>
References: <20200422111957.569589-1-lee.jones@linaro.org>
 <20200513093956.GC831267@kroah.com>
 <20200513131312.GB271301@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513131312.GB271301@dell>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 02:13:12PM +0100, Lee Jones wrote:
> On Wed, 13 May 2020, Greg KH wrote:
> 
> > On Wed, Apr 22, 2020 at 12:19:36PM +0100, Lee Jones wrote:
> > > A recent review of the Sony Xperia Development kernel tree [0] resulted
> > > in the discovery of various patches which have been backported from
> > > Mainline in order to fix an array of issues.  These patches should be
> > > applied to Stable such that everyone can benefit from them.
> > > 
> > > Note: The review is still on-going (~50%) - more to follow.
> > 
> > I think I already took some of these, but not all, and I can't remember
> > why.  Can you resend the needed ones please?
> 
> Yes.  I sent them for the more recent kernels and you(r scripts) added
> them to later ones as part of the normal process.  You said to send
> them anyway, saying something like "not applying patches is not hard
> for [you] to do".

Ah, but it did confuse me :)
