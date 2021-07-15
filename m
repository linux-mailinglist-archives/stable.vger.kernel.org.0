Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5443CA1C2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 17:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbhGOQBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 12:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239546AbhGOQBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 12:01:00 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03213C061760
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 08:58:07 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id k27so8820233edk.9
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 08:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CEb5a1maIQQgHYmKJB3wbVzZJDH16Rwjgv/JsDYzDW4=;
        b=NYmYiWqwZ7wq29hbL4QMhRiMKrd9SOlvd18wyaXqGvRAGRbzBaJthm960JE2gQPqOH
         RcKw1rkiJdrekSMIZ1VkOMQPAgyvbaVaHcSdWk6wRPQNZJ6eByaj5cC9FfJw5A5CPPIz
         vTp6sziLVcfp59AZG6byxXmy5nAIACQGJv140=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CEb5a1maIQQgHYmKJB3wbVzZJDH16Rwjgv/JsDYzDW4=;
        b=qfhtTyMHwQaKYpJNZhLSQZH2RvLB23B9C5OZ5rvyRWPuzvUNeUtq4y5Y24ojoFxL2U
         EQV4Ygw+aR55k0vr1HY4wZ6mRB40GxCGwMxf07/tZJOm38H6aB+B/EMtwQav0Z/k3/0p
         426n+bOd9whkM1FLbppabIPgXXztXJqvDFrNeHuZvnNqG54T6+gnM3YHfAWlVpNgyXi/
         57+SDL+wVcfydhEJdqJzP5jVMRLWqccacHJm+hwDwsqKZhcolSeAzS4B8xzFHZUPfYgh
         NrELgbgvkh8+dGiE1MRkK0ogqgjvo2HWMGipyOfGLHd/x8dyWEM74Rp8g9Z4nZ1Iw3Xc
         PAHw==
X-Gm-Message-State: AOAM532i94/7c9uOch5Uwj8SU/tux4ulSArR/KFcZxxo5qsOQzLRLQ6W
        ieC1pIw2O9U/wmq9ds/a7hum1tPUcY2f01nPyCPw0w==
X-Google-Smtp-Source: ABdhPJzbx5mWi4SVxmU66lSkrv7u5T0QyI6zXoCXUYV4qW+xU3i3I1P9jmNb8I7dkhiEXZ68f70jjsvNjynRj5bSSGA=
X-Received: by 2002:a50:9b06:: with SMTP id o6mr8161258edi.284.1626364685536;
 Thu, 15 Jul 2021 08:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com> <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6X2og4mzqAEwJn@dhcp22.suse.cz> <YO8DJkVzHFmPv6vz@sashalap>
In-Reply-To: <YO8DJkVzHFmPv6vz@sashalap>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 15 Jul 2021 10:57:54 -0500
Message-ID: <CAFxkdAqE0vKCyr4qFjtKmn46rHn+RJsn7m_MX6jjbN6FZcDLMA@mail.gmail.com>
Subject: Re: 5.13.2-rc and others have many not for stable
To:     Sasha Levin <sashal@kernel.org>
Cc:     Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 10:30 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, Jul 14, 2021 at 09:52:58AM +0200, Michal Hocko wrote:
> >On Tue 13-07-21 18:28:13, Andrew Morton wrote:
> >> At present this -stable
> >> promiscuity is overriding the (sometime carefully) considered decision=
s
> >> of the MM developers, and that's a bit scary.
> >
> >Not only scary, it is also a waste of precious time of those who
> >carefuly evaluate stable tree backports.
>
> I'm just as concerned with the other direction: we end up missing quite
> a lot of patches that are needed in practice, and no one is circling
> back to make sure that we have everything we need.
>

It does work both ways. For those of us maintaining a kernel for a
community distro, without an army of engineers actually paying
attention, the current stable process has fixed more bugs than it has
introduced.  But it does occasionally introduce them as well. When it
does, it is typically pretty easy to see where, as stable releases
tend to be smaller than this set was, so only a few patches in any
given subsystem or driver.  If we go back to a case where only Cc:
stable patches are selected, I suppose the logical step would be for
maintainers like me to make sure that we send a message to stable
whenever we pull a patch from upstream that fixes an actual issue that
users are seeing.  I don't have a strong objection to this, but it is
more work.

Justin

> I took a peek at SUSE's tree to see how things work there, and looking
> at the very latest mm/ commit:
>
> commit c8c7b321edcf7a7e8c22dc66e0366f72aa2390f0
> Author: Michal Koutn=C3=BD <mkoutny@suse.com>
> Date:   Tue May 4 11:12:10 2021 +0200
>
>      mm: memcontrol: fix cpuhotplug statistics flushing
>      (bsc#1185606).
>
>      suse-commit: 3bba386a33fac144abf2507554cb21552acb16af
>
> This seems to be commit a3d4c05a4474 ("mm: memcontrol: fix cpuhotplug
> statistics flushing") upstream, and I assume that it was picked because
> it fixed a real bug someone cares about.
>
> I can maybe understand that at the time that the patch was
> written/committed it didn't seem like stable@ material and thus there
> was no cc to stable.
>
> But once someone realized it needs to be backported, why weren't we told
> to take it into stable too?
>
> --
> Thanks,
> Sasha
