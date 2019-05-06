Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3A81506A
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfEFPjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:39:14 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42420 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfEFPjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 11:39:14 -0400
Received: by mail-yw1-f67.google.com with SMTP id s5so4114960ywd.9
        for <stable@vger.kernel.org>; Mon, 06 May 2019 08:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QtAJPN/issoSyhS/fgMnZjKOMoByFNd896NEgVmz7Sk=;
        b=CSEZ6JriGjyK0yC7LNrSbJ8jsF+V8BRrTJiBaphVlBHApmR6rkiSmNPdNBjW+QVrt4
         M2VA9VdcrG1TjhjDBoH1LrBuX8uluKdfQqDhJWj1VR6HqGiHFl6GkSeaAlI6o8Tjzw4K
         fTcjSZ0ov9kUnM5JDOJeCeL6Lnwj2BR2MHJdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QtAJPN/issoSyhS/fgMnZjKOMoByFNd896NEgVmz7Sk=;
        b=VcRCvB5vCTpFnVrz1YztQdIPiEr+yJ530BkV7PyPvJmH2xp6v1Sdx+yqbsNwB5fcFj
         TCfeSbS604gs2OAuoL5BXH27GTEhnzyXXldqUKCp4g3QhRIww16XQkvnpfDk527NOld3
         f/o047XJafnOkjV9sqi9nZks8HaLbLzvQAG+hDTp10Sfx3MiaoB0wCK1zKTrDEpHcp8Y
         ifwXxd04NnruyVMt2/FXyQnERPmJNBkOqcTXXnDYRnkAbADZZv7ipbqlrnBNiVC3zrEh
         dZclY+KKH2DQRqWf2F/PHOcV4uqNZ1KUW5mgUj2xNJUkU819w0VYwAHenNA21vPmbFm3
         tjEA==
X-Gm-Message-State: APjAAAWC6a096/nZkcl6KcfP6TmpZf7oVCJ0zbnUqfHBYG3fjLFehgdM
        LpE+tyoChqzXPNQctEzFIIkeVkb4sME=
X-Google-Smtp-Source: APXvYqyLSfuywQ5lXgkg4Tawa6XuKQqjGu+MwKwDiCl6N7/jBYHKCAN+egJtyao8UDkbPCvwih7DJw==
X-Received: by 2002:a25:d289:: with SMTP id j131mr17133183ybg.289.1557157153027;
        Mon, 06 May 2019 08:39:13 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id v144sm3064174ywv.15.2019.05.06.08.39.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 08:39:11 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id q185so10680059ywe.3
        for <stable@vger.kernel.org>; Mon, 06 May 2019 08:39:11 -0700 (PDT)
X-Received: by 2002:a0d:ca47:: with SMTP id m68mr5699628ywd.229.1557157151272;
 Mon, 06 May 2019 08:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20181018185616.14768-1-keescook@chromium.org> <20181018185616.14768-3-keescook@chromium.org>
 <CAM0oz-91yjPQKnxGDjwFThs19U=+iziuUr=9z13NSibr_uRxZQ@mail.gmail.com>
 <20190505131654.GC25640@kroah.com> <CAD=FV=UV7x-qJU86MzHxY8bqDV7rcc3XoyotKyy_+1MpMM22bA@mail.gmail.com>
In-Reply-To: <CAD=FV=UV7x-qJU86MzHxY8bqDV7rcc3XoyotKyy_+1MpMM22bA@mail.gmail.com>
From:   Kees Cook <keescook@chromium.org>
Date:   Mon, 6 May 2019 08:38:57 -0700
X-Gmail-Original-Message-ID: <CAGXu5jKzH0Ttdtp5bXP_EAfp+fA+tEQwLXh=VmZ1r5q6wdpqaw@mail.gmail.com>
Message-ID: <CAGXu5jKzH0Ttdtp5bXP_EAfp+fA+tEQwLXh=VmZ1r5q6wdpqaw@mail.gmail.com>
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

On Mon, May 6, 2019 at 8:16 AM Doug Anderson <dianders@chromium.org> wrote:
>
> On Sun, May 5, 2019 at 6:16 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, May 03, 2019 at 11:37:51AM -0700, Douglas Anderson wrote:
> > >
> > > On Thu, Oct 18, 2018 at 11:56 AM Kees Cook <keescook@chromium.org> wrote:
> > > >
> > > > From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> > > >
> > > > ramoops's call of pstore_register() was recently moved to run during
> > > > late_initcall() because the crypto backend may not have been ready during
> > > > postcore_initcall(). This meant early-boot crash dumps were not getting
> > > > caught by pstore any more.
> > > >
> > > > Instead, lets allow calls to pstore_register() earlier, and once crypto
> > > > is ready we can initialize the compression.
> > > >
> > > > Reported-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
> > > > Fixes: cb3bee0369bc ("pstore: Use crypto compress API")
> > > > [kees: trivial rebase]
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > > >  fs/pstore/platform.c | 10 +++++++++-
> > > >  fs/pstore/ram.c      |  2 +-
> > > >  2 files changed, 10 insertions(+), 2 deletions(-)
> > >
> > > I'd propose that these three patches:
> > >
> > > 95047b0519c1 pstore: Refactor compression initialization
> > > 416031653eb5 pstore: Allocate compression during late_initcall()
> > > cb095afd4476 pstore: Centralize init/exit routines
> > >
> > > Get sent to linux-stable.  Specifically I'll mention that 4.19 needs
> > > it.  IMO the regression of pstore not catching early boot crashes is
> > > pretty serious IMO.
> >
> > So just those 3 commits and not this specific patch from Joel?
>
> The middle commit ("pstore: Allocate compression during
> late_initcall()") is ${SUBJECT} patch and the one with the "Fixes"
> tag.
>
> The first commit ("pstore: Centralize init/exit routines") is needed
> to apply the middle commit.
>
> I haven't done lots of analysis but the last commit ("pstore: Refactor
> compression initialization") sure looks like it's important if you
> have the middle commit.  Specifically the middle commit allocates the
> compression earlier and the last commit says that it improves handling
> of this situation.
>
>
> Unless someone thinks otherwise, it seems best to apply all 3?

At first glance, yes, but let me double-check it this morning. There
were some subtle changes that made me not initially want to backport
these, but it should be doable. :)

-- 
Kees Cook
