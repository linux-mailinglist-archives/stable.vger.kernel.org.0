Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5953B26B4
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 07:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFXFXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 01:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhFXFXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 01:23:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62F78613E2;
        Thu, 24 Jun 2021 05:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624512048;
        bh=qd/c/frC6rWUAJZD5GduEjUYTotUTpnUDtDJhIQdLfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aFW9KZ29vmaHZDTQcoxPtJUkgq94amnviNAy//338khfAW7cvP8xbFvfcTakcrQz8
         Ile67jXJao3fJGh635buOr7brRgbs2frLriHD8GApgYiz0j6JUJw8fOwgS6ggOrx9/
         BnZjZA6JXlBaz4AY3O8yZRi+SvtyVTsYwAJoH6eY=
Date:   Thu, 24 Jun 2021 07:20:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 4.19 425/425] scripts: switch explicitly to Python 3
Message-ID: <YNQWLNoMznAxx5+b@kroah.com>
References: <20210520092131.308959589@linuxfoundation.org>
 <20210520092145.369052506@linuxfoundation.org>
 <20210520203625.GA6187@amd>
 <YKc4wSgWcnGh3Bbq@kroah.com>
 <YKc47AGJRaBn3qIQ@kroah.com>
 <20210623202529.GG8540@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623202529.GG8540@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 10:25:29PM +0200, Pavel Machek wrote:
> On Fri 2021-05-21 06:37:00, Greg Kroah-Hartman wrote:
> > On Fri, May 21, 2021 at 06:36:18AM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, May 20, 2021 at 10:36:26PM +0200, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > > 
> > > > > commit 51839e29cb5954470ea4db7236ef8c3d77a6e0bb upstream.
> > > > > 
> > > > > Some distributions are about to switch to Python 3 support only.
> > > > > This means that /usr/bin/python, which is Python 2, is not available
> > > > > anymore. Hence, switch scripts to use Python 3 explicitly.
> > > > 
> > > > I'd say this is unsuitable for -stable.
> > > > 
> > > > Old distributions may not have python3 installed, and we should not
> > > > change this dependency in the middle of the series.
> > > 
> > > What distro that was released in 2017 (the year 4.14.0 was released) did
> > > not have python3 on it?
> > 
> > oops, I meant 2018, when 4.19.0 was out, wrong tree...
> 
> In anything yocto-based, for example, you explicitely select which
> packages you want. And changing dependencies in middle of stable
> release is surprising and against our documentation.

Yocto documentation does not dictate kernel development processes.

good luck!

greg k-h
