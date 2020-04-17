Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C52F1AD8C3
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 10:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbgDQIig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 04:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729650AbgDQIif (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 04:38:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F962137B;
        Fri, 17 Apr 2020 08:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587112715;
        bh=pK4RIabtc8C96XCzrexGS4ZYK5gul5qNF93/fIrP700=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zjX6bqTfWF63eaHRVjf3jwIzP+ZE7+M4VXGw8ybnc47ZqR6ap4Mdjfzyf+VtQuDtZ
         Tv5ILDuhI7jo9fmIO9zFDeQYeD55lzTOqde+DjYi8ge5IcAUyFJXZ9C75AvTsTiH/H
         auzzdi4cBDBcn7bWSjE+XXpyHXXFBjBkXVOfQCzw=
Date:   Fri, 17 Apr 2020 10:38:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/254] 5.6.5-rc1 review
Message-ID: <20200417083833.GF141762@kroah.com>
References: <20200416131325.804095985@linuxfoundation.org>
 <a93947f1-c810-70af-219a-63a4ab01e125@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a93947f1-c810-70af-219a-63a4ab01e125@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 02:17:03PM -0700, Guenter Roeck wrote:
> On 4/16/20 6:21 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.5 release.
> > There are 254 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
