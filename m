Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2824AD370
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349386AbiBHIbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349576AbiBHIbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:31:18 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BC0C03FEC0;
        Tue,  8 Feb 2022 00:31:17 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso1534294pjg.0;
        Tue, 08 Feb 2022 00:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=U3FG54nVvypW1jKAOoyuKDAV+WQrGg96u+NDo77pums=;
        b=e+nvh7iQY+Az0wofQKQlWVNCaAJ924mYAdBblWZpVpF8LKmq5EgNDp8doQvfgS59xC
         qe58UlrNQtvOVsZgtHqiHqSHwbDCvd7kWLZ3nVE5PXz8gJHE300aRwKQyX4GsGRgH7wx
         ezQnD6Y+hwV5QX1/E0cotXVll3lFo+AgLDPj6YRWQ02/FRXdvP88IJH/HrTaZBUXAAvW
         XuiSWc5MsEMOfEkFodUGqATHbV9RHD67HmZx0MnJ9DEFF/TF6oer/SRJUXEig75jvR+8
         +K03oVikAHQc3bRdr54scif+n4ICbv9rNFQDsUNzcU5tFh3nVmB4aBn7rwh9KnRxsUbT
         HQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=U3FG54nVvypW1jKAOoyuKDAV+WQrGg96u+NDo77pums=;
        b=pvhwo898pKsCAZP5Z5uAtwczMlbI5O80hVIESSZCnsPsmYq6SFMsqsW6i2lW05vE6J
         jF/3CPmdClVO05BmOjQgi+tUdLgw3UbEJoa5B39CbYaEGVOXl7Ei//hPzA2z4aNWSrY6
         4YtZABcFNH3TB1oR6c1xEPs3EM8tUAHEH7dn7JC9y6vEkNFKuTUCAVQYlrWdZ+KsY/88
         g2mm0S4gBQaTwwrTLTKM0RVF8hDcQj/petfq5eP5PhKvvgS5DJ8qGP/j9ccY7wFrLYRj
         DD4u+yFqi5Gdt92laE6vyrE2h7Di/3x/4SkPzojNT+ClS783d3DecRjqTx4+OAOCm1SP
         fNPA==
X-Gm-Message-State: AOAM5315iG02nbjRXJqmKQNt543dc314PYnFes2hCpnUwBMoEXChQ8VL
        iBO6k61WsckekHfYy7Xq5XE=
X-Google-Smtp-Source: ABdhPJxBohix/pgoDrNHcSxsVCDJ2ZoratCoe3TqiSN7uVuXzynqLGMF8vpn0ekDGp5X6l9R+DLedw==
X-Received: by 2002:a17:903:230f:: with SMTP id d15mr3698073plh.8.1644309077146;
        Tue, 08 Feb 2022 00:31:17 -0800 (PST)
Received: from [192.168.43.80] (subs32-116-206-28-37.three.co.id. [116.206.28.37])
        by smtp.gmail.com with ESMTPSA id p6sm1900714pfo.73.2022.02.08.00.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 00:31:16 -0800 (PST)
Message-ID: <eecb2e67-92c9-f39f-c10e-89d33ba48cb3@gmail.com>
Date:   Tue, 8 Feb 2022 15:31:12 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220207133856.644483064@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/02/22 21.04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
