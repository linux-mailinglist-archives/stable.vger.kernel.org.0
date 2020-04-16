Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05B31AB63F
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390358AbgDPDbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390005AbgDPDbC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:31:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63055206F9;
        Thu, 16 Apr 2020 03:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587007861;
        bh=TKWZDJhAW31YA2vn64CercISnHyFznQPi1cg1F/Y4Q8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k0pDqTrSkYapj1OM5Yx4rGj1CnjZfXFrrWCDpPi61LGqxADwQOqxLStJKDq/PWBoC
         FQiskKyLZmLmkf9YmRhR3Hbw2anhbFfekcjGI23SbkEWs0r1R+EDU7qNuRIYqvScPm
         ckRrbsH56sJs4rWXhgq01nBPNAAGql8be2gxhzZs=
Date:   Wed, 15 Apr 2020 23:31:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        kbuild test robot <lkp@intel.com>,
        cros-kernel-buildreports@googlegroups.com, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [chrome-os:chromeos-4.19 21350/21402]
 drivers/misc/echo/echo.c:384:27: error: equality comparison with extraneous
 parentheses
Message-ID: <20200416033100.GH1068@sasha-vm>
References: <202004150637.9F62YI28%lkp@intel.com>
 <20200415002618.GB19509@ubuntu-s3-xlarge-x86>
 <CABXOdTd-TSKR+x4ALQXAD9VGxd4sQCCVC9hzdGamyUr-ndBJ+w@mail.gmail.com>
 <CAKwvOdnOuMcjzsqTt2aVtoiKN3L9zOONGX-4BJgRWedeWspWTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdnOuMcjzsqTt2aVtoiKN3L9zOONGX-4BJgRWedeWspWTA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 10:51:37AM -0700, Nick Desaulniers wrote:
>On Tue, Apr 14, 2020 at 5:56 PM 'Guenter Roeck' via Clang Built Linux
><clang-built-linux@googlegroups.com> wrote:
>>
>> On Tue, Apr 14, 2020 at 5:26 PM Nathan Chancellor
>> <natechancellor@gmail.com> wrote:
>> >
>> > Hi all,
>> >
>> > Sorry for yet another convergeance on this commit... :/ hopefully this
>> > does not continue for much longer. None of the warnings are obviously
>> > caused by the patch below.
>>> Fixed by commit 85dc2c65e6c9 ("misc: echo: Remove unnecessary
>>> parentheses and simplify check for zero").
>> >
>> No worries.
>>
>> I noticed that the problems are pretty much all fixed in the upstream
>> kernel. I just wasn't sure if it would be worthwhile sending a request
>> to stable@ to have them applied to 4.19.y (and if necessary 5.4.y).
>> Any suggestions ?
>
>We should strive to be warning free on stable.  Thanks for identifying
>the fix Nathan.
>
>Greg, Sasha,
>Would you please cherry pick 85dc2c65e6c9 to 4.19.y, 4.14.y, 4.9.y,
>and 4.4.y (maybe 3.18, didn't check that one)? It applies cleanly and
>is a trivial fix for a warning that landed in v4.20-rc1.

I'll grab it, but could we please look into disabling some clang
warnings?

I understand warnings that might warn us about dangerous code, but this
reads to me like something checkpatch might complain about...

-- 
Thanks,
Sasha
