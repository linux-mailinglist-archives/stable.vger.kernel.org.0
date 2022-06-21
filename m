Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC771552F3B
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiFUJ51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347270AbiFUJ50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:57:26 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829B127CF1;
        Tue, 21 Jun 2022 02:57:25 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id bo5so12622357pfb.4;
        Tue, 21 Jun 2022 02:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zLrX8Nbz/ii0DbaDDTWzWJ9REoXF+EZTeLsLu8+k9QA=;
        b=nFvBT3js+hZr83wagusc8nIpd8BNUK0vQOV9/eJ9HEWsomrVNHI720LwIHsAL38MzG
         091FhA/9iclxfjupccvpJsqFYynSJpPKtXnbSdJUMaXyp4ZA5Y8Ip8BoohzMafisDGJg
         uLL2+tDfR+2qRqo8wSmfJ6BsC7g5KgaR908pH4azPgzGLF6+fZALjp2j7dRwp5znKBty
         6aAQgHA6ZDZa9bwqz/jab3tLbb8PHJzdVBhkWJsZf2Zi8Q3SFMZlmrLVevGf47rDHbgf
         ukITsRLOFBOyeW2GXx5BM37AHxHX/8isShswxaeLJd8oMq0HLUcjW+qr2yHPTmb3kM9E
         +M+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zLrX8Nbz/ii0DbaDDTWzWJ9REoXF+EZTeLsLu8+k9QA=;
        b=NCygVXJbGk4p0omyo3JuPmmO3vq4gMCjckJfeZco9fAZb/LyQMwIOOE45ZKZYjobUx
         rMTEu3Fju2ealETZqnmYAY8ATzBiQw9jf4ab/Ozu34TfcW9gybMnIWZ/ERO+fIn7UdJ+
         xy+A7vYVjPzoqElNAVzOK6F9MgtaP5BkgcwTra346aC5/MpzAllzd5AForwrVZSCe2tg
         80MU55U9CLy1yjymv2iU63QSdtSuXyOpFQ4AA1YR1ey0rIFkrZoroII64/y+nUQ3Hamn
         SgCFzWF6LEDS/yyor7qlv2Wv80aOUu/4x8IF7FdlQY6rjTZYxGowjywDzfEBoKFEdmDn
         kADA==
X-Gm-Message-State: AJIora/D/yMNwSjR/+qRi+dp3jDe1sl+XDyiTa1d4TXq5qaYlG0RiBII
        xWVm6yW7inmRFKDCUPYRsfAAbu4YWwg=
X-Google-Smtp-Source: AGRyM1s5p3tbERT9a4wrIM15o3rTPzXiC7ROJSjzYCyhVxUKTU9NBbiDG+lR+uQmIGc4shm097ZU7w==
X-Received: by 2002:a63:5412:0:b0:408:84a9:9562 with SMTP id i18-20020a635412000000b0040884a99562mr26177237pgb.600.1655805445016;
        Tue, 21 Jun 2022 02:57:25 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-83.three.co.id. [180.214.232.83])
        by smtp.gmail.com with ESMTPSA id gf23-20020a17090ac7d700b001ec9f9fe028sm4221671pjb.46.2022.06.21.02.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:57:23 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id EE9B710383B; Tue, 21 Jun 2022 16:57:18 +0700 (WIB)
Date:   Tue, 21 Jun 2022 16:57:17 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
Message-ID: <YrGV/WnDqi1VaZsV@debian.me>
References: <20220620124729.509745706@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 02:48:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
armv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
