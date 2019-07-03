Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7448B5EF34
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 00:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfGCWkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 18:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbfGCWkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 18:40:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD1F321882;
        Wed,  3 Jul 2019 22:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562193637;
        bh=U9X3r+hqsa10CCFfjW88iGHBTrrTWT3UO69xN2SMbp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eNxNtYN95/L0iA8jEcSa+CvN+6YeuVe/MX4WRs/W8jLe3Fl0hjX+6nA8bNmjmMXuL
         yOzs3GfvM2wAvKkF2pkXrDGwVw99H+B/+JIhER/e7WWgv4rpD1sc/h3cNhqGme8vDv
         +mtlgTl+cPmluI9XJO3p5zlxAZSrmzElejETFvvY=
Date:   Wed, 3 Jul 2019 18:40:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "4.4.y backports" <stable@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>
Subject: Re: [STABLE-4.9] proposed backports
Message-ID: <20190703224035.GB10104@sasha-vm>
References: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
 <CAK8P3a3M7cuxPeoZrNKaQGayg-Q6-UH+JEN4gsMDNxa9SWBpUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAK8P3a3M7cuxPeoZrNKaQGayg-Q6-UH+JEN4gsMDNxa9SWBpUw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 10:31:51PM +0200, Arnd Bergmann wrote:
>On Wed, Jul 3, 2019 at 10:17 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> I looked at the kernelci.org output for 4.4.y and found a couple of
>> patches that need to be applied here:
>
>Here is a similar list for 4.9, from
>https://kernelci.org/build/stable-rc/branch/linux-4.9.y/kernel/v4.9.184-66-g79155cd391a8/
>
>8535f2ba0a9b ("MIPS: math-emu: do not use bools for arithmetic")
>02eec6c9fc0c ("MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()")
>173a3efd3edb ("bug.h: work around GCC PR82365 in BUG()")
>993dc737c099 ("mfd: omap-usb-tll: Fix register offsets")
>5464d03d9260 ("ARC: fix allnoconfig build warning")

I've queued all of these up, thanks!

--
Thanks,
Sasha
