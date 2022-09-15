Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505445B9569
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 09:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiIOH3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 03:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiIOH3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 03:29:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA7797ECB
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 00:28:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q62-20020a17090a17c400b00202a3497516so14372610pja.1
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 00:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Fhw29JEHtb6qb4ud3dpLERCou+hLp4czclTyz4sM8OU=;
        b=dRm6uJHzU2fwPNwmRJ2PajFLvwjehyezpOi9tI43hUOSUPv+eu9oXhLENNm2JOCDt2
         HiutLSG3dz3RRM24ckioC1CRQCjr6VrXod9pzusziOsw/7Nmzez68rLVpeT1oPrzwNOh
         rVaTasAhVFtF19pSiF624lqNgR9zi3+RCRnNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Fhw29JEHtb6qb4ud3dpLERCou+hLp4czclTyz4sM8OU=;
        b=yEpn9kBJIp8TYERgR1Ik3Qr3DQXHr68yjUMAPOmTSIYYCIJ6qZq0Ava2/8YDOrnKR0
         YwxCmVH4JEgwKv63rqDzpGhhRrvElIPbyU8lQ1nzqulcT6pa2cWq0J/oQqDbQigDbDI2
         iVOgl0erR2MNFcWkpDwVcqEwU+TCDvwOkRZAVWvoe0NV+yuC/SE6SghrJHpMbHg8JJQl
         cNOlkMJF8mgJqGRd0ArZUMUsZsacp9tWiwpRgr7TB0yjd935l+ScXrR4Is5kT5BGvLkO
         vYRIv+jO+J0J0hi3hVd0u5JrOR+Ftlqfu2of/L/m/U378jemcnXyhvg9nE/5DyZDjAs6
         R7EA==
X-Gm-Message-State: ACrzQf1/+8WKR18kjTuj3VZ24PVu5joMRkKLTaQ2QBYEzuPTc5Mm91BU
        +rY3tAawmak9UtWTiLF1M6vH8w==
X-Google-Smtp-Source: AMsMyM5gHlD7VMLtWRKGOjIcYY9J/4wc4PJMOFlnEsHi7y4nMt8wxhrPtCIr8VPoGzOGZGZ1PsmRww==
X-Received: by 2002:a17:902:da88:b0:178:143a:7267 with SMTP id j8-20020a170902da8800b00178143a7267mr2992839plx.164.1663226906824;
        Thu, 15 Sep 2022 00:28:26 -0700 (PDT)
Received: from 179a892027e7 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903120700b0017312bfca95sm12279095plh.253.2022.09.15.00.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 00:28:26 -0700 (PDT)
Date:   Thu, 15 Sep 2022 07:28:18 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/79] 5.10.143-rc1 review
Message-ID: <20220915072818.GA1084726@179a892027e7>
References: <20220913140350.291927556@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 04:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.143 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.143-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
