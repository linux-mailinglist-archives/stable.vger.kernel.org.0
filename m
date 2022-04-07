Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DFC4F6F32
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 02:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiDGAaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 20:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiDGAaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 20:30:18 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B854EDFC;
        Wed,  6 Apr 2022 17:28:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n8so3464211plh.1;
        Wed, 06 Apr 2022 17:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=2V6mXdnYE9lX/aHxpMJNO/c/FemqRn9e/z+6mFFwjF8=;
        b=gs3lbfWnhcH99JQ/b/9qhTMh8wuxhto0QJLjEMJhiLW/hlEKlM5VfRrYWC+yfgRnV1
         o7zxOyxA0waxpWOLSA72SJsCf1NKin/dtCuN0634wkv0eLTPRIvS2IsKwK6KalXyh1Le
         AB+jcQYPl9EoPSJhbYNKDCIwCg4A5vP7/Pf7RY7Yi2J5gT3oywE86mHAeprkG6tvL06S
         XTQ3Ya+cGWaTEAhBnuSMFxVh3kvEsfGxyQh3fN1G6oIOH6prtq/CrYYNQos1EvLd5xPj
         +h/pVsY4s57/yA4hCOaGYpFLlvaWmi7D3n9l6YFuiJCfDVUoPsiKyBKjkWnTkHTfZ5Ve
         0DYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=2V6mXdnYE9lX/aHxpMJNO/c/FemqRn9e/z+6mFFwjF8=;
        b=JAxpzIBwY5FFGsj4O6gTyCuwkpK9EbS1/kkRsXQ0WdMP12LKfcB+YF+/p976eXkbzS
         YJQH80y+RpthAk3mrr7+WUmHbilYe1m9JCyPCWvZmtTbPMxan8c4NVIC7qmdRSgAI/h7
         UhEBOtV5n/ZA3NFs/4jjtH+fHaxp1a4pH/fTc5gw/+zQ0AmajwzmvAjqYV0HiQDDyZgf
         5HBQufk6g1uqB4EdTs95Ztk6HLzSL3+ODZ0r87Fnt3GSA6AiWdy7h/ej3t0NIi+L6o17
         OIXVPnHMRDDiaNthJ7gTf1hC6tvxKN8k1xe3/Q40wbnab/DtMvup8goAwtjR7V3lyGdv
         cL/w==
X-Gm-Message-State: AOAM530IkIoboussL3ULMowRDWO5T5TGXcfqEMWWnd6n+AGhZT2WJO2I
        I3oiSlCdK5iUmzOs3JY9b+PNdFwTscARLQg2rP8=
X-Google-Smtp-Source: ABdhPJzhpyVyKOoISHKGDfPGYEFuOsjGjw9HWoMRk97F9wHZYWPk0CNpR9cajWQyP13CyUgtAPsaEA==
X-Received: by 2002:a17:902:ab01:b0:156:f1cc:6d2d with SMTP id ik1-20020a170902ab0100b00156f1cc6d2dmr3937096plb.127.1649291298257;
        Wed, 06 Apr 2022 17:28:18 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00180500b004faac109225sm21885786pfa.179.2022.04.06.17.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:28:17 -0700 (PDT)
Message-ID: <624e3021.1c69fb81.79ff9.9d48@mx.google.com>
Date:   Wed, 06 Apr 2022 17:28:17 -0700 (PDT)
X-Google-Original-Date: Thu, 07 Apr 2022 00:28:11 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220406133109.570377390@linuxfoundation.org>
Subject: RE: [PATCH 5.16 0000/1014] 5.16.19-rc2 review
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

On Wed,  6 Apr 2022 15:44:28 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1014 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.19-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

