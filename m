Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128B03705CE
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 08:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhEAGEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 02:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhEAGEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 May 2021 02:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE7DA60724;
        Sat,  1 May 2021 06:03:49 +0000 (UTC)
Date:   Sat, 1 May 2021 08:03:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Jason Self <jason@bluehome.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.12 0/5] 5.12.1-rc1 review
Message-ID: <YIzvQXt5sBTiBwqC@kroah.com>
References: <20210430141910.899518186@linuxfoundation.org>
 <20210430155708.43451c72@pc.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430155708.43451c72@pc.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 03:57:08PM -0700, Jason Self wrote:
> On Fri, 30 Apr 2021 16:20:55 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > This is the start of the stable review cycle for the 5.12.1 release.
> 
> I noticed no problems on until I upgraded to new GCC 11.1. This is
> sparc64.

I don't think gcc 11.1 builds Linus's tree either yet, so this isn't an
issue.

As the fixes for this new compiler come in, letting me know what to
backport is appreciated.

thanks,

greg k-h
