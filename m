Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ED8200AE1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732641AbgFSODY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730380AbgFSODY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 10:03:24 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2422DC06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 07:03:24 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u13so11304299iol.10
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 07:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=OIIDlfcyhq8GpxZiSZ0N5GrBiYJCNWA0YqLByMwLUao=;
        b=ThaZyjWeCYtJco9esLQ33oMp+5Ketkhn9b8NlUJFCl6IEr2ZtUCZBL/I/qb6xfJfAI
         2iVLYZUjpCiNMq3r88yCZcfSnmJhu+aTLaYqiAi88pRrCMutl9XOOJVBhBspq3+T9NGS
         yXa67HjrTXBx3fX2uWZekeqxsyjk6bx4FN6yg3UcW3qGzZq0C1BGZUjxqMUFEunQB52V
         Z3HggJVLIT7Rs/QJMCQ1JQxJ5+LLxlHn4+mOBqo9Pv6VcLo/eMR0BFZ7ZUIloFB/kIIf
         ZFNr3ZWmGPOB9ZZ9z4+tBKInim7Uxcy+yTLKxgRXKJDxxJX3q8W0i6hUieSeqvUMOTHz
         BPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=OIIDlfcyhq8GpxZiSZ0N5GrBiYJCNWA0YqLByMwLUao=;
        b=Gj3xyVtCVh3V59M5Oid1DxiZoRXrj9RTkgENarOag7FoPeE5CrcgsyPylQk7qShi1a
         4FBvT6N4HpXjBLR2xhlCcdbKC4Wdsv+PtIYVz52NKdTbyE+d5Dom3lx/IBzMq2MK6gPe
         VzAVKfGNTwVdmHJc+s5XMxKzasLgr4/JXX7JFBVOVZmc36rUd3UgWoDs2HKno7WIWzh5
         ocg1VjevkDckivejsBJNOTo92hhOVhHGtyh3qWiwETSPrFk14vcMyzjJCVzGd9GRKctb
         qOPb9rCmP5Q8j3AkbKF2RAmDBzXKJDyAp3KevP2ldkHBz//RagtXiyoX4zX35uzPOrCr
         rnJg==
X-Gm-Message-State: AOAM530+RRuJIF/i+E5zAQZ5wNZQbrv2F2IxlZ6ZqCbbItLASzvpI6n1
        tb5k6b2LCKiSAjBaCu29RYGLCH0PZP0Xk0fNTvFzTzBk
X-Google-Smtp-Source: ABdhPJwJ4g8ai+60UV93wL0APNZJ5h3gefETgGnkohCa9os78P4tXHVHiCmQOWfy9G15ExSXjXmKtHCFK7YDTnhTdAs=
X-Received: by 2002:a5e:9309:: with SMTP id k9mr4442948iom.135.1592575402356;
 Fri, 19 Jun 2020 07:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUU8mXX23JHvEGjgBtTTp_zpm++wBkAgw_Rx0T-Rajz28w@mail.gmail.com>
 <328409138.27353672.1592572038963.JavaMail.zimbra@redhat.com>
In-Reply-To: <328409138.27353672.1592572038963.JavaMail.zimbra@redhat.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 19 Jun 2020 16:03:11 +0200
Message-ID: <CA+icZUVcibK32G+9YUahD02n+yvk4DLxG9vJ6DFOJJXTYoMDQA@mail.gmail.com>
Subject: Re: PASS: Test report for kernel 5.7.4-1d8b8c5.cki (stable-queue)
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Yi Chen <yiche@redhat.com>, Jianwen Ji <jiji@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 3:07 PM Veronika Kabatova <vkabatov@redhat.com> wrote:
>
>
>
> ----- Original Message -----
> > From: "Sedat Dilek" <sedat.dilek@gmail.com>
> > To: "Yi Chen" <yiche@redhat.com>, "Jianwen Ji" <jiji@redhat.com>, "Hangbin Liu" <haliu@redhat.com>, "Ondrej Moris"
> > <omoris@redhat.com>, "Ondrej Mosnacek" <omosnace@redhat.com>
> > Cc: "CKI Project" <cki-project@redhat.com>, "Linux Stable maillist" <stable@vger.kernel.org>
> > Sent: Friday, June 19, 2020 1:48:51 PM
> > Subject: Re: PASS: Test report for kernel 5.7.4-1d8b8c5.cki (stable-queue)
> >
> > Hi CKI maintainers,
> >
> > thanks for doing automated tests.
> >
> > I am interested in a report of currently released Linux v5.7.5-rc1
> > before doing my testing with Clang's Integrated Assembly on
> > Debian/testing AMD64.
> >
> > Is there a browsable URL you can give me where I can see if AMD64
> > (x86-64) tests have passed OK?
> >
> > Or is it "Be patient and wait".
> >
>
> Hi Sedat,
>
> thanks for the interest in our testing! The testing for v5.7.5-rc1 is
> currently still running. The x86_64 tests that had the chance to run so
> far all passed but you'll have to wait a few hours to get the complete
> results.
>
> We're planning a public web dashboard so in the future you should be able
> to follow the results there instead of having to wait for test run
> completion, but it will take us a few more months to get that ready.
>
>

Sounds like a melody to me.

Thanks.

- Sedat -

> Veronika
>
> > Thanks.
> >
> > Regards,
> > - Sedat -
> >
> > [1]
> > https://git.kernel.org/pub/scm/public-inbox/vger.kernel.org/stable/0.git/commit/?id=2009b13ce33bf5a474ccdda991559e39712862c8
> >
> >
>
