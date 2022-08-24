Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E24559FC68
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 15:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbiHXN44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 09:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238352AbiHXN4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 09:56:12 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674037FF88
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 06:55:51 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so978221wme.1
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 06:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=wAe3mPHA651+ldl83WkFd0kxyB2d8GttUhU/NmvewGw=;
        b=p6cP46w15b75KzWq1bkfAddt6/4E94NO0bAmpJC9ZVR/7oVHT97AXs7EBySBZTFGtQ
         PN+12eqzFNO4IZlkDxE2qAKmYZsk1aUUw2ynZzohDRrA8C4F4MweYpPMxHP3AG3iuPY2
         x7agvqjaj0J3fQ5U3ETfdFsvrft4NH7qTuIiAQ7zu0sFScruPRV6SL3Zs5Ki+coZCGyw
         vOU5aGrSc2peqW8IOlGBzM/Dk1Tgo6MaxVFM7+7bnvXs16U+ZamXzDr9uSKJc3vdgI5f
         OfvLjS3Tv7m8frtoBj1QMx+Do893ZLLCUCVYHuoLqmr5b3OEIgEvgaOP97Mb1W5h908q
         F93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=wAe3mPHA651+ldl83WkFd0kxyB2d8GttUhU/NmvewGw=;
        b=Z5XvSY90vZSGo0Cjj4rPxlQJ1ciPVdDKjm+S3nOjxk2wmuq1NF9wAEvDBoBE9jQNHn
         LgjxhOboktvOer9+mdqhymNE8yvhVlkpsgO6VkxQbnQVvGlxx04aQSExGouhw/ycYjip
         Zx7w70JBQxj+mg/S/6vm5Zx93YUlZYGFDAj4q5YmntcyirOp6XT8onY6UMBIEO7B1olf
         Av/fGOJgAweULMDtH/s2UgScyQs2B4riI++c3b2x0Gsxvhl0VoiCSzK+kLFuvceQ0I6v
         W8v/D6rQ0piOsss+oRMAMukmE9wcWpYW+k9Y9q0BopI+JzVrvXI34xYCF3lDuDUZ0+/j
         iGDQ==
X-Gm-Message-State: ACgBeo2wluMSvatH4wAopyq/A6XBTJvIqI/vnGUllMpITwYmEbuGywY1
        CS8fiy4KAB0FbmjsPWGwHIJ+GmhNsg+vn6Jw
X-Google-Smtp-Source: AA6agR7VZKHlVm9KtJi9cm6SSm1cB9rPhyKji6SDYx3FLaqCk11IMbXhHp8kzZrQ6tb4uoH7p9W2Cw==
X-Received: by 2002:a05:600c:1d89:b0:3a5:c1db:21c6 with SMTP id p9-20020a05600c1d8900b003a5c1db21c6mr5121531wms.174.1661349349859;
        Wed, 24 Aug 2022 06:55:49 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id t14-20020adfe10e000000b0021e8d205705sm12127680wrz.51.2022.08.24.06.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 06:55:49 -0700 (PDT)
Date:   Wed, 24 Aug 2022 14:55:46 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     RAJESH DASARI <raajeshdasari@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexei.starovoitov@gmail.com,
        john.fastabend@gmail.com
Subject: Re: bpf selftest failed in 5.4.210 kernel
Message-ID: <YwYt4ix8JG65nGQF@myrica>
References: <Yv3M8wqMkLwlaHxa@kroah.com>
 <Yv3wZLuPEL9B/h83@myrica>
 <Yv9shQ3i49efHG6f@kroah.com>
 <CAPXMrf8VsNMKNLxFjdytk57mk_9ZC0avg1qCGLSMOZNirpdboQ@mail.gmail.com>
 <YwCGoRt6ifOC6mCD@kroah.com>
 <CAPXMrf-Gc-Mv1goZrk59GG96OLPxEUC-FKT6Dwo6TU6D7po=gw@mail.gmail.com>
 <YwR76AVTOsdXNpxh@kroah.com>
 <CAPXMrf-XUHnfQtnCMs6pbpM+2LUBLqE2c1Z-UwsM-mU1KdoOUA@mail.gmail.com>
 <YwUdyiK16jz1W5Aa@myrica>
 <94756777-b5b4-4db1-fe52-2386609f8a86@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94756777-b5b4-4db1-fe52-2386609f8a86@windriver.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 11:25:15PM +0300, Ovidiu Panait wrote:
> Hi Jean-Philippe,
> 
> On 8/23/22 21:34, Jean-Philippe Brucker wrote:
> > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > 
> > On Tue, Aug 23, 2022 at 10:31:40AM +0300, RAJESH DASARI wrote:
> > > Sorry for the confusion, results are indeed confusing to me .
> > > If I try with git bisect I get
> > > 
> > > git bisect bad
> > > 9d6f67365d9cdb389fbdac2bb5b00e59e345930e is the first bad commit
> > For me bisecting points to:
> > 
> > (A)     7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
> > 
> > This changes the BPF verifier output and (as expected) breaks the
> > test_align selftest. That's why in the same series [1] another patch fixed
> > test_align. In v5.4.y, that patch is:
> > 
> > (B)     6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")
> > 
> > Unfortunately commit (B) addresses multiple verifier changes, not solely
> > (A). My guess is those changes were in series [1] and haven't been
> > backported to v5.4. So multiple solutions:
> > 
> > * Partially revert (B), only keeping the changes needed by (A)
> > * Revert (A) and (B)
> > * Add the missing commits that (B) also addresses
> > 
> > I don't know which, I suppose it depends on the intent behind backporting
> > (A). Ovidiu?
> The intent behind backporting 7c1134c7da99 ("bpf: Verifer,
> adjust_scalar_min_max_vals to always call update_reg_bounds()") was to fix
> CVE-2021-4159.
> 
> If we revert test 11 changes brought in by 6a9b3f0f3bad ("selftests/bpf: Fix
> test_align verifier log patterns") backport, all test_align testcases pass
> on my side:
> 
> diff --git a/tools/testing/selftests/bpf/test_align.c
> b/tools/testing/selftests/bpf/test_align.c
> index c9c9bdce9d6d..4726e3eca9b2 100644
> --- a/tools/testing/selftests/bpf/test_align.c
> +++ b/tools/testing/selftests/bpf/test_align.c
> @@ -580,18 +580,18 @@ static struct bpf_align_test tests[] = {
>                         /* Adding 14 makes R6 be (4n+2) */
>                         {11,
> "R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
>                         /* Subtracting from packet pointer overflows ubounds
> */
> -                       {13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82;
> 0x7c)"},
> +                       {13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82;
> 0x7c))"},
>                         /* New unknown value in R7 is (4n), >= 76 */
>                         {15,
> "R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
>                         /* Adding it to packet pointer gives nice bounds
> again */
> -                       {16,
> "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2;
> 0xfffffffc)"},
> +                       {16,
> "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2;
> 0x7fc))"},
>                         /* At the time the word size load is performed from
> R5,
>                          * its total fixed offset is NET_IP_ALIGN + reg->off
> (0)
>                          * which is 2.  Then the variable offset is (4n+2),
> so
>                          * the total offset is 4-byte aligned and meets the
>                          * load's requirements.
>                          */
> -                       {20,
> "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2;
> 0xfffffffc)"},
> +                       {20,
> "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
>                 },
>         },
>  };
> 
> root@intel-x86-64:~/bpf# ./test_align
> Test   0: mov ... PASS
> Test   1: shift ... PASS
> Test   2: addsub ... PASS
> Test   3: mul ... PASS
> Test   4: unknown shift ... PASS
> Test   5: unknown mul ... PASS
> Test   6: packet const offset ... PASS
> Test   7: packet variable offset ... PASS
> Test   8: packet variable offset 2 ... PASS
> Test   9: dubious pointer arithmetic ... PASS
> Test  10: variable subtraction ... PASS
> Test  11: pointer variable subtraction ... PASS
> Results: 12 pass 0 fail
> > In any case 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic"
> > test") can be reverted, I can send that once we figure out the rest.
> 
> In my testing, with [1] and [2] applied, but without [3], the following
> test_align selftest would still fail:
> 
> Test   9: dubious pointer arithmetic ... Failed to find match 9:
> R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2;
> 0x7fffffff7ffffffc)

Right thanks for the details, so I think the cleanest is to revert [3] and
partially revert [2], tests 11 and part of 9. I'll send that out

Thanks,
Jean

> 
> 
> [1] 7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always call
> update_reg_bounds()")
> [2] 6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")
> [3] 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic" test")
> 
> Ovidiu
