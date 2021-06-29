Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EEA3B77B3
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 20:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhF2SWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 14:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhF2SWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 14:22:16 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223A8C061760;
        Tue, 29 Jun 2021 11:19:49 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id a5-20020a05683012c5b029046700014863so6813985otq.5;
        Tue, 29 Jun 2021 11:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vnWqHp1e6POoAP3tfJ9X8fJQJfE+R11DVnX7leY3zLY=;
        b=otY4J/rNhgXVGz1gopnbkJcKoakvA0uXzLRzBR3AhwpsXRWupgGo1n5akvW0RtPaRO
         QxfFLjlffwhGaeZ6snSz360kR2O7F0eHYEnY8Tu1vAsCD/CbFPPVr9pWbDN5+9SqkEj2
         3cKbRiTjVh0mOQ+0bJOIxIPRL3MnIBiG8snKdV+qsmc1w8HZsLmEnBFLoaBH6eDdlYds
         0aj2dX8mVWqSvwUhmY43Wtx2hRwmyIOmK+5NriIEZfVfaukKeA4/YjesT27MqjFjsOOw
         8UuNS9xfDJNa0WnqMojrUI0z3Mx/215j5SEe7j/nNushsQn9L4ODgvMo4h2PxmaFdItD
         rJEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vnWqHp1e6POoAP3tfJ9X8fJQJfE+R11DVnX7leY3zLY=;
        b=CCfPFhwWyMzhVXgoeYBNlKNIBe9uQSecK8BEU+vuJ95W5nUM2NZ19nRtYX9754Qpjq
         dyq4paGu+hvcGIdfQh2AXtAgYAN1yeCPFlZrx3wfcCBiQnS1IA1WOsRafSpd3qdlcxXR
         r/XuyauomdJKZVmCEEWo2ClUna/LZl3yqV0imShVJu2+tYjjTnLiS3YcNEc5Z2TQ0K6+
         f2D7ias3hvL6zIiKNcVYRpP9Ym9Uo0is1VyWOxclbqGgXDHmPq5FFV1SWv9BqthSegPv
         /NQcuY01WqAQYRs1tWFbZWoChhCzJE4Bm5MN4K03+DnU1xfPtrJK142ET9WdJgpbqsmm
         UK1Q==
X-Gm-Message-State: AOAM533UIbZXE/b/IVVDfEjiB4Sd1NO9LcClIKBgXquXZ9zIycJQK/o3
        Y8/wftupSmc/aEHPxLC/Up4=
X-Google-Smtp-Source: ABdhPJyBzORnV5TFGy8Mn3TShLlatYORez5rItZ0PGjbUy2FEmyq8YfkUAygCnVURtkqtdA7TNRyvw==
X-Received: by 2002:a05:6830:1e64:: with SMTP id m4mr5498314otr.23.1624990788532;
        Tue, 29 Jun 2021 11:19:48 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f138sm4052951oig.21.2021.06.29.11.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:19:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Jun 2021 11:19:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.19 000/109] 4.19.196-rc1 review
Message-ID: <20210629181946.GD2842065@roeck-us.net>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:31:16AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.19.196 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:32:48 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
