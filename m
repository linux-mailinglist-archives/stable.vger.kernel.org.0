Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD41804F4
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 09:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfHCHJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 03:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727201AbfHCHJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 03:09:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F8022087C;
        Sat,  3 Aug 2019 07:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564816139;
        bh=3EcRt6U9sYtaanaCPv6B+Cvsq16YBkeq/EHReC1GLGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2auqNNhmrIyhe3KY3JmOf6igoAyAJMmmvJSuaqQUA0pILdhOlLhCL3Abhxt/u3lWw
         5dwHx3nRgLb2HiKrVwqd+VuZZgVw4HwvwRGivqZldRz6ocWiaX+/StrbMPS9EwNCyo
         yVRVWTLA/s+A/jY7Iv6P/5bwXQfB3gRIrc2keZkQ=
Date:   Sat, 3 Aug 2019 09:08:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
Message-ID: <20190803070857.GA24334@kroah.com>
References: <20190802092055.131876977@linuxfoundation.org>
 <3245056b-0437-72d8-6aeb-749e6bce8793@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3245056b-0437-72d8-6aeb-749e6bce8793@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 05:25:40PM -0600, shuah wrote:
> On 8/2/19 3:39 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.6 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
