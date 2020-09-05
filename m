Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FA325E60F
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 10:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgIEICf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 04:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgIEICe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Sep 2020 04:02:34 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003D1C061244
        for <stable@vger.kernel.org>; Sat,  5 Sep 2020 01:02:31 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n22so8158784edt.4
        for <stable@vger.kernel.org>; Sat, 05 Sep 2020 01:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=27ZFvFHs4wIKU4HMi46Fneg9D4+eZntU2s6ubfbmSEI=;
        b=kiy8KokDXYM4dYAEhTYSYKP3vOnxwLMROCBLHnYCJJyQoHVarhSO5MK07pQi/blaZq
         Kq2/SAfvyoLQE177Elb2HDUhLOgwRP/UzIuBMKJb3CpVlCBJsIlWeT3qUvnJsVJKBg9x
         zBjz6mQEpfswveYHGYUnh8OCeK2wS08P7q9BMBSDurUxq5eUNRgvl1/yE9EVYLAV77bh
         yt4LNPjzgA6t3glvab84ZBLEYrDYIqlpcZo9Itk60XVEUWrYb34In1hp9tydr50vw/48
         qcYTQCFnt7gYPw7/ZIdXECT6monVSsW0TT7Vy7Oi1Fpw0ydaC7Hr5Ny2Er0nW31Eye7m
         dbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=27ZFvFHs4wIKU4HMi46Fneg9D4+eZntU2s6ubfbmSEI=;
        b=f19nPOICtzBeGgjLCDQ43suUBxj5T2UjTt6hJJdef7fOM8YB4Sn5/EYcnXwzUR/pgE
         Kvi698N2RNi3s2/3UmVLBV9E/QDmLcx9H0yhY+pW9E19y+j5fuqMT7uKtRX8mJHVRNOf
         3X/xXEOe8K0q8gHo2ruRf2VsBI9BP2OgMVueyupzWYtXEQg68UOvXwwNHvDD3R43RL+4
         ze4qWHTEvjsNliMkUqjokCgYyHRZt3yABvJwTV1GV1WDdw6h1xll/K2KD7q51LQEDivS
         xMvNuq05R5hTGh+5l48jWdP3epXACJQKKIL7IVtArfbyWbUW5a4c9ZfLmRt/R1gclEHq
         nJjQ==
X-Gm-Message-State: AOAM530PoBphlcYCvUvEWSmzvhz/6JBaFwCPO3hIO95OucNeTOwmBcxA
        iVh18UzMPdYVdexsjhL8Kw0=
X-Google-Smtp-Source: ABdhPJxtBXuFIh946EvPUP8NMPWeqULd1txQg20gArFDeWqziZMd7jtYDVRT3rI/FW3uuG2p0YVhBQ==
X-Received: by 2002:a50:f199:: with SMTP id x25mr12072739edl.347.1599292949912;
        Sat, 05 Sep 2020 01:02:29 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2450:10d2:194d:30d0:809a:348:c6fe])
        by smtp.gmail.com with ESMTPSA id q11sm8200758eds.16.2020.09.05.01.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:02:29 -0700 (PDT)
From:   SeongJae Park <sj38.park@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     SeongJae Park <sjpark@amazon.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Filipe Manana <fdmanana@suse.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vincent Guittot <vincent.guittot@linaro.org>,
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
        Xiaochen Shen <xiaochen.shen@intel.com>, sashal@kernel.org,
        amit@kernel.org, sj38.park@gmail.com, stable@vger.kernel.org
Subject: Re: [5.4.y] Found 27 commits that might missed
Date:   Sat,  5 Sep 2020 10:02:20 +0200
Message-Id: <20200905080220.23493-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200905070946.GA184702@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.com>

On Sat, 5 Sep 2020 09:09:46 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Sep 04, 2020 at 04:17:48PM +0200, SeongJae Park wrote:
> > > <snip>
> > > 
> > > Stopping right here, if you have fixes that will not cleanly apply, and
> > > you think they should be applied, please fix them and send the proper
> > > backport.  I don't have the cycles to do these on my own.
> > > 
> > > Same for anything else here that you think should be applied but does
> > > not cleanly build/apply.
> > 
> > Totally agreed.  Actually, I posted a similar report[1] before and received
> > similar response.  I promised to back-port some of those by myself.  That's
> > still in my TODO list, but I was unable to get a time to revisit it quite long
> > time.  From this, I realized that it wouldn't be easy to review, test, and
> > backport all of the such suspicious things by myself.  Scaling up to multiple
> > stable series (the tool says there are 152 fixes and 147 mentions for 4.9.y)
> > seems impossible.
> > 
> > For the reason, I updated the tool to make the report to be sent to not only
> > the stable maintainers but also the authors of the suspicious commits, because
> > the review / test / backport of their own commits would be much easier that
> > others.  As a result, we were able to find one suspended commit:
> > https://lore.kernel.org/stable/CAKfTPtAkOes+HmVabRazhCBBUo0M+QW38q3Zzj_O3O+Ghvc1pA@mail.gmail.com/
> 
> That work had already been done before your email was sent.
> 
> I too can write a tool that sends out "this patch might be for stable,
> will you do the work for it!" emails, but that's a bit rude to ask
> others to do your work for you, don't you agree?  By asking me and
> others to dig through this list, when you said you don't have the time
> to do so, feels very odd to me.

I thought the tool and this report are like a very simple form of the CI test
bots like 0day, syzbot, or some kind of static analyzers.  Mine has quite large
number of false positives, though.  Actually that was my only one concern.
Therefore I thought asking the authors to check this could be a little bit
annoying and therefore I asked them to let me know if they don't want this.
I also thought making an explicit list of false-positive 'Fixes:' could help
someone in the community.  Also, I didn't intend to make others do my work
instead, but I just wanted to help the community finding missed patches.

For the reason, I didn't think this as rude, but seems I thought in a wrong
way.  If you felt it rude, it's rude.  I apology for that.  I will stop posting
this report.


Thanks,
SeongJae Park
