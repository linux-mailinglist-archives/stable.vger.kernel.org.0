Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA5C6663C2
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 20:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjAKT3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 14:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbjAKT3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 14:29:34 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAC7DFDB;
        Wed, 11 Jan 2023 11:29:33 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bu8so25070625lfb.4;
        Wed, 11 Jan 2023 11:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nh+HWu2JgroWbtQ9Z9rpBoFsAPaIHouSCQ8ia9uxj5A=;
        b=bnd73aiQkqW9SWCuYjanI6LTSYxdJUcUYM2p1bIl7Uov3SzLCCKDcnlDNjNu9vd/TG
         SsAUx4/kkYktlnHiWcQUd8EoadD78NgZkrpcOOAh27jYVuGf+KVwO4IQg4vvHrb0SIdy
         5tkigPSrlcCcc+tHMg/pm8W4pqT/5BevqB+1yLufe7hnXsFRvb/f9PGnkKLgMsUYqQFv
         y918YZUTqQ0ZgruJlb9ulWP0XtleP9+YJeIZeBaSXFFBBm54e6uYRL58ZOWadkyVpeLE
         dIOPffl4aN9J6UMWCsF1VJz2E+4a7fxzM7HJZAjvlPCEOwHA2uB8lDU/S3eBBpK6gcfY
         hQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nh+HWu2JgroWbtQ9Z9rpBoFsAPaIHouSCQ8ia9uxj5A=;
        b=zg1gTLTKZSt9JTQnAIWXJY32Nb3nCPQsASzq7nUl3syXi0AFT9M9O9SQvOCHnZWcc4
         JfmaVQppeWo15j0/2TMm1WxFlVLnydrrX90jp+Tlj42811+gNkhzKbYMwY6b6P7+2OCV
         tFEqqNcOCmnwLQuDrMydV4b+zLZNK2ZTD3TFF1Rj6pelurFu5DERE4ZhrVP2UnmuLmlS
         wf3lBGKLERsc/pibUhogf8Xyd+l87n5SbE8f7l6jM+BliN10hTXJANnEl9P1reTTJuPE
         f1iPqM2i4t1rI6TeNugUPVbobpLiQBfd+u4p1xBFYz7p8nseY/02xU5qyPcIE6xAjCW7
         ikBg==
X-Gm-Message-State: AFqh2kpo3fMYKxs4UIebhus2fx7rllqbZmmEVw1tB6QJJWVsvZoLn1li
        aR50AqVqEStT2hGSXWG8URQwyPJyqDaM3nsOYkBb6YY9
X-Google-Smtp-Source: AMrXdXuDhAip91DCYumXLyACGXv2rUJdTZOyeROJDFlZjQpZOAbOlCcEn6ZG0Ii5xzfm0NNqoVWKAQebf9YVi5ESsKM=
X-Received: by 2002:a05:6512:238b:b0:4b3:9d5f:e405 with SMTP id
 c11-20020a056512238b00b004b39d5fe405mr3519187lfv.428.1673465371935; Wed, 11
 Jan 2023 11:29:31 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUUYrasObBwMQWae=+eAfUzvxc1Pk39QFz9=NXedWO41Vg@mail.gmail.com>
 <Y75E8Y7FPGjxL0xx@kroah.com>
In-Reply-To: <Y75E8Y7FPGjxL0xx@kroah.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 11 Jan 2023 20:28:55 +0100
Message-ID: <CA+icZUXJG+jgoQKdGvz7=kfAWRnpXgbF3SJOhO4GXH7PHp5FTA@mail.gmail.com>
Subject: Re: Please, clear statement to what is next LTS linux-kernel
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, helpdesk@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Larabel <Michael@michaellarabel.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023 at 6:11 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 10, 2023 at 09:22:48PM +0100, Sedat Dilek wrote:
> > Happy new 2023,
> >
> > I normally watch [1] for the next LTS linux-kernel which is for me an
> > official site and for an official announcement.
> >
> > On the debian-kernel mailing list you read Linux 6.1 will be the
> > official one for Debian-12 aka bookworm.
> >
> > I saw a phoronix article about EOL of Linux-4.9 [3] which points to [2].
> >
> > [2] says:
> >
> > After being prompted on the kernel mailing list, Linux stable
> > maintainer Greg Kroah-Hartman commented:
> > > I usually pick the "last kernel of the year", and based on the normal release cycle, yes, 6.1 will be that kernel.
> > > But I can't promise anything until it is released, for obvious reasons.
> >
> > This is not a clear statement for me and was maybe at a point where
> > 6.1 was not released.
> >
> > If you published a clear statement please point me to it.
> > And if so, please update [1] accordingly.
> > ( It dropped 4.9 from LTS list recently from [1] - guess Konstantin or
> > someone from helpdesk did - so [1] is actively maintained. )
> >
> > Please, a clear statement.
>
> Why exactly do you need a "clear statement"?  What will that change (or
> not change) if it is made?
>
> Please see this previous thread for what I need from others before I can
> make such a thing:
>         https://lore.kernel.org/r/Y53BputYK+3djDME@kroah.com
>
> Can you help answer those questions for your use case please?  That will
> help us make our decision.
>

You made a clear statement: There was NO decision made for a new LTS kernel.
Stand: 11-Jan-2023 Linux 6.1 is NOT an LTS kernel.

Thanks.

Best regards,
-Sedat-
