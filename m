Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAAF6E81B6
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 21:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjDSTPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 15:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjDSTPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 15:15:11 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC5F527C;
        Wed, 19 Apr 2023 12:15:10 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-5144043d9d1so83064a12.3;
        Wed, 19 Apr 2023 12:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681931710; x=1684523710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=syjt/k5qWCL0P1uU40/xSeDGborcvz1X6BHF/A89cyg=;
        b=kPMQUtmFLHdC2pdMOcVVsQ0V7XB3dMzz7FXFM/yyb8l1HL2dHL0nvw9b2sHt/fut0D
         wMxhR3huLcaEnZxK9DDSE03hgftGsIjbh+x4PPJWOa4lVacSA6d0ygDVuxRPaOPZW1yX
         WadUdRHqAPm+UHZKInPvbPPWjc9gGuJCOOr6//t2tPIBR8mOu09vRBxjaBaLvn0vEEjo
         AmLCAjlNYxEPqTRcUsiQh1A/Ro8o1rnjijS/9LzlNsWFBdz1/toVJILrkERfszXAIMem
         dUmvb765Uwj1zNa6vL6wRvUF0Pelm2w6SzMQvRUm+KXKS1EORJOlfcCwcxertjFWTwZT
         9wLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681931710; x=1684523710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=syjt/k5qWCL0P1uU40/xSeDGborcvz1X6BHF/A89cyg=;
        b=NxLWXzPBVeiKgC6Eu2prPh9eTigkLfNgylbFiX+i5U2tMdxRDIId6cPmbAxceDffJo
         HKvVROeA1ki6JgKncIKnLVK7Xqb626NjbuUNQ9RZiBiayAi5Yd6H8q0Tpuxi5rTUNcBk
         GljUqBNtt7JhhFBqnIcXfUk3BoP/oCVV+wEAatWpcBh0o9h5Fxor4Dzffrz7stbBeu31
         FpGNi+IioGBALcFPdZBYo1zu/JadqBQ0AB/RakQ488xFZQmwj5wwpQYUYA9o/1mUZFZb
         YwEt7PBRquL/zdZ77mAw4jzbSejL+aJnhtqEQIK4Mnb89XKkXbrQmHkISXLpv0MpUJTX
         pxlA==
X-Gm-Message-State: AAQBX9dxbpCHOH7bDhPaLAQUAyI/JqxvuzXD90TXQ2uDoTrbpUkQBj10
        ymKm2bHjlXT2S7MGWaJKaDQ=
X-Google-Smtp-Source: AKy350YCbkg1urE+MYLiNEms0yNX5L4R7TIBO4SeLs6NihVS+L97frK/A/rQVyVkalZJGnCJ9cJI2A==
X-Received: by 2002:a17:90a:1f86:b0:247:5273:dac1 with SMTP id x6-20020a17090a1f8600b002475273dac1mr4265068pja.12.1681931710038;
        Wed, 19 Apr 2023 12:15:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ga14-20020a17090b038e00b00247abbb157fsm1745502pjb.31.2023.04.19.12.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 12:15:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Apr 2023 12:15:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/120] 5.10.178-rc2 review
Message-ID: <bfe2e9c1-95d0-4dfb-97be-d15a7fc03d13@roeck-us.net>
References: <20230419072207.996418578@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419072207.996418578@linuxfoundation.org>
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

On Wed, Apr 19, 2023 at 09:23:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.178 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 07:21:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
