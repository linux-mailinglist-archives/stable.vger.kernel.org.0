Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E087210F7DB
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 07:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfLCGgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 01:36:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfLCGgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 01:36:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAABD206DF;
        Tue,  3 Dec 2019 06:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575354978;
        bh=/GoAZU5C+WGh7DVS7t7rPePLIkUl6Ze3vbDYrdSOEFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mDi3jCUUj5H/5Nvu21UWL8B8aVX/WJ51I4Dco+Z6waGjSvChEjbzuIlYYp7qsN+mB
         eZYL23faA8LyERNJhy1EJPjA4vNRii6w6BiATblWDCkYvX2QuLHlmHAxW0fYD7Zr8Z
         KdwIlGrUwgMflzDBcEq5lWiufh5CbCgu+uTjfhEk=
Date:   Tue, 3 Dec 2019 07:36:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/132] 4.4.204-stable review
Message-ID: <20191203063616.GB1771875@kroah.com>
References: <20191127202857.270233486@linuxfoundation.org>
 <CA+G9fYs-ugvOrYBZbmieSK1rQrcRh6R9cL3Vz8xK59sB3aAqyg@mail.gmail.com>
 <20191129085350.GE3584430@kroah.com>
 <4808b398-aa8f-01a9-3783-a07344944944@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4808b398-aa8f-01a9-3783-a07344944944@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 09:25:55PM -0800, Guenter Roeck wrote:
> On 11/29/19 12:53 AM, Greg Kroah-Hartman wrote:
> > On Thu, Nov 28, 2019 at 06:59:17PM +0530, Naresh Kamboju wrote:
> > > On Thu, 28 Nov 2019 at 02:04, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > > 
> > > > This is the start of the stable review cycle for the 4.4.204 release.
> > > > There are 132 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.204-rc1.gz
> > > > or in the git tree and branch at:
> > > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > 
> > > Results from Linaro’s test farm.
> > > No regressions on arm64, arm, x86_64, and i386.
> > 
> > As you all are doing run-time tests, it would be interesting to see why
> > I saw failures in the Android networking tests with this and the 4.9
> > queue, but they did not show up in your testing :(
> > 
> 
> Did you solve this problem, or am I going to get into trouble when I merge this
> release ?

This was resolved with the 4.4.205 and 4.9.205 releases.

thanks,

greg k-h
