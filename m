Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE8494503
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 01:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345298AbiATAoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 19:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345374AbiATAoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 19:44:22 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89007C061574;
        Wed, 19 Jan 2022 16:44:22 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id a12-20020a0568301dcc00b005919e149b4cso5537681otj.8;
        Wed, 19 Jan 2022 16:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vhymUIiUOu8Rj2HWQRNi8DvyMXVYCcspgLDTmCeO0Ls=;
        b=BYEFV4+q/ZioChHSoeyClqNXxyTBdJ8tOEIBwfZF3svSg+FHbYyLeiO640DizYCUkj
         I44pkQXfECCoxAvdiyVPOKKZmlDf5P1gVII90AVOXoPXMZk0qcJpjlRvOKLqgloFXVl4
         EnuD3JSsfXqh6anS46FZVFITlseaGfjgLERnGPwrdQVUtPfGA5A1mOz+qtuGeBu6IzkT
         ILZ6tH3ubpCfP29DGkT4OdGOLtK6R2wyvnzvvOTknIKVu9Y8kdQIQkZ1rhCowbU4tvlh
         UdmafxiBG3eXPe7oVbDM9LrLxHP9v5MC2bZ3xvWt7vwYEX0SVWG3K4pmJoTXEguiYvCf
         cuxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vhymUIiUOu8Rj2HWQRNi8DvyMXVYCcspgLDTmCeO0Ls=;
        b=sxb1SG6NqHE922wynUyqR+kTk6JuGFaJCA62Kl961A+rPo/wjyEgykCnlCe2ujjMaw
         8qxJcf6NYsewjCZ/KfgVkI3K4xTYCLT6YSpdN3OcFPtNvIH0fbj51kqUoj8ysYIvekPR
         kABr4XHGqCAtCit5SilovNtiT7pN/qXKLPiL8SRpYfj3rnrgDo9HfjttPYbwn4zk+FwF
         32s03TW/oCJC78yzjw7F0Q5OtXpfUWEwmSxtW4d5uEYD/PcsI0sCDK05DaiD4o0n0Ven
         Ozmk0RdcHDfSqMN/evh0aKszD0SYc17ax+tYNPRKWfxe3zq9xMB3uI83NesnJWLsEXiD
         959w==
X-Gm-Message-State: AOAM530Dgw3H8qjSCx0nfIhRowbMLUpiT5plnYGlL3EjhbwssOexC+x4
        GP5B1gcMv2MIQCAQaWcm8Ak=
X-Google-Smtp-Source: ABdhPJzjLjbRC2X88jcVdpQPZUX8LyrUCrXKuEr4V504CMVZ2H4gdOWOP5LWz3cQrl5AgMKnaofBzA==
X-Received: by 2002:a05:6830:440e:: with SMTP id q14mr6342970otv.171.1642639461974;
        Wed, 19 Jan 2022 16:44:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bk23sm863779oib.23.2022.01.19.16.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 16:44:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Jan 2022 16:44:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
Message-ID: <20220120004420.GC3474033@roeck-us.net>
References: <20220118160452.384322748@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 05:05:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.2 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
