Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6789554B4D0
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 17:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiFNPgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 11:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356866AbiFNPgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 11:36:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9FA3FD99;
        Tue, 14 Jun 2022 08:36:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id bo5so8899549pfb.4;
        Tue, 14 Jun 2022 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4O00W84GsNOvIkGVcQE2YMku7qw/UGMrG1X5vdWTO7o=;
        b=kE+cdT81zLGZr4SYfcji8NDrCSqP/Zd/1rXb9EirZX4HdI50m1KgzuV88A8en1D4hr
         151mv4GyEb2Kxbsc+e/O3FNBuO0DiebCweodNWOtV0eCWHC309jQr6m0g1C075YLx6OX
         1oShJdGqx4NoWjKuWq+EdgulDarzKltGmLSfmkB8G82Qpi85dq5h5PXs+YrzushOJofK
         RpSgRioeahU3gb6JI0bE3wcdcFnpPeA0Utl609r9wGQRNng+AuGTk8HdY1qYaG4eEkpr
         0IuW6BLodDWLAquIrfU1Axhs3I70g96QIBqjuha+Cpml5tTB/wl2+StjiDX54Hauynnv
         I5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4O00W84GsNOvIkGVcQE2YMku7qw/UGMrG1X5vdWTO7o=;
        b=7sKugfzwjoKhUVCQnaxCTSs/qrGYUUHq3uufKTy1qlx9prUoYPHH35yzs5/aHiFaqU
         w9Aol3ZXcWYYpPrqrkA9N/tB/9fQ6v8keliwr3nDHLwDcD927wwUAApZtdJ49vs2JkFq
         /5Ba612FJflReiwdt6hWtBvUhdEaggvUL5dl7XP1pXM4riyLVrVMHc2ngIPa48zD4Vnq
         IA/3x2LNdcAi6bulYT9UJ+Y8v5vAwA0S8f9gUZA60C5cJsi4hYuzYsLYx0ktlXMvmgSO
         6XWPsuawk3wNzMwmJ3Bm1/35DUQMvmFM2xQbuew71TWywNq3jQloTI0RMNE/RFoKbPyp
         kEtQ==
X-Gm-Message-State: AOAM531D+7S2ddMPlLoN/f40YMWp2zMgMh9AL6Tnp/hE507X9/zdc/93
        Rq+dSGFfLiTRCLO3VT0hUG4=
X-Google-Smtp-Source: ABdhPJx5drNdXHGh7HZJ3g/3HUzhxch+Wo2YHITM6X8TEVG07A4NR1EmNO77JPmmt7zZnqRtFL9s5g==
X-Received: by 2002:a63:a50c:0:b0:3fe:3f58:93be with SMTP id n12-20020a63a50c000000b003fe3f5893bemr4949764pgf.265.1655220968853;
        Tue, 14 Jun 2022 08:36:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a9-20020a637049000000b003fba1a97c49sm8037729pgn.61.2022.06.14.08.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:36:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Jun 2022 08:36:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <20220614153607.GB3088490@roeck-us.net>
References: <20220613181847.216528857@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181847.216528857@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 08:19:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.47 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
