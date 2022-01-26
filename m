Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFB849C866
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 12:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiAZLPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 06:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiAZLPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 06:15:23 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A80CC06161C;
        Wed, 26 Jan 2022 03:15:23 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so1738187wmb.1;
        Wed, 26 Jan 2022 03:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oB7FvwEDFZDYVoBTpjTDMOC2SfRcobTBo9kJ8jQPmFM=;
        b=CxIHtBk+wzjvbXKgbhMCy7NLEBTib9WOzw6VChUGhAKwfw703ez0MxwW16T9bA2IBb
         mwCQVGdyjHeh31kosKas6NvmuOmrNaguE+yucG+q3VFs18vVn+PLnTKxEV4FC00SA2sY
         w4uzq534gJwaNT64GsK0DBLwG8fLRphp7JStRFsB+EbEdHmqaSdAqMhK5e9ycvhIq1sH
         SaencuqF3Dqc1HHhVCrmnqMhwKFsW2Md7R7cKxHXl8R+gOh8WNF+AnlzDHhMSdvqwfnQ
         kKhX1hyWl9RcW/DnZTvXVezaKbLNiqG26zobjPKIxAaI5Vm4rpamWT/CDcYsVsWH5z1W
         YAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oB7FvwEDFZDYVoBTpjTDMOC2SfRcobTBo9kJ8jQPmFM=;
        b=JBo2wh5WMCwqbF2LQwuosIFJM1hGfUvxYltTBnNPsaKCTg8lYJ+wm8holeFVTR2rIN
         8vuV1fA6oRNCQ2sq+l/DT+dDN4qVAjwRaS3wM9XeeIwpokv9M8WgGPb9ErVbgNBQBA+6
         gAxdleFobjKDGTUP04jotDJ5hqQ2Q0kFPN5K16xZjkoXDWVZuw+KZ5qHkHZP0j+ji42c
         9Lk58o2SiSAZZkWD4SUCHsQr6oWTplD+ZF1dvP1jQ+JI0EKaxItumRsYWrSd7nI7sZxI
         sX5U1vj9qEeo8R/kb1G24IUUJF4Td/58bPZQa/uDTs+6sf8Qt8BCbYHs9FQWxox3c+nT
         LmtA==
X-Gm-Message-State: AOAM530KbXDp6YaMfUZVutCZ1kH4PL/qVh5F1PfFITMFNmuXNVDaRMik
        IP7lsDs3VBFC9E+R1xF9MDE=
X-Google-Smtp-Source: ABdhPJxlDXoYojJ2h1CdPBU27ox3UHLvF0CYepnQx0Np+CfzFMiwW5LrjjrS+k9Me7GwlRm7YnOG8g==
X-Received: by 2002:a7b:c04b:: with SMTP id u11mr7176852wmc.104.1643195721517;
        Wed, 26 Jan 2022 03:15:21 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id w8sm19610238wre.83.2022.01.26.03.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 03:15:20 -0800 (PST)
Date:   Wed, 26 Jan 2022 11:15:19 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/316] 5.4.174-rc2 review
Message-ID: <YfEtR5aENnj98ErE@debian>
References: <20220125155315.237374794@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155315.237374794@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jan 25, 2022 at 05:32:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 65 configs -> no new failure
arm (gcc version 11.2.1 20220121): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/656


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

