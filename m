Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBC828BF0A
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404069AbgJLRaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 13:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404035AbgJLRaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 13:30:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF65C0613D1
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 10:30:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j7so4215667pgk.5
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 10:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=v0AdZGi06c/kzJZh24P4aQjE5ukb95Z+UwxoUfOR2Ew=;
        b=cSc82buz6ZIbkSefbi6BfmOz98OwL1erinhcTQt1QXmEIMFgOA1Xz7ou0DQv1dItNC
         g/ZSGgsMGQZz8XwLjJHyeVFWcd5yd1qtV/eUIzQaGoowT7B1XzK8D1B4gycRaGEb3Nu+
         auMXYu8jYfwvIDBE1chpSBVG/6YBfx1W1fs0T6BYtUE767dBI6LPhp9RI5DTAroEgl4g
         nQM57UZ9udRM5iLxZcqrr8jdr1DRhnfjwuKZadaK35nXF/usP+IiLGIjPIXaQzW+M92O
         Cww6QucMNT/9l8wm+A3yG/IvdOtaGktoi1ioUiGjaqCS5QzOf49B28RN5OBGVySOMDNs
         VzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=v0AdZGi06c/kzJZh24P4aQjE5ukb95Z+UwxoUfOR2Ew=;
        b=l2XD0B6ONdtHRbsjQYiX+vlFoFt77iih+vn/OpRLEBMPkC17eHvRH+1YJkLbHdcBjP
         3fQ0YcWa2EidXQO4bpysjpl4M+tPzf/GXtPb6sXO7tfr2b8s4t4ez8HK+3sNvx9aIbN0
         bj/iGdGOs8Ay7SZGiD73p7lWVSyviGgcQ//NQevmpXBoP9WBP08LcerL0PuNpvUmTLbx
         anDsHNUxbsAVSz45EiaFcDctzxNx+GjGZzjqBiWpz0qv+1cskzVKjv0OwEFr1CQx8CfA
         RgSsMEWGNHpPmUcsFYjJyycgwr+ZxgFmopKpBr1B7tDcIKMs6zn9FyT4ZkHFeBFjjUds
         E6yg==
X-Gm-Message-State: AOAM531uJ1JFmQkI541PYUIawKDXVsta94llnhdvgVy3LxjlNRZO6bDX
        arR8XyZJSTUfTD+WVhPu0PpPqQ==
X-Google-Smtp-Source: ABdhPJyMem7/qg898mhmnsaOKJcNew0PRi+PS0RDVSgwFcdVEY5RS5Wbf3saVrpenW1mNQgTctAS9g==
X-Received: by 2002:a63:1e0c:: with SMTP id e12mr14309950pge.386.1602523818705;
        Mon, 12 Oct 2020 10:30:18 -0700 (PDT)
Received: from debian ([122.174.176.57])
        by smtp.gmail.com with ESMTPSA id g9sm19739568pgm.79.2020.10.12.10.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 10:30:17 -0700 (PDT)
Message-ID: <d31bda1df5cc75e3217d88eece08dcc2c3c29531.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Date:   Mon, 12 Oct 2020 23:00:07 +0530
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 * On Mon, 2020-10-12 at 15:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.15 release.
> There are 124 patches in this series, all will be posted as a
> response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

hello,

Compiled and booted 5.8.15-rc1+ .  No typical dmesg regression.
I also  have something to mention here. I saw  a warning related in
several  kernels which looks like the following...

"MDS CPU bug present and SMT on, data leak possible"

But now in 5.8.15-rc1+ , that warning disappeared.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology

