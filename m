Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F044128E1CE
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 16:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgJNOAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 10:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgJNOAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 10:00:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA7B2222A;
        Wed, 14 Oct 2020 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602684048;
        bh=eUeSKV5FeSuD28bubXBjtn9kVU9XNjj7MGMg3m98azY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YrcHihAzqaPfA10cPQwB+OX10G55juEAXtCO9eG3dWZPqolZDXQeVshuwtmg1Yez9
         mAKieRTtFO7+ay6pMpH0QKcwnBl8nPa4LoANQDFru5Gohb8KLBqTuhJ5h57V5guZAu
         vQat6T4sEuKeTGv08lhfisBhxQ4gGKU9xvkvU1dI=
Date:   Wed, 14 Oct 2020 10:00:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Dmitry Golovin <dima@golovin.in>,
        Matthias =?iso-8859-1?Q?M=E4nnich?= <maennich@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: llvm-nm and lld patches for arm32
Message-ID: <20201014140046.GQ2415204@sasha-vm>
References: <CAKwvOdnBqCT0XG298nLqE7=WvxrYJFqV6jZ8-fZX0fF67bLQBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdnBqCT0XG298nLqE7=WvxrYJFqV6jZ8-fZX0fF67bLQBQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 03:32:46PM -0700, Nick Desaulniers wrote:
>Dear Stable Maintainers,
>Please consider cherry-picking:
>
>commit fe00e50b2db8 ("ARM: 8858/1: vdso: use $(LD) instead of $(CC) to
>link VDSO")
>
>to linux-4.19.y.
>
>It cherry picks cleanly and first landed in v5.2-rc1.
>
>It allows us to more easily use ld.lld on arm32 for Android.
>
>
>Also, please consider cherry-picking:
>
>commit 29c623d64f0d ("ARM: 8939/1: kbuild: use correct nm executable")
>
>to both linux-5.4.y and linux-4.19.y.
>
>It cherry picks cleanly and first landed in v5.5-rc1.
>
>It allows us to more easily use llvm-nm on arm32 for Android.

I've queued up the patches.

>I've attached both backports as mbox files. Please let me know if it
>would be preferable in the future for me to have one email per patch
>being backported.  I tested both locally, and the patches are passing
>our presubmit testing in Android.

If the patches apply cleanly and pass your tests as-is, it's enough to
just list the commits and let us cherry pick. No need to attach the
patches to the mail.

-- 
Thanks,
Sasha
