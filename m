Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684303B77B1
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 20:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhF2SVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 14:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhF2SVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 14:21:52 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77220C061760;
        Tue, 29 Jun 2021 11:19:23 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 11so19126195oid.3;
        Tue, 29 Jun 2021 11:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=++q11dCIOywdIXaoEbh+wU1uy0CHe6Vm5Vocl2Aa0XA=;
        b=uIZNZtzccgDurCYrm9+O7qn/UxA/6XqcB40fjPHaHIdTEeArFQ3I4jzWYiqMP3tEGQ
         dz7CDSTMYO9fU4r4fNuH2aC5kZMQSyn55GgTvvbN+JHYYLyXLQmewKT5mfXmVFLmwnXj
         KEHXP5aEXPBDntiYW+tKXe5zopKzvZONXViwZXEaPDzI8JbQ4BoRlmtDWsrOdLxrNQhq
         IECtcr9vlD9L6SiFng/+0hhLQsupZP7cqrk5GSz+l/lhhUFrutOxyu/UsftewKuD+SH4
         umzWLaR4sMvKSnLpb/86+6g20BPckt+fSlMg15u2Ds/j1vescbhswz+jFRbtzwWnyWVO
         WuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=++q11dCIOywdIXaoEbh+wU1uy0CHe6Vm5Vocl2Aa0XA=;
        b=iEmXzfVCaI3miP/BOCC7WPtByIMdalrZOycZX5nZ0mI6vk2AnosMkQDfrO0iZdgExS
         EW8B/K6IK+fCz7RF83Yp0rT+eMLwTTMLdfaPRLPHMcmTpkYSa2gXw03mA2jY2GO0W3nQ
         mCWGwCJmM2vRN7SNIHc3rbwRmNP/52gJgv7p6ru7Pie5bJk9ZPBo7hE6rBduHHGXZO9B
         FEdsN2PpFzCJ28UH3QeYFMYPPkJ77RlDBaC8vE7br7B7aylJ7S3G22FLp+GasSDGvUIR
         yE9soKn6T95fdJpd+Y1pBRgOV1Jyj8OsQZc/rnKDgyjuU/gOK+N4USUKA3VvrcEQIKyT
         IFIw==
X-Gm-Message-State: AOAM5331KfWiHNSrim9qCS7z6YJ7kWcI2NCcRIwswDfZGbwashBSgbYt
        sfWmBVloGvMTp+rkrFvccgc=
X-Google-Smtp-Source: ABdhPJzrtuU33CSwbaP/3Bk5yPNUrhmMwmyIZNXuJOhB2PEr5K3H3vPgxk5df2XLFcNfj/+Hc0Ag5A==
X-Received: by 2002:aca:ed57:: with SMTP id l84mr18909575oih.119.1624990762920;
        Tue, 29 Jun 2021 11:19:22 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g25sm1879278oov.41.2021.06.29.11.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:19:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Jun 2021 11:19:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.14 00/88] 4.14.238-rc1 review
Message-ID: <20210629181921.GC2842065@roeck-us.net>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:35:00AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.14.238 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:36:04 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
