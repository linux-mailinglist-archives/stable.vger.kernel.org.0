Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CAB3B1CF2
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 16:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFWO6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 10:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230339AbhFWO6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 10:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D306102A;
        Wed, 23 Jun 2021 14:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624460180;
        bh=4sPNf4Ao9YvJSY93g6ZfvxdkY0phH7I2W8Kasxxc288=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eh12elo7948IReSIIVAnWs+Gpm+yH6k9AciE/lyVr2d7LUN0fKsZCPcjbhMLKv778
         arbgAjbqnpbstYUP850hlOD6diq7JbG8aiXpXprHuwf54w4jJBagn4w4X+wF6saDtm
         rfRqQYDxPaRkMoaiVEtKABRCfnvVCt6uJriWFoLk=
Date:   Wed, 23 Jun 2021 16:56:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Philipp Hahn <hahn@univention.de>
Cc:     stable@vger.kernel.org, 892105@bugs.debian.org,
        Ben Hutchings <benh@debian.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>, carnil@debian.org
Subject: Re: Cherry-pick "i40e: Be much more verbose about what we can and
 cannot offload"
Message-ID: <YNNLktX3oWXK/KIh@kroah.com>
References: <937dd880-f902-aa9c-67d5-2d582a29e122@univention.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <937dd880-f902-aa9c-67d5-2d582a29e122@univention.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 08:18:53PM +0200, Philipp Hahn wrote:
> Hello,
> 
> I request the following patch from v4.10-rc1 to get cherry-picked into
> "stable/linux-4.9.y":
> 
> > commit f114dca2533ca770aebebffb5ed56e5e7d1fb3fb
> > Author: Alexander Duyck <alexander.h.duyck@intel.com>
> > Date:   Tue Oct 25 16:08:46 2016 -0700
> > 
> >     i40e: Be much more verbose about what we can and cannot offload
> >     This change makes it so that we are much more robust about defining what we
> >     can and cannot offload.  Previously we were just checking for the L4 tunnel
> >     header length, however there are other fields we should be verifying as
> >     there are multiple scenarios in which we cannot perform hardware offloads.
> >     In addition the device only supports GSO as long as the MSS is 64 or
> >     greater.  We were not checking this so an MSS less than that was resulting
> >     in Tx hangs.
> >     Change-ID: I5e2fd5f3075c73601b4b36327b771c64fcb6c31b
> >     Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> >     Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> 
> Debian had this old Bug
> <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=892105> reported against
> 4.9.82, which still exists in Debians old-stable 9 "Stretch" current kernel
> 4.9.258, but also with latest stable 4.9.273.

Now queued up, thanks.

greg k-h
