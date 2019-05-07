Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CC81642E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 15:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEGNFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 09:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfEGNFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 09:05:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DE4620578;
        Tue,  7 May 2019 13:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557234301;
        bh=U5Njy+cgqsa5JZNyf0k1GwtrQUuBB14C8uSm1z6PB1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S4PPh6vW6IRWvqmcRMO2RFQa2elrfZEnK/cxHetinJ6BKznqMzk88waQVQgdPxZ2j
         lNA8+d5snlLSzi22QVBf02Ad4J/F53ljAlCh2tHmd0pSN5JaaG9k35+EnOMy4HAFFn
         7KmtUT8pj2cEQU7x//aGDdO3C3C5PO3LZxoTSKXc=
Date:   Tue, 7 May 2019 15:04:59 +0200
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
Subject: Re: [PATCH 5.0 000/122] 5.0.14-stable review
Message-ID: <20190507130459.GB17237@kroah.com>
References: <20190506143054.670334917@linuxfoundation.org>
 <CA+G9fYsQhu8=23c0zNPKuDxOxJuwCesNYZikEtMztUBYy30u1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsQhu8=23c0zNPKuDxOxJuwCesNYZikEtMztUBYy30u1w@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 12:48:45PM +0530, Naresh Kamboju wrote:
> On Mon, 6 May 2019 at 20:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.0.14 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed 08 May 2019 02:29:09 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.14-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for testing all of these and letting me know.

greg k-h
