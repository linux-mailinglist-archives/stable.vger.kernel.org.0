Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA31472E5C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfGXMCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbfGXMCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 08:02:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5659229ED;
        Wed, 24 Jul 2019 12:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563969763;
        bh=9p+0vUvWmZ0Nu55+k5utufym+tHrmxy1nBlQRS035RY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nW9a3cw/6ODf5Nts50Cifc+JqSRHzxC9dZ2KL+fLVouDfla3BbY4gzRQ252ktveJd
         +IQXSgfrg5Buo7QBmDszYGPG1xNha6mPHQfW5+jsrHEBxTG1DbKnLVlXYrEgdw4q1R
         +y4HKmq+wk2HiZzGOu3AQgiKjLgye1lKY+e2Fa3I=
Date:   Wed, 24 Jul 2019 14:02:40 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
 hv_eject_device_work()" failed to apply to 4.14-stable tree
Message-ID: <20190724120240.GD3244@kroah.com>
References: <156388316686177@kroah.com>
 <PU1P153MB0169E0984244BDEF657CC0CCBFC60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169E0984244BDEF657CC0CCBFC60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 01:01:18AM +0000, Dexuan Cui wrote:
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: Tuesday, July 23, 2019 4:59 AM
> > To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
> > Kelley <mikelley@microsoft.com>
> > Cc: stable@vger.kernel.org
> > Subject: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
> > hv_eject_device_work()" failed to apply to 4.14-stable tree
> > 
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 4df591b20b80cb77920953812d894db259d85bd7 Mon Sep 17 00:00:00
> > 2001
> > From: Dexuan Cui <decui@microsoft.com>
> > Date: Fri, 21 Jun 2019 23:45:23 +0000
> > Subject: [PATCH] PCI: hv: Fix a use-after-free bug in hv_eject_device_work()
> > 
> > Fix a use-after-free in hv_eject_device_work().
> > 
> > Fixes: 05f151a73ec2 ("PCI: hv: Fix a memory leak in hv_eject_device_work()")
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> > Cc: stable@vger.kernel.org
> 
> Hi,
> I backported this commit for v4.14.134. 
> Please see the attachment.

Now applied, thanks.

greg k-h
