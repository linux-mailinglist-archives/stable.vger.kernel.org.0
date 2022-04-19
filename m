Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F23506099
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbiDSAJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiDSAJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:09:49 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EBD3A7;
        Mon, 18 Apr 2022 17:07:09 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id z8so16483807oix.3;
        Mon, 18 Apr 2022 17:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tR2KJ3ik5nUbef01f/H/C2f872WKtSqjd0bnxfjCfcM=;
        b=E24hjrhgBrGZnOdOIIodDRUoACWesWNaEYgWzaOzg+i5R0HXy6qTBvxcSXNbt22uog
         X4oLtza35tBh86s0aIVVa2y70I3xVei2Rtl+QOwbXMprjec1wZBqftyTmFk7vWuRs0bH
         RBBVbkIxQu1t4Mw4Qonk/OfOpIQteGe128t6751C8a7PmFuDWR+UBy7+Abk4rfcP3yAn
         DYfAUQebsGKEmRqLns3/GDXK7pBRuAjEeWvLIla3L4IcseJJWvmriNPB8yRyWG5Lc9xh
         BcU8QgXvVE0ZRAOoMc4AzzVsZsbuGe4alPGpkFx0amLNW/ZOkubVabIOqLirVuNM9TmL
         VH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tR2KJ3ik5nUbef01f/H/C2f872WKtSqjd0bnxfjCfcM=;
        b=cGQ5j2G94M0DDm0/g5PZOprxakHaf4cZoio+xrSPhsYcMW7S+ec+EzSq6BiLhVQSvP
         xOYQ/Jzmh7d2WBXtfOJACYK37P5HP6lWoal5cAus628b3CHHp9Ik5sXQ1JoyrlMgWhj9
         sTD+xBH1FGQyS3ZRMa857C4ZaedfV6wMjAmaNPZqzjZPaKiLfL2wvrCJyHRc8lwi0jTB
         sLdLmEzb0BCQPLOT9y4XPQFXGUhWxRZanFnSFvucnG4Kj+heSeUe6601Nq1rR1gx8Gpv
         fkXBWXV9w3zH2fkIzlWRAsV7Qjb4cqhzRz6Ol9YAki6MHmvBgwkWncoRMYx79FTd4HpT
         vqBg==
X-Gm-Message-State: AOAM531voeLycqDHbfXZVNIlVrOeOvbUURj1MhoFdB+0S/uG4/K0VhQP
        Or5fTCxjImOlsr12upe6Alk=
X-Google-Smtp-Source: ABdhPJzYHWWJ5kTFvC5fxNmVRZbN0TBfN1gUuuCqCgTMfZ5YF0TwO7Eg8UICI6/7pIwElOJXHaITZA==
X-Received: by 2002:aca:2818:0:b0:322:3bd7:66f1 with SMTP id 24-20020aca2818000000b003223bd766f1mr6442141oix.38.1650326828660;
        Mon, 18 Apr 2022 17:07:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 65-20020aca0544000000b002f980b50140sm4652684oif.18.2022.04.18.17.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:07:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Apr 2022 17:07:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc1 review
Message-ID: <20220419000706.GF1369577@roeck-us.net>
References: <20220418121200.312988959@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 02:10:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 154 fail: 2
Failed builds:
	i386:allyesconfig
	i386:allmodconfig
Qemu test results:
	total: 488 pass: 488 fail: 0

Build error as already reported.

drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:
	In function 'hubbub31_verify_allow_pstate_change_high':
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:994:17:
	error: implicit declaration of function 'udelay'

Guenter
