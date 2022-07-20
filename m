Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06AC57B0E7
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiGTGRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiGTGRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:17:51 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6774E623;
        Tue, 19 Jul 2022 23:17:51 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id bh13so15524394pgb.4;
        Tue, 19 Jul 2022 23:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pqNStkEE5nj9ig4nf4zL5amEb6B5afNSv1tHPbA0Hq8=;
        b=FoRbIBHRIcQY0tFaS9EjSNmKsRK2WkGZmQG6sYMLB+KRD7xLXkdlyzNZIo5XlO56+o
         cdUgrtkJ943ii8qY2JZc4jIILizjFFZz0U7maihfEHWkWq9/aBTleVrMa7qq3joxmwuB
         z7GGS5sHGDADgK5z2r7MbnUyctX9Bc3ZBZHkqR1UNAuasgajmnalMMBHIixNxaKw0VfU
         gHRYV+HnTksDP0stORQcVoCCjqd6rxluNE59o/mIm1RtjiWPBxK5QEDuxC08na1srCCi
         pab0OloEEAh+yCD65FXIJUqYWlyODh7yFTVfRrRLaxE+AK45t7oEwkWEPb/KVkhcVrrW
         71Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=pqNStkEE5nj9ig4nf4zL5amEb6B5afNSv1tHPbA0Hq8=;
        b=kD763vRbPrCaGFU4RNKvFDMt+r6nZgUvKV4JhYwexSprELvry+Jw4F19GwX0buZR5p
         9iR6fTV4sVyQzD96RV7WFYSp90UetS9VRSjF/7CnJUlyleQb8Q9cxQYr5SfGlXWsJR9T
         zepY3mVQNLsBhu5KGhscPLaY3Qr3y98GuQFZ6c0BI7AW94olrtMQNWrSMh6fW8nc0QZb
         r7TM5RCBGhWoa8dx8D/+F3wehNc4KKY6jLpXkNxqG67qWgJGmULoK2neXCSqK6Iy8THh
         kbOsLDXtQfrIn0reZX+dkYR87GxwqneNpdeD87k70JgKiJuR2X3V9vGLVPxFHXir+mHB
         P7XQ==
X-Gm-Message-State: AJIora+4EBDZPB5S49/vU2Y15eISjjBvRImCyrKJBGAgAMb35jBPmciA
        ex5dIjdvoD73a6pRoFEl6OLooWEvhgMJbA==
X-Google-Smtp-Source: AGRyM1sbk9cSp4Iw4XorJ3qB9B5MLgvg5Y1hcP3kSv2xJHltYlKPB7u12xgm/da2KZ6gH89K6p4+4g==
X-Received: by 2002:a63:f91e:0:b0:419:e9dd:6d97 with SMTP id h30-20020a63f91e000000b00419e9dd6d97mr21762241pgi.116.1658297870728;
        Tue, 19 Jul 2022 23:17:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q8-20020aa79828000000b00527bb6fff6csm12568546pfl.119.2022.07.19.23.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:17:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jul 2022 23:17:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/43] 4.14.289-rc1 review
Message-ID: <20220720061748.GB4107175@roeck-us.net>
References: <20220719114521.868169025@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:53:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.289 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
