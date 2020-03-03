Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252DB1774B0
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 11:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgCCK5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 05:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbgCCK5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 05:57:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A344D20838;
        Tue,  3 Mar 2020 10:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583233024;
        bh=vISdA5FQkTvp9GTRWEkxl83LKzCCu26+KpfK0uTIxcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KqxHrmzA/FhGYpNHsf1IFUEfCq6cJbLXEpfoWt3ORkg7QVOd1IL73s336KrXZeJIH
         hdcHbhfgclWClQ0a0lHDowc9eT8KXHdi1m/mnMrrGWzxGGOIOvr/5cjRWLGDtGYyhJ
         Y7zpYYdY7mNzI3Woqmh5xVXrsIqBxM0GXCcJgbBU=
Date:   Tue, 3 Mar 2020 11:57:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "Lee, Chiasheng" <chiasheng.lee@intel.com>,
        Mathieu Malaterre <malat@debian.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hardik Gajjar <hgajjar@de.adit-jv.com>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        scan-admin@coverity.com, Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH v3 1/3] usb: core: hub: fix unhandled return by employing
 a void function
Message-ID: <20200303105702.GA1699585@kroah.com>
References: <20200226175036.14946-1-erosca@de.adit-jv.com>
 <Pine.LNX.4.44L0.2002261313390.1406-100000@iolanthe.rowland.org>
 <20200303103921.GA13097@lxhi-065.adit-jv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303103921.GA13097@lxhi-065.adit-jv.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 11:40:05AM +0100, Eugeniu Rosca wrote:
> Hi Greg,
> 
> On Wed, Feb 26, 2020 at 01:14:24PM -0500, Alan Stern wrote:
> > On Wed, 26 Feb 2020, Eugeniu Rosca wrote:
> > > 
> > > Fixes: 1208f9e1d758c9 ("USB: hub: Fix the broken detection of USB3 device in SMSC hub")
> > > Cc: Hardik Gajjar <hgajjar@de.adit-jv.com>
> > > Cc: Alan Stern <stern@rowland.harvard.edu>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: stable@vger.kernel.org # v4.14+
> > > Reported-by: scan-admin@coverity.com
> > > Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> > > Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > 
> > For all three patches:
> > 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Friendly reminder to pick up the patches, if no other comments.

Less than a week, please give me a chance :)

Don't worry, they are in my to-review queue...

greg k-h
