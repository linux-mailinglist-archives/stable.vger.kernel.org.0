Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BE62A150E
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 11:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgJaKCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 06:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgJaKCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 06:02:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A606D20702;
        Sat, 31 Oct 2020 10:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604138548;
        bh=dimlWfuYaFXe1jrR3VITCfeFMXT4YmPWUbJRsWUQdLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zg+/daaM3fG37DrEZAJcmlFPIbeiC1aD0RwDm1B64nslmInxAg5ZnCx+xJLOfv4qR
         IR3O6/Ngmm23Zz16LycbdGSBOeSMnV1DrOuHXNLd3CtmrOEuivYeGhDt3vm8h2tWUZ
         F57rEIuNBho5GwRH2hx29rCby5wxLmQFOC83BCFA=
Date:   Sat, 31 Oct 2020 11:03:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     Ross Lagerwall <ross.lagerwall@citrix.com>, stable@vger.kernel.org
Subject: Re: Stable backport request for "xen/events: don't use chip_data for
 legacy IRQs"
Message-ID: <20201031100314.GA3847955@kroah.com>
References: <0e4837c4-b750-4889-bb8c-8a36c73c7110@citrix.com>
 <1a63ad59-c0d3-893b-8098-97146920214b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a63ad59-c0d3-893b-8098-97146920214b@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 03:17:09PM +0100, Jürgen Groß wrote:
> On 30.10.20 14:29, Ross Lagerwall wrote:
> > Hi,
> > 
> > Please backport [1] to 4.4, 4.9, 4.14, 4.19.
> > 
> > It fixes a commit that has been backported to all the current stable releases but for some reason the fixup was only backported to 5.4 & 5.8.
> 
> Greg has told me he queued my backport already.

I did?  I don't see that commit backported anywhere, did you get
confused with some other patch?

I need a backported version of this patch if we are able to accept it,
as it does not apply cleanly to those kernel releases.  Can someone
please provide it and send it?

thanks,

greg k-h
