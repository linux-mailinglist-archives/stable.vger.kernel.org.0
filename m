Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57A24D3C5C
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 22:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbiCIVuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 16:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238450AbiCIVuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 16:50:17 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E2185BDA;
        Wed,  9 Mar 2022 13:49:17 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id q4so2912177qki.11;
        Wed, 09 Mar 2022 13:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=sxvKTikY8johRtBV0JsrDp4qIzaspSzV/aknHXI6mPA=;
        b=DCXO3372gPkxqP/Leco25R+kBT3KC6i+9oHMlPpmT+JSeAW5L43zE9d6d4Br3DvUil
         g1mpCeweEtr57ihSZ3v3Lu5Wqt3b+xsbwCZ88y9lNDoRh2ifUxY30DWyxLziXWAu+ElF
         TUOtflCId8R7+wcSMXzSduYnD2cCh/r7ky7OK715NCydC80W+1HkTND0pEvDKg7mbg7j
         6rIh+3vH2TFkQv7wVBwOTLv0IH15S3SaMjlPRlIS9iYQB3hgxs8K2Hbx+yKgQEaoNdfD
         ynn+sEXueD3BluQqIKivZwtxCUDefogfxSxrFQ9Un81CMx0nIYzF5x0epajCXHgP6ag5
         GSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=sxvKTikY8johRtBV0JsrDp4qIzaspSzV/aknHXI6mPA=;
        b=iUkmZG8lis3wWjwOQWuhNB1RwawDdtCwyzwcrHOvNEz4Ljh1JqlDsRLoftYYoIIT7G
         253ZvCgINsX/aWkomMnAC8Jzv9ik3pLYuRMqRicpDeWCNDguhU2249uHogeYd1AF5vUu
         Jkx8A3X/KLB4JzgftJKP7GlKCYomr8kUWrc0HjYPETyR1DH9eWIpGp260iKhiXYt29rl
         FMf07CzkEyBCq3wwNTiaQthq/k07Il80CnemPso8fp/Tcsm8GIXAPlexeQuT0tfvYSke
         cJyvRdldAtffWDWvPjAlIwIxRSZGc58THsDZKph+0JzM08EUAyH+wgzGP3aQpnrMolHK
         S23Q==
X-Gm-Message-State: AOAM531vck8U7nbOkxWpgjGdFoJJwgxBrjAk91DpPftZiOkCjR90K9c8
        IkXSNGFsTsDA0uTNS7Sq/QPSGurL6FXzVf5Mb1NWLw==
X-Google-Smtp-Source: ABdhPJz6S3bIPh2tXJa8Muk574LyVrRdVW2MlicGoT88aodYQr+2l7R9qt9NP/h1er0GNuLvdiEjqA==
X-Received: by 2002:a05:620a:2a05:b0:67d:2fb0:b292 with SMTP id o5-20020a05620a2a0500b0067d2fb0b292mr1189717qkp.343.1646862556410;
        Wed, 09 Mar 2022 13:49:16 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id t28-20020a05620a005c00b00662fb1899d2sm1460327qkt.0.2022.03.09.13.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 13:49:15 -0800 (PST)
Message-ID: <622920db.1c69fb81.bcbd2.97ff@mx.google.com>
Date:   Wed, 09 Mar 2022 13:49:15 -0800 (PST)
X-Google-Original-Date: Wed, 09 Mar 2022 21:49:13 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
Subject: RE: [PATCH 5.16 00/37] 5.16.14-rc1 review
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

On Wed,  9 Mar 2022 17:00:01 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.14-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

