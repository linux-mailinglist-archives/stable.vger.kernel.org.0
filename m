Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1522616F72
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 22:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKBVMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 17:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiKBVMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 17:12:34 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8C5E02D;
        Wed,  2 Nov 2022 14:12:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b21so36170plc.9;
        Wed, 02 Nov 2022 14:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SIubiPo7zT5JJe+L0CchJwTPpEdYLEw2sGAtp4350gs=;
        b=CnB6/zwTWr3MfwsAQZrhc9un2x2CcquEJn9y9MBorfQM7i78853QvADCeolFY0bc0e
         iYfdfH++uJHK8GwANGol7IStY/laYsTMdnlKzfvrYJ9qLYO0IzDena0YckpY/LDfqxmy
         ylwLVRM5xRZWalbXojFg7qMp7cdA/ruYqA0YmwOtcSF+OWcRLb0uPhP4xaxG4n1j52So
         GK7AIebmbcO6uXFGWSGF+sIkKiLFm6agGwZIhG/G9BCP/pOG0tUmbxOnCMBsS+kWYeWx
         IWUoOju9ClNC7I0LSEIloD5EwxZ16z/yLU2IyrEOKqaTKVWU+5es6mPiIzc9b/cTQ8wY
         wvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SIubiPo7zT5JJe+L0CchJwTPpEdYLEw2sGAtp4350gs=;
        b=u1ub37db1afuoK0NLWhP9C8J6mIpZj1SRfShS8oKaMPaobo2x/lRef2roB8RwebE/K
         kGOYVkcs8SmHTWmXpp8EaoUBzyaI5RR5d60gkC6JZhotyrrcrpPWcLhylnfvp2xjNstK
         4wvjVlJdQax22y0Qgvh6z4JttxWet2FFLpzRzQ0+EtfhXgSPJfhRvskid6mT/zsKmXSM
         BbUsoLFMY55OKDmH2ma36ASKbAGSSAd6fiZfUyj5uTWoUFT14BtOnsa4uJXNK2++Dwgl
         QwhMI4batS7N3cWNMmgxm0H0cmlUdE1WTM9/SoAxRQR/DtWfnaGYgKD9/HH+WqGiuKfE
         Pv2A==
X-Gm-Message-State: ACrzQf0lUskIhh6fpUxuU9Go4jYqYQrl+/y47clAQDoi+8/WPhjgsYpF
        J8+WMhQIZ3IHo1JiW8Ce6lXwIM/d0+QLjxb0fjg=
X-Google-Smtp-Source: AMsMyM4YZX18r4YFJQuWrrBszdVvGlOIfto5QLEius64s8tg50mFMIPYT4/u+gUPDqnMRgfRlZcilBoc+qmwqpBb4qw=
X-Received: by 2002:a17:90b:3144:b0:215:db2e:bc6e with SMTP id
 ip4-20020a17090b314400b00215db2ebc6emr1855922pjb.12.1667423546267; Wed, 02
 Nov 2022 14:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022055.039689234@linuxfoundation.org>
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 2 Nov 2022 14:12:15 -0700
Message-ID: <CAJq+SaBVDr99kcJ-XacoGc0Ah9Ur1eOim1jG1Jf319Q9Qh0Jjw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
