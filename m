Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F4016BD4C
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 10:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgBYJar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 04:30:47 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52825 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYJar (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 04:30:47 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep11so999558pjb.2;
        Tue, 25 Feb 2020 01:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MyZhA0J07pMhvS+mYmflH8Nux1ZTVIS3CbfeXxs/q5U=;
        b=N4+MzaPG7ttFxpyhsjOue5XE2mZa0zfZyP+OYAuxuQFH8VcH/mTzFKwvcP7tPSK59w
         MVCLzpkYL8UFq99TNAxc76/ewE2cUBs7Sp4Bxehz2Uc4THAVc/p/QNOXLrUHKV3aab1W
         nhtsTnyJ7S6N/kFPnpPre0Dh4I5R9Ee66XA+h3ALAL0s1rLtB/ZYzp3PXzOBO7TJxJ4/
         a+lRUk3x3vii3ZECc38QoIvaguEi/z+c/62BEEvBIsbx/fTlZFAKsPs27uW1xk4s+cDh
         Z8bg2YnAOgYEQxpbAhypklMzMLvp0Ge0CfHSmF3vdhpdSZuPRaszLZ9CSVD1iomr+Flu
         Uefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MyZhA0J07pMhvS+mYmflH8Nux1ZTVIS3CbfeXxs/q5U=;
        b=fYuf6O92UGU90x7LRHl2mU5DNGGRFq7biti5Z77jpNX4SMPymeRCo4uD9JK5u1flpa
         pH8czXr7hvSGl6cf/igrHFx1e0dfI/7WAY0Cy/egRgJUB1o/H//AGcacBwNyxA2D291I
         eA5+8mkzeOKctG/RdjiXqrXhrSYaBqMfkyOlVawC9+evgZRjYKdLnbBRhREOx3WsZuOv
         8CYShhkedQMW/aVx8IT42Qd8OmJLpr9jVRxU+rdiP8azJPn9OYCUHjr6JXvBc7WgbGeX
         DFwnwvgWMKkKp3ftRvquitXjcJUwr9JTbLVNmMmTTK5O02rCrORe7jraL+1wnzb5auiH
         WzXQ==
X-Gm-Message-State: APjAAAWcx59Pw4+uZV8SczZ+Ru02UH0Y4jbO4w1neLjkWOxUIbWjNxZF
        JRiZpHncRfz0vaTnbUhne1rN4MGuKwUVDwfpB8Fw+ob95yM=
X-Google-Smtp-Source: APXvYqy5tHg7eIVGQce8f+r6i9aXugFzJw7m5P/L2bxzmZrYdhymF709ZFzVWGjS/psEpPa+1XnwVTO6jTXvRJa4Qwc=
X-Received: by 2002:a17:90a:b10b:: with SMTP id z11mr4230996pjq.132.1582623046747;
 Tue, 25 Feb 2020 01:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20200223181832.17131-1-kristian@klausen.dk> <20200224011017.C5207208C4@mail.kernel.org>
 <e700ebdc-3dce-c151-3ea5-f7ab1e4cb07f@klausen.dk>
In-Reply-To: <e700ebdc-3dce-c151-3ea5-f7ab1e4cb07f@klausen.dk>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 25 Feb 2020 11:30:38 +0200
Message-ID: <CAHp75VcAZZ-d1BQON0ciLoCGt5=1qh4s1jLGhDdApicT+7BEGg@mail.gmail.com>
Subject: Re: [PATCH v2] platform/x86: asus-wmi: Support laptops where the
 first battery is named BATT
To:     Kristian Klausen <kristian@klausen.dk>
Cc:     Sasha Levin <sashal@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 24, 2020 at 3:15 AM Kristian Klausen <kristian@klausen.dk> wrote:
> On 24.02.2020 02.10, Sasha Levin wrote:

> > NOTE: The patch will not be queued to stable trees until it is upstream.
> >
> > How should we proceed with this patch?
>
> The patch should only be applied to the v5.4 and v5.5 trees.

I'm not sure I got this right. Do we have already this change in upstream?
I don't see it there. So, why there is no mention of the v5.6 and
current upstream in above list?

-- 
With Best Regards,
Andy Shevchenko
