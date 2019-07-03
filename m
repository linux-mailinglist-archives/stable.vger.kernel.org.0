Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B765DEBD
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 09:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfGCHUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 03:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfGCHUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 03:20:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030A22187F;
        Wed,  3 Jul 2019 07:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562138414;
        bh=HTIs6URgs6UpJnvwHagTAFVSBWb6Z9ivuBI47raU+YU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gcL5qmdqNOsTc/9FMAjdcS3xK2LxaJPbPgEs19wyI2ETsrhLFsor2sz4hZ/bkM/8e
         KhLwrRr4jAnV+yp+MOUOxddH/Dn8vb+GPwrRFQ7iXjN9wR07odPvV7X3pvJP3M9Vic
         cgn+OgWIZX9PX3Dn3B9M9ZXUDiea9ySlSZPkH6Mk=
Date:   Wed, 3 Jul 2019 09:20:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 4.19 26/72] usb: dwc3: gadget: use num_trbs when skipping
 TRBs on ->dequeue()
Message-ID: <20190703072012.GA3033@kroah.com>
References: <20190702080124.564652899@linuxfoundation.org>
 <20190702080126.031346654@linuxfoundation.org>
 <20190703020312.GS11506@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703020312.GS11506@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:03:12PM -0400, Sasha Levin wrote:
> On Tue, Jul 02, 2019 at 10:01:27AM +0200, Greg Kroah-Hartman wrote:
> > commit c3acd59014148470dc58519870fbc779785b4bf7 upstream
> > 
> > Now that we track how many TRBs a request uses, it's easier to skip
> > over them in case of a call to usb_ep_dequeue(). Let's do so and
> > simplify the code a bit.
> > 
> > Cc: Fei Yang <fei.yang@intel.com>
> > Cc: Sam Protsenko <semen.protsenko@linaro.org>
> > Cc: Felipe Balbi <balbi@kernel.org>
> > Cc: linux-usb@vger.kernel.org
> > Cc: stable@vger.kernel.org # 4.19.y
> > Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> > (cherry picked from commit c3acd59014148470dc58519870fbc779785b4bf7)
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This one has an upstream fix: c7152763f02e05567da27462b2277a554e507c89
> ("usb: dwc3: Reset num_trbs after skipping").

You were the one who queued this series up :)

I'll go add this one now...

thanks,

greg k-h
