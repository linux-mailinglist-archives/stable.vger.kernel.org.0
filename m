Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A935D5FC2C3
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 11:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiJLJNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 05:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJLJNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 05:13:41 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CCEBBE26;
        Wed, 12 Oct 2022 02:13:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c20so6107896plc.5;
        Wed, 12 Oct 2022 02:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h2U+d4Zkc153eHg+kH8o3aRDtfh0D1FunK0gPBr0efc=;
        b=dIeETlrm8CAMZurnhhYy7iIDi/5p8kauBEgI/yYXOJanLadsbmCJ3t07u0DvNwWlg9
         FuKH7tdxi/fNKtYCDuw270BxeCuQzgyzHaabJG0d5jTOnawRO4if4ibb+fsorEH2WYJe
         EKERn2Ht0OCwcvL3RE8GVc5kO3DcW+WmJfG6V2/t57+PpNiQYZdLxKNC+qeNpjSMVXUo
         e6EZGkQvpw2cIHYQKFTPn97JOiozBVaXU25ewRNJ1f7QWwj3DejBGEtOADFHUDmD0yX0
         hofiBfeYttr7uItoagf4eQDnIPE1Br7YdssQqpMhktBMG8odbq0/7PcecIcWaMC5pUv5
         B2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h2U+d4Zkc153eHg+kH8o3aRDtfh0D1FunK0gPBr0efc=;
        b=3mLKqcH3gTMajCG8E8b0gA9O8ZCCOIhNZdcyRKcwfLMDE8ZKeEtVx+u4PzJUmmRNA5
         U3rhhmEAWRMVWzQSKfg6JDImSdokCTApxYJBgQRNbzWViUISaMqVCdV+o1dMScLtSNye
         NH7ir29dBx+QUESLd3YCS4y/rn+X3kPAxNEBf0o+CRaWjPR4BP07ETgCWI1b52z7JUVM
         wilVvDhfA8f1qiGd5zQkWIvc7B9c7oyx/ZStnijDVkSfHxnxVwBrRBYP9ykYHxgCgBle
         UGzmb7ioUmSlia8P0ghiUZ5B0jEKtFjeIliY/YYrlHaUIvsebeHRc6GptQzH3E7TaURf
         Sv5w==
X-Gm-Message-State: ACrzQf0nYRgMCkPILH/cSK+Z26CbA+jipLbUHLD3OrDOFQkQuNQtFaAu
        oveNw8A9pgcYkMHYUVZzJil72FSiTZgGMrGTFsk=
X-Google-Smtp-Source: AMsMyM7lsf/M66FYhm4FZm8OXGsZnMcZ7d27v4HYD/k9gIwMPGwCPboxl9S6/SDdmqYu8hJWO/aAStnzcftWIkw2iqg=
X-Received: by 2002:a17:902:d50f:b0:178:6505:fae3 with SMTP id
 b15-20020a170902d50f00b001786505fae3mr29231679plg.54.1665566019533; Wed, 12
 Oct 2022 02:13:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:249f:b0:45:6892:6b88 with HTTP; Wed, 12 Oct 2022
 02:13:38 -0700 (PDT)
In-Reply-To: <20221012090454.GC14506@amd>
References: <20221010070330.159911806@linuxfoundation.org> <CADo9pHgdB7Czsuw=gxv9jAyrUJLjFNCVLW0CGXfszKrj1EfK1A@mail.gmail.com>
 <20221012090454.GC14506@amd>
From:   Luna Jernberg <droidbittin@gmail.com>
Date:   Wed, 12 Oct 2022 11:13:38 +0200
Message-ID: <CADo9pHj+--=X8LZXr=+_=J-RiWR4P48f-m=J_6VbTv2QgG+usQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
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

model name	: Intel(R) Core(TM) i5-6400 CPU @ 2.70GHz
so amd64 an older HP desktop machine i got from my brother that now
serves life as my Arch Linux homeserver

On 10/12/22, Pavel Machek <pavel@denx.de> wrote:
> Hi!
>
>> Works on Arch Linux
>>
>> Tested-by: Luna Jernberg <droidbittin@gmail.com>
>
> Can we get more details, like list of architectures you build it on
> and list of machines or at least architectures you test it on?
>
> Best regards,
> 								Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
>
