Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC359D225
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbiHWHcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241063AbiHWHb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:31:59 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F406C647C9;
        Tue, 23 Aug 2022 00:31:52 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f17so6526761pfk.11;
        Tue, 23 Aug 2022 00:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=bMjoYyTDsyRUgx8ZranR4mdIniSPbYJELNZYSk0nTHs=;
        b=jGBuNF3u9pVvmg7gEUDKES7r+FaaDe4iJH5hFbDiBAhSTZUrb/jvsjVaaMBejm8Xyr
         +SuY4H/1mkpoz+gfjrt1Nx7QRrEmAtnivDMjpoJX+IFst+wWJ4rBYJ8UXfxlpUluOfOM
         XdQNXcQzBVDLS4F9754ftMOsLJUHc9Burv/gWZmS0SNv1SrZ5DYfaXRp2IGRdwDs4owv
         cF42nUeigJa7trF7KGd0xk9fqfGOEmFD/Zor/IF+UUiYKLEcxoi8g2NL+i0EcgSro3OK
         mwb2leMSObljziGLwHaSKp708zdZUYztV4gPoNhrw58xQvwxX7zyvLevdRr113jWzPfn
         v6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=bMjoYyTDsyRUgx8ZranR4mdIniSPbYJELNZYSk0nTHs=;
        b=zgt3sxYlCtbJ9MYLtIEzR0PwSHoPKxoicFjVlnBeBaWo3Q0kDzTOyhjUw8FHBHsRdT
         qlMnJgHIWnJoIAXm//imq26jPeFkBsQY7/uaaT2T8am74SPH9AYiJ/mxVKz/JnVwYugT
         zu2L3JoqI1193CBXmTd9JjrodZYaijHi06ONQCAIB8oQZemZBZkVgbcg5kxuv9JdE/mX
         gH0zxP/9LtqJJOgE/gVT9qLWD0Hv9yfMHXFq7xSfcpRZcfWPrOf5Wgrzo6WkVvM/fcyr
         8+TbKdKX8c+x8Saa3Q1wrxumHB7g958wAHSLMqu2csAy5FBnm2Q3jbnIp8Q7YQI4XtGn
         TZ2A==
X-Gm-Message-State: ACgBeo0YgfW1sUy2gO9VAGG/ckZLPg9JXSRuviNp/Xwi1P6S8lFOnCZq
        SgFYLjRl6+qx2WznISFGWfwF7+XBSZeIVsMhcQwGifZFax1vdg==
X-Google-Smtp-Source: AA6agR4XHbQYmGVKRt50x7EkFE4YvH6VV7RIsVrwy7kYGIKQWSYwiFfqIjk12Xp4faO1WhaXyaaiQSJlZVvisi9Hie4=
X-Received: by 2002:a62:7bd8:0:b0:536:9c1a:1ed3 with SMTP id
 w207-20020a627bd8000000b005369c1a1ed3mr8842175pfc.77.1661239911918; Tue, 23
 Aug 2022 00:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
 <Yv3M8wqMkLwlaHxa@kroah.com> <Yv3wZLuPEL9B/h83@myrica> <Yv9shQ3i49efHG6f@kroah.com>
 <CAPXMrf8VsNMKNLxFjdytk57mk_9ZC0avg1qCGLSMOZNirpdboQ@mail.gmail.com>
 <YwCGoRt6ifOC6mCD@kroah.com> <CAPXMrf-Gc-Mv1goZrk59GG96OLPxEUC-FKT6Dwo6TU6D7po=gw@mail.gmail.com>
 <YwR76AVTOsdXNpxh@kroah.com>
In-Reply-To: <YwR76AVTOsdXNpxh@kroah.com>
From:   RAJESH DASARI <raajeshdasari@gmail.com>
Date:   Tue, 23 Aug 2022 10:31:40 +0300
Message-ID: <CAPXMrf-XUHnfQtnCMs6pbpM+2LUBLqE2c1Z-UwsM-mU1KdoOUA@mail.gmail.com>
Subject: Re: bpf selftest failed in 5.4.210 kernel
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, df@google.com
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

Sorry for the confusion, results are indeed confusing to me .
If I try with git bisect I get

git bisect bad
9d6f67365d9cdb389fbdac2bb5b00e59e345930e is the first bad commit

If I  try to test myself with multiple test scenarios(I have mentioned
in  the previous mails) for the bad commits , I see that bad commits
are
bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
selftests/bpf: Fix test_align verifier log patterns
selftests/bpf: Fix "dubious pointer arithmetic" test

Thanks,
Rajesh Dasari.

On Tue, Aug 23, 2022 at 10:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 22, 2022 at 10:23:02PM +0300, RAJESH DASARI wrote:
> > Hi,
> >
> > Please find the test scenarios which I have tried.
> >
> > Test 1:
> >
> > Running system Kernel version (tag/commit) :  v5.4.210
> > Kernel source code checkout : v5.4.210
> > test_align test case execution status : Failure
> >
> > Test 2:
> >
> > Running system Kernel version (tag/commit) : v5.4.210
> > Kernel source code checkout : v5.4.209
> > test_align test case execution status : Failure
> >
> > Test 3:
> >
> > Running system Kernel version (tag/commit) : v5.4.209
> > Kernel source code checkout : v5.4.209
> > test_align test case execution status : Success
> >
> > Test 4:
> >
> > Running system Kernel version (tag/commit) : ACPI: APEI: Better fix to
> > avoid spamming the console with old error logs ( Kernel compiled at
> > this commit  and system is booted with this change)
> > Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
> > test_align verifier log patterns and selftests/bpf: Fix "dubious
> > pointer arithmetic" test. If I revert only the Fix "dubious pointer
> > arithmetic" test, the testcase still fails.
> > test_align test case execution status : Success
> >
> > Test 5:
> >
> > Running system Kernel version (tag/commit) :  v5.4.210 but reverted
> > commit (bpf: Verifer, adjust_scalar_min_max_vals to always call
> > update_reg_bounds() )
> > Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
> > test_align verifier log patterns and selftests/bpf: Fix "dubious
> > pointer arithmetic" test.
> > test_align test case execution status : Success
> >
> > Test 6 :
> >
> > Running system Kernel version (tag/commit) : bpf: Test_verifier, #70
> > error message updates for 32-bit right shift( Kernel compiled at this
> > commit  and system is booted with this change)
> > Kernel source code checkout : v5.4.209 or v5.4.210
> > test_align test case execution status : Failure
>
> I'm sorry, but I don't know what to do with this report at all.
>
> Is there some failure somewhere?  If you use 'git bisect' do you find
> the offending commit?
>
> confused,
>
> greg k-h
