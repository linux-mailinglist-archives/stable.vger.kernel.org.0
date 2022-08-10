Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5A658ED1B
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiHJNZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiHJNZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:25:07 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA8F2A432;
        Wed, 10 Aug 2022 06:25:05 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id a18-20020a05600c349200b003a30de68697so1698996wmq.0;
        Wed, 10 Aug 2022 06:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=YKlnB/xQvDlOLZg9g4bam4igpyaDLMq+fXBsPOzdF0A=;
        b=ppEqai2qf+x14QFGYV4tdxooO+UgJNXzga6KQZ39oJ1xFt5LU2RZZ6i20TM7APVmet
         smmrkY3MKVONKHYqK2cspwTysW2jmzsUvznHk+tsOHPm7fK5czU+UkT56IU3KKGZdJB+
         YYyoxoBAwk2zYorSXqBJ5tLUKE+bPKt9nSuTtA+au9H9HGSkuO7csp8VjSPVePgc1xb5
         VnYM9iNFICGLBNfIVgj94+ue5E8ZJvTPhPcs4i3fQADd1NA57SdqeugjqTiywnK2spxp
         iKXLAQJfTxUrEm/xEwTTHPZS46Q1pqMrrih+IyzoE5xVkMy5SNhVeR4hZkFFi+y7gC8s
         14Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YKlnB/xQvDlOLZg9g4bam4igpyaDLMq+fXBsPOzdF0A=;
        b=Oz3I/PgYm4Gsa6L1GdNvuNmHn6l1hEMP821Vjoe3Pl2HekrUIKFHZdy8O7ZR2afXub
         alKQJQ+rPJT0mj6LMTEGKhJp2QmAyxg9rQb5YHc80ILIfuK2hgScVCRa7mj7lJRJPY8y
         GSvWLHIbsygQxl2yk/W8AjAjAhZBMAft8L1rk4/an/ujcSHOxhAIn6eN2YWWTBrqQl68
         HcRVhiHS/TUOWpoi1pQcUcBu/Qx38GDccgfnbq6JWB7sUwox0tm21AgG9PfY1HGK5J2L
         ugu4tg4tbYK2eZ2JLEjCYI30LhdIL6Ss1ZDdhjQJB1+faTCb2G0OZfsmNR0gi3TBJyzK
         Pq+A==
X-Gm-Message-State: ACgBeo1mgpSn88zNJrXkyHNdNPQhfU1kVrU3momoF7NW+jEjP3JCdvH/
        FWqHbL9U83lW3B+AjWJLnKY=
X-Google-Smtp-Source: AA6agR7ZRA/Zo1ZmPdtBdfXkAQtKQVHSXs7vvbJIMVE6EM8frntTMiIVb/NJuyh1N23gDC1dfkDFTw==
X-Received: by 2002:a05:600c:1c83:b0:3a3:2631:2fec with SMTP id k3-20020a05600c1c8300b003a326312fecmr2387074wms.155.1660137904218;
        Wed, 10 Aug 2022 06:25:04 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id e9-20020a05600c4e4900b003a5a4635fadsm2523935wmq.37.2022.08.10.06.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:25:03 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:24:53 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/30] 5.15.60-rc1 review
Message-ID: <YvOxpRimMX4ADM+7@debian>
References: <20220809175514.276643253@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 08:00:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.60 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220807):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1619
[2]. https://openqa.qa.codethink.co.uk/tests/1625
[3]. https://openqa.qa.codethink.co.uk/tests/1626

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
