Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7C959E432
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 15:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbiHWMxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiHWMwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:52:39 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02736272
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 02:58:16 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso9252618wma.2
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 02:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=BbqAlWYfZGsyfPLY71apTq3nIwqXzvuPF15BxrlLdaw=;
        b=MByJSC+DhVZo4v7UMC9BN4C3Ekn0xjud697Z7uxkms5N3Wp8X1tiX7L2YteroRiMZm
         Tty7jqW0+nS6dq8odTqzz9w5y0IusBhMIyCijuhNIP/Gl/vQMPpvdEWEltpHTUEjFZ/F
         cNKX+Mv/G8OP+1ZR6NBPB3rW9GJZJ5+Ziw+LrVryAORNPM3jfR06KGZf5MyB69OAH9Cu
         AZ24f4qfEZyWvgiqJHF5AtorvsYi2hzrlBcGzZiA9z956emS+mOfRvkX4MlVk5zsJnYd
         eWDOjWrxFN8RxPXAXAPWVnaRzoSanR6wdgs5/K2h2Y/Bpr/Po6rEEpbgBwHwijUhGtJ2
         LIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=BbqAlWYfZGsyfPLY71apTq3nIwqXzvuPF15BxrlLdaw=;
        b=LKzuWIin6s7VvyqQYjr1mHSDLIAskPR54sQDVDOw2bjM9txW3qxDyCDIIZwMuevdjD
         xxn+wwNd8oHvTy9/eFbAP7ALhJpVlq7kR85edoP19VU3w8T5QH1S0/2R3Qs31imznq57
         ZRNBDjR3q7sMztvN+cnA5wgEEIiiG613rIkl8gAxxsCNqloBh2fiL3RwUCQ3TdsNB68P
         ekqUsdeGN5zQTkn1mtxw2GJBcLbfdXWQgdVYxUPra5yJe8CmqA0Y9WjTyLAHo6+0kys/
         uYe4bemkkZIUMQ6r5L8Oc8ABBeolCGXy4MRQ9H5MX9MtjLe/eANrsVFWgnIcKGKA9JO5
         cTdg==
X-Gm-Message-State: ACgBeo0DVnsEUViAVfFr7P0U12L3KgMVFe1ZUUAh5MyBjJWNaW2rA1FA
        MOvA2tGv98rpHhJyARDhCPMkeg==
X-Google-Smtp-Source: AA6agR7KCCEiVwgbungNN9V/KW365pmudGRPb1bTDOxB0xPshfGIMwdaZoc/y8laIo0cKC1R2SsmNg==
X-Received: by 2002:a05:600c:19c8:b0:3a5:ec6a:8d16 with SMTP id u8-20020a05600c19c800b003a5ec6a8d16mr1592882wmq.182.1661248693717;
        Tue, 23 Aug 2022 02:58:13 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id y9-20020adff149000000b0022549ecba02sm8462201wro.19.2022.08.23.02.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:58:13 -0700 (PDT)
Date:   Tue, 23 Aug 2022 10:58:10 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: Re: [PATCH 4.19 026/287] selftests/bpf: Fix "dubious pointer
 arithmetic" test
Message-ID: <YwSksjAucU2zwo0y@myrica>
References: <20220823080100.268827165@linuxfoundation.org>
 <20220823080101.156298170@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080101.156298170@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Aug 23, 2022 at 10:23:15AM +0200, Greg Kroah-Hartman wrote:
> From: Ovidiu Panait <ovidiu.panait@windriver.com>
> 
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> commit 3615bdf6d9b19db12b1589861609b4f1c6a8d303 upstream.

This shouldn't be backported to 4.19, because it adjusts the selftest due
to commit b02709587ea3 ("bpf: Fix propagation of 32-bit signed bounds from
64-bit bounds."), which wasn't backported further than 5.9.

See [1] for the report about these BPF backports to v5.4, which we are
still trying to unravel. Given how painful building the BPF tests used to
be even on 5.4, I'd rather not do the same on 4.19!

[1] https://lore.kernel.org/lkml/CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com/

Thanks,
Jean

> 
> The verifier trace changed following a bugfix. After checking the 64-bit
> sign, only the upper bit mask is known, not bit 31. Update the test
> accordingly.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> [OP: adjust for 4.19 selftests]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  tools/testing/selftests/bpf/test_align.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/tools/testing/selftests/bpf/test_align.c
> +++ b/tools/testing/selftests/bpf/test_align.c
> @@ -475,10 +475,10 @@ static struct bpf_align_test tests[] = {
>  			 */
>  			{7, "R5=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
>  			/* Checked s>=0 */
> -			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
> +			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
>  			/* packet pointer + nonnegative (4n+2) */
> -			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
> -			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
> +			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
> +			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
>  			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
>  			 * We checked the bounds, but it might have been able
>  			 * to overflow if the packet pointer started in the
> @@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
>  			 * So we did not get a 'range' on R6, and the access
>  			 * attempt will fail.
>  			 */
> -			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
> +			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
>  		}
>  	},
>  	{
> 
> 
