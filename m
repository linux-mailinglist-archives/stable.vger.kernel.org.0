Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C385F1EC2A0
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 21:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgFBTWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 15:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgFBTWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 15:22:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E83206E2;
        Tue,  2 Jun 2020 19:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591125733;
        bh=p81d91/l5BttC3KDp7R/wafjUbJAQ6YdxentJwo5ND8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zVw+Z9pZ/PUadFKa5TYoL5RqexPkELROLakXNx+9TZfv5OBjwsAVZIP6FoznD9kw1
         a8/FGAGPaNx94tL/+/Db9VTklsBWoTRL6fVboJ/mGOGWzrw9II32Ga9Dvf/qhAwbL/
         UU9RNQAppwz2LFVoPGh/w3kCVniOIzUA7zJAWTx8=
Date:   Tue, 2 Jun 2020 21:22:11 +0200
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
Subject: Re: [PATCH 4.19 00/95] 4.19.126-rc1 review
Message-ID: <20200602192211.GB3874407@kroah.com>
References: <20200601174020.759151073@linuxfoundation.org>
 <OSAPR01MB2385187EB41F2DE86DCECDF6B78A0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB2385187EB41F2DE86DCECDF6B78A0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 09:17:25PM +0000, Chris Paterson wrote:
> Hi Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 01 June 2020 18:53
> > 
> > This is the start of the stable review cycle for the 4.19.126 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/boot issues seen for CIP configs for Linux 4.19.126-rc1 (47f49ba00628).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/151700942
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml
> Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=25&search=47f49b#table

Thanks for testing and letting me know.

greg k-h
