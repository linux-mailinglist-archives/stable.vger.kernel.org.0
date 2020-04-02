Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D315C19C1D2
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388274AbgDBNLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 09:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732262AbgDBNLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 09:11:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E58206E9;
        Thu,  2 Apr 2020 13:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585833078;
        bh=rrFl5xQKRZR2PkQNEwtH4MOruQArTRofxhl376m8Xvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nW5CCyTn4oSSyBV1cr38N8syGO4TOJpu0u6w8xLr0FJqEcprAKL3PTU3z+SkqlReT
         ywzNQwrbYneeYIcJ+wZgxTPTDQ2DPU5ZtRx82pVz3wxzDsvRgQ+GM0fn98Ww2DAQFK
         p+JEFd3UfE8s21ffSvqGmbNVHC+tJxAujjXYlaXk=
Date:   Thu, 2 Apr 2020 15:11:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/116] 4.19.114-rc1 review
Message-ID: <20200402131115.GB2891655@kroah.com>
References: <20200401161542.669484650@linuxfoundation.org>
 <TYAPR01MB22855DF740F7C9D9493D49EFB7C90@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22855DF740F7C9D9493D49EFB7C90@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 08:15:37PM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 01 April 2020 17:16
> > 
> > This is the start of the stable review cycle for the 4.19.114 release.
> > There are 116 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/boot issues seen for CIP configs for Linux 4.19.114-rc1 (558d25f4fc65).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/131909855
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml

Thanks for testing 2 of these and letting me know.

greg k-h
