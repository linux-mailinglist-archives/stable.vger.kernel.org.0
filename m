Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F37946C4CB
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 21:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhLGUpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 15:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhLGUpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 15:45:22 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7D8C061574;
        Tue,  7 Dec 2021 12:41:52 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id x1-20020a4aea01000000b002c296d82604so116178ood.9;
        Tue, 07 Dec 2021 12:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dPRBb7y44FAuAwORNACPpuZicrbuQcxGqis2StmYXM4=;
        b=bz6ikqixzspGzcJnff2LoTfX1tGwKFvy0wXHP36R0dWoSo/l1xsW8EgZzRpmxe2nmi
         6fd8FuUGBVE1lOX8kHSdN9YO+D9D9kihI9xtepA5EI5Fu5Wuxeej7WDlqUMvcuJObTzN
         bR3NYB3+nB86AFt++pkobxwJR188YzxDfvg1VKfAscpuaYR8HE2OFkRipjifr8bs5Ud9
         liMHNr5PNb/er8rewu/Z6KmvLt+5pgxnId7Zp3346XxPlerkXtG/vxYoSpcgY4Q++IYY
         uKvsoSI0hVaHLZbeaNl+2ugZRm6rU+3u9lfY5gdDQ0BXPfzXI3wfFygUPJjhhqVSqAUo
         HKXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dPRBb7y44FAuAwORNACPpuZicrbuQcxGqis2StmYXM4=;
        b=ljoX7uBZ4xf9fOs7MQ+24wPG9r3S/FmtyQbAYATv3M8YjZ8oc4YhDoobxCSvUyjBC9
         ZU0p3wBfozFbijs4d3flEJG7RTGIlTkJjl0l3h6Fs/w2SDkGXoHiBeQLJpbEz94r6I5P
         ZD+HnA5qDzvGcFU4yFOs9X4DYJfwzLECcvc4rNpyt40hCTydDrtV70mUXejUMEck0sb1
         4PCRwdZcYfyz6nG1f6aYzZSK5GTPCh44SknZLHs/cmTBAqIt0pGhZQqc684aF26oItZx
         ydjmtX5Vd/Uha2jRde28VrJwP8oG8njGBJKV7jV1mP1CIe0y5LE+7KpUN946ktVhTC9S
         +0Nw==
X-Gm-Message-State: AOAM530nVHI9BCXC0hTtd4REP56M95gG0VUvhDZ/nX/YsCG/ic9MqJOu
        GnDxbEJgVENQQX5AkSBtplA=
X-Google-Smtp-Source: ABdhPJykK9umVm11BAZnpn3F6Sj7904rryokr9jNUQ686mr+/ITrBlM6sS6P05PJzsCjJPqh9/GNPw==
X-Received: by 2002:a4a:300f:: with SMTP id q15mr12422984oof.36.1638909711678;
        Tue, 07 Dec 2021 12:41:51 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9sm168446oog.43.2021.12.07.12.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:41:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Dec 2021 12:41:50 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/125] 5.10.84-rc2 review
Message-ID: <20211207204150.GF2091648@roeck-us.net>
References: <20211207081114.760201765@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207081114.760201765@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 09:18:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Dec 2021 08:09:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
