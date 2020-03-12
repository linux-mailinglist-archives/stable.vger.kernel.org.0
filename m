Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69021828EA
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 07:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387906AbgCLGVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 02:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387848AbgCLGVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 02:21:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF9C20663;
        Thu, 12 Mar 2020 06:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583994097;
        bh=OJrCHrdfLh0u9qAZeXo2exlLcdkkmSp/mJ+tXwxrGhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QrX7Wyd8G/9rr5b5vvcFaACZT6DGPMcN9Ma9E/F1nWUF8daPCG5dq/QMfKq+RKA88
         hJlikjJFTms+1V5HiU2xE74uRg14K6HlojEF9WAzVd/Js4rB1ILE6IUpI+ew10BkyX
         crENqy4jESZMCjiwLpl03FAX6yqvfVcO0/O6rYis=
Date:   Thu, 12 Mar 2020 07:21:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/126] 4.14.173-stable review
Message-ID: <20200312062135.GA4128239@kroah.com>
References: <20200310124203.704193207@linuxfoundation.org>
 <20200311131135.GA3856613@kroah.com>
 <b9917046-393a-0314-0836-61003fd3d8e8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9917046-393a-0314-0836-61003fd3d8e8@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 01:39:44PM -0600, shuah wrote:
> On 3/11/20 7:11 AM, Greg Kroah-Hartman wrote:
> > On Tue, Mar 10, 2020 at 01:40:21PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.14.173 release.
> > > There are 126 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 12 Mar 2020 12:41:42 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > > and the diffstat can be found below.
> > 
> > I have pushed out a -rc2 release to resolve a reported KVM problem now.
> >   	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc2.gz
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> All clear now on rc2. The kvm problem is gone.

Wonderful, thanks for testing and letting me know.

greg k-h
