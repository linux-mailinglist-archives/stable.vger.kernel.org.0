Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C22D88A8E
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 12:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfHJKOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 06:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfHJKOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Aug 2019 06:14:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9B4B20B7C;
        Sat, 10 Aug 2019 10:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565432049;
        bh=NdhmUL7OlSRS8qdxL6JHqdvP10Js4TyMSDEm18zf7FI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fUJravqnp5notamOU5KFFmTgX2VfE0zsvACo+frugy1MULCoRWJI3QJb0UBej9LEy
         HNLo6lWtVDxrxRMFOXJijgrz2YzgpSe2h1VaURGrNJ0MHkSE+0Rx7CzCRiFVODQCd8
         9qA9+DLuCPKkIGti2leW0iu3oSr2I7PgW5YvNNVY=
Date:   Sat, 10 Aug 2019 12:14:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/32] 4.9.189-stable review
Message-ID: <20190810101407.GB25630@kroah.com>
References: <20190809133922.945349906@linuxfoundation.org>
 <524742dc-61b4-8738-3823-74a7f770d424@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <524742dc-61b4-8738-3823-74a7f770d424@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 02:59:11PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 8/9/19 8:45 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.189 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 11 Aug 2019 01:38:45 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.189-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing!

greg k-h
