Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3FC117968D
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 18:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgCDRS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 12:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgCDRS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 12:18:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5172721775;
        Wed,  4 Mar 2020 17:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583342338;
        bh=Hi46C8miaxSJDl9YWIo3LxQmSQqaJQU9BO0DcjVlBh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=snyvNtq94D94ViBPiqtiYopX7TuXIx7pAS01tEPlxuKootu7Uj5AfSm9I9MFbDapL
         UzBWcpYdpB2GfFioG1zOa3TFnA/X94ZSLPJrZOcvsdIaf1Sr/YgPxHIO12jSP7vgDD
         LVdLuRvTgjQJUYCAeeyy5gSsyCjZkmA25mo5F/Wc=
Date:   Wed, 4 Mar 2020 18:18:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
Message-ID: <20200304171856.GD1852712@kroah.com>
References: <20200303174304.593872177@linuxfoundation.org>
 <20200304165312.GC22358@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304165312.GC22358@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 08:53:12AM -0800, Guenter Roeck wrote:
> On Tue, Mar 03, 2020 at 06:41:04PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.8 release.
> > There are 176 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 423 pass: 423 fail: 0

Wonderful, thanks for testing these and letting me konw.

greg k-h
