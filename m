Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3392232352
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 19:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgG2R0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 13:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2R0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 13:26:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10261C061794
        for <stable@vger.kernel.org>; Wed, 29 Jul 2020 10:26:01 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w17so12087266ply.11
        for <stable@vger.kernel.org>; Wed, 29 Jul 2020 10:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNp6kZKANI3pBR6i8y+/XdO7n8ax8rlSmErac042k/Y=;
        b=fly0eTKEM/EKGjP16uHCq+pssRpnG1oc9UoD42sQ+DjGaEGgDyCjJVmdsBehGVFJAt
         tDNAzjNWyi+KKho1FdNdW0k2Jcj995U+FXNERWEzMPKtWBQK2ClbuGt9rZHOMZNBJArP
         mMJu/xJZIGQE7SLkiym0nS1ZReiINiIbRfdJtUtmmpKJ8uVAZlZspIxXpVKx1k/6BwI2
         02z/r47siNSpiw+r3aRWjPJ/9coKNnamUgcvWA5cRB1aenxCHis13DRTQYYS7Lr+KWV2
         kaE/I4emqVM3JfncrYgEFOLqJsW1mmYMKIrUMGhBvDeW2SYcpLzYbOsX83egBqqrOxut
         VerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNp6kZKANI3pBR6i8y+/XdO7n8ax8rlSmErac042k/Y=;
        b=tpb3gZUYk1hiwtIyE0DBsQKU5spAQI+XngCY/LjSgHcAeL0RaHgBwO2Ujw5K5A+KN9
         7qUf9JyIvdukAxDrK8jBtjbNf6WWkKRvzH9A8HhzwMBkSYThzWJJ9T+IVMWthxjzP+H+
         Qd3toYeNnwMZ86upGyZav4Spvr9vCSLcpwEuqeYXEBvToVYqKdewweBafSqypIajGg+y
         jNpm6OPATPlqtDx1nvvDa5no7k2B56V88r83nAICJGmPTPHBpnjbk+6Ljj/DlG74oZbR
         B+G0wMFHVdVyJjgyKVvJqmkY7ARvEWVSzTwmptGWQIvwCUAWWwKs1alC2tkEPRPHS7ry
         QsxQ==
X-Gm-Message-State: AOAM531zwvFclAxNd6TrRM9lgMJ+3SSrH62mw/vO97thcilBi8RDwmx3
        9Tw2JFvdZ/pz5LJln8axQljBIopaqXysbasKZzzkcw==
X-Google-Smtp-Source: ABdhPJxDXD5VZFMahV5bPRMyliowl8obs4+5jq1SXRL4nu282PjxCmsVHe9zoAoUJK2Ok2mSTg9oXhoTHKsmOrWerxU=
X-Received: by 2002:a17:90a:d306:: with SMTP id p6mr10153051pju.25.1596043560274;
 Wed, 29 Jul 2020 10:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200727191746.3644844-1-ndesaulniers@google.com> <20200729115155.GC2674635@kroah.com>
In-Reply-To: <20200729115155.GC2674635@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 29 Jul 2020 10:25:48 -0700
Message-ID: <CAKwvOd=cNoP7nVQUDwbVDGu4EQXa87aTvjiCdrcXK74jJyggig@mail.gmail.com>
Subject: Re: [PATCH 4.14.y] mm/page_owner.c: remove drain_all_pages from init_early_allocated_pages
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Miles Chen <miles.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        Oscar Salvador <osalvador@techadventures.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 29, 2020 at 4:52 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jul 27, 2020 at 12:17:45PM -0700, Nick Desaulniers wrote:
> > From: Oscar Salvador <osalvador@techadventures.net>
> >
> > commit u6bec6ad77fac3d29aed0d8e0b7526daedc964970 upstream.
>
> This is not a valid git id :(

Prepended a `u`. As a git user, I must have `u`ndid something.
Surprisingly it wasn't a `:wq` that was added.  Thanks for fixing that
up for me and applying.

-- 
Thanks,
~Nick Desaulniers
