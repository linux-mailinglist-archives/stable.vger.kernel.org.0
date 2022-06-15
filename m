Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E3454C0FD
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 07:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242983AbiFOFAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 01:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242811AbiFOFAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 01:00:08 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC42842A1A;
        Tue, 14 Jun 2022 22:00:06 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id bd16so6068873oib.6;
        Tue, 14 Jun 2022 22:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=8+bSBajFXGCPrKGOOA+/IZXfT4P9Pe4t+NSXOvRG8oc=;
        b=ZT4Jacu1FbygNWRpE54frEyuD3aTWfjuPU38DT47RwP7MyvB7amZEfgPY/wOcPnbKX
         iLnL9niy12ZzkDmM7DKl37SmS4nS4JxXriRuP2Lz2kR3/LPHGNv03Vrjrc2MAJXDJXjq
         7/A24w6iNIV8uvUVcmv3aQgBdopUTIey2iFnZoaWYySkgY4K1hyc69kVIMRL/y6SkaQj
         f7YmOM6DhhnR2UqNGWh4w/Jkh01xSF4yLv+fuLDIU9yfv35MRCNXhRYV8aJNHPYlkHeX
         i4zbJC2g+tIzSiQL4+AJi2if5nbGaZhAijfxr1wnQCIxFVU4EMzNXhc6I70qllleeQiA
         6A/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=8+bSBajFXGCPrKGOOA+/IZXfT4P9Pe4t+NSXOvRG8oc=;
        b=MsxGWn6OoUoJ4ImSm2YMQ68S3NhVoUgNr4zNCOzgD74lRlDTrXMXTfP0/ZyjWw5Mxc
         5jUPF09U3fvX2cyiBE0TntlrLmvGxHnO/nasF/NSlAi1q46Hn3/HldI5K0EE5P06ixTf
         RSPG8VyKOllR4n7JI8/JQt7jt6TTQuxqxuNogqDbnC7TEyZfP9K+/eGkbeYWT24U0OSq
         Rv/Lhno6fpnQEatAusqxLxR/nB/D9KUZxQ5nrC1FYfg9xVEpVxHRt5QOAe7NPJSGqNNB
         czTtlf1GdlyGvsbxtKiIKHeKLGC1Qq4q3m27ue8EixAQzRpPywzSxeu3D0Q2BiS5MwD7
         bBiw==
X-Gm-Message-State: AOAM530h/CpxXKPpwBIdlljUWHfOK513Xq1d3RKzq6gHICrDkSJ35DP+
        XW8jwz7B4KqsmYm9q3zceXNmaYtU26n/LQ==
X-Google-Smtp-Source: ABdhPJxJDSiCAYKQm/EMX4Okj2kPC0XnGDWq5RN+IZVd7O4dQtwkjGeYfu8G5ZCZ80B6MMoT8n8oxQ==
X-Received: by 2002:a05:6808:1981:b0:32f:373c:485d with SMTP id bj1-20020a056808198100b0032f373c485dmr3925166oib.45.1655269205488;
        Tue, 14 Jun 2022 22:00:05 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id ay30-20020a056808301e00b0032e7bd6557fsm5826904oib.50.2022.06.14.22.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 22:00:05 -0700 (PDT)
Message-ID: <62a96755.1c69fb81.d4c24.fb50@mx.google.com>
Date:   Tue, 14 Jun 2022 22:00:05 -0700 (PDT)
X-Google-Original-Date: Wed, 15 Jun 2022 05:00:03 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/11] 5.10.123-rc1 review
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

On Tue, 14 Jun 2022 20:40:22 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.123 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.123-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

