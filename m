Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DFD28C0D
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 23:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbfEWVG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 17:06:58 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:52666 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731537AbfEWVG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 17:06:58 -0400
Received: by mail-it1-f193.google.com with SMTP id t184so12283158itf.2;
        Thu, 23 May 2019 14:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qdKz+TOs1wCAyZUw0giltCYWrjHfuqYDcD0Y730vB18=;
        b=X1/pu0J+wGbtPR2O2S+IZYCGPHacIpZIWlZOFWyrcdChosOCsJjjuHh8Pmjbpcd/iR
         v93QHkkPBOa+2R+cA7xBGf3GJGK02mE+fvVDdEqB4GgsTipeTPJ6UQCrvJq1kJdFsskk
         Hf68qhuoJF1y72HyQhy9UTR3pwbJ0O9GFSXpJUdO0NLDRyZ927qoRsk/ndLeG80c6yon
         KvRUWEcuvxzy08YY3EsZPEefJ9KlXLSN7/HrXAx4ZcfMc7utGhKD2QaS4QFHFQqcxvSq
         u6HahTlnlzCTKgxbW3PKFhDSjhK486kZuopYnyXvidTzXDyRLyYdnh+FR0DcMA72iFhD
         4IYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qdKz+TOs1wCAyZUw0giltCYWrjHfuqYDcD0Y730vB18=;
        b=q2kjOeNLaruz5fmvyfCne3jSuaf8mYtxhxjfy9NBJ93DP26a1Vvo8X7opb6xajTwim
         FCI62uCmeKsDyt2cZg8pfzRwLnnacCw+jPyu/IYG9U8wuJGTvPXItHAgkrybYyuyqUT4
         vnTAjdiFhc6WaTYKpA3FaFmgJSuKfUjZAMhPxPaTEGgAFQ4orpiqMmoysuq6or1cBy7/
         bsaLC4BIt6WGkrpLML+ZMm/9vEH2RGINbZE8+oY9mFSf5BHYc7u+/OZx9nS2647nyZst
         Hn1iRkgaH5VqN9A+OgTWhjvDIkGvi2ZVVESXwdbckqefRbDZo0gGZgptXBDtNiCVh4bL
         AWIw==
X-Gm-Message-State: APjAAAXwSo24peNtu5zbjbvwO5v/O/2uhWZkuxb5OX1x8NvFDwHzS+Kr
        Ux0X58s5HblrdCFv+f9JTDezwAjui48HM5sGZ1Y=
X-Google-Smtp-Source: APXvYqw39Es/1/4zjenOfZ0CdT39/+9yH2SVWfYxIvNq4CN3m21LbaDD6pNQgMJJnPBaS4n8+lARacqZ1hZGTol3H8M=
X-Received: by 2002:a24:e084:: with SMTP id c126mr14417307ith.124.1558645617016;
 Thu, 23 May 2019 14:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com> <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com> <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com> <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com> <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com> <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <CABeXuvo5Y0aHgo-xMzmW7V02g+ysGqAkdoCAkW7L6LkukdvAcg@mail.gmail.com>
In-Reply-To: <CABeXuvo5Y0aHgo-xMzmW7V02g+ysGqAkdoCAkW7L6LkukdvAcg@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Thu, 23 May 2019 14:06:45 -0700
Message-ID: <CABeXuvrKAz3epJjc9J21K-dET1Om9C=3gaDOUiQ96C39x4MAVg@mail.gmail.com>
Subject: Re: [PATCH v2] signal: Adjust error codes according to restore_user_sigmask()
To:     David Laight <David.Laight@aculab.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Just adding a little more clarification, there is an additional change
> between [a] and [b].
> As per [a] we would just restore the signal instead of changing the
> saved_sigmask and the signal could get delivered right then. [b]
> changes this to happen at syscall exit:

Rewording above, as there seems to be a few misrepresentations:

Just adding a little more clarification, there is an additional change
between [a] and [b].
As per [a] we would just restore the signal mask instead of changing
the saved_sigmask and the even the blocked signals could get delivered
right then. [b] changes the restoration to happen at syscall exit:

> void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
> {
>
>            <snip>
>
>           /*
>            * When signals are pending, do not restore them here.
>            * Restoring sigmask here can lead to delivering signals
> that the above
>            * syscalls are intended to block because of the sigmask passed in.
>            */
>            if (signal_pending(current)) {
>            current->saved_sigmask = *sigsaved;
>            set_restore_sigmask();
>            return;
> }

 -Deepa
