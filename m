Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FFD3F0042
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 11:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhHRJUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 05:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhHRJUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 05:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86DE661053;
        Wed, 18 Aug 2021 09:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629278401;
        bh=xWoO8qZGOnYVc8A/wcF8Ybze9Rsmnj8Tf+OG5tASQZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m/mhII8RVGFMLqgPLRcYborhHvJdiVCuOlYrNrsgWDHM1AATvZNoTb2OsAEylC/3g
         itYWk/q890dTd3g8bAkqEV00X+vD8p+8F16czdVtIeZJ0M3SzHGEsAXN4oFwBokhqH
         WwbMwYd7sqXtUHPuJpWpL6cbK1gReU8pPHQ7VPHU=
Date:   Wed, 18 Aug 2021 11:19:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.4 49/62] PCI/MSI: Enable and mask MSI-X early
Message-ID: <YRzQvhDRyBWdEs5G@kroah.com>
References: <20210816125428.198692661@linuxfoundation.org>
 <20210816125429.897761686@linuxfoundation.org>
 <20210817073655.GA15132@amd>
 <YRyuefFT4N/y0plX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRyuefFT4N/y0plX@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 08:53:45AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 17, 2021 at 09:36:55AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > I'm sorry to report here, but 4.4 patches were not yet sent to the
> > lists (and it may be worth correcting before release).
> 
> Yes, they are known to not be complete and incorrect at the moment,
> others have reported this to me.  I will be working on these later
> today, thanks.

Now should be all fixed up thanks to some patches sent by Thomas.

greg k-h
