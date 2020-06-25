Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAE820A3F1
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 19:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404679AbgFYR12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 13:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404711AbgFYR12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 13:27:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4369320773;
        Thu, 25 Jun 2020 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593106047;
        bh=swKIgBHCHhqeVNFve0RHkoMOIOIki7r6j8InBIrYiIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PkZ2KGxXnnSNrDOALBMdUs9Khc6qtg2PkAjUpT2tXqRHCCA2KuUCuhrGSPZl5AtUX
         Gqle8C6sYcLTqAZEPb+W1dYX2exRhKrbdHJBZ5GUnZlWlUH+6+SZUS5McdECUUseDI
         BFxbsHXdUxifixqPRl0Y+xFmMygH/Dldkjh77oX4=
Date:   Thu, 25 Jun 2020 19:27:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/207] 4.19.130-rc3 review
Message-ID: <20200625172723.GA3966298@kroah.com>
References: <20200624172351.011387771@linuxfoundation.org>
 <20200625155441.GB149301@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625155441.GB149301@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 25, 2020 at 08:54:41AM -0700, Guenter Roeck wrote:
> On Wed, Jun 24, 2020 at 07:27:18PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.130 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Jun 2020 17:23:16 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 421 pass: 421 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
