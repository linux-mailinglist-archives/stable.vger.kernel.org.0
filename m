Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C17955A4E0
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 01:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiFXXeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 19:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiFXXeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 19:34:04 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0695857A8;
        Fri, 24 Jun 2022 16:34:03 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d5so3306288plo.12;
        Fri, 24 Jun 2022 16:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vxOfDpDg8T4k6xTp7iSGsB5Fy9mAkHoURHIJacqg3Lg=;
        b=l3bMy7k9bvWJmpD1YyOGIOiP3gy4rAo1MnpujSmLqCJbVpSGcUcRlm1W9W8ge6IWTF
         WKGuocJncWVp1fogE4R5vhBcijGeTWLUO4x9RoPYc/DlUWZSF/zxYQ/mXAn5ct9aUk4b
         roSO/3yjPtUDErqLII30lf21mhoCwIFT7WvjbO2UOJ3r8Ba8Q15btcyvxGhpGj8NlTzz
         +e7EzsSmK5WH54Ko3W968VOtzXtcK4CGhvaqh2cOlHRzKyeHvr2rfD2FZVCTDZSeVfk0
         9fKBRQe2IXP8y4OHjvUyUGmEIpu1ePlN66W1rt2ilk+Q9Y9DyV9jbi7meQ2J/kveXwoy
         RJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vxOfDpDg8T4k6xTp7iSGsB5Fy9mAkHoURHIJacqg3Lg=;
        b=bVlCAgEQ2mx7JDpeuMN3E4FRsf0PDkNKY2hmapCORnWHqFJi9Ch0VIRvWHSA+cYn83
         JKSiFDF4opXyxCgC0MGY+BWnAqqdB4NpZbIMnbhLuO3ZJDIb/q2e7GkN/L26gTwsjax+
         g6j3CPdve6Iuo6eD1BEwyVqnXsAVQ4rj4v5VQF10FZHdKXBo7UqziQ7dimB6f3VCJ7o7
         jNrps+mRpzgopmVh0ukt9898M1a2/HxqPyeubakSoxxUblzWfWJkxDK03yXJCIb/o0cq
         IbCNwIiVqBYaQ5hXA1GKO8W9bzaa0xe5LQh98vEeiXZyiM5pJbfsmg2Rjqav4wrYmaBU
         VBjQ==
X-Gm-Message-State: AJIora9+ev5iP+knUHmtS3LVyDyhy3/YNYufn5VG1JS8+euTzJNbczBA
        3wV6lis9HHkfnqBbCSzkJHQ=
X-Google-Smtp-Source: AGRyM1s9Ml1Z2lZ5B8FiLoLwG9GtCBXHhYoUzS3/Iu95sTTYSzmwTvXGId9zfvaBB179AzEnGslhwg==
X-Received: by 2002:a17:90a:5b:b0:1ec:c27c:8c98 with SMTP id 27-20020a17090a005b00b001ecc27c8c98mr1467615pjb.146.1656113643430;
        Fri, 24 Jun 2022 16:34:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bc26-20020a656d9a000000b0040c8dd84ff5sm2124597pgb.72.2022.06.24.16.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:34:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Jun 2022 16:34:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 000/237] 4.14.285-rc1 review
Message-ID: <20220624233401.GB3341529@roeck-us.net>
References: <20220623164343.132308638@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:40:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.285 release.
> There are 237 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
