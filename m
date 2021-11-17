Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9770A454A40
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 16:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbhKQPsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 10:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238768AbhKQPs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 10:48:28 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F0EC061570;
        Wed, 17 Nov 2021 07:45:29 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so2919587pjb.5;
        Wed, 17 Nov 2021 07:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=jRWOIgdwNKjUOncp0Boswtyyoo/ED5REIZEfVjwOOxM=;
        b=AffhQ37eX0tpXpIsFMUOCmh0Pejq4xvJr4opADrW2VohyoEK7qROUP6IyTiaKT3z+R
         Q/6TZvyQCNO13R/6c6YPZnIfyKP0JjnnwE8/zLQQ2prc74kGlsALZOd35I5UgGmRvrHH
         T7z9a6j8KH7IKfQWAcb3nxEPA1St4idTkViaaes481XU4wbWYU4MguNrYDDErT8gdjjd
         vKb00kjekuNownXt0dg0krT2uoBtTcda9IFskwBgjh4zXWHkeQDvIiu+R9lVajqCb457
         o2n3cN96OEHDJkLxOYOgWN+ac3peZaf4xNXycFTlyLihzE6tsBJ3cYKuiUzUHZity+J6
         iU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=jRWOIgdwNKjUOncp0Boswtyyoo/ED5REIZEfVjwOOxM=;
        b=GuEMpp0VpUZhCBeAS9QllWG0iOLbnOYkDmANth34u0Kol/T86LY6aSHHYM6zEPn1/C
         DwPAOOWLV1b7XF4FNCJiSNpfnvti+fHhToQ0dXY9DtMsdOWMnLuCRxJzM30y+QgBWF18
         t5dQvOQlOT3ejO82mqPINXveNLoFLwcrRYt8fPcBgTGNv6Nxq+7P3k5U6CnK9nhUZ3A1
         OqY1ZrlDwVRq40yzhnOBAnutBmyYGgmgIHj+4KCS/rSEk5wLhJmrYvQWyEWdCnRhRifh
         +pFQ5+c32w0Y19G63JmES7gTPECDXRbubqC6qISmImB1q24OXPF6srhCKMXAA5a1vIZG
         smOA==
X-Gm-Message-State: AOAM5323Shd/OPawqpJd3oCR7kI+FSBANfB+2edj2peZWcr10SXbo83l
        hocf9DTykU83aFVIS9yO6SchxVBoS1LdSzCVb5g=
X-Google-Smtp-Source: ABdhPJwRNBU4IfR5Dv9ALDO0MzdFP5SAauAREUovfnwSmDH6CT82yOxRRDpG64lolcGJS0yIIeaAuw==
X-Received: by 2002:a17:90a:4a06:: with SMTP id e6mr761298pjh.228.1637163928418;
        Wed, 17 Nov 2021 07:45:28 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id lw1sm5639647pjb.38.2021.11.17.07.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:45:27 -0800 (PST)
Message-ID: <61952397.1c69fb81.db822.015c@mx.google.com>
Date:   Wed, 17 Nov 2021 07:45:27 -0800 (PST)
X-Google-Original-Date: Wed, 17 Nov 2021 15:45:27 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211117101457.890809587@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/577] 5.10.80-rc3 review
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

On Wed, 17 Nov 2021 11:16:12 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 577 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 10:11:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.80-rc3 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

