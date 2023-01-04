Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A094B65E007
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 23:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbjADWds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 17:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbjADWdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 17:33:47 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AE041D66;
        Wed,  4 Jan 2023 14:33:47 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id d127so29332117oif.12;
        Wed, 04 Jan 2023 14:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBk/GUOFJpV0frmR9hUeExB+NmtSOtdf9eRxJ5AOjIQ=;
        b=Mf84CwUoCPXs/lUsleHJP2QDFRgLTo3+Lt//Avckve7viIJJY/esQ98sEvFhnv1yw2
         mcMFffwSv3g7eI0K1CIyJgCrWSNaFFZXSDRBY+jdlxTuWjDoazyg8lrdA7sEWECJZ8wR
         iXT9cG2uvoUcs3mLLSOw57fa1/o/559A4wVOfzOXChWvr0p61TUO9d+Nh675YEBIFIHf
         SH/lopXtFauTWG+fRvFwbsg9LWaihflqnBqTkMIJF+mFi6wRnCocJFtQ2KgWanIbNTdi
         E0nzJTfkeOBHDOpQTbc/yCph9nN9SofGrgDEi456gZaaxSv6F4ZmLVECASbXT3WhxVgd
         VHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBk/GUOFJpV0frmR9hUeExB+NmtSOtdf9eRxJ5AOjIQ=;
        b=zDaeh9a4s0CryZnpF7ICDVRspQEYg1k8e1jSd+d+NLpO1fPtCUQEvaRlNiD3mJJKQM
         ExJ40L0oTbicXgfxhv46XLWKTl07d7JfVpV2vCBy66Hq6h0Ivy1B3PuaOfIXSgf63acE
         xUEHW2fKHS6e8QQId6+xlvt7DwwCsrkSjJ68PyoOFjS+JJqSTT4BmGQYI1eBEiHxNFKV
         nYdPJbsaD1pRF4OIf+K7v/ag+wNdHvtxtTTW7Vu3A5uyKyerPWfOz5IJaxh1pEV4Dhx7
         bwCuwVFuYsjIVVB7hOqeT3LK4nWYjUZnFbP5fCZKaV6FZjTStHAgV89rC8BrVI8lfUrX
         ywnQ==
X-Gm-Message-State: AFqh2kqkKSpIzi09HkkTxg/rGPkoSM/P5t5OF5wDmg/UXwXgfy/rmzZw
        kZCFXOhXxT7sYlmZK20VblU=
X-Google-Smtp-Source: AMrXdXsxFBFKu40SWVBDh7xLZrJOajopjl+QOpkoKTwFCGDmynRGRrgVRUGPRX8uBqQP0gScBg9Gbw==
X-Received: by 2002:a05:6808:1493:b0:35b:e443:e5d0 with SMTP id e19-20020a056808149300b0035be443e5d0mr28281025oiw.17.1672871626219;
        Wed, 04 Jan 2023 14:33:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cp26-20020a056830661a00b0066da36d2c45sm16753405otb.22.2023.01.04.14.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 14:33:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Jan 2023 14:33:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <20230104223343.GA2451464@roeck-us.net>
References: <20230104160507.635888536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
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

On Wed, Jan 04, 2023 at 05:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
