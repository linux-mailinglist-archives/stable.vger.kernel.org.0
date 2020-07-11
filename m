Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BD321C5C1
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgGKS2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 14:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgGKS2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jul 2020 14:28:11 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25151C08C5DD
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 11:28:08 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id h28so7318522edz.0
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 11:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qptBZzYQmGUSrB1gYaro4KC86w7xRACt4nGpxA934Lg=;
        b=MS0M6Jpdfk5BRX9IT/yz435ln8+5sFvRJ5xcVUEVxD5BVgZX9q3pL4EfWbDc3q4Jkr
         e50VjG3ye4PDFlZy8RDkfbelBtcZP6hNhsexP/JMdK3XJmaM7/ypSusjb8G6D9Qy6xRk
         mWs+G1YR76GNa9sv/YeWuA+fcLo5auw5Y4kPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qptBZzYQmGUSrB1gYaro4KC86w7xRACt4nGpxA934Lg=;
        b=rnGPDQ+wdEnUqdsyG9M/h8VA0HDIWX0bWXRlmPdKNuTlpZNTB3Jdg03jULKFq8MrjE
         eN4QIXseD8fRd1ugyVM/Gz2UeP17d1wsqoJiKu7qqlLH14rW5yhcsTYIq9raBSTw6dkj
         19c4xh9kt9T6uojpc+M4IOdcTV4/1oON3Y7FO+HOVwxXBvRDLOKomq9a/mR/N62iBSHF
         qF5E78uJKyrD7BLG/evSpxQI5J3QYfc+v1Tn49s46yeEa8/IVGDDHZci4Zp+w6Mc6fr5
         gvDBgFVvm9EIjvhFMlNHYYT+HctSAN/I1Fyavy5L/R/hNnWerP/zUIMs8SrDHoOE1q9m
         Cuow==
X-Gm-Message-State: AOAM532St46SMfBMqvOnapQzxv56XSJdS8o0eZcV5tluaBI0cPzurxzA
        rc8GoRXLG1wd/ZvzloijNvJXwmnwDC4=
X-Google-Smtp-Source: ABdhPJy2qvCnLRERVXpzHvGrwh+2Z7muJ6xq1Odot67Kd+n+qXjZZkDTpnUFZl9yWKaXkxfhrnqyWg==
X-Received: by 2002:a05:6402:204e:: with SMTP id bc14mr6066351edb.128.1594492084205;
        Sat, 11 Jul 2020 11:28:04 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id bc23sm7386974edb.90.2020.07.11.11.28.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 11:28:04 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id p20so9693338ejd.13
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 11:28:03 -0700 (PDT)
X-Received: by 2002:a05:651c:1b6:: with SMTP id c22mr38521209ljn.421.1594491719786;
 Sat, 11 Jul 2020 11:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com>
 <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com>
 <CA+G9fYusSSrc5G_pZV6Lc-LjjkzQcc3EsLMo+ejSzvyRcMgbqw@mail.gmail.com> <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com>
In-Reply-To: <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Jul 2020 11:21:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg6mHH-LwqMNBcrP2nO8_acb_T2CCsweH-p8BvUFeAWtg@mail.gmail.com>
Message-ID: <CAHk-=wg6mHH-LwqMNBcrP2nO8_acb_T2CCsweH-p8BvUFeAWtg@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        William Kucharski <william.kucharski@oracle.com>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 11, 2020 at 11:12 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The fact that it seems to happen with
>
>     https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/mem/thp/thp01.c
>
> makes me think it's somehow related to THP mappings, but I don't see
> why those would matter. All the same pmd freeing should still have
> happened, afaik.

No, I think the only reason it happens with that test-case is simply
because that test-case tests many different argument sizes, and as
part of that it ends up then hitting the "stack is exactly one pmd in
size" case when the stack alignment is right too.

So the THP part is almost certainly a red herring.

Maybe. Considering that I don't see what's wrong, anything is possible.

                Linus
