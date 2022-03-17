Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272E44DCBF4
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 18:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiCQRCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 13:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236753AbiCQRCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 13:02:52 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0919185478;
        Thu, 17 Mar 2022 10:01:35 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id w7so6599441ioj.5;
        Thu, 17 Mar 2022 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=3kzF5Qdw46iyXZ9frjcDC47kp/SMgp29DoE26T8TYjU=;
        b=Qs8R0ZGhWxVm3ATuVwVWFz+M7xWqffAKkYSoLeMtcd94kdR09xoc++aEuid3GMPOIs
         Yv/icJmwoLNZpKr2hFx4vK3pZIqckoHno+X4tS6jes027VzlXkLfYJeDXTFP1TcNVbir
         Ghzj+i0b2Efr1QxgHcVWrOnLejHExlx8hvplqdW6CpcxToonF2eWOZAyK300NmAG+tw5
         NPSG8IevPVAtBk3IG4YS7CoMB54gtTVRQuyVfTWG5madbbWHmkcPefIXVUu/SWHg3jfw
         hR3hi9A/a285QhV/Tq6dl6HaERgwYfgux4WStaL2iqpoYNI7//bQpFs5ep2cu4ifidtm
         xTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=3kzF5Qdw46iyXZ9frjcDC47kp/SMgp29DoE26T8TYjU=;
        b=LkLjH7iFEErddc1lJkedoej5GtbZhGRRCz1EVlETyO/L3LbVNr7ZqcBlYpjkqP656o
         G/W3MAZueoW6GXM+rtVF7NiTJXC1SF8lJNLrqr7ZkoZKc0nNHT5RQwQxxDudFI6Jd436
         mCAAgVqA9pJj5wI0W+joqD7xnd6G1cnYV895GZbGOXZ2/qXGTs0GM9Tkcy5oSEG7mnbI
         TAuovKzGz59ajw8jqSjMG0/wpCI9NkgXb1oMzBgpJ4wLbrnyFLh9dexn7S3hYst0K6l1
         G1Wb6v1zm+oUEf0Aq8FltwNCvBiXYmBLLUDvuRuShiTnU52vYkEjRgZup/uzv0BsB7Do
         fDlA==
X-Gm-Message-State: AOAM532xIPE36ESvzQBbUBG6O1JEU4TnqiI5VKMBWB95tp8Y1YY7URly
        dEs2YqqLBjLh//2AVRawTGul1uswZFIhHXITkGU41g==
X-Google-Smtp-Source: ABdhPJzhya1quRNSVzMTQDypQTJIYI+Dy17itcK8vVMiNQ7C4+PBTvcNW4S68axS0zxSDR8smvdmxQ==
X-Received: by 2002:a5e:9618:0:b0:645:ba5f:c1b2 with SMTP id a24-20020a5e9618000000b00645ba5fc1b2mr2792855ioq.64.1647536494584;
        Thu, 17 Mar 2022 10:01:34 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id k2-20020a056e02156200b002c7881bf27asm3575506ilu.27.2022.03.17.10.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 10:01:33 -0700 (PDT)
Message-ID: <6233696d.1c69fb81.6ea81.ff5c@mx.google.com>
Date:   Thu, 17 Mar 2022 10:01:33 -0700 (PDT)
X-Google-Original-Date: Thu, 17 Mar 2022 17:01:32 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
Subject: RE: [PATCH 5.16 00/28] 5.16.16-rc1 review
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

On Thu, 17 Mar 2022 13:45:51 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.16-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

