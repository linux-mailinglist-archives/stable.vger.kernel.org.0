Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D40370385
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 00:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhD3WfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 18:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhD3WfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 18:35:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ADEC06174A;
        Fri, 30 Apr 2021 15:34:18 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r12so107460252ejr.5;
        Fri, 30 Apr 2021 15:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=hiUWyFqlJdRwXooAQ25d93+ugrINarVaEPoxy9k6sZY=;
        b=o7fI9649WOSdBxRzmWL6eg3WfbF3n4v3mV8DKNDEuOgbn2LNYMh8jT3MCubl/aiLPE
         UB9+0cI3iYDtmjY3LZpzqjLQTGuJ+d1j95ylNHI0ZihCSxdMFhQ4QnLnT7Gc0IHyOpRk
         YJBrYT6BPkYrIIx6qsiC3LvHTgn0gvFF2EwB6HtNlyZ3BPHQuMNFK1hvHfZ/y79DViiF
         MyLnX3SMWFZ7tcQs6oqKMOF/lQNHdrPvrfpPsvpPrH0gsnmXDUVmmM7DenhBux6GuBtz
         6iLe64YeIcoj2VpNVPrETMCnXHbH05a6+xKWkSFaVlFKRYRTmca9NW1eFW51vkt1dlet
         X7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=hiUWyFqlJdRwXooAQ25d93+ugrINarVaEPoxy9k6sZY=;
        b=EXHMMCAYkNKeZWXa0VNVfdk7Ztm4LRENoOykwqpAFS3WN/Sx1V5YKdasnjjqVt6LmF
         Qg4msn+Cm5FfmPe2dzPj3T1V9GzSzjnLRBc4yzwRNQlE/hfnXmvibOZYxpDS6u1cJmfn
         foxqa3b07Dn2pNHkrtr50fqlVvSlN8tiOzvPnFPkzzeIkj/N316v2cAAVwa1uVZk0nQq
         VcSrhGXAQHz476XW9KMvuTvul8D601iidH1dFjRB3o2/chlGwHpmLoeHMyr6i4rIeWnu
         3IjUl7ISoUXcXGvZifh6VeTUatv+BMdHTRLx3RC2VY6Cjwzuy4H7iR1nkY/hR2OsKbkH
         ecng==
X-Gm-Message-State: AOAM5328DMv8cSVxu3xCSHTxvCqq59fQHKTYMedZAtTEtrAisWzN+/YI
        uCU8xd+PQVaNagmQTaPa/bbdfbA/KgVJqp5aFeb51Q==
X-Google-Smtp-Source: ABdhPJzJNF/bw7xzI+qqPUxkrtLLVbS5pSocMcxmcTOA9wPJrBPgao08DYg5esNfCkl3LBWcwMegXA==
X-Received: by 2002:a17:906:7714:: with SMTP id q20mr6853170ejm.167.1619822056541;
        Fri, 30 Apr 2021 15:34:16 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g4sm2770343edq.0.2021.04.30.15.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 15:34:16 -0700 (PDT)
Message-ID: <608c85e8.1c69fb81.18a89.7996@mx.google.com>
Date:   Fri, 30 Apr 2021 15:34:16 -0700 (PDT)
X-Google-Original-Date: Fri, 30 Apr 2021 22:34:12 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210430141910.899518186@linuxfoundation.org>
Subject: RE: [PATCH 5.12 0/5] 5.12.1-rc1 review
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

On Fri, 30 Apr 2021 16:20:55 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.1-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

