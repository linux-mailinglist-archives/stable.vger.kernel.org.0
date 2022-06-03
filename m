Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E3053D38F
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 00:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiFCWUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 18:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiFCWUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 18:20:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5C72F389;
        Fri,  3 Jun 2022 15:20:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a10so8312774pju.3;
        Fri, 03 Jun 2022 15:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=wzD5mA3Q7bnJEiZpaHczvVNh6Js6wc6fDQF182vrLro=;
        b=Nsjs1Icmc/tjIcQ+e1aOarscCNRccs/2GZCTJo0tFsBiHAXo7beRDcag+1UzbS406L
         VaBGZpqSqbOG+VqXlKn76vxfp04gP3IHT0gtAW04stLw/+lbG+gnV9jg1IerlUedl1h7
         IWb0xjd9KC2tukE00H7mPtveQS6wDKyvcn6PAPqhCO7lLM+bZlyN4LbFekNvPD4IQFrh
         THonzxol5WmMDc5ZCkGq/AfnrdCYyZyDOz9KcFWHzT3UGhrN9HHK84oGRceuVK7ahGrb
         /To1bhbULEQCLqLGRxv4/wCD5gN6Chz7SR+pu5e9NMtm48+yKFEBcEiFuIT2l9pMbnTS
         dlYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=wzD5mA3Q7bnJEiZpaHczvVNh6Js6wc6fDQF182vrLro=;
        b=OcAiI4+nt0Dq18XbwNoaVzE7+TkdmPqRhABqWXpv1CDAM1iuFd4xMVHYRgWLUGgUPT
         aSZkk1nSfVV33dX/5NKejI51HWUuSTqk0cb8J4PMqYQRmomdx4IcA83knDmiKRm/xVbp
         uvxP136l09tpLqjJw8ZOVwSsgMPGMZzseBByRNoOjZaDaHe1yaKrxfbVWLjU7P4EvpsM
         ug0CvMBwNYBnFMGSzQAZMfrJET/OkXxRnC0WUU9Cq5O3d3gOZ+KUsC4laONijgCSPVoy
         y8MCqS/WC3nNnzcF27AIifAhDypdDWemuxU/Yygka29Yhu57R1hv5qXVmAWH/+guSRt3
         oCjA==
X-Gm-Message-State: AOAM531P5sfm5Fb3TnI4DY6faAe23qn76aq56AhoW6TG7VopBXyUsCYT
        9goZfugcWwDKcMQhcKRYJPC/jK8ttfVF7X1NLF4=
X-Google-Smtp-Source: ABdhPJxzWKWAdOxfbomQhMo219/BEeIdNxSfsbzeiPXu1Gf2p700cYhBWtzf7MZZXhTm5Kesax+48w==
X-Received: by 2002:a17:90b:21d3:b0:1e3:2eee:3aba with SMTP id ll19-20020a17090b21d300b001e32eee3abamr13174205pjb.232.1654294809511;
        Fri, 03 Jun 2022 15:20:09 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id z12-20020a17090a8b8c00b001df666ebddesm8122696pjn.6.2022.06.03.15.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 15:20:09 -0700 (PDT)
Message-ID: <629a8919.1c69fb81.37ff2.42db@mx.google.com>
Date:   Fri, 03 Jun 2022 15:20:09 -0700 (PDT)
X-Google-Original-Date: Fri, 03 Jun 2022 22:20:07 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
Subject: RE: [PATCH 5.17 00/75] 5.17.13-rc1 review
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

On Fri,  3 Jun 2022 19:42:44 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.13 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.13-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

