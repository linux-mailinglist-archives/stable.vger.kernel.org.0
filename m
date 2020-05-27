Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714951E405C
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 13:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgE0LsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 07:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgE0LsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 07:48:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B4220873;
        Wed, 27 May 2020 11:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590580091;
        bh=QV9YmA6SLCzz+5if2UqnhgkHN5mAKCnPWg4ZiKOEg/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zXCBCW6qIcmZ4Y2iFDXDiZF/+H9GK4B2LTJlVTupGlzKmpniLBXlP3UiSPNzkh6MG
         aFdXQOL73lGYFhYcFUYvqhgdHCMJ6x9cdI6/bPLvzSOIEiMwuQ0UKldTe/9C824LgV
         pkBX++0+HlwRf3kp988OaJ6czzajUPlAycy04V/Y=
Date:   Wed, 27 May 2020 13:48:09 +0200
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
Subject: Re: [PATCH 4.19 00/81] 4.19.125-rc1 review
Message-ID: <20200527114808.GA385991@kroah.com>
References: <20200526183923.108515292@linuxfoundation.org>
 <OSAPR01MB238593B39F13AA0669A5CD11B7B10@OSAPR01MB2385.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB238593B39F13AA0669A5CD11B7B10@OSAPR01MB2385.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 10:29:00AM +0000, Chris Paterson wrote:
> Good morning Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > 
> > This is the start of the stable review cycle for the 4.19.125 release.
> > There are 81 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/boot issues seen for CIP configs for Linux 4.19.125-rc1 (59438eb2aa12).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/149870026
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml
> Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=25&search=59438e#table

Great, thanks for testing two of these and letting me know.

greg k-h
