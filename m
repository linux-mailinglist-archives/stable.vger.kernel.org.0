Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 899153B749
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389447AbfFJO0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389402AbfFJO0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:26:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F8A2207E0;
        Mon, 10 Jun 2019 14:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560176774;
        bh=6NiCHKye5atumPBvboN3xElDSadPH9wlMcA9SVn5rNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PS73eHrJ5BAkWVCVfUBIazkMtKNSbcM95CK4IIZNQAL+k10UI7Vubyam1X8F2f/Jw
         eipNKLgu6/uDrywRoiKR3CRLHqmdn523FJek4ry7bgFyJukCcJwRCDDPtnJVuF5gyB
         7MMPQM4NEn9Xkq1HR/cb/3GifAuAW45maChKP59s=
Date:   Mon, 10 Jun 2019 16:26:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
Message-ID: <20190610142612.GF5937@kroah.com>
References: <20190609164127.541128197@linuxfoundation.org>
 <CA+G9fYuxGDX0pX0BROB7mJqJuCPYRshzae+cTnb_xQXEtBpgXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuxGDX0pX0BROB7mJqJuCPYRshzae+cTnb_xQXEtBpgXA@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 11:33:43AM +0530, Naresh Kamboju wrote:
> On Sun, 9 Jun 2019 at 22:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.9 release.
> > There are 70 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.9-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
