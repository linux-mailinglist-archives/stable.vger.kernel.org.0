Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2F253D952
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 05:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbiFEDDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 23:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiFEDDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 23:03:24 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60167393EA;
        Sat,  4 Jun 2022 20:03:21 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b17so5615386ilh.6;
        Sat, 04 Jun 2022 20:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QW2mNsv+N8owCdPUNlE7uQX4EDUVw57AHy4UPadNzOE=;
        b=eO2E+ixJYPTyfg0G3tkTGS885Ngol6i2AJRBJi84MUbUD8HEtYzF/HpSl9IyMj5QZk
         Sq5IGZmFKdYo77+WDCeRwZY3tUF5pHfIGjUr+8am9fZwquvErOMcj0BLhnz1UNyIKxm/
         50cv9GseKkH1/BosnmZJbMoEIgSFd45U25aXJewSDEvgcZXOU93i9KAKxbY8aQzTscD4
         WB1S8LRtjdKd1K6sz3IQ+DPmSfa+QrWVmW4VmVT1X+Qewsu4C6uAmLHNmlQ8mYbHM+Sn
         /DjbaLZ6O6IPVjXO6W7nTWsfJjs7+yAtO2GareMXY6R/b9fTcqlOgQIKyhzJZbfYzzjh
         ozXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QW2mNsv+N8owCdPUNlE7uQX4EDUVw57AHy4UPadNzOE=;
        b=sldKMUEruKovvy8CtIkF/DcGLPUTYe1ewK4gIUyGmffWDsJyAH9wQkCU6axGqFvFIa
         2o00FqlqmTRxnlbUv878Dbek5XLGFK8OL3hMDrGnk6MulFaShJk3pByMoHeenDE+pgpb
         PqFnKnPQrsGW2ztI0C0V3V6bWkSSw0rhuFmtF/dHbf8bGc22lDNNJQ8Xt3rn5tmt237K
         0/0dXTCTN89/kbaiWvORZNZE7CY3osVDg8hAK56m+bhyfEN2fiM2a3LfQ5p2hj9Ae01D
         a004jz/xERjA08Cx+p7aLsECR7WWOF+7+g0wB+JhoUOlTakerb6pO4QgqiKAwwBX5mNT
         vopw==
X-Gm-Message-State: AOAM530awkN4czKFIGxMcjPad2KmjXYqrc6MGt0KJZL4IKNiprXQk1Pu
        M62JJ6DjQDbVGCrYUDQpCDLa2SAYKTBRLO0ZZO8=
X-Google-Smtp-Source: ABdhPJy0is8aeCRAAON5p7AE+1eUq9z4Wiwcvr1Q3byfQpyTir1nczSsHbuqMDbEWgZLMEFwX7CwxA==
X-Received: by 2002:a92:ddc7:0:b0:2c2:91f5:146b with SMTP id d7-20020a92ddc7000000b002c291f5146bmr10373121ilr.21.1654398200330;
        Sat, 04 Jun 2022 20:03:20 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g10-20020a02a08a000000b0032e7456da06sm4297417jah.15.2022.06.04.20.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 20:03:19 -0700 (PDT)
Message-ID: <629c1cf7.1c69fb81.911b8.9ef7@mx.google.com>
Date:   Sat, 04 Jun 2022 20:03:19 -0700 (PDT)
X-Google-Original-Date: Sun, 05 Jun 2022 03:03:18 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/53] 5.10.120-rc1 review
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

On Fri,  3 Jun 2022 19:42:45 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.120 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.120-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

