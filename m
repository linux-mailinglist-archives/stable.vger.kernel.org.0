Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE95139C29
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 11:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfFHJc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 05:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbfFHJc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 05:32:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82852212F5;
        Sat,  8 Jun 2019 09:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559986379;
        bh=jT5ZKmteGTRTV3nBeQTt7nV50BpI9erE79XuDUgymYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8TGsTXpHk/w4tOqPxzG0bY3k6ym0vIKreELt14MheWVE5wb2ZdCJzsNTTU/tJser
         dbRrD+MR4y+VGh8KJrPEzHVD7mV9sU6GV08hyS3Ei/HVyKZoQ+zEU1z35lW/jadQvk
         nInUggyZqlotNZgcaaVqEOVHqxNNSjgTZKDCoTN4=
Date:   Sat, 8 Jun 2019 11:32:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
Message-ID: <20190608093256.GD19832@kroah.com>
References: <20190607153848.271562617@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.124 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.

-rc2 is out, to hopefully resolve the btrfs 32bit build failure:
 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.124-rc2.gz

thanks,

greg k-h
