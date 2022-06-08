Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A40B5430EF
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbiFHNBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239832AbiFHNBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:01:14 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFC6182188;
        Wed,  8 Jun 2022 06:01:13 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b135so18268447pfb.12;
        Wed, 08 Jun 2022 06:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gv2ycoIf3reQ+057cn/ObbcPQa8S7JEf+GBOIKoJePY=;
        b=c7YCQL/ZK5JfAWbqTbxNC7hOtpjfE384WFWLDmcOA5hC1Gpj0rBkKAmRxGbC4NpYMg
         0cvXUvH8hwdJaXXkW/a1UkB/KV3S38dxjWts5z0e7bXUKq3IPdgBN+jBcSHHpttQi55q
         b4pnZ6qnOmcKczPjLOq/7YSTkCrwTRgI0k6evHMI1YJGY+131INj7sRe9IgzdsvtzZJn
         1yJVab51cwtin67h4MozKJZXwJI6m3DCdqnM/vqWv+CQ2u0hgTAQhNHSo6ZTBVYd1DLL
         gA/RinWsAeuqkPu/DCr1Mf2fMnehp4d8j/iKaMdI9ZYCsq0lR7m98n0C3JgVMqRt0bZB
         8eAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gv2ycoIf3reQ+057cn/ObbcPQa8S7JEf+GBOIKoJePY=;
        b=O/7XyedSOC4oi2+kjIuMG/egvCiSdQwaoIvtAmbkYBeloBAu3gSnWhyCiWVXzengH9
         8Zb6yuTBfscoz/zTm8oAxK2ecGBRw7HmpHfRIHHJmJUk+tr2dAEYv+0JnLyo/y8zl7IR
         KWzq06Q8Q7vFIjw5buZhf5XVrkoKb+opccxyn6NmKzLMk765BhCRtt8MT6ip9E/861wO
         BM1XsGU42Fq+qPixXEqKePYPuKKwhzlwRWNkXxULtBcSjjm9+DtDElHndQMuk8DCeCdd
         z7bN3RN4sugwgJ/+m+1zV/HZeP4l9mOyqFdedaIyhO/GlawazoAL4YTdhvyoxf3fiCr6
         WZbw==
X-Gm-Message-State: AOAM533K+tsP1J9A9AgluV8ptHZqNr6szJkPoSWjdej4mJMDQ206GlsE
        tBIVvJEw1IyZv2LjS1eyj/M=
X-Google-Smtp-Source: ABdhPJzxOlpaqz+PDkcOqp8sWE0ThFxh3s+COUf2E069Jd3X7yfm6KwkgpjxjgPQabzLzcod4ng4Zw==
X-Received: by 2002:a05:6a02:19b:b0:3fa:3e63:15fb with SMTP id bj27-20020a056a02019b00b003fa3e6315fbmr30732565pgb.129.1654693273223;
        Wed, 08 Jun 2022 06:01:13 -0700 (PDT)
Received: from localhost (subs03-180-214-233-24.three.co.id. [180.214.233.24])
        by smtp.gmail.com with ESMTPSA id a22-20020a170902b59600b00161ea00350bsm14482825pls.277.2022.06.08.06.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 06:01:12 -0700 (PDT)
Date:   Wed, 8 Jun 2022 20:01:09 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/667] 5.15.46-rc1 review
Message-ID: <YqCdlXr+m4c5sgTP@debian.me>
References: <20220607164934.766888869@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 06:54:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.46 release.
> There are 667 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0) and
arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
