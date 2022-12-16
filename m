Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23FE64F32B
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 22:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiLPVal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 16:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiLPVak (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 16:30:40 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F125EBF7;
        Fri, 16 Dec 2022 13:30:38 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id p24-20020a0568301d5800b0066e6dc09be5so2132789oth.8;
        Fri, 16 Dec 2022 13:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=faGp3q5VvI8mnMapKFqjzxGSUJuGRKvhZk/bzvMwrec=;
        b=EG9MMukXtUfOFru3q0tQ7i2lPRQQd8YlI51YZCpfBI7Kpn+m1vJoe7GwMvs/WLSvTn
         CxQVQAkd2w3j+2OkF5UEekmxAPGflMtuu3XPorCs9L0aPE6+tqoEesTFcAqtt4QHOGvT
         g8gS47X7tDnFmSO6LQ2DDrA8C3pGRCZRr1WiCFwMh/Pi2nsYRdgEBp2MT9ENc7ZFu4+q
         NT/MIoTNJOsL/DSugQXVj6w0+6huCzgDtjnHmM62Sr5U2IVlY6dcThGlJT4X5oel/gbW
         lIrd4QUGKxLNFzIPQ1fr9UTvTi0HWwSMlv39cnLTz2sxFJKEbPNRGi4A78S8xiNNEBG9
         oJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=faGp3q5VvI8mnMapKFqjzxGSUJuGRKvhZk/bzvMwrec=;
        b=ktowgT3iyGeuAlylZZ4Wu/XYHAvrGbMh8ehBP6iltse0XmbSaHzp4/bN0n2SNrH/cH
         bjGNur60+/Oz8/TKaO+Zub9bURuhXq7ZegDr18Np+Kj/riRoRWHKFh60BD0JEa2OCxf2
         CmKlhW6ux4CDMCIWYoeZ52SRpqHHGHpoEQsspcfabNfUQS2WYUULGyjA+zWrgHmkCKSd
         c5XXKE83BLC/4Ahxj9CXssbetpDotifeTq8dBvBN8xlUbs9VV1hOGknakgNCbf4lEjSM
         BfOje2kIbnUkismBd+O3F/G1K9uMMX/JQvFuGb8iOavECIPXCawNWHuH4Y2AjG7zNv7C
         IP7Q==
X-Gm-Message-State: ANoB5pk0rKm3KHgg93+vWQ/gmu99AwjbZmZlMBDjBHGBVj6D0PR4bgMj
        FO9Ytc/3z6HJJvK1CdrbUeM=
X-Google-Smtp-Source: AA0mqf5HX9yHM1K70mNKMezVLvpwm3DRYe7ckKN4YczJWg3BA3Sr+ZAPbep0hgWbB5oDc6XFP/H8GQ==
X-Received: by 2002:a05:6830:d05:b0:66d:da2c:c7bb with SMTP id bu5-20020a0568300d0500b0066dda2cc7bbmr19924588otb.18.1671226238099;
        Fri, 16 Dec 2022 13:30:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11-20020aca1c0b000000b00353fe4fb4casm1214406oic.48.2022.12.16.13.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 13:30:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Dec 2022 13:30:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
Message-ID: <20221216213036.GB4067594@roeck-us.net>
References: <20221215172906.638553794@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 07:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
