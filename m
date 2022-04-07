Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED34F8BB1
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 02:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiDGXCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 19:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiDGXCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 19:02:54 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B2B75E40;
        Thu,  7 Apr 2022 16:00:53 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id s2so6866484pfh.6;
        Thu, 07 Apr 2022 16:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7Qyv8QdcND81xZ2B5k9Ja+iWLUF0skRmo+wVQGrFX6w=;
        b=oUztzCBbDRjHHkv++9oLnfjyO8tsMTXPXjHEFbBYVFiaSuG+TXhy8F1LXBeD71+rS2
         NS5VGDMpl7w0U6n7R+Kfz3GYKK02nQ6sdhvzneTlxD2Sz/o3vy+MPp82ifk1iqhLK10s
         i/OTD18qx/qZkKp7W8sSz29xMVuGOsl0s7+thUf5Q/8R2SQYF690rpyWy/PNyLt1+dja
         7qMde03kxmfqfs4Lq9/FjXL7ELpet+0AIsitD4oUJFfltEF5JBjpYcI6n7UGZGxOLNuV
         9HRBsFuR4Uhl2aiR+OsPPqW2hGIMvDC39CjKjjdgfRiJJ04QNUiTh2PgSSPkdHXBiSDN
         xxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7Qyv8QdcND81xZ2B5k9Ja+iWLUF0skRmo+wVQGrFX6w=;
        b=xhCV4e51P90S8dNdwvH4hUAqmGENqzGm4/WqpTQVStbRwF0sysWJFcpg2HKRJvoYAT
         baGl+I28hrtt2URDTq1N+2Q2hgkEkpkcCu/WjthCkH0TpC82UO8ajPuKYzgQKB/gkHjH
         DWh+hmROaqkZgTF28qD1KkIW3oUSg2UyNebPwDOr0G9dTl1wLTH0+9wda0+k7qAs2TqV
         sL+sZYZBvNpcJFB4STlmSPWmBkuqM5SXhRUxvBEKYVOw66e0qwmEJ5gB9okpBObF/5lB
         7IBgCbyYibAM7D6Zzo0YljNBOoF2naXAsLYfhU547gPE5l2+rpzvflkmvrG0Gc+407a4
         wCcw==
X-Gm-Message-State: AOAM530epXF4OhtwHbf2Cu0h+wJUGlxxpzmzJ9vqbkLDh1msxj7x3N/7
        0mjrNow6d2adIZJerqvjrtKBIucS9ckoSNwX8LY=
X-Google-Smtp-Source: ABdhPJz/NR9OT6T1T82sbfhXQpRzpfjh4U/Ycs8HWMcb4AzonLQV3iCnBYpUBEihOe6YYpqd0komsw==
X-Received: by 2002:a63:6802:0:b0:37c:6bc1:f602 with SMTP id d2-20020a636802000000b0037c6bc1f602mr13414944pgc.128.1649372452216;
        Thu, 07 Apr 2022 16:00:52 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id bj18-20020a056a02019200b0039cc84dfb40sm2753514pgb.19.2022.04.07.16.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 16:00:51 -0700 (PDT)
Message-ID: <624f6d23.1c69fb81.50fba.7910@mx.google.com>
Date:   Thu, 07 Apr 2022 16:00:51 -0700 (PDT)
X-Google-Original-Date: Thu, 07 Apr 2022 23:00:49 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220407183749.142181327@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/597] 5.10.110-rc3 review
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

On Thu,  7 Apr 2022 20:45:17 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Apr 2022 18:35:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.110-rc3 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

