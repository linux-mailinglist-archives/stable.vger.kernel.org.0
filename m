Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664091C51B3
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 11:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgEEJRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 05:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgEEJRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 05:17:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48CE206B8;
        Tue,  5 May 2020 09:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588670274;
        bh=NZoNRXSFkcOT6OMSAqjQZRa+qOXkO0M0eIUQ79Qkg6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vjmKFXWVY2Yjd6q53JJTdpipVgepxcoC3b8Wq/CHpnLgB6g6AZls9NwDyLax4lRTH
         NXuhClfObJms4QWEqp2mT/j3m7eHqQlYGKmMfW2t0H9qnaSxcCErcD4K1YLAlkY0N0
         PL89zHvoncrueJOoljOZ8vkDbTZn0aMjox8Kbviw=
Date:   Tue, 5 May 2020 11:17:51 +0200
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
Subject: Re: [PATCH 4.19 00/37] 4.19.121-rc1 review
Message-ID: <20200505091751.GA4172718@kroah.com>
References: <20200504165448.264746645@linuxfoundation.org>
 <OSAPR01MB23852E6BD6C72252CA326927B7A70@OSAPR01MB2385.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB23852E6BD6C72252CA326927B7A70@OSAPR01MB2385.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 05, 2020 at 07:42:23AM +0000, Chris Paterson wrote:
> Hi Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 04 May 2020 18:57
> > 
> > This is the start of the stable review cycle for the 4.19.121 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/boot issues seen for CIP configs for Linux 4.19.121-rc1 (2e3613309d93).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/142506752
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml
> Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=25&search=2e3613#table

Thanks for testing two of these and letting me know.

greg k-h
