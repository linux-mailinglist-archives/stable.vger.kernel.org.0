Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D12570F42
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 03:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiGLBL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 21:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiGLBLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 21:11:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B934C371AE;
        Mon, 11 Jul 2022 18:11:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a15so6301664pjs.0;
        Mon, 11 Jul 2022 18:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=79mv9H2qFeFF/9ijdg/LRxKVZ4H29pDTE7A2HsCJppQ=;
        b=F6FBfbDXgu4bHnmOg6l5HZV9ubHlQJV+48HGRU014wXJvHXtctsOSWrP588PF7omfl
         Uv58SRsoJLEYpIv1uJUO0YmGtNLj8FhiZAXZahd+70hk8K3hiH7w5IMRfgJ2V3s13tb8
         7Z+sqitVUye4qvsOsl781GsSCaVJkzfwBR7F+AwKxLbWInC/QiH3RXvTTqQ9mMlosbU/
         YfIx5vP1y/UHmQvDGQIJQWwfGELehu0bj6O6+/KtE3I10rji20EBfkKMGXfTruu38sWB
         BjgqqUcMR2HJoJFfGkI5hJbcuj6eddHhncCUr63NIw7O+TCUeIgDluMcsmnYFmeRGcMd
         NqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=79mv9H2qFeFF/9ijdg/LRxKVZ4H29pDTE7A2HsCJppQ=;
        b=5592Sm7kGKKlAMhEaQV+qWmzLWjIEb09saz9TQLZHxNr1p6q/hJlMtZMokuAWLlvIp
         vedCPSb3cZA5HjZlAaAUivP5OptQehlzQ9CP1CVsOtDQAglrkr/AOAyQEudPeOQnst5S
         eX+FHYLvACecTS3S2nvi2gqyPx4RxzdOFHJnbTL3AgdSceA3+iZe9EF3U++/CxuKQ0X8
         ogHq/D1tjrTtyn46B25tbe0V14Vusz1PJ7vNrpuIRfD+fCtBziC4mQ13qT7rPEnzRwL5
         qSYAQRgonehAWRFjaSzKxhpeePAdqbFoX0nfrwOGy9mrKDHojEUdbM2PVQ2jlvs1wvKY
         9Axw==
X-Gm-Message-State: AJIora8d2CDN8S9fxQsuTlhtr6pbIaLMMVzc/KoHdO7PSa2uAHaXgODd
        5BZFhdV3HsTKONQcKQXcXU8=
X-Google-Smtp-Source: AGRyM1td3yDx8TKtN5Bue/e1U+a7l5SRQS0jEFsm8wUjBaaMSPIzbBI6/Au8P9SzGSmWUfUGwgHbPA==
X-Received: by 2002:a17:90a:1117:b0:1f0:5361:1712 with SMTP id d23-20020a17090a111700b001f053611712mr1269889pja.239.1657588313312;
        Mon, 11 Jul 2022 18:11:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r30-20020aa7989e000000b00528baea53afsm5391096pfl.46.2022.07.11.18.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 18:11:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jul 2022 18:11:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/31] 4.19.252-rc1 review
Message-ID: <20220712011151.GC2305683@roeck-us.net>
References: <20220711090537.841305347@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
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

On Mon, Jul 11, 2022 at 11:06:39AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.252 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
