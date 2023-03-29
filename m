Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29A56CD7C5
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 12:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjC2Kes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 06:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjC2Ke3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 06:34:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0D249DC
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:34:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so15680400pjt.5
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1680086054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+G0x4df8nN5k7A1CedGNXaYeU9br6DP1S70P25KOU3Q=;
        b=leicsZUabtl/b04clZPzdxhIVtE92NjsAby5skkmC4BOrHrwDbqMDxyNy7EYxS/KMO
         pEfo1a6DcBrFeFSzXBkyZigB2nsKXlYpwMHc+X552mssmZFgNZuHXRal13MypE8FXa+q
         0R2JXsv0JPohslv6/ObMVaQDVHWIAAa3gwQ6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680086054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+G0x4df8nN5k7A1CedGNXaYeU9br6DP1S70P25KOU3Q=;
        b=ktQGQ9hFwb4WpwgidirwICV8+DMU8k/0BRr9+BI6ueeNqtzPL74NOGcz51j39yFHIU
         xFzw8PvY1TZmRX/KQDJh9oVo2nvYNkZuE1zymDuBU2KNDBTwT4K/OIG7ZrzV08m2opyx
         KkX+gxRCKHMn7cbiNFFu4QD4aoZJh0r6021fdgwyh/2G7eK7+T7xx0jyDMadtosfPHeI
         lP9VJ/zyOhhM6oq9TiA5oZhu8NGQRQquu2gMQZDiiA0atYmWV6st9v6YBUtDT5Cncfl6
         aB6KTnfJv1fPFT+Tmuh7QBQgI8YYYpFR3hxhb4Q+Z4IIyubblHMDrmKdnp9WLIv+fcny
         NGug==
X-Gm-Message-State: AAQBX9dus9fXcjU4RBcKSbnS9NJleoj8QCxkbT9j6DSwqt8rsEyn2Ve6
        DL2H5+4cnazvL6rhikWzEhH6Hg==
X-Google-Smtp-Source: AKy350Z7IkUvnWfi8bjLMEeSSg/1XJxBZz8APPh8P42x16gp4l7TciaEW0XJpMJcStPFJvhfLDdnIQ==
X-Received: by 2002:a17:90a:1de:b0:234:b964:5703 with SMTP id 30-20020a17090a01de00b00234b9645703mr20022640pjd.18.1680086054136;
        Wed, 29 Mar 2023 03:34:14 -0700 (PDT)
Received: from 67ca92301206 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id lt15-20020a17090b354f00b0023b2bc8ebc4sm1160182pjb.9.2023.03.29.03.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 03:34:13 -0700 (PDT)
Date:   Wed, 29 Mar 2023 10:34:05 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <20230329103405.GA8@67ca92301206>
References: <20230328142617.205414124@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 04:39:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.22-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
