Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11871659F68
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 01:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiLaAS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 19:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiLaAS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 19:18:56 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4401E3F0;
        Fri, 30 Dec 2022 16:18:55 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-14fb3809eaeso20360789fac.1;
        Fri, 30 Dec 2022 16:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U65gfQUYRoplG6TAS3ktSDbsYgSOOmACnI2ukxtDlsY=;
        b=IlemQu/qq80xBMvKyMaTOjQE4pvyH4fOBgWLG50ekYVT6p6q7zpu43bRoyO56pMJQG
         V3YKsSwgwYhq4CIXVF6HYvb7N+VF3N6/tbg5YoLclz8LRzGRSivcoPXubM5SE313qEkn
         s6A75rM//ch5SkaMcC/6Am5saNT6HojhWrrdoGBoObGoSK5Wp/H92ZudbGvuNzNtxyB6
         pB+MuR2//GRg8Z3rYO2/qYe7ygLoMH7cYQhlONcEXUJQUKlPcTJCO7m6QNExtC6q9M+5
         7rh03WBRhPPitZk/I75C6pgA9myx1BeTDr2xkmRp2JzzsTXhFV5jOgIxbDs3ibdOX8im
         1LSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U65gfQUYRoplG6TAS3ktSDbsYgSOOmACnI2ukxtDlsY=;
        b=w2Y6igYhRZ3QpGmaXSYtTKWLmh6+GNqpIfKREYr0lRYbJHxZRhcEwYDWK2cny8fCFY
         nywSeyTCyoQFBiGifEpKOf2YEMQc94H98YSa7US7oOfGtrpj/mmHvEt1KrEYyBRF1Bfh
         2thwQnvFz77PJpgYK7P8Fsrt0uHaOuWjDJZ/ObRG0DVm19VXopKySZJWw7GBdoSM+ek6
         JaOHH8Op0Id5SaBjQy1GpU0IrASa1EqGAM5K0t/gmeD8GYdjDqjWPbbQf6hSLwu0X5zQ
         toheVfEoDaBfjp4ks/X/MTyF3Fsg9qKTY995+5uOCpWRzEHog+OzTt6kVlpLvK0iS30d
         eNzw==
X-Gm-Message-State: AFqh2koZNZvzhe5GJe9OKHO4s4AKo2Rq6AWMQ3nKjjNrQ7msYkiWeEMI
        OkFlDu1GH56rIIjR7Je48D0=
X-Google-Smtp-Source: AMrXdXsWY3VWmDmV6hLbhsL6BYH2lvTNsv8dDWthRzf7qn5EoGWPcHNEPSMYBz/yEiSMMnYwpQ2gvg==
X-Received: by 2002:a05:6870:8a21:b0:14c:8b5d:493c with SMTP id p33-20020a0568708a2100b0014c8b5d493cmr18225299oaq.0.1672445934915;
        Fri, 30 Dec 2022 16:18:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eo32-20020a056870eca000b00130d060ce80sm10440198oab.31.2022.12.30.16.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 16:18:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 30 Dec 2022 16:18:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Message-ID: <20221231001853.GC2916712@roeck-us.net>
References: <20221230094107.317705320@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
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

On Fri, Dec 30, 2022 at 10:49:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
