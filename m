Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B97C14CD7B
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 16:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgA2PgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 10:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgA2PgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 10:36:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99B7B206F0;
        Wed, 29 Jan 2020 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580312183;
        bh=/XrUFl8xZ3WjaZdihjrJQqITqwZJFVwGF5yIhKthqyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y6ojsMvMNJT5ZLHt/zGp6MeryTkGgwvD5FG4VRjQqtQuxjovTFRgTYEOqJBlVp3ID
         aNbIv7/j8jGt/frjnzumkJiHCvxCepLxEXFNeqQVioQoBFnIFjd3e1yBJZhdWdCESd
         xhHWaMuOYH/jgKkqHj/wmCP2kFIWzGb8XOKxXZ4c=
Date:   Wed, 29 Jan 2020 16:36:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/104] 5.4.16-stable review
Message-ID: <20200129153620.GA439013@kroah.com>
References: <20200128135817.238524998@linuxfoundation.org>
 <20200129144356.GC23179@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129144356.GC23179@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 06:43:56AM -0800, Guenter Roeck wrote:
> On Tue, Jan 28, 2020 at 02:59:21PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.16 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 388 pass: 388 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
