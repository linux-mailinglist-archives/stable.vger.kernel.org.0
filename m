Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDB11DC861
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 10:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgEUISp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 04:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728473AbgEUISo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 04:18:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA25207FB;
        Thu, 21 May 2020 08:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590049123;
        bh=ZLtwahDGHeue/xgjYbVBVRvTFrWv2lMvo1DjaCwGCfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MBlI+CotLeulFE3mlp2J2fsQknJCRKNh+fIMqRQKDltk7j6Z25MQ1N+dyte4F5Ssi
         floKcxFgOKmlqbjutaL1qtcPkc8ndDpp5fz5PgyMh3vevbpmXAJ0WkrOfn/gw6jmv9
         Ymb8gWaJsK78xGZ3lCrQgP844rm0IaezqT29zVf4=
Date:   Thu, 21 May 2020 10:18:41 +0200
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
Subject: Re: [PATCH 4.19 00/80] 4.19.124-rc1 review
Message-ID: <20200521081841.GA2658859@kroah.com>
References: <20200518173450.097837707@linuxfoundation.org>
 <OSAPR01MB2385550A5A777F16C743F13CB7B70@OSAPR01MB2385.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB2385550A5A777F16C743F13CB7B70@OSAPR01MB2385.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 07:49:42AM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 18 May 2020 18:36
> > 
> > This is the start of the stable review cycle for the 4.19.124 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/boot issues seen for CIP configs for Linux 4.19.124-rc1 (ff1170bc0ae9).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/147257412
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml
> Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=25&search=ff1170#table

Thanks for testing all of these and letting me know.

greg k-h
