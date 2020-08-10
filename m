Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B3B241249
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 23:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgHJV1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 17:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgHJV1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 17:27:24 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A6DC061787
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 14:27:23 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id t23so11229593ljc.3
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 14:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/WDS43rlS3733ZJcRlieCTJ4y/G+sqa5pD9t19aFErg=;
        b=XKpQj2TmMGlnJe5J+3klZSKWK18EJmh2RGy2FtJGTkQjOPYwfa4dsIXRD2BxDFL9TN
         cUYRWm1FwuDhPyrNPcaEM0A0+/FumReOuZi1MGFEwMCdCgoLnwRGoRtSt95WQiOh3App
         FB8ZjfHj+Kv7EJxwM4gfXO28Git8PP+ImavNqKI7n02oLTy65SXPIhTeBaL2apkF6Ypq
         u9XCGjpI3nS5ecDD9uUbO9v2Ied7niWkca7dwq1HD6nLvx7QfLFECsZYeF34FNpiv6on
         hvQ3CSg4i7qOeQHWWP/KPTCHMfXkpGhjA8BOCC516/IXzge5RGqTjyqG8FEMaNlnuPdQ
         2aJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/WDS43rlS3733ZJcRlieCTJ4y/G+sqa5pD9t19aFErg=;
        b=qpKoVXnNqPtmlOblfNQ5yh54kL9FPdH/Uzu7CYDznPV4sU4Z1EltCMBos8jCZpib+l
         9z/WewHT2MzlMWc/HZaaieaQI5oi9f7+/OfHv4531r0D7Z8ds3SeUu8RlxwZVT2q/EGg
         zYfG9RuOSS0XE1KfhkuM1/DVxGWXrMsFx2wWcJ/9hpas9/JyWjiSZ+Bp27HxJejuTq1i
         RovbMBSPeTtysdzqN1GCU9EqyqkxteEdVEpsuCFW0vaZjvYFw+HUSQLSgmKxpUSOZXCi
         zDHbbfYt7jMZj5tXGBdb/vWl8b8CUG+wERGaS6hsjRVfdDSCmN99G8I4DY0AoYCloM9Q
         mhSQ==
X-Gm-Message-State: AOAM531WJIp9wnBdBfwJ3ADbWc5/lZXkxSEVSIqdiycHyFOC3a94aywc
        e313QbGzY8SLAH2WEE0iqsoe9gWfez8WnDLRwQp2sMV3
X-Google-Smtp-Source: ABdhPJzXc9rSqXbU3vOVd37HoiQZ04pedfQ7RrRG7IJXH22rbvY17HN8qaobdvJmQhCEKf1KN+w0j2oWyK8yrb8YmLo=
X-Received: by 2002:a2e:95cc:: with SMTP id y12mr1360162ljh.138.1597094841875;
 Mon, 10 Aug 2020 14:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200808183439.342243-1-axboe@kernel.dk> <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net> <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk> <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk> <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk> <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
In-Reply-To: <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 10 Aug 2020 23:26:55 +0200
Message-ID: <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 11:12 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 8/10/20 3:10 PM, Peter Zijlstra wrote:
> > On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:
> >
> >> should work as far as I can tell, but I don't even know if there's a
> >> reliable way to do task_in_kernel().
> >
> > Only on NOHZ_FULL, and tracking that is one of the things that makes it
> > so horribly expensive.
>
> Probably no other way than to bite the bullet and just use TWA_SIGNAL
> unconditionally...

Why are you trying to avoid using TWA_SIGNAL? Is there a specific part
of handling it that's particularly slow?
