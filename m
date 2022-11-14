Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1F0628B64
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 22:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbiKNVgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 16:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiKNVga (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 16:36:30 -0500
X-Greylist: delayed 1803 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 13:36:29 PST
Received: from outbound-ip19b.ess.barracuda.com (outbound-ip19b.ess.barracuda.com [209.222.82.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F47765B0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:36:28 -0800 (PST)
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198]) by mx-outbound42-203.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 14 Nov 2022 21:36:27 +0000
Received: by mail-vk1-f198.google.com with SMTP id r23-20020a1f2b17000000b003b89463c349so2629911vkr.0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sHhq7GAcH+SGAD2OAT/4GIJITY8Agpvr4ItX6H4dnTw=;
        b=RkaNIlr9V5SN6THND5V/unQ4uGo4Ewoz2wIKKh+ktKuyCJdNnVVPtPduHX2TXf/r3W
         OxV+lLwPYO0X+XWeGLEZ6I3mH7aPIjXo9AyxulJrwHbamWpmay+eU+B7rLJIkFYiYEve
         ZSWF624bLS8OJ48owc55yns0psiZ8lOP/YruCDfdNvvg3D8QY6oVkL1IExlvhbOlkznZ
         70h0LGGBw0M6fJwlBKvJBOWnCQ96ztSV3OtQ8cAlSDsTG8P61hJ3Vb9xDWv1jOHzZ2UN
         JGIYpXsf69ITyp1HII4ksPVOAJVtMCt1wwGkjVTLta2BW12VcOuX5HHW4NiFp/Q7g3/W
         fcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHhq7GAcH+SGAD2OAT/4GIJITY8Agpvr4ItX6H4dnTw=;
        b=MBbEXM79WtooxVgnJLWBqZqLCu+NlyZP1L8EGwrPh3pzjVEhOfmTH59r2NBIqZLLlu
         gwNeLXPcHDdsUPYumAtx4g5i8QjnbXZE+xGTSjIe36wjjAjqb3OCs1wQDp+WYs0ZtJBs
         ooTXver4n0//yKmY65OQEoQSQQwU+JbqJB9Z7SZEsojxR7GqSlxhIl/vnD7nm/HEWW1/
         Zgy8pzxwK2M+1Xeuv5iijj9YhYYfnr3vxS00IYJ7Y+esBt+rbWKYa5egIpNogbMuAzBP
         iTVRptYZAYz7h0JOxSB9zP2/dutkZlTgN1KFsgMBDC5IT9FxpjxcUtdv3noK2pOajnME
         eOHg==
X-Gm-Message-State: ANoB5pknHWbZqruzY3Nhgu21feK0iMJSLez5LLzg5FUeTYaSM0EzuHnt
        JavNtTgQt2pkCCasb9CsZY2HRnMfmoySOb9h0UCAVczLvrV97PQU6XVhCyGEu8Gmj28WwvzfLaB
        s9Bo/4sLS7YQnStmTJjHDdyHbPwWpb0GZ5grrWuvRnGL4WRAfW1Ky8+iDYLUK+yz3
X-Received: by 2002:a17:902:b18e:b0:187:2790:9bc2 with SMTP id s14-20020a170902b18e00b0018727909bc2mr1045587plr.61.1668460006278;
        Mon, 14 Nov 2022 13:06:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5hR1jUSh6vO+NzVXJRDYcadYdn4lJl0ydhNhJqjQVtk/DjBGaS18IFlwxJN0Asr3csyDUI7pdHlDadYCNkliw=
X-Received: by 2002:a17:902:b18e:b0:187:2790:9bc2 with SMTP id
 s14-20020a170902b18e00b0018727909bc2mr1045562plr.61.1668460006054; Mon, 14
 Nov 2022 13:06:46 -0800 (PST)
MIME-Version: 1.0
References: <20221114124442.530286937@linuxfoundation.org>
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Mon, 14 Nov 2022 16:06:34 -0500
Message-ID: <CA+pv=HMHfNO-v2jRMrzHKx7VWzg9khjPxp6pNh0DPDsnF_O55w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-SWM-External: yes
X-SWM-IntToExt-Scanning: swmout (swm-pri11-itoemail0-scan.leviathan.sladewatkins.net)
X-SWM-Sent-by: swmPRISMgateway (swm-prismgateway-pri02-mail8-scan.leviathan.sladewatkins.net)
X-SWM-Antivirus-Version: 1.1.0
X-SWM-ite-Primary-Server: swm-pri12-item.leviathan.sladewatkins.net
X-BESS-ID: 1668461787-110955-5610-7348-1
X-BESS-VER: 2019.1_20221114.2026
X-BESS-Apparent-Source-IP: 209.85.221.198
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.244150 [from 
        cloudscan15-185.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS162129 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status: 1
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 7:47 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.


5.10.155-rc1 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
-srw
