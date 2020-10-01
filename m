Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FD627FE2B
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 13:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgJALOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 07:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgJALOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 07:14:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC3C2087D;
        Thu,  1 Oct 2020 11:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601550868;
        bh=+zAamjDJEUYPRPOKYscxJUXE5BZcELpzSwzCeDB+URQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YjhxEt9VlwaR/By+SfYp6RBZ3TdNw+qlAvC5fRUgV/JRWVJny4snm4NkRAeN3Z9hA
         SoOBUG9tZmqDOas33XqoJ8tpdbR3XqVxBu6x5G1z/ghv6rHxRdGK1P/nfPquVfuPHx
         pCfhBI4HuahIe9foWGjfKI3pNAjIth5EppYvgUTA=
Date:   Thu, 1 Oct 2020 13:14:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/245] 4.19.149-rc1 review
Message-ID: <20201001111429.GA1999687@kroah.com>
References: <20200929105946.978650816@linuxfoundation.org>
 <20200929122627.GB29097@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929122627.GB29097@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 02:26:27PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.149 release.
> > There are 245 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.149-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> 
> No problems detected by CIP testing:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/195833156
> 
> The failures are caused by boards being offline; they are not caused
> by kernel problems.

Thanks for testing two of these and letting me know.

greg k-h
