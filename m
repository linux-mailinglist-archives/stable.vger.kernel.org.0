Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AEC2AA656
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgKGPfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKGPfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Nov 2020 10:35:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0478820719;
        Sat,  7 Nov 2020 15:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604763341;
        bh=+kFYdvrx6Wym6Fki79wysbMv/AfXfI4m4fIIQZ+Lb1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ikl/bu4XJrzlowDJu7Pf17hzLoZ81PrhpqGr//5Y8oaLNLJJLhPutZ7cPBc1zOMlj
         8MBcBcHBHJ1l0MgCAZIUkS7tsgV3WeqjIqhtJD6XAJx89Hpf2IBPJ/QwcBhjsrXeb3
         ADqmC91NtRBc0imTLA8/IMoe5mWYLVkk/ytK6wKk=
Date:   Sat, 7 Nov 2020 16:36:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] Fonts: Replace discarded const qualifier
Message-ID: <20201107153625.GA116750@kroah.com>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201102183242.2031659-1-yepeilin.cs@gmail.com>
 <20201103085324.GL4488@dell>
 <CAKMK7uGV10+TEWWMJod1-MRD1jkLqvOGUu4Qk9S84WJAUaB7Mg@mail.gmail.com>
 <20201103091538.GA2663113@kroah.com>
 <20201103095239.GW401619@phenom.ffwll.local>
 <20201103105523.GO4488@dell>
 <20201107051918.GA2209915@PWN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201107051918.GA2209915@PWN>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 07, 2020 at 12:19:18AM -0500, Peilin Ye wrote:
> Hi all,
> 
> On Tue, Nov 03, 2020 at 10:55:23AM +0000, Lee Jones wrote:
> > Would you be kind enough to let us know when this lands in Mainline
> > please?  We'll need to back-port it to start fixing up our Stable
> > kernels ASAP.
> 
> Patch is in mainline now:
> 
> 9522750c66c689b739e151fcdf895420dc81efc0 Fonts: Replace discarded const qualifier

Now queued up for stable, thanks!

greg k-h
