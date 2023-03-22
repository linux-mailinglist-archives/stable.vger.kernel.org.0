Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874DB6C4045
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 03:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjCVCU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 22:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCVCU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 22:20:27 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DF84DBFA;
        Tue, 21 Mar 2023 19:20:26 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id f14so7855139iow.5;
        Tue, 21 Mar 2023 19:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679451626;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LoYhF+v3FctdaWwoqqIIS1qqDpKm5L/AMYSClAzsXQw=;
        b=aEviMH7nUPuN7OK3kZYZEZ2e4laI65KPQ814H3yNXG+Rbu5Bc6+C/k6qRJXVxe8VpC
         ZKnjY1Qw8xcPHoGXqzRjqJlvwi5Cb52rKRLUNyUlyMe8c4HApghxE+woWgvZZ4ZpURsd
         Z8SvTPJNWfsAsCWyvTh8cHvN89tk397rMLFyykmZ1awvz0sMYVveMM5kapKmech5Q88B
         MwF5FZY2B/GdPP5v+ptOnd1R6nM7rcWS7CrOUjUxx8IoBxfR472C3uqaPoCUxYgDBVq9
         VdSEoYhp4ELoUTL4o7vVLbjIgEFKTUdRmg6UrS13t4l8QkcrG6Ztbe7BS99CVyue5TkA
         ealQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679451626;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LoYhF+v3FctdaWwoqqIIS1qqDpKm5L/AMYSClAzsXQw=;
        b=lVzJSXaHm4susmuMKn5LtZ0DKk1PGKaD5zLvxTG4PK4RNvURBuz+YRrsUwYbMV2ABQ
         WaWNV2ybcXdvrFX8dccKq41FY+HsOBA9WkojVKPvLAmfjwDefYuIu0sWAr743Iekb+tJ
         28YNfpOysmIuKm/l6i32CpRgBEYfIkw20I6xhyzOHaogmCHVglR71R/nlkItJso04+U4
         HIY8hi6vyYUr3R2YrDBhGgtXsc9q+GLeu4LpmQ8+eYSMuE3V89IZygMsx27NKRgxeuX2
         jodTF+8bNYCnyboQnYQQ/6+MzKYDEvBJIQch0sD8sT0oEhdO1YMJ+SnBJMQAxQtVyksS
         FrYA==
X-Gm-Message-State: AO0yUKWhO1eJ6JjC8y+oqmibYetOdntvkWz9NMputMwhpkz9WHs2p/eb
        61vSB6M7i05j2T2wfo6PywQne/BIA6Y=
X-Google-Smtp-Source: AK7set/C/SfWxGH1Sp8hVcBJxUsvqRvc0/EhaVW0OtF5hv+jZrDCS2QDMJlMqIjanUenH01tcyHhIA==
X-Received: by 2002:a5e:c605:0:b0:753:13ec:4ba with SMTP id f5-20020a5ec605000000b0075313ec04bamr3527548iok.4.1679451626214;
        Tue, 21 Mar 2023 19:20:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z18-20020a5e8612000000b0074ce0b89a37sm4083370ioj.1.2023.03.21.19.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 19:20:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Mar 2023 19:20:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Xi Ruoyao <xry111@xry111.site>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, loongson-kernel@lists.loongnix.cn
Subject: Re: [PATCH] LoongArch: Check unwind_error() in arch_stack_walk()
Message-ID: <b4592fa4-35ec-4062-b965-962fc1ea12f6@roeck-us.net>
References: <1679380154-20308-1-git-send-email-yangtiezhu@loongson.cn>
 <253a5dfcb7e41e44d15232e1891e7ea9d39dc953.camel@xry111.site>
 <f61ac027-0068-40f0-87bd-17f916141884@roeck-us.net>
 <CAAhV-H5kFRt9z0U_TqSQeqX9WuUJ2cg0LOboUXHp-fLR0PoTJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H5kFRt9z0U_TqSQeqX9WuUJ2cg0LOboUXHp-fLR0PoTJg@mail.gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 08:50:07AM +0800, Huacai Chen wrote:
> On Tue, Mar 21, 2023 at 10:25 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On Tue, Mar 21, 2023 at 08:35:34PM +0800, Xi Ruoyao wrote:
> > > On Tue, 2023-03-21 at 14:29 +0800, Tiezhu Yang wrote:
> > > > We can see the following messages with CONFIG_PROVE_LOCKING=y on
> > > > LoongArch:
> > > >
> > > >   BUG: MAX_STACK_TRACE_ENTRIES too low!
> > > >   turning off the locking correctness validator.
> > > >
> > > > This is because stack_trace_save() returns a big value after call
> > > > arch_stack_walk(), here is the call trace:
> > > >
> > > >   save_trace()
> > > >     stack_trace_save()
> > > >       arch_stack_walk()
> > > >         stack_trace_consume_entry()
> > > >
> > > > arch_stack_walk() should return immediately if unwind_next_frame()
> > > > failed, no need to do the useless loops to increase the value of
> > > > c->len in stack_trace_consume_entry(), then we can fix the above
> > > > problem.
> > > >
> > > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > > Link: https://lore.kernel.org/all/8a44ad71-68d2-4926-892f-72bfc7a67e2a@roeck-us.net/
> > > > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > >
> > > The fix makes sense, but I'm asking the same question again (sorry if
> > > it's noisy): should we Cc stable@vger.kernel.org and/or make a PR for
> > > 6.3?
> > >
> > > To me a bug fixes should be backported into all stable branches affected
> > > by the bug, unless there is some serious difficulty.  As 6.3 release
> > > will work on launched 3A5000 boards out-of-box, people may want to stop
> > > staying on the leading edge and use a LTS/stable release series. We
> > > can't just say (or behave like) "we don't backport, please use latest
> > > mainline" IMO :).
> >
> > It is a bug fix, isn't it ? It should be backported to v6.1+. Otherwise,
> > if your policy is to not backport bug fixes, I might as well stop testing
> > loongarch on all but the most recent kernel branch. Let me know if this is
> > what you want. If so, I think you should let all other regression testers
> > know that they should only test loongarch on mainline and possibly on
> > linux-next.
> This is of course a bug fix, but should Tiezhu resend this patch? Or
> just replying to this message with CC stable@vger.kernel.org is
> enough?
> 

Normally the maintainer, before sending a pull request to Linus, would add
"Cc: stable@vger.kernel.org" to the patch. Actually sending the patch to
the stable@ mailing list is only necessary if it was applied to the
upstream kernel without Cc: stable@ in the commit message.

Guenter
