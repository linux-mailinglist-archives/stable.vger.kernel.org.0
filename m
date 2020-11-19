Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CC32B9247
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 13:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgKSMNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 07:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgKSMNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 07:13:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C647D246B0;
        Thu, 19 Nov 2020 12:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605787979;
        bh=A5X2c9veLVTHMILwlAf1UQTaaLM190we49PDzR6YmM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xFKQEPnJdlJYH9bJKScDiyXpRgH5NPvBPIBLF2hUsaPOSSUdvZFyMq6UXsXMturSn
         HL2VsE15c4I40lgZwd8w/NpK1yDyzCTKcowxCPk3HMZmRvmH640LpkXBCoRwFkJnrj
         dbfMQDMdiB7Kayh4vprBJ3DVQnP51rFI+b7iInnM=
Date:   Thu, 19 Nov 2020 13:13:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/255] 5.9.9-rc1 review
Message-ID: <X7Zhd0Ka54s1voQ5@kroah.com>
References: <20201117122138.925150709@linuxfoundation.org>
 <20201118152546.GA174641@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118152546.GA174641@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 18, 2020 at 07:25:46AM -0800, Guenter Roeck wrote:
> On Tue, Nov 17, 2020 at 02:02:20PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.9 release.
> > There are 255 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of these and letting me know.

gre gk-h
