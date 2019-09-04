Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95758A91E0
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732967AbfIDSfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732542AbfIDSfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:35:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0522220820;
        Wed,  4 Sep 2019 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567622129;
        bh=yjbIx5m7mX/mvZZcdpxUUJpXRLtcX0uCm2sa4PBCsMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DYeE0ZtEAdJbL7hmPbcyGggHUG0Kkrhni8rI/1Z2ttLnq1KIglHZUwXh47fwr9RQu
         d+ku040gMbzGnqVBQDbIu//cVSiZ1O4RDuuTdqYfBIk6QTrV/MW6dDmxiwBKSgONKv
         dTOAR3xd+I5UIbVUABdPFqAsIGVViLJk2phEOOeM=
Date:   Wed, 4 Sep 2019 20:35:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricardw@axis.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 07/83] ASoC: Fail card instantiation if DAI format
 setup fails
Message-ID: <20190904183527.GA364@kroah.com>
References: <20190904175303.488266791@linuxfoundation.org>
 <20190904175304.389271806@linuxfoundation.org>
 <20190904181027.GG4348@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904181027.GG4348@sirena.co.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:10:27PM +0100, Mark Brown wrote:
> On Wed, Sep 04, 2019 at 07:52:59PM +0200, Greg Kroah-Hartman wrote:
> > [ Upstream commit 40aa5383e393d72f6aa3943a4e7b1aae25a1e43b ]
> > 
> > If the DAI format setup fails, there is no valid communication format
> > between CPU and CODEC, so fail card instantiation, rather than continue
> > with a card that will most likely not function properly.
> 
> I nacked this patch when Sasha posted it - it only improves diagnostics
> and might make systems that worked by accident break since it turns 
> things into a hard failure, it won't make anything that didn't work
> previously work.

This is already in the 4.14.141, 4.19.69, and 5.2.11 releases, have you
heard any problems there?

I'll be glad to drop this from the 4.9.y and 4.4.y queues, now if you
wish, but just want you to know it's already out there in some releases.

thanks,

greg k-h
