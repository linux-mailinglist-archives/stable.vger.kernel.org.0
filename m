Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EDA616EFF
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiKBUow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKBUov (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:44:51 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E10E6463;
        Wed,  2 Nov 2022 13:44:50 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id r15-20020a4abf0f000000b004761c7e6be1so14240oop.9;
        Wed, 02 Nov 2022 13:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0WD9bpr5JJ4KMTp6S73EYzDW3o9+WWWOCwWgbVamhs=;
        b=bX2scgkU89yPPrGITD1zuDsTAQZrcYmRLSebrCdqpJjiiTHjf9dlynwCzD/ng83v/v
         SwsWGsuiy+mQ7zStPGfvev2A7jtrewIp9hTHsHG/LIJR/J3SCt/yaw9rMcXuTvYFXL4L
         VxErbNO8QN2CDs2zXvrBVy8ksu+GSFnvs4j+STEXS3996ZMTQIXf2W9yqPezeEN0q5Zs
         FJzPoyAfiBdbXvtta3lN79U/Ek3bDFyGvTvYgc+qpBhSGgU/1txeNFA4gip8VWqSGkL2
         1Dly2ooS5m//DBecZIeYHizM6f0RV6ZcjnDh5DOiKREuw9kkOEjnonx+zvs51/zn7jmM
         dEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0WD9bpr5JJ4KMTp6S73EYzDW3o9+WWWOCwWgbVamhs=;
        b=4WmPLkZO1cXylZfFiG5PWpwdTZocqvY3UyBq5mZdd9zkxY7xyT/UbkZaQtkACi15Yv
         szAiBMmtyvu+VmC2bgGlQnJsT9wx7Zl4axJecjdBLj2fHUskRszWxasHWW25VOkK+82Q
         +0zbgmzOK8cJPLubL9GKFjbeq0ew4l37Koy+xVEKNVFEGhQwjoJOi+gjY19xaXdBJDvQ
         TC0nF2Xxgrya5TXxZ7Hi8qKz8/Hdrw/VIoFJ1yGfpUE8+BnOjFReyhXYaM+k5DyMbhf8
         hUO3nvE9WS/w2/sMdkDv1pa0v84SH2L0HaGmcOCzlLSQ1G7R6RPMvfxgyGWU/kKSJfOP
         zW7Q==
X-Gm-Message-State: ACrzQf3vQ9qQEZf4igLj68YvmPfC/7Z8R/acRRS+Z+QJd5uhOFgqh+K0
        GY28+jjeJTRruqV35K5u3Nw=
X-Google-Smtp-Source: AMsMyM5XkIVQhWcZiwMbOcFf0NQqDRncK5bZ4Le/9dK640e9I9W12PLvo/VHlfyVRd7s+aUtzVD5+Q==
X-Received: by 2002:a4a:bf16:0:b0:481:1436:49ac with SMTP id r22-20020a4abf16000000b00481143649acmr11389981oop.28.1667421889773;
        Wed, 02 Nov 2022 13:44:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o37-20020a05687096a500b00131c3d4d38fsm6496841oaq.39.2022.11.02.13.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:44:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 2 Nov 2022 13:44:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.9 00/44] 4.9.332-rc1 review
Message-ID: <20221102204448.GB2089083@roeck-us.net>
References: <20221102022049.017479464@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
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

On Wed, Nov 02, 2022 at 03:34:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.332 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
