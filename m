Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB5B304C
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 15:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfIONmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 09:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfIONmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Sep 2019 09:42:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB7B214C6;
        Sun, 15 Sep 2019 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568554934;
        bh=UDUepZNdoMSBE3UjwJY92HZjrX6wace2q6zswCwfVss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wol0sZc4OytvsYb5tM9Rz7QDBb3YMGasuwDUDUjf/72oa8ah/gT2CJAVsfqsDcfYy
         8lAJki0gyW4MJIAQxqeS0wx5G/cDnWtb0ItdL4QC4svSAjQg4MIfqrXjJoHTRRjm7P
         x3ltWPDfJ/Ww6cNviQ391UoSby8NurG4x/qMzegk=
Date:   Sun, 15 Sep 2019 15:42:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 0/9] 4.4.193-stable review
Message-ID: <20190915134210.GC552389@kroah.com>
References: <20190913130424.160808669@linuxfoundation.org>
 <32171a50-9fa8-5233-3a34-4f1e751b54a9@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32171a50-9fa8-5233-3a34-4f1e751b54a9@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 14, 2019 at 06:55:34AM -0700, Guenter Roeck wrote:
> On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.193 release.
> > There are 9 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 170 pass: 170 fail: 0
> Qemu test results:
> 	total: 324 pass: 324 fail: 0

Yeah this one worked!

I've done a -rc2 for all of the other trees, hopefully that resolves all
of the issues you found in them.

thanks,

greg k-h
