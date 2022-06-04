Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A042A53D6B8
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 14:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiFDMUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 08:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiFDMUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 08:20:31 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A722529A;
        Sat,  4 Jun 2022 05:20:30 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id m20so20534751ejj.10;
        Sat, 04 Jun 2022 05:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=31qdPROrxq/TP50e2ZYzae61KIq6K75h/y1mHZtdXh8=;
        b=pc6IxByXcUdGgyfvPeUTI5zT7kOKiC+cHG0TpzjwVEzny5AcLFiGMZJh7F0XGhPZRQ
         akSvyYIaI7P0zo8k74iMkzr+qe5NT8j45mb3gxkQxKzSR/3Y5fhcETs+CINTxxSLvumI
         Skm0z99bnhO2N9yRRgbhe/hMiv/rs5TGmDZt63WQeln77K4L7m+ZteNERuY3gSfdhpnc
         mLqdDHP07SfYLbsxUPT8GaOIG2EMKTbUoT0r2e+nZpz2zfJ6pP9c/3iMUKDqtPcAWZbM
         iKZtGOCIz0zSTsOrzS1bZLN6snxynlAMJaAQx28UMiUfxgyZmqZYkcMZYdeIWT1AZEEB
         IH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=31qdPROrxq/TP50e2ZYzae61KIq6K75h/y1mHZtdXh8=;
        b=3vqg+69KufSwHKZS8f/GPGkzM6Rh2JJKgsEIbDf6ZXZlsIa0PljV9/gcYre57rbs7A
         bkQk9q/P04JDX5l5GkTgNdf4Jz4z0aXjrWGIyF1HwvZknOcZMoZaF6fUNNUPZlPzZDpR
         7Nl0C1odV73JjaEhi0hMRXbwMIOq4KNVpne58S152Eo8EXqt+rt62PoDJPF+GQF/px9k
         EA6axKTX11mlyJviJBnkEkaZ0/0OEEhguTLJAiaSVz5WrG30TRUhZbUp68AGFYU1cQor
         LIKndaQhwPd46JqI3qdN86080KO6wSqH2qnbpXcTxtrmOcFEu11rXrcmU0Jmf0WC9nel
         0g1w==
X-Gm-Message-State: AOAM531X9Cak8kqOyxb9I3FTaef3PqS+JKbtgeMybfj/bTi83q1YYliq
        +w+QlU5z30bh+SQOBvyPyVU=
X-Google-Smtp-Source: ABdhPJzsg1Y+ywZTbEJVBuY5dMSrPgoxdFwjoz7QYa1eETisQ2z8UvjQzY2naeXRkOZHxvTvTUsXVQ==
X-Received: by 2002:a17:906:58c8:b0:6fe:91d5:18d2 with SMTP id e8-20020a17090658c800b006fe91d518d2mr12542015ejs.190.1654345228594;
        Sat, 04 Jun 2022 05:20:28 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id g8-20020a1709064e4800b0070f8590ee8fsm1372865ejw.159.2022.06.04.05.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 05:20:28 -0700 (PDT)
Date:   Sat, 4 Jun 2022 13:20:25 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/30] 4.19.246-rc1 review
Message-ID: <YptOCU/vk7TWotcS@debian>
References: <20220603173815.088143764@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173815.088143764@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:39:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.246 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 12.1.0): 63 configs -> no  failure
arm (gcc version 12.1.0): 115 configs -> no failure
arm64 (gcc version 12.1.0): 2 configs -> no failure
x86_64 (gcc version 12.1.0): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1266


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

