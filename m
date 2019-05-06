Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80202150DE
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 18:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfEFQF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 12:05:27 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:33391 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfEFQF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 12:05:27 -0400
Received: by mail-ua1-f66.google.com with SMTP id 49so1448788uas.0
        for <stable@vger.kernel.org>; Mon, 06 May 2019 09:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rRFFU8Q/jQghW94GutkX/fzbuY9dKYgOCq1w5lys5os=;
        b=h2G+g0f5qcaSkmO+aIkatHsodbmhrHyNCkxJUs1xGr5Fil8QSPcy2zpt/dYAmSjtoo
         qNZIeF/MEpm8x3u4dQZ5NOzIxeuDUCemWdlh05SkylMyMccltrh9MUUIjiqdtgdyeb0D
         x9EtOIkulHA5fOCXhXBT9wjgf5lZuGNPbi4BE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rRFFU8Q/jQghW94GutkX/fzbuY9dKYgOCq1w5lys5os=;
        b=IpotecH4qbVrsQ9NkW2n+q4L5l3qXVHEHxBdC2nwY55y/J1mjZt7wysQ5i6ZqE2PZw
         uxuznz6Kghfu1uz/y0AhYPIbykJD7ioNWeZwoMfL7HpE++lYpC/f69Fv6dwaUPRb0KFJ
         yVXDvXOSmyekAA9G1xgW7XXl1fG6PUhSnvjm4UDUZ7OTew3DuvatsiZ9Hftzsndh2DoL
         tbn+Nz+eiGb8CQvT5ea9HP5kxCkVQ0gAxftTOCGRwRypmduwtC+7uJYWjKwnPbrCT3WD
         wdgthT3bSisJ6NWE6iGzU3A0ypdXRW6LB4dw7SZnttjOB1zz6rO0d6dWCnB4XpSJFpFH
         klkw==
X-Gm-Message-State: APjAAAVFPcmgxoMYZ1NXqVUa5E0VQnwY8irANuqS/46BjYKwUA8pLFgR
        g214SA0R3vGMWjvXcaBkGmCSSL3o/u0=
X-Google-Smtp-Source: APXvYqz8lahPfd3zeWD1Wyg9SCf12JCRQy+w1iHFiHzA8rN8kxNvigrajPojEE7hiKUMMpbxA92Nzg==
X-Received: by 2002:ab0:664e:: with SMTP id b14mr14634uaq.97.1557158725273;
        Mon, 06 May 2019 09:05:25 -0700 (PDT)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id 8sm2969078vkw.38.2019.05.06.09.05.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 09:05:24 -0700 (PDT)
Received: by mail-ua1-f53.google.com with SMTP id 94so2588955uaf.10
        for <stable@vger.kernel.org>; Mon, 06 May 2019 09:05:24 -0700 (PDT)
X-Received: by 2002:ab0:d89:: with SMTP id i9mr13008936uak.96.1557158723903;
 Mon, 06 May 2019 09:05:23 -0700 (PDT)
MIME-Version: 1.0
References: <20181018185616.14768-1-keescook@chromium.org> <20181018185616.14768-3-keescook@chromium.org>
 <CAM0oz-91yjPQKnxGDjwFThs19U=+iziuUr=9z13NSibr_uRxZQ@mail.gmail.com>
 <20190505131654.GC25640@kroah.com> <CAD=FV=UV7x-qJU86MzHxY8bqDV7rcc3XoyotKyy_+1MpMM22bA@mail.gmail.com>
 <CAGXu5jKzH0Ttdtp5bXP_EAfp+fA+tEQwLXh=VmZ1r5q6wdpqaw@mail.gmail.com>
In-Reply-To: <CAGXu5jKzH0Ttdtp5bXP_EAfp+fA+tEQwLXh=VmZ1r5q6wdpqaw@mail.gmail.com>
From:   Kees Cook <keescook@chromium.org>
Date:   Mon, 6 May 2019 09:05:12 -0700
X-Gmail-Original-Message-ID: <CAGXu5jKtteYVhB=jpjBBkGqW5_XK=zpCP24Fj+mM0L8RBnhh=A@mail.gmail.com>
Message-ID: <CAGXu5jKtteYVhB=jpjBBkGqW5_XK=zpCP24Fj+mM0L8RBnhh=A@mail.gmail.com>
Subject: Re: [PATCH pstore-next v2 2/4] pstore: Allocate compression during late_initcall()
To:     Doug Anderson <dianders@chromium.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Doug said:
> > > > I'd propose that these three patches:
> > > >
> > > > 95047b0519c1 pstore: Refactor compression initialization
> > > > 416031653eb5 pstore: Allocate compression during late_initcall()
> > > > cb095afd4476 pstore: Centralize init/exit routines

Okay, confirmed. These look sufficient to me, and the resulting tree
passes my pstore tests. Greg, can you please pull these into 4.19?

Thanks!

-- 
Kees Cook
