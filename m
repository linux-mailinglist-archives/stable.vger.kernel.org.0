Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B8449D4F9
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 23:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiAZWIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 17:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbiAZWIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 17:08:12 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089BCC06161C;
        Wed, 26 Jan 2022 14:08:12 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id s9so2275505oib.11;
        Wed, 26 Jan 2022 14:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=89Hp7/IjrgwPt3QPlHIut68ac2PX0Ug9n2aPKa8OYxM=;
        b=iHUnn9+c4rO9fQzQUCdFh4Y6GU7DSdBumNsi8s4/dphmWzY8v7t0cAZNws2z7G+Cvv
         +dQ1ktLvdiMOugqAwg4k6ejI0jwKTkwFgroo9pjzfxB1SYMphiD3K8MTBc8N5phUrGUs
         ZA9dGQ0rdPwb6J2XcZZGI8Py9Lcs1o+KcLX7rQgRNP0sCKAtnUJu5eURRC0Gyce/U9WO
         D+zArgpHM7w2QNKSUiD/A5Gx0kXx2g6jnZ26vb49Krn5dzbf1SAqyc6h6KpKzr9SZ19g
         BCRIJ15tRkOE2ILyoxv/1v7dV4+++KJev0OZXcNDk2OFqLLTjEo96Vq7L3fV2OL6erp8
         riug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=89Hp7/IjrgwPt3QPlHIut68ac2PX0Ug9n2aPKa8OYxM=;
        b=RbIrAaJXbMTO8B8/pPlv/A9EM2Xo2EUMcU0jtNybksgQohhT4GT0qLSOcA+aQ0vgI5
         /s3FLMCB8/NhuoC1uFZUv7Zvb7D3AnsMvywh6hYFWMEFxh02hZWaGcq+yJMeG5lDkNYW
         3dV668B6PS2dq9sOeXwBH/38IQTEikp76QYZWSPY2NEP9KPquWszzNl2hR8WXBswadIu
         axyck/dk6L1pw2KbyYwgF7KtvJTTETVa7NrHGXGZjZwoCzZ+muOtBGQgz1hT9qI3CyUE
         9HBRT1AixftiS5nBP5jPCwxZdJxWftHIyF6Vn6Ce213F7yiw2BIrFFfF7ZX9KCuTkAsh
         HcZw==
X-Gm-Message-State: AOAM5309SfVVsSjXNbeYf6hHsPD6rqCPQ0hQZiZDRHOP+5W60INnhhMj
        mbf7oO0TgS4xnfPr6J3aHno=
X-Google-Smtp-Source: ABdhPJwlFarVOUAMBPvH1rXaym4H8AFuo4q8PBFRxGzwzdIB9+3uwpoR0Ui/z/oxugTJ2Q2IcN5LTA==
X-Received: by 2002:a05:6808:1899:: with SMTP id bi25mr458759oib.338.1643234891471;
        Wed, 26 Jan 2022 14:08:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bb32sm9660829oib.11.2022.01.26.14.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:08:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 14:08:09 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/316] 5.4.174-rc2 review
Message-ID: <20220126220809.GC3650318@roeck-us.net>
References: <20220125155315.237374794@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155315.237374794@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:32:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
