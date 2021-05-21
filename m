Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5101038CD49
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 20:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238923AbhEUSZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhEUSY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 14:24:59 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39FDC061574;
        Fri, 21 May 2021 11:23:35 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso7907148wmm.3;
        Fri, 21 May 2021 11:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XDCEmnthFB6MpJa8N1DYmzVWWE6ksA9AEYb6qZSQyD8=;
        b=tikgeKcfqnkpg1MtkSabs1VohQ9wzd5uYVvr6ZHhtkZCJirLjc5v4+763BUT7QIsok
         RkYIFdTMw2EIfEsF2QaZyC1FfUsNtkD5AvoE/9A10IC2jubIqbqs8cQqdMeZ2pGcSif9
         gcOFxFQQxbTqD87NqK7b1uGZ8HCD4T3Ld4sN3XqWsh4uhMzLf/58c5V8z9mY3ReShC7W
         Z+vGJuPYWFHMRnHJPW5AZgF9kZsytxX+vLFz4iPHHIoC5p+uLqD/8lnsvPPhhNaJfamA
         YSv1rjGm3jmBS7ftIekjq996Tmand/yQGC0W8u+bpmO1QVpH3y5+sHXPU1je0edIKdzr
         J5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XDCEmnthFB6MpJa8N1DYmzVWWE6ksA9AEYb6qZSQyD8=;
        b=KPbjbeok4jnpacN8QUsM9gX2WCXYz7JLmO3lJPl9cdiB3ILAh/ChH9hVL18yuvua/U
         HVG7uSywNNBVVcs5gm3K1Q6jluQ6IQkwwSOu739rV+GvqQmSp4ErIYj6k2m1JnYN9h8o
         jXhA5VCh1eMp3YOFRzlHlz59mY0UtcfpFjGX5YdoZSfrnsZDPl0vTbUvp1Xt8CV3G9u3
         a0TuPlr0dqSNyJRz08JwJfjyR7koaq44hFi45Uo2UxITWKjZCMDe2yXq/ILtPlv6VXpF
         YjooRqOyi5tL8uKG4eFZeQnEPA5td2uAkmBmF2hN2QAd+WCw88qb9ZScbvkd0HJ0GB6g
         qDsA==
X-Gm-Message-State: AOAM5306PTc4OPHxBjwOQCdJxU4920VjJB/x74/MLgJ9B/+PWZdhGTs6
        G0Em8ylXslxHzlMgIzTGvpQ=
X-Google-Smtp-Source: ABdhPJwbj+mDzHrC7bqxUMNHugoXNS7b5rAiVgUn5CgnrWXjKQPNCpmQfT9TdkrJydta1kgJ2M864g==
X-Received: by 2002:a05:600c:4f8b:: with SMTP id n11mr10008202wmq.180.1621621414299;
        Fri, 21 May 2021 11:23:34 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id t16sm3084467wrb.66.2021.05.21.11.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 11:23:33 -0700 (PDT)
Date:   Fri, 21 May 2021 19:23:31 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/425] 4.19.191-rc1 review
Message-ID: <YKf6o2TcWlT2pmmZ@debian>
References: <20210520092131.308959589@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, May 20, 2021 at 11:16:09AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.191 release.
> There are 425 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 63 configs -> no failure
arm (gcc version 11.1.1 20210430): 116 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
