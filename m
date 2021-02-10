Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174BD316FEB
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 20:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhBJTSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 14:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbhBJTSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 14:18:08 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A947BC061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 11:17:28 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n201so3080245iod.12
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 11:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d/zvyGkMXSWn1Irdy78f+YeinsP4PWGDw5bwcL7LGws=;
        b=IqE3mV57l/0g6jQ18NeRBbzGO4KaSmn3sGEsPuXDj33Yc2acsiVs7+7PCrBYM0b6Bg
         kZ3WJWUGQA/OQ7BbmXzrOW9EalIbBP6NXFclRakur1e/4IR1AQ8BmYCQ1Yk+bqW07ubT
         ZjElBazyB/RwuiTj6TLEfnpKbIWdEL1p2NmuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/zvyGkMXSWn1Irdy78f+YeinsP4PWGDw5bwcL7LGws=;
        b=GC3PmF1vh+scDFcwgfXZrcbwRX13zgTH+t07B3GT+aikftzQRoyloqQuI4psQ0QFV0
         G+bLl3oQmnX39fSJzFw2VkH8mqTpBurxaMk/yDrNH1kROMx/68Hl9rVX+1atvtPI8cfw
         1rweJnYDqnRqMNE+EzHHWJDPXK7gp4u25MXkJRMb+T2g/6s+Drfqc2SRHpVUSMz0RxIW
         1nm0XugZd1YWO+CthRSUCNP4g9I93BrJJGyDKGzOekecThdxQIiReObfS2uvBzcngIMA
         1Ub9Jy9jqPmHV3IB0eyVphce9FNzqj9RDpw53mNu9Nmji3ZMGJYQyUa8oyjJrMe9ytzF
         GJqw==
X-Gm-Message-State: AOAM531guJoFCFRuw4B3K5f2TKTD26+pN0agtc2zRSIp0bZo0eWw1zv/
        oYMjo/heN7HpRUrA9Lim48DTZZUqcxFUyg==
X-Google-Smtp-Source: ABdhPJycCJcfzpywKYc7OI+Hs80jCW/FUWxzTug7IdRt87bl9cdPULYq2x3r8YbV5BQJjJtGmIs7pA==
X-Received: by 2002:a02:cf24:: with SMTP id s4mr4926441jar.130.1612984647777;
        Wed, 10 Feb 2021 11:17:27 -0800 (PST)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com. [209.85.166.175])
        by smtp.gmail.com with ESMTPSA id x15sm1391224ilv.31.2021.02.10.11.17.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:17:26 -0800 (PST)
Received: by mail-il1-f175.google.com with SMTP id q5so2889320ilc.10
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 11:17:26 -0800 (PST)
X-Received: by 2002:a05:6e02:d0:: with SMTP id r16mr2465155ilq.112.1612984646136;
 Wed, 10 Feb 2021 11:17:26 -0800 (PST)
MIME-Version: 1.0
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
 <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org> <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
 <YCPgzb1PhtvfUh9y@osiris>
In-Reply-To: <YCPgzb1PhtvfUh9y@osiris>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Feb 2021 11:17:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=wghVA-6aNQz3rwr5VHmJAHkUvGyzKFpsEN1HPB5SL+aQA@mail.gmail.com>
Message-ID: <CAHk-=wghVA-6aNQz3rwr5VHmJAHkUvGyzKFpsEN1HPB5SL+aQA@mail.gmail.com>
Subject: Re: [patch 09/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Hugh Dickins <hughd@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linux-MM <linux-mm@kvack.org>, Matt Turner <mattst88@gmail.com>,
        mm-commits@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Seth Forshee <seth.forshee@canonical.com>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Tuan Hoang1 <Tuan.Hoang1@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 5:39 AM Heiko Carstens <hca@linux.ibm.com> wrote:
>
> I couldn't spot any and also gave the patch below a try and my system
> still boots without any errors.
> So, as far as I can tell it _should_ be ok to change this.

So your patch (with the fix on top) looks sane to me.

I'm not entirely sure it is worth it, but the fact that we've had bugs
wrt this before does seem to imply that we should do this.

I'd remove the __kernel_ino_t type entirely, but I wonder if user
space might depend on it. I do find

   #ifndef __kernel_ino_t
   typedef __kernel_ulong_t __kernel_ino_t;
   #endif

in the GNU libc headers I have, but then I don't find any actual use
of that, so it looks like it may be jyst a "we copied things for other
reasons".

On the whole I think this would be the right thing to do, but I'm a
bit worried that it's more pain that it might be worth.

Heiko, I think I'll leave this decision entirely to you. If you think
it's worth it to avoid any possible future pain wrt this odd inode
number thing for s390, just add it to the s390 tree with my ack.
Because honestly, I think s390 is the only architecture that really
cares by now.

               Linus
