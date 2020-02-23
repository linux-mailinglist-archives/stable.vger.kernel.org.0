Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05936169917
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 18:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgBWRhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 12:37:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgBWRho (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 12:37:44 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE1AE206E2;
        Sun, 23 Feb 2020 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582479464;
        bh=VYRbWHOIu9FMc3Y7uZ5eGq+xnrmoDxqnLJsxvvj2PS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KbknYzEHABY9w/vi1zMdewoe970XwgMr1O2OjR0ZovuTPacjILTtD95h8Ir1F/zor
         2JjHkxXgt6dnLh60DKOVypwJHHKsnc3kE6qenxKY8iFOCgNOfW183TqhltYY9KIad6
         Nz3mCyoaYWKuOTeQVYdYynhsfyKsH5BAjUl8pqO0=
Date:   Sun, 23 Feb 2020 18:37:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/191] 4.19.106-stable review
Message-ID: <20200223173742.GB488033@kroah.com>
References: <20200221072250.732482588@linuxfoundation.org>
 <73554d3c-ff50-d8c7-3694-e67b8a76d904@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73554d3c-ff50-d8c7-3694-e67b8a76d904@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 22, 2020 at 07:46:57AM -0800, Guenter Roeck wrote:
> On 2/20/20 11:39 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.106 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > Anything received after that time might be too late.
> > 
> 
> I didn't send final summaries this time around because all release candidates
> are broken. I expected to get updated images last night, but that didn't
> happen. FTR, the test results for v4.19.105-192-g27ac98449017 are:

Sorry, I was traveling for much longer than expected, hopefully this
should be resolved.

greg k-h
