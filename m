Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5571F25758C
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 10:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgHaIhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 04:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgHaIhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 04:37:36 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB1FC061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 01:37:35 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id t23so5702294ljc.3
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 01:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=abTonOcjEZ2XN7nBrtLFHGYhtcKoWlXGhNNsL7BifC0=;
        b=ghHSe5cXUBhyI0V9TEgPpzzVRjYdZfG80BtGrC2NbcZEo3CFuGqrAbsFr3K65fo1rO
         h0Qfo38vXbUWiCMoglqZB4xhb69TrXi1+M6DNyK8XvdoicVUd7ToTN/33cwp+CH7bGVI
         V0LAAKTyAeMORDk3TOpJaeigECM+fI+LJPjhGG3qpW7FcFynY0n3QzDTaXO48h8YGg3W
         L5w2sxjsYIzTI10SoWi25fXLqzTIVjJRyJgtjLggrGQ9eq/K427FwYGpXl9g2EIcQVMF
         SREmWgDqG2rTtBJZE9F+yUYcAkkEIRoDwPHhlBtnrzP6NI2FsEtxdYA2wlkrydKxl3h+
         TN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=abTonOcjEZ2XN7nBrtLFHGYhtcKoWlXGhNNsL7BifC0=;
        b=GDah31GYbrF+WWgehmUymZW4ZLTKA/A2MtoDi5+ukO1dgH8J3oXjN9bRcGF/Ax75A/
         IyUKdxUFVZle9+ixhDjYzPr4rZz0WKcIyMjnoK7AFE420/x9qolhBd5JMPGAecwHuIjG
         e5iuvrmoj7D6tbYiaFUQ8iaY/jl4G+2CfnX053iGod1gXkMGhErWVJxSPEgpzrs6fqAD
         oXMkv+F3OXD9hG7XQ9EA5RTszP8Z64b+OwNO0ycO2RVBjxJgoj8Hn0UZfEEYtaYY3Y97
         i2jkQzCmjK9NB78NsF6D+HTTfUqd0ef3qfu/1yANU9kT6FXkgq1oET3ADc893F+xX6s8
         uf6w==
X-Gm-Message-State: AOAM531EhZcPjNTSKZVHH5mSjkudUzVy3m3G6uatBAJspS1P2wFNo4Uz
        UjIwhscKkPutbRaGYbUawq5Dx6NZBDyhlIfFQLNtYQ==
X-Google-Smtp-Source: ABdhPJx/khJiJsUwcAUMHtWV5zx7dVpw+99di3aQ+8XgzVq8H7Y89xHCsuQejVwSwx5Bkp5ickNj0sgbrdQMxDI5Lsc=
X-Received: by 2002:a2e:9990:: with SMTP id w16mr158065lji.156.1598863053709;
 Mon, 31 Aug 2020 01:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200828152745.10819-1-sjpark@amazon.com>
In-Reply-To: <20200828152745.10819-1-sjpark@amazon.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon, 31 Aug 2020 10:37:22 +0200
Message-ID: <CAKfTPtAkOes+HmVabRazhCBBUo0M+QW38q3Zzj_O3O+Ghvc1pA@mail.gmail.com>
Subject: Re: [5.4.y] Found 27 commits that might missed
To:     SeongJae Park <sjpark@amazon.com>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Filipe Manana <fdmanana@suse.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Taehee Yoo <ap420073@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, Jan Kara <jack@suse.cz>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Adam Ford <aford173@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, amit@kernel.org,
        sj38.park@gmail.com, "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 28 Aug 2020 at 17:28, SeongJae Park <sjpark@amazon.com> wrote:
>
> From: SeongJae Park <sjpark@amazon.de>
>
> Hello,
>
>
> We found below 27 commits in the 'v5.5..linus/master (upstream)' seems fixing or mentioning
> commits in the 'v5.4..stable/linux-5.4.y (downstream)' but are not merged in the 'downstream' yet.
> Could you please review if those need to be merged in?
>
> A commit is considered as fix of another if the complete 'Fixed:' tag is in the
> commit message.  If the tag is not found but the commit message contains the
> title or the hash id of the other commit, it is considered mentioning it.  So,
> the 'mentions' might have many false positives, but it could cover the typos (I
> found such cases before).
>
> The commits are grouped as 'fixes cleanly applicable', 'fixes not cleanly
> applicable (need manual backporting to be applied)', 'mentions cleanly
> applicable', and 'mentions not cleanly applicable'.  Also, the commits in each
> group are sorted by the commit dates (oldest first).
>
> Both the finding of the commits and the writeup of this report is automatically
> done by a little script[1].  I'm going to run the tool and post this kind of
> report every couple of weeks or every month.  Any comment (e.g., regarding
> posting period, new features request, bug report, ...) is welcome.
>
> Especially, if you find some commits that don't need to be merged in the
> downstream, please let me know so that I can mark those as unnecessary and
> don't bother you again.
>
> [1] https://github.com/sjp38/stream-track
>
>
> Thanks,
> SeongJae
>
>
> # v5.5: 4e3112a240ba9986cc3f67a6880da6529a955006
> # linus/master: 15bc20c6af4ceee97a1f90b43c0e386643c071b4
> # v5.4: 6e815efe19a99a33b16cc720c3d3a727565a4fa1
> # stable/linux-5.4.y: 6576d69aac94cd8409636dfa86e0df39facdf0d2
>
>

...

>
>
>
> Mentions not cleanly applicable
> -------------------------------
>
...
>
> 39f23ce07b93 ("sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list")
> # commit date: 2020-05-19, author: Vincent Guittot <vincent.guittot@linaro.org>
> # mentions 'sched/fair: Fix enqueue_task_fair warning'

A backport has already been sent:
https://lore.kernel.org/stable/20200525172709.GB7427@vingu-book/

>
...
