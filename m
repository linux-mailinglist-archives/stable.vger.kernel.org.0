Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6E470B95
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 21:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344100AbhLJUOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 15:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344092AbhLJUOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 15:14:50 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55780C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 12:11:15 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id r26so14715249oiw.5
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 12:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=KOuxIJMKNYTeFBZJypgba4fX+/Q0qIYXKhuuL8rsgx0=;
        b=jVoZIrcMIhcs34MqmEu4ybtJ5mLwAIvoFS0tyZsRHN4vdJAK/w845YZOVWqDs0cTJ9
         zyZqSqx4fdy9fgwK5vH4S+kbFps3bK2u+/N34wWhw5m9GiKK5/JsNEvB5noC2KjZCY3F
         Xqb+ha3f/RuGPuLBdlIDA3m2rXEfI0QOkqwmn4Iil6ZoshZlDPnAMQhpGISk2HbeumEX
         Unit1NJWJd3ryBpOJKu5EMDpLo/4/Cjl3i6TCaOHcWmh0GamQpWIXnzjtmbU89W+c+nt
         0x68acITGXIkgSXRJkuzZUwV6BTrVCDCYMNJTDKK/9bWdlX+i20vygzsV62Qz14DvYYN
         Y6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=KOuxIJMKNYTeFBZJypgba4fX+/Q0qIYXKhuuL8rsgx0=;
        b=LP4cXfscDiQdvRZV1yyMPf7eCtfxpdTuFwsbU4Q97fvLuVwJR+83DzD7eP7cqZuEUl
         CcUMRXR0aikxqV3LJP20eIpPitxiiN1EipRyElsuewTuogfgv3FtPLe2fvwDUlaULX0A
         yav3jkIDytFStv4YyI1lH8++y4ijDB99K/ReyL6ZJYrb9OCVCtuo58F+vyaF1M4kXG6a
         Id9CLClmX0TLLjetoHeUaIAP/cenQQ3Qq+QTUFtt01Nma7vz4y2QSGwTAWEvj9yi8WZu
         5R7WI0BO6nKEz0DpijO9VgilX1qVDwMseykZ5APZr4EadjsGtduvHmEm6p465r1lc95m
         g8hg==
X-Gm-Message-State: AOAM532fCiPkrGv75Nc+TZAV/vn4PGtwCKvBJc7Jv5bm49Iw+kqLVytZ
        HHcMoiRJjr/CyfFCWNJigh2VZw==
X-Google-Smtp-Source: ABdhPJyii/gnYmnJibARTLGKVefuQ1oitr4zcIVcaAzq7IipapeLfzuP8rfZ9812r9rqo2jWSqft+g==
X-Received: by 2002:a54:480b:: with SMTP id j11mr14297800oij.102.1639167074440;
        Fri, 10 Dec 2021 12:11:14 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id f20sm991153oiw.48.2021.12.10.12.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 12:11:14 -0800 (PST)
Date:   Fri, 10 Dec 2021 12:11:02 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Borislav Petkov <bp@alien8.de>
cc:     Mike Rapoport <rppt@kernel.org>, Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org,
        Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
In-Reply-To: <YbM5yR+Hy+kwmMFU@zn.tnic>
Message-ID: <297f4912-907-bb45-75df-a030b0d88a8e@google.com>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2> <20211209143810.452527-1-jdorminy@redhat.com> <YbIeYIM6JEBgO3tG@zn.tnic> <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com> <YbIgsO/7oQW9h6wv@zn.tnic> <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic> <YbM5yR+Hy+kwmMFU@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Dec 2021, Borislav Petkov wrote:
> On Thu, Dec 09, 2021 at 05:37:42PM +0100, Borislav Petkov wrote:
> > Whatever we do, it needs to be tested by all folks on Cc who already
> > reported regressions, i.e., Anjaneya, Hugh, John and Patrick.
> 
> Ok, Mike is busy so here are some patches for testing:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=rc4-boot
> 
> I'd appreciate it if folks who reported an issue, verify those.
> 
> The first two are reverts which should address the issues with mem=
> folks have reported. And the last one should address Anjaneya's issue.
> 
> I guess doing it the way as Mike suggested is cleaner/better.

Yes, mem= works fine for me, on both machines, 64-bit and 32-bit,
thanks; but I'm not exercising the troublesome EFI case at all.

Hugh
