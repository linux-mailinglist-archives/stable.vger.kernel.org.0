Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9059E386C57
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 23:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240729AbhEQVgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 17:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbhEQVgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 17:36:47 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6329DC061573;
        Mon, 17 May 2021 14:35:30 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t4so3908817plc.6;
        Mon, 17 May 2021 14:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=attsytHbipYOgWpcPcHpCKVvuqA3N68XPfEcSSoxPl4=;
        b=iD4SGUZBwMZn+yiNQThfZPnDo/oWRoyVWa/mOrYLbx6DkDNhae0qy28018ofSx6CLH
         XVur7zjLaQUgql8lZYMaPAAeCqAiJwRCqHWP+xn83pnXJ8/M5ih3u24gsxUjnrA0VSpp
         oJpnhusNH/V51CsqE/DScakTZl3Xc5pVS0f+WCJbtWySDRsPyStR2gAyy/f0C9RapEeU
         rO9Q9yCKKQQJCsYMp9OBxuSsjZ5L1nA2GaEUWhcLVZue4g+EGRqY4QCgN+X3lmj97Nll
         U2hDzobCbEGVHYkAPMhdejgyT9WYyY3JPzR3u6IAwgHYqNgDAV7Y4Sei7TP53gWpsb4/
         mO7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=attsytHbipYOgWpcPcHpCKVvuqA3N68XPfEcSSoxPl4=;
        b=kSIgLal0m8II8AhyQPm9PR/yEYkTJg5Xm15RucrlypNRyWFg/VBu6o+/lPwfASIB6D
         Umg4NmUKMQUNF8GvQfirkwp0ll1umLViDuWZYsUtK8qVXIFTn4/dHG1VyYY4M0tMrAmu
         mtXBtMBM/anbi3vQpeaZWom9hjW9mOZin/GzP5dQjNGWwF+6KugTM87DaQCczuz3Pg9F
         kZ1t0nUKG0UHKdEK3i31zAB+zI/qA1jSGe569nw2a1BGjxX1LSnkeSycggsxu6WxPVmT
         X8m+bqeBXUhO8Ey+oJj8hoEcZP07MZ5+jBNiTnmfgYieSHKEovQUQ6ERKJ476qWo6urS
         IjnA==
X-Gm-Message-State: AOAM532F3XZ0TggCc32sIcPM8fjyJhO0JAA3oF5NvqSkH00tVHxxxFm/
        K3t2g3jjGWpF5lsZM060vJluKqiOm4DUt8X1hkA=
X-Google-Smtp-Source: ABdhPJwee59COR8BdsR2cusX9UMgl3OqHaZG/atIfTb4g+UFP73ptSdjhXjC8Ewe2BJXHJyDd4yYJA==
X-Received: by 2002:a17:90a:e7c2:: with SMTP id kb2mr1541458pjb.193.1621287329445;
        Mon, 17 May 2021 14:35:29 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id u12sm10293593pfh.122.2021.05.17.14.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 14:35:28 -0700 (PDT)
Message-ID: <60a2e1a0.1c69fb81.8df1.388f@mx.google.com>
Date:   Mon, 17 May 2021 14:35:28 -0700 (PDT)
X-Google-Original-Date: Mon, 17 May 2021 21:35:27 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/363] 5.12.5-rc1 review
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

On Mon, 17 May 2021 15:57:46 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.5-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

