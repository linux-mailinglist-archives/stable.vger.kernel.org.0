Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80D1171B5
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 08:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfEHGgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 02:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbfEHGgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 02:36:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D68214C6;
        Wed,  8 May 2019 06:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557297371;
        bh=DyFZUP47fvNxPifOYx9AZaS6bp/RaKFBOFQd4OB6xDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pI0hDQtwZs8/Mbl88wUCD2WOqw7BKHBzQ5wbMAWQLIPv88uAlSerJJaIg3RbMQfHC
         v/UylA9Q86TSZJ5RT4I1/MKaK//JyMek1eMP1VDVwBRCmeyaxlZHtEti+M5OJ7uJ8t
         F3Z/KQOlb6NCbv1uBelJDb+O/nYvWwWro/ef4S/E=
Date:   Wed, 8 May 2019 08:36:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.0 000/122] 5.0.14-stable review
Message-ID: <20190508063608.GB28651@kroah.com>
References: <20190506143054.670334917@linuxfoundation.org>
 <5f6a5628-9613-99f2-a4f4-619f6f7d6018@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f6a5628-9613-99f2-a4f4-619f6f7d6018@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 02:19:45PM -0600, shuah wrote:
> On 5/6/19 8:30 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.0.14 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 08 May 2019 02:29:09 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
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
