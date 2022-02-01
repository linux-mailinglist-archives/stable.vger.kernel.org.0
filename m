Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902B54A67A6
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 23:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbiBAWUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 17:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiBAWUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 17:20:43 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851EDC061714;
        Tue,  1 Feb 2022 14:20:43 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id l13so7912652plg.9;
        Tue, 01 Feb 2022 14:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=aip5U1EEsBs+h2Ey373SphJTST30ErR1Vel4zpBSfSs=;
        b=BhgQKzua2LgvVMwH8d09Wj1vGAljJjafChnyAtk6ZeamKWAsp1kGizt+21QAdUsO5n
         4Y4ibNaJaaYe3oUdjWDv4ToQNHYSHMNmOQEIdktnly6qKDZTujllbWRMJ7NPmIgcUk/z
         N0JS/HX1kBmJ+HEQG4zzMmLN7qFVLG1Njs2UBK+kTaNWYEEb58+IUAHXKganRyc1UPMG
         covrZoRWSIWpO79hoXI38hYjs4e93AeGBLEFP+avPQqb2Ox62gJlw41/tLzeba12WDaa
         RfdhkPE/7ht5QL9eBvB7mwr/nodz1BFrjelGRgqmTlLCSOML1hJEBV2TxcblnhGca6ls
         N/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=aip5U1EEsBs+h2Ey373SphJTST30ErR1Vel4zpBSfSs=;
        b=IB2pg8frIBpnW0Yrwz9lmxUAt8uz2/MKlKNEEzIidEkbanbPtG+41pu4BTGdZf59EP
         1EpBpCU1pqhdd+h5vg2akZFX/hIfTj6ebJITl99nZxvmk3H7hB3iK7dSV/ZdJPcNtzHA
         o8KgcYcFfy6o0BwKoGja1jPiNKdHw+jVDILLGyUm2ThSbw5YABuwF7GJQkcaqqwc1HQB
         /sHDYdYwzJWf4SAzTyVahGpoSWhqq1XOLgEoQvXyzK3bOf3aRWIwRM6Towvw1Az83dRR
         rhBB9qn4gv/UOOvmIzFdCxv6fKE0muqzV79sOmH8TcTiiZFv3QriF6V1Ya28Is+lmoe/
         EqUQ==
X-Gm-Message-State: AOAM532UXAAQuO/uRnWOYWVbzZxTIhOszWYFK96JSIW+DlvmJQK/VNDy
        DZVRCsiy9PWsbaS+8nZYvlegPC1BLI8inpXHWZM=
X-Google-Smtp-Source: ABdhPJyaUzftmwa3cRE2DCmQa3fK0w5ruvc8WYRfGqKtrkSGp2ICK9UfD2iHsIgIpQ8dBZghmUfilw==
X-Received: by 2002:a17:90b:4d91:: with SMTP id oj17mr4766058pjb.46.1643754042412;
        Tue, 01 Feb 2022 14:20:42 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id n42sm22176327pfv.29.2022.02.01.14.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 14:20:41 -0800 (PST)
Message-ID: <61f9b239.1c69fb81.24eb4.a48a@mx.google.com>
Date:   Tue, 01 Feb 2022 14:20:41 -0800 (PST)
X-Google-Original-Date: Tue, 01 Feb 2022 22:20:34 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
Subject: RE: [PATCH 5.16 000/200] 5.16.5-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 11:54:23 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.5-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

