Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1B73FDE0D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 16:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhIAOxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 10:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhIAOxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 10:53:21 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECE8C061575;
        Wed,  1 Sep 2021 07:52:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so2243722pjq.1;
        Wed, 01 Sep 2021 07:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=0+XXJhScY19oZMVL+l3pgoV6l2jBpGbQQo6LlQzT0QY=;
        b=TP99TCI6DWcwaxgbCBfc+z2SnIx3udQtYhQ3pWiGQx7mZIm4U8VGUquiZmE3WCEzUd
         /ftTtcSrCidWfw8/CHsPh5hH1ZUwuTELcI3gy2s+z1yB606Dcp5UFhnQg8ZYOkXvp4KL
         FBIGnBB8qj9wzdU+hA/zjzVcJoLjO2a+TbGJ0zTXyy1lEvlTM2hS7C6XL9EIo3sDhabJ
         2r2o0wGg9RTnoirXzomYQVLcXDLfMOt3lrbXHGVXPyXblTvW6C+LjMtuMiv3FbQSyjJC
         63bJx7BeeIxb3KiRkgh7gTDD7ec2GTeXSSXeQYZHGDWs4dzP+OpB+eG0BYe2NeZZJIKo
         uJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=0+XXJhScY19oZMVL+l3pgoV6l2jBpGbQQo6LlQzT0QY=;
        b=pu6yDPyiZF1Dib63tpKsgjNOrIoJp+ibjonpUCFJhBIEglW+tv3XqzWV6UJxWsBxMX
         dvIgxbwZB+AxC02AhVAUQppkxejYO9N6CEAKkAzKm7ljh1/W6zU49db1TGx4ofzJDw3D
         vwkNUB/czwImA6cYmuP+MYKV2Wn2C6xGgEE4yRViixB8hxwwIouqBL8Lde1V0G9gx4bc
         ohVC/U+NB3UGDaVS4gYnY1oRDjFs6a/v0YdHkcQB3AMLYco+4v66MJ7mohMyTp0raJW7
         xJMQHTACHm0WwpDknoHRb6O1MXfHqTwwdgXegeW2SuJf9iLPpejqsyGIxcV8otOo7kxQ
         NLxQ==
X-Gm-Message-State: AOAM532E7Famq/p/3N0zvVboSZWKtCLPqaVc9IoleOG8X0jvLv22aCwr
        RtbqtXJYSeYVUZZm1lxj2pvqFDzQ12q7Qckmg7E=
X-Google-Smtp-Source: ABdhPJzkc4SJOT1RNawGQpaq3B6e/jDBE9m4cDNZZ0yAAVI6rcjOpDsdqV7mSNj88bVMKsIFwb7dtQ==
X-Received: by 2002:a17:902:7892:b0:133:a1a4:5917 with SMTP id q18-20020a170902789200b00133a1a45917mr10153701pll.17.1630507943378;
        Wed, 01 Sep 2021 07:52:23 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id x16sm18933pgc.49.2021.09.01.07.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 07:52:22 -0700 (PDT)
Message-ID: <612f93a6.1c69fb81.e57fc.00eb@mx.google.com>
Date:   Wed, 01 Sep 2021 07:52:22 -0700 (PDT)
X-Google-Original-Date: Wed, 01 Sep 2021 14:52:16 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/113] 5.13.14-rc1 review
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

On Wed,  1 Sep 2021 14:27:15 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.14 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.14-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

