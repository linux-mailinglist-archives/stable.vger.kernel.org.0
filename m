Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847EA195813
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 14:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgC0NcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 09:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgC0NcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 09:32:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F63720838;
        Fri, 27 Mar 2020 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585315933;
        bh=HNpnIDl0zqSNywSLkkSXxGutEzA7mG44rwD9YIFLqlg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YL5F8s3x1x7iIln8cyC45KTkV5cKWdpSc1OY/O2wu6/S//wsTuY839eG9pUMWPE70
         AtERwdhwXljwc6JjqoFnsPljd6ZDfxcQ/cZks+uMAK5MSRmjj7voQDsfFtJ/tyxY5z
         Wj/5TY/+SkIUWih+RJrzcO1ApDsfznp/92S8BBrc=
Date:   Fri, 27 Mar 2020 14:32:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: Commit 024aa8732acb for 5.4.y
Message-ID: <20200327133210.GA2267097@kroah.com>
References: <CAJZ5v0izbXdxMWZaySokD+7smnZhSpjOJy5DQGNG+Dw3+iFVZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0izbXdxMWZaySokD+7smnZhSpjOJy5DQGNG+Dw3+iFVZQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 02:11:46PM +0100, Rafael J. Wysocki wrote:
> Hi Greg at al,
> 
> Please the following commit:
> 
> commit 024aa8732acb7d2503eae43c3fe3504d0a8646d0
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Thu Nov 28 23:50:40 2019 +0100
> 
>     ACPI: PM: s2idle: Rework ACPI events synchronization
> 
>     Note that the EC GPE processing need not be synchronized in
>     acpi_s2idle_wake() after invoking acpi_ec_dispatch_gpe(), because
>     that function checks the GPE status and dispatches its handler if
>     need be and the SCI action handler is not going to run anyway at
>     that point.
> 
>     Moreover, it is better to drain all of the pending ACPI events
>     before restoring the working-state configuration of GPEs in
>     acpi_s2idle_restore(), because those events are likely to be related
>     to system wakeup, in which case they will not be relevant going
>     forward.
> 
>     Rework the code to take these observations into account.
> 
>     Tested-by: Kenneth R. Crudup <kenny@panix.com>
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> 
> into 5.4.y as it is needed to fix an ACPI wakeup events
> synchronization issue in suspend-to-idle.
> 
> Note that this commit was present in 5.5.0, so 5.4.y is the only
> -stable series needing this fix.

Now queued up, thanks!

greg k-h
