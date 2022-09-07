Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7944A5B0C5E
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 20:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiIGSRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 14:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiIGSRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 14:17:17 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421C8B14E2;
        Wed,  7 Sep 2022 11:17:14 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id e28so11111250qts.1;
        Wed, 07 Sep 2022 11:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date;
        bh=dubdDeXQwaEqO1LQ7CfpmQjP3T8FcaEec1BqYW1q66o=;
        b=DShQGpb3oUd7qxO2mA24zrcoOWVPKqFf/WBFp27xN2UQoALbdfQavwCFOpwDhqAeqv
         Ig4/KL62iqdFQ3DSmS+IAYzjaduJgoVJHi2bZiLLT39Sw2XJaikdUikTfPNdUvrZfyrw
         PdtUXZR9ecwl9O6eWihDbRdt/nPsF/SMmr1+RLO53YfZFo19LAh+UswvkRV7sjzBtRMM
         M9DBikQ7ZGemWpHaXp9c76OetZ/+xE0zoiU0BpgoylYUQCjMVkJU8Cfs4sJb+1YhlIb/
         AdSgh0TO+PWKMHcr5C5PSa1Sycr8/6moB0VSMHRSnirm0TNiYsTm7xUWd+JRai4J1vNL
         zqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date;
        bh=dubdDeXQwaEqO1LQ7CfpmQjP3T8FcaEec1BqYW1q66o=;
        b=uTQ2cH0e9hBU6nsAx3SklccmCKrJhKgHX7eyW1MMwjLZSPVyatyd9iJd4Q26xSRBUH
         kVZOcYq/rbvPcemO3biL4cYJL6tRVCrzkYsGSWOmlArvCA0nw9D0MdDpZ7XEuoUjPsdp
         +JXa2R4/3DNL3/HrH5gq5Chbkd5e8cH33Yk7z6t2pW9GLAflMvpSC5kdNz8sdHz8ldJ/
         NA6NfX467MdZLawOBqxfi2nAS/F0eMuN52ggxPCDh6XCGlwLbOqzUVWZ4Nx9+evHyRC9
         NpaDp7y1vb09hohbbBxkXe6et4mJHj5wm4HhAZKSRMgi4frkKATnT1y9a0+xTR/UudDS
         AQgQ==
X-Gm-Message-State: ACgBeo1IGIdIr1IlL05U8boDE1YVahECXAPJa7f0NHzsJA+nP6gGWJ7D
        xqVWxBjvBPj0gp854WtKOco=
X-Google-Smtp-Source: AA6agR6wZ9UGCJvCgjcfyxOVt06/ZCDNHCPblaKyTKQTMXULiHo5H65J9UQsjI3CDXMhRYTbDzYu7Q==
X-Received: by 2002:a05:622a:1394:b0:344:648b:575a with SMTP id o20-20020a05622a139400b00344648b575amr4376650qtk.607.1662574633410;
        Wed, 07 Sep 2022 11:17:13 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id m23-20020ac86897000000b0034355bb11f2sm12538387qtq.10.2022.09.07.11.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 11:17:12 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 3935B27C005A;
        Wed,  7 Sep 2022 14:17:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 14:17:12 -0400
X-ME-Sender: <xms:KOAYYz9s-YN3wnusJ2fYdc91vL5Kq4-6hJzTu7MpYQbxAP6-nspqjg>
    <xme:KOAYY_vMffySFolShRCpI6PTo8XqmS7D65jyGoEyDjuGJJkJWw52_Jd3-_otBycuW
    qYXSFxyM3dzho-rew>
X-ME-Received: <xmr:KOAYYxAhfiDg7OfMpN8U0HDz_Pa4vYTrSve3xaCnF8nLP8dVONtJav76rj0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:KOAYY_ffC8cJS0J2z2ud2Drp1GoPHGY4xlnlq9npkgpqQ792dca4xA>
    <xmx:KOAYY4MKPlHFqA3cGk6eoLa0c3YBD9yK7MNiSJNKV_sXPPkcY37i2Q>
    <xmx:KOAYYxnIhiCkHSCVLXGHYNaWwNBmxwSPJSlxDQoIGe-_KO7UXdJT3g>
    <xmx:KOAYY5FDmJAahG7nyhbH6LgSCcv4zdFo2wzTfdDFlVccV9IROooESA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 14:17:11 -0400 (EDT)
Date:   Wed, 7 Sep 2022 11:15:52 -0700
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Marco Elver <elver@google.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] kcsan: Instrument memcpy/memset/memmove with newer
 Clang
Message-ID: <Yxjf2GtNbr8Ra5VL@boqun-archlinux>
References: <20220907173903.2268161-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907173903.2268161-1-elver@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 07, 2022 at 07:39:02PM +0200, Marco Elver wrote:
> With Clang version 16+, -fsanitize=thread will turn
> memcpy/memset/memmove calls in instrumented functions into
> __tsan_memcpy/__tsan_memset/__tsan_memmove calls respectively.
> 
> Add these functions to the core KCSAN runtime, so that we (a) catch data
> races with mem* functions, and (b) won't run into linker errors with
> such newer compilers.
> 
> Cc: stable@vger.kernel.org # v5.10+

For (b) I think this is Ok, but for (a), what the atomic guarantee of
our mem* functions? Per-byte atomic or something more complicated (for
example, providing best effort atomic if a memory location in the range
is naturally-aligned to a machine word)?

If it's a per-byte atomicity, then maybe another KCSAN_ACCESS_* flags is
needed, otherwise memset(0x8, 0, 0x2) is considered as atomic if
ASSUME_PLAIN_WRITES_ATOMIC=y. Unless I'm missing something.

Anyway, this may be worth another patch and some discussion/doc, because
it just improve the accuracy of the tool. In other words, this patch and
the "stable" tag look good to me.

Regards,
Boqun

> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  kernel/kcsan/core.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
> index fe12dfe254ec..66ef48aa86e0 100644
> --- a/kernel/kcsan/core.c
> +++ b/kernel/kcsan/core.c
> @@ -18,6 +18,7 @@
>  #include <linux/percpu.h>
>  #include <linux/preempt.h>
>  #include <linux/sched.h>
> +#include <linux/string.h>
>  #include <linux/uaccess.h>
>  
>  #include "encoding.h"
> @@ -1308,3 +1309,29 @@ noinline void __tsan_atomic_signal_fence(int memorder)
>  	}
>  }
>  EXPORT_SYMBOL(__tsan_atomic_signal_fence);
> +
> +void *__tsan_memset(void *s, int c, size_t count);
> +noinline void *__tsan_memset(void *s, int c, size_t count)
> +{
> +	check_access(s, count, KCSAN_ACCESS_WRITE, _RET_IP_);
> +	return __memset(s, c, count);
> +}
> +EXPORT_SYMBOL(__tsan_memset);
> +
> +void *__tsan_memmove(void *dst, const void *src, size_t len);
> +noinline void *__tsan_memmove(void *dst, const void *src, size_t len)
> +{
> +	check_access(dst, len, KCSAN_ACCESS_WRITE, _RET_IP_);
> +	check_access(src, len, 0, _RET_IP_);
> +	return __memmove(dst, src, len);
> +}
> +EXPORT_SYMBOL(__tsan_memmove);
> +
> +void *__tsan_memcpy(void *dst, const void *src, size_t len);
> +noinline void *__tsan_memcpy(void *dst, const void *src, size_t len)
> +{
> +	check_access(dst, len, KCSAN_ACCESS_WRITE, _RET_IP_);
> +	check_access(src, len, 0, _RET_IP_);
> +	return __memcpy(dst, src, len);
> +}
> +EXPORT_SYMBOL(__tsan_memcpy);
> -- 
> 2.37.2.789.g6183377224-goog
> 
