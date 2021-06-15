Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B773A82C1
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhFOO2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhFOO15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 10:27:57 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7911AC07E5E0;
        Tue, 15 Jun 2021 07:19:45 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so14419384otu.6;
        Tue, 15 Jun 2021 07:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wTu0VA5n5KUZNz/P8frrE249ZJZYVz3mRxXwsAW5Bmk=;
        b=SdE0frSHs8cnQ6NUDMC4ZSMha5dox2JLCnCwYGVSBlqN6T5DHEVsoRxhSBiFJGPH8G
         5ihpL5/U6bpCjO7NgqivGWwnER5B/yQ8LLyxR1oDMbeicms4ZPiXZ1BDWCsmLX4U4jPW
         xUhZzcCGXts3LIvXV7uT/WO05tl7ApRJPgELkH/b8gFnMZ6/j2wMf7v+tbck8bhnPTqb
         VyJbahlJ4vjs3BhyJyv4DbpOPnb5uCKo07Mw8VS7ccw85SBHSfPh8/pMVYmyhdCfCw4f
         9iHH+WsjAmDPkntc4G7o6uQ4Qy9L0XYC+8VAsyKh3MRzEGN5zL7GlQt6wdEgDXDxDZde
         o8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wTu0VA5n5KUZNz/P8frrE249ZJZYVz3mRxXwsAW5Bmk=;
        b=YR+zqR+htrvhREsvDEtUYPmm2oJTY2x3BBgBiQxd2L7OyFkmv2kf0Ofo81QIL+VDfg
         GdAGh7+t4g1cP8ntUlo7A7t2V6St0Cl4yJAmBu5ikCHMVBV3JVID1CmSgGE9J9wTpu6D
         Q4czjJxUimRvBpKgbicg+eyn7C+Yu7i9RopLKsPuYzSUTHz1gUuxndfg2bYHu1H3GduQ
         JJeajU5OgVksvvQJJZnChMp2aa2PmYjTpphiykCf9XC5nQjNEt9vBx1I39IO130+9Q8j
         6Yao0RspA6Rt4gYgJyuTTNq083+GKB+2BCcfidc7pZKYuU+/mX8fnMPOcKolpYChFMmx
         /JRg==
X-Gm-Message-State: AOAM533/AlG+5eIMftSfncM/Xh4XD5zX0I2VMB7OE8TKsIEHDUVo0Law
        sJMdGr0LcLayP5SqhSrpcUQ=
X-Google-Smtp-Source: ABdhPJwxcmfOAziq589Nr6Ohr5pLS4OvBfGoukfVbucpUOz8rGrejN2GgQhiniCdKdmHv9zPDNWaaw==
X-Received: by 2002:a9d:27a4:: with SMTP id c33mr18382153otb.281.1623766784884;
        Tue, 15 Jun 2021 07:19:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c188sm3951822ooc.29.2021.06.15.07.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:19:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Jun 2021 07:19:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/41] 4.9.273-rc2 review
Message-ID: <20210615141943.GB958005@roeck-us.net>
References: <20210615060657.351134482@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615060657.351134482@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 08:07:19AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.273 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jun 2021 06:06:45 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
