Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1AE77846
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 12:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfG0KuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 06:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfG0KuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jul 2019 06:50:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7145D2081B;
        Sat, 27 Jul 2019 10:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564224602;
        bh=puzQsGjnt15rkiUfXA/RWn3azul1N4E6hfDvzplyaZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IO6Iz5KYMy3C8ACWdJLx2KaHX3wy0xfY1NLE0XSKGbcxa459/jMsv5eFftoYlX4NV
         zmXyjBNgcCWIFXQN63heoEOwG9pWIfNKk72WLTy0HgeT8fVEt/g9ZUQzZ9CABQNbds
         tokmieeoD7RE/qAlwG/GGFlm7i/bcF04JSs6dPXw=
Date:   Sat, 27 Jul 2019 12:50:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/66] 5.2.4-stable review
Message-ID: <20190727105000.GB32555@kroah.com>
References: <20190726152301.936055394@linuxfoundation.org>
 <2cd55ec5-ea26-2d47-1aa2-276662329e59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cd55ec5-ea26-2d47-1aa2-276662329e59@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 08:33:27PM -0600, shuah wrote:
> On 7/26/19 9:23 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.4 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions,

Thanks for testing all of these and letting me know.

greg k-h
