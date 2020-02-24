Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEC9169F51
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 08:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgBXHfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 02:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgBXHfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 02:35:21 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F91D20637;
        Mon, 24 Feb 2020 07:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582529719;
        bh=2sQxiyaVnHBqbiqLkT0UspbHsbzvDOKqOi5uxNz021I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yD8DdCxp5eIVw3tOHXKivApnAb02QeAJ5dX26QXVqkhnoG/+JouNGHZBM6FgnLRti
         hSbvQH623LjmqacFHO0gxBckQ/gXEB2FPVLgVMk/srE6w1YpPPlzdK3TtRfRWcMEQV
         L8xlvq7X4kgV2RkaMAqi15GclGmJaNSkbELPBSm0=
Date:   Mon, 24 Feb 2020 08:35:17 +0100
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
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
Message-ID: <20200224073517.GB651792@kroah.com>
References: <20200221072402.315346745@linuxfoundation.org>
 <20200223154024.GA131562@kroah.com>
 <20200223173204.GC485503@kroah.com>
 <CA+G9fYuK+qmpofdLThcTW6w2YCCM0byfoy7vvy2FGvgZoes5Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuK+qmpofdLThcTW6w2YCCM0byfoy7vvy2FGvgZoes5Pg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 24, 2020 at 10:16:48AM +0530, Naresh Kamboju wrote:
> On Sun, 23 Feb 2020 at 23:02, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > -rc3 is out:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.6-rc3.gz
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these!

greg k-h
