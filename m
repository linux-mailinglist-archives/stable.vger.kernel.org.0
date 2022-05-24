Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6957D53321B
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241274AbiEXUCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241270AbiEXUCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:02:19 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF0E4D25F;
        Tue, 24 May 2022 13:02:18 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w130so22761334oig.0;
        Tue, 24 May 2022 13:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xvj+AOonWRi4E00mE1Oi4UbZWIEzZq2r1BXDxMY1foc=;
        b=N/lJDmx/CtlhhaF+8PEhrdY4B5ZQ8gKWJhtZc+8ZcJcTVOy7REYt22wMK3T12LiP71
         Xsitd6QybpUHy6QmILpYWX0eyIyCWrkAWeMbqIcvdLK758/mFM3fAYoflqXLQ47lF3a4
         i7VI/LLzIGm8ahHvlQ+pycxZThnd70h9euTWRYZjmJGBushVDFGchoAy+p/ViogQ8bjy
         IXViM7JHURyP269W20imjJc21wl3Sry03zTGFB3owT5ov0rGnmGD0SLjPQD7Vj6TaesV
         AE/zcWQMkeTBWpka7J0n4ZQMwAu3I6EovKSSMP4Opq5Z90Mlr7WdS1D61H0/eTLU0xzE
         gAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xvj+AOonWRi4E00mE1Oi4UbZWIEzZq2r1BXDxMY1foc=;
        b=yaiYcgCuREXiLwppdUm1eULO4pQJwzcpfAbgyCi/fLk2lXp4A68jreC/+rzaRMWr1l
         Ee+zNgMWMS4LyCZZ0GdqygQN/DMRUeuNO42QwTT1J7hzTKzYJAeQ+RXmGF4Ewix95TcA
         ToNRvAydQcLxqp6cfU3GYtGB2xPk/mrWnFozb7zRaA3pz1uX58Kun/LRGsoB+Z0peiwC
         AeUcJhklH793/+Nu/Cxc5UpfTja61hSs2Oei9b/kqnqqkPLaheMcYC2XC8lhMoBduw4X
         OroUMGAaxkVQVOBb/iGn4/vQkEA0TkQ9cnjWJO0XSlgSV4cth1BFIave0SWiCoNKm7xV
         /0zA==
X-Gm-Message-State: AOAM530ojIpx/bRHSrwqfP9ErC25F9aY/7FkofQSeWHdSB5FwzuZ3qK4
        5CT4Hy+mzR2KMwGaSOHGer8=
X-Google-Smtp-Source: ABdhPJxz+8NCB1WDYBeNgkkVsWtgL961w6wiUuoZDuGIBwcDxWcsMsIDDX90hQc59+2UkyeXxHeVMA==
X-Received: by 2002:a05:6808:eca:b0:2f9:c581:3f76 with SMTP id q10-20020a0568080eca00b002f9c5813f76mr3469488oiv.138.1653422536007;
        Tue, 24 May 2022 13:02:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l7-20020a4ab2c7000000b0035ef3da8387sm5761677ooo.4.2022.05.24.13.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:02:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 24 May 2022 13:02:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/44] 4.19.245-rc1 review
Message-ID: <20220524200214.GC3987156@roeck-us.net>
References: <20220523165752.797318097@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
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

On Mon, May 23, 2022 at 07:04:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.245 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
