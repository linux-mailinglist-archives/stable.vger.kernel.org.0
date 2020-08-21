Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8541F24CF54
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 09:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgHUHeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 03:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbgHUHeV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 03:34:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F652078D;
        Fri, 21 Aug 2020 07:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597995261;
        bh=HOIyK+2v9sCy4+v+HmmgcGBJyAxZni1qUT0Gq2Y87As=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iXd+kuQPmTCD6i0Q8OiPUx91cOAbEHYqvABK7ekuWEznsUMZRt+4brAEGAikD+HBe
         5Uwsuw+amzSQ6mYrmdfc/YB/f+eRfTM3SnxVEwiG0rP2/OeGoiJr0SibCMhmHV5FOm
         WJp0tonBShbAsNlB0gRFmuUwqsfd3DdnnbY3w1Hw=
Date:   Fri, 21 Aug 2020 09:34:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 196/212] gpu: ipu-v3: image-convert: Combine
 rotate/no-rotate irq handlers
Message-ID: <20200821073440.GB1681156@kroah.com>
References: <20200820091602.251285210@linuxfoundation.org>
 <20200820091612.258939813@linuxfoundation.org>
 <20200821070216.GB23823@amd>
 <e586d38120241447df58818c1f9e3c04e5068972.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e586d38120241447df58818c1f9e3c04e5068972.camel@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 09:10:30AM +0200, Philipp Zabel wrote:
> Hi,
> 
> On Fri, 2020-08-21 at 09:02 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Steve Longerbeam <slongerbeam@gmail.com>
> > > 
> > > [ Upstream commit 0f6245f42ce9b7e4d20f2cda8d5f12b55a44d7d1 ]
> > > 
> > > Combine the rotate_irq() and norotate_irq() handlers into a single
> > > eof_irq() handler.
> > 
> > AFAICT this is preparation for next patch, not a backfix. And actual
> > fix patch is not there for 4.19, so this can be dropped, too.
> 
> You are right, this patch is preparation for commit 0f6245f42ce9 ("gpu:
> ipu-v3: image-convert: Wait for all EOFs before completing a tile").

Which is included in this patch series...

