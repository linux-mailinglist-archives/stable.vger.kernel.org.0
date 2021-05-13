Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C01137FF26
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 22:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhEMUcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhEMUcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:32:50 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302E5C061574;
        Thu, 13 May 2021 13:31:40 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id ez19so73204qvb.3;
        Thu, 13 May 2021 13:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=50IoG46QAtEbh2O0EvnETKmp1fWPHFQZP7int7pwImM=;
        b=aO+1JfACYIpmkLQAxh6bARHzkp68v9AkD/Y9kIy9cAgjrvSNShtdn9eZjdNHzFMt8C
         e5Vl1l59nU1vdzHABEe8gqVVliChl2jO7B97003SYFOv4zndyafw8xQHomrmPsCWs7jp
         PMK8C57PfJ1KO0aiaF7AZsvfc1S6effT0wgTBBbBBBb5hWHcRaHVVlPBYQL1Z9bIv+SO
         s7t/Kx3BjDgrY7c2eeN6uiZOmpCjZT1VAmPR4L7kNoXbUAQkkQEK5IDwLErIKQ7+LPgg
         UuFYN0XswMkE9SJNIRejHRIEkKg8qSoyGFyrxR8pbLdwwK/Q8+lI844bPMT0ng5POwaA
         W+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=50IoG46QAtEbh2O0EvnETKmp1fWPHFQZP7int7pwImM=;
        b=gWbYEIyXCa/ILjEvrBWrPHcjW5Q0+Qpw+V1AUxvPMDZzFklGZJi1z0kstK51ea6jvw
         NCuE9HKxc+zwIchRL5ecHzo8Q64obQQgS8QXm0vOjlSLlT0QSs4O7Ob6ItnwjZlpWCcn
         KRrxONn4TfzirheHd95ARDy+s7KMMziwuSUTrmIZZtXrVEV+j+UrPt4dMlUwyqIIox+z
         c7Gi1rts2s/U9UTDHjTMhQDmFKFyknaCzm8lykIxOIrrGqVxXUe4v/+Bcyq/wDMCyO1l
         V4TeZxx8VSG24RwNWHZ2pOyjEIaup9fcYtFF26SYVJAaRfJz/YtxmhHIo1RSjk9rjXF/
         N/AQ==
X-Gm-Message-State: AOAM532C3RCx9Jkl15ZM/zDL8LuZGCcdy5yGncOmdymrxYmeHipT5OMO
        NkL2YxvEKww/4zNZrLrKSS0=
X-Google-Smtp-Source: ABdhPJx6NGidKMxMCGUBMFutO59ICuE8sJMs42E2tKeqLll3BtZE9AtsdH13/+rPCxRe1DO3yLRbhw==
X-Received: by 2002:a0c:9e4e:: with SMTP id z14mr35244033qve.31.1620937899446;
        Thu, 13 May 2021 13:31:39 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z30sm3205809qtm.11.2021.05.13.13.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 13:31:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 13 May 2021 13:31:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
Message-ID: <20210513203137.GA911952@roeck-us.net>
References: <20210512144743.039977287@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 04:46:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.119 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 156 fail: 1
Failed builds:
	arm:axm55xx_defconfig
Qemu test results:
	total: 428 pass: 427 fail: 1
Failed tests:
	mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs

Failures are as already reported.

Guenter
