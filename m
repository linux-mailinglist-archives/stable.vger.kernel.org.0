Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC64B3E8B36
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 09:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbhHKHql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 03:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229743AbhHKHqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 03:46:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAD3060EB2;
        Wed, 11 Aug 2021 07:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628667975;
        bh=605MzmQLiffAH7Q90NqXn2IPDwzwrySReFnbsW6/s70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FHkAprg43wts+48IQ1hVKqfXF6FEwhgfhDIbQCyhhBSQhiaOyw1eyZtJypPxd/DAP
         g8PugKfn9vdavFEOSAQc7pllDkR4uxD4Rf3GYyMteR4BY6+d8RLbugNOXePj7oBeWx
         7jmW7vF3oiNniNJxQzaYeMlpfzysHA72xqDha9G0=
Date:   Wed, 11 Aug 2021 09:46:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@jlekstrand.net, Jonathan Gray <jsg@jsg.id.au>
Subject: Re: [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in
 eb_parse()
Message-ID: <YROARN2fMPzhFMNg@kroah.com>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811072843.GC10829@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 09:28:43AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Jonathan Gray <jsg@jsg.id.au>
> > 
> > The backport of c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 to 5.10 in
> > 6976f3cf34a1a8b791c048bbaa411ebfe48666b1 removed more than it should
> > have leading to 'batch' being used uninitialised.  The 5.13 backport and
> > the mainline commit did not remove the portion this patch adds back.
> 
> This patch has no upstream equivalent, right?
> 
> Which is okay -- it explains it in plain english, but it shows that
> scripts should not simply search for anything that looks like SHA and
> treat it as upsteam commit it.

Sounds like you have a broken script if you do it that way.

good luck!

greg k-h
