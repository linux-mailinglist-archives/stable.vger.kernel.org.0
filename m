Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18495071FF
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 17:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353953AbiDSPmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 11:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353949AbiDSPmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 11:42:03 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7451A393;
        Tue, 19 Apr 2022 08:39:20 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y10so16344768ejw.8;
        Tue, 19 Apr 2022 08:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=33LchwTrEhdlnLyKbglv7/dtQNUqBirb2JXkyZQUCOc=;
        b=KgIPGLiNfLKXnt1jpVRt5QA9LPjkD93A6q67UDQbvKjwk1tPR46ssvNtz5bei+hj04
         SlKXUGRKwYWBShyJwsfzhjHigOxQu3sVeCdW4s1zJVE8p94Nr45zTAXxwqCYEkU0GFGe
         C/0EsUcK/XaZvOlWjewEUS56b0Ew01EqPoBd8ZnvxNSUaz06+xCUigeuNBmZimKP17IK
         j75SAFsiQvC/GemVJjYpiHUXsRbnrl77h1HenYLdWDt5G3X77MFGj22Pn3/1GAdCm4bP
         6QwtNuP5KPgFHOtFXAf8iXxCFbQWcem6mLg5KaNz+AHnO0zeE98TtjVJJVJjJ84XPaT5
         XiSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=33LchwTrEhdlnLyKbglv7/dtQNUqBirb2JXkyZQUCOc=;
        b=PojzisVRoinA0hZOQMyydtOnYHLzI4xZwnr5tAjGXw27/lU0qR+JW+ICTDpwdLh6t5
         tKLiJ9bAMMKyfk2YFmR11uw0WcrUTyUmwuKPaq1cQQ688WTm7N4WMhCTifOih5/zZUxl
         B3z/GBFfzuVVdhWZXE5+ztUxQmRfU4ZF3FtdXH7LKdn0dScyVrBdHAV230ClPdxIA478
         ctLX/Px2s4BsQchaipoXhGIRjsGJ1EsVE9eeRxbrvao59c36MiVsjL08WOI6VvisCGzl
         7xSgSbLbpk0JtETX+6XoPune8jXZIKlWHdGA+HOeU6hJUPb8FnCJgK71G+K/t1HbLBSj
         tCMQ==
X-Gm-Message-State: AOAM531x7XKRkhQ2JmaAd58zOqjqZgFbCdVrzPsLOpjisL5HlpVdBTQD
        XNkNOrQ3OQD6SDXPgUMEVgM=
X-Google-Smtp-Source: ABdhPJyTX2xrgCGJF499BXA4Zflfu2URrbPB7ZmtLtU3TlYb17I6w1x2kexgEL0gjvwBjhG+cAJrEQ==
X-Received: by 2002:a17:906:4ad9:b0:6cf:93f:f77e with SMTP id u25-20020a1709064ad900b006cf093ff77emr14209516ejt.558.1650382758838;
        Tue, 19 Apr 2022 08:39:18 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b006d2a835ac33sm5768030ejc.197.2022.04.19.08.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 08:39:18 -0700 (PDT)
Date:   Tue, 19 Apr 2022 16:39:16 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc2 review
Message-ID: <Yl7XpJ4DQQ/01UWa@debian>
References: <20220419073048.315594917@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419073048.315594917@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Apr 19, 2022 at 09:32:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Apr 2022 07:30:20 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 62 configs -> no failure
arm (gcc version 11.2.1 20220408): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1039
[2]. https://openqa.qa.codethink.co.uk/tests/1040
[3]. https://openqa.qa.codethink.co.uk/tests/1041

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

