Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341CB52724A
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbiENO5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiENO5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:57:30 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453E42644;
        Sat, 14 May 2022 07:57:29 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id q7-20020a4adc47000000b0035f4d798376so3275549oov.6;
        Sat, 14 May 2022 07:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+fx9gQleDUXi15OvpODAVjLikH7NVxmDsPHuY7CBKoM=;
        b=aTut+jjNaRKyxvwykbHMCeImoCqF37H09MvQSOt5taeaicx1DNGHBmJ5Zujwuef6jC
         Uw0mJhLenXiro0lnkAxqmHIi6iFaPh5VsK3vE0Hlyz/uBhjz32Tjs/uyPTXxHga1PM8x
         wf2b5CztUFjtIRiQM6bSZzoP5Xe7FbqzOg4SMhXtkevnC2dy24Jjvy3/W93+5QQoptzO
         N8NbI8wPmE5TAIRQw5gRhhh5NOPGV3LOSbskZUPdNb/2YRzhf5cPz9D5O9q54yQjknqX
         9rp3Js1XDT1ok3O0jqbIiyk60NSOz1sAlN0xZ+zSgBxVF1Nsaw/5Zxjb1mHsMGoOjV+5
         R2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+fx9gQleDUXi15OvpODAVjLikH7NVxmDsPHuY7CBKoM=;
        b=fqo3M8LPj+7AslQhAOCioa8yyOBGYzEqFx2tmwsJ+Gc0woFv9jRvCyXIsuMGznyDUy
         82LJIUiccL0CjFAFcu8nuy+DD5Tx4ziMSAL274svJ7ZxRpACTSamK3Pll6rTqUIvb4pP
         UcjwifCPw+ZJwzrcxRzDV/mHidkeRXWaD76mA1L0g09zhwST5QtghNVXm94pCoX015ye
         srOobv9Vs29DyNxQZ9MOMwRg+pU841zTAxTq9wzuhtZE9NHiVydhARYjJmC7f1+SKoZy
         7fQFiVqwvzxRDsr19EVNPtVWHkjGZzrlsJAtgrW8mk83J6Zo8rNPtj+FQxWlr7WNpajv
         1vqA==
X-Gm-Message-State: AOAM530Oy/MMppE9e4p8x1JkpKHRVRpO8XaPiesa4Fsi2U8T0ozqxmkg
        L/mbmMK6jnkMF8t1tomh+JE=
X-Google-Smtp-Source: ABdhPJwXq866RBhoGqOQG1ZbWy6pYqCy4odfowcaaescMKQ3rt6Z25w0VwJBUTjdnWiroi95vwWjrw==
X-Received: by 2002:a4a:db95:0:b0:35e:94fc:5cf8 with SMTP id s21-20020a4adb95000000b0035e94fc5cf8mr3716053oou.48.1652540248637;
        Sat, 14 May 2022 07:57:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h5-20020a9d6005000000b006060322126bsm2097273otj.59.2022.05.14.07.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:57:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 May 2022 07:57:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/21] 5.15.40-rc1 review
Message-ID: <20220514145726.GF1322724@roeck-us.net>
References: <20220513142229.874949670@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:23:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.40 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
