Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2B94D0CB9
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 01:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiCHA0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 19:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiCHA0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 19:26:19 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E19AE52;
        Mon,  7 Mar 2022 16:25:24 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id d62so19067655iog.13;
        Mon, 07 Mar 2022 16:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9HMETxfeX0Scdp2ikPPQ4MgFk8yPoMEChL3dROnLEnk=;
        b=OrUb0a1+YpDe9cfuI2P3oadHAb9yIGF88yboVHiZsbHEyI//PPttYYr4BQEwcBZdAZ
         viicHiHqtVS+nFwODoWdjFKmPezYjBuFtegFRZbqPQr6PeXDSB5Kq/A/Mvm9t7WTQcbC
         il1dmINYStxmeDndvOgVZnF8fUBhogtqWeoXDhi572owL+0HNR3Kb/KchmymzMJoo1Mj
         NEDaMLYjtEwMCNbNNadObiNGdnfhI79TogPTUaFwmdUpCPtjdq1FimLYuU6EilHcxfci
         0OqKwm62MdK2fLBpmWeGGv7w/QNLAu3n3fZSXJjhj2DpFbOh67G/h1GVoi2+i4yVM+PL
         TPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9HMETxfeX0Scdp2ikPPQ4MgFk8yPoMEChL3dROnLEnk=;
        b=7tVdGxmK860DkVJNZhNZsobYi8TcsgqfuA5qORdWi6shpAn8Ej0Gl6e8XsECadv4wE
         rbIwdxm9cjLevABoBuZU8JWwVoau2MuuITqbAVm4WcB4+lvmxbozFOj/iGsNg2CqyVWZ
         6eTPId3hj7naFKHhjH5pbBFYA+fV3YeAiypln7qeQlr7hx/XlwqkzEbSnB9pkx/6gYG+
         v1KKtRkcBixlLnGQzcUkmc4HJzzFpFLD26E9ATwIOXVl7PrQ2kQjKhsTBMWpcOPdGr/0
         JyUmzLy78T8vPSPwu9JsnwIFOPkohaKtt5VTlreMMvXGhQFQGsFMnEoQ4lbVqxyXmuLr
         q2IA==
X-Gm-Message-State: AOAM531ROorBDL7ujRTEga4+uq7JcvWwGSgayj9XK/Hmwk5Tfs8zlEzV
        +CFboCHU8FQchne0a1F9ldNZYLhrRbg734r8YNibHg==
X-Google-Smtp-Source: ABdhPJwwPzgwZV5Qicq63O5ojpQyFguS0nK9rk95+V1oR5oYW7bF33gv7rpifcW88bJlcKxLjggGHQ==
X-Received: by 2002:a05:6638:130a:b0:314:7a0a:6b1a with SMTP id r10-20020a056638130a00b003147a0a6b1amr12860252jad.197.1646699123533;
        Mon, 07 Mar 2022 16:25:23 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id h1-20020a056e02052100b002bdfcff2d98sm10887343ils.61.2022.03.07.16.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 16:25:22 -0800 (PST)
Message-ID: <6226a272.1c69fb81.32b26.8f6b@mx.google.com>
Date:   Mon, 07 Mar 2022 16:25:22 -0800 (PST)
X-Google-Original-Date: Tue, 08 Mar 2022 00:25:21 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
Subject: RE: [PATCH 5.16 000/184] 5.16.13-rc2 review
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

On Mon,  7 Mar 2022 17:28:30 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.13-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

