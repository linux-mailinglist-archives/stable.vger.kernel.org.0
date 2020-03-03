Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72F91770AD
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 09:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbgCCID3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 03:03:29 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40329 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbgCCID2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 03:03:28 -0500
Received: by mail-lj1-f193.google.com with SMTP id 143so2427345ljj.7
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 00:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KqbIKcbs836wG6Yo6y8EZd9rbyi6kC17rHMJ5qkNUd0=;
        b=z8yRqL8AxErgkwMitPy14bX7MB/os/974SQCYJw77/bz+T5pL4OkURYeGAc407dJJf
         DThVxE/N2WYyP8GTVS4ecDIpJ/r/ERmC9vhJalGJunef4LYEsKCNd0uWZ17Fg8P5R4hf
         wgnR1qwEmAXxMW9vYfjJuI/2yq8i/xJCy2Y5gtv9/J+xkorHnNjTBl4ZtZ3i3iKZ5Uc0
         TH7++J2bebb9Nr7+W+rkX5cwqL2tev2uYDiYwsBHoy3FFFSRrN4MEyDIurpoNMLHNd+w
         JVoMbkxAg5MKp88pcQ/sPiuMl2gXrrlvFV/NlWgri+YgJqutmiF9RNjukTWUGGVntFS7
         sPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KqbIKcbs836wG6Yo6y8EZd9rbyi6kC17rHMJ5qkNUd0=;
        b=kZvSnvSJo5RE8LnMyZ4dMLiWkyOB23UI4xPUlRRmtDaaN+pY1SvcMBM15upCv5fX/L
         nmRjuM2WBFybxfYV2ZbTOxZB9c8okW3MRcWCxH8yCfve3YLn7vXkIXoBmcJ35MBE8qq8
         BJVcRI3ZUbVSwSanrA78Csjw4+fWaKTGsjGvQuywPf3D6bCxgVLf0B2hwZqCtu63Qxgu
         eltrbizHoqkY+vw+m7gmii4Qrd9JBGMlI+axNZ/dGGSWJfEe00Avkfrj8sCqZJMTpFQ7
         J48GkXuydyr6dTnvye4JlZKF9R/GxwivJSuj82/PY/Xq2/AtXi6UpR2iHhdLoTs+yj3h
         taSQ==
X-Gm-Message-State: ANhLgQ1RUrMAkuaaXjITgUI5gvjcEccIjk/o/VI/mrFYZ6e56sezEb6t
        6GGE80qARuWIuWmxkUrFBcrtl0dd6CPU9sVuLLAMJg==
X-Google-Smtp-Source: ADFU+vvzJ/cjCzm1guynTnQn7rdNgauoTGbH+2fVcr5Y8zj9LcIfCI1rC2H/5GERmJmKWuc2xxQMxTcpLRu6XbZUw9A=
X-Received: by 2002:a2e:8546:: with SMTP id u6mr1622427ljj.21.1583222606658;
 Tue, 03 Mar 2020 00:03:26 -0800 (PST)
MIME-Version: 1.0
References: <6CF798B4-B68B-4729-A496-2152FC032ABC@apple.com>
 <20200301031128.GK21491@sasha-vm> <2f569b8a-329f-8259-d91c-7e526e0d768c@apple.com>
In-Reply-To: <2f569b8a-329f-8259-d91c-7e526e0d768c@apple.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Tue, 3 Mar 2020 09:03:15 +0100
Message-ID: <CAKfTPtAHpJmEXzBtaeFA+PHDEzZq+0DfG+LABcTRnXCVz=6adQ@mail.gmail.com>
Subject: Re: Fixes for 4.19 stable
To:     Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Andrew Forgue <andrewf@apple.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Mar 2020 at 00:13, Vishnu Rangayyan
<vishnu.rangayyan@apple.com> wrote:
>
> Hi Sasha,
>
> Not sure of this, looks relevant but I'm no expert on this code.
> This particular change bef69dd87828 doesn't apply cleanly, need to
> backport it. I'll do that now and retest on the failing setup and report
> back.
>
> Best
> Vishnu
>
> On 2/29/20 7:11 PM, Sasha Levin wrote:
> > On Fri, Feb 28, 2020 at 12:13:54PM -0800, Vishnu Rangayyan wrote:
> >> Hi,
> >>
> >> I still see high (upto 30%) ksoftirqd cpu use with 4.19.101+ after
> >> these 2 back ports went in for 4.19.101
> >> (had all 4 backports applied earlier to our tree):
> >>
> >> commit f6783319737f28e4436a69611853a5a098cbe974 sched/fair: Fix
> >> insertion in rq->leaf_cfs_rq_list
> >> commit 5d299eabea5a251fbf66e8277704b874bbba92dc sched/fair: Add
> >> tmp_alone_branch assertion
> >>
> >> perf shows for any given ksoftirqd, with 20k-30k processes on the
> >> system with high scheduler load:
> >>  58.88%  ksoftirqd/0  [kernel.kallsyms]  [k] update_blocked_averages
> >>
> >> Can we backport these 2 also, confirmed that it fixes this behavior of
> >> ksoftirqd.
> >>
> >> commit 039ae8bcf7a5f4476f4487e6bf816885fb3fb617 upstream
> >> commit 31bc6aeaab1d1de8959b67edbed5c7a4b3cdbe7c upstream
> >
> > Do we also need bef69dd87828 ("sched/cpufreq: Move the
> > cfs_rq_util_change() call to cpufreq_update_util()") then?

This patch is not related to the 2 patches above. It removes some
spurious call to cfs_rq_util_change() and some wrong ordering but this
is a fixed overhead which is not impacted by the number of cgroups
unlike the 2 patches above. This patch will not help with the high
load of update_blocked_averages

> >
