Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9E019BEB7
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 11:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbgDBJdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 05:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgDBJdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 05:33:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 776232072E;
        Thu,  2 Apr 2020 09:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585820025;
        bh=V+DsRmD1jKgFC2f+YdgybKQN7I637/31PDZEdXSxOrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nqKxQe58nVCYAf8XTzJRquS/C5lFKY1TsHHLAUbDrqm8sR5BFsBxkjEwbfDLx/hsu
         wqOCVtlUuj0acX4Pl53r6XF4ThW42ScpTilw0D9/aNx9aNsbBCw3K2u/tuli34cKv2
         PHflktltDrnH4A4pl22VVbaaoT0x1uPcCmANka5o=
Date:   Thu, 2 Apr 2020 11:33:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/10] 5.6.2-rc1 review
Message-ID: <20200402093341.GA2762294@kroah.com>
References: <20200401161413.974936041@linuxfoundation.org>
 <f51f52b7-3afb-6d90-8172-70eaab016e93@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f51f52b7-3afb-6d90-8172-70eaab016e93@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 05:14:20PM -0700, Guenter Roeck wrote:
> On 4/1/20 9:17 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.2 release.
> > There are 10 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
