Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BD4471344
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 11:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhLKKOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 05:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhLKKOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Dec 2021 05:14:52 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC00C061714;
        Sat, 11 Dec 2021 02:14:52 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A66031EC04E4;
        Sat, 11 Dec 2021 11:14:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639217686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2iIoi3GbjEvxGrP+g9gYZi7LJf2Z+uyl9CUzlFsM1mI=;
        b=NC7JdP6mkvLQBpd4eGHEb6l2BMEr3U7UqpRyDsYvH43zUiJ1UPiXGo97dsYW5XP7bhiy7z
        1HRChiIiOwpPB7v9uWR91VJ5mLNIFM1GehlcGs8fJKMMcLeOJSO3QyZpTPovh+mD9tbywe
        oVsT8eYLS4doMLEdP4ZmAgodrWq0TFI=
Date:   Sat, 11 Dec 2021 11:14:47 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Hugh Dickins <hughd@google.com>
Cc:     Mike Rapoport <rppt@kernel.org>, Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbR6FzLIp2GjeOQi@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic>
 <YbM5yR+Hy+kwmMFU@zn.tnic>
 <297f4912-907-bb45-75df-a030b0d88a8e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <297f4912-907-bb45-75df-a030b0d88a8e@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 12:11:02PM -0800, Hugh Dickins wrote:
> Yes, mem= works fine for me, on both machines, 64-bit and 32-bit,
> thanks;

Thanks!

> but I'm not exercising the troublesome EFI case at all.

Yeah, I added some debug printks in a VM yesterday to confirm the
ordering. But will give Anjaneya some more time to verify, before I
queue them next week.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
