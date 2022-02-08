Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CE94AE3C2
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 23:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386343AbiBHWX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 17:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386466AbiBHUg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 15:36:56 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472CDC0613CB;
        Tue,  8 Feb 2022 12:36:56 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so169733pjb.1;
        Tue, 08 Feb 2022 12:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xeyhe9pInui/Mmw1ol2pyh/uR5BpYVyzJYI1oiXg1WY=;
        b=Y9XA+T/riyUHpvQLnQGw/qm+72MJeFpJm/HAncuFyV7c8/OCT/5+XXcg9I8bDShxyn
         BixYfPfH+zliCgwOmlk0HsxGftR0f5UzRSCm6zboHzQwRc0IQ/xdqtD3pEpZwOXaX1wP
         qr0BiMk5L5uDU/BWHDb+APvfgk9iLmpGz203hm6+dp2ZRV2ysIH/y6Xu/1J30auHDW7s
         ISbwx7SVNGaE1ThLXD8bDDsqJrQH5q3xCM4ef0JXggsOfBr2EpErllSs6Gdu1+GGe/0N
         YivIRIDpgWw2Im6lEuN3z4N15xf4xmTU8kfpgdEWHCo7ThxIWq2Rtm3wrAz/DHXBPLiJ
         zQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xeyhe9pInui/Mmw1ol2pyh/uR5BpYVyzJYI1oiXg1WY=;
        b=lTGne2OQfMK4/ol/avyjWo80ESCaoPwAip/XzSVAi/RzQdhixnFXT3ByJtuZ7OIdVb
         4ZOKO06qTfKjZnmpAu81DsD2z6c23BiRdzQioquiNsi223FOEZ2G2q+VHTW116YRNP7v
         bKCdUjW+TNE5Q4JSy4eV8sPfPQ6+uQiT4rYmXZ7NT2NHvfCHxi7t7n9LF19oTxReKJIU
         mKqYP32CQN5r/zw9BiIL8aJJno5UiT45MrUGMSctayH2jFOPZ2SD/O6Al8QtFbfHVRgu
         1En69yqU3zNcqplmyTrFmrUohs9hAhBEnZq8vctBCZvxBpfqXjOrMWSliETmqKdA+p4X
         ftUA==
X-Gm-Message-State: AOAM532qcAkzIpXYuQeTXVKpJfnqbclBiznEBJtDb7Az3KW6GA/Zx8W6
        nvsqYdxIdapv6m79NAnTfcHXj/Iu8iBB4dS2UIMsMQ==
X-Google-Smtp-Source: ABdhPJzcVrWIXwOzcvjHsPmxVzf5MPfVFZ2DhOIiCh0tPe0Fs27W1qv14d39RTc7cZmZ8ZvJIVV/1Q==
X-Received: by 2002:a17:902:694c:: with SMTP id k12mr6491550plt.98.1644352615151;
        Tue, 08 Feb 2022 12:36:55 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id t11sm12939746pgi.90.2022.02.08.12.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 12:36:54 -0800 (PST)
Message-ID: <6202d466.1c69fb81.e678c.15d6@mx.google.com>
Date:   Tue, 08 Feb 2022 12:36:54 -0800 (PST)
X-Google-Original-Date: Tue, 08 Feb 2022 20:36:47 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/74] 5.10.99-rc1 review
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

On Mon,  7 Feb 2022 12:05:58 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.99 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.99-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.99-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

