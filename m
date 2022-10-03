Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E889B5F34E4
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 19:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJCRxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 13:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiJCRxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 13:53:41 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B9D37181;
        Mon,  3 Oct 2022 10:53:40 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f21so2504326plb.13;
        Mon, 03 Oct 2022 10:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=seOItXcDPiIqj/YOv/PlOMnnzpNAvMgsP2pm+dBW/xA=;
        b=HT07GxACKlpZk1Tp7WV82yjz2DIg5f0vS2DnC48M1+vEdFTe5r2VKnR6vUcxZMTFy/
         UaDD0jRZ48Hx8Ko2iRk/LVjwmVcaA0A7FXf49adfNSzxYc78sJu7iZ6laVoOIoOqTe7s
         dvFnnrkW+HH8SUHNCQLSMnQMXxWDz2Kxx/todfwFEid23d2PR1zjkRVvh2C6N0o/XJe3
         V21vOOzKzKyZ6N9WTgHVbmCw6Piwiwf830UgPmv0mX9i658IuWJmYsHU+vWWgs9FHPgq
         5W/JflGy6mTRY5/CdAphoMNQw5yw62qSfrvD+MyTNr0+I5C0f+CQ+5ls2vPmP/EJadD8
         rGUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=seOItXcDPiIqj/YOv/PlOMnnzpNAvMgsP2pm+dBW/xA=;
        b=Vt/5sV1meiV0pRPCZcpdWT4fY+Jc8y/q7ZcVWcgCezgjmvOn5PGF9vyS49PWUSksYQ
         +QH0X4HWbE3IuewCSCnBA6WTijloj9jjgMXLDzCVcpPUa6+V4wIVektOHDB0fY5ix60Q
         WkCw54bAG4Pv+vD96JW7Hi1BCqDiPsbg5bjqexvYylhh+XFTIkjw+xIkyokHTTtQ0HCH
         q0TiSEp5/bsUhgCbzX2EuKc+zCr+mMTBokzVcm1N5G0Kqx8ufXIgGMb1haeEhCDAFvY3
         4FzaHLcYouiD5DGpZNoZdMtGFJaWm/mQqBLXp8Ly0ZEPy82vFV0P6q4TCl34wN1KnoEt
         O0Tw==
X-Gm-Message-State: ACrzQf3EJduIGSqWsj4aW5hbWn6XNBd5M3y0/gY5y4odE37RF455DjYf
        6IPQ3nl3E24WTSdA2eQybYE=
X-Google-Smtp-Source: AMsMyM44bxtqGkDvW/9ZPXgSJ5p0O9IuVD8MdREUzo6qzCT2DcjamxC6sisF2+mrspxEz8Qe6wpxLA==
X-Received: by 2002:a17:903:2606:b0:17f:4a42:26 with SMTP id jd6-20020a170903260600b0017f4a420026mr7278469plb.106.1664819620001;
        Mon, 03 Oct 2022 10:53:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o11-20020a62f90b000000b0053b850b17c8sm7690708pfh.152.2022.10.03.10.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:53:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Oct 2022 10:53:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/25] 4.19.261-rc1 review
Message-ID: <20221003175338.GD1022449@roeck-us.net>
References: <20221003070715.406550966@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
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

On Mon, Oct 03, 2022 at 09:12:03AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.261 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
