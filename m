Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC99A4E06A
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 08:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfFUGOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 02:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfFUGOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 02:14:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83C402083B;
        Fri, 21 Jun 2019 06:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561097656;
        bh=W3P2N40BA3IoKdInbXSdAz9w2dLwY7prCzcWQY0x7R4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qix5qPU2/d2Qk8O4VkgxdIytZEofT4D32J8Nvb0rPVrhsD1mqMXIT7vVtEhrO8aiY
         29QYxn+a8LOQhuuVybkcpDFuqRrWsnKOzPJM6f/tkMnYNfNH784+1GZR7wkEidforI
         AXlaxPkMFhb2LnZ1RcUwAD48G7Pi9zu4irWm4Qvw=
Date:   Fri, 21 Jun 2019 08:14:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiunn Chang <c0d1n61at3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/98] 5.1.13-stable review
Message-ID: <20190621061413.GA28816@kroah.com>
References: <20190620174349.443386789@linuxfoundation.org>
 <20190620234839.4f4aiczjjssfn2fg@rYz3n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620234839.4f4aiczjjssfn2fg@rYz3n>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 06:48:40PM -0500, Jiunn Chang wrote:
> On Thu, Jun 20, 2019 at 07:56:27PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.13 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Compiled and booted.  No regressions on x86_64.

thanks for testing!
