Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5992D04A6
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgLFLzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgLFLzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 06:55:50 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817ADC0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 03:55:10 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id a1so10566315ljq.3
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 03:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G4CMyYhigPWHwzhN3WOGLfE4ZJZKOFk7WA78JDlq4c4=;
        b=KX/3o9qDRXMDrxU0l03jVtHq6/ND1GkzcozZ6qEKB3NliC0AxWVk1AE6g2SBrVzTy6
         lWVqkjC4pvgvOspOck9+COQbLjIIhxriRXN1R4s4WQWLaolJstOt0LXLHuBkEhcd5vNq
         u9TPZDRUiV+yKw/zsSVA8KRUrgTzd1sRH19fqhy1uk0zCwU/AtUURSUVv5g8ye0FvMSm
         ReQp8WtMFokiw6tPCnLyA3Bzl1K6Wl+eFVAjCTCa8FbNcF+H6J6TJ3/Fzyv4OiBCnt9G
         94nFvdgal8i7grVjWuUfw3TfiWiU7jvHSv6vaNQ8pJRyFvB/5vUgQnRHqAkC4ZbN033H
         Z3xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G4CMyYhigPWHwzhN3WOGLfE4ZJZKOFk7WA78JDlq4c4=;
        b=DByKCPScu4lMXlCgpb5DzNxsse3qiI0oZn0yREAWj0lTUdcnt9Ckc82yklg9N2sSd3
         3pyC09y/zWudUi0i5Esy3AkrbfrQwpcNxq7mE4JBHLZeiEPbBZjOnVygB/5raTyiHiYE
         nZbvRQL9chSG296/UWGBUslj0sNASZe4fKLSQSgsFHGyWS/7m4a3l9fND6Iy+nVxQUmE
         nqbWscCiPeORswLfhxnuvjB3YiX7tUP1VHqPM4rWEpt/f71xTqM9za0vrvv08xPG2fpt
         2lyb8GaRdGHB6WyZM5PH5kBEMNfrv3cyD1GXv/ijtkrCwionOjQ2gRZ541NM4Cd1PrQU
         Wy+Q==
X-Gm-Message-State: AOAM532hVYQbZGeKu0Ku7r2+tXsdr7Ss32CFKJzuQKxSZb6fSmwYXotD
        TNj17cpJ5bPnx/8pd8neJTmNFho4SnTSFLOoDTy8ww==
X-Google-Smtp-Source: ABdhPJyudSx1K48bLgApvgwFfX5hoR+98k+iYYlPgLUdFMB+OesTy7TDBsW2T+RceIp53wcnBXTET4q6LTSd98RatHI=
X-Received: by 2002:a2e:9990:: with SMTP id w16mr6847780lji.111.1607255708899;
 Sun, 06 Dec 2020 03:55:08 -0800 (PST)
MIME-Version: 1.0
References: <159041776924279@kroah.com> <20200525172709.GB7427@vingu-book>
 <X8yq+7/dQADbrTTL@kroah.com> <CAKfTPtDmpYYA2nc-+d3OfT-=2kf82+3O50WGguDQ=XOXTnbZGQ@mail.gmail.com>
 <X8zDGGvVkyDGbco/@kroah.com>
In-Reply-To: <X8zDGGvVkyDGbco/@kroah.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Sun, 6 Dec 2020 12:54:57 +0100
Message-ID: <CAKfTPtBTXdVVwB+st4agBbJ3oXnB5gJ7BwvgM7=191PWvvxMLg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 6 Dec 2020 at 12:47, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sun, Dec 06, 2020 at 12:25:12PM +0100, Vincent Guittot wrote:
> > On Sun, 6 Dec 2020 at 10:56, Greg KH <gregkh@linuxfoundation.org> wrote=
:
> > >
> > > On Mon, May 25, 2020 at 07:27:09PM +0200, Vincent Guittot wrote:
> > > > Le lundi 25 mai 2020 =C3=A0 16:42:49 (+0200), gregkh@linuxfoundatio=
n.org a =C3=A9crit :
> > > > >
> > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > If someone wants it applied there, or to any other stable or long=
term
> > > > > tree, then please email the backport, including the original git =
commit
> > > > > id to <stable@vger.kernel.org>.
> > > >
> > > > This patch needs  commit
> > > >     b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some=
 more")
> > > > to be applied first. But then, it will not apply. The backport is :
> > > >
> > > > [ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upstream=
 ]
> > > >
> > > > Although not exactly identical, unthrottle_cfs_rq() and enqueue_tas=
k_fair()
> > > > are quite close and follow the same sequence for enqueuing an entit=
y in the
> > > > cfs hierarchy. Modify unthrottle_cfs_rq() to use the same pattern a=
s
> > > > enqueue_task_fair(). This fixes a problem already faced with the la=
tter and
> > > > add an optimization in the last for_each_sched_entity loop.
> > > >
> > > > Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
> > > > Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
> > > > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > > Reviewed-by: Phil Auld <pauld@redhat.com>
> > > > Reviewed-by: Ben Segall <bsegall@google.com>
> > > > Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.guitt=
ot@linaro.org
> > > > ---
> > > >  kernel/sched/fair.c | 36 ++++++++++++++++++++++++++++--------
> > > >  1 file changed, 28 insertions(+), 8 deletions(-)
> > >
> > > This patch doesn't apply to the 5.4.y tree at all.  Can someone pleas=
e
> > > provide a working backport?
> >
> > It seems that commit b34cb07dde7c ("sched/fair: Fix
> > enqueue_task_fair() warning some more") has already been applied back
> > in May. But then, I'm able to apply this patch on top of
> > v5.4.y/v5.4.81
> >
>
> What is "this patch" here?  I tried to apply 39f23ce07b93 ("sched/fair:
> Fix unthrottle_cfs_rq() for leaf_cfs_rq list") directly to the 5.4 tree
> and it too did not apply.

commit 39f23ce07b93 ("sched/fair: Fix unthrottle_cfs_rq() for
leaf_cfs_rq list") can't apply because there are several changes which
are not fixes which have been applied since v5.4 on the same code.

This patch is the backport on v5.4 of the commit 39f23ce07b93

>
> confused,
>
> greg k-h
