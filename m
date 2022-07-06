Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B1B5689E8
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 15:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiGFNpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 09:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiGFNoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 09:44:55 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1C1DEF2;
        Wed,  6 Jul 2022 06:44:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id j184so3416718pge.10;
        Wed, 06 Jul 2022 06:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p1aOiGwzgulAkJynWH7Bm3Wo1YreFINZ80weAfTWr2I=;
        b=MAQ7yLz4YydiJZAnDHJCXntKbujkqkgXgKbg42QOFcJ8yoAvzJs33i4GOdZyPWCDOX
         J2+xRuUtSFHatG+oIEAlGDLbs3pQA3XHYY1FS6xCjor9czMoGTl6iSdUy5rlnwRDTdFY
         LgLHgdKB91qzJBYJyDaF7P6XVQ5Ol7TN4/t1b2vYYOHgn8iPgDIy+dyqNMzOfguH3ke2
         Yud0whcBSMcj/vwPfxv/gicO+EpEv8F67s9enXWJYnxh5iLAe1YffL4gWQDL4hly3itw
         LE0YN0zv5OA5TLDE1FxPsmXQoC3To7Xw3Cg2z567F+M9qZW8hd/jtT9ipfj9Us+aDzL4
         mn0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=p1aOiGwzgulAkJynWH7Bm3Wo1YreFINZ80weAfTWr2I=;
        b=l2Mj8/R85xcJ8gZ6IwT2WvksOogoSl8f+kOqCRLc3HJs4VjlWJpOAZBMwbJEqOw9LT
         izAKQupwq9WWBC8KUI3a9Y7URmUikPiQ7DAvhZt0JoJoVaEsvJt6g72GjMi0TWCP3wd/
         kDrt6dbW27dQbbA1DuuzCQEe5LVwecAS4LYj6RUDTRRDpDT/Mkh6HiXGqLO6ogmhE/pH
         GkUHC+cFqqLhgAnlTtKqZYC2rFO66JVWsPwqo4vRLhMQbwOWzuUY/zdeusZmnZ3nQY0W
         F+DZ4Iponq9M2SGrtcWsSmurQIC8ULwvKzTHPEHUhGKfA6kYf2YprNsV170DEALsBtwA
         9Kdw==
X-Gm-Message-State: AJIora+YAY2cVAOUct+OOK2muqTB3b9zpIPEX+H/JpKQhlTkc+u3AchA
        aLe4DW6Gc4RUDIQQcOYGm6EP807Yt0i/Tg==
X-Google-Smtp-Source: AGRyM1vszKvydOraRqBGMR4KNC3eB+Fe3zA3VZ1n9NutytWKrab+7M3Ax7gV3U06L06GyJZFb4pGvQ==
X-Received: by 2002:a05:6a00:2387:b0:525:7314:7cf with SMTP id f7-20020a056a00238700b00525731407cfmr47936515pfc.84.1657115094455;
        Wed, 06 Jul 2022 06:44:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x12-20020a170902ec8c00b0016bedb7ed1esm4996834plg.116.2022.07.06.06.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 06:44:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Jul 2022 06:44:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/98] 5.15.53-rc1 review
Message-ID: <20220706134453.GF769692@roeck-us.net>
References: <20220705115617.568350164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 01:57:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.53 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
