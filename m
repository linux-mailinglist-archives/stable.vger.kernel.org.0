Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705CE28FFB5
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 10:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404947AbgJPIFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 04:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404912AbgJPIFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 04:05:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC0AB20829;
        Fri, 16 Oct 2020 08:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602835538;
        bh=dAdiBNvJWGSyEP0e84gNvsOKGLnA0tWyQLz2UfPnqFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2TEMlYg+YprwDKnLYQYp/XaXIsIIq7ICwztTJczJkdtDc+8k+XXp0/Nwb6ICDRgeT
         ESPCE/v5h+quOOoblerG/60V7a6u95BZSdoy0L2ssbAdH8IRZvocbZLSz7KC4f/Veo
         y1Pwp22BBc+zEn4n0yCleqbHldZyNDwRravFz3PI=
Date:   Fri, 16 Oct 2020 10:06:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     stable@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] xen/events: don't use chip_data for legacy IRQs
Message-ID: <20201016080609.GC1355531@kroah.com>
References: <20201005061957.13509-1-jgross@suse.com>
 <f0b0b56e-512a-84ed-f03f-86ef54c10e96@suse.com>
 <20201014095108.GB3597464@kroah.com>
 <8c0a8ad7-df8d-47cf-5ad1-43715e903757@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c0a8ad7-df8d-47cf-5ad1-43715e903757@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 12:44:39PM +0200, Jürgen Groß wrote:
> On 14.10.20 11:51, Greg KH wrote:
> > On Wed, Oct 14, 2020 at 11:31:33AM +0200, Jürgen Groß wrote:
> > > Any reason this has not made it into 5.4.y and older by now?
> > > 
> > > This patch is fixing a real problem...
> > 
> > What is the git commit id of this patch in Linus's tree?
> 
> 0891fb39ba67bd7ae023ea0d367297ffff010781

Thank you, now queued up.  Always try to remember that next time, as
it's required.

thanks,

greg k-h
