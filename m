Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30D515315C
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 14:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgBENCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 08:02:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgBENC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 08:02:29 -0500
Received: from localhost (unknown [212.187.182.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2F1A218AC;
        Wed,  5 Feb 2020 13:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580907748;
        bh=JO0PiD6GAtZW4R/gNGJ7SITTwqtP29t+uZTX1Ax5Gtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HC04tIk7WLAY+u93dDpB0rQ6/y46U6V8mv0IkUa7eEjKHmRdpw93PhOQyO5ttx8Pf
         EGR+PMk7kETqvVGc9ZR0vg2njXsNVgkD/HsHjKfL384nx3nB5NfbAUT8MNf8T9z00L
         XzzKWEarx9vbjzo5UMrmA3c03ESZwgl3MvQfwBGY=
Date:   Wed, 5 Feb 2020 13:02:25 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/53] 4.4.213-stable review
Message-ID: <20200205130225.GB1199959@kroah.com>
References: <20200203161902.714326084@linuxfoundation.org>
 <3bd0423b-478e-d626-88e7-5d62167ee7e0@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bd0423b-478e-d626-88e7-5d62167ee7e0@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 06:43:58AM -0800, Guenter Roeck wrote:
> On 2/3/20 8:18 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.213 release.
> > There are 53 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > Anything received after that time might be too late.
> > 
> 
> arm:{allmodconfig, omap2plus_defconfig, imx_v6_v7_defconfig}"
> 
> arch/arm/kernel/hyp-stub.S: Assembler messages:
> arch/arm/kernel/hyp-stub.S:147: Error: selected processor does not support `ubfx r7,r7,#16,#4' in ARM mode

Thanks, have now dropped the offending patch.

greg k-h
