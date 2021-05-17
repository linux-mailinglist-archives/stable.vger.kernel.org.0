Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49D386DBE
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 01:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344548AbhEQXjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 19:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344523AbhEQXjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 19:39:14 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10755C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:37:57 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id o8so9354986ljp.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EC/dKq26KSxNM+GJiWisbAjkLsRsOPgjxy3coeO4AlE=;
        b=FThto6ud9Hwt3eqtm0LMrpULqIpjhcfbogeOlKokXRBCG/FzGZV6wV4S8pbUAGGGg7
         gabJ5Wnl+QVxF8RAEmE87BExUr0RYkt/IYmwVlmqujgfc24oUXlr+e3RZ5zIv3wK8icK
         VYk25bz+oQya7XLR3f7zxk6Vkbdziif35liF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EC/dKq26KSxNM+GJiWisbAjkLsRsOPgjxy3coeO4AlE=;
        b=ZbEmLdJ53xbcslIrynb29QW4M5JRSQNJbszRJI1O+Rh1LJ8Ok/YvHoekXovf4O+frw
         VHYXj1JxcxLW6Nj/7Fgt3Z//M+ohLbJC83HFr8vpvq9b1C9sDu3fbCjszkvZ/NQQGffW
         NZs4chNrxRPE4EOTPQ6sGtUGFs+8mQJyk9cxzggqyrJKKMhDC8yglegzZhZ+/0UT98Gb
         KqneUcVZOx1uiDuaFK4nzeI2l6eadm7jOgHt3rBY2qgFmmAoWIpG8cJFgFo4/wWO9bTv
         hQTXrldet08m/LtzBe07zIwJ5L0DDDoPY8c8U9Mqd3pbQr47EpuWozYZalZ0JOEcS+up
         5GBw==
X-Gm-Message-State: AOAM533zB9QZaGH+Z2Vd9Nqh1fJf3+o/EwONtq3v0/Jvi9izqp4Ff9wD
        Vw9JDDXbSw3Km97Xi0/WXli1Du0lB7GoF/AS
X-Google-Smtp-Source: ABdhPJzr3yrA4CC/eo79KBp+lrPJYSXYhZfTYiOKWr2OJnJgA+XUd3Um/aP8YcpzhoAj2TNBSjhKNg==
X-Received: by 2002:a2e:95c6:: with SMTP id y6mr1591135ljh.155.1621294675117;
        Mon, 17 May 2021 16:37:55 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id j3sm2098746lfe.5.2021.05.17.16.37.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 16:37:54 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id a2so11246667lfc.9
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:37:54 -0700 (PDT)
X-Received: by 2002:ac2:4a9d:: with SMTP id l29mr1663396lfp.201.1621294673874;
 Mon, 17 May 2021 16:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210516121844.2860628-1-willy@infradead.org> <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org> <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
 <YKFt4Njj5au/JEhT@casper.infradead.org> <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
 <YKHYFpyPcnwpetM5@casper.infradead.org> <CAHk-=wi0Vp7DRh5ZwOsWKpQUyPpwo=9qG2hRw2uFp0adMp=brg@mail.gmail.com>
 <YKL2C0YtlxYbsRdT@casper.infradead.org>
In-Reply-To: <YKL2C0YtlxYbsRdT@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 May 2021 16:37:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wja9m_sdu2VekWNJWhswZ8CVKROPvtCreZmANE1jBCHDw@mail.gmail.com>
Message-ID: <CAHk-=wja9m_sdu2VekWNJWhswZ8CVKROPvtCreZmANE1jBCHDw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 4:02 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> or if you'd rather look at a git tree,
> https://git.infradead.org/users/willy/pagecache.git/shortlog/refs/heads/folio

Well, I wanted to check a git tree, but this seems to be based on some
random linux-next commit. Which is a bit annoying.

Looking at it, I get the very strong feeling that the *only* thing
there is "don't call compound_head()".

I have only gone through the beginning of the series, but it really
strikes me as "that's just a page pointer with the rule being that you
always use the head pointer".

I don't mind that rule, but what's the advantage of introducing a new
name for that? IOW, I get the feeling that almost all of this
could/should just be "don't use non-head pages".

Is there something else that appears later?

              Linus
