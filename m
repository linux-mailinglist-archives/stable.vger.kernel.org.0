Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935541738E3
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 14:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgB1NvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 08:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgB1NvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 08:51:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC56F2469F;
        Fri, 28 Feb 2020 13:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582897877;
        bh=PnvV9twaI0HKd5xcbJPqqDp2lk0njkXJ6Pik+bdscuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xtj1SeVK3WTv2AMK8Z7K2qfbrVLGe3ZcG0flZs91LwtmuWBhW0u7tXjJbh0gmXp8j
         2+8Tu0VP1vOKFjBQraetMi1Z5Wppj/+IwYpB+edGFb7O+vqt0lxlk0Uw42nY62/vfC
         CQgCoTIbFdNwHrWsfl3WENHQu8NdWJlXUgKHgxNs=
Date:   Fri, 28 Feb 2020 14:51:15 +0100
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
Subject: Re: [PATCH 4.19 00/97] 4.19.107-stable review
Message-ID: <20200228135115.GA3049877@kroah.com>
References: <20200227132214.553656188@linuxfoundation.org>
 <TYAPR01MB22855734042EC30DAB547F58B7EB0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22855734042EC30DAB547F58B7EB0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 03:51:30PM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 27 February 2020 13:36
> > 
> > This is the start of the stable review cycle for the 4.19.107 release.
> > There are 97 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No issues seen for CIP configs for Linux Linux 4.19.107-rc1 (6ed3dd5c1f76).
> 
> Build/test logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/121568317
> Pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/ba32334b/trees/linux-4.19.y.yml

Thanks for testing 2 of these and letting me know.

greg k-h
