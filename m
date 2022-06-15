Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C16754C080
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 06:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiFOEGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 00:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbiFOEGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 00:06:02 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D712A953;
        Tue, 14 Jun 2022 21:06:00 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 129so10300252pgc.2;
        Tue, 14 Jun 2022 21:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3MdljxvyTO3NouhO0uDbYvYpMidvc+8e9KGGzvyjGtQ=;
        b=eN49rm5Zb8v3DE21nk+L1lNldIUXTPdAHfeWEgFtCHcAr7gkC8Sh2edElBcY1ZA3WC
         Yj+tjr8n/lHgdwX4UHRXQJi2uMjwn1DGjFUKQFphUdZLPoQex/K9NEMqfyMnIAwcciwG
         1k2arrlXPOcT4Q1HjVyP1ePVMxSpMuxA+Jt955Uq+o/5K4THBMKVTBniVI/t8R0yNAX3
         DFP7pybEG+C9wKDb1NBTOSJF1OL5D0sMNHYQ/dFxRZF/XJHXHAEpJSSX970kUWK93kUW
         oI4jLKxYW7jU5YcsGAyZ7MXOh8zG/W4DpPfTwrQCEaWMfdOC3gYBK9HPIINzGi1o17vF
         OREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3MdljxvyTO3NouhO0uDbYvYpMidvc+8e9KGGzvyjGtQ=;
        b=DDSnu2Q3L49tIsharAIW8dKXXAK0vkhT4Z2L+nA1YhHjmi00xOIYvki/N5/0aLLVWm
         EtNdCu/WxOmYnjtJz/v5ZxvDK5Tm/8FhVs7cvt20xPiiGk87SCI9Z9LJEQetPch1/CKj
         s85NOy/yjT3HTycWGFVusa3UYRkh1z0el9QM3cjF2oUQ1in71ZKywhGyXXKkjOSkMTg8
         9J+MNmnjFgeQKUqGTxNP32Ge6Zbi4QrXiqlRz0eZLmMLEj6tKDPHhLMkMTsb2g+TjMnb
         ejH8ZhKE3l7h/GskD5TLKYXdBNfldjrbbBnpvuw1sWbQ+87/AC2m+tVv6EFBQ/kR5Jgm
         ArVg==
X-Gm-Message-State: AOAM530+TpBiQxWkbUHIgC5PyozJv6WTf/zlRLkUoQLu+dO/PKzDkmuP
        jyP2h8jfXxWmpiH4H2bcuffQ6NXp4J2X0g==
X-Google-Smtp-Source: ABdhPJw9LHSknyBiLjqZvJPg3J9W7/wy8MQkLMs68L7WMTM9rYIY1QDHHrI/6xfRRra5BBsFAyQMNQ==
X-Received: by 2002:a65:404c:0:b0:3c6:4018:ffbf with SMTP id h12-20020a65404c000000b003c64018ffbfmr7368454pgp.408.1655265960013;
        Tue, 14 Jun 2022 21:06:00 -0700 (PDT)
Received: from localhost (subs03-180-214-233-74.three.co.id. [180.214.233.74])
        by smtp.gmail.com with ESMTPSA id ay21-20020a056a00301500b0051bc3a2355csm8369267pfb.64.2022.06.14.21.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 21:05:59 -0700 (PDT)
Date:   Wed, 15 Jun 2022 11:05:56 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
Message-ID: <YqlapPTsEAQYAnTv@debian.me>
References: <20220614183720.512073672@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 08:40:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
ARMv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
