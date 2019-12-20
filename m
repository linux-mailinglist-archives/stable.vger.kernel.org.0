Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7C11275C8
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 07:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfLTG32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 01:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfLTG32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 01:29:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DA9921D7D;
        Fri, 20 Dec 2019 06:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576823367;
        bh=lVSesAA+4CxihPJB6l771gxxLbj9f1eIrR1zOpSBJXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gB5DUjfsMXgfkNoD4RItJpT9sHvRUzLNHrTrXAO0vhp0vsz4sugrm9NBpW465ZRdJ
         DTzq1YSf9bU9qOOkaP4h3KEX3oFD8XHxHC30iWNXqdFqhDoIR6//v8EZFB0S8HDJFJ
         PbDw2FLw6RAMaTqcMaQdL4tJ+dkRg/zaHzpR2OlA=
Date:   Fri, 20 Dec 2019 07:29:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/80] 5.4.6-stable review
Message-ID: <20191220062925.GB2183748@kroah.com>
References: <20191219183031.278083125@linuxfoundation.org>
 <edc11c7b-86a5-319d-a2c0-640234eb1003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edc11c7b-86a5-319d-a2c0-640234eb1003@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 09:30:04PM -0700, shuah wrote:
> On 12/19/19 11:33 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.6 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
