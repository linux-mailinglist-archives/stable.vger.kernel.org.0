Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045FD2B9595
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 15:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgKSO6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 09:58:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43489 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgKSO6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 09:58:06 -0500
Received: from mail-ej1-f70.google.com ([209.85.218.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1kflNr-0004Lt-Q8
        for stable@vger.kernel.org; Thu, 19 Nov 2020 14:58:03 +0000
Received: by mail-ej1-f70.google.com with SMTP id gr9so2264782ejb.19
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 06:58:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o8QUSX5+wVSC79Qfp5B2ocoxFhcKMvm6Nc/lFmydSbM=;
        b=Wym1taXvcNkYywHdvaeru5RfUgOdEvwCdnvvdBmFYto6SV1NqwPA80CN4oM8KIiI/p
         I2gtxMCsxRQvPVB+glil207bKZiMjjntlHYV2lqtiMNnsm1gfOk/vR7mG7j/FS1Tvq7Z
         8mm/m1XWqVCv/3ZyH2kSeLftfKQitqe5Uzf6KB6m148efXZzsbYdy44ZhTXihdDkPLY7
         JheTvjVFBfuYimXTaj6LCHTy+I48cMZW60J5EyUuv2sJHKp98drUryvYLifGj649ClUO
         IwEHIMq+I7XAEvxyNkZ15MqTfEAL7YFiiiPXp1iUzXmTWPaadsp9s48kqmKVxye1kJlb
         PIjQ==
X-Gm-Message-State: AOAM531L1SIAcHZVScPwNa3FBbdyfA0tSIXTwhBkkDftvJNzild09/98
        OmQyuAtS6PCnVTKwlL5YhsimSUZAa50Cohx4GgAuuH8CWqS4qoOftNuyQ2flmNsOa5I3zI4mOcO
        Ndq9e+5gm4jYKo4C87X6xEjTxIrCK4nI1pvHZKhGp9tuxjRVreg==
X-Received: by 2002:a17:906:c086:: with SMTP id f6mr11749780ejz.38.1605797883481;
        Thu, 19 Nov 2020 06:58:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOjT9ivnURFruQ/CuwTCek9XT2cC6He55gu0cxihHBqDT/K4S/JWDspcuX6bTvDtNv05CAFysCCQvlo9+WJCE=
X-Received: by 2002:a17:906:c086:: with SMTP id f6mr11749766ejz.38.1605797883265;
 Thu, 19 Nov 2020 06:58:03 -0800 (PST)
MIME-Version: 1.0
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
In-Reply-To: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Thu, 19 Nov 2020 11:57:27 -0300
Message-ID: <CAHD1Q_zRaaROK_TCGg0csua=r9pskwKxCnztGW7XPK71n68DGw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Ben Segall <bsegall@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Phil Auld <pauld@redhat.com>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Gavin Guo <gavin.guo@canonical.com>,
        Nivedita Singhvi <nivedita.singhvi@canonical.com>,
        "Heitor R. Alves de Siqueira" <halves@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 11:56 AM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> Hi Sasha / Peter, is there anything blocking this backport from Vincent
> to get merged in 5.4.y?
>
> Thanks in advance,
>
>
> Guilherme

Forgot to mention the original thread link:
https://lore.kernel.org/stable/20200525172709.GB7427@vingu-book/#t
