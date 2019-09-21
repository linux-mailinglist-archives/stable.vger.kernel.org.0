Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F377B9C5F
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 07:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfIUFE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 01:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfIUFE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 01:04:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F3F1206B6;
        Sat, 21 Sep 2019 05:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569042297;
        bh=g1Fi6L2aYxJb/AYy0XGG6ea8KF2WG4YQ/fEGMbbhQOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OD1tsW/roGuushmNorbEGDMvkC7YgzfUXZBtohCPLW0+RDHV87W95NF9jXpN+01Il
         cDcL1Fe7yNKT7ayW2sADUQNxtoMtPLhz5VlwsZIemC4pdVCbxDoOJIDQ3RC6Xi3VDa
         tkHokMS1jxmmZIV8Nsts8L82BKgC+NInWNrKgpJ4=
Date:   Sat, 21 Sep 2019 07:04:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/21] 5.3.1-stable review
Message-ID: <20190921050455.GB991717@kroah.com>
References: <20190919214657.842130855@linuxfoundation.org>
 <5aa8e046-439a-83d4-1cb0-6bff87edfb5e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa8e046-439a-83d4-1cb0-6bff87edfb5e@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 03:17:48PM -0600, shuah wrote:
> On 9/19/19 4:03 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.1 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
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
