Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2585523B32C
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 05:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgHDDJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 23:09:31 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39368 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgHDDJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 23:09:30 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 074392tG016630;
        Tue, 4 Aug 2020 05:09:02 +0200
Date:   Tue, 4 Aug 2020 05:09:02 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
Message-ID: <20200804030902.GB16602@1wt.eu>
References: <20200803121902.860751811@linuxfoundation.org>
 <20200803155820.GA160756@roeck-us.net>
 <20200803173330.GA1186998@kroah.com>
 <CAMuHMdW1Cz_JJsTmssVz_0wjX_1_EEXGOvGjygPxTkcMsbR6Lw@mail.gmail.com>
 <20200804030107.GA220454@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804030107.GA220454@roeck-us.net>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

On Mon, Aug 03, 2020 at 08:01:07PM -0700, Guenter Roeck wrote:
> I should have guessed. Bisect points to the random changes. Those are
> really causing an endless amount of trouble. I hope the problem they
> are solving is worth all that trouble.

I was exactly suggesting that we postpone them. I don't think the
problem is worth the trouble, and fixes are currently being proposed
so it might just be a matter of days.

Regards,
Willy
