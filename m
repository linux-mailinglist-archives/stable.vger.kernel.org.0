Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DE7476649
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 00:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhLOXEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 18:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhLOXEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 18:04:00 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791BDC061574;
        Wed, 15 Dec 2021 15:04:00 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v19so17837684plo.7;
        Wed, 15 Dec 2021 15:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=hJ247Tjtv2/SMLJJVrKbZ64lGbQGu3byyWPjCjUkufA=;
        b=X7FZiUXrQBtJOhpSwc8vgZlabebrQAjdSNY338T02H8YNE3CKJ65APZx+fMj5ECm/t
         ygM5Adq0yrMP7rwMBEwZquKC/UlVPk9YzLwKv83oFbVAUQLGdg6cEHUWVMdSQyPcCtAe
         z43OLTIWcoGDPNPRmtHS3/tV8DQnEjyIOqBb46/VvsY/fxPgrL41HbZqhmIiByyblhgB
         I36sgXp0skTlzGSWiKD4NTqMMZNyqgA/yCt4IFT60Ex0TgbWUCmDCoIELTT3Fit5+S2w
         2tk3KVn0nXEraQOPaDckU9CB5a79H9UpWRKKjii2cYtk5MqiKtyMNyFP7eTIbkhHAZJl
         8JyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=hJ247Tjtv2/SMLJJVrKbZ64lGbQGu3byyWPjCjUkufA=;
        b=rgXTq6zRfp+3GPgfj02uCFxIoUntnQkugpKBr0Yc7fSy/qgXaLKtaScAvgg0Cg6eQh
         SwjHh2gAyb0AH0DN62KdvzNg3zYmw9lD0IGJG/BzQpmlhmDICbiYthGbfwxzGB+oLvCR
         M6xP/RGCKsKGlgI27nJp9xUpxwKJXlhMm4miaMknurONSE1wx5jBQ8VuCttTY8/UP0/3
         /cBibUPT8zme5JMDdqn6+v1IPlfWvfZYPVN7xmG1FE+tNBmqTe67BH/RuqNYIrb+JWda
         itqXGhhMP7Fd78B3wFHAPwaPpkF6aNw5n8Pe8/ZoVowB/FJc/4Gu3W7JCxoKUrHI0hKd
         hx4A==
X-Gm-Message-State: AOAM531cnLO1pagswfUD572zh9q1kZ3nAR2IsM5bh/6SPK3z9PS0XRbC
        b42Q8HbiIAYjMlgi94t3B78DnC7dWUM9Jjuh9u4=
X-Google-Smtp-Source: ABdhPJyD03wqzdSWY/kLivk1pCO2f72V0VVdzsclt3SzMtqKCV6RTXeFRt60iohIJRzXNqVUg8/qNg==
X-Received: by 2002:a17:90b:3511:: with SMTP id ls17mr2401111pjb.81.1639609439529;
        Wed, 15 Dec 2021 15:03:59 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x14sm3210065pjl.27.2021.12.15.15.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 15:03:58 -0800 (PST)
Message-ID: <61ba745e.1c69fb81.4952a.8dfe@mx.google.com>
Date:   Wed, 15 Dec 2021 15:03:58 -0800 (PST)
X-Google-Original-Date: Wed, 15 Dec 2021 23:03:57 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/42] 5.15.9-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Dec 2021 18:20:41 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.9 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.9-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

