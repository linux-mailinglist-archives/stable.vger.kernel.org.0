Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15324B5EEA
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 01:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiBOAPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 19:15:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiBOAPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 19:15:11 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3738106CBE;
        Mon, 14 Feb 2022 16:15:02 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id f37so7475987lfv.8;
        Mon, 14 Feb 2022 16:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=H3kQop1x+B3mlVKVDTMEImkl0y1zDfGnntwEOsoqZlA=;
        b=Rw6IvHIpxdsyzZMq+qdiQyu9N3lB9zF8ukwsi7Sju5A7ovw350nTcbb+3nR2jXhUyi
         wr8Arn3bhoUBjXjXCx+InJzC3r0XmT1LK44mTbTJIeJeV3gmyYxSCIQUHNPr6RR5amvP
         65EMhmUVgAeX2PhzxzYfB/u8b9c3Mr2JvfRDKW4JiUntpbtMGwc0klSLuIxTeGoaDCrv
         JW7CEm/vsjkQQb6FRkgrhNFLeWCwVgVkk7+ULPzyP8hMbAe3rAWXGsbx+f85itQ7rLc6
         XpXfKZ7AuJl7nCY4LezF+dx2Wp7vxaiV+VtwnV5SHd22LozlxUu4tuF8F+DoF/p9aNyW
         JhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=H3kQop1x+B3mlVKVDTMEImkl0y1zDfGnntwEOsoqZlA=;
        b=yQA9OqON3fRteLQ61iYxZlsDwYTo6/4T7OdwjUIzmFq2ZjDkuQbev42Dc2MpK3NMKy
         DN4fnmcc7m91k+9cc24xQnpPmIkDQz583XRx9dsNPBItxECJ1QbgyG47KPjnD7Ox8Abo
         kFGJD5LhE4qyRnjDMRIUkZ52oGUPQvUA2J65unUoC/3BxiZr1wLRTqP4oh8DeuSZbFz+
         42bHRwQqCdt8zx4dynNUysTJSsswQO1EEFBBOeVmdcbmUfyDuhPrQnimPZIIdipmtF5L
         FxrIRWEcJzFJQ9NeuQx6EsmFAKsZZ+7maMp0Cypj4D8X2ot/6ahlUpksnegudzvG14Tn
         QC2g==
X-Gm-Message-State: AOAM532NTQ9NjbSt1EReglMp6uwd7E3RDziTBMlHEyQemIAwTeX2cwWg
        5LPV7s9vTIXQqAO+NSEaAsYeGvvlygKSGYgAOwF9UA==
X-Google-Smtp-Source: ABdhPJzceiQhtkP8c9tKqXEGJpwTUWHMniBgkPfP5a1sYqEM1AuZ3IxHcE18xCbsut2F//PXuliQ3Q==
X-Received: by 2002:a05:6512:2216:: with SMTP id h22mr1083623lfu.155.1644884100645;
        Mon, 14 Feb 2022 16:15:00 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id c4sm424773lfs.220.2022.02.14.16.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 16:15:00 -0800 (PST)
Message-ID: <620af084.1c69fb81.5b25e.1c14@mx.google.com>
Date:   Mon, 14 Feb 2022 16:15:00 -0800 (PST)
X-Google-Original-Date: Tue, 15 Feb 2022 00:14:55 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/172] 5.15.24-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 10:24:18 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.24-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

