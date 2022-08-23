Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EDD59EC7F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 21:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiHWTid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 15:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiHWTiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 15:38:14 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8022EA1D40
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 11:34:55 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bq11so11451157wrb.12
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 11:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ytTjReeUrxoqSJ5BeQcZY9hlOg/OMaAOjybK5mQFt+A=;
        b=Qy0Q9yihjuVjrN8moQnwdH5FwctVgPQjWaTW/jYlmysDVAO2t2WrbWoTwEtoaJmO7I
         AAM5wdq4aFShbRm62kuc1uNIEpKVeAh8SmEEQ3PfYvDK6AzvNnbwQRFbA1niDLjUyRze
         ADnk1oooR/czh6+WUVhvHGqF+EgkFgwl4/94d7l7cNsTJVGDee5XPIEoP+gbdxTuTEpm
         +ygSBBsYP68UagMawe/iKr+zmHc42vuPYH+ZHxXrIQcDzCeyYDSvwVvmYYC9SoBuVJHY
         MyHlPxkg1fmYUo//Epo2iJbf2qX8wqeeva53IyjehMh2NsTVCLC5JUn3hpVlqas2Ed+U
         iUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ytTjReeUrxoqSJ5BeQcZY9hlOg/OMaAOjybK5mQFt+A=;
        b=5ICEK6+fgqjMtle72QcMHMUN6faDkuIlc6YSqxdJhm762pznG6cb46/qazscNmj122
         cTm7Kjwz/Z+jqwf6Ovt27MUTBbwXn7MqMHv9wZ9fVnCvUYUCKOpVElUzBr1BMelHYvCp
         QxDksMoouXc3sr3r3GxWJWyNTqOZqjlUbQ7ejYj6+4PdWss8MObURF2Q4NSbNGCUi4ne
         F3WwpU18auHFG24VQwKAoaNqQ5B39tJW5YlPhitmixq5/F4qOQGqfNInAwKLnepfICrU
         gH886nULpPeT+tSa1MPPgTxj5OugvpDm30+NbftIyhcAHuUByfNYSaPVN3542ISs8RXp
         dryg==
X-Gm-Message-State: ACgBeo3DDXc5zoj1kwX0lHmWXqHRASl2x+MY31VMrAUk9CNGwA5ko/I7
        XKANeEM15WxwnaF/MseRD2Eczg==
X-Google-Smtp-Source: AA6agR4/pmlxMMCthZI/YxG8smLnTaQ2KoVUL3TkzQsGdeXmEbVwBRWaPWlRjyZd2AB6jbN6KltESA==
X-Received: by 2002:a5d:50c8:0:b0:225:5a57:bd84 with SMTP id f8-20020a5d50c8000000b002255a57bd84mr6104142wrt.131.1661279694038;
        Tue, 23 Aug 2022 11:34:54 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id g10-20020a05600c4eca00b003a31ca9dfb6sm27073664wmq.32.2022.08.23.11.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 11:34:53 -0700 (PDT)
Date:   Tue, 23 Aug 2022 19:34:50 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     RAJESH DASARI <raajeshdasari@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, ovidiu.panait@windriver.com,
        alexei.starovoitov@gmail.com, john.fastabend@gmail.com
Subject: Re: bpf selftest failed in 5.4.210 kernel
Message-ID: <YwUdyiK16jz1W5Aa@myrica>
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
 <Yv3M8wqMkLwlaHxa@kroah.com>
 <Yv3wZLuPEL9B/h83@myrica>
 <Yv9shQ3i49efHG6f@kroah.com>
 <CAPXMrf8VsNMKNLxFjdytk57mk_9ZC0avg1qCGLSMOZNirpdboQ@mail.gmail.com>
 <YwCGoRt6ifOC6mCD@kroah.com>
 <CAPXMrf-Gc-Mv1goZrk59GG96OLPxEUC-FKT6Dwo6TU6D7po=gw@mail.gmail.com>
 <YwR76AVTOsdXNpxh@kroah.com>
 <CAPXMrf-XUHnfQtnCMs6pbpM+2LUBLqE2c1Z-UwsM-mU1KdoOUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXMrf-XUHnfQtnCMs6pbpM+2LUBLqE2c1Z-UwsM-mU1KdoOUA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:31:40AM +0300, RAJESH DASARI wrote:
> Sorry for the confusion, results are indeed confusing to me .
> If I try with git bisect I get
> 
> git bisect bad
> 9d6f67365d9cdb389fbdac2bb5b00e59e345930e is the first bad commit

For me bisecting points to:

(A)	7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")

This changes the BPF verifier output and (as expected) breaks the
test_align selftest. That's why in the same series [1] another patch fixed
test_align. In v5.4.y, that patch is:

(B)	6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")

Unfortunately commit (B) addresses multiple verifier changes, not solely
(A). My guess is those changes were in series [1] and haven't been
backported to v5.4. So multiple solutions:

* Partially revert (B), only keeping the changes needed by (A)
* Revert (A) and (B)
* Add the missing commits that (B) also addresses

I don't know which, I suppose it depends on the intent behind backporting
(A). Ovidiu?

In any case 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic"
test") can be reverted, I can send that once we figure out the rest.

Thanks,
Jean

[1] https://lore.kernel.org/bpf/158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower/

> 
> If I  try to test myself with multiple test scenarios(I have mentioned
> in  the previous mails) for the bad commits , I see that bad commits
> are
> bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
> selftests/bpf: Fix test_align verifier log patterns
> selftests/bpf: Fix "dubious pointer arithmetic" test
> 
> Thanks,
> Rajesh Dasari.
> 
> On Tue, Aug 23, 2022 at 10:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Aug 22, 2022 at 10:23:02PM +0300, RAJESH DASARI wrote:
> > > Hi,
> > >
> > > Please find the test scenarios which I have tried.
> > >
> > > Test 1:
> > >
> > > Running system Kernel version (tag/commit) :  v5.4.210
> > > Kernel source code checkout : v5.4.210
> > > test_align test case execution status : Failure
> > >
> > > Test 2:
> > >
> > > Running system Kernel version (tag/commit) : v5.4.210
> > > Kernel source code checkout : v5.4.209
> > > test_align test case execution status : Failure
> > >
> > > Test 3:
> > >
> > > Running system Kernel version (tag/commit) : v5.4.209
> > > Kernel source code checkout : v5.4.209
> > > test_align test case execution status : Success
> > >
> > > Test 4:
> > >
> > > Running system Kernel version (tag/commit) : ACPI: APEI: Better fix to
> > > avoid spamming the console with old error logs ( Kernel compiled at
> > > this commit  and system is booted with this change)
> > > Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
> > > test_align verifier log patterns and selftests/bpf: Fix "dubious
> > > pointer arithmetic" test. If I revert only the Fix "dubious pointer
> > > arithmetic" test, the testcase still fails.
> > > test_align test case execution status : Success
> > >
> > > Test 5:
> > >
> > > Running system Kernel version (tag/commit) :  v5.4.210 but reverted
> > > commit (bpf: Verifer, adjust_scalar_min_max_vals to always call
> > > update_reg_bounds() )
> > > Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
> > > test_align verifier log patterns and selftests/bpf: Fix "dubious
> > > pointer arithmetic" test.
> > > test_align test case execution status : Success
> > >
> > > Test 6 :
> > >
> > > Running system Kernel version (tag/commit) : bpf: Test_verifier, #70
> > > error message updates for 32-bit right shift( Kernel compiled at this
> > > commit  and system is booted with this change)
> > > Kernel source code checkout : v5.4.209 or v5.4.210
> > > test_align test case execution status : Failure
> >
> > I'm sorry, but I don't know what to do with this report at all.
> >
> > Is there some failure somewhere?  If you use 'git bisect' do you find
> > the offending commit?
> >
> > confused,
> >
> > greg k-h
