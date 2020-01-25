Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7ED14998D
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 08:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgAZHnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 02:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgAZHnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jan 2020 02:43:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A8321734;
        Sun, 26 Jan 2020 07:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580024585;
        bh=gzFb3FIwende/52Sex6BcYaaLW9CAKocNXuXkuxnZeE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=coz6boZLQknJVqpPS/jZrBOi57Wc5cnc+L8BdIBdGoA3+J07Gh7VuygvBYRbSBLUO
         OoOYHhsR5L5VpxFJjeLT27Vol2cprtRE0GfJBq2oS/yg1Vhgvt8XZWJs9eALcfqbGm
         Pa6RnOHBwTJgxVrci7Alg4TviCHJaTgPkmcj+LDQ=
Date:   Sat, 25 Jan 2020 14:51:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/102] 5.4.15-stable review
Message-ID: <20200125135158.GA3519301@kroah.com>
References: <20200124092806.004582306@linuxfoundation.org>
 <ff4da7a6-5b13-89fd-1cec-9dc2b85a0ae7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff4da7a6-5b13-89fd-1cec-9dc2b85a0ae7@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 02:46:59PM -0700, shuah wrote:
> On 1/24/20 2:30 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.15 release.
> > There are 102 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.15-rc1.gz
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
