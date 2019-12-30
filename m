Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E89512CF9A
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 12:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfL3Lee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 06:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbfL3Lee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 06:34:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBB3620730;
        Mon, 30 Dec 2019 11:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577705674;
        bh=90lEMuP09iwuXMSV8Oyzmx6ab/XfA4IdZZTwHmBqXq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TdTm9hbx30s7IsdNew/r7G45Ykt7FhutRumccAZgxhAn+jvnR51IhhiaD3Fi4067G
         jVRQXSjHwcIBZKVGwnQTCsxLQIdi3jk/8dL3NnuD2A+lqRoEcYxkbxwE5JVKfZ+R4k
         1F+fqV1m3PZMR5JFw+XGo8sFlHoOmowvczHitytE=
Date:   Mon, 30 Dec 2019 12:32:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191230113204.GB884080@kroah.com>
References: <20191229172702.393141737@linuxfoundation.org>
 <c61bc847-9e64-07da-169a-67964a870b12@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c61bc847-9e64-07da-169a-67964a870b12@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 07:18:53PM -0700, shuah wrote:
> On 12/29/19 10:20 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.7 release.
> > There are 434 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 31 Dec 2019 17:25:52 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.7-rc1.gz
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

Thanks for testing all 3 of these and letting me know.

greg k-h
