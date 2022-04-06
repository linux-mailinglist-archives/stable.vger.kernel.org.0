Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6B04F6530
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiDFQTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbiDFQSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:18:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E7737A29;
        Wed,  6 Apr 2022 06:44:02 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so5782455pjn.3;
        Wed, 06 Apr 2022 06:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=RwX0uughPCrzoOEWZNsX7H1H6/75muhMMi0zchv0/s8=;
        b=VvF5GxftlOsJ+OxthLmKga3EFD/rI2vkMabl2VpEhUpZqcH6c2NOQw3IICH1eh4n5y
         rhvGvSIW9YyNWDNpfy/BuqQWViRlulNcFJpSeo3UgxP5dJU0Ri1EzZoovSjJoM9JfYxf
         0/CECYIBPvUfpxUs7EDb9NT/sVdxW+TLJO9f7pSvgWnMm3D4qYWL/afTZ2wYgYtWyU8k
         v4c+SHShsS8qk7iLlm2VE74NLg+bdmr3hL5NHm3TYnBNPTpVIfpFtBbMeaRZBVdeKuH4
         0BQUIeRE9B2O5op1vMLabRwQqk6MoG58INU6gS7I9FLa4RgAjKmy/zGEbQyfQgrnKqKa
         dhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=RwX0uughPCrzoOEWZNsX7H1H6/75muhMMi0zchv0/s8=;
        b=Vhu4NbthKlO1cadea8i++q4rwaMBNuoXNFSqL0M0+XSiZY4cQO518rKwL8X7vQG3ja
         814UU9B7D3/CJWJgMdcK1ThOjB82/N2UKEQWcW4MZSyCAe2KI6yOrsROTuSOQbah6+tw
         wwocqwOURpbMuqieY4cAt0tSbDAap4cvwfLKf46IEBEJ9iRgl55IJSoR45QZK5fcYvdw
         U7JgSZWJ6tb9N4sm0kFhWCjfIgXA1/Z/pJ+mQCNupFJvPe6Z5C06Dhfr6E4otlYDdxTs
         qVFaEm3ZI66Ltnk7+jJxxcRIR7ou+RRHUmcn7l9eLs/iPOXycsYciZL7LzOLSUzWHIIL
         qU2g==
X-Gm-Message-State: AOAM533VE5Y2hhdZEb7Mn1fjIsNOOUtt3OlMyDLG2onwyhalNTpXZ6Rd
        PcquZqCITtkFugrd28p9KNPvRpoAmJHfuBc+LQo=
X-Google-Smtp-Source: ABdhPJwjvIqpvKArYl2Q+0VlnlgdiBDK+h1Z74uGsUXg7MGexW6JXpZvtIM9XeY4bA8OMHSoIx3Zug==
X-Received: by 2002:a17:90a:be0f:b0:1ca:8dbb:3f11 with SMTP id a15-20020a17090abe0f00b001ca8dbb3f11mr10063496pjs.104.1649252641494;
        Wed, 06 Apr 2022 06:44:01 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id m123-20020a633f81000000b0038256b22e74sm17244197pga.82.2022.04.06.06.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 06:44:00 -0700 (PDT)
Message-ID: <624d9920.1c69fb81.76b2f.c664@mx.google.com>
Date:   Wed, 06 Apr 2022 06:44:00 -0700 (PDT)
X-Google-Original-Date: Wed, 06 Apr 2022 13:43:59 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/913] 5.15.33-rc1 review
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

On Tue,  5 Apr 2022 09:17:42 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 913 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.33-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

