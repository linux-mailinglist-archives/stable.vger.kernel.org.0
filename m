Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6825C5B1321
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 06:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiIHEE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 00:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiIHEEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 00:04:55 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2C86566C
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 21:04:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y127so16664397pfy.5
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 21:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=nY+Znyng41bnPyZXUkBANMf4fhVi6WarlKK2by8W9mo=;
        b=KVQhlJ8fTjPd6rgo2edKBdGvHdrPWvesGjwz9IF+dqXQ7X4kWVBS2A31SSl+OZfPDE
         8iOmdDbWG42uBB1mEkYi6t/7VOPIjc0DmBmWh6eLIjZGfGGXEjLMjFG3lHzm3t6lAXxF
         2Ayi0+YCv5yesMr5ZcCvx61lboE2LR6gOdymE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nY+Znyng41bnPyZXUkBANMf4fhVi6WarlKK2by8W9mo=;
        b=1vEqtbOZ21dClWpgpWJTr40RfPK2A3h3zLaw+Gy2s3wwzfATukriJyV3icFVkC6r7U
         R9tsttmL/7i1+ejCv9dd4/Si4p08+PP8PcaEttTmIdYJnb3+b9oiSzJd44Kjdx1Fc9bm
         meoTtFM/hdqGU1BnS8KuUk6AJCAtLzFHcl2suNhs56o/V40AOXz8KE3ZLb+uRrfOzOPG
         lg2yPQFlyaKCRrvaqExCTHee6Yw7VIjvVBp9xYhURYgrxB4OEDHKGOXU/4667J+302Pu
         rxp/F6o744Ihq+mCPSypN+WJpm1js7q5iL9yRc5VN3ODa43gsgwI3QcrwEFTr04Pnqpa
         ol0w==
X-Gm-Message-State: ACgBeo0K2d70pvbkiPPZ5awxO7zxlJYYpzdEOIafoUgTJO9tgJ1NItBL
        vBKXg8d49SYuzFs6LnEJGmsDkg==
X-Google-Smtp-Source: AA6agR5S/YjfiXbj3fgVVLbAfSxVlk/CmtsUrEw4Rse3hWtApQgVYXUzB1Tv1N0vKPTRPrvuvwxdbg==
X-Received: by 2002:a63:2355:0:b0:434:3049:12ed with SMTP id u21-20020a632355000000b00434304912edmr6375058pgm.537.1662609890845;
        Wed, 07 Sep 2022 21:04:50 -0700 (PDT)
Received: from 9c4a42ebaaae ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id z11-20020aa79e4b000000b00537f30237e9sm13498499pfq.157.2022.09.07.21.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 21:04:50 -0700 (PDT)
Date:   Thu, 8 Sep 2022 04:04:42 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/80] 5.10.142-rc1 review
Message-ID: <20220908040442.GA8@9c4a42ebaaae>
References: <20220906132816.936069583@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 03:29:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.142 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.142-rc1 tested.

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
