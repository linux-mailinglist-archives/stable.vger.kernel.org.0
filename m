Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0D4B7D5C
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 03:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbiBPCCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 21:02:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241749AbiBPCCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 21:02:43 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D919F3B6
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 18:02:32 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hw13so1159760ejc.9
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 18:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oy1YM/HzNdw/9ZFVOisrJV7nT7HM/m+A2J2vkUwfDOQ=;
        b=iDyrMrL5USelID7ncCPEtS8P1iJHrYtWzRHFXvfjcLZ5sKzz5wxlqfs1s+VKuXUM0H
         bGgWxmr27jV9NoSeuAb37hoTBfjgUAEcN+piOHr3ZcSuFnR97cd0hhrJloCfcgTixOur
         HfqfFdKk1epCuLop7JuIGXVestj+xatWHY7ISqaz/6N/em25cnifpHZ2wJJzylKYRyTu
         cmgDwPQ03pVEoYZlthWznKxroxaO2hwI9DBAVajtQkJgG74Y8T96l69LJD2GcrrVjkER
         +KLdZqB8AenqHTaxBfKy9OGWUvnl8lk/n6FHGTEFnsOg8XpW7ayjvQjoRYt2nckqjUjf
         2gQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oy1YM/HzNdw/9ZFVOisrJV7nT7HM/m+A2J2vkUwfDOQ=;
        b=HY55inXpoKpasVYx4OeGZh+CBkQSR6LMx8xeta5IlrPeGh/x8WxSlQF/vi41OQRX1N
         warTFm0cc5p5/J92HFmiZ17I/pXwsBo9tzE1UTYJm2C4b/N3YOdHG6XlLFtfqTV+rZ35
         RQ/xJRMXRr0iUHp0Cc+Sl48mtzBPVwmu0E/JP0QGb5z93dFKxtJmvchwxN9uF/wilIfq
         wqvsqdd8tNL9ydz3r9CD2IYLFBQOOgc6H7HIThs0RSUjmZOr4NHXyo+pyHdZr9YhJZIO
         QTd0O9045vKx7127p2bfQnpkyPkr0IzrJ4dqjSrym5Ewt5l+/W4V+7HwS/zbkZGAzbiD
         1pJA==
X-Gm-Message-State: AOAM530K9iePINbtbxNejd0BDa33JF7aW0v+LPp83TwGXQ1MwGjLs8qD
        25mp7HfMM6gRkLonZzgqnK2mUuVfCOPq0fru9eCjTQ==
X-Google-Smtp-Source: ABdhPJyzj9PoOwCqscEDxQYrkHv3HVEzD3hy4Cgfik4tedxpf27fA2eNn7NTVcXO/NFhy7cKYusXyRRgUtlbqVzts2A=
X-Received: by 2002:a17:906:c12:b0:6cd:795c:9803 with SMTP id
 s18-20020a1709060c1200b006cd795c9803mr552433ejf.593.1644976950396; Tue, 15
 Feb 2022 18:02:30 -0800 (PST)
MIME-Version: 1.0
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com> <YgwCuGcg6adXAXIz@kroah.com>
 <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com> <066c9f4b-b0a3-9343-9db9-1c1c7303da6f@intel.com>
In-Reply-To: <066c9f4b-b0a3-9343-9db9-1c1c7303da6f@intel.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Tue, 15 Feb 2022 21:01:54 -0500
Message-ID: <CADyq12yuzOPbv+jrdhf8unzsifVXGw31LbW+Sh2tZ3qG=xjGjg@mail.gmail.com>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate inconsistency
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 4:42 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 2/15/22 13:32, Brian Geffon wrote:
> >> How was this tested, and what do the maintainers of this subsystem
> >> think?  And will you be around to fix the bugs in this when they are
> >> found?
> > This has been trivial to reproduce, I've used a small repro which I've
> > put here: https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
> > , I also was able to reproduce this using the protection_keys self
> > tests on a 11th Gen Core i5-1135G7.
>
> I've got an i7-1165G7, but I'm not seeing any failures on a
> 5.11 distro kernel.
>

Hi Dave,
I suspect the reason you're not seeing it is toolchain related, I'm
building with clang 14.0.0 and it produces the sequence of
instructions which use the cached value. Let me know if there is
anything I can do to help you investigate this further.

Brian
