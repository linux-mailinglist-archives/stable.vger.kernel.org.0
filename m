Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D9EAAB92
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 20:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbfIES4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 14:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbfIES4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 14:56:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 908DF206BA;
        Thu,  5 Sep 2019 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567709798;
        bh=i6OWPx+i5LhSJ8Xv+mKDWS3PSY8etiDdSr67fqZVJWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N102LImF8nNCUagp5r/MCOz8xNDTpCrW1O9Gyyag/79Pu0kqK3k0ZmbyNiCAKAHCB
         CusbZ4QFmYXhP9NEE+YEjvisgxFQPIDUfZ3h7k3r1YJ4CivdMLHgxK3WnhhT7c0x7e
         N3r6fv902bZZ9uEPbiG4WWldy/RDpyoP4NnQCnyE=
Date:   Thu, 5 Sep 2019 20:56:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricardw@axis.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 07/83] ASoC: Fail card instantiation if DAI format
 setup fails
Message-ID: <20190905185634.GA24873@kroah.com>
References: <20190904175303.488266791@linuxfoundation.org>
 <20190904175304.389271806@linuxfoundation.org>
 <20190904181027.GG4348@sirena.co.uk>
 <20190904183527.GA364@kroah.com>
 <20190904190535.GH4348@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904190535.GH4348@sirena.co.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 08:05:35PM +0100, Mark Brown wrote:
> On Wed, Sep 04, 2019 at 08:35:27PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Sep 04, 2019 at 07:10:27PM +0100, Mark Brown wrote:
> 
> > > I nacked this patch when Sasha posted it - it only improves diagnostics
> > > and might make systems that worked by accident break since it turns 
> > > things into a hard failure, it won't make anything that didn't work
> > > previously work.
> 
> > This is already in the 4.14.141, 4.19.69, and 5.2.11 releases, have you
> > heard any problems there?
> 
> Ugh, how did that happen?  I've not heard any reports but I'd be a lot
> more comfortable if this was reverted, these releases haven't been out
> that long and the users who'd be affected are mostly doing embedded
> stuff.
> 
> > I'll be glad to drop this from the 4.9.y and 4.4.y queues, now if you
> > wish, but just want you to know it's already out there in some releases.
> 
> Yes, please.

Now reverted and dropped, sorry about this.

greg k-h
