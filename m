Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAFA279B74
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 19:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgIZRcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 13:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbgIZRcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 13:32:36 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3342FC0613D3
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 10:32:36 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y17so6348339lfa.8
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 10:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tWe98Z0+yeW9gkegitz9dCMR70Oh5RZVF1XD+EtjfBI=;
        b=YANRG3v8mFUdar8MnApQc7eZ0xpcy9rLqBogJxvFlVToZ9asxctFyxRLw7T7EgwW68
         UWQDCWRz5Z0W51uhmXYLF32IgPz5NXZm9C8KyHb+TJeU/rVKewxu3RMuFrmOpx/2+cDV
         //gJ3pIIZv81LlPeoNW7dyyHoJGugzfK194yA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tWe98Z0+yeW9gkegitz9dCMR70Oh5RZVF1XD+EtjfBI=;
        b=j9GtCsFMOG5ZizEXBYsq3TV6f7PYOSCPDAS47CbqlffWo8uBIZq81gArXoJZtWNfvI
         35lH1RYwaHPyrpsKBDAk60Qqq9zwOJoAZ1ffgc0+8ZKXBsRpZqf+4W1ym6oCV+2Uak2M
         D791BWYY/qRPbjwfWkZPdohupfC4zz7ZJAgoWc/s1/2auOlinfHU7WiqwTQJ5KffzTVs
         jH6VGzm2er/OO8ItrRmhO+QQ5AByepM8BMSPaz/9qzVk2Zjm8gv55En3MekSUtUrBs/4
         NlhfajJRoOtKtdnUx/3FoCikWLskVt9CSJD/aXry5QSPkYsrITj/2mRKhg/br6puxEPd
         fptA==
X-Gm-Message-State: AOAM5305Hv28/vMDqHvxWJjRpk0v8OsHWmeoCfdgq0H4Uq2NKYUFLCNu
        DkTv3imQ3Su6h+u130ZXP4Db6+ubumH4Ag==
X-Google-Smtp-Source: ABdhPJwLL09Fzk7AoNkXUyYe8+7Gun81VxMQmBgZtP5Dyt9KyLHbEzQI5+7LJZv9KQWRQ571n/V1Uw==
X-Received: by 2002:a19:3fd5:: with SMTP id m204mr1228466lfa.233.1601141553668;
        Sat, 26 Sep 2020 10:32:33 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id j20sm1941480lfe.181.2020.09.26.10.32.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 10:32:32 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id a15so5050896ljk.2
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 10:32:31 -0700 (PDT)
X-Received: by 2002:a05:651c:514:: with SMTP id o20mr3140153ljp.312.1601141551598;
 Sat, 26 Sep 2020 10:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org> <20200926041928.9xJHGgkah%akpm@linux-foundation.org>
In-Reply-To: <20200926041928.9xJHGgkah%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 26 Sep 2020 10:32:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
Message-ID: <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
Subject: Re: [patch 8/9] mm: replace memmap_context by meminit_context
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     cheloha@linux.ibm.com, David Hildenbrand <david@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ldufour@linux.ibm.com, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        nathanl@linux.ibm.com, Oscar Salvador <osalvador@suse.de>,
        Rafael Wysocki <rafael@kernel.org>,
        stable <stable@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The explanations here do not make sense.

On Fri, Sep 25, 2020 at 9:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> There are 2 issues here:
>
> a. The sysfs memory and node's layouts are broken due to these multiple
>    links
>
> b. The link errors in link_mem_sections() should not lead to a system
>    panic.
>
> To address a. register_mem_sect_under_node should not rely on the system
> state to detect whether the link operation is triggered by a hot plug
> operation or not. This is addressed by the patches 1 and 2 of this series.
>
> The patch 3 is addressing the point b.
>
> This patch (of 2):
>
> The memmap_context enum is used to detect whether a memory operation is due
> to a hot-add operation or happening at boot time.
>
> Make it general to the hotplug operation and rename it as meminit_context.
>
> There is no functional change introduced by this patch

So far so good.

But there is no "patch 3" that addresses point (b) in this series.

I see it on lore, but it's not part of what actually got sent to me,
so the commit message for patch 1 now makes no sense any more.

                   Linus
