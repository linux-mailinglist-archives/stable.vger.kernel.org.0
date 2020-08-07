Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216C123E848
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 09:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgHGHsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 03:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgHGHsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 03:48:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F01D221E5;
        Fri,  7 Aug 2020 07:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596786497;
        bh=B+w8pE3q3gBGNyk0eDtluvfGywFYIKgHWYYctrH9J0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dC1fk7eIf8TEBMJoJmM7yh26LaGYC50Itumy+iZVqhAzcVZviolOpdws4yl2TOOU7
         +9M4rYXbHe7uMXdkrU+gcvwex3CLPtTYRAqSb2DkgeUvKYgXKUkdoLaYKJPn2rGZBa
         7vpHOu05DQrwjq0x1tbF0g9HInDUZ5Wfwt2IYDOU=
Date:   Fri, 7 Aug 2020 09:48:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 0/7] 5.7.14-rc2 review
Message-ID: <20200807074830.GC3048107@kroah.com>
References: <20200805195916.183355405@linuxfoundation.org>
 <20200806185836.GD236944@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806185836.GD236944@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 11:58:36AM -0700, Guenter Roeck wrote:
> On Wed, Aug 05, 2020 at 09:59:33PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.14 release.
> > There are 7 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Thanks for testing all of these.

greg k-h
