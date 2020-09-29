Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724DE27D347
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 18:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgI2QDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 12:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgI2QDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 12:03:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C432074F;
        Tue, 29 Sep 2020 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601395410;
        bh=JGLmjeIPrF77pZIwGYIOwOXFqja3Ao+CgtckD6pJE/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ObfrPMb0TCtSx6DwQ8mVRfB4ZO2YJ7/kf993EEKVMnA2zEaAhH1otb9OCAJIT9/M+
         X849IglgxaRoISmfjJKkmM3KK8Mf8mqv83QFj/aF4ASb5CXMa8sKB2YZJ8vimyM0K6
         VhMpvCnJaJmMUSxtPo3TzpucAbwEr+3iJocxjvc8=
Date:   Tue, 29 Sep 2020 18:03:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: replace memmap_context by memplug_context
Message-ID: <20200929160335.GA1324521@kroah.com>
References: <20200929135738.28697-1-ldufour@linux.ibm.com>
 <20200929142904.GC1203131@kroah.com>
 <b4e8f0ea-2d4a-eacf-b617-932906cbf1b1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4e8f0ea-2d4a-eacf-b617-932906cbf1b1@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 05:31:50PM +0200, Laurent Dufour wrote:
> Le 29/09/2020 à 16:29, Greg KH a écrit :
> > On Tue, Sep 29, 2020 at 03:57:37PM +0200, Laurent Dufour wrote:
> > > Backport version to the 5.4-stable tree of the commit:
> > > 
> > > c1d0da83358a ("mm: replace memmap_context by meminit_context")
> > > 
> > > Cc: <stable@vger.kernel.org> # 5.4.y
> > > Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> > 
> > What happened to the full changelog from the original commit, and all of
> > the cc: and signed-off-by from it?
> > 
> > Please include that in the patch, you don't want to see all of that
> > stripped off, right?
> 
> Sorry, I was thinking some magic script was pulling the original commit
> description based on the git commit id ;)
> 
> I'll send the patches again.
> Is there a specific tag to use when mentioning the original commit id?

You can copy the format we use when committing the patch to a stable
tree if you want to be nice.

thanks,

greg k-h
