Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8526223C942
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgHEJey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgHEJew (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 05:34:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD8B72075A;
        Wed,  5 Aug 2020 09:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596620092;
        bh=Cfh6QCLeq5XjsIJn+9NmstpBF1m0cXk6I1N0W9SvAN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EUIAcsFLQiJmiMLh47EkNLaeazsYf9w3EZ++KQvhPEJ+73hhTC+iku/nn455JIS87
         2ea/AfmB8S1LES1JxrZAjhzas9vM0Z7ht5RG50pnXIOJjIiG6ARKojocFKIowjprZo
         fE0kEPls5Qv3TG2EEuGXRtDRaYTiEbTSX1riDog8=
Date:   Wed, 5 Aug 2020 11:35:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/116] 5.7.13-rc3 review
Message-ID: <20200805093510.GA1388764@kroah.com>
References: <20200804085233.484875373@linuxfoundation.org>
 <20200804192418.GD186129@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804192418.GD186129@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 12:24:18PM -0700, Guenter Roeck wrote:
> On Tue, Aug 04, 2020 at 10:53:53AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.13 release.
> > There are 116 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
