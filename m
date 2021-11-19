Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3948457865
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 22:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhKSV4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 16:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhKSV4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 16:56:06 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2CBC061574;
        Fri, 19 Nov 2021 13:53:04 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n85so10418406pfd.10;
        Fri, 19 Nov 2021 13:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=5xw91+HUoiYi0mRqg+08lGzsCsX+pYab050XCbWLrA0=;
        b=maFk9IPr3qIydIyqJQMuDHLpk8z4xBkpcfqzWhGDLZu1jTWuhpAGvxSt+r7TBuAWt6
         PdO0r39mzN1T2Wr/kCFGBux9EW7KOWw/2gV8+noyBGsCrBDtrRLee/AdhttyJOkTq9TI
         hh/rVVf1OU6QS6+uF2RAibaBFMpg5FQCEmVvfqK66wj45Kvlr6BUsppnCjVSAToNWGs9
         tD0RdINvvN1CsBlbVN+pwa1FWfU/a41b2DcNY/FounfcViTaCFXwjc2WMNgdV6s5k69G
         RU0kQKG2NyEcDdsYjcOhCfuehs36fN0mo+XaQWkMgiqUih12BsYShSkQ/W0382ZUtRS0
         5Q3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=5xw91+HUoiYi0mRqg+08lGzsCsX+pYab050XCbWLrA0=;
        b=D6yGGFCsuA4bPdI+Oix9zWQLkP+zdzOCtbaRPLvaqpaQnAE/bzzJ8HMJ1zDzovwHOE
         dXSpqWjHxMfi29vbonP5C7q+uiXN2GjlTFecJUF8LPW5yogZjSODbxzGn5cjn9Cf2k35
         qy4+wamPlrWwQHfsh5CZNzEnPMsnYTX9nvAp+1zxBOJBzTpZ1bCAUTGnfLEymD1b/se9
         nNBVxtfGm7+vIAEhlFq3DBlaToPEZ+kFOTXaOCyueDI2S5/qSig420IwjtofsqO0kygK
         C7nYpycgEzl4hyIOkD75sFsH7m5l756fJN9odZvwGqsZ0PhrALMg8tgNBPLHBzpEf375
         iYQw==
X-Gm-Message-State: AOAM530Om/uiI/a+d2GadaLjKxzXepmw+dccoDXwvAt6P1tF4bYx+kyA
        MYVw/+hf11Dl5nh48Zq/IAD7Jgcmv+7AsVKf9/g=
X-Google-Smtp-Source: ABdhPJzwzjA3a2wap+kIDSm5zArFnNQaBL1UO4jWWMgaS9uS2/53UZv0pm0z0svz9ZAR6rWipBw4oQ==
X-Received: by 2002:a63:1007:: with SMTP id f7mr3558468pgl.212.1637358783231;
        Fri, 19 Nov 2021 13:53:03 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id h8sm617246pfh.10.2021.11.19.13.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 13:53:02 -0800 (PST)
Message-ID: <61981cbe.1c69fb81.75cd8.291c@mx.google.com>
Date:   Fri, 19 Nov 2021 13:53:02 -0800 (PST)
X-Google-Original-Date: Fri, 19 Nov 2021 21:53:01 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/20] 5.15.4-rc1 review
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

On Fri, 19 Nov 2021 18:39:18 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.4-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

