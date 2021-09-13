Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF535409CB8
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 21:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbhIMTOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 15:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbhIMTOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 15:14:02 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B129C061574;
        Mon, 13 Sep 2021 12:12:46 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id bg1so6484912plb.13;
        Mon, 13 Sep 2021 12:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=MLRdoHEqkoihV/XPsuabbjyyNtIvAzqyI0OO1lOyXWM=;
        b=U0y6z31+Tjzxqeh8FqL2QijuIgnq6oOyO2/10p9CtuwJPKhHLSzKzb05rFVAeay+5q
         WSFU/FSgWr6vbaeI5+QIkqB6UHNupoZmIihYAOd2AqZ16sWLwvhLYBXimfMzslfHh8/L
         PIi+Et32B+SNCilyEq5tTRc5fvi3YPO4k1CTGgz/HZdotlBA7vXoTi8ioZmJKCr7J8uG
         5pc+SsEv/e7yr559/Jkt/Wt49/tVfzzU1sCJA8vdiWNQE0WX4Lr0EpQcHbO9StmPwU/f
         Aj7XmYYW6CYDhoNO279XKnY3Air2PCi+oG7NqeWSk1OFW4+oQIl/x2q7o+7KwXLzed92
         QxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=MLRdoHEqkoihV/XPsuabbjyyNtIvAzqyI0OO1lOyXWM=;
        b=LHvhrjpf4d+H8HwToFe/nprQsU1qt808l5TvbogjsVf53RoYv4QMqIMFBUP7A3Tmw3
         z2EY76ObVZMofqX8pQplVn8kPp7AEmZ1U7fFdlxKM5k9PSJgRK93UEyBKMw/aZ0dmsOk
         VQED5VFM1rSS1D3KUR9HzJtUQXTMzB/IoQRsZeYiKsa6Sa964lMqngUI9rQRNMkESdkT
         Y1k94GgXAfJDLUxOF/S4Dmkm3O1FgU4K5BVTebWxhAx9BcX9UtAZyrxqodvoXN95O7ME
         PbrF19ChU9k7S+Rl6nGvh0u2YXbZ1hV1IM7esqaJor4MF3u8LC7IfZKs54xv+p6JcY2S
         lG3w==
X-Gm-Message-State: AOAM5332IeYWCS0bLN3trlTWPm7vR6OthyLh7DZX5+iv0z7OKP3cmq03
        ZD1HGfbDtyFH7AzNDFVymRWPZjJyt5nLN+6bYAE=
X-Google-Smtp-Source: ABdhPJzrlPyT88OWTIwqVCuPkS+ELCxQqXHB8XW4dSf6tnmje1/y8da6JkCp6v1cBZcP3sxFgVKtRQ==
X-Received: by 2002:a17:90a:1915:: with SMTP id 21mr1237158pjg.24.1631560365455;
        Mon, 13 Sep 2021 12:12:45 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id h5sm7851101pfr.134.2021.09.13.12.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 12:12:44 -0700 (PDT)
Message-ID: <613fa2ac.1c69fb81.869d2.65a2@mx.google.com>
Date:   Mon, 13 Sep 2021 12:12:44 -0700 (PDT)
X-Google-Original-Date: Mon, 13 Sep 2021 19:12:43 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/334] 5.14.4-rc1 review
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

On Mon, 13 Sep 2021 15:10:54 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.4 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.4-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

