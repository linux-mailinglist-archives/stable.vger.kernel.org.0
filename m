Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F05012274A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 10:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLQJFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 04:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbfLQJFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 04:05:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B8B42072D;
        Tue, 17 Dec 2019 09:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576573550;
        bh=j2u35ZvOuGh/FWG8sPe1wmowTjFy2Ma66k7JgIV7ffc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D91beYh9FInH4r4CtdFHpG2aeIlQUcZ6GaRPD0JoVxnwkv6kxQGmaa8ltVSmqHjH2
         8jW5x0DThwo1SHVXamilOprQ2GdXTfzQCpCFg4q9hMLbuD7CrWDqTQx0t2dkxaWy98
         bOOAbLPldeNAGl61JyAbWalVJpxq76svHv5uCKp4=
Date:   Tue, 17 Dec 2019 10:05:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
Message-ID: <20191217090548.GA2801817@kroah.com>
References: <20191216174848.701533383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 06:45:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.159 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.

There is a -rc2 out now to resolve some reported issues:
 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.159-rc2.gz

