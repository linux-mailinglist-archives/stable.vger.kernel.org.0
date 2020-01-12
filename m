Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8E01385D1
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 11:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbgALKWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 05:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732565AbgALKWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jan 2020 05:22:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 371DA2253D;
        Sun, 12 Jan 2020 10:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578824544;
        bh=UZzvA2p7iJMamh9HphZLb6mHUktjDOcp5TageZeULDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfAAX7gRziMju5IWVmOZLdUBYLT3N7nVMmg3yzS3QwAGryO0davXbMQOi2cI2C63V
         LN1bMVB1KIF9Icnt2kI+ASWAJsMngnzCo2o6icdq9ix0/RO4o4V7BBGjbwd6VoCBKQ
         0/cgu1P4FT9kYrIiCH3EokfjBulQ/+pWVvy9P6L0=
Date:   Sun, 12 Jan 2020 09:14:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, patches@kernelci.org,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH 4.19 00/84] 4.19.95-stable review
Message-ID: <20200112081452.GA464465@kroah.com>
References: <20200111094845.328046411@linuxfoundation.org>
 <23c3a0d1-1655-8cc2-7c96-743a47953795@roeck-us.net>
 <20200111174715.GB394778@kroah.com>
 <CA+G9fYtPeGWPGmd-R55VWwfx6QXSH=NmofVR3vPVtMZomov7qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtPeGWPGmd-R55VWwfx6QXSH=NmofVR3vPVtMZomov7qg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 12, 2020 at 10:27:16AM +0530, Naresh Kamboju wrote:
> On Sat, 11 Jan 2020 at 23:17, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > > arch/arm64/kvm/hyp/switch.c: In function 'handle_tx2_tvm':
> > > arch/arm64/kvm/hyp/switch.c:438:2: error: implicit declaration of function '__kvm_skip_instr'; did you mean 'kvm_skip_instr'?
> >
> > Thanks for this, I'll go push out a -rc2 with the offending patch
> > removed.
> 
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for testing all of these and letting me know.

greg k-h
