Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E4114E893
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 07:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgAaGG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 01:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgAaGG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 01:06:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399752082E;
        Fri, 31 Jan 2020 06:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580450784;
        bh=hRukl1dm5QSvpXFH5kTsRLyYQBTXAnyo2x0DgzgPIIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0HcffgGHGHIbiwVAmOCh1SRXUGvI5CNgpQAOCC4aUs4vZCQdgxGi8LTBlTous6hor
         yz+MeKlXCVqG0oaCpuLC8JSx5TQlyfS8nGqLwCeI48Ht/sGyVFxMvZdcBYuNPdCn0g
         BQujIWCqKV+M95vlz+R3JgVhrpRELdmWjSfXTfBw=
Date:   Fri, 31 Jan 2020 07:06:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/56] 5.5.1-stable review
Message-ID: <20200131060622.GB2179850@kroah.com>
References: <20200130183608.849023566@linuxfoundation.org>
 <a99ad773-c0ac-f887-5f74-b47eb395803f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a99ad773-c0ac-f887-5f74-b47eb395803f@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 09:40:28PM -0700, shuah wrote:
> On 1/30/20 11:38 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.1 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
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
