Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D16126CC1C
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgIPUjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgIPRHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 13:07:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068F220731;
        Wed, 16 Sep 2020 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600276067;
        bh=ib7N94E2nLCwiAfrg9neVbGKdpsytr4YeLzSAPlnqiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Zm55sb26Zkzc8leerButOxYH4sYSPn3orHxfsTv6vegpLbKYH8RpDGFTnCq491TM
         BRp1zSStouOW/FK2C926yoe+2wJPIByHbxHK5aV3iOsyVNfjotSlD2DnkEeh8q/zCi
         LW1aVZVqTni2QxBeWv7tNcIzaLzbAv4XojbenlVE=
Date:   Wed, 16 Sep 2020 19:08:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Villalovos <jlvillal@os.amperecomputing.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/5] Add support needed for Renesas USB 3.0
 controller
Message-ID: <20200916170821.GA3054459@kroah.com>
References: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
 <20200916063116.GI142621@kroah.com>
 <e92b6d88-387b-1b06-9df1-49897145e0a7@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e92b6d88-387b-1b06-9df1-49897145e0a7@os.amperecomputing.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 09:54:50AM -0700, John Villalovos wrote:
> 
> On 9/15/2020 11:31 PM, Greg KH wrote:
> > On Tue, Sep 15, 2020 at 02:30:34PM -0700, John L. Villalovos wrote:
> > > Add support needed for the Renesas USB 3.0 controller
> > > (PD720201/PD720202).  Without these patches a system with this USB
> > > controller will crash during boot.
> > Is this a regression, or something that has always happened?  If a
> > regression, any pointers to what commit caused this?
> > 
> > this really feels like a "new feature" addition to me, unless this used
> > to work properly.
> 
> It is not a regression. It is a crash that occurs on new hardware that has
> this USB controller.
> 
> 
> Without this patch series, hardware with this USB controller will fail to
> work. So in the choice between "regression" and "new feature" I would say
> "new feature".

Ok, to support new hardware, use a newer kernel, no reason why 5.4 or
newer will not work here, right?

thanks,

greg k-h
