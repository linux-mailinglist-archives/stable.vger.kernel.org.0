Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10236456E48
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 12:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhKSLid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 06:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234542AbhKSLib (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 06:38:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D18AF61AFB;
        Fri, 19 Nov 2021 11:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637321729;
        bh=0mMxTxaBCwhVTZnQeua3KUuMQaonvxomLNBFDzUScG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xKn98P/SmTGDmWkjg30ib8L+nA/6x442N/m/dBV9OIH9nK4dGSS9a4Mw8vHySuhK0
         TaT7ODCGugMuMqBRAdoWqi5e09tUlbHrbnxFNc+DfRSLcSvswlASbrX38nuVdoBydr
         PsdpfF0wngtWQbxl1MtKa0MKNK3urbSR36wT9FgI=
Date:   Fri, 19 Nov 2021 12:35:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Please apply commit 5c4e0a21fae8 ("string: uninline
 memcpy_and_pad") to v5.15.y
Message-ID: <YZeL/tLIXYqcnvhy@kroah.com>
References: <70eadb53-b964-796b-dc4b-470e226c0982@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70eadb53-b964-796b-dc4b-470e226c0982@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 03:13:46AM -0800, Guenter Roeck wrote:
> Hi Greg,
> 
> please apply commit 5c4e0a21fae8 ("string: uninline memcpy_and_pad")
> to v5.15.y to avoid the following build error seen with gcc 11.x.
> 
> Building m68k:allmodconfig ... failed
> --------------
> Error log:
> In file included from include/linux/string.h:20,
>                  from include/linux/bitmap.h:10,
>                  from include/linux/cpumask.h:12,
>                  from include/linux/smp.h:13,
>                  from include/linux/lockdep.h:14,
>                  from include/linux/spinlock.h:63,
>                  from include/linux/mmzone.h:8,
>                  from include/linux/gfp.h:6,
>                  from include/linux/slab.h:15,
>                  from drivers/nvme/target/discovery.c:7:
> In function 'memcpy_and_pad',
>     inlined from 'nvmet_execute_disc_identify' at drivers/nvme/target/discovery.c:268:2:
> arch/m68k/include/asm/string.h:72:25: error: '__builtin_memcpy' reading 8 bytes from a region of size 7

Now queued up, thanks.

greg k-h
