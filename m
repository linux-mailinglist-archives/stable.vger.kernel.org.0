Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E29823E2E3
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 22:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHFUKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 16:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgHFUKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 16:10:35 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22331C061574
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 13:10:35 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id z26so8925273uaa.4
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 13:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w3vwUVs19vIEjWfyfpOeOe4lGyH2nlye5ZP+rs9rBEc=;
        b=bIRXS68h6i679hB3/SfWEVWF6Df4eW/+UznxGvkKqe4XMHBmUl76cokIPxFPlBfpL5
         uSnk7z6y7Hb7lzN/4lOzGuqSBhCfp2fuTxjQBK5h1m513Asz3f0qzg7z2kXQqqX/IR0+
         vDfgFTBwRSfoXvGQcLIk71MNV91B4wRASLnMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w3vwUVs19vIEjWfyfpOeOe4lGyH2nlye5ZP+rs9rBEc=;
        b=mvg0v90AYwIL67TGFopayKCPfcmZuJMg3FcMmYcf/4PT0GKJs3alBe58uSGp1hpRkd
         UfBjljyca5iEOkZfetbvjluRTI+FZMW829kRbDsOm7H6P+SHrvoEf0Wh9oOdArEdJEQE
         +gJQQfbeRbI+pOsO/fHT0x+ctBScBm3870BlQnxtlHSIr4TLyF4Qr2BPIr2qWr839/By
         1wmTSn6dt2GO5sOUiCAAzp6Nz70g/cjYtuJDOil0+B+o66jWaaM8Im+12EN8fNv9IIaJ
         8RL3LzfaC7GjHe28gJefJt4Fdy/JVgRQOMyoebpBoSizvawo7KDwJppuVrsd+PBw7+a1
         g13w==
X-Gm-Message-State: AOAM530+DnKuMffHfR5C1ncK6Zjfhs5Kgr1Z8gup3oH7fVvv1b2Bw6ez
        dPqKYFgW4sATX3cR8mzGCsNZmmHfaQY=
X-Google-Smtp-Source: ABdhPJx9tiqH+b4sRskfpYLRU1CTkxXnsZtWH5rrocvmQbY6HUW17kpqlpprBj7oWQC5rX+m67FhKw==
X-Received: by 2002:ab0:5b91:: with SMTP id y17mr8223786uae.95.1596744634160;
        Thu, 06 Aug 2020 13:10:34 -0700 (PDT)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id k16sm1086951vsg.26.2020.08.06.13.10.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 13:10:33 -0700 (PDT)
Received: by mail-ua1-f52.google.com with SMTP id q68so12047304uaq.0
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 13:10:33 -0700 (PDT)
X-Received: by 2002:ab0:22c9:: with SMTP id z9mr7910964uam.0.1596744633145;
 Thu, 06 Aug 2020 13:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200720152803.732195882@linuxfoundation.org> <20200720152806.931980695@linuxfoundation.org>
 <20200722120930.GB25691@duo.ucw.cz>
In-Reply-To: <20200722120930.GB25691@duo.ucw.cz>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 6 Aug 2020 13:10:21 -0700
X-Gmail-Original-Message-ID: <CAD=FV=V53j6h-RAA9xpoj2BBUVOJa=3hH85rnm=0Mh7WnQHMog@mail.gmail.com>
Message-ID: <CAD=FV=V53j6h-RAA9xpoj2BBUVOJa=3hH85rnm=0Mh7WnQHMog@mail.gmail.com>
Subject: Re: [PATCH 4.19 066/133] regmap: debugfs: Dont sleep while atomic for
 fast_io regmaps
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Jul 22, 2020 at 5:09 AM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > From: Douglas Anderson <dianders@chromium.org>
> >
> > [ Upstream commit 299632e54b2e692d2830af84be51172480dc1e26 ]
> >
>
> > +     err = kstrtobool_from_user(user_buf, count, &new_val);
> > +     /* Ignore malforned data like debugfs_write_file_bool() */
>
> > +     err = kstrtobool_from_user(user_buf, count, &new_val);
> > +     /* Ignore malforned data like debugfs_write_file_bool() */
>
> I guess that should be "malformed" in both cases.

Sure.

https://lore.kernel.org/r/20200806130222.1.I832b2b45244c80ba2550a5bbcef80b574e47c57e@changeid


> Plus it would not be bad to share code between those two functions, as
> they are pretty much identical...

I took a quick attempt at it and it seemed slightly worse to me when
they shared code, at least if we wanted to keep the behavior
identical.  For me it was the extra ": syncing cache" part of the
message in one of the two functions that pushed it over the edge.
Specifically if we wanted to keep that we'd have to do one of these:

a) Keep the printing out of the common code, but then the common code
is really small.

b) Add a special parameter to the common code named something like
"do_sync_if_val_becomes_false"

c) Pass some extra string named something like
"append_to_log_message_in_no_case", then do the actual sync outside of
the common code.

That being said, if you want to try to make these two functions use a
common helper and everyone thinks it's better that way then I won't
stand in your way.

-Doug
