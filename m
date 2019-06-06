Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C60137DAC
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbfFFTyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 15:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbfFFTyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 15:54:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236C020872;
        Thu,  6 Jun 2019 19:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559850872;
        bh=66WsNXowRab9p9S5MUiX0WYjcQJB5kg1QYxRp1zFqvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eh2LVpjxCU1McUw64x1zv9MzZCGWScqWK+Ab2PhDcZpN0lxqqVZiDBbMI3p0lB1OD
         2bcVtasojNvv4dD2aTcMYwlqVy4wCpHcqdG91w/9SDaDE2nMjo4q5qQySYSxN8c1wl
         sKV9uLRA5Qktbk0GHQ65UNExZcCpqSfuixD7uMHI=
Date:   Thu, 6 Jun 2019 21:54:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Phil Elwell <phil@raspberrypi.org>, stable@vger.kernel.org
Subject: Re: Dynamic overlay failure in 4.19 & 4.20
Message-ID: <20190606195430.GA27447@kroah.com>
References: <45e99a24-efb9-5473-2e57-14411537dc9f@raspberrypi.org>
 <2da582d1-11eb-3680-33f2-3a5c139613a8@raspberrypi.org>
 <20190605175059.GA29747@kroah.com>
 <20190606011422.GG29739@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606011422.GG29739@sasha-vm>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 09:14:22PM -0400, Sasha Levin wrote:
> On Wed, Jun 05, 2019 at 07:50:59PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 05, 2019 at 01:02:18PM +0100, Phil Elwell wrote:
> > > Hi,
> > > 
> > > I think patch f96278810150 ("of: overlay: set node fields from
> > > properties when add new overlay node") should be back-ported to 4.19,
> > > for the reasons outlined below (briefly: without it, overlay fragments
> > > that define phandles will appear to merged successfully, but they do
> > > so without those phandles, causing any references to them to break).
> > 
> > That patch does not properly apply to the 4.19.y tree.  Can you provide
> > a working backport that I can queue up to resolve this?
> 
> Greg,
> 
> That patch has contextual dependencies on 6f75118800 ("of: overlay:
> validate overlay properties #address-cells and #size-cells"), I think it
> would make sense to take 6f75118800 and then f96278810150 rather than a
> backport.

That works better, I have now done this, thanks.

greg k-h
