Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432422008F0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgFSMof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 08:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730895AbgFSMoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 08:44:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9173DC06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 05:44:34 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l12so10039669ejn.10
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 05:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCI3p26DpFemoziWXeJgThj3QZvSObjlmSL6zVJZMZM=;
        b=mT1iyjzD8b9pQtlhasBVb61xX8KM/sVkswMsNj7rm4VZ9FZjqWjDzgsdzIk1LLdD1r
         o617NdhQ5SX5LLSmmxkoaiFjpMsoZ9b6L7/OREl7a+uq7OyqbT/x5mMATFbq5OlnXVDC
         mEnC0v6nlAEpcKio0iRF9U2he4dnrenwnFZ5OPcGRfB/+knEhasC/OdE9c+GNfLKzHGu
         +3N+z0ZOTRf3ErFW+bP2kNxMtlh4Axv2rO+XTQwyiszjDXx1tUYQlyxXQSznY8yxIa3r
         V2rINYek0XmG+jr3eaEcT8dN5mBovdD6CjtS9KSbovIA9irtad+Sr9w/YxPa8995axQS
         mx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCI3p26DpFemoziWXeJgThj3QZvSObjlmSL6zVJZMZM=;
        b=b/WmK371dWX8fI3skUZlnumddo1kAVqpP4fAk4DLxFl5LCq0wzaMLIP+3PE8eoM3a/
         /v+jS7Qdik4w9ciW4FkrNQTmiOTi/whxKUttYW+ADa7ALBWXVF3tz93MhykzVpLqb7lk
         tj395sReAFdO/qoie3cax0HMyPlCb4/TrPkY3ok9M9NdiS5dW0v0puK1xgmULhji0K6Z
         V2EWt4bp5dR4/3u9h2ubdut/XRiioXrShZwZ8tUnJfBwHz4Qeyc7CwuwdMzAxQAFnqUJ
         zWxCwLpW2GW/UY4aYwQdp0WxSbYjzlXuThwz/EJUOzN1lXjSOEIjV+opL1dfh9gxgpxq
         /k0Q==
X-Gm-Message-State: AOAM532bflo3INMqxCGN3ztvKdx5P0LFnanyokXF9mxv1umYukdEWn2Q
        zQTVl0oH6eAkJn232mRohvwTEB5y6ZJbrQYQ0IJ7mA==
X-Google-Smtp-Source: ABdhPJwEtgcjLXQh69MP0ygbMHygeKyCScYL87FrbKjDGF1cHozGT3auO4g0YX/uieAEXMo03QYRqbbunpRTq9IOVNg=
X-Received: by 2002:a17:906:e0cf:: with SMTP id gl15mr3341034ejb.501.1592570673333;
 Fri, 19 Jun 2020 05:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <15924957437531@kroah.com> <20200618162649.GA250996@kroah.com>
 <20200619022822.GV1931@sasha-vm> <20200619092137.GB12177@dhcp22.suse.cz>
 <82125cf7-a3e0-8596-ef6a-cda750bee28b@redhat.com> <CA+CK2bDVVcjvQAswxPe-2=DTOjf09Ty3tR69WdcEFaTgd87EqQ@mail.gmail.com>
 <d5d57204-a503-de53-edb1-63d12709e687@redhat.com>
In-Reply-To: <d5d57204-a503-de53-edb1-63d12709e687@redhat.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Fri, 19 Jun 2020 08:43:57 -0400
Message-ID: <CA+CK2bAo3dD3A4UqX9f3ruMYjBiiM8PRy1H8wJpi3JWUVgomDQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] mm: call cond_resched() from
 deferred_init_memmap()" failed to apply to 5.7-stable tree
To:     David Hildenbrand <david@redhat.com>
Cc:     Michal Hocko <mhocko@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        James Morris <jmorris@namei.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        pankaj.gupta.linux@gmail.com,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yiqian Wei <yiwei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > 117003c32771 mm/pagealloc.c: call touch_nmi_watchdog() on max order
> > boundaries in deferred init
> > 3d060856adfc mm: initialize deferred pages with interrupts enabled
> > da97f2d56bbd mm: call cond_resched() from deferred_init_memmap()
> >
>
> Just to note, in contrast to the subject, this is about the 4.19
> backport IIRC. Is it really only these patches?

Ah, I did not realize it was 4.19 backport.

Yeah, it might be more, I have not checked it.

Thanks,
Pasha
