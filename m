Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675BC4529FA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 06:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhKPFsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 00:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbhKPFs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 00:48:28 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD21C06BA94;
        Mon, 15 Nov 2021 19:54:07 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so1631721pjb.4;
        Mon, 15 Nov 2021 19:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=uXbfw/izal149Gz5yqwKVpenNb0MrLQ7PVdG9ilARhI=;
        b=Lu/wvcRI5AXNv6tsBujJhaL/4L2p9/BLilOlq2zJyp5Gst02OMemQYFNKJn5C+AoyF
         iiJsLcczKZHir7jVHsiZmw/EQLNT3PXaes8OeX5ox2S9s0T0HGV1bZoTYvbl0XfwViDg
         p+9BwpIpDnQI2WH38MpDOpZun3GNaVY/xXZ3fVXjv3D6U7Gwe4yOfoBJ5MygWnRHMjjf
         8QYyewUgmhYqzsL4NuH3d6E3a2XxKTxrxY9zIHTcR1ljNw/Lo2WF/qp7ZEyRyPIgrN7Q
         yZH9v/S0CzTB79mVJ548ElH3drHEjTdkxlFKgnMFqCGdadjUrx9YXSCz7ljUihr6jEpt
         6j5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=uXbfw/izal149Gz5yqwKVpenNb0MrLQ7PVdG9ilARhI=;
        b=aM4NJk9Q/H1u8dp/dMm2Xnl1MqY78fQ6FXC1FozT+lmVKZ/DsQM8aeGZs1tb7HO44a
         dtMtpOyIwln82TSm66dvCYITiN7+A0J+1ouHdrrfWg7nI1COuPeAStlqkh5h+nTArLR7
         5dZok1xuxM14GZ/RnDx/SZoqf4hdUaSXdmkgZTMK6uymYsYPKsQthy/TCwl6WjCAXY+c
         3rW6M2YNFHu+rw1d0/J2a7ReE/i7tWqgrSOOJ2xi8+kDQCEHY30NKXl6xFPdnXW/QdOn
         /vq4mIscojjnJWbSsuonWKFYu0ThQ4Ux3jNu8/jZP1gxx4Ug3xQ5vj0wl/oCFWr0+mJQ
         itQA==
X-Gm-Message-State: AOAM5336/XrSYlOQo0OKYdykWQp3XIbE0BxmUxPCrd4HNSlCnbM9ci6w
        84t8psHZY4VQ2htnk1W03/69Uam80FSqbC9pd4Q=
X-Google-Smtp-Source: ABdhPJymZx6pXQY24wSlQVstcliQQQBRNaUYIOsBenM2qkd8z5cfw7qK0Un+zHO12V0ANPtye45Meg==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr68883616pjq.64.1637034846642;
        Mon, 15 Nov 2021 19:54:06 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id i67sm16628105pfg.189.2021.11.15.19.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 19:54:05 -0800 (PST)
Message-ID: <61932b5d.1c69fb81.d235.1c67@mx.google.com>
Date:   Mon, 15 Nov 2021 19:54:05 -0800 (PST)
X-Google-Original-Date: Tue, 16 Nov 2021 03:53:59 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/849] 5.14.19-rc1 review
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

On Mon, 15 Nov 2021 17:51:23 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.19-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

