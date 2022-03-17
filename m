Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0354DCE77
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 20:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbiCQTLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 15:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiCQTLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 15:11:21 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B76208C23;
        Thu, 17 Mar 2022 12:10:05 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id w7so7020722ioj.5;
        Thu, 17 Mar 2022 12:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=hDbgA7gV8Bhpf/qXtTqfrmshocN1+RVTTi6fuPy0wKs=;
        b=KsZOvvOZLobBDug40aTcfdczgcTC/lpgMfOJUf2X+gKksL0p+PYP5WCWbc3dM5/Kek
         XA2qQkpoS23Dl3iTUU0LIUeFQNYBT3fMMouF0nluCcQagE2l2YoPVXif7lVCOlrtyePP
         T5QTA8zWK5aOgp4Fbdp+Z3FbvRafehaKlJ1zXwM4CYzf8xxs8v/b4ZObWt2ejkPY2m88
         VMnQOxKIZ9r4oXLgDrRzirn4HdENgKA/jzz9HP7DFDwAJSpuFsFwkjl3JCeIXTVtXqsr
         dIflCURkLJ9imj8nhYT4KOjeMM5vXE7MqfsQOPgDF18S52NR9Kec1LPO4IUUlG9V6dzt
         Rlmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=hDbgA7gV8Bhpf/qXtTqfrmshocN1+RVTTi6fuPy0wKs=;
        b=W3/JN2O+yv8GP9eHRgTVlG1wsLRRg5LcukPv7io8Ca+YJmoKE5TNTFCh/TiFD0Jscs
         ly8GkvqI4ff+9IJoQU29jubvjSlf0OaThO7jyGTJU9JQMrjV2ujql4ghadYdMXSut/6X
         9kw0M0JpvqQM5c7MpNhrjVjljLJVcpT/gryd8mJ3wUrHRyBgYePW8yigPe63UE7fbDW4
         9s0fv8C9dYg0IEMO7mUnrkem51YfghYuSR/LfGb8CA9dwAHTuWcllfUUv/0+8ZFvzX6L
         gMfypVEEz49FXfK/6fMPyyiDGXAhnbz1jOkr/OLgH8s0gkgVxhYtdUSvIZIFvroDkOvr
         RGSg==
X-Gm-Message-State: AOAM531bMsgMps5qoLaeL6aVDGsebdCKFF/oREAxqg/1C5iVbF0hNs3k
        2isA/jwL9hgLkyfelaHYrDSC1keXKcD5gdjMPyE=
X-Google-Smtp-Source: ABdhPJzU1bSJYhH7Evxo/QnvLA58mHOapnJkn2Aaoy+y4BMd26nfiCMVNhhKmDRCm8ofTRSSxaChXA==
X-Received: by 2002:a02:9402:0:b0:31a:5a8:81a5 with SMTP id a2-20020a029402000000b0031a05a881a5mr2839516jai.83.1647544203738;
        Thu, 17 Mar 2022 12:10:03 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id m5-20020a927105000000b002c60ed6d3afsm3362851ilc.69.2022.03.17.12.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 12:10:03 -0700 (PDT)
Message-ID: <6233878b.1c69fb81.14d9.f5ef@mx.google.com>
Date:   Thu, 17 Mar 2022 12:10:03 -0700 (PDT)
X-Google-Original-Date: Thu, 17 Mar 2022 19:10:01 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/23] 5.10.107-rc1 review
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

On Thu, 17 Mar 2022 13:45:41 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.107 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.107-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.107-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

