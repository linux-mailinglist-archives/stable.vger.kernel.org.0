Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A184F1E8E15
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 08:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbgE3GCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 02:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgE3GCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 May 2020 02:02:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594BC2074B;
        Sat, 30 May 2020 06:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590818549;
        bh=oz9ffgNa1Xsgz8Geg1zBzwDMczhFqg8QC5tCX0m31Js=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8IB6hgzKRHJdOSvHF749cuTzG5J1IGLRPlgkCFAjnAUgOSI5qdOkSFkCmIkrhAej
         5wO0bMABioiMqdk+W3ieuwdY/xVlqjIsqSJNHq/LGl+ezt8PTOUf66UViMmGdbk2CJ
         Fv1vuHjCI7EEYAysYSy3q63e3C0ZKitiB98ttcPI=
Date:   Sat, 30 May 2020 08:02:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     stable <stable@vger.kernel.org>, Michael Walle <michael@walle.cc>,
        rrafael.j.wysocki@intel.com
Subject: Re: patch "driver core: Update device link status correctly for
 SYNC_STATE_ONLY" added to driver-core-next
Message-ID: <20200530060226.GA3462734@kroah.com>
References: <159065032912689@kroah.com>
 <CAGETcx8ZSBYznasT7MYgMCmmr5qTcvt2OjS_B8fiicONVXQDgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8ZSBYznasT7MYgMCmmr5qTcvt2OjS_B8fiicONVXQDgw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 08:12:14PM -0700, Saravana Kannan wrote:
> On Thu, May 28, 2020 at 12:19 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     driver core: Update device link status correctly for SYNC_STATE_ONLY
> >
> > to my driver-core git tree which can be found at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
> > in the driver-core-next branch.
> >
> > The patch will show up in the next release of the linux-next tree
> > (usually sometime within the next 24 hours during the week.)
> >
> > The patch will also be merged in the next major kernel release
> > during the merge window.
> >
> > If you have any questions about this process, please let me know.
> 
> Not sure if this is already/automatically queued, but this needs to go
> to stable@ too. Cc-ing the list to make sure it's picked up.

I will make sure it goes there too, thanks.

greg k-h
