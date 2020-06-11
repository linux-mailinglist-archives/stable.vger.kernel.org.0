Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2921F6234
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgFKHWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 03:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgFKHW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 03:22:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 379202074B;
        Thu, 11 Jun 2020 07:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591860148;
        bh=xdQlhHdHT6oN5QzkaLmkf3bpGTcCZk91ChQg81VcFH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qwAAbFNRyNDudetlyVDC3lCdScW+IS4wm+KQFjmIpKDZsG63SDpbF2sDxpueEqzFS
         b4fnkS006nD9YxaTNNe1ndi7pj9M+XZUhjv6FbYkqV+Rvfkgc6ZZS1gd65KsyAVpAb
         xvDlkpOWtr1pNl9Wtm5n3oQMrbkvxBd7HB+aepPw=
Date:   Thu, 11 Jun 2020 09:22:22 +0200
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
Subject: Re: [PATCH 4.4 00/36] 4.4.227-rc2 review
Message-ID: <20200611072222.GA2645249@kroah.com>
References: <20200609190211.793882726@linuxfoundation.org>
 <OSAPR01MB23852D581ABC965E131E6EE3B7800@OSAPR01MB2385.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB23852D581ABC965E131E6EE3B7800@OSAPR01MB2385.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 06:51:15AM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 09 June 2020 20:18
> > 
> > This is the start of the stable review cycle for the 4.4.227 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/boot issues seen for CIP configs Linux 4.4.227-rc2 (61ef7e7aaf1d).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/154557183
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.4.y.yml
> Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=25&search=61ef7e#table

Thanks for testing 2 of these and letting me know.

greg k-h
