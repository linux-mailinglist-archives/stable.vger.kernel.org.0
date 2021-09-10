Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B3D407397
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 00:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhIJWwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 18:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhIJWwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 18:52:18 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEF0C061574;
        Fri, 10 Sep 2021 15:51:04 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r2so3135570pgl.10;
        Fri, 10 Sep 2021 15:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=3mpqjN68QQFaPBGCnbSwv0HNK+T3hlBJN58L+ECUVr0=;
        b=AIHCKtGx6AnCmJWHYqbnECRPR8apQ7rwIO1IC7n7SD+bk8SYSW1tF4zP5LIYqqqU3k
         VWsxzSPsrRrboEBoXq3IGkZWWxuVj89m/BLVR5P3HVd6zswtqFUoTqvaf6YstwWRmAmD
         Hh2pWYPHsCYgKiDHnW9BPql5MjL8P/hsCAWDLjAN/xxo8TjREVNQpU4XiwQuP+86fjie
         pOLZDadxTF6sehqQjiffk/YtH6MW4sD5klcDqege6wbiA559phw4V45LiC0se5gCKD72
         ocv8Pdb59InxkiWnnV77W5OOWtfqVeY7oaB8GXw9OX+93S2GNQ4PQtSDXMWMlPJEbM7W
         QWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=3mpqjN68QQFaPBGCnbSwv0HNK+T3hlBJN58L+ECUVr0=;
        b=AsXqnVPgBwqbY54ekEiFV0Y6a2R1AcsTYuK93AZYxAqKibt9TT3uQpIzqukn0ny1t5
         L4UBkuYTaM+khcUaq0teGrkVarvsDU3phbdLNKLVajRQNsQFDL75/Mv2eRnCU51Mt+GM
         uxuuHtXI68x4XpSG3X96Ta0r0YSIavkXDOoI2AyPQ3jc956DsrNIhaA6dQhA0HGhFzvy
         ywxRwAOVvyE1ficnHMkCw1aA65xIC8IAobJ04SW0FCHLongKBY21o3YKv+pJnpSBg8Kc
         jhEulHrFYDyzkdqDnwz94c20pvR47WiCGkOGGtBKX/N8uTlkKZx0ZOa7QgSNRKU7y1EI
         GGyw==
X-Gm-Message-State: AOAM532rixcyKUsuJMJ36wZL+tRC698zH9ayu0vvT7nA8MTk1cE0nKeh
        uy5ybbOrv3pGkODisblpadSwCWv4jCqf/5CQkZg=
X-Google-Smtp-Source: ABdhPJxKaRf6KpYLjK3cs6GqM/vNcnZ38KzPV2AYnzurXdiok0wxY1oO6TNJSWgOCd86jUIB3pX+0A==
X-Received: by 2002:a63:4606:: with SMTP id t6mr42200pga.388.1631314262764;
        Fri, 10 Sep 2021 15:51:02 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id g4sm6147055pgs.42.2021.09.10.15.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 15:51:01 -0700 (PDT)
Message-ID: <613be155.1c69fb81.3bb88.364b@mx.google.com>
Date:   Fri, 10 Sep 2021 15:51:01 -0700 (PDT)
X-Google-Original-Date: Fri, 10 Sep 2021 22:50:54 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/26] 5.10.64-rc1 review
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

On Fri, 10 Sep 2021 14:30:04 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.64 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.64-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

