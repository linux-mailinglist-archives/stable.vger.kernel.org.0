Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9544BA140
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 14:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiBQNcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 08:32:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbiBQNcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 08:32:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C063DECB3C
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 05:31:50 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id h18so9646270edb.7
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 05:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B0M/IeDIZGDcjbJ+9jtwyMZRbiHqmRKaJeE0g2p7LE4=;
        b=EcO/f6Ht5+dpl6IvTJTBMSv3SiVfR0UbSXtnhj76Rm8qfUeUWKPvAkaw/yX3GVPcs4
         VkU/hBPdgZxB448qYxGahx6hEj2NnLDW5/8WRTE50C6q6pDcanFpnv0Sn8iHqQhouK2U
         8/QJuyK0Pv9MSmWICgutOvhlLrDv2++0a9EIPsKFss6wpT9YPqVAzfRDK4pEp39DIfBe
         guhZsQxb2H8l56cLwclMKHaerODFXqdEoInf2OQZFwggBDthun7OJg4H6UQjrNQyGXEQ
         cxJG+bfK96XlCfJ4nZDusI7G3GtmGsm4NL2m8CdHG/s+vhvF8RjwApKeWa3gidQW3iYd
         qezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B0M/IeDIZGDcjbJ+9jtwyMZRbiHqmRKaJeE0g2p7LE4=;
        b=fEqzI4awpvO+gQl3EOT8vxNHNO3NRiSOyQXbKRyTbqKvTwL9HB0IQfi25a9+Ck8OLQ
         KeKyDFQYKXEflhqDDI1Ja/Jyr5DweFt6KGaV6XVDyIPfOgKdWe8vs4ipmpzutmZeqjju
         uSNJ42/CkmTjeF0Flr2f1iyy/gBUDEvDKmbXLswxeXlUjF4xih3r6e9li3LJgX9FpsoD
         RCIhf2APqwa9W4IRO1DCH6qoAEemDTyvaLdmLD8KAPWxlcMlrBSUaA7/XJfSirUTLRc/
         s3wPDzplZ6JkmU6+f+/+OLmnpfTtaJDogGNKAbFNpK/UuHP2VVaua6fi9AzqGmO6Kga5
         qCLg==
X-Gm-Message-State: AOAM532Afl3ENQVU7NW69+WweoqsUGW2S5yYLHrv8kXVX3Ial+ngBzy0
        pcq5NP/0aRyK2ZcO/mEJVz6q9HtZL3XatUPoG08Cfg==
X-Google-Smtp-Source: ABdhPJy2VS2aswdOO3DumeVi/SW/abrgycj4jXJPEjtyYzCgFJSj6xjCtQrAxiqrFht8TNaoQkT6V6rZJhZEgXHrFF4=
X-Received: by 2002:aa7:d8cb:0:b0:406:3135:51c7 with SMTP id
 k11-20020aa7d8cb000000b00406313551c7mr2504206eds.233.1645104709080; Thu, 17
 Feb 2022 05:31:49 -0800 (PST)
MIME-Version: 1.0
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com> <YgwCuGcg6adXAXIz@kroah.com>
 <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
 <YgzMTrVMCVt+n7cE@kroah.com> <fc86d51c-7aa2-6379-5f26-ad533c762da3@intel.com>
In-Reply-To: <fc86d51c-7aa2-6379-5f26-ad533c762da3@intel.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Thu, 17 Feb 2022 08:31:12 -0500
Message-ID: <CADyq12yGvqbb3+hp6f39RqyEM3Mu896yY6ik7Lh39W=o44bYbA@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 10:16 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 2/16/22 02:05, Greg KH wrote:
> >>> How was this tested, and what do the maintainers of this subsystem
> >>> think?  And will you be around to fix the bugs in this when they are
> >>> found?
> >> This has been trivial to reproduce, I've used a small repro which I've
> >> put here: https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
> >> , I also was able to reproduce this using the protection_keys self
> >> tests on a 11th Gen Core i5-1135G7. I'm happy to commit to addressing
> >> any bugs that may appear. I'll see what the maintainers say, but there
> >> is also a smaller fix that just involves using this_cpu_read() in
> >> switch_fpu_finish() for this specific issue, although that approach
> >> isn't as clean.
> > Can you add the test to the in-kernel tests so that we make sure it is
> > fixed and never comes back?
>
> It would be great if Brian could confirm this.  But, I'm 99% sure that
> this can be reproduced in the vm/protection_keys.c selftest, if you run
> it for long enough.

Hi Dave,
Yes, this is reproduced by the protection keys selfs tests. If your
kernel was compiled in a way which caches current_task when read via
this_cpu_read_stable(), then when switching from a kernel thread to a
user thread you will observe this behavior, so the only situation
where it's timing related is waiting for that switch from a kernel to
user thread. If your kernel is compiled in a way which does not cache
the value of current_task then you will never observe this behavior.
My understanding is that this is perfectly valid for the compiler to
produce that code.

>
> The symptom here is corruption of the PKRU register.  I created *lots*
> of bugs like this during protection keys development so the selftest
> keeps a shadow copy of the register to specifically watch for corruption.
>
> It's _plausible_ that no one ever ran the pkey selftests with a
> clang-compiled kernel for long enough to hit this issue.

For ChromeOS we use clang and when I tested a vanilla 5.10 kernel
_built with clang_ it also reproduced, so I suspect you're right that
the self tests just haven't been run against clang built kernels all
that often.

How would you and Greg KH like to proceed with this? I'm happy to help
however I can.

Brian
