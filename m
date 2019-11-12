Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F32F989D
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKLS2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:28:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfKLS2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 13:28:18 -0500
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02182206BA;
        Tue, 12 Nov 2019 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573583298;
        bh=0I9pkb6k0fXoK5Q3Ovb6KXLhsqVA4A7Nqlyp8MeqvSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rh/WX5KQaRaOqwDMSSZmMLMkpn5o1xxPUdbXT/riE0jRMZ2y1OI5fObYDhBmUxUyN
         7LCVLBF7uIPwd8ByL9ZuQNCd1dD2buysbz1JVMD0CxMgEpOQ/ScbAHLtOPyGvQcMfG
         K+6tcNCJFlx2TKkl+r41q+WjXLdSoN6S9sZsrIag=
Date:   Tue, 12 Nov 2019 19:26:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/193] 5.3.11-stable review
Message-ID: <20191112182619.GA1824025@kroah.com>
References: <20191111181459.850623879@linuxfoundation.org>
 <20191112182040.GF30127@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112182040.GF30127@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 10:20:40AM -0800, Guenter Roeck wrote:
> On Mon, Nov 11, 2019 at 07:26:22PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.11 release.
> > There are 193 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 391 pass: 391 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
