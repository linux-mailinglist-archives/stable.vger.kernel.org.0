Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B6D4F6137
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 16:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiDFOMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 10:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbiDFOMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 10:12:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428CD12F6C2;
        Wed,  6 Apr 2022 03:06:36 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p189so1117736wmp.3;
        Wed, 06 Apr 2022 03:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=47pi7dvQzwfLX3ainw4cotVpAlhqEnPPur28m2DBYnI=;
        b=oyRzTjU9Y5vVWWhJlEXWBmqOttlu6Wt5erI3pvi3Fx5Be/D9iwtxpOKRdMqP8MSnvV
         JBJGNCltub8U7JXIZ9M5AUptIBltfbxi4nu/ZZCi8tXkbjKvPp+Epc3VQSPe52ylIXpy
         ubB2jEtugsabOsmsf+PzZzpWaaV/LpZUIhPFv72C1ChcXPk/o3VCBcXs7tjofJaVJpqA
         yC3Gaaecl3i9SCS0y10GBJEn1wndI7ziUMRs9XbXmODOmMaV4YAdNfaPbtVNPnY7mDVq
         xpvGUcS/BLncMrjceqSCIxgkHqp31zclZ1gtlHQTFDVsVq+1Lql1hC9hId/rA59BKViW
         fJuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=47pi7dvQzwfLX3ainw4cotVpAlhqEnPPur28m2DBYnI=;
        b=li/3TbjpWZHsrO+pbFpJmtXrij9rHnpV7KRyXW2Lz7jkUCar7FcAjsIc6tceNQsPN5
         7TweOfbz2md+g3nTgA2JCOApSHNWfCYhQjcpw7h3/WG+/dFM8wCqBq1j0/Bfcf65mUx7
         ssqDT066TvXeTQbgs7946m2i4ZTPiv9RFCamQn+TT8v17B5SHgeQ5MDwNy9QN4PkDyhK
         EBV56EDNXSFbfHAwdgDJDcr51Of2fpycaevFq1CwNxQG3nZZlt+q6ps8zkocuT1ENZQ3
         GvH7VbkgbbzdXk34swUil93BLj52npvhWg1HnINcoGFN7p+h0SxWssS/Aa8WbdB+C3Lm
         ZsOA==
X-Gm-Message-State: AOAM5327sjlCJ7E4ykCI0sLo8UfCfU7Hz54jC2GxxmXWSPiEhO/NEJRx
        i2za2kx6msNbxP4PxR9Z3Dc=
X-Google-Smtp-Source: ABdhPJwjEWxUDNSk8rXkcq9W0u0al0JkpQ7wIp2FGwbqxDUXcBGMVgOqvVjB2N3EDRLNfNHBWOY8ag==
X-Received: by 2002:a05:600c:4f10:b0:38c:ae36:d305 with SMTP id l16-20020a05600c4f1000b0038cae36d305mr6818888wmq.34.1649239589575;
        Wed, 06 Apr 2022 03:06:29 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id l2-20020a5d5602000000b00206120e0b0fsm10793032wrv.18.2022.04.06.03.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 03:06:29 -0700 (PDT)
Date:   Wed, 6 Apr 2022 11:06:27 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <Yk1mIxYRSDSsIOyq@debian>
References: <20220405070258.802373272@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
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

On Tue, Apr 05, 2022 at 09:24:54AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no failure
arm (gcc version 11.2.1 20220314): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: fails to boot on my test laptop. Detailed report at: https://lore.kernel.org/stable/Yky7RmYZnPp9HgzT@debian/
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/978
[2]. https://openqa.qa.codethink.co.uk/tests/981


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

