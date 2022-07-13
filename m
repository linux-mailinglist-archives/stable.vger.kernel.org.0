Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368DE5733C6
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 12:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbiGMKHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 06:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiGMKG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 06:06:59 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C82FAC82;
        Wed, 13 Jul 2022 03:06:52 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l68so6201475wml.3;
        Wed, 13 Jul 2022 03:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eAK6Hw3uh7G+ofZOFnR2MgNLiILk5v+8DcThspMZQcc=;
        b=UxXJTE9GFK7QMB4PQpJno35ohQDv9RubcYV6VN/LsV3X2XutglJMyfTAKjfBqTNvQZ
         ru3rHYCIGeU8BAiJu4YZi5NuKjOVKvM2L0pmsbYDLh14U4FNRmA+7YxGqATxXcfcCBMp
         LSBM8UEpvYmM4/drhbkiuS8wz0zM6hiHhR6Dfvzz6aM3xB4c0gZN/ETyZ5MgWpOAY655
         eLjTwXHasDsXWQfJ/hWtsaW794804z5yjZP5aBNptmsSyHpMqLnbPRBZBUweqJzC1Vii
         lXXgnKZYc43qbgiUPkA1Gz/NYpm0qy/1WRumiBj87YJ3hWiPJDFIPqJp2l0p7ANSPAYD
         iq6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eAK6Hw3uh7G+ofZOFnR2MgNLiILk5v+8DcThspMZQcc=;
        b=awQ9lNNhUrYBYGvF2jqt05Wfzr5pSOpTgMm5EfmkDkpq6gJfoL2NTPH7mpsGzpVfzs
         g9Q7heJXuWVRsrf1aMCstr2knnqpEALe3Y7XJzTn1fFDvRiCXO7fWCjjWOXj4ll7h5Rx
         red/Hi1Rtre+4+BOnWSvqbR+vzsbIjtpGUmBebTFt4r/RTS1n0Jh4wrI4zleE3FUkoN0
         ij5+tbPzYNTQGY6/+IZ8UtbeiOeDvOHTidHi1qVeWpLGFVSaHp2ciPBnif4EwFFuUGcD
         kAVgW5DXZ0mYQftHCdxWa2yjch/59nP9Y/RIi/MvjShZ6ysG9mCH9bF8E5mn21mgPOBh
         riDA==
X-Gm-Message-State: AJIora9bJuOHOgEpflheLrzX8ASCl9bK76KC70m8+ONIZNvIPDzKwrIX
        GZavl4u+M/Q1F+DBJlR6cUk=
X-Google-Smtp-Source: AGRyM1t3HpOmL4UF2GMFkyqdU3JazO6CYBII/MAcgLApJu19cwDp22veD72l4xNe4V6n1KXDnzPC+w==
X-Received: by 2002:a05:600c:4e8d:b0:3a1:2e4d:1dd2 with SMTP id f13-20020a05600c4e8d00b003a12e4d1dd2mr8898075wmq.85.1657706810960;
        Wed, 13 Jul 2022 03:06:50 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id t1-20020adfeb81000000b0021d6e49e4ebsm10276543wrn.10.2022.07.13.03.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 03:06:50 -0700 (PDT)
Date:   Wed, 13 Jul 2022 11:06:48 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
Message-ID: <Ys6ZOOa5dfc7AvpQ@debian>
References: <20220712183236.931648980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jul 12, 2022 at 08:38:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.12 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220706):
mips: 59 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1507
[2]. https://openqa.qa.codethink.co.uk/tests/1512
[3]. https://openqa.qa.codethink.co.uk/tests/1513

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
