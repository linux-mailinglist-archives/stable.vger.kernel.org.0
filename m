Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F73E5A5888
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 02:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiH3Ary (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 20:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiH3Arx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 20:47:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A6E7FF8C;
        Mon, 29 Aug 2022 17:47:53 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso16318885pjk.0;
        Mon, 29 Aug 2022 17:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=OGiDFGZnbFj8/1mCX69wfPLWi7ySipoBwRAyqNUJ0MQ=;
        b=S7cdEUtd6JAsr+oz7iEIcMY6/9MALwyGIG0KdPX3bCUBaZuldwATPioDv55/lEuTg5
         veFKMNfq0n+vF8Fuj+tTZkYeWk2+5nN0Bor7fpMz6sYnUBQUEZ1u1KT94H6+XHffCY7P
         y+Lkau+8S2q7FKofWLVMYgQ69A0xymZCojz0x4LgB+SbIKFOml+WyCk63fB1tFJ0QOWC
         ENyUoMyL7An6XO5XWB7Hgs/MSqINtWuqlyjzEM4w++6JoNHjUfoNd7k1BozUgAOrdeVF
         Gtu9YPMtISFttpnpwJDC+TeF0nYGjqd/WtdgL5NycMYZrOn/by8cLVigMY7qYtN79veD
         nRuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=OGiDFGZnbFj8/1mCX69wfPLWi7ySipoBwRAyqNUJ0MQ=;
        b=wwDmQVxyQ+Nil1mvlfm7prjgs6QS68JuEzMCVQZbMdg7GXxPlZfnlGmOvSY5FWck/F
         JR8937fBbSajQm7zNAXNCDy7dvM24nXyG3/oTlTrSl5AjQkpA48t1YPAVkUdHWLtF4uk
         ex+XeQDyBNk2MfwP9kRZnXsCIUD4cGrGoUopjn5yFu/t8bKXUmEPbrpz1NfDnWmstbh6
         QgB0UsFCIE6W36odm7KHUQbyz4V2s2Bs8P8vQbUY2qr81WTjWQ+u1eb5mJJzM2JL9XsD
         Lx7BaISXvzp0Us0R2+fTF5SD8T+zrZSMVvOYrYL/hWdB0dTRxfqDYRNzJlT+DAjm3SmB
         DI9A==
X-Gm-Message-State: ACgBeo3Y9LIa2QqchafMI31EIDxYxfSCGrh8uaP7Xa7z/YvY4YtXxbH9
        ftYObwltLrNZcdNwQDaTictzyiH/KdaumQ==
X-Google-Smtp-Source: AA6agR7n+RdR8Pemxbu3Xbfc5dgi6hCBHpUHyGkeX7XnQXZ3rxrc1UptSbEuEeHOfAP3TVZ8WQr8Fg==
X-Received: by 2002:a17:902:e947:b0:170:d739:8cbe with SMTP id b7-20020a170902e94700b00170d7398cbemr19340963pll.141.1661820472660;
        Mon, 29 Aug 2022 17:47:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x13-20020a17090300cd00b00174e086c752sm2364634plc.121.2022.08.29.17.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 17:47:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Aug 2022 17:47:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/86] 5.10.140-rc1 review
Message-ID: <20220830004749.GA3337218@roeck-us.net>
References: <20220829105756.500128871@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
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

On Mon, Aug 29, 2022 at 12:58:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.140 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
