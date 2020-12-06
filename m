Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526B12D0353
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgLFL0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLFL0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 06:26:05 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50930C0613D1
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 03:25:25 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id o24so11858152ljj.6
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 03:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2/g46V4V/x56zJEluo1Ml8ocCr4fqKEQfP04GtM99tA=;
        b=KlSSFy5rh6HzZIS9R7olknMtq8dl9+hGYMpJaXZ/jBCAjuB/KUSHKnO4BTOSgT96rc
         MVkUnvoA8+p+SyONWJtWBtnmBR5HAxQtxKhYUqUxXY2aBp9GezVDRRHzHB8RE0whGv41
         QOX9m0aSauXMX6BF1jtn+u3uyveGFGDBrqzC8d69mP/RbgMGOB5tcWgtdWNDtyAWXqPA
         A7tNdomZrxqc3OkalvelBwPpBU92KDDZU5rwDsBzMAD+Hz8oUzVwTxCGoitVc+mfliuL
         VB/rNKyoyxpED6Nx09IvzJ8vFUl5NmRjyganUFcfDffEZ5ppUnLrjmpn1s5hW0DYbREX
         HZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2/g46V4V/x56zJEluo1Ml8ocCr4fqKEQfP04GtM99tA=;
        b=rB2iX5nLbI9S3u2+q+fbPiazTOQZKj3uskoOX67XIg0J+sgF1WO8D7duoppLUw+PQc
         JZVBqBIFbULoluwyiMuhHGMwNlF8FYULcl7sC+tE8A2GiHSqak4seATURpz/DSB0lOrS
         G2A6EJxOfxcB3zuOBoL0yfQ2DClaGKYDQhy6xaK+3rRpTcAaoOGLGAPBi27pwMZfDEbz
         cNyku59DbIoXeLJZzWx1jtHIEj2Cx30KTZZ7MJ+TUqJqdg4Fi35GFuXyGfeCecRIbXmT
         DEp+RUF3KrdjKnXWxrV73p2jHk1778N2h6gAp4VFZzfJ5R7juvcBh7efGHkLtyzgEKip
         Lisw==
X-Gm-Message-State: AOAM530F7hIgB+9tXMG2e5i3e99dtZ7ALW48yPXnNLZk+vEP4alToHyq
        grtM0SKe1+dp18fOBEeBZc9kpbBGsEVvt+gNM2nsCZpnk+shuw==
X-Google-Smtp-Source: ABdhPJwngp7EL83zeCN81bhaBVxNOA+aLurX/hrMmp0KswXbhGWuOcEql0NmDf89+D/aYe6JHucolQvdljMx9CfF5hU=
X-Received: by 2002:a2e:b8d0:: with SMTP id s16mr6726247ljp.423.1607253923637;
 Sun, 06 Dec 2020 03:25:23 -0800 (PST)
MIME-Version: 1.0
References: <159041776924279@kroah.com> <20200525172709.GB7427@vingu-book> <X8yq+7/dQADbrTTL@kroah.com>
In-Reply-To: <X8yq+7/dQADbrTTL@kroah.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Sun, 6 Dec 2020 12:25:12 +0100
Message-ID: <CAKfTPtDmpYYA2nc-+d3OfT-=2kf82+3O50WGguDQ=XOXTnbZGQ@mail.gmail.com>
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

On Sun, 6 Dec 2020 at 10:56, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, May 25, 2020 at 07:27:09PM +0200, Vincent Guittot wrote:
> > Le lundi 25 mai 2020 =C3=A0 16:42:49 (+0200), gregkh@linuxfoundation.or=
g a =C3=A9crit :
> > >
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git comm=
it
> > > id to <stable@vger.kernel.org>.
> >
> > This patch needs  commit
> >     b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some mor=
e")
> > to be applied first. But then, it will not apply. The backport is :
> >
> > [ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upstream ]
> >
> > Although not exactly identical, unthrottle_cfs_rq() and enqueue_task_fa=
ir()
> > are quite close and follow the same sequence for enqueuing an entity in=
 the
> > cfs hierarchy. Modify unthrottle_cfs_rq() to use the same pattern as
> > enqueue_task_fair(). This fixes a problem already faced with the latter=
 and
> > add an optimization in the last for_each_sched_entity loop.
> >
> > Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
> > Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
> > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Reviewed-by: Phil Auld <pauld@redhat.com>
> > Reviewed-by: Ben Segall <bsegall@google.com>
> > Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.guittot@l=
inaro.org
> > ---
> >  kernel/sched/fair.c | 36 ++++++++++++++++++++++++++++--------
> >  1 file changed, 28 insertions(+), 8 deletions(-)
>
> This patch doesn't apply to the 5.4.y tree at all.  Can someone please
> provide a working backport?

It seems that commit b34cb07dde7c ("sched/fair: Fix
enqueue_task_fair() warning some more") has already been applied back
in May. But then, I'm able to apply this patch on top of
v5.4.y/v5.4.81

Thanks

>
> thanks,
>
> greg k-h
