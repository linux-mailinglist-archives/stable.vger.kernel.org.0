Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E2B1D0C78
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgEMJkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:40:00 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53671 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgEMJj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:39:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 819845C01E6;
        Wed, 13 May 2020 05:39:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 13 May 2020 05:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=I5cLelH9WQOWpljdbZEbQ2JdZ1/
        KYDxCfpZfHrKlvfs=; b=NQfxwMrYtpV8CrOwM10sE/GeFtyAV/m5ZuqLS1+dn4i
        Enh0Gn6TtyNKMsDXzjLlstcLEDjIerEehc9U2T8WcN6CKRKJQxOYq6lXtD/NhLGC
        1i8HU9g/6KrTMxmZXUypyGHNbdtzl660CmVBdXFqAeo/ZxFDMG7saWXDrvvIQ0CY
        y2dYpOkr2QjyeDhgh8MtNaOk75tR7UPZPo7SPjHstP7nn1iSMT4wJeXblQ1YEu4e
        fqwu8kZv/cXBJVia7ZK+D3uFjN3clpUvyVVvkTxCvOzsYiL5dNYKjxGpkE7+lXiv
        Kzf9UJ/9qknUnnjYjgSSiGpV/NNrJIdOiOQj2y2DMUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I5cLel
        H9WQOWpljdbZEbQ2JdZ1/KYDxCfpZfHrKlvfs=; b=rZziZQ+lbFtRRrTGpY3PMW
        91ZsIPlZXYJAbhKOAUxO0SUynivo3Lf3qmoobd+RtydjBMWsuu7y+Ek/N9RXTuTE
        Uc3MiMKREctAjZV1LU7QdOBKhTWf8Z3ZtReWZq2lGiNAiBS7MpIOOZuTBAy2erEn
        mQqiCz87asjL8CkWKpEs+YCi5C7MIVrnIDkTpl5ExSXc5tOHOxe1t+65PoPQ5osw
        ZSwY4csvoTNZgCi/xTmI4f7z8ZUmBaELI7hKPzSvYIq/jL5Mh0NQm/rjKfD9kmaF
        dgV4Ao2A4DzmlQsIqlJOXbirZ0xg95ISyIXbdZZHmpHwRf21d33luLK0v1DG1jrQ
        ==
X-ME-Sender: <xms:bsC7XgmkZgGUjiCpeBRbX2OlAT8G-wxZiU13xffPRwzvGJfDpxTIuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bsC7Xv0JVh5gv1z8B4e-47kFkbTvTq9rdhHrTSo8YHhP7LaZiXVb1A>
    <xmx:bsC7XurmN8pK2BwJ86T1yyaeOHQc5XeIEJ_qMbsukzH39PIqqfRE8Q>
    <xmx:bsC7Xsn53mPMUYlZ2028fuEPVd6-6b__SWI6oI6fdgfNqOaGQCVE1g>
    <xmx:bsC7XvAmusb4hG6WW-fvtxU71VA0NGqpMMZSY2VArWTcVStm-g7O-w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0885D3280066;
        Wed, 13 May 2020 05:39:57 -0400 (EDT)
Date:   Wed, 13 May 2020 11:39:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/21] Backported fixes taken from Sony's Vendor tree
Message-ID: <20200513093956.GC831267@kroah.com>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 12:19:36PM +0100, Lee Jones wrote:
> A recent review of the Sony Xperia Development kernel tree [0] resulted
> in the discovery of various patches which have been backported from
> Mainline in order to fix an array of issues.  These patches should be
> applied to Stable such that everyone can benefit from them.
> 
> Note: The review is still on-going (~50%) - more to follow.

I think I already took some of these, but not all, and I can't remember
why.  Can you resend the needed ones please?

thanks,

greg k-h
