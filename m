Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BB83794DE
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 19:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhEJRCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 13:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbhEJRBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 13:01:23 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5DAC06138C;
        Mon, 10 May 2021 09:59:53 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so10432921pjy.3;
        Mon, 10 May 2021 09:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=NWytwvpuLWzV9HVQrhdljev4Gwim1gcczRTeJN1g2EY=;
        b=FUIrLiM74VTIaaNi1qJUfWnCmMnVZYmko1Mm4MK891XZzCVmglLdO7QS0IrEavdvB7
         2mwN4o2UR0Z7PG/GX0F1rFaKWHGNgkDbnywhpI7qbPL5Qi+JzK5VV/MBe7E/A+UJvF9q
         FOPTf5CkFmeUP2i0TfwZlxRNXU/sccqU0BAOinTZvl7XiLLhXe5VqHjIUFnQO8wiw9QN
         N3r40Yvq6yv1A+QpYeifux7R/A+BRmJd+YyZJbNCE8Xm8RGABJF0sSDP9vGtVONga28f
         BXeCL8CIOFqeQfX6o7fGMyYIevLW0s3sd+oS1cBXnbpUUJd2C7BdAqOCTFLCpkVKqK6E
         Bz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=NWytwvpuLWzV9HVQrhdljev4Gwim1gcczRTeJN1g2EY=;
        b=WbZMbe9cnd03LE4I4x2udQ7UEa4Zy1/A3hixCq1WThTk5HhAa8V6bKUj9QSqItu1kt
         ksL4Jldi0yzA1khyFwsUsNRo2JW64UDNzmloMGNTLmmIy2zoLtp/6D+7hT/ZUWtpsk6d
         2M977D91NtA5eBzKGqjrsFlvcYWmaOuJaIbxYRNINyP4Wp5kbRFYmCT9LLwBWjvGh8C+
         ZtCWtA5RY1KizBHyJftjOb5YK3gozI9DLAaVQ51TvauuwWGwEilhwNe02GMiBZBUElex
         4nr6aU50PIFqoxiKq3pqex4tAkUYUmwh+6Pa3KmR3T1+l52BYJyT6Cu3yQm/VrP0L/Wk
         xG9w==
X-Gm-Message-State: AOAM531KrrStvg8e4yLN56qPnqIv/0qhbxj9LMGCt98UVCZ/ypBKjGif
        LorOn+B+aVf0EWif5Djp8vXgWHAgsQvPRZcaFMpHCg==
X-Google-Smtp-Source: ABdhPJyD6CZI/Hc87OKWakDAQ+Li0u8HCi9AuQRtbLVhFBA+aanDqY6Fq46hFwINcPB4z+n0+eJjag==
X-Received: by 2002:a17:90a:d98b:: with SMTP id d11mr91751pjv.33.1620665992661;
        Mon, 10 May 2021 09:59:52 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id a129sm12193519pfa.36.2021.05.10.09.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 09:59:52 -0700 (PDT)
Message-ID: <60996688.1c69fb81.a305c.4fa9@mx.google.com>
Date:   Mon, 10 May 2021 09:59:52 -0700 (PDT)
X-Google-Original-Date: Mon, 10 May 2021 16:59:46 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/299] 5.10.36-rc1 review
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

On Mon, 10 May 2021 12:16:37 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.36-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

