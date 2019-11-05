Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D8FF0321
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 17:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390245AbfKEQhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 11:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390060AbfKEQhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 11:37:22 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7E2821882;
        Tue,  5 Nov 2019 16:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572971841;
        bh=8bkawGF6C92Iume03tUUw5DghOb0maAehRtJjgYaORA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sv/k6UgWUKg/E3W749a7PNJ5UDZIL1C4k1dXz0ZA3VRlhvwXAii9xvkYFgY03pUuh
         ag4kltqP8p55WAc1WkjJLe8MpW8PxX9sCC/7Ht2jgyc4AR1tzrLA2zuGr2zgbDC3/h
         Y2r3+05TX5WtX8H1RhHT1bvLlQPCpsCLUI86gG98=
Date:   Tue, 5 Nov 2019 17:37:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/163] 5.3.9-stable review
Message-ID: <20191105163712.GA2760793@kroah.com>
References: <20191104212140.046021995@linuxfoundation.org>
 <22e9066f-b2e9-552e-70d8-b6aaf3a01cd4@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e9066f-b2e9-552e-70d8-b6aaf3a01cd4@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 06:26:27AM -0800, Guenter Roeck wrote:
> On 11/4/19 1:43 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.9 release.
> > There are 163 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 391 pass: 391 fail: 0

THanks for testing all of these and letting me know.

greg k-h
