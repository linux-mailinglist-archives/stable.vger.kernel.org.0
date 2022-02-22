Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C26C4BF7C4
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiBVMFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiBVMFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:05:21 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBBD15D394;
        Tue, 22 Feb 2022 04:04:55 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id j17so6067727wrc.0;
        Tue, 22 Feb 2022 04:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NJos+zEViQMblxHjKBjy9ykego33RJXVaT8cb59knio=;
        b=i1cUTK3XerPPdYb6D1O63CRKrN5Qulg/qCDUP6fS5GqY6aSDbhIdtuDhHykAtHhYeq
         ineSV3Ejx/gwktRhpW7BvWg7qA5JL0mM8oiRMvYHsnd/JzKyZNp++I2cYeMw2N5Y9NiY
         nHNP/LnkL5zmkx8OgBmMH+C4Jyw1UmULDIG8jcSGq5BtYSE0FTWqsxztqLSPnHkETF63
         4DEm8vSJDt48sDrT+L8+Tj1jGSCLYpL+fxewblytJlDm+Ot4v0bdBP9l6sZkOSrOBN1e
         DoWr5hjIvtR4vs8q6lzsKNOLACzacNgHRISEU4w9zHCSdWktQHbGKJI6xCcjpkkanWrL
         E9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NJos+zEViQMblxHjKBjy9ykego33RJXVaT8cb59knio=;
        b=Lc7l1190nMW0+G3mPRFmorZpopMQxp+rbsXez4gFXgn4rqiCgoVeBU1r9Zl75HI3/m
         VqImu+HXETN8MxVtR8M5Gz9mhY6wPiSoGWbkoZOkedUhJsVYuHCNv58lG7ttt8bmwTvV
         y8Yxx5YtxSHWT7gbXyp5YJcIOn+RurobbLGKo1RAXRQjcwwJgvbpEEzO5QQ51lnlK+n3
         3vsZvTeA6bZ7aPiNk8BIpF5De1KIdnbFQqxl7aK0vizGfMV6wFXllFjiZ6A2Viu5blZR
         XjxU3E55KhxMH+kq1FLtUP5GUM0np4RjmqlNqQc5S7Z9jki9pzNe37wNYuHOB9eDqjzi
         jFyg==
X-Gm-Message-State: AOAM532YVUDaix55ELDpaPtDrt1tIJEiUWey03GvvfkjXM7kHrLHyXP8
        UATPeY9hGQJz7wGR8si4Edc=
X-Google-Smtp-Source: ABdhPJxr8kLjZ6BViDqLtShmBYQxL0l8nZ3cJL/AItKcsG6lPtlaHwuMyvJFlMVK5o4O6irp4CObXQ==
X-Received: by 2002:adf:ec51:0:b0:1e3:d68:6398 with SMTP id w17-20020adfec51000000b001e30d686398mr18946670wrn.203.1645531494400;
        Tue, 22 Feb 2022 04:04:54 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id u11sm55460114wrt.108.2022.02.22.04.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 04:04:53 -0800 (PST)
Date:   Tue, 22 Feb 2022 12:04:51 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/80] 5.4.181-rc1 review
Message-ID: <YhTRY/XuNaWUI6R3@debian>
References: <20220221084915.554151737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
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

On Mon, Feb 21, 2022 at 09:48:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.181 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 65 configs -> no new failure
arm (gcc version 11.2.1 20220213): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/792


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

