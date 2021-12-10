Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D2D470BE1
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 21:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbhLJUfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 15:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242895AbhLJUfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 15:35:51 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1B5C061746;
        Fri, 10 Dec 2021 12:32:16 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id q74so23905441ybq.11;
        Fri, 10 Dec 2021 12:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u1KIaiWD0RRaY9avsVjWTL7sLAxSTbzMnnLPy0nFeRI=;
        b=Po34Hq0TwRMgrgkzDyMZXR9dSFMOfcrmrwLMpm8hGiygB4kazsqOTo53uipYq/zck0
         6iHqR2gETmZMEfFh5Gmtx0MxTlNq1bdfMMe9HiYUWzeniMD48Pk0qVHQKCgJ8LcI36Yw
         K4XjG+phtdJCvSqD6FS/EdTPEHY+QeTbwjD4OL23/OGPb1SI7Bhn/4i/QlcxAAFrW2Wv
         YG5KAxvvgOgfPj+3PzmIQgYUQlggtCbi8xymb7lynYqhCkX8tpG1z9ffXEPDRIBsTI5P
         CbUfJ9HuEGzioxMmWpb+Lg9FXwkEmyNxMhY/ujjSmPBp7kHNDMtjoivwF0BSMuUJJRLK
         JSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u1KIaiWD0RRaY9avsVjWTL7sLAxSTbzMnnLPy0nFeRI=;
        b=myQuWpKAVMTFwk3BTb5DhehP1YF3v7tn11EYDV7GydQCLLJonr1H5D7vseb/ngnNKX
         9b3hi8Ik29dTGUr1BPUpofOzew6VwmQ8gmIkCq33ATM5t4fYPXqDqOrRCMHFdX75KvCR
         wL5weyfkMP2l3DyIDP9icA7uNLYhsWjmsBrfKFLVJ+JHUcE135BPDUeIgtQBdGJGPO1M
         aSbZ3u9LBmoQbydLexU1F8yQKsawkYmoDI93U6GQrJU0UxPkokT4aVIvD+3tWY/njW9E
         qadlkbaaCNkVN9lLrdpuStpJI+/jF2ytj0Z4hJRgw9zgfkS4pTGk/zd0/0BSexlW90k+
         /Omw==
X-Gm-Message-State: AOAM530MJa7Hu546chlT9nqiqpZnAtSgXzaAGy6CLD+ssIcs3cL4iyW+
        3S79q3VR9Cyo3RDxA9HjKKyIp4lDMiocoa647zI=
X-Google-Smtp-Source: ABdhPJxr9hBCc750hqsyB5Rr4SyQthNu3A9chQlYqwQgM2pxWLSVZaq/UbPLSGkyrhGH0CDCYR6gjBVfvkuIg/Hyyww=
X-Received: by 2002:a25:1906:: with SMTP id 6mr16694348ybz.754.1639168335163;
 Fri, 10 Dec 2021 12:32:15 -0800 (PST)
MIME-Version: 1.0
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com> <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com> <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org> <YbIw1nUYJ3KlkjJQ@zn.tnic> <YbM5yR+Hy+kwmMFU@zn.tnic>
In-Reply-To: <YbM5yR+Hy+kwmMFU@zn.tnic>
From:   "Patrick J. Volkerding" <volkerdi@gmail.com>
Date:   Fri, 10 Dec 2021 14:32:38 -0600
Message-ID: <CANGBn6-sWv81czvi+_pTMm4J4X=TGUR1Jg50k6BOqcCczDwONQ@mail.gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and early
 param parsing
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mike Rapoport <rppt@kernel.org>, Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 5:28 AM Borislav Petkov <bp@alien8.de> wrote:
>
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

I applied the two revert patches to 5.15.7 (the last one won't apply
so I skipped it) and the resulting x86 32-bit kernel boots fine here
on the Thinkpad X1E that was having issues previously.

Then I tested an unpatched 5.16-rc4, which (as expected) got the boot
hang on the affected machine. Applied the three patches, and the
resulting kernel boots fine.

Take care,

Pat
