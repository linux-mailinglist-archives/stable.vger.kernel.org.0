Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9A23C94C
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgHEJfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbgHEJfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 05:35:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F962173E;
        Wed,  5 Aug 2020 09:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596620108;
        bh=nr3Gwx8f0h9l3j6WBIzrsYb0QLrJrGIiARd1k+UJ2xQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fgMLF/rvU5muUTy7h0xQKT7+fEnUarKtAuoTDXqyFvfjiHAXfC+O3OzDcBVDcJE5s
         6j00K2K3bx/HbxVoTMUAt6fASP15UgFEgprehRHmJNIwH9aQV7GvHlv5u98JhRffua
         ShG0jdqdtUjlYI96pGL7KqLIw61AYluNoChEznsM=
Date:   Wed, 5 Aug 2020 11:35:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/116] 5.7.13-rc3 review
Message-ID: <20200805093526.GB1388764@kroah.com>
References: <20200804085233.484875373@linuxfoundation.org>
 <5770087e-992e-39ac-61c1-5fc23fdee22f@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5770087e-992e-39ac-61c1-5fc23fdee22f@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 02:21:31PM -0600, Shuah Khan wrote:
> On 8/4/20 2:53 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.13 release.
> > There are 116 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.13-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing all of these and letting me know.

greg k-h
