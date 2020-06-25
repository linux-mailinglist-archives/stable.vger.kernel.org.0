Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF1C209C33
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 11:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403957AbgFYJpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 05:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389894AbgFYJpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 05:45:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 353E320679;
        Thu, 25 Jun 2020 09:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593078316;
        bh=77zCTrVeRsOnQTM4A76BRsxjLVMeEVAnfEdbtBCzlcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nck4BtH5Cr7Ue7pyhhz5oaV73t8bqxrX1iCmdvSpXXAPieNKo1SgPMjuBx0IedKMO
         BlnXvd/UbF1b3ywdWghUriIjnLh/lO4Ex6liYWv49cPBkY5YrhBsavS+b9T9tzSd8U
         aDP6tzGSU40vJLyo/JRDQNyV/EngGVs9cLp4oDVA=
Date:   Thu, 25 Jun 2020 11:45:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, patches@opensource.cirrus.com
Subject: Re: [PATCH 01/10] mfd: wm8350-core: Supply description
 wm8350_reg_{un}lock args
Message-ID: <20200625094513.GC3299764@kroah.com>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
 <20200625064619.2775707-2-lee.jones@linaro.org>
 <20200625065608.GB2789306@kroah.com>
 <20200625071313.GM954398@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625071313.GM954398@dell>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 25, 2020 at 08:13:13AM +0100, Lee Jones wrote:
> On Thu, 25 Jun 2020, Greg KH wrote:
> 
> > On Thu, Jun 25, 2020 at 07:46:10AM +0100, Lee Jones wrote:
> > > Kerneldoc syntax is used, but not complete.  Descriptions required.
> > > 
> > > Prevents warnings like:
> > > 
> > >  drivers/mfd/wm8350-core.c:136: warning: Function parameter or member 'wm8350' not described in 'wm8350_reg_lock'
> > >  drivers/mfd/wm8350-core.c:165: warning: Function parameter or member 'wm8350' not described in 'wm8350_reg_unlock'
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Cc: patches@opensource.cirrus.com
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/mfd/wm8350-core.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> > > index 42b16503e6cd1..fbc77b218215c 100644
> > > --- a/drivers/mfd/wm8350-core.c
> > > +++ b/drivers/mfd/wm8350-core.c
> > > @@ -131,6 +131,8 @@ EXPORT_SYMBOL_GPL(wm8350_block_write);
> > >   * The WM8350 has a hardware lock which can be used to prevent writes to
> > >   * some registers (generally those which can cause particularly serious
> > >   * problems if misused).  This function enables that lock.
> > > + *
> > > + * @wm8350: pointer to local driver data structure
> > >   */
> > >  int wm8350_reg_lock(struct wm8350 *wm8350)
> > >  {
> > > @@ -160,6 +162,8 @@ EXPORT_SYMBOL_GPL(wm8350_reg_lock);
> > >   * problems if misused).  This function disables that lock so updates
> > >   * can be performed.  For maximum safety this should be done only when
> > >   * required.
> > > + *
> > > + * @wm8350: pointer to local driver data structure
> > >   */
> > >  int wm8350_reg_unlock(struct wm8350 *wm8350)
> > >  {
> > 
> > Why are all of these documentation fixes for stable?
> 
> Because they fix compiler warnings.

When you type 'make' these warnings show up?  We don't do documentation
builds as part of a normal build...

If for some reason we ever get rid of all of the thousands of current
warnings, then yes, I will be glad to consider stuff like this then.

thanks,

greg k-h
