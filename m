Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE972A7C50
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 11:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgKEKw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 05:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbgKEKw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 05:52:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 023C42151B;
        Thu,  5 Nov 2020 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604573577;
        bh=HLwjzh+Ab+YRSUIlLPef0SMVt0Bc/DTXD1TFz9l23eg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dIBO33fLLjA/OPg65LFHzU55WtvpB3tQ1bJnzzEVv2mfXISepiXZ4jMNTDFRFZDay
         ARTvPrW8rtJJyTi2ouVrEk7hKc1WMOgG9YbF6P9B94K2eCPUYGtOyvANjT5W5vKeoN
         YScjbOKF+jbmr+9zQJex9YBCfRZxzvfy8lpSjiZE=
Date:   Thu, 5 Nov 2020 11:53:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/391] 5.9.4-rc1 review
Message-ID: <20201105105346.GC4038994@kroah.com>
References: <20201103203348.153465465@linuxfoundation.org>
 <20201104175123.GD225910@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104175123.GD225910@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 09:51:23AM -0800, Guenter Roeck wrote:
> On Tue, Nov 03, 2020 at 09:30:51PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.4 release.
> > There are 391 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

I should have fixed up the other build issues, and thanks for letting me
know about all of these.

greg k-h
