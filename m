Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DECFBC2D64
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 08:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfJAGTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 02:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJAGTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 02:19:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4303E215EA;
        Tue,  1 Oct 2019 06:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569910748;
        bh=qyo5l4BO9qSh5Sx4tnDeF/LgGMXNfboJ3yJ2sElUKJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0hx25+a0Oy7Tv7630pYdV3yjzvYCngmz8U1I0rVkEm94pFu4/80f5EE8gDrs/C1G
         VmOtcoAIGhk6IqtKTmdjTWRDDXdd9TMpFSTlBQNJMQiVqDiJcSFOV6onLZHxazTnaO
         s78gLMalKAxaIWMUtLt5/BP1xBIgB8Vms+/YDdqQ=
Date:   Tue, 1 Oct 2019 08:19:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/25] 5.3.2-stable review
Message-ID: <20191001061906.GC2815916@kroah.com>
References: <20190929135006.127269625@linuxfoundation.org>
 <20190930183015.GB22096@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930183015.GB22096@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 11:30:15AM -0700, Guenter Roeck wrote:
> On Sun, Sep 29, 2019 at 03:56:03PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.2 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 391 pass: 391 fail: 0

Great, thanks for testing all of these and letting me know.

greg k-h
