Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4135AE534
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 16:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfD2OrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 10:47:13 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34290 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728318AbfD2OrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 10:47:13 -0400
Received: by mail-lj1-f193.google.com with SMTP id s7so6902767ljh.1
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 07:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4sxDBiGIfXC/ZiB8rBSK37wy0gqfF4x7jFrHPYHvbvA=;
        b=jxCRQIk8xd5/68/ic6ZDupRiHo0z7xsxLRb0PfkjP1kbZ9SxgCDXwTf9uUqJJ990Dj
         VHGckJD0/Q0f2eFix1OtHyOiSJQZo+Eeoxa07sSHKsOu3rWotlnHSTItFWOiltlhm9Zu
         H5mq3z0HojQmiK1VfzTQs/o6b8qYXk19zC6I9Xy6+AAO8xFoV8U1d8N8cG5b0Yz651nQ
         KdTxSuvFnIkgcloxLqLE6FK4pQbAQRlPsqU4+lsTiB+Aaipr18hnzvPvz27bSZuFqyFr
         /XkaLzZnTTrDYWXSROP9UPEBCdfJmr70CiQQ0QyPvx/DPzhfK7OK+HxkDXKlcpbd+wZd
         IlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4sxDBiGIfXC/ZiB8rBSK37wy0gqfF4x7jFrHPYHvbvA=;
        b=LjBW6ZPWGADYjTN8FtoLoR2emAzAjC5SvWNnehD/wbv5x2LTKEVV9em2xWF9dNJpIC
         D31z9UknGsMmH7i0CJ3/N3YFThx63F0sZY7N6ty0SmOkCx4DvJp4lR+qqm6w5Oo3CWIW
         dSraU0aDZkuxqRDdoaeekNj06NJxiJ2+lb2sg0QDLjBM1zIrlGV/zRqQFSTEqtmy90gb
         TtdUoN1CDJaYNT4MNgi11K+sHxagDhcNOpSSpiOGaowSpoNb9TPIj6/jJRrnWio+kEdn
         ggXMdBreNMfxQvxRzCBK5HnjtNd3KmCcA3gYwtoHxoDGIKg5BbTDt+wDfiQtI1RJ3JIu
         mQWA==
X-Gm-Message-State: APjAAAVgbsAyBwroGiug4ETervAFO28a/ztgC2EI2iSdQP8Wo6ZGYnQC
        be3w3mwfzzBLd6JzZ/19cs0+7XVQN9QnKMgf8Rqc
X-Google-Smtp-Source: APXvYqwnGM3bgmafa0PUo1+A4uuPdo7L9ALPkS2QAvxAQutzf1VOfe4H+Tvfe5KUnuBe3FLFr4zwVXZvgtYpTXAqMM0=
X-Received: by 2002:a2e:810f:: with SMTP id d15mr7819224ljg.38.1556549231239;
 Mon, 29 Apr 2019 07:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190422210041.GA21711@archlinux-i9> <CAHC9VhTtz3OA3EchaZaAeg=DxoGoz_WFdj+Mi9nd9i+cmjmuJA@mail.gmail.com>
 <20190423132926.GK17719@sasha-vm> <CAHC9VhRcdY7G_ES2VqNVpkoU=CRJkJySb3m1sFdgKJwh3JQ2oA@mail.gmail.com>
 <20190429124002.GB31371@kroah.com> <CAHC9VhQxrtYJTOj=aOL4FY=myA4ZO-rcY7TdCeFbjVnCmgOxew@mail.gmail.com>
 <20190429140906.GA7412@kroah.com>
In-Reply-To: <20190429140906.GA7412@kroah.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 29 Apr 2019 10:47:00 -0400
Message-ID: <CAHC9VhRDoYd=vfz3Sm8NKpMW_QoX7t_VohumUxU5i6AjTwCRyQ@mail.gmail.com>
Subject: Re: scripts/selinux build error in 4.14 after glibc update
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss@m4x.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 10:09 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 29, 2019 at 10:02:29AM -0400, Paul Moore wrote:
> > On Mon, Apr 29, 2019 at 8:40 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Tue, Apr 23, 2019 at 09:43:09AM -0400, Paul Moore wrote:
> > > > On Tue, Apr 23, 2019 at 9:29 AM Sasha Levin <sashal@kernel.org> wrote:
> > > > > On Mon, Apr 22, 2019 at 09:59:47PM -0400, Paul Moore wrote:
> > > > > >On Mon, Apr 22, 2019 at 5:00 PM Nathan Chancellor
> > > > > ><natechancellor@gmail.com> wrote:
> > > > > >> Hi all,
> > > > > >>
> > > > > >> After a glibc update to 2.29, my 4.14 builds started failing like so:
> > > > > >
> > > > > >...
> > > > > >
> > > > > >>   HOSTCC  scripts/selinux/genheaders/genheaders
> > > > > >> In file included from scripts/selinux/genheaders/genheaders.c:19:
> > > > > >> ./security/selinux/include/classmap.h:245:2: error: #error New address family defined, please update secclass_map.
> > > > > >>  #error New address family defined, please update secclass_map.
> > > > > >>   ^~~~~
> > > > > >
> > > > > >This is a known problem that has a fix in the selinux/next branch and
> > > > > >will be going up to Linus during the next merge window.  The fix is
> > > > > >quite small and should be relatively easy for you to backport to your
> > > > > >kernel build if you are interested; the patch can be found at the
> > > > > >archive link below:
> > > > > >
> > > > > >https://lore.kernel.org/selinux/20190225005528.28371-1-paulo@paulo.ac
> > > > >
> > > > > Why is it waiting for the next merge window? It fixes a build bug that
> > > > > people hit.
> > > >
> > > > I place a reasonably high bar on patches that I send up to Linus
> > > > outside of the merge window and I didn't feel this patch met that
> > > > criteria.  Nathan is only the second person I've seen who has
> > > > encountered this problem, the first being the original patch author.
> > > > As far as I've seen, the problem is only seen by users building older
> > > > kernels on very new userspaces (e.g. glibc v2.29 was released in
> > > > February 2019, Linux v4.14 was released in 2017); this doesn't appear
> > > > to be a large group of people and I didn't want to risk breaking the
> > > > main kernel tree during the -rcX phase for such a small group.
> > >
> > > Ugh, this breaks my local builds, I would recommend getting it to Linus
> > > sooner please.
> >
> > Well, we are at -rc7 right now and it looks like an -rc8 is unlikely
> > so the question really comes down to can/do you want to wait a week?
>
> It's a regression in the 5.1-rc tree, that is hitting people now.  Why
> do you want to have a 5.1-final that is known to be broken?

I believe I answered that in my reply to Sasha.  Can you answer the
question I asked of you above?

-- 
paul moore
www.paul-moore.com
