Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC283DDF3B
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 20:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhHBSdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 14:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhHBSdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 14:33:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98060C06175F;
        Mon,  2 Aug 2021 11:33:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e5so20650860pld.6;
        Mon, 02 Aug 2021 11:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=cAw1tkEZIaQf1XKZ8ZPskjieinW7Gn80BrRVSD7BNas=;
        b=S+48NUj9VUSfdTSXV2SBVdE2evl7BpXBpxsd9r5nul/lUWhs4EDL4+CxAWlXfdUwxX
         /eQnbltedNzWe6BZ5ASq32HVmVOB+1yx0BzQRY//ZBrkr1lwbq2AdyS7ESm4P8mO9MkR
         fTaqSngn3c2VLngq/HCwvVLbCyue1q0iG4Sy7ZJSWSnwEskHWPrssGJJzuot4AFxHMlJ
         vvg3kcdLTQDtVlHE0lkElSGSo8E0AoXiC+p2T58rB+YSsHIGk++4yUH7/ugOAtVOwomZ
         aji4cRTp9gF+QtiDdffkhzUq8BmUCTwIZ8sYeVJsCH84/rRWRqJhfTNwifF1jhZGXs1Q
         JoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=cAw1tkEZIaQf1XKZ8ZPskjieinW7Gn80BrRVSD7BNas=;
        b=hAVechauOxm2A3yynQJtzGcIfO4AXpEawpRYaifirSmaFNhUGvoD6TK8Yolj7Drt11
         ylEc13tSBVzjtPHJI05xdg/fWm9A2l4aT1mmRoA9GS9OVeuKDxYZ8DRwJXJHg06h8GO9
         ZaErwEju4R/UGi8vGN08f14vFwQPzW5IuxO4xZCDjCGmA2pV0td80tU28huOpezSu32N
         uRRv4gFYVyu57v4No2sF1wS/KxQQ6oICfA1H+bXpNb8Z+wRRs9MMC/yw2UQznJ+Fus4i
         0d6sN9Pab55SJX1ebXSGp0RvqUIh+d3HqjD776OHzmDRzJDpPYboyfzQR2SACsNXR8k4
         /1ZA==
X-Gm-Message-State: AOAM531nK/EEtVR+1asDerr4BKxgoVKrDp5OGE8lwJiYIH/ZlZj3DiQr
        O7o4ruwCO5BK6FZUifbfaXg6mhFPN4//iMzv8FM=
X-Google-Smtp-Source: ABdhPJxPnWZuK/p/IvVOkS9G8OZF1gvzoiNav4Ophp8X3FibKYJfyLIHHM4/m6NFmLmIVSZcLZ4Aaw==
X-Received: by 2002:aa7:848e:0:b029:333:4742:edb3 with SMTP id u14-20020aa7848e0000b02903334742edb3mr17700750pfn.12.1627929220705;
        Mon, 02 Aug 2021 11:33:40 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id z8sm439106pfa.113.2021.08.02.11.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:33:40 -0700 (PDT)
Message-ID: <61083a84.1c69fb81.38f1e.1cb1@mx.google.com>
Date:   Mon, 02 Aug 2021 11:33:40 -0700 (PDT)
X-Google-Original-Date: Mon, 02 Aug 2021 18:33:38 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/104] 5.13.8-rc1 review
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

On Mon,  2 Aug 2021 15:43:57 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.8 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.8-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

