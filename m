Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E221D11CA2E
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 11:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfLLKF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 05:05:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbfLLKF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 05:05:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0ABF20663;
        Thu, 12 Dec 2019 10:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576145126;
        bh=L2H9eq8pC7K4HaH1T4Q10TccCc43XUdeO6k9HfYmDFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDOc2ZGUt/abj6G/lXs+5IE1nNhJXDIZPphShyoCpUad4moXA7a9ydRDdwuMHnBrg
         egoxdBmP/73w0Q0dkNqwxUKNm6vQrwmGoxgQAAEY6USgr26DroMBXEOw53x4Uw3KSA
         m4jUcjrv1UHUdIMSbX9vksSBkPpnmh25NmJcZM6o=
Date:   Thu, 12 Dec 2019 11:05:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
Message-ID: <20191212100524.GC1470066@kroah.com>
References: <20191211150339.185439726@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:02:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.89 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.

I have pushed out -rc2 with a bunch of fixes for existing issues, and
some new fixes:
 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc2.gz

