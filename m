Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42301B2361
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 11:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgDUJz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 05:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgDUJz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 05:55:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0BAC20CC7;
        Tue, 21 Apr 2020 09:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587462957;
        bh=BXcCEAkl7Od3Ux/7Tx+tbq4a/38F00dPs4wyLkKcnGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U4fxJShhB8AgmCjOeQYW+1tqZKnf2Wr2tBgyTXKwIAtIknFz6Vuftbhqkjy4V4uwn
         wm7hpogylpOSYzbLa0fgXCKXxVKFqzBfhImcsrmFFShYiOe+0dV8yIPkYSHVMX49vf
         zJbM/uArVPOuG0RvMXknkJXQm5bwTDVJ2uLJpX4s=
Date:   Tue, 21 Apr 2020 11:55:54 +0200
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
Subject: Re: [PATCH 4.19 00/40] 4.19.117-rc1 review
Message-ID: <20200421095554.GC727481@kroah.com>
References: <20200420121444.178150063@linuxfoundation.org>
 <TYAPR01MB22857D9B69F610097596174FB7D40@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22857D9B69F610097596174FB7D40@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 02:17:02PM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 20 April 2020 13:39
> > 
> > This is the start of the stable review cycle for the 4.19.117 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> No build/boot issues seen for CIP configs for Linux 4.19.117-rc1 (df86600ce713).
> 
> Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/137867597
> GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pipelines/-/blob/master/trees/linux-4.19.y.yml
> Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=25&search=df86600ce#table

Great, thanks for letting me know.

greg k-h
