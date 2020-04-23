Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC601B6A2E
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 02:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgDXAAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 20:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgDXAAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 20:00:15 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BBAC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 17:00:15 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e25so8117405ljg.5
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 17:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3AO2zDYw2OTrVTsEOf9qOCAlkKJ6vVvcI1aCDMu2ZHI=;
        b=HS3L0RvS4J2AHu7yfa/WS299UPIfdIbz/WFwgftGS6ioGesdU8JDJpiCx8KTLRhzpA
         Sfr0mHYtsT0QNWyBvlx8aWk4NH51uEI07Sr1zkBRpg2pGcz3a3lRSpCoqLAgwInRrt2P
         J2Jv3rZreCwePGwxg5ozt4xBt6eUBnW1Am+tGXtZBNVX8gRgNeIyGZE6gjHpmMmjMR7a
         OqPZfZcjampppdtDZ8OBwmW1hsnnK++hHZHP2GyH0qVPUsaBj5DiTrxhcwv6AWkYBiO8
         FSfcdCtwihfWI8gehyCoCkUNA6Y7H9x6+q9r5a3ae6cNP056qNWkhKgJrrrI2dzM2wch
         SRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3AO2zDYw2OTrVTsEOf9qOCAlkKJ6vVvcI1aCDMu2ZHI=;
        b=DKFkK5K9jGQwdyJ8k1PTof9He6zMMGsHswGKQ1nJTZlJBfaDNOQBffaDbbs5J8dA17
         p2SftAD+9JYZDAkucdnljm0qUFYaMRUaP9uMGnWkVPMpyAuYOpenjMpPV9c5ApgvWwR3
         uGZqbgyGcel+OfsKW9wClkSIHHAFQ4Z00HAviOZWU27xCwvNnwE+LbEE1seIVMiuSm6Z
         oAbyBgrNWLczgSbBrQPdJOlU4/ZBfgqS1Hn3zgMhuIh7OzNGwk0FdleBy5Ryjug8zrIJ
         fNJ/+v75EDSXQecLSPQqkWLQV45VW4n4u21J4MtF0Tg3R1ce4vChAInpVlq8EvSiVKgO
         gHrg==
X-Gm-Message-State: AGi0PuaoMzr+ViDqLgZc1RRiE99sVv4Wlrvuf2j9QxBs+tACoPdOFBVJ
        wbVR9wxtihggSDOZvtS8mRC/Ko1tT7tOLcoIRshIPA==
X-Google-Smtp-Source: APiQypK+4462/UiJw2zVslTXnFJSdEZhNkC9wnzz+Q8zSaEjmCsx8aWyreNA0I93TTjbrrEaBN7JVQiJAfn44Wb6CKA=
X-Received: by 2002:a2e:87d3:: with SMTP id v19mr3762634ljj.176.1587686413751;
 Thu, 23 Apr 2020 17:00:13 -0700 (PDT)
MIME-Version: 1.0
References: <lsq.1587683027.831233700@decadent.org.uk>
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 24 Apr 2020 01:59:47 +0200
Message-ID: <CAG48ez0nyLsyAeLJXEnCnhkh26EnZGnam1cyd84a5LoFcEyMiw@mail.gmail.com>
Subject: Re: [PATCH 3.16 000/245] 3.16.83-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 1:03 AM Ben Hutchings <ben@decadent.org.uk> wrote:
> This is the start of the stable review cycle for the 3.16.83 release.
> There are 245 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Apr 28 18:00:00 UTC 2020.
> Anything received after that time might be too late.

Can you please add backports of the following patches? I asked for
that in <https://lore.kernel.org/stable/CAG48ez29d-JJOw8XMp1Z=7sDj8Kvmt+9KXC9-ux-0OBhUP02Xg@mail.gmail.com/>,
but I guess that fell through the cracks somehow.

8019ad13ef7f64be44d4f892af9c840179009254 "futex: Fix inode life-time issue"
8d67743653dce5a0e7aa500fcccb237cde7ad88e "futex: Unbreak futex hashing"

Can those still go into 3.16.83, or is it too late for that now?
