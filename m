Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6129C505ADB
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345298AbiDRPVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345335AbiDRPVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:21:00 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E84AC90D4;
        Mon, 18 Apr 2022 07:18:33 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r13so27115382ejd.5;
        Mon, 18 Apr 2022 07:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oOl2Vvn39de4P/DDrUZWEr84mmGT3rwLK0gEKwLAL8s=;
        b=feQ/p3x3itOtxrZySLUf9P1K/spqoY+VBwv9Mw7CupMcn5JjSmTKkUXI1XqY58sgaK
         ZE1a4kHzGa6udfdNlTfq8ZvlxxKfJ34i3sFiItah1UdF7QYBx3MWEYn/+HzMXV5uqaqN
         ZVb06EQfGacflVk1OY/RtH8iBal8ndnq1y+hNExQJoBbV9mSP0JccLpiqM8BISegKiRk
         5W6HOV0p2FgJWkxjRixrm2pMuPg/5LougDAkWMgIwChis5frWI0awCSL2kFuFtvSNttk
         qNh2QBxMtvahjsePbNKidSeD/M1+LRYKoHFKus6u1JO3L3O13UbYbAm8NqAmtldqDx4P
         PFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oOl2Vvn39de4P/DDrUZWEr84mmGT3rwLK0gEKwLAL8s=;
        b=8Edyc/UIioHPjn4Ui09moB/fTStNYNzjhX+jYNM8lfwenwj4ESFUvyD2qDDpLI29GU
         51G99pGePxl6K8U+B0yP3iX0o4O+HyOp0sgBca5oqkkeIaML6MG+lGPgbDN2Qu6ckqFW
         6JbK4CnHyH8MH2EodftV5bIbwIJBira0E9wYmn+wWKzIOP4EbbRNA4DoZrXICsJlG4d3
         c5W6hCoEb39Qi4gF8p9DcZNDqETyNA1IryNJhQeEexbQijCJSh9uYjI7X4X9OOCYRDfy
         f/2ToPb6QTrey6fJJbJLzQLT7bIOT+dMximovk6WjH3Xcv5cce/LU+EUO9os1W/8S7VW
         qPAA==
X-Gm-Message-State: AOAM532LtrZO4yIxNYe0ai/a7bDWszxNIVuVIGYQjc3PaaCwYZAIeiwU
        GP7WeQcJKqilngANndmuCo+T6Y1HGrGayLmU82dWIcfQILQdqg==
X-Google-Smtp-Source: ABdhPJxZqT8orVqZJEjJnG+1HrtAMGQsn7w9U6Xue8OXM1mLz/pcCdG0gxwym3p1qyPW5h99bK9s+W0vta9BrZJGeEQ=
X-Received: by 2002:a17:907:8a14:b0:6e8:9691:62f7 with SMTP id
 sc20-20020a1709078a1400b006e8969162f7mr9478736ejc.497.1650291511577; Mon, 18
 Apr 2022 07:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220414025705.598-1-mario.limonciello@amd.com>
 <20966c6b-9045-9f8b-ba35-bf44091ce380@gmail.com> <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
 <CAHp75VceVwAq68s_hnpXt8VvLBHVUMxFTJR+_Tnph_mvpxGVPw@mail.gmail.com> <49dceaa1-7e8a-671a-0601-2ee92a5d3818@leemhuis.info>
In-Reply-To: <49dceaa1-7e8a-671a-0601-2ee92a5d3818@leemhuis.info>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 18 Apr 2022 17:17:55 +0300
Message-ID: <CAHp75Vd1VKeGx2EJnKnSBf-DvnPPajDNs=+kQ1f6j5JU8hNLMg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        firew4lker <firew4lker@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Richard.Gong@amd.com, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 4:58 PM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> On 18.04.22 13:42, Andy Shevchenko wrote:
> > On Mon, Apr 18, 2022 at 7:34 AM Mario Limonciello
> > <mario.limonciello@amd.com> wrote:
> >> On 4/17/22 07:24, firew4lker wrote:
> >
> > ...
> >
> >> Linus Walleij,
> >>
> >> As this is backported to 5.15.y, 5.16.y, 5.17.y and those all had point
> >> releases a bunch of people are hitting it now.  If you choose to adopt
> >> this patch instead of revert the broken one, you can add to the commit
> >> message too:
> >>
> >> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976
> >
> > I prefer to explicitly tell that this is a link to a bug report, hence BugLink:.
> > But this is just my 2 cents.
>
> Please use "Link:" as explained by the kernel's documentation in
> Documentation/process/submitting-patches.rst
> Documentation/process/5.Posting.rst (disclaimer: I recently made this
> more explicit, but the concept it old). That's important, as people have
> tools that rely on it -- I for example run one to track regressions, but
> I might not be the only one running a tool that relies on proper tags.

To me it looks like a documentation confusion since Link is what is
added automatically by `b4` tool. Having Link from the patch thread
(and not always the one with the discussion) as well as link to the
issue will be confusing.

> And FWIW: I'm all for making this more explicit, but people already use
> various different tags (BugLink is just one of them) for that and that
> just results in a mess.

Nope, it results otherwise. The Link is Link to the thread, which you
may find a lot in the kernel history. Making bug report links and
links to the patch threads that's what results in a mess.

> I proposed consistent tags, but that didn't get
> much feedback. Maybe I should try again. Makes me wonder: where does
> BugLink come from? Is that something that people are used to from
> GitLab, GitHub, or something?

It comes from kernel history :-)


-- 
With Best Regards,
Andy Shevchenko
