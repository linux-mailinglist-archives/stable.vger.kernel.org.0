Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7F255DCE2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243333AbiF1Di2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 23:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243270AbiF1Di1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 23:38:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD72910BC;
        Mon, 27 Jun 2022 20:38:25 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a11-20020a17090acb8b00b001eca0041455so11222002pju.1;
        Mon, 27 Jun 2022 20:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6LMGa772Cpd0fqJMV5Tx0e6cc7BPyO68l6tpza+MHVo=;
        b=htVqiZjV5qqLRbXWpBXmAO1ENps0ZLH4I+BQJbGKDEqqW8QfHbsfyc5LqHoC6osMZg
         EGF/SpS7djBz/a2VPXsH+vjyySXP+rKr+nadJUKyoW5KeOilyJm2IBd2wO+vo9w61vJ4
         n3yAD1UFe6HnC0OJ13unnCKPf/7B+hxWPCWIMKsL5ASLZwD5nAIeKsugl6YA0Q4GVNbn
         gN4gCs9w3iXW6hBkRAPfROxDnVit9Amg4SQ5jSQO/ZCJfIFcdC6p2V9KyDaoBtb3lh5t
         6JaA44IrM8MGWJCg7F3MsieNyzQzcuwXBsiyS1wqX8pHza4gAEsOjDVszMfZ3ZC3Qm2l
         2AbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6LMGa772Cpd0fqJMV5Tx0e6cc7BPyO68l6tpza+MHVo=;
        b=OPkmZ6WeK4uoM4SzFvBQicltZc2IW/taugM1x4N7525SNsFmzf9xVoM1Wt6DHFQU1C
         fzL9JAe8Z4uvkFMQiPzqCpRcReopZgJhc7sod0sk+mPLjZQP0xpHHXpfrq87lVrsz4Cv
         ZlL51WidteZXgrcrRjb4M4ytkJpQSs2RioPncXegBf7OVaAGRHg/siaUV5IyE81K4jl6
         TlU9hNrAfzCj7erYF68V45I50AGfBaOyvZZw0Wbyf7iiqDN5uPiwP8kESunofcV+3XAm
         9VW0pI863ibKIgRG39A3xmGBHaxsH5O/YMarrPJa8sf1I6vIxzVJBlT3iba6z6+X1Voy
         AdBg==
X-Gm-Message-State: AJIora96Q24cTT+4bp/uCrlQ8XE9cS1FVF3/6jl3fQpQSkdJfoeVmz3P
        zdLaQUzLaafzVKdra/7TBY4=
X-Google-Smtp-Source: AGRyM1sHwuvpJO6RjuZx3nVYz/CeSLidfhL7YlhXXD+pDd7J4W2/ukr2qRt5eWiCNxXbOwCwRlQxkg==
X-Received: by 2002:a17:90a:1c09:b0:1ea:91d4:5a7f with SMTP id s9-20020a17090a1c0900b001ea91d45a7fmr25203743pjs.232.1656387505374;
        Mon, 27 Jun 2022 20:38:25 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-91.three.co.id. [180.214.232.91])
        by smtp.gmail.com with ESMTPSA id d1-20020a170902e14100b0015ea95948ebsm7971740pla.134.2022.06.27.20.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 20:38:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 725F61037D8; Tue, 28 Jun 2022 10:38:20 +0700 (WIB)
Date:   Tue, 28 Jun 2022 10:38:19 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
Message-ID: <Yrp3q1gpvfUm8QIP@debian.me>
References: <20220627111938.151743692@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 01:20:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.51 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
armv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

But I see a warning on arm64 build:

  CC [M]  drivers/staging/r8188eu/core/rtw_br_ext.o
  CC [M]  net/batman-adv/tvlv.o
In function '__nat25_add_pppoe_tag',
    inlined from 'nat25_db_handle' at drivers/staging/r8188eu/core/rtw_br_ext.c:520:11:
drivers/staging/r8188eu/core/rtw_br_ext.c:83:9: warning: 'memcpy' reading between 2052 and 9220 bytes from a region of size 40 [-Wstringop-overread]
   83 |         memcpy((unsigned char *)ph->tag, tag, data_len);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/staging/r8188eu/core/rtw_br_ext.c: In function 'nat25_db_handle':
drivers/staging/r8188eu/core/rtw_br_ext.c:489:63: note: source object 'tag_buf' of size 40
  489 |                                                 unsigned char tag_buf[40];
      |                                                               ^~~~~~~

Introduced by commit 15865124feed88 ("staging: r8188eu: introduce new core dir
for RTL8188eu driver").

Anyway,
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
