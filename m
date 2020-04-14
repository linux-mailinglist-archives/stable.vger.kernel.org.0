Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09021A75DD
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436533AbgDNIVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 04:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407134AbgDNIVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 04:21:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63F85206E9;
        Tue, 14 Apr 2020 08:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586852459;
        bh=e+ZqgmSTFSQ0U9tWAfWcVUMwKtjBxt3DVUkjfLMMDi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hQv1B8fjWImvoLZH44NSpxFeTCnEsrhBsayZ+G0WdaW7li+xjRS4+zr2H3F9Waohu
         ItY4ip7UExf6lRubEf66/EeduApt86EesesHn36CEB6boXuPk+IvHf481wQgkb5FWz
         XEalWVo/CBzrfZLMDZfvo5ADqWOh9q5GhhOkn0P0=
Date:   Tue, 14 Apr 2020 10:20:57 +0200
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
Subject: Re: [PATCH 4.19 00/54] 4.19.115-rc1 review
Message-ID: <20200414082057.GC4149624@kroah.com>
References: <20200411115508.284500414@linuxfoundation.org>
 <OSBPR01MB228027C12DBA445E6AFF69F3B7DD0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB228027C12DBA445E6AFF69F3B7DD0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 07:42:37PM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 11 April 2020 13:09
> > 
> > This is the start of the stable review cycle for the 4.19.115 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> > Anything received after that time might be too late.
> 
> No build/boot issues seen for CIP configs for Linux 4.19.115-rc1 (3b903e5affcf).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/134988024
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml
> 
> Kind regards, Chris

Thanks for  testing two of these and letting me know.

greg k-h
