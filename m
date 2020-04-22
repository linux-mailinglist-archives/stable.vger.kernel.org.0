Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B544E1B4569
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 14:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgDVMvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 08:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgDVMvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 08:51:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87E9320857;
        Wed, 22 Apr 2020 12:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587559910;
        bh=SQkryVGgqoUzY3aJvT8Gf/kltSUg9byJ5NlefWiVwG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QNKC+XKcszxrVfeKtalGm+ZbpxJ2JzzPkYK86b1m0xgOpypbG7OUXih/YGp1MOHDD
         nLxoz1dKTQ9kEBGqoRj1++8cr6ub/J6Uzc8Y7NtfndEoSTPXaoN076qHyoKGY8Wv/b
         PakdJLJ4IZAY0JIvab9iJ1+oIsMBCc6TVNLNMHzk=
Date:   Wed, 22 Apr 2020 14:51:47 +0200
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
Subject: Re: [PATCH 4.19 00/64] 4.19.118-rc1 review
Message-ID: <20200422125147.GA3153333@kroah.com>
References: <20200422095008.799686511@linuxfoundation.org>
 <TYAPR01MB22852052125D7E1B036BE8AAB7D20@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22852052125D7E1B036BE8AAB7D20@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 11:10:58AM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 22 April 2020 10:57
> > 
> > This is the start of the stable review cycle for the 4.19.118 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/boot issues seen for CIP configs for Linux 4.19.118-rc1 (b5f03cd61ab6).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/138626535
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml
> Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=25&search=b5f03cd61#table

Thanks for testing 2 of these and letting me know.

greg k-h
