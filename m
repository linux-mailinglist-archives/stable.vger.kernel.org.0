Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6074D52164
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 05:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfFYDxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 23:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfFYDxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 23:53:42 -0400
Received: from localhost (unknown [116.226.249.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 270FA2089F;
        Tue, 25 Jun 2019 03:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561434821;
        bh=zC4UyLLMMwKefCEt2ugCmbhdhGv1VywUC2aQCvLeFME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0huKlhMRfMPkLZAlnZX5nVx76V965I2JnoHS2LMdJBjYT0MCHBxp9KpNmhsvk7frr
         Ii2HD7164qpfRhovgAA6OV9kCi62owXZ9rnS7+khaKyRvYYPtJTDEEln/rsrKJ5v8W
         8Dq0BrBYXgXtzjJnKfVRyy569MDCnt+Gz/OysLp4=
Date:   Tue, 25 Jun 2019 11:08:28 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/121] 5.1.15-stable review
Message-ID: <20190625030828.GB11074@kroah.com>
References: <20190624092320.652599624@linuxfoundation.org>
 <cce74c67-5844-a60e-8fbc-9ebb29bef826@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce74c67-5844-a60e-8fbc-9ebb29bef826@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 05:15:41PM -0700, Guenter Roeck wrote:
> On 6/24/19 2:55 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.15 release.
> > There are 121 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> For v5.1.14-122-g815c105311e8:
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

Great!  Thanks for testing these and letting me know.

greg k-h
