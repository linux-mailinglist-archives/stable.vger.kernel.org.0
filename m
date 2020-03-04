Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27052178A9E
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 07:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgCDGeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 01:34:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgCDGeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 01:34:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F031214D8;
        Wed,  4 Mar 2020 06:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583303662;
        bh=0bFMruGHjDl4u/PXiAxJFCNMzIY5qx/8e+NPtVZeCmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xal/kcy/vHVzE/YjNCxpbZYWzKVEybp+HviqChR5PGSk3q0YZVwLb2LlKO9W6dEgD
         aJ/u7hTJy928QrqevwzYCLqhZAZobwhlpIEtGtjAPgOvCbAdg5YLVYQNkff8o9eD9C
         tvbROWjDxDchtgR0lVEwXTDHnGF6Qt6cLd378jm0=
Date:   Wed, 4 Mar 2020 07:34:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
Message-ID: <20200304063419.GB1202498@kroah.com>
References: <20200303174304.593872177@linuxfoundation.org>
 <925b1535-00ef-5583-8119-3c9fd50cd6e8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <925b1535-00ef-5583-8119-3c9fd50cd6e8@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 04:01:34PM -0700, shuah wrote:
> On 3/3/20 10:41 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.8 release.
> > There are 176 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.8-rc1.gz
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

Great, thanks for testing these and letting me know.

greg k-h
