Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB411898B4
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 10:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgCRJ7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 05:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRJ7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 05:59:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F29720767;
        Wed, 18 Mar 2020 09:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584525576;
        bh=gOMY48AxhaddmpM8KsxvfyKZ95lFLO7SWpIVx9MkMDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bho7cgJlyczgQzdtnqzmANX22taag2Vl8taWqYKguVMKpnuGt4XWUNB7V6T3LNS3X
         nrwJKIY4/OyfsaqA7NWKuYrIkQIdihkrYgiPMfckbv08xv5aMIdJNrV2QbNf/0oPWI
         wiiwa2+/752wO9nO/FDsoitM9RuuXDTnt9uPqCX4=
Date:   Wed, 18 Mar 2020 10:59:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/151] 5.5.10-rc1 review
Message-ID: <20200318095932.GB2034476@kroah.com>
References: <20200317103326.593639086@linuxfoundation.org>
 <260df9bf-004c-9f1c-c5f3-479e024d69de@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <260df9bf-004c-9f1c-c5f3-479e024d69de@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 12:48:13PM -0700, Guenter Roeck wrote:
> On 3/17/20 3:53 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.10 release.
> > There are 151 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Great, thanks for testing all of these and letting me know.

greg k-h
