Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A31C861
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 14:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfENMSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 08:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfENMSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 08:18:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 706C7208CA;
        Tue, 14 May 2019 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557836320;
        bh=UoQ1GUBaf4Wp6YbRrvcWkKgd2cytEBxruecbcb66K3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NegoOybYXogsqCKhWKY+PLVs3pf3WBRygfrm4240BB/bMrEgnBX/OJl8zcOmLNC7K
         fhIYIgsL+PNt7i9jDV0SwuENfekQlq3wGEyOvWjvZoPcOUWAL2SEDJcmw8jdp4mnw6
         lMrhaAm0amG4VH9IfnhQOa8HFnZ8vbZgv8bZPJVg=
Date:   Tue, 14 May 2019 14:18:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ritesh Raj Sarraf <rrs@debian.org>
Cc:     stable@vger.kernel.org, debian-kernel@lists.debian.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] um: Don't hardcode path as it is architecture dependent
Message-ID: <20190514121838.GB13434@kroah.com>
References: <20190514101656.10228-1-rrs@debian.org>
 <20190514102645.GA6845@kroah.com>
 <ae549525ebe4075c9598d8598d39e7d3d088878a.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae549525ebe4075c9598d8598d39e7d3d088878a.camel@debian.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 04:36:38PM +0530, Ritesh Raj Sarraf wrote:
> Hello Greg,
> 
> On Tue, 2019-05-14 at 12:26 +0200, Greg KH wrote:
> > On Tue, May 14, 2019 at 03:46:57PM +0530, Ritesh Raj Sarraf wrote:
> > > The current code fails to run on amd64 because of hardcoded
> > > reference to
> > > i386
> > > 
> > > Signed-off-by: Ritesh Raj Sarraf <rrs@researchut.com>
> > > Signed-off-by: Richard Weinberger <richard@nod.at>
> > > ---
> > >   arch/um/drivers/port_user.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > What is the git commit id of this patch in Linus's tree?
> 
> The git commit id should be: 9ca19a3a3e2482916c475b90f3d7fa2a03d8e5ed

Thanks, now queued up.

greg k-h
