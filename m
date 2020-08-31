Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DB0257522
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 10:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHaIQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 04:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgHaIQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 04:16:41 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A377C061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 01:16:41 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 67so195875pgd.12
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 01:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U1qfomPrxBgrKrIyASypjd089pdAYsDMrimLHrAX4f8=;
        b=mAw3pq/Wb0DauU7iT2L4herLH30KVkzgrOlx0nT8aWVxwO2tZVPjQAmJyrX91oJ4FJ
         uNzffGfDelwQoAZKy84+hoWg0XD2F3VyqX43pPTPAdTpANt6YquFgtiQRUpykqjEqRJ3
         K8Ye9a2sgggAew8FcYI3LZIFiXEpEmajUlcAePv4qs772W54rWgCBiMtobFDOvzsPqah
         89M9X0JleJ8R1m+XTMgP4PDcy0wS4EtjmWT1kLsqnhbSNhQCoKTdVtm1BfA67qPRUp/I
         Go1J10QTgqKIAbvGnDa9Ct0t7QBxPUaeS9Y279JMr/6e0imh65Kz6leDywpDyQ4DThpO
         74yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U1qfomPrxBgrKrIyASypjd089pdAYsDMrimLHrAX4f8=;
        b=hF9yt656YVxxHnUA0Kzb9yN6OPpvE5a1IXuCrPqKsELYvinSL2QxRGKu15mcACDX/v
         W8fizArl36hEzOJNau4arWcavj9FOJKbminx7MVWNaMC7jtZ5shnvaAyUYatjxeLIrkW
         ioFeeLsQm3xMoeZnnhWXqaoBInbJEOkUJ7Ot2SnJyRnXCVAfLMzLBICX4T83Yz0nLb46
         Wn4SjaBUh57kdHNXNUHBS6zl+6Og5gkAkqLowvuKfvoMGetQF7k7FEjLtG3pbcYX2r0B
         hh98EzpTEA01Huh9iWorklXj3iTkQ5lf6E4ZPBUk0pe+J/ag8R1sliNq0lLopaRLEm4R
         qwHw==
X-Gm-Message-State: AOAM5311M7qW4xkQFXlNKepZy/Oj2icMgCtWlFibgzzkU5npYCgKdjMx
        +3r+4L7mkUETeDFgVYAdMRHMHuiPDwOdmvOp8t3Nuw==
X-Google-Smtp-Source: ABdhPJxocXyKBB0/m4xoOjhmzjbo1Jf/dKM0V9D6EKSKnWvfXlPxwoIphDqx7SHQxf6PN30dYmVYUZ9FBsB+JplMaXE=
X-Received: by 2002:a63:9041:: with SMTP id a62mr376155pge.273.1598861800233;
 Mon, 31 Aug 2020 01:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200828152745.10819-1-sjpark@amazon.com>
In-Reply-To: <20200828152745.10819-1-sjpark@amazon.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Mon, 31 Aug 2020 16:16:03 +0800
Message-ID: <CAMZfGtVFLQBG+2fDdcRaDDOd27Es4d3H2ADU7BBGaz6_XbvanA@mail.gmail.com>
Subject: Re: [External] [5.4.y] Found 27 commits that might missed
To:     SeongJae Park <sjpark@amazon.com>
Cc:     Filipe Manana <fdmanana@suse.com>,
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
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sashal@kernel.org, amit@kernel.org, sj38.park@gmail.com,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 11:28 PM SeongJae Park <sjpark@amazon.com> wrote:
> 10de795a5add ("kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE")
> # commit date: 2020-08-06, author: Muchun Song <songmuchun@bytedance.com>
> # fixes 'kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler'
>

Just avoid compiler warnings, so it is not needed to backport.


-- 
Yours,
Muchun
