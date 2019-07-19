Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2776D977
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfGSDqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfGSDqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:46:42 -0400
Received: from localhost (p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp [153.156.43.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175832173B;
        Fri, 19 Jul 2019 03:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508001;
        bh=nAYoqz+5H882kFi+NQUIEku47ymiqi7InWyq1u7P9PY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i5wIuLqdpYaUcGQsxJtViTntSroo/MUYRD/gi1qnkcn4Qie2BLVrzMHPRtKn15Mw5
         W7QvwLKxImMFB7Cccu+PGsI/rX9uVLJhFtj04v75HNABB0cXwdSj62tqDJbi+dz5qz
         zj8KVesz3EKkqVAScSwr16T61Nuksrezo/JzO+Jc=
Date:   Fri, 19 Jul 2019 12:46:38 +0900
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/21] 5.2.2-stable review
Message-ID: <20190719034638.GB8184@kroah.com>
References: <20190718030030.456918453@linuxfoundation.org>
 <20190718194907.GF24320@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718194907.GF24320@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:49:07PM -0700, Guenter Roeck wrote:
> On Thu, Jul 18, 2019 at 12:01:18PM +0900, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.2 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

THanks for testing all of these and letting me know.

greg k-h
