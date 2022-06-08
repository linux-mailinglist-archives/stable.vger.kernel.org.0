Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF54543EC0
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 23:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbiFHVlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 17:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiFHVlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 17:41:46 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9971A304B5D;
        Wed,  8 Jun 2022 14:41:45 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id p69so1545240iod.0;
        Wed, 08 Jun 2022 14:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=PPvP11Cj0zdHoWV2qQ+HvScAFVrTsMgfe9gV+ooY5M4=;
        b=i2bnwQFB5eig6XOz5EnvNiYMwAYljw51pZk5kVSoKnYV4i6tMsxpAcRlmuJbtCVBvO
         xRrp+0b0H/Ksz2DGXCMNP2zTvJ38SmuToAd41py0fVKso9hQoGyZyUVBvjq1vkJrFvEL
         bNIrVoB68lVl9Aj1ytVq7FQLjXPUV6uGC4DoBU0r8YIKteWvInKbGo3zindLhM6x/ZZ+
         whqnWbVawhFkD6mDHJ3MqHUUdsf+icqz74QoYoZV/htnARd4oGgZcFuUhJPUfisAB0We
         350ZZcsgAxkM+qTfH0Bd7W0fl1mxwtYdC1kdSJcTLKTKN78nQwq+rRaNmmnOu5OuK3l2
         +NBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=PPvP11Cj0zdHoWV2qQ+HvScAFVrTsMgfe9gV+ooY5M4=;
        b=PjpQDHPLAsx2DJR+lf0FrK5IRTpv61+KFrrhbMyzNJn9bpkmCQvBJsW9LBoO2IKjPA
         hiQNnNWJoVP+MqPFH8Hu8KURs++WPnMRL0JGZpZZOPgwTBDIkfywgBnZECCkKRt+0u/7
         I1PNZqh2Mw/TCut4cjxwsatPhigcJyPE2uI77ryRu3cuOB4gyKcKGGOQD+2teyxyxbv/
         c667mGVM+W0fucjRNGTJrB4h+C5De0FkGTPkKJSd0gM1z0LoWWg7sUKruGECpSMRxWaI
         oSTt5rg6fqj2LPin0MOBBLefpIaES8OoWDZIt7yy3w86vyFzwFPAvjVqHg2uZBZSe5bQ
         alWQ==
X-Gm-Message-State: AOAM532ICRfO4Trt6YT3BSVbqzri9Mnd/Il4x2WTGf4ZuQD/fB6d5IiA
        32ZI4i0FFGt9gWDkRhqgoWvJI9aU9+onsm3akdQ=
X-Google-Smtp-Source: ABdhPJyB2Gb2WrMUnrjlCDz5TE3VbhfLav9NdT/HPdU8oTuAFeMESaqOrQxSbojAsL0HukSXfc9Cxw==
X-Received: by 2002:a05:6638:488a:b0:331:4ea3:843e with SMTP id ct10-20020a056638488a00b003314ea3843emr19685956jab.91.1654724504650;
        Wed, 08 Jun 2022 14:41:44 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id r21-20020a02b115000000b0033197f42be0sm4966213jah.157.2022.06.08.14.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 14:41:44 -0700 (PDT)
Message-ID: <62a11798.1c69fb81.d3857.9521@mx.google.com>
Date:   Wed, 08 Jun 2022 14:41:44 -0700 (PDT)
X-Google-Original-Date: Wed, 08 Jun 2022 21:41:42 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
Subject: RE: [PATCH 5.17 000/772] 5.17.14-rc1 review
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

On Tue,  7 Jun 2022 18:53:12 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.14 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.14-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

