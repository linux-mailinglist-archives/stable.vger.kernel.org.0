Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B12527248
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiENO5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiENO5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:57:01 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D8F2644;
        Sat, 14 May 2022 07:56:59 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id z5-20020a9d62c5000000b00606041d11f1so7007078otk.2;
        Sat, 14 May 2022 07:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wRNDH6PTPiAzerFSEmuZw4zFBMiXy2l+20ohpH1Ko84=;
        b=WcgIxiECDnbFc6grOIO1BNxxCtTmG/eYEE7dIwLXcpmjU2LGD3tbpd64iiEkIEvs8h
         i787v2Zqm+GayEzbOH3+hTDOw6N/KSJL4MoQO8CE3kBMM7YzhljmnflDhNpWISrUjsWq
         Cq6/cea+9DwUbaV4nTITs77pmxEZ5Rp6YtgMmLQY3qcHPxg8KL9EBz8txETStd+ejzN/
         Vgfs+ZvHRFyDRC+5Lt9JJkqTuI394J8gF8E/Y+MN2GE75ekiOmybmzVHVtMQPauwhVgT
         A5uIJn4UhfdLLsMDq56wtz4Jr0nrA6dNcpcB5JMYkzVO66ZFfl+FkgCn1v/ANoE3+hLq
         y6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wRNDH6PTPiAzerFSEmuZw4zFBMiXy2l+20ohpH1Ko84=;
        b=AZtsnoaAd5iFvWki6HStMkr9fZ6had6AzcPsmx1+u6Vcp7zLHRvjeOALc53jnFV4Q/
         5I3MQBPzpT0AfEn3jhlMgqYh7Pn12Jzq/TxvPu9sHJ75mHXy1HyuGcHiSQvoO7hCCOvr
         /4wOZPdGfYpjjECTaQiHbJN0Sc1PLCw7cbu0nWmtXPpDeuJMlLHUsus16qWAIrGs7jrs
         2vuhpsDJwDZU6vUlbQOkreb/df7hEEjYdEBXcWINpt7o0cInFNd9LzIiwo+vsEcFnYxu
         Jwf9MB+27SWOxIQnOQqwc5BuvGd7HwoMBCtR5smNvkWfJmTiiY+m091Hr+0KZJ/4WvR0
         VvDg==
X-Gm-Message-State: AOAM532JMums3KXAQ4HqZ6FA782YyqhPNPpGmNDumjnsx9kO45Ha4WEh
        07ZGLDboHawa1foO1TznVGQ=
X-Google-Smtp-Source: ABdhPJzZd50f63hXiJFmdfD5cwVoH2eTR9xA5Z2UrHAoASZOgBz/Uc1nxu1ZMesNWXRILfodn/q+FA==
X-Received: by 2002:a9d:4f12:0:b0:605:e45f:a533 with SMTP id d18-20020a9d4f12000000b00605e45fa533mr3568010otl.293.1652540219311;
        Sat, 14 May 2022 07:56:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bi5-20020a056808188500b00325cda1ff96sm2321963oib.21.2022.05.14.07.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:56:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 May 2022 07:56:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/10] 5.10.116-rc1 review
Message-ID: <20220514145657.GE1322724@roeck-us.net>
References: <20220513142228.303546319@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:23:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.116 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
