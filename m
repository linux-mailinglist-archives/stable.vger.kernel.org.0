Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B69559C8D1
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 21:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbiHVT3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 15:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbiHVT2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 15:28:52 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0388BF76;
        Mon, 22 Aug 2022 12:23:24 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 2so10846368pll.0;
        Mon, 22 Aug 2022 12:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hq+fAn138jPgRMiMBLqU4Gzfn3VTPBYZenvdqXkN2b4=;
        b=DV1OBN2CXOvkAyY1LtHAJUN7bDIwnqYDyzX+Hs+EAGVyewEOHoW075itIvPT3mazJ4
         CXN2TvRf3JCvh44hDbAYduRyL3+NjYhelPjzxk+dgi2OrQgJdQT+uex4c0f6xKbnAlTo
         Raw3j/8UXfG6Oi7tk5WCE64iqFNIny5Nd6ce+JWqUAiPr9xs6NbsFAdWiSLi6clKEi1a
         0zAfLx3dOA4nOImmg9bJuoppHsPmj/LdwPJK5QUbDv7xUUKvWT2b4d4jjc6eTC21yzJe
         MM5IDDMh5XvdaNl0VP59QdrE65VymNs3mTnDeokCOfv6AkYJIhL+ReMul5LKL+eJ3doD
         tqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hq+fAn138jPgRMiMBLqU4Gzfn3VTPBYZenvdqXkN2b4=;
        b=vTf/GokP2hTlEKBm6B3jM0olugJCwAoUe1XxjPK45csZuZQvSZkGlV7FG29TwR3tzK
         mtOLE1eEM13J8d6sV/UtgYNEGxShl3dyM0kRDRdBvXOc4ZuEqmylvsmodJ0JZK8vD55R
         Q+3irR4QUc+vhVBVW6qG0BG5wHPq8bhNLk4dnlKr2kdWUfRwSXqIz//XiReCg1cuYLMv
         gq0vxCpiBZoC6S97bfREaLdZM+LNMpFA1OodvPZea5ObaBJw9gnGmKAuUHbGqdNQfG5P
         5sfTuG2hDX+VnXY0IFwlckmNjMkeF07NxoquGrUjAad9pW2FwnuNGnSQfyiEjufp/+H0
         W8pw==
X-Gm-Message-State: ACgBeo0rjJb4rMzN5cJosuSfWKnc4pFT4qNXWQbljWSXogI3tvyau1AZ
        kuA9ojCZAxpAZvsfqcB/JjlQRM0NoZvG4SnlU0I=
X-Google-Smtp-Source: AA6agR5mHRVCfOxXp79Q69k25s8A61dL5tmsJ/CdB+zd4Vt+3zYFb31fXEKLnmW/1aoPHjmSmOJppG/miJo9q5v4rOs=
X-Received: by 2002:a17:902:c1ca:b0:172:9b8b:a3ff with SMTP id
 c10-20020a170902c1ca00b001729b8ba3ffmr21447845plc.81.1661196193725; Mon, 22
 Aug 2022 12:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
 <Yv3M8wqMkLwlaHxa@kroah.com> <Yv3wZLuPEL9B/h83@myrica> <Yv9shQ3i49efHG6f@kroah.com>
 <CAPXMrf8VsNMKNLxFjdytk57mk_9ZC0avg1qCGLSMOZNirpdboQ@mail.gmail.com> <YwCGoRt6ifOC6mCD@kroah.com>
In-Reply-To: <YwCGoRt6ifOC6mCD@kroah.com>
From:   RAJESH DASARI <raajeshdasari@gmail.com>
Date:   Mon, 22 Aug 2022 22:23:02 +0300
Message-ID: <CAPXMrf-Gc-Mv1goZrk59GG96OLPxEUC-FKT6Dwo6TU6D7po=gw@mail.gmail.com>
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

Hi,

Please find the test scenarios which I have tried.

Test 1:

Running system Kernel version (tag/commit) :  v5.4.210
Kernel source code checkout : v5.4.210
test_align test case execution status : Failure

Test 2:

Running system Kernel version (tag/commit) : v5.4.210
Kernel source code checkout : v5.4.209
test_align test case execution status : Failure

Test 3:

Running system Kernel version (tag/commit) : v5.4.209
Kernel source code checkout : v5.4.209
test_align test case execution status : Success

Test 4:

Running system Kernel version (tag/commit) : ACPI: APEI: Better fix to
avoid spamming the console with old error logs ( Kernel compiled at
this commit  and system is booted with this change)
Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
test_align verifier log patterns and selftests/bpf: Fix "dubious
pointer arithmetic" test. If I revert only the Fix "dubious pointer
arithmetic" test, the testcase still fails.
test_align test case execution status : Success

Test 5:

Running system Kernel version (tag/commit) :  v5.4.210 but reverted
commit (bpf: Verifer, adjust_scalar_min_max_vals to always call
update_reg_bounds() )
Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
test_align verifier log patterns and selftests/bpf: Fix "dubious
pointer arithmetic" test.
test_align test case execution status : Success

Test 6 :

Running system Kernel version (tag/commit) : bpf: Test_verifier, #70
error message updates for 32-bit right shift( Kernel compiled at this
commit  and system is booted with this change)
Kernel source code checkout : v5.4.209 or v5.4.210
test_align test case execution status : Failure

Thanks,
Rajesh Dasari.

On Sat, Aug 20, 2022 at 10:00 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Aug 19, 2022 at 07:20:11PM +0300, RAJESH DASARI wrote:
> > Hi ,
> >
> > I did some more tests ,  Please find the observation below.
> >
> > step 1:  On v5.4.210 kernel , I reverted  only commit  bpf: Verifer,
> > adjust_scalar_min_max_vals to always call update_reg_bounds()
> > 7c1134c7da997523e2834dd516e2ddc51920699a , compiled the kernel and
> > booted the system with the new kernel.
> > step 2:  On system with newly compiled kernel , I clone the  v54.4.210
> > source code  and  reverted  commit  selftests/bpf: Fix test_align
> > verifier log patterns  and selftests/bpf: Fix "dubious pointer
> > arithmetic" test , then ran the selftests, test_align test cases
> > execution was successful.
> > step 3: If i revert only selftests/bpf: Fix "dubious pointer
> > arithmetic" test , test cases are still failing.
> >
> >
> >
> > Please find the attached PDF for the other scenarios which I have executed.
>
> For obvious reasons, we can't read random .pdf files sent to us.  Please
> put it all in text.
>
> thanks,
>
> greg k-h
