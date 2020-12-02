Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6B52CB6F4
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 09:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgLBIWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 03:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgLBIWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 03:22:12 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3805FC0613CF
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 00:21:32 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id q8so2104285ljc.12
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 00:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50hkyjdpOpzVKpMdbqi7m/ZX+zJIgmsLFnDXoZPSm2Q=;
        b=T//dxfbZlqYIL3B9Eymb1uVKhIvGeR7JLrgZYy06DjsBlOvJ6mN3cC7CZadr8l0Mjd
         RIjjGv0wy9lzeJO6dMZylZscEeEdhT/O2HTTbFiOpGCS8OQTkNV7OwgIu5yO4c144K0i
         qn+7aR9AVgPxwuVIl0zXn5jwHen+CmOMd81rGkQoQwAEwyQyyfkGix2tfDbY2AqJOn71
         EvMC++xCA6DO5fHEvDYY/jfO+T+8xJ+lRNAPR68y9DxYw9Pb7FEJZJ6bePXZv+kDKVmX
         zFlKYgmYsZ5EdcvnPl+ELR7P+wBbscUVc5YlUGcf1LkPmYha2B92t3WUNJEqsSWVO5Io
         AKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50hkyjdpOpzVKpMdbqi7m/ZX+zJIgmsLFnDXoZPSm2Q=;
        b=Oq8Us9bPHQVeAbeiwF6HojlIgmRWORMdXP/W0HVM2nxzBdRXghaioHXh7CePQc2Ywv
         kzL/aCNnLRYHkZ9jr1IfubQEDCcmK64CiZS88VPHEaH5u1DYW5IpGD0MBYSKAVVlOlvN
         J1zJvVgX3l5whKmz35fEEBWFuYcQmTOKZRFQVNPK135jZdfjypG5mDCCu8qh644AxM3I
         3QIKsvHxHD22iNDznafYw1XeuFtEjWMfHiRguErYUgvXEyBm162iEEqmxqzrG0mLVkzd
         ZIgX9s+qZeXsc8bo6YAr6xJI+a6ST87iQrVNC7nwpKsQ9Y2NQmH0RunkrBXDaCnJpltZ
         BFMQ==
X-Gm-Message-State: AOAM530QzNWchA9OvB/Urq7Tjsoxiec3iBcG6LK/t4sDkDaWJnzl/G0o
        8dLIcGs1dibSWmNpfvgiYZc0FdP6Pfbjl1WqAydQfg==
X-Google-Smtp-Source: ABdhPJwFAQRxGlhjQ15vSiOuaTt1Tb5IURPTrmg75yaCqmsDRNd3GYAbfNvhV/Z3rERkSzAPLYO0WaNGpwdouQgT7nA=
X-Received: by 2002:a2e:b8d0:: with SMTP id s16mr621380ljp.423.1606897290626;
 Wed, 02 Dec 2020 00:21:30 -0800 (PST)
MIME-Version: 1.0
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
 <e87e517b-7f97-66ba-4f17-718330910a7b@canonical.com> <X8dHZP78hCVlb3n9@kroah.com>
In-Reply-To: <X8dHZP78hCVlb3n9@kroah.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 2 Dec 2020 09:21:19 +0100
Message-ID: <CAKfTPtDTQsaQbB3OrAD5Q=0d5oULu6TD18+WQ1b-S05n46WeyQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>,
        Ingo Molnar <mingo@redhat.com>, Phil Auld <pauld@redhat.com>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Gavin Guo <gavin.guo@canonical.com>,
        nivedita.singhvi@canonical.com, halves@canonical.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2 Dec 2020 at 08:49, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 01, 2020 at 12:03:18PM -0300, Guilherme G. Piccoli wrote:
> > Hey Sasha, sorry to annoy again, but maybe Peter is very busy - wouldn't
> > be possible maybe to get that merged after a review from Ben or Ingo? I
> > see them in the MAINTAINERS file, specially Ben as CONFIG_CFS_BANDWIDTH
> > maintainer.
> >
> > I understand the confidence in this patch is relatively high, since it's
> > a backport from the author, right?
>
> I still want to see an ack from the maintainer please.

SCHEDULER
M: Ingo Molnar <mingo@redhat.com>
M: Peter Zijlstra <peterz@infradead.org>
M: Juri Lelli <juri.lelli@redhat.com> (SCHED_DEADLINE)
M: Vincent Guittot <vincent.guittot@linaro.org> (SCHED_NORMAL)
R: Dietmar Eggemann <dietmar.eggemann@arm.com> (SCHED_NORMAL)
R: Steven Rostedt <rostedt@goodmis.org> (SCHED_FIFO/SCHED_RR)
R: Ben Segall <bsegall@google.com> (CONFIG_CFS_BANDWIDTH)
R: Mel Gorman <mgorman@suse.de> (CONFIG_NUMA_BALANCING)
L: linux-kernel@vger.kernel.org
T: git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
S: Maintained
F: kernel/sched/
F: include/linux/sched.h
F: include/uapi/linux/sched.h
F: include/linux/wait.h
F: include/linux/preempt.h

Isn't me and Ben enough in this case ?

>
> thanks,
>
> greg k-h
