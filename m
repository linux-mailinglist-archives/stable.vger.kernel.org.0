Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBAA4136BA
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhIUPzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 11:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234299AbhIUPyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 11:54:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C21611EF;
        Tue, 21 Sep 2021 15:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632239593;
        bh=RAm2TBCw5TxiLV9IkIE8lJLorq9H5ORzpSdJSH0VVMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qUg8+mphxk8z+noePav16pSzYFFOMNmzS+mQUaKlcLpbGHK6p5WtGBHBlI4HZJTxn
         Vql2jry1zP03ruf2RdOOIloJodYdSc4Nv+ccT9Q+1Teu9mdIzVllvjI8b+AQ+LKLp9
         b5ZkavNVKI87SisZLhBN+FwyykvBSzazrAIbKhOA=
Date:   Tue, 21 Sep 2021 17:53:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 116/122] bnxt_en: Convert to use netif_level()
 helpers.
Message-ID: <YUn/5hEyI9//stlU@kroah.com>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163919.617145875@linuxfoundation.org>
 <5662a5175932e46febd024cadc4bece443aa92c0.camel@perches.com>
 <YUn0iDB21QnjtXaX@kroah.com>
 <0a25e9c5ff70899369134be4fdd609d2ee21baed.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a25e9c5ff70899369134be4fdd609d2ee21baed.camel@perches.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 08:49:52AM -0700, Joe Perches wrote:
> On Tue, 2021-09-21 at 17:04 +0200, Greg Kroah-Hartman wrote:
> > On Tue, Sep 21, 2021 at 07:30:42AM -0700, Joe Perches wrote:
> > > On Mon, 2021-09-20 at 18:44 +0200, Greg Kroah-Hartman wrote:
> > > > From: Michael Chan <michael.chan@broadcom.com>
> > > > 
> > > > [ Upstream commit 871127e6ab0d6abb904cec81fc022baf6953be1f ]
> > > > 
> > > > Use the various netif_level() helpers to simplify the C code.  This was
> > > > suggested by Joe Perches.
> > > 
> > > There isn't an actual change here.
> > > 
> > > Unless this is a precursor to another patch, this isn't anything
> > > that should go into stable.
> > > 
> > It is a dependancy for other fixes.
> 
> Then it's useful/necessary to mark it as such when applying it.
> 

That's hard/difficult/messy to do :)
