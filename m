Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A10253D836
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbiFDSz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239717AbiFDSzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:55:54 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9680B4DF75;
        Sat,  4 Jun 2022 11:55:53 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-f16a3e0529so14552883fac.2;
        Sat, 04 Jun 2022 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7NWYyyweloxEKrOnq4kqHbezc+YyKwo6EjahPQWT03E=;
        b=IeERvP5OrUAkWbvbb0vNJBw9CAGZXXjVzzOtTy0MahtnZO2h95SFHZL7sU5yFurPEo
         0hDK0qcRi982yeiQvirGim3bWzKOFXhYljePG+4lGNJGJ7TOgiNzDwuTJn57ShH3IuT9
         2TFpJBI6nUarmvBuA/rrhdXBT2LcZ4ZEByFjXvtZVggitGHYWL7Ih825+PFcsgUz8x8J
         9o6oyEMY6cZjO8YVj8XR8i+8xSGTOl2EEfbtfyg0VlW9WpHxT7WxfuDUYOiI6SUOu1Nw
         DnxbJKwqRf8umlh7I9WHORKsanvwVZsCcbTOzEfKsj8+BgmXdGEdzYEF5Ju/a24yB4aD
         YHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7NWYyyweloxEKrOnq4kqHbezc+YyKwo6EjahPQWT03E=;
        b=VSuh1MdenLWZXQuvtD93dWxClTHQ2BbJ1tuT7NbxSMpmDGA9/9sVy+AkZkGs6pqXt8
         ERouveqIo1wyiURiw3wUc7W9BfrAtoodqb8PzUJW40OCJLUYmN6li6w/R1aGr1epTc+V
         OeRyQBJSa5vIw7Mnxnmr2BwwhjvoI+AH9wMzp6OgRE6O3HqneyZzmvoetPvvu2fiD1XN
         qM9Tq7tsqmZMSLAKjhb66pR7BzAVo26lDOUBPFq4qkwbjOJDV9O509D7q7/GDn7LlML/
         y52RCFznrOuHYrK5d3rDas4uQcwFDsMfUpTj+gu65FpIuEr4wVdgk8vc0a41zeipFtP+
         I9kg==
X-Gm-Message-State: AOAM5336LjDC+dqm9VxvjFz+CepaqVNJb9/uk47b0acSKx4GaslA8/GL
        aF1+2QADpxQr0kAqLxNnVSc=
X-Google-Smtp-Source: ABdhPJwtDBdShpSAiGFla77BgbIt12MNLybLXnkv3iuhC1gO0ctJkNPREobwyvuuKMEWHBiHI+egOw==
X-Received: by 2002:a05:6870:8a2c:b0:fb:d45:23d0 with SMTP id p44-20020a0568708a2c00b000fb0d4523d0mr4662804oaq.33.1654368952999;
        Sat, 04 Jun 2022 11:55:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bf1-20020a056808190100b0032af3cffac7sm6222201oib.2.2022.06.04.11.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 11:55:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Jun 2022 11:55:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 00/75] 5.17.13-rc1 review
Message-ID: <20220604185551.GF3955081@roeck-us.net>
References: <20220603173821.749019262@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:42:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.13 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
