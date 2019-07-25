Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08287756B2
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 20:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfGYSRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 14:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfGYSRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 14:17:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CFEF218F0;
        Thu, 25 Jul 2019 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564078629;
        bh=AJVoc2epXGd7c9kfW/jeXPJ0q+wK45OdPrV284d0UaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HVLwOjt7aQMS6RHqte9cT2pn1EU4LVdplnXWGmGbCABtcz336Ct9iJRv7ACPMhEl6
         S/jaATvpiK3lNhicCHplO23XlRs+j5j3yGTHvTJI5t82iZooLzretJ3VCcGfsmEwAE
         Kcstad/jb+lTd9j9LZNj+g10b8UgntsIFLXjK2+c=
Date:   Thu, 25 Jul 2019 20:17:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190725181707.GA10098@kroah.com>
References: <20190724191735.096702571@linuxfoundation.org>
 <f0e2b7f5-b078-2639-6011-0ac04966a347@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e2b7f5-b078-2639-6011-0ac04966a347@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 09:35:09AM -0600, shuah wrote:
> On 7/24/19 1:14 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.3 release.
> > There are 413 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.3-rc1.gz
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
