Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFFC57545
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfF0ALh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfF0ALg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:11:36 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C81F216C8;
        Thu, 27 Jun 2019 00:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561594295;
        bh=5DDui4iuonpz2LKxoAqKGqJHGkisAqRFtDT76gTVIZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xnUBYpkMsoNlcxxdFEH/u6Re9a8PnM4kljxwPlwIhZb5tF95iDqMKzKbhQXGkX/+M
         8gQQ8gvPz3aEByYOTHaBAsOL80uA661mbpbj9wg5zNjWIh3JIsbQR8j85M51dLuX3g
         7IhbB/4TUrXLcrWfjKoBBXYvN+ME7mkb/OJRXetU=
Date:   Thu, 27 Jun 2019 08:11:32 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 0/1] 4.14.131-stable review
Message-ID: <20190627001132.GD527@kroah.com>
References: <20190626083606.248422423@linuxfoundation.org>
 <20190626173613.GB2530@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626173613.GB2530@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 10:36:13AM -0700, Guenter Roeck wrote:
> On Wed, Jun 26, 2019 at 04:45:20PM +0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.131 release.
> > There are 1 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 172 pass: 172 fail: 0
> Qemu test results:
> 	total: 346 pass: 346 fail: 0

Wonderful, thanks for testing these and letting me know.

greg k-h
