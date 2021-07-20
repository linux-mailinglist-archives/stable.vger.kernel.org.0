Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24783D02B5
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhGTT30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbhGTT1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:27:08 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F283C061768;
        Tue, 20 Jul 2021 13:07:41 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id t143so467354oie.8;
        Tue, 20 Jul 2021 13:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pcHC6RqOk82iZlsKDkfmCT/vQcwevScTuqrbEhZkZAA=;
        b=QDWczh0iRZ4z4D9/mg5jnfBhdoZkGzLH9LnqkkigVrmepC57MSaFh6AZf3iBIrjorj
         5hl692D2TOrWpvb3KNthGHrepO8xEO40D79oQCuVMsrsnaWZmi1Dd2iYQxZo41stYwbe
         QSWDXpjW/7mqQ0Cgp9egdDkEVAOua2qOKZW7uytMg14u+NQurCSH6PwCbDE0RFFzh3Os
         sPpTcGuSgMIEko5yEXqXXQm74JQrVGvI1fyxgS6hArvHq6n+/a0eqLzu/VfVqzVdkRLx
         eUy/4kk7r1vZbqrEAsZTzgKxZhe6S+igWIBQelzuvV9cebDCi8JrrRO+LG8TIgZ8pWWI
         +brA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=pcHC6RqOk82iZlsKDkfmCT/vQcwevScTuqrbEhZkZAA=;
        b=aomGNzUe+qUc9aU57nd66pvGTTSa9Dc8FazrE400TImv3bb5TaPq0MnC0hAe1ZhxoB
         kO47NEK7MLTrNT3pP46a9U3WHrikyvjCVzyDLm1GDn9uTeH2B060Z56uSPfdVTwSEvi/
         LB0Fl2BZrvtF+fwoUA+93QfZwAnHhDGnRwEdIYnw2qAY1TIFpDe9I1hxD6/z7sEen3gr
         O+BdEKha6rf9Ib+lWldrFw7GpYbKLTR2gdgWqZEZMqZzZZNyqphPNvfiKxQ3/Av6NfM9
         Cz4rRpY/HDoSDTPXFBkcO2ceov1STk2PlX7Z0fxoY23LfsgFy35VX2GJHw1+Z4t9Ki05
         Qi0Q==
X-Gm-Message-State: AOAM530CLhFJRwGmsj0y6V5c4P5DXsE2sDr9K+X0TeyROTRaxFzRn/kU
        BsA8Ti6mcZ+UZMPv4j1g/eQ=
X-Google-Smtp-Source: ABdhPJyxdjdz2Nhs8erJvcgesmFL5+Y/x+tIc/aXrxPocd6aNjzhDS/B3LPresLvNif0CRh7A72SQw==
X-Received: by 2002:aca:c46:: with SMTP id i6mr15328955oiy.179.1626811660909;
        Tue, 20 Jul 2021 13:07:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v3sm4184200ood.16.2021.07.20.13.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:07:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Jul 2021 13:07:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/188] 4.4.276-rc1 review
Message-ID: <20210720200738.GA2360284@roeck-us.net>
References: <20210719144913.076563739@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 04:49:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.276 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 328 pass: 315 fail: 13
Failed tests:
	ppc:mpc8544ds:mpc85xx_defconfig:net,e1000:initrd
	ppc:mpc8544ds:mpc85xx_defconfig:scsi[53C895A]:net,ne2k_pci:rootfs
	ppc:mpc8544ds:mpc85xx_defconfig:sata-sii3112:net,rtl8139:rootfs
	ppc:mpc8544ds:mpc85xx_defconfig:sdhci:mmc:net,usb-ohci:rootfs
	ppc:mpc8544ds:mpc85xx_smp_defconfig:net,e1000:initrd
	ppc:mpc8544ds:mpc85xx_smp_defconfig:scsi[DC395]:net,i82550:rootfs
	ppc:mpc8544ds:mpc85xx_smp_defconfig:scsi[53C895A]:net,usb-ohci:rootfs
	ppc:mpc8544ds:mpc85xx_smp_defconfig:sata-sii3112:net,ne2k_pci:rootfs
	ppc64:ppce500:corenet64_smp_defconfig:e5500:net,rtl8139:initrd
	ppc64:ppce500:corenet64_smp_defconfig:e5500:net,virtio-net:nvme:rootfs
	ppc64:ppce500:corenet64_smp_defconfig:e5500:net,e1000:sdhci:mmc:rootfs
	ppc64:ppce500:corenet64_smp_defconfig:e5500:net,tulip:scsi[53C895A]:rootfs
	ppc64:ppce500:corenet64_smp_defconfig:e5500:net,i82562:sata-sii3112:rootfs

All failed tests are due to

drivers/memory/fsl_ifc.c: In function ‘fsl_ifc_ctrl_probe’:
drivers/memory/fsl_ifc.c:308:28: error: ‘struct fsl_ifc_ctrl’ has no member named ‘gregs’; did you mean ‘regs’?

as already reported.

Guenter
