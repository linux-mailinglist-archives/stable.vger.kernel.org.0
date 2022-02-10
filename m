Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A3C4B1242
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbiBJQCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:02:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiBJQCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:02:36 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71FAE5D;
        Thu, 10 Feb 2022 08:02:36 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v12so10477670wrv.2;
        Thu, 10 Feb 2022 08:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7PANtWWD2Kt+GHWBLiAh9yfO08n/yT3I6/7j/Llw5GY=;
        b=Sgv0zC2zExaw9LYXehvrYYdC/OOpMR5IrFatO33Oasgf1h5l58VJ3uOMAJfOY1Nv5Q
         z+28+gAXeP/TlTW6jiepnXBJF5Cg4M35/34HKFymhthSXR2PLB7/BM6C95xpfVmEaJ4U
         KRz7+PDBxl8dDNl/qz3n7cg6TZ7qL0iAbbe7rJo1Vip7aLy9pQDFLxulaMRlwSXY15us
         41yC6LBJlH26b+roAzbg4sw9eWhSCSJ64LqhoV402SWMJLokFrkvlhdwipcK4Ij945/H
         Nhq2RF1P4RumSGwnkAZ+5Xsq6FwSUga4fcqT9fNmatTIvW/U/sO5pM3Mj8Jh40vtRyO5
         5rOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7PANtWWD2Kt+GHWBLiAh9yfO08n/yT3I6/7j/Llw5GY=;
        b=UYkp9nl9dQCpBVFfN4Ynhw3ckyhAgPrKkONsE3Wl2OBh3GTBCWlIjpvKED3qbyg9Yg
         qLmaMBkpP7dTz/MMlKk0/kAX5aJcPkmh/cbzE8Webb9+vLE8ApCJzzZS+ZPM2gwTJGWJ
         KhKCJY253RK+d9dKlneYLpJLMy5nxeqV2AVIGu7brO91WgNcF5p1rreTLYgROvPnKF0Q
         1xMlBXCPYt0UDphQP+4ZtxWW7FcKY59EoN3EcXXTOtNUTET3eC6VqB07+PktBQLP6K9a
         NwmIWFasGX1UlBhfl27k/BknofI+YYdihgIrzOWh1gUd3Zzm8K+CMKJK2eZdiJRTcZuQ
         3afQ==
X-Gm-Message-State: AOAM531tbIfjk+lrSzW8J+7O30zw8+pW49J3OwtOjQ4G0VL5mr7YKqJV
        MjAoeqHP+DGBEdWDjJUpIdw=
X-Google-Smtp-Source: ABdhPJwf67uwAasYWAYx5+iqoyLyRlZqlOiOqrCNtgT6F7SiBcNbSXGcixBRB5ZGLLerGBstYrsBOg==
X-Received: by 2002:a5d:4448:: with SMTP id x8mr6850908wrr.529.1644508955188;
        Thu, 10 Feb 2022 08:02:35 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id v9sm7818807wrw.84.2022.02.10.08.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:02:34 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:02:32 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 0/3] 5.10.100-rc1 review
Message-ID: <YgU3GBD+FoVrk9Im@debian>
References: <20220209191248.892853405@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191248.892853405@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:14:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.100 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no new failure
arm (gcc version 11.2.1 20220121): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/734
[2]. https://openqa.qa.codethink.co.uk/tests/738


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

