Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8942F279A9C
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgIZQKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 12:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgIZQKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 12:10:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B0C621527;
        Sat, 26 Sep 2020 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601136624;
        bh=L/jU0eAnnG730b+6O257WWiDq0rUYy/5COa6NSmqZkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0E5qjbaz8/KqK37mzibs5+8XwS9k+qBC3OdJQU+Ajgg/GimU9kqijd2GnxCfcv9JI
         XrYObMgmzhyxwf/Is/siY8F0ZoNX8CXNGL139cRvGFcom73fThakNEnIwaydLEqZz1
         lAY3N8kPFitaE30MCoVX5Ok3CjQy+2zarqMG2JyA=
Date:   Sat, 26 Sep 2020 18:10:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/56] 5.8.12-rc1 review
Message-ID: <20200926161036.GD3361615@kroah.com>
References: <20200925124727.878494124@linuxfoundation.org>
 <20200926154456.GC233060@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926154456.GC233060@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 26, 2020 at 08:44:56AM -0700, Guenter Roeck wrote:
> On Fri, Sep 25, 2020 at 02:47:50PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.12 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 153 fail: 1
> Failed builds:
> 	powerpc:allmodconfig
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> The powerpc failure is the usual spurious 'Inconsistent kallsyms data'.
> Hopefully a fix will find its way into mainline soon.

Hopefully...

> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of these and letting me know.

greg k-h
