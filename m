Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAF43CC1
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfFMPhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfFMPhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 11:37:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A7E02080A;
        Thu, 13 Jun 2019 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560440267;
        bh=GVf49hFCmcRRH5IPgZDm+9Q8NkzxgT1kPYT89nbbwgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDnHm1StBx+nQRq0m1g9H/twrrrfEiVi0hC8aCH1S5N0Zc8HGay21dh98aIyPLML2
         /cYshCvedsyI7rMoGeegHKKGvkNMmTfLPk39drws9i3soJUgRYhEiwX0QXcxCz8Tno
         yhzOcoCOvptF3CaDx7C9LVVUTJd8ZQVQ7iEqZcDE=
Date:   Thu, 13 Jun 2019 17:37:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     sashal@kernel.org, Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/81] 4.14.126-stable review
Message-ID: <20190613153744.GA15226@kroah.com>
References: <20190613075649.074682929@linuxfoundation.org>
 <1139f9d4-1a0a-b422-276d-546e7cb1bc85@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1139f9d4-1a0a-b422-276d-546e7cb1bc85@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 08:11:33AM -0700, Guenter Roeck wrote:
> On 6/13/19 1:32 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.126 release.
> > There are 81 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 15 Jun 2019 07:54:51 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> [early feedback]
> 
> Building mips:nlm_xlp_defconfig ... failed (and other mips builds)
> --------------
> Error log:
> /opt/buildbot/slave/stable-queue-4.14/build/arch/mips/kernel/prom.c: In function 'early_init_dt_add_memory_arch':
> /opt/buildbot/slave/stable-queue-4.14/build/arch/mips/kernel/prom.c:44:14: error: 'PHYS_ADDR_MAX' undeclared
> 
> The problem affects v4.14.y and all earlier branches.
> PHYS_ADDR_MAX is indeed undeclared in those branches. It was introduced
> with commit 1c4bc43ddfd52 ("mm/memblock: introduce PHYS_ADDR_MAX").

Thanks, I've dropped the mips patch that caused this.  I'll also drop it
from the 4.4 and 4.9 trees.

Sasha, I thought you had builders set up for stuff like this?

greg k-h
