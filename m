Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CE85839B4
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 09:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiG1Hn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 03:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiG1Hnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 03:43:55 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BD260685;
        Thu, 28 Jul 2022 00:43:55 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t2so1120837ply.2;
        Thu, 28 Jul 2022 00:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ld02fAkkfQOOuyOTcOJP2ZPoGVJcKXaJAF1qWkKBQFU=;
        b=BolG1kEwisLqRQ4VzpTH7v/DNlxzLqYO51lMC29vIUlJIBcvaDLGJURQWrJsxrs8U/
         j4VFGHkB9qBs7D+iEa4fzmt5UMHpQwnrDz+gZJ6ilVU+hSrJR21sKTx7JMiZIc8YZDI4
         rC7eS/foBYSGPL7A5ZKIWxEJlCFjndMohFV14u4UQBeR4o5NDTi/ihWG0TUgRYj2AjF2
         nMhi+SXmG9D7t21+APP9p0Wo3T+iDRV2TFCGFcKlzil2Sy+7XMOfSrjamMKmqeM4IycZ
         5RRUcDD+Q96ErSGZatsEL1qHi0/FuFqf5odyXzRyOSQmNxCo+0Wdu+24YucPZ81x4tSJ
         Jqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ld02fAkkfQOOuyOTcOJP2ZPoGVJcKXaJAF1qWkKBQFU=;
        b=ZwetXX3cw6N7YoFFj6zapYj5lh2W8O7j7D9vulgxRK9zuSFsixVdjpZBIknZ3Za4ay
         8pFIN5S6yREnO3ghw3EA8fW0vLb+UL181mwAs64ry+yC0TorH0LYViONOuBoetIjqOAg
         x1HOq5/1xps1w6nmD+BWD+4ATOTBsS3DzVdBcixx25m0VEtC3UrHSd6WSOZ8vVR1ErrK
         BDe8Tp0P6VUi0C3rp9Pnn039qn97LQEf41vvgv1ZkCN2Cu2IasMA47r76cWXVMQDvYgm
         1e9tXipGT80FR8mHhSBoDa6R4qO7x/r9xX4a18A4vva6xG8mD7T8+Ylr04y1uSYawqSo
         g+1Q==
X-Gm-Message-State: AJIora/jjUU+y1joHDd5M3fFIGuulqPbVGQdsgY2/yF8NzUgFJhb0SV8
        QRChhArUmeAZXmv0KJhy6Y0=
X-Google-Smtp-Source: AGRyM1s3HzMpz9c1oBbT1x2dnRdj1bGj85TmFHhbUHZBPlgBgNdAPgaDx3NA0OrcBtUzk+6HlPev4Q==
X-Received: by 2002:a17:90a:fec:b0:1f2:8c1f:210b with SMTP id 99-20020a17090a0fec00b001f28c1f210bmr8913583pjz.114.1658994234573;
        Thu, 28 Jul 2022 00:43:54 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-25.three.co.id. [180.214.232.25])
        by smtp.gmail.com with ESMTPSA id i2-20020a626d02000000b0052c0a9234e0sm80pfc.11.2022.07.28.00.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 00:43:54 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C45B1104A8A; Thu, 28 Jul 2022 14:43:49 +0700 (WIB)
Date:   Thu, 28 Jul 2022 14:43:49 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/201] 5.15.58-rc1 review
Message-ID: <YuI+NZPGYYg9g/T3@debian.me>
References: <20220727161026.977588183@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 06:08:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
