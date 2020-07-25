Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3A22D8DE
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 19:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgGYRUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 13:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgGYRUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jul 2020 13:20:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62DC9206D8;
        Sat, 25 Jul 2020 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595697654;
        bh=tsXknhVBYEmB2CJYeY9vU2qcrD5B43pPBPyaIHl7sCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gRrUSykOt9EXcm6iUGecAcMKn8B+gQ2uDu91Esx9bYDK9fpRh7BzoCy5yk/EPvryl
         PRKAUvqpxHPFfIfqOxCxoTdJ9FNBo7En15jyn746/g/l7ujY6HfgeXyylfYvO7FYU5
         QHidFPL6+CVaAR5ojKH7ET3hoPO4f16GRUZsz4Hg=
Date:   Sat, 25 Jul 2020 19:20:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     stable@vger.kernel.org, Scott Branden <scott.branden@broadcom.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/19] firmware_loader: EFI firmware loader must
 handle pre-allocated buffer
Message-ID: <20200725172050.GA405510@kroah.com>
References: <20200724213640.389191-1-keescook@chromium.org>
 <20200724213640.389191-4-keescook@chromium.org>
 <20200725100700.GB1073708@kroah.com>
 <202007250849.2B58CD3B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202007250849.2B58CD3B@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 25, 2020 at 08:50:33AM -0700, Kees Cook wrote:
> On Sat, Jul 25, 2020 at 12:07:00PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jul 24, 2020 at 02:36:24PM -0700, Kees Cook wrote:
> > > The EFI platform firmware fallback would clobber any pre-allocated
> > > buffers. Instead, correctly refuse to reallocate when too small (as
> > > already done in the sysfs fallback), or perform allocation normally
> > > when needed.
> > > 
> > > Fixes: e4c2c0ff00ec ("firmware: Add new platform fallback mechanism and firm ware_request_platform()")
> > 
> > "firmware_request_platform()" :)
> 
> Weird... I'm not sure where that mangling happened. Perhaps a bad
> cut/paste at 80 columns? Hmpf; thanks for catching. I've updated it on
> my end (I assume you fixed this manually, though?)

Yes, I fixed it up already, no worries.

greg k-h
