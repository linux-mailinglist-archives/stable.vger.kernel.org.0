Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1048551D
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 15:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbiAEOzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 09:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241148AbiAEOzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 09:55:06 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DFCC061761;
        Wed,  5 Jan 2022 06:55:04 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id h21so54492302ljh.3;
        Wed, 05 Jan 2022 06:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=vF2Ur+gJNu/g/h2RseWON+i1azy8tz5Gjqu/58crw4w=;
        b=P0cw6CmbJdzTwWCdut97utaRg06tOvItHw6xqjzQ3HGRhnDwZzoyBAmuXmp56V62LF
         8kj+MQEWBXvm/Q1YQRXs47h0DSPpkt2HoQUKfFrTWxmRNMpAvbJ95L9zZwJon9HPkeT+
         g7s0mhhP4QFYPIUAXc6+JOT8XlzN+2wyReaRUdjwbfxK5Osk3AHjE1L8f80fy+6sxXPJ
         LETFnJG9FAJWbZqAiuWd70EDYrfBQuGSNIjrJEC+YAdqhjiZAH2FRZjMgCpu8GxSdxzL
         didWz7/dnGA1jznQlGT7/c/FLak96tBBPX1UWqeBThEfsxRtUqXYqQ9Lq8pGpmRYasBT
         SBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=vF2Ur+gJNu/g/h2RseWON+i1azy8tz5Gjqu/58crw4w=;
        b=dSFjQWnHexJIdbXrVNG2mKhi1AR1Etvbk/95aqvd0Tv0n18NKxhzf04W+9GsVNoBFl
         NZ9QaI3spR8U8UP7Cixc0IskDcOhebIBKTVNxO2vfftJANAwPN0MclSeyybnihwrTf0r
         +RODazyquZ3fWKE6B+X5zaxw7OK/5su+p2AQf7Sg2TcIqQuWzII4IE5NxC+Rnb02Yxy8
         tUf1fr4XRcaPkyaRuP/BTBXnJm97fwrWiJBOA0louE+C8XuWgtxxo/CWyckWNXs/huLl
         qEDGhlNE8KBjqoBcdWKqKJxyH9vLsqmAjD8SDxD++pOgVDRkrb2TxmhcPFg9sODwQxRe
         C7bg==
X-Gm-Message-State: AOAM532TJLQqpqO//fdJcG2CRWdmvCGut+yrg4UEK9aF7QYqa09lCSz3
        2ZV6XcNqSFTXao8mCD3Rs69thg1ggM5UQhsS7UQ=
X-Google-Smtp-Source: ABdhPJzQn1H73Hr4Vda1J1Ie/6CORlmqbP+9PQdb9ui/o6nqqAKqOhR7RcMLD2m23LtgKeDe5PLlgg==
X-Received: by 2002:a2e:bc17:: with SMTP id b23mr32262436ljf.365.1641394502333;
        Wed, 05 Jan 2022 06:55:02 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 194sm3124128ljj.60.2022.01.05.06.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 06:55:01 -0800 (PST)
Message-ID: <61d5b145.1c69fb81.40afb.07d4@mx.google.com>
Date:   Wed, 05 Jan 2022 06:55:01 -0800 (PST)
X-Google-Original-Date: Wed, 05 Jan 2022 14:54:57 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220104073845.629257314@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/72] 5.15.13-rc2 review
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

On Tue,  4 Jan 2022 08:41:12 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.13-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

