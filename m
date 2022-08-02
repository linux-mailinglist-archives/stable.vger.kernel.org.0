Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1619A5876A9
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 07:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiHBF3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 01:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiHBF3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 01:29:54 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89193C8DF;
        Mon,  1 Aug 2022 22:29:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f11-20020a17090a4a8b00b001f2f7e32d03so879916pjh.0;
        Mon, 01 Aug 2022 22:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=xpZQqxov8E0HictKISxN7/gkFMetmyAoDMZt8klp/n4=;
        b=Wp0868rjJcoB/BpB2hBKdIuVMNdz7DmQljgleWzikvt54gcj79JfNv3Gh0jeEuNdnK
         iXtGdVDhBXUuMLTg+FLz93sXlcDw5oZ+Zx37Lgc8Abbjf4ZVEpJaLtYIMnbYyytEy+wm
         /6yxN+NaJ0gpW6jrl0NEYjRuHS9gPYzJrrOJgW6t9rh5SbkDv/ADra4db/OrG5BpVCth
         G0x0fPP0NfxJeo+VT30pbYU/aDwOKNMwbNNXaLH/bP4lTr5SY4zHOYHPMbHI60Yxe5Ec
         9tAD6qnm9l42vKEYtKJMls/U6aWEjlOhSY8n/SpNXuVwc+DGzLBaxM1tyY9c/dgL/UvD
         j/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=xpZQqxov8E0HictKISxN7/gkFMetmyAoDMZt8klp/n4=;
        b=SdPqO2okbqwJRDtS8wxsGo24ju4VhYUodiNrY9HxUJO6umbOAz+tNwyTCTA91oA2A2
         KCmkD53y2QYL1BJwScjqeqgNYSBx2JaUCEAj5AS6BJN1mN3P3RGGXO4VFiCtQeA1W5AI
         YnQl7Ke8NAVis4UbaRzJ8PPxbeJXc9yfN62ecquLK3m6Jk//1UsWaPv01Vs1U+ic36q5
         0uFHQjsR98B/MtktNBffRSRNr/4JbwKGEeODlNjbf8jNX5qGze/D2B4O9mSEi/p5cCTu
         AShvPGrt8xWeLs50ZpDBgQg4tx4JCPYX1+1Yj3BIWGuwgxrK29jfd2v3BIXlyg9y+w4R
         KdbQ==
X-Gm-Message-State: ACgBeo32Yh8X17j8jcMJwWr/F2cciHutazEyZDaAw66TOnNQ3hxpxIrc
        lNaapTc2CPFRlx2l5RsRMQo=
X-Google-Smtp-Source: AA6agR5Pv3x0ZE1nD2xlatuSRt84MTKRjE2YCn36lV0xYi7iCGsCDRN0327h1ZF/ZDdEOGUPaJtf6Q==
X-Received: by 2002:a17:90b:3881:b0:1f5:81e:8ceb with SMTP id mu1-20020a17090b388100b001f5081e8cebmr7135157pjb.207.1659418193369;
        Mon, 01 Aug 2022 22:29:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c16-20020a170902d49000b0016c0eb202a5sm10765242plg.225.2022.08.01.22.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 22:29:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Aug 2022 22:29:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/88] 5.18.16-rc1 review
Message-ID: <20220802052951.GD572977@roeck-us.net>
References: <20220801114138.041018499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 01:46:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.16 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
