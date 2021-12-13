Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4639472AEB
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 12:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhLMLJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 06:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhLMLJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 06:09:28 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55499C061574;
        Mon, 13 Dec 2021 03:09:28 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id w1so50594303edc.6;
        Mon, 13 Dec 2021 03:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rV3FydouJ/520IXWxfP8bQLpDyzw093oB7PRel5o028=;
        b=DSK8o/1487FvtHnh+KfrTQKOR7NMjCaF547LkPg+Kop47B8qkOaiTs8VmKsLWOmO5a
         6ixOh8UmCDhK9G4oOdBhm7tco6g2NI0hP4Liy3PPwubsUXjlUkatObk0Z/njXBke6R3u
         YpAzGd0nuCILRkVrK6afqnr2EG5VUlKZWW8btqhOXHVNmgtgzs0l5lB4iqRYhMWz6gS/
         7U6j1Guxq54byE1MUVhwcbHzHUsw6ORyZYvdTLhCKZayVfkvVC9gAb7Dj1/ZGl8oRS6a
         5jvPqrzYpGqFlf3kE7OzKWlvFMpWPNw3BjESsvZhLBuJRXeOJ+2SRLqk5la0JiVk2SWE
         uMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rV3FydouJ/520IXWxfP8bQLpDyzw093oB7PRel5o028=;
        b=SNnpvhYy7TiOs0wOU/AWvZiv8HIX5AmC/v7Vw+xtHvi4xpJCAqjDAr+0GHb0Iplkhn
         d8fKbvShHMgkimRrstVOD6q0aKysGV4YfTQudiDe5owinD7qurJu/vhlcusY14/ZX2jw
         pzFTIT84ekr8zCP/pOlzNjtkqNN5KtgtMqym3k6ICvXxR+M4ZzLy9fa2uPu9Xhdg1hIy
         7VW+iCIc1hyStO11s+ZUVBS7vGf9hlh/5jGS3dDwRZTzXU6jnQxRjVowjyV/5csL8dFx
         A5EqcsCWi8QXlIjXnd/FzAcfZb8CFzrjnIyiK3zvgpjuKFm/eu3QC2GzTl+8KecGQJyn
         l3hA==
X-Gm-Message-State: AOAM531Jh0i62y4yMW2myM+q9Xmy9r7vXKeFt4XaLr/zEkEc/gDY3XfF
        xVJxGVurYkiY2B3qwaCAoSGZte9Ale/pyLhRugg=
X-Google-Smtp-Source: ABdhPJzMTTA9VeDAxXIMMv1aO7DUWUr1wL78KcYtzL27yYLBu4wWycHO4vM2ODiUDDFX2V58fsB8P1FPrY88HJcHoW0=
X-Received: by 2002:a05:6402:291:: with SMTP id l17mr63905473edv.242.1639393766938;
 Mon, 13 Dec 2021 03:09:26 -0800 (PST)
MIME-Version: 1.0
References: <20211210143529.10594-1-mario.limonciello@amd.com> <CAHp75VfkK++Knyj1D85BbJQL_AYhByAN-wQcH6qfKgC8O1CZ=Q@mail.gmail.com>
In-Reply-To: <CAHp75VfkK++Knyj1D85BbJQL_AYhByAN-wQcH6qfKgC8O1CZ=Q@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 13 Dec 2021 13:07:56 +0200
Message-ID: <CAHp75VdWLGi5g8UeJEPZoWvQrtyOeTc1LXotGTRrKUeK_-2C+w@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        "open list:X86 PLATFORM DRIVERS" 
        <platform-driver-x86@vger.kernel.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 1:07 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Dec 10, 2021 at 9:06 PM Mario Limonciello
> <mario.limonciello@amd.com> wrote:

...

> >  static const struct dev_pm_ops amd_pmc_pm_ops = {
> > -       SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(amd_pmc_suspend, amd_pmc_resume)
> > +       .suspend_noirq = amd_pmc_suspend,
> > +       .resume_noirq = amd_pmc_resume,
>
> Can you simply switch to SET_NOIRQ_SYSTEM_SLEEP_PM_OPS()?

My gosh, I see that it was like this... Sorry for the noise.

> >  };

-- 
With Best Regards,
Andy Shevchenko
