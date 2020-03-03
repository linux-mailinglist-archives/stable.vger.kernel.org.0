Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DC51771A9
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 09:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgCCI6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 03:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgCCI6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 03:58:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 776F720842;
        Tue,  3 Mar 2020 08:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583225882;
        bh=/uUuIvpx18VnWYIcc7tV/zQpAF7dLw6ih680eCqkfmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e6IuFKZUdJADiUrKn329XwY+cPqaYnBhD4fRjpToQtTxMjUAo8hQ+xeAHpC+FwSLd
         sPyY4d7MKeyadtVitbREWfN/sCQcHL7W/2l1fOAePfDFMEqUwww+Ry2tM1XF8aYsGp
         /TQ5ta8NakYBSANrkC2N8hNAinFmin8VZOZoweqw=
Date:   Tue, 3 Mar 2020 09:57:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        lirongqing@baidu.com, stable@vger.kernel.org, vikram.pandita@ti.com
Subject: Re: FAILED: patch "[PATCH] serial: 8250: Check UPF_IRQ_SHARED in
 advance" failed to apply to 4.14-stable tree
Message-ID: <20200303085759.GA1324468@kroah.com>
References: <158271336456142@kroah.com>
 <20200226233949.GC22178@sasha-vm>
 <20200227095908.GC1224808@smile.fi.intel.com>
 <87r1yf2j57.fsf@kurt>
 <20200228183643.GB21491@sasha-vm>
 <87wo81c1f0.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo81c1f0.fsf@kurt>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 09:01:23AM +0100, Kurt Kanzenbach wrote:
> Hi Sasha,
> 
> On Fri Feb 28 2020, Sasha Levin wrote:
> > Hm, yes, looking at it now it doesn't look too tricky, I'm not sure what
> > happened a few days ago :)
> >
> > If you want to send me a backport I'll be happy to queue it up.
> 
> Sure. In v4.9 and older kernels the bug exists, but the workarounds
> aren't applied. So, Andy's patch becomes shorter.
> 
> Here's a backport for v4.9 (compile tested only):

Now applied, thanks.

greg k-h
