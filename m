Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228A4FE38D
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 18:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfKORDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 12:03:20 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34481 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfKORDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 12:03:20 -0500
Received: by mail-qk1-f196.google.com with SMTP id 205so8671331qkk.1
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 09:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aFoRlwDVKq21mj3wCZljPYZAflK9jrHnXeJaUk0Q0qM=;
        b=mgHL1adTKa/qEfHqm030iM9EkOLjZshEI3Z+8bC9tR/VMhvftQVTg2Q6R+wP46Ooka
         Lyklpm371qKZPYXe9dmVCp8DwTEDueQFnRuDu88ZDjwQT8IObINTF/P2ptjqH6RveI6a
         3A7/O+TeNzm7bgfVtppDvt6CPqJiS30N8is4mOJkpOaO/ucvVbySagGdN9uqkN8r2iqA
         8zwdfUuAfUS4w/y7efYU8FPeCCMJKW4PEKHHugmmzcQ5avjtW7p18VgWoEKekLznx6gy
         5cPzIAVDvnQYrvm3h8whetULjlxEGSgS8dWcqwOa4CC0Y+4PFSo21IWGQzD51+DwBwEz
         GnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aFoRlwDVKq21mj3wCZljPYZAflK9jrHnXeJaUk0Q0qM=;
        b=uckkLR/AkAj6U2puBeMmQZyA1cnGgSvJ2ErFSM8ZuLfqfr92cFLZSg4+3jRvMhPD2A
         54yxkxV1FSkIBD0BPL8wGCxEWco56n6kU/c8AbujAhZ04giDFWiG1mVGt+6w5b11Oyuc
         aNZ1/YjeKrfHj0nEWRQVJh7Q2nrIJ6fMdzskAdGVhuVP08OIbfqFIQ32FK5iEsK/vL/n
         iSjsCfdUAc2VsQQWNJYLCIRk8Rxfbp9Zc65byGD2TLm5h0lbueV5GsxJ0atOKcjIlHgH
         Svuc8L2DP2dR/7I3XJ8FnM0n5/v6cdKqROX9tbrYS5ZDLX35+0fQZuHkBptC5Avx5SK0
         DDrQ==
X-Gm-Message-State: APjAAAVxWBjErW0sQdSOtEZKRdh1zd6yYVwgVax/U+Jmq2/z6lMxNZnC
        qGDkuNDGPY5qlCLfOSOmvaGs0bWZDei1OQ+0IlHW0Q==
X-Google-Smtp-Source: APXvYqzSiUyJue4q4ZwgFrukwvwEhpZANriBvaS41QgcHeDSU6DbzITxCy01JmMzs4LLSk8OqcfYr06L1P+nrzsTljU=
X-Received: by 2002:a05:620a:7d3:: with SMTP id 19mr13436665qkb.457.1573837398931;
 Fri, 15 Nov 2019 09:03:18 -0800 (PST)
MIME-Version: 1.0
References: <20191112223300.GA17891@debian> <20191113013026.GO8496@sasha-vm> <CAG=yYwnJKcriaHcZFFrznxq1V9-ZcLzC-O=fAhQ6Skmn4eFPAg@mail.gmail.com>
In-Reply-To: <CAG=yYwnJKcriaHcZFFrznxq1V9-ZcLzC-O=fAhQ6Skmn4eFPAg@mail.gmail.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Fri, 15 Nov 2019 22:32:41 +0530
Message-ID: <CAG=yYw=N6fRJfsQG08-h5SX1RBqgcZjhCU44e1QFHaJ6_YS_Ng@mail.gmail.com>
Subject: Re: PROBLEM: objtool: __x64_sys_exit_group()+0x14: unreachable instruction
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
        christian@brauner.io, tj@kernel.org, peterz@infradead.org,
        prsood@codeaurora.org, avagin@gmail.com, aarcange@redhat.com,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 14, 2019 at 3:07 AM Jeffrin Thalakkottoor
<jeffrin@rajagiritech.edu.in> wrote:
>
> On Wed, Nov 13, 2019 at 7:00 AM Sasha Levin <sashal@kernel.org> wrote:
> > Could you bisect it please? I'm not seeing the warning here, and
> > kernel/exit.c wasn't touched during the life of the 5.3 stable tree.
>
>
> I tried  using related to  "git bisect"  and managed to  check based
> on kernel revision related. The warning existed even on 5.3.5 and
> may be even back . i think may be it  is a compiler issue which creates
> the warning and not the kernel.

i saw a link related to our issue:
https://lore.kernel.org/lkml/20170726191008.jk2cdqr4wqnc33es@treble/
please see the above link.





-- 
software engineer
rajagiri school of engineering and technology
