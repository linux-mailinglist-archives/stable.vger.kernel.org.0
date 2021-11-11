Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8BC44DA91
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 17:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhKKQki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 11:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhKKQkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 11:40:37 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AAFC061766;
        Thu, 11 Nov 2021 08:37:48 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id k4so6150401plx.8;
        Thu, 11 Nov 2021 08:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=oq2tN5WjvNVPk/P1cHs+WdAfx3WWEDptIZhF6fszdh0=;
        b=LdVE1l87UXg9bEaRDEZyltPxOIa+xGCYn+2Mh+0hviIzG5HubipASofnJ+mijG/2R+
         8KK9KE78lIqHR9NJSQeKD34WsHPh0G0Ann97JPfaaJVJQKPGcsCc7XVJyMcNPve03nr2
         ZdwZdYWLhX/GaeJLzqBlPwB65UiJuN6pLew2lD6DOMXjBRjJBVdrOX6yIwAhBKXllo5R
         OkUSgoBF+ifEG9a48xQfKxYCyy8n183ccWB0FOv8ZvaDKsZUroZ/GT4uvPU+2hOLSTKe
         iscs5lDmxEJ8XOhBEJKGnC1ouuOIqGm0WvNgdFkNtkTE1ExgeUgDVPSv/fAcowfZeYAz
         ZpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=oq2tN5WjvNVPk/P1cHs+WdAfx3WWEDptIZhF6fszdh0=;
        b=Y2ye+02MwSW1ltzMY8BJ5QP7+XLtZYTgDdUHBlAnSa2oCwy7nH3xdgF2DRUoRCbqtj
         +en6MaRZHDx9GSYawaXZppdAmPwSrGMd2IrOw4s/dh2YL/x+ndMW823QiAPRqea06Pq0
         vf98j7LhyMaJb/yoL7xwS5FM/saj2UdOfOqcH7u8xWo6PWcyn9JkISzYPPOpSD5R99JD
         7A6mcNFE09AcTrILQy+LFuiQ7cCGeN584dQCcQEmSDvIy31BrLYCqxnMi8Fd6m5y5dbF
         qqyUS16SRU09zrdp6GrZU57vPaPsjAFYVu0hSwCgUygqi25BMvl9wLDWDrRHGbF3FSjv
         6YFQ==
X-Gm-Message-State: AOAM530vt9O34Hi1VLmhVGPnxJyYfuya8v9vqWJn3U8B6VldxWSeWBE7
        q4pt16/FchpLQJT0UirQfP6BkxrASFY8bV5NvKI=
X-Google-Smtp-Source: ABdhPJzrphLKbfJ6bUx2QWlWUuts73Sxc9UnvWwhRyafK2YNSGbCHmLI0cvYVHalkp6CrtqzqB8VZg==
X-Received: by 2002:a17:902:b20b:b0:141:a92c:a958 with SMTP id t11-20020a170902b20b00b00141a92ca958mr461967plr.24.1636648667718;
        Thu, 11 Nov 2021 08:37:47 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id y28sm3638941pfa.208.2021.11.11.08.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 08:37:47 -0800 (PST)
Message-ID: <618d46db.1c69fb81.4f9fc.a0b1@mx.google.com>
Date:   Thu, 11 Nov 2021 08:37:47 -0800 (PST)
X-Google-Original-Date: Thu, 11 Nov 2021 16:37:46 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/26] 5.15.2-rc1 review
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

On Wed, 10 Nov 2021 19:43:59 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.2-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

