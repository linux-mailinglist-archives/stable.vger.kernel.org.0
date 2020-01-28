Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD6E14BF58
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 19:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgA1SOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 13:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbgA1SOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 13:14:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06D0214AF;
        Tue, 28 Jan 2020 18:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580235278;
        bh=3k9NThVcfievCd4QOFK+JbiJi4/OisfJHuWL53IrZCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CeJ9qTzQMKHNUsLsf/UyKlWab+YinTdGW9HNAblML312r/SnSC23csHvuYaFwbbGT
         kSJFWgS1JN1OpyGotJe2RL09SgpG1nHjuKXhbLFRBfddE/j0LO3GvWY+n8Uv3q7spB
         n1qcbkNLuNu5li5xaGPTLAYDCNBcUEhcqhu5KSsE=
Date:   Tue, 28 Jan 2020 19:14:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/183] 4.4.212-stable review
Message-ID: <20200128181435.GB3673744@kroah.com>
References: <20200128135829.486060649@linuxfoundation.org>
 <20200128175119.GA8176@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200128175119.GA8176@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 09:51:19AM -0800, Guenter Roeck wrote:
> On Tue, Jan 28, 2020 at 03:03:39PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.212 release.
> > There are 183 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> > Anything received after that time might be too late.
> > 
> 
> v4.4.211-184-gc4e686398655:
> 
> arch/powerpc/kernel/cacheinfo.c: In function ‘cacheinfo_teardown’:
> arch/powerpc/kernel/cacheinfo.c:875:2: error: implicit declaration of function ‘lockdep_assert_cpus_held’;

Ugh :(

Will go fix this in 4.4.y and 4.9.y and push out new -rc2 trees with
that resolved, thanks for the quick turn-around.

greg k-h
