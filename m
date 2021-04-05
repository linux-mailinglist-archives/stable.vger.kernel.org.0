Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260C4353AEB
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 03:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhDEBlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Apr 2021 21:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhDEBlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Apr 2021 21:41:05 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236FEC061756
        for <stable@vger.kernel.org>; Sun,  4 Apr 2021 18:41:00 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so4986765wmj.2
        for <stable@vger.kernel.org>; Sun, 04 Apr 2021 18:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=in2R/BDzVJYoFiPJC28ODsaKmgI6LWLkCqlem8tTa68=;
        b=MU82mEW+mVsVklRT6afqclf/BLKRKOLstIJLSPckNmJV9qn7zHIkw/jWL057+is5FT
         zf/utVsDjE88RmlOKT95OoPMfITdI8oIvbfndAb0VhQJNrlV0v5GBie5fVdCED9dcDZD
         Ixha80LrgoJaHZUUfOuGKM7betHvH+xNJ/PhY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=in2R/BDzVJYoFiPJC28ODsaKmgI6LWLkCqlem8tTa68=;
        b=m5WGSOgNjgA7OInhUsONEXhGboDYk4N/Gbau7xUFfYhLYtm6GTHh5itZsvDWTbS317
         E7JqXa0u76w50weYyoHp1rWsexwX5Pf9xU1wTgETIkuTPGqoBYdM9xEn9zJD/rCtZg4p
         1W6ySGg9Oss686SGnNAd2pX5BXJCvS+tPVfDma+jGVXJ25EMdd14T7X3nR/UNbMAHI3g
         DIJYkS+2pphjx/V27vO9JaZdUOmGtTGq+sugssEgjkSjMH3mkcYCQRwNxMAhyIoI1nFj
         +CwgUKUM3u8EA4mvLbuTGRwmIgCo7OYbK8nu9ZA08YkjOGA12Hko+mtKoSINNtu/k3DL
         sjGg==
X-Gm-Message-State: AOAM533nMrRKvq72HZbeHGpEam6VP9i9ZDbfnCrSixMfnqZqXYAXH7TG
        ++A4rRmSvb929SpZUEPFGFJuQExMijmDjmsj4prOtDhghlU=
X-Google-Smtp-Source: ABdhPJwb0zN60Kg4HLH8P56HvIack9KllU+Q5O1fJ6nHKpE3yevso4WcdI4aVD+pl5zqV4uWZfCSmA/jSuZkn43x00c=
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr22959885wmq.7.1617586858626;
 Sun, 04 Apr 2021 18:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAAjnzA=2AwmEfPVKb9qo2LyzhZnF5orb3DGubTy2dc0hbQBXVQ@mail.gmail.com>
 <YGOCvMzJmgAhUYJb@kroah.com>
In-Reply-To: <YGOCvMzJmgAhUYJb@kroah.com>
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Sun, 4 Apr 2021 18:40:46 -0700
Message-ID: <CAAjnzA=i8x6qCAyx+Eiz_xdxSgLuAzP5tUu-OzF_FAQFqGHrEA@mail.gmail.com>
Subject: Re: stable/linux-5.10.y - 5.10.27
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry for this late reply I just saw this.

It is our internal testing tool we are just bringing online, so the
output is completely ugly right now.

All tests pass (kpatch/livepatch, linux-test-project, and some others).

This output will be getting better with each iteration.

Patrick

On Tue, Mar 30, 2021 at 12:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 30, 2021 at 12:14:01PM -0700, Patrick Mccormick wrote:
> > JOB ID     : 29cbaf7acada1e4b67b23f0841955606b597319a
> >
> > JOB LOG    : /home/ci-hypervisor/avocado/job-results/job-2021-03-30T18.59-29cbaf7/job.log
> >
> >  (1/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_nptl:
> >  PASS (6.21 s)
> >
> >  (2/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_math:
> >  PASS (2.01 s)
> >
> >  (3/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_hugetlb:
> >  PASS (0.08 s)
> >
> >  (4/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_ipc:
> >  PASS (20.08 s)
> >
> >  (5/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_uevent:
> >  PASS (0.06 s)
> >
> >  (6/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_containers:
> >  PASS (36.90 s)
> >
> >  (7/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_filecaps:
> >  PASS (0.11 s)
> >
> >  (8/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_hyperthreading:
> >  PASS (71.20 s)
> >
> >  (9/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/kpatch.sh:
> >  PASS (13.63 s)
> >
> > RESULTS    : PASS 9 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT 0
> > | CANCEL 0
>
> Any hints as to what all of this means?
>
> thanks,
>
> greg k-h
