Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3E971863
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfGWMkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbfGWMky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 08:40:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D01E2239D;
        Tue, 23 Jul 2019 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563885653;
        bh=2yESyL4sgBNuc4J72xPNiV5LLwH1Zy6lfU+PQ/m8elM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WB5BHPOrYuvvxHlsyV1Uvpixyjqk642wL2iB99l02e/mhiOPq/glScqamMrJLzX8C
         XG1wWIbELE/br1iC0KzC5ada2QNsVUKlAojLJMWfjC1hve47zZQ9QsuYPANTOAMeuW
         sd8hFlNORS4tS0VfpkQ0ZPiIdat7sEXIUDwTQJjc=
Date:   Tue, 23 Jul 2019 14:40:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     dsterba@suse.com, nborisov@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: correctly validate compression
 type" failed to apply to 5.1-stable tree
Message-ID: <20190723124050.GA5356@kroah.com>
References: <156388330112473@kroah.com>
 <20190723121955.GE3997@x250.microfocus.com>
 <20190723122817.GB11835@kroah.com>
 <20190723123018.GF3997@x250.microfocus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723123018.GF3997@x250.microfocus.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 02:30:22PM +0200, Johannes Thumshirn wrote:
> On Tue, Jul 23, 2019 at 02:28:17PM +0200, Greg KH wrote:
> > On Tue, Jul 23, 2019 at 02:19:55PM +0200, Johannes Thumshirn wrote:
> > > Hi Greg,
> > > 
> > > please try the following:
> > > 
> > > >From 9afa2d46ecb511259130eb51b4ab1feb1055d961 Mon Sep 17 00:00:00 2001
> > > From: Johannes Thumshirn <jthumshirn@suse.de>
> > > Date: Thu, 6 Jun 2019 12:07:15 +0200
> > > Subject: [PATCH] btrfs: correctly validate compression type
> > > 
> > > (commit aa53e3bfac7205fb3a8815ac1c937fd6ed01b41e upstream)
> > 
> > Worked for 5.1.y and 4.19.y, but not for the older ones.
> 
> But 4.19 lacks the buggy commit, doesn't it?

272e5326c783 ("btrfs: prop: fix vanished compression property after
failed set") was originally in the 5.1 release, but it was backported
to the 4.14.112 and 4.19.35 releases as well because it had a cc: stable
tag in it.

thanks.

greg k-h
