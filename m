Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC96C489FEA
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 20:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbiAJTKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 14:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbiAJTKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 14:10:39 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E602C06173F;
        Mon, 10 Jan 2022 11:10:39 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h30so2372886ila.12;
        Mon, 10 Jan 2022 11:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=mBwNCC1Jx7+fhUj2wj9RmdYP9OBbVW/RNMLHjwHDXaQ=;
        b=Tvibpb75nNeM2GA9qWsETzrEyGNM9SNXlIw0vEwRXXDzZsYM2qPOmrFFlky2xxJna5
         8hb79B2glfQkGqRK7/WrBQI3LiE3wQvmq6no3DC9n89eh2j+64ZI1J/2rwIKmVlOXw8N
         VT7Oh0BZbClcBHubMJbnDrP/mrs53VkTEzCYCkxSpASDwkldkfBovPRHD01HsBHQinhu
         6XFALtn1MuviUeV7Vc5jyim00rbUcsfsu6J+ks2a+LYFg0NVCO2Qw2kDcpZwJvQw+L3R
         6vHdCyMGWzey8S8hzvO+FQ/Vg7btqwxgfITINKeY9dL4EOHIzAOwWhMBczSUNQLEJro5
         AqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=mBwNCC1Jx7+fhUj2wj9RmdYP9OBbVW/RNMLHjwHDXaQ=;
        b=DaecXcolEh0Pm4Y8upSYFvVmG6gTdO07yatPO8QotEg3F+qKJd0ljRNgt8tWwwmFgw
         Lu1nffa2fnVAqiH0GNbbPxj1P2RTHsF/qBzbiGIumCveObZDO6T7ymlr6pGl8Qm3gCFn
         FBgLXsL9GTVvOlYZwn+SkI/QBg193jdDle/NKWAx80sTeu9jt1tGdv4U2ur0XTmTMWji
         IvpktC0XznWyXG/Nml2kWUah32UhGCgA+JQj8l81Z4aLSiupmXbl5Iek3ywtU7rFD71W
         M9Dr/7eKhSUHbiiO3zDuC2xmjaqraS2fh2882jhbl/K30OZPHatk+pQG5J4lUiaoz2oP
         4NaQ==
X-Gm-Message-State: AOAM532krtlS/KGtgLt/yv+9XOzEDoWn/Zv8STLE78faTSCp/bWZ1r9u
        4iVdraqySCTE9sC0l+okxfWRi5lcnwW8RGQxIJ0=
X-Google-Smtp-Source: ABdhPJzN08oSDlK0JZh4CzLfsX+eRl0C57xOBnTHfR+sdIHFnXYDWVgQI4P2h+PVi1/5LxsNKkH0Gw==
X-Received: by 2002:a92:1e0a:: with SMTP id e10mr721863ile.28.1641841837969;
        Mon, 10 Jan 2022 11:10:37 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g20sm5007485iov.35.2022.01.10.11.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 11:10:37 -0800 (PST)
Message-ID: <61dc84ad.1c69fb81.a19fb.597f@mx.google.com>
Date:   Mon, 10 Jan 2022 11:10:37 -0800 (PST)
X-Google-Original-Date: Mon, 10 Jan 2022 19:10:35 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/43] 5.10.91-rc1 review
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

On Mon, 10 Jan 2022 08:22:57 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.91 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.91-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

