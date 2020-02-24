Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2A169F50
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 08:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgBXHe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 02:34:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgBXHe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 02:34:56 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4765020637;
        Mon, 24 Feb 2020 07:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582529695;
        bh=o+yL1rAZEZaOSpkYZ2IJzD35Vhx8Z6VvSOO76ueSMKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sq/dMG06eMMypKL0oNarz1mCbIGJDWhBYEhVFN74xs/mT43BNH5SVOnPnvk+Pti46
         tfu7FujvUf58RQjJ94R1dEoZ2thZYZ7DsrZKvgzu7ZA+hxjRLIwLMFT70WnkFjGyjC
         1nVVu5QzJdVHfGfJ7SOCdKpgAQK7niJL82fIAHFQ=
Date:   Mon, 24 Feb 2020 08:34:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
Message-ID: <20200224073453.GA651792@kroah.com>
References: <20200221072402.315346745@linuxfoundation.org>
 <f0283e80-9f30-9c17-579f-91e3d5d66a04@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0283e80-9f30-9c17-579f-91e3d5d66a04@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 23, 2020 at 04:18:46PM -0800, Guenter Roeck wrote:
> On 2/20/20 11:35 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.6 release.
> > There are 399 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For v5.5.5-393-g8ba99698af46:
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 416 pass: 416 fail: 0

Great, thanks for all the help in testing this round.

greg k-h
