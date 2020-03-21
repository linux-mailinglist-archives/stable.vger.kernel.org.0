Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0418DE6F
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 08:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgCUHNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 03:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgCUHNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 03:13:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B60B220739;
        Sat, 21 Mar 2020 07:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584774793;
        bh=9NdQQHrfKdW++wRnCqGWLoyQpz5EEicMjB+3yJ/YsG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o4kGFv9rP9umkRC6xmoFzK5smoL43muSbEVc3JvMNGRx3aannvRA5MKjXfBnqGdya
         wemrkWp2uVNhB+Q3DC/ra6rc33KtbU9yF/I7VHFDqwtpTOkeWSXhlbhPtSMiiPZnLX
         /hbb+fjmprx41HKWDhzqJnWE19pY3aGw4kTMH73I=
Date:   Sat, 21 Mar 2020 08:13:10 +0100
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
Subject: Re: [PATCH 4.19 00/48] 4.19.112-rc1 review
Message-ID: <20200321071310.GG850676@kroah.com>
References: <20200319123902.941451241@linuxfoundation.org>
 <TYAPR01MB22854A4356027767654C9723B7F50@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22854A4356027767654C9723B7F50@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 09:01:22PM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 19 March 2020 13:04
> > 
> > This is the start of the stable review cycle for the 4.19.112 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/test issues seen for CIP configs for Linux 4.19.112-rc1 (d078cac7a422).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/128111695
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml

Great, thanks for testing two of these and letting me know.

greg k-h
