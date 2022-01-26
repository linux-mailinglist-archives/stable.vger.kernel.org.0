Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F6D49CD5C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 16:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbiAZPLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 10:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiAZPLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 10:11:38 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7FFC06161C;
        Wed, 26 Jan 2022 07:11:37 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q75so21328455pgq.5;
        Wed, 26 Jan 2022 07:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=thMjl4FNBNimyskghxkkuOCOamGzfZq4PykTR1OXXZk=;
        b=ORI7uLWx05MzyDbi5JhFB4IE+cM5RGLTsi7bcWTlxdm2LDkrVyJW/wjco9ZUZJpn2l
         KRl/dK7i5VBkbx7UvIJM/v97UfktjzJxOAd27kvmbzvFL/EZiIal8IVH0WS5Z09nUN29
         S78xmXeejcWt7/qYMEL18F/kj35hR1MVziyXN/IL2XoaOBo4bwSHJqJiSLJCZgGL1nn4
         bJBmH1vk5e4WY0EvHeAgmRgAphEhgXtPxMn4K1VJ5nEDGzGK+7A7x7Q2Jk3DPg6fmKtw
         hm4bpfFAMyXBRVp0BSa71KZPx2o+S6S8HqYsGekf8EcjxLNEvBuVqF3SVXqrjJZQgr8p
         Nv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=thMjl4FNBNimyskghxkkuOCOamGzfZq4PykTR1OXXZk=;
        b=j2+pUbaeEdNrjw66KJMVrBKaQ1b7JMA6eT+x4OBdNDzX8QmTVgZ507fKENBHER1/cP
         VkqwTMJMHvqGwIUvIw4ZEoUG5JL4Lqg55kaxTyPHOxlquayhUN9kNzARwpgvb2v50uyt
         TXCwi8kDsWAzbz0BArZl1i/GiaNsmKHyZHdoFG7l7WM7PTRbIjcp2N+KJCUyd+IGtV2U
         XiWxyool7azpKKY8Ru4DP5oUJ15XF1LCFVU5ZMvB8G9EKlpzDOxs7IVI37Wuuqf2TYnq
         vDWIq64SYO5AdRvniZSTJg65UztR/QYpnhbF1lLZYezrPipLJp+PsGecwgl57yRIyEER
         DgyA==
X-Gm-Message-State: AOAM531IdN0R9qiNbEMR9eQUkx3eLIBcSo9CrOsEB3TjW9bkqo7l7slp
        y8ijbI7ZN3MycTAUXGAuMhy0/kDJWS/Zf0gInyo=
X-Google-Smtp-Source: ABdhPJwP8FOD22IqFY+/RdwjaUR2K7yT+gVpJMm4sG0Ov9mHFzBm5b/z0prAPOjVWsB4+axwr153sg==
X-Received: by 2002:a05:6a00:16c7:b0:4a4:edfe:4625 with SMTP id l7-20020a056a0016c700b004a4edfe4625mr23167669pfc.58.1643209896866;
        Wed, 26 Jan 2022 07:11:36 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id o11sm17573593pgj.33.2022.01.26.07.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 07:11:36 -0800 (PST)
Message-ID: <61f164a8.1c69fb81.3f09f.1502@mx.google.com>
Date:   Wed, 26 Jan 2022 07:11:36 -0800 (PST)
X-Google-Original-Date: Wed, 26 Jan 2022 15:11:34 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220125155348.141138434@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/560] 5.10.94-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:32:31 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 560 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.94-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

