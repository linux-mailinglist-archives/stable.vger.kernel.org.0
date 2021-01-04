Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6E12E96D0
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbhADOJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbhADOJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 09:09:22 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ABEC061795;
        Mon,  4 Jan 2021 06:08:41 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l23so10935487pjg.1;
        Mon, 04 Jan 2021 06:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vk8C9HoW2pvmUdV2sr6e7zZzLcVm9WJ4tIscz6SlA1k=;
        b=cD4XfqnRq1Ej9DBPW1so9hBX3Lx8ekvxk+tj1w7tvqIyuhg8mqCs3VFQ2zVsK0LysM
         HLGhaeGn3kXSV7443KGWOAXqkc7m2vm3r5RywkG8pEjdkS0Ui2udOiQt8n+dFVjq8FPW
         LeHe6nltRTjlNwe3lwgDZdNaXvIT/KuzR1yAZJTTif9NgcBypFyLXqHjka+0dlFHwo6V
         ui3vS6uiBCoBROOKf7gvS6GzbcN251aeQJxeopuzhQpSmkfIDY7wyP9A6s1b3dXTTEIP
         AZi+1D1hKEJodkks3esE+JYg/gYWN4PuU+oE/bkbTMemRGw++HELkLttbd/q5xJktIWQ
         gZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vk8C9HoW2pvmUdV2sr6e7zZzLcVm9WJ4tIscz6SlA1k=;
        b=g7kakHf+IJKPFgC6WfYHcDwpOtbt7o0CnYUQ6IFG2YyGfeyukpaSAsLfG+OhYF1AGi
         pC9IV2X9b72YSqA0budiNqsja289/zPXPEDnenYm43HzkdVbw+xtTh0L4BAess3+8Cga
         MPO3wiskOEIypsn9q9f6EozNPbGy4rnDrQeiY5Ek5NJjNTbYDvf65XAMmOYm4bV/Ef34
         aFHGU3Dp90TAc546GVw9bO8Wz0qc3fZPUvKZxS64L4Z/IxSeEqRtR/tfBBO/QPFXLION
         /QQQPDDTdXiAwDwst1jpkjmSNnPn6ChkIbDNTDZrxrORufUKXd7dS1+1IsLXAOatu0SN
         8Uig==
X-Gm-Message-State: AOAM530Hnhau0MJpNx8Sj+U3CRlOOqpoR/4P7JpsQ50Ca4mqDCtXQ2GA
        6FCZ+OaQSaDiSlXBaiLW2a3e7CYhH84s2WN4gYM=
X-Google-Smtp-Source: ABdhPJz3sGR57cWmWPiqGMfehlV2pOUP4d8PEdBjHsYs+Sw1WTYBKvQCVUFrnv+X+lyX1XQGHlmq562Fbl8zDHnMfc4=
X-Received: by 2002:a17:902:b7c3:b029:da:76bc:2aa9 with SMTP id
 v3-20020a170902b7c3b02900da76bc2aa9mr72963723plz.21.1609769321325; Mon, 04
 Jan 2021 06:08:41 -0800 (PST)
MIME-Version: 1.0
References: <20201223143644.33341-1-heikki.krogerus@linux.intel.com>
 <ae94a191-4273-0000-deda-4859034343b8@redhat.com> <20210104122343.GT4077@smile.fi.intel.com>
 <c59bb4a0-62bc-3390-dd29-758d415c59fa@redhat.com>
In-Reply-To: <c59bb4a0-62bc-3390-dd29-758d415c59fa@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 4 Jan 2021 16:09:30 +0200
Message-ID: <CAHp75VerY2PyBeRvv0kkDhthyko1V3di3EBALK6i-G29HYZgeg@mail.gmail.com>
Subject: Re: [PATCH] ACPI / scan: Don't create platform device for INT3515
 ACPI nodes
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Moody Salem <moody@uniswap.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 4, 2021 at 4:01 PM Hans de Goede <hdegoede@redhat.com> wrote:
> On 1/4/21 1:23 PM, Andy Shevchenko wrote:

...

> > I'm wondering if my reply has been seen...
> >
> > https://lore.kernel.org/platform-driver-x86/ae94a191-4273-0000-deda-4859034343b8@redhat.com/T/#m30308ca22cd0ce266aa6913ab7ef1fc56b3279de
>
> Yes I've done the s/Link/BugLink/ in the commit msg and fixed up the
> typo-s in the comment block locally. I should have mentioned that in
> my reply instead of just blindly using the template-reply which I have for
> this, sorry; and thank you for the review.

Ah, thanks!
No problem.

-- 
With Best Regards,
Andy Shevchenko
