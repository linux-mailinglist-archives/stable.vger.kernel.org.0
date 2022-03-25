Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E348C4E7D10
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiCYT12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 15:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiCYT0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 15:26:55 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C0B1BB79A;
        Fri, 25 Mar 2022 12:00:11 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id l128so9291210vsc.7;
        Fri, 25 Mar 2022 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=r/95gP+62R+F7oCqZcO36nUxKx/3DFkpVOjIVjsUBb0=;
        b=eTNMgQi4QHA7yaFi1tawBT56ZWrwQoj5d8R8CFDwLbR4lyM2iOILRXw5o0QhaWDFRH
         oZBJG3yD9PPokIZDxBMWS8KwPGYaBOlBeTYW6//dRaa8gWYFVEOWuMHPmT36JGreufKl
         M+Q5f5oDCfzMaodfq4ylynRFReak1rRk3DbagLD4ugt9lRZZsa6I2HQcB+qODAdEBBbF
         8V7dEMCM+R9JB+Teh3y0qbvoaYCs52mL7K8rnuTPo15sP2xNQnEth+vliYfjng/1NF2A
         9m67Jkvhxv4qbz7Zjeo6XRMMkthfd8rdbKz4/v6qXwHuahocrqOaw4fhOlJt6CvPnYQ+
         Y2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=r/95gP+62R+F7oCqZcO36nUxKx/3DFkpVOjIVjsUBb0=;
        b=UTI4Axy0cHybyYYrBMrJvB8R8aE4nt84Xotka/47iZ76vl9bdwtnM9ZkrqgkFzO6qG
         NORp3KpiWFvmJEkcDCWJQ8N3LB5Wq9A5VljqKMDzODOCcWuvLJdpiXq39dV25l7Ms2AD
         HwERNF9I3WyGcg5EvxC960PR7qee8r0jvK+8eAoQ4TfNsAVFJuRE2ou4UM5ktQCgL33t
         Bl3uDi3FzhhckksZCd76q94v6IVmKOK5WLmGpNGtf4S0q/9Gap4tO67419e7ZJUNeaoV
         H/eutrjBOKBp/ntwbhAi92fbu6SyYS5CEBbpZhmUNqsX3kUY2DhPgcob8Dc/F15Lw9m0
         wB/Q==
X-Gm-Message-State: AOAM5302nK1tMbjRozBonDjBClRdTaPuaTAWoYoc4tAncrkP55fjxAsO
        yaslnk9qBE7lPgxIiH2zvuTU9fIa+V3BPs1YKuw=
X-Google-Smtp-Source: ABdhPJwJW2eMukNWeLEwwbk9MGN0sJuFKhXnpYB5Kjc6uxpm7d1SLS/nj3fMxyUiZLun/1Up/vNHNg==
X-Received: by 2002:a17:902:6b0a:b0:154:6527:8ddf with SMTP id o10-20020a1709026b0a00b0015465278ddfmr13182065plk.154.1648234327008;
        Fri, 25 Mar 2022 11:52:07 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id u126-20020a637984000000b0038147b4f53esm5910455pgc.93.2022.03.25.11.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 11:52:06 -0700 (PDT)
Message-ID: <623e0f56.1c69fb81.92164.1317@mx.google.com>
Date:   Fri, 25 Mar 2022 11:52:06 -0700 (PDT)
X-Google-Original-Date: Fri, 25 Mar 2022 18:51:59 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/37] 5.15.32-rc1 review
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

On Fri, 25 Mar 2022 16:14:01 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.32 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.32-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

