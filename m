Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B09A27EE1B
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 18:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgI3QAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 12:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3QAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 12:00:47 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC79C061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 09:00:47 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y11so2788210lfl.5
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 09:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvdB7J3ojJeIo6lUqGYWmtz7rx3h+2idqdXcew5+qhQ=;
        b=N6j07IitlreWSX9amxOOqk51P7vHXqH5nQxH7Kl+NLsnhhvgxYrWIvxGkBJ3DjWlzB
         PGDejRrPln6nRJEdbFDB8co6+6mZ3u4xS25OWa4KB+rXcySeu56r/qlHUHxAt4xnZzJX
         5gwp/oyP/fOTTR8Nwqs1KysB9ZCDCm4BPlSFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvdB7J3ojJeIo6lUqGYWmtz7rx3h+2idqdXcew5+qhQ=;
        b=pThkk+fETbJ7d1HOQ+qnNHsaxpt2BnHTltaP/CVXQZWXUWOaEsglnftRlpQzjTxhXS
         hotoqy0onbKhYc++eJ9RDHVUBA5VyA1t5TCkhIsv8S8UqA4DwEmXXT1F/Z+B0vCBvj77
         /KHLifx8sCDxjSXzR9d5gI+cOnlQ0glclfKHdwnhUHohahiRewnsz8L+SgNSLJWBwrVe
         7JztOXCNNBcDQRgOLz2cgrcjvaG35oBYOz2Y1kFUoCvvr62ETYuJRWX2+ra+u/Ar+ptg
         cFcpR5VvAtH5neS/Wdh1vcpqJE9ezJUwdo1QHTDXDlghvwnuOKCdiqfFifaHC997bc5Y
         16iQ==
X-Gm-Message-State: AOAM5318rooj06YrFjUl3bJzWiqmVl40m7SrHPIWOrQMJXh2qLcEsjiB
        3RpZEZbWwBFUxVp2YAajE4BA/m9Bqo1pYg==
X-Google-Smtp-Source: ABdhPJyk4/OqDf58X44l4F2xlTZ5b+q6m0tMNLfOOCCB6huZCKAtsoxjZIO9V10X3tb0k/k6hus59w==
X-Received: by 2002:ac2:4116:: with SMTP id b22mr1216527lfi.224.1601481645310;
        Wed, 30 Sep 2020 09:00:45 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id h124sm234426lfd.151.2020.09.30.09.00.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 09:00:44 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id 77so2809384lfj.0
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 09:00:43 -0700 (PDT)
X-Received: by 2002:a19:e00a:: with SMTP id x10mr1213265lfg.603.1601481642902;
 Wed, 30 Sep 2020 09:00:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
 <20200926041928.9xJHGgkah%akpm@linux-foundation.org> <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
 <20200929133737.99427221b858425e5ddff706@linux-foundation.org>
In-Reply-To: <20200929133737.99427221b858425e5ddff706@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Sep 2020 09:00:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgGN3drZeV-RZpVn20yZ6tB0PDCgXa=DaD47sRvM16sGw@mail.gmail.com>
Message-ID: <CAHk-=wgGN3drZeV-RZpVn20yZ6tB0PDCgXa=DaD47sRvM16sGw@mail.gmail.com>
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

On Tue, Sep 29, 2020 at 1:37 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> 1/3 and 2/3 were cc:stable and 3/3 was not.  As far as I can tell, 3/3
> is rather theoretical once 2/3 has done its work, so I held it off for
> the next merge window.

That's not the problem, holding off is fine.

The problem is that the commit messages are garbage as a result. They
were written as a series of three, but the patches weren't _sent_ as a
series of three.

So if you split up a series like that, you should look at the commit
mesages and edit them appropriately.

Or, in fact, try to avoid such commit messages that depend on other
commit messages entirely.

               Linus
