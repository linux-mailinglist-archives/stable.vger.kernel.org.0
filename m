Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FFA46BDF3
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 15:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhLGOn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 09:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhLGOn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 09:43:27 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE059C061574;
        Tue,  7 Dec 2021 06:39:56 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b11so9555168pld.12;
        Tue, 07 Dec 2021 06:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=4ZD9jvAWryKoCDhRlJjTTJNDzeOrDOzgwmEgfWSVlMA=;
        b=j5DS3xod9H+UBY6zDCURkRjwJE9ucGh7gApKC07+AOOvMVuo0RKUWTkEKE7atT4bKw
         iUPUdr+4BVFgy4YVdW/0YduliiX/ZsxdDGfUanC78xSRF4PEvuKqFDZfaH1cCxA+EEdb
         z3Ys3EWBD9ZV8OJ3J95jqg3OZGZCL5RLeT+KRoTuqAa5l0VvGFiO/CcKnIm2VjfhSSTQ
         r/5Pwbu2NYydDD6Rg25WKLbr73NYzKNnJqQG2byhJCsFOA7hxjKgTN0z9onv56sNZVXI
         HCNkB0YVh5IQmquiZTOjOif/1rP8Ay0pXdLq+nEa5tBL/eQrQDA4x36aJr7zs3gBV8rv
         Wlfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=4ZD9jvAWryKoCDhRlJjTTJNDzeOrDOzgwmEgfWSVlMA=;
        b=FsvXLTmGJRSf5chGJGkO8T0x2RP7YVs01eJVcrrXGicrueeN7HtEV/iR4C+Hdvy+b2
         WWAbVHg4ti053xzuI3YFEfQ16P2PLUSOWkeNDHwGRZzJ/pYVbR2ynBT8C0JaHBqHI7f2
         /aiG0TU8gwapK9nMgP2xkIf1ISrln0JAtZ3TOU28LGoviSGywjPIMVAWvOnCmxCVEK0r
         rhOLB1MbQrAzarLKF3TXXNBUXSDSoFkRwNymJx4qZTvTLHJUO/jad3w3qdufG+3sxsBQ
         67osQhIop4ut3uMdvVQaWZKpZke6H4zYX7QmNKNWyouBEQWMg8w5fPjpU0mCZXpSBUdK
         GyfQ==
X-Gm-Message-State: AOAM530rwJloLJdjWqwbREbCk5X/ltB+OZSomVfy04ukV6d3R1fHAT9j
        Nmi91OZUGjSTRBXd68GF5wgzWC7nVIAEL44rfxw=
X-Google-Smtp-Source: ABdhPJw9fI8FspfAq/rgnF9M3X4cwNNUF80TC1to3X3WAkart3j3wpaNIfZA9mrxQvPOp1BKrbPutQ==
X-Received: by 2002:a17:902:eec5:b0:143:982a:85c with SMTP id h5-20020a170902eec500b00143982a085cmr51210818plb.66.1638887995642;
        Tue, 07 Dec 2021 06:39:55 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id o16sm17883135pfu.72.2021.12.07.06.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:39:54 -0800 (PST)
Message-ID: <61af723a.1c69fb81.c28ee.25f8@mx.google.com>
Date:   Tue, 07 Dec 2021 06:39:54 -0800 (PST)
X-Google-Original-Date: Tue, 07 Dec 2021 14:39:53 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211207081114.760201765@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/125] 5.10.84-rc2 review
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

On Tue,  7 Dec 2021 09:18:22 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Dec 2021 08:09:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.84-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

