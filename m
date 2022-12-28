Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1661F658711
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 22:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiL1Vba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 16:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiL1Vb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 16:31:27 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DE1140C8;
        Wed, 28 Dec 2022 13:31:26 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id m6-20020a9d7e86000000b0066ec505ae93so10519432otp.9;
        Wed, 28 Dec 2022 13:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g55xSgNfuPxooo0uABGdBIlskF3WWC3oxJT4+davjnw=;
        b=YIQtzmZiZrRrzBNTu1RxdZ+Vf8ouChz3e5d32r4foWNA5CUR0dd3zxVDL0yQPaHhaw
         /cQ95eJp+hZSV5fwY5lxP+CEP7pKstaHhpxvQw+KKGXkb3YhAbbeNFffZlThe61W6k/l
         Tqd4IEdelOixOLnZCCd/xsuxoph7HvrflwMwaPynp+3/jvi/fUrQRacCKWo+KUbKo2vE
         nfZlSPLGsmT3bxgR/GCl1gNgcE7IBZtyzm7oqVZc+OCU8fZ/N0sU0PoIVbGYuVXUSU0j
         1b4vIfsM6DNBtMM8UxCKMCUsZgVwJsUwcIk4NW3ES83XpxToVgCLaKk3Ur82ugNk7+DF
         Po5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g55xSgNfuPxooo0uABGdBIlskF3WWC3oxJT4+davjnw=;
        b=bnuDbyP+0R1jwde0p73tYUhLUjV/eRQcKYYZV8VbI/HbP9Jo/Zv08QLT+395GYryQA
         ZHjy6eSMJ5UsI6IOkcYFKM+D8VH1OsM4OHPV9mLIXmcteb//F8HfJ7jDEsXh8rAaZZux
         uQb8ozbWB0wzSRvK7RHfA7pZnS6GYvbwvkEZ0UN9mE+MRVAh+hUQwVHlEz8HQ7p3unXA
         IMdiicPf1Iw06+58wdwWxI79hEQ5uOIfuQLY3cJyEmI6o8ayJwXyHsGXqWc0cpvB0WNw
         BbhsX4IaW+jxUhQfBfxrCVqn0EwA5+PoWnvUKLrY9GQQ5ElofO6ZrfiCoY0sefQDoZXJ
         gm4Q==
X-Gm-Message-State: AFqh2krTmwv7umdRiHGundR2U27j2WEEK9HODhH6IBoWBKBBo45wD3t1
        F4DOAP+TLMqv4EcqSUMWupQ=
X-Google-Smtp-Source: AMrXdXtArnjAShWd3z6jxGQbNFDe7/wWUdnQMKeSas/MRzfuO/ZFoy01XuecrrZnXZPthPb1haDWtA==
X-Received: by 2002:a05:6830:43:b0:670:99fe:2dcc with SMTP id d3-20020a056830004300b0067099fe2dccmr12703052otp.18.1672263085580;
        Wed, 28 Dec 2022 13:31:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h12-20020a9d600c000000b0066e93d2b858sm8230656otj.55.2022.12.28.13.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 13:31:24 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Dec 2022 13:31:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <20221228213123.GA2229529@roeck-us.net>
References: <20221228144330.180012208@linuxfoundation.org>
 <9560136e-d6e9-995a-141a-61dd05a62b8a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9560136e-d6e9-995a-141a-61dd05a62b8a@linaro.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 03:15:01PM -0600, Daniel Díaz wrote:
> Hello!
> 
> 
> On 28/12/22 08:25, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.2 release.
> > There are 1146 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We're seeing the already reported problem with the unused variable 'rpm', but also seeing this on Arm, i386, MIPS, PA-RISC:
> 
I see this as well if I try to build with gcc 9.4, but not with gcc 11.3.
Interesting.

Anyway, the problem is fixed upstream with commit dd1f1da4ada5
("pwm: tegra: Fix 32 bit build").

Guenter

> | /builds/linux/drivers/pwm/pwm-tegra.c: In function 'tegra_pwm_config':
> | /builds/linux/drivers/pwm/pwm-tegra.c:148:53: error: result of '1000000000 << 8' requires 39 bits to represent, but 'long int' only has 32 bits [-Werror=shift-overflow=]
> |    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
> |                                                      ^~
> | /builds/linux/include/linux/math.h:40:32: note: in definition of macro 'DIV_ROUND_DOWN_ULL'
> |   ({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
> |                                 ^~
> | /builds/linux/drivers/pwm/pwm-tegra.c:148:23: note: in expansion of macro 'DIV_ROUND_UP_ULL'
> |    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
> |                        ^~~~~~~~~~~~~~~~
> | cc1: all warnings being treated as errors
> 
> Those are with GCC-8 and allmodconfig.
> 
> Greetings!
> 
> Daniel Díaz
> daniel.diaz@linaro.org
> 
