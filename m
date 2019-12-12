Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9A811C94F
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfLLJiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbfLLJiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:38:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDF8214D8;
        Thu, 12 Dec 2019 09:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143495;
        bh=UlUP+r0l6vL+p/u4gySp7aVL3E71ArRcpUychAwWhPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MS++4ttC54jH1jDF73vhXP7cwgJukDkqynlvmzwMOFuwjrkAY/YPZ0anugF7/ks+J
         qOOOH7gasOLJoKZ+WRP1eDTN9eTKA7MCWBSrJOexedi4ylfH+cSZ8IMRsZlQ15jb2p
         8omnUul+tj3HzSjfLixGhVnRHSDh1yzPF+15oSCU=
Date:   Thu, 12 Dec 2019 10:36:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
Message-ID: <20191212093645.GH1378792@kroah.com>
References: <20191211150221.977775294@linuxfoundation.org>
 <0253e33d-afa5-3dda-95d5-220535537eb4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0253e33d-afa5-3dda-95d5-220535537eb4@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 07:48:28PM -0700, shuah wrote:
> On 12/11/19 8:04 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.3 release.
> > There are 92 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc1.gz
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
