Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B981BD4B9
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 08:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD2Ggp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 02:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgD2Ggo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 02:36:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BBA8206F0;
        Wed, 29 Apr 2020 06:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588142204;
        bh=N4/e8rFbJKShvQh4pRtyzPbTxIkVgTMXGfjkTkX/wsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KR+V3CfLTztAr2Ai7CKhLA9t6joaigtvxDED4TdDWUcSZenQfTmAix2ZsUCdCa/9c
         /P1eKkeA4oY83wHb+d9S7ZuDhPhXzstj6kBTmDWnfXbEE81pkz8Ex/+cTYA2JZgpLd
         FuA5Wu5V9Yf+f7xRXLkMAOK8Tr9ehd1jLa0ZvKQg=
Date:   Wed, 29 Apr 2020 08:36:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/167] 5.6.8-rc1 review
Message-ID: <20200429063640.GA2007811@kroah.com>
References: <20200428182225.451225420@linuxfoundation.org>
 <37127381-3bd6-e32c-ab2e-e0f542a3fca7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37127381-3bd6-e32c-ab2e-e0f542a3fca7@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 28, 2020 at 06:44:16PM -0600, shuah wrote:
> On 4/28/20 12:22 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.8 release.
> > There are 167 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Apr 2020 18:20:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
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
