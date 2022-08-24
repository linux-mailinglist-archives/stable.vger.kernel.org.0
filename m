Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A3059FF3F
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 18:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbiHXQOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 12:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239237AbiHXQOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 12:14:03 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF5A9AF9C
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 09:13:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a4so21406114wrq.1
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 09:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=AY5Gj63eapxUT4qMtWVRtgy0+Cmp8OUrfb4J0LxivUk=;
        b=CIQb0XBbm5S5nLcFhYWKofqHvJ/WtS1sfdb6Se1L60+IQmDMxB9wMOF/WKDOlUE22K
         oviwiS9HfXRlOVmxRPPeE/9nKkGcrGOulr970gdahEn1bD9u2KWM2EzMmoonGUFgjP6f
         BcF1DjdhGOJfXsMTz+nQCoIyp4ckuhUEPsw+PaP1Zljq+nmrCHJFMVrFBX0aoC7Naut/
         K+dgttTRb/FwoZViQ8ewwjl6DDAztkaF7YISy3AFIEGL4Bf6UYDcS015Qv1xvbOjSL8s
         79F/4cx276g2CGg8NzB9SmxTR4ENW2lAtIjYbT7BTGR5hwTnX6rymMMuaACciVd+BbeO
         KXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AY5Gj63eapxUT4qMtWVRtgy0+Cmp8OUrfb4J0LxivUk=;
        b=YQvLKl8KXfZ6dZihXs0MPU+y1MYzntJIDbHMf1BS6kHZh6uVk6nTlCCKwCYKxLWKXi
         jz5+LZq5RBf/jegnsznbyxdGKf908LhAhFK9YoNOe/mMpA8jmJDToZDTbYbDvvpd/8Z4
         S21HJSjIwX6YEwUXUwhiTKFgVW2iUrYcA1sHXs0iFBsWbGWZivlS5o11/7fCYdTOTT2x
         qsulQhui95IM+8W4znh9Ev9EdBwksQBYkajvjY/TOXGb/oK0iw7Kt9UW6O3KsRpeCKDD
         A5qq1WeTSAB+uFlcyXxBLu6MGGlrila7Jeb0JV2oNxD8PGW6CtBtS8mvQ3lxL7LcsntK
         z9xA==
X-Gm-Message-State: ACgBeo29P7eKv8uYfsXKExUs8hFXadXhuKjC4GhJQ/QRdfC7R41QDW23
        MzZfKitqzeY/JzTaDXfTX1xIVg==
X-Google-Smtp-Source: AA6agR5C2lJWB8q4B5x7MBbdEN5DHs6MGNRoKPT7qO6X/cyD1FCzM3o7IxHHc3lvkxdQGWoN/zTueA==
X-Received: by 2002:a5d:4e41:0:b0:225:5b3d:3942 with SMTP id r1-20020a5d4e41000000b002255b3d3942mr5554wrt.78.1661357637598;
        Wed, 24 Aug 2022 09:13:57 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d438e000000b002253604bbefsm15679816wrq.75.2022.08.24.09.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:13:57 -0700 (PDT)
Date:   Wed, 24 Aug 2022 17:13:54 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: Re: [PATCH 4.19 025/287] selftests/bpf: Fix test_align verifier log
 patterns
Message-ID: <YwZOQv/dqReP8XfU@myrica>
References: <20220823080100.268827165@linuxfoundation.org>
 <20220823080101.125479106@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080101.125479106@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Aug 23, 2022 at 10:23:14AM +0200, Greg Kroah-Hartman wrote:
> From: Ovidiu Panait <ovidiu.panait@windriver.com>
> 
> From: Stanislav Fomichev <sdf@google.com>
> 
> commit 5366d2269139ba8eb6a906d73a0819947e3e4e0a upstream.
> 
> Commit 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always
> call update_reg_bounds()") changed the way verifier logs some of its state,
> adjust the test_align accordingly. Where possible, I tried to not copy-paste
> the entire log line and resorted to dropping the last closing brace instead.
> 
> Fixes: 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Link: https://lore.kernel.org/bpf/20200515194904.229296-1-sdf@google.com
> [OP: adjust for 4.19 selftests]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I believe this one shouldn't be applied as-is either, only partially. See
https://lore.kernel.org/stable/20220824144327.277365-1-jean-philippe@linaro.org/

Ovidiu, do you want to resend this one with only the fixes for "bpf:
Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()"?

Thanks,
Jean


> ---
>  tools/testing/selftests/bpf/test_align.c |   41 +++++++++++++++----------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
> 
> --- a/tools/testing/selftests/bpf/test_align.c
> +++ b/tools/testing/selftests/bpf/test_align.c
> @@ -359,15 +359,15 @@ static struct bpf_align_test tests[] = {
>  			 * is still (4n), fixed offset is not changed.
>  			 * Also, we create a new reg->id.
>  			 */
> -			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc))"},
> +			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
>  			/* At the time the word size load is performed from R5,
>  			 * its total fixed offset is NET_IP_ALIGN + reg->off (18)
>  			 * which is 20.  Then the variable offset is (4n), so
>  			 * the total offset is 4-byte aligned and meets the
>  			 * load's requirements.
>  			 */
> -			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
> -			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
> +			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
> +			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
>  		},
>  	},
>  	{
> @@ -410,15 +410,15 @@ static struct bpf_align_test tests[] = {
>  			/* Adding 14 makes R6 be (4n+2) */
>  			{9, "R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
>  			/* Packet pointer has (4n+2) offset */
> -			{11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
> -			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
> +			{11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
> +			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
>  			/* At the time the word size load is performed from R5,
>  			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
>  			 * which is 2.  Then the variable offset is (4n+2), so
>  			 * the total offset is 4-byte aligned and meets the
>  			 * load's requirements.
>  			 */
> -			{15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
> +			{15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
>  			/* Newly read value in R6 was shifted left by 2, so has
>  			 * known alignment of 4.
>  			 */
> @@ -426,15 +426,15 @@ static struct bpf_align_test tests[] = {
>  			/* Added (4n) to packet pointer's (4n+2) var_off, giving
>  			 * another (4n+2).
>  			 */
> -			{19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
> -			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
> +			{19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
> +			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
>  			/* At the time the word size load is performed from R5,
>  			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
>  			 * which is 2.  Then the variable offset is (4n+2), so
>  			 * the total offset is 4-byte aligned and meets the
>  			 * load's requirements.
>  			 */
> -			{23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
> +			{23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
>  		},
>  	},
>  	{
> @@ -469,16 +469,16 @@ static struct bpf_align_test tests[] = {
>  		.matches = {
>  			{4, "R5_w=pkt_end(id=0,off=0,imm=0)"},
>  			/* (ptr - ptr) << 2 == unknown, (4n) */
> -			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
> +			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc)"},
>  			/* (4n) + 14 == (4n+2).  We blow our bounds, because
>  			 * the add could overflow.
>  			 */
> -			{7, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
> +			{7, "R5=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
>  			/* Checked s>=0 */
> -			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
> +			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
>  			/* packet pointer + nonnegative (4n+2) */
> -			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
> -			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
> +			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
> +			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
>  			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
>  			 * We checked the bounds, but it might have been able
>  			 * to overflow if the packet pointer started in the
> @@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
>  			 * So we did not get a 'range' on R6, and the access
>  			 * attempt will fail.
>  			 */
> -			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
> +			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
>  		}
>  	},
>  	{
> @@ -528,7 +528,7 @@ static struct bpf_align_test tests[] = {
>  			/* New unknown value in R7 is (4n) */
>  			{11, "R7_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
>  			/* Subtracting it from R6 blows our unsigned bounds */
> -			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 0xfffffffffffffffc))"},
> +			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
>  			/* Checked s>= 0 */
>  			{14, "R6=inv(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
>  			/* At the time the word size load is performed from R5,
> @@ -537,7 +537,8 @@ static struct bpf_align_test tests[] = {
>  			 * the total offset is 4-byte aligned and meets the
>  			 * load's requirements.
>  			 */
> -			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
> +			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc)"},
> +
>  		},
>  	},
>  	{
> @@ -579,18 +580,18 @@ static struct bpf_align_test tests[] = {
>  			/* Adding 14 makes R6 be (4n+2) */
>  			{11, "R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
>  			/* Subtracting from packet pointer overflows ubounds */
> -			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c))"},
> +			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c)"},
>  			/* New unknown value in R7 is (4n), >= 76 */
>  			{15, "R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
>  			/* Adding it to packet pointer gives nice bounds again */
> -			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
> +			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
>  			/* At the time the word size load is performed from R5,
>  			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
>  			 * which is 2.  Then the variable offset is (4n+2), so
>  			 * the total offset is 4-byte aligned and meets the
>  			 * load's requirements.
>  			 */
> -			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
> +			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
>  		},
>  	},
>  };
> 
> 
> 
