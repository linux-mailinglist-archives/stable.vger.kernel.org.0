Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C59B32C83B
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377146AbhCDAfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387981AbhCCUJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:09:29 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B15C061756;
        Wed,  3 Mar 2021 12:08:49 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id w3so5112077oti.8;
        Wed, 03 Mar 2021 12:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ji0+VmKZLwtuggeWbtaFHHjpiuLIrXLOhc4el/eVDOg=;
        b=igKPuOBPf6UMr2zaszKRxemypGJE7vQDA5rzI+tYH7VRd7TYVFMLWZEAxNoi696D5H
         lEd7xBfHhu4qRtCsZxCM3U3hv4B7cUlaurnDtUsA3IJzEXdh/qnMST9ZhlK05J1WeWPe
         291fr7IIw2L4ffqCKmQ42j5XcwEF4M8e77yo1dOKvKKChRSf3gUevebBwBK8dwiuR7ht
         9MfqbwkPCfVANR8nHVX0FMgIMFgS7EUE9hdLVDWoZSAFD5+/srEnMr69u41bihpH4t5h
         B0Chy3UiK6f5vt+dIchxxsoG92I/s0OXc9RJ+e/Ovxf7NO2N9A6C50D3E2J7a8s6U485
         rnnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ji0+VmKZLwtuggeWbtaFHHjpiuLIrXLOhc4el/eVDOg=;
        b=qXabXeiAJDz3K+zo/+b/E2Iwtg5aQsVhTDKJjevq0Pi+dbrzyZVLi/rYpg1acu+YYM
         rZgm4640Mr2Rasvhppv9y924qMKPIDaqpBUxzDjXRI9OvUeLiHSWFD2pUdTk/PRz1Hik
         eGHlSc8Zvm/bldyWyozX8dLRwcO3Xe5R3/E6R8EAR4r9QzNdgQHGLn757kq6c5pPYhjc
         gUNZFy1mkgC8IIgD48vJDqlwXVDg/uR5FgJt/7eSbnI0ra25DJXY51CgTG+OOW2Z4UAU
         /uUwG4jg8QlwwL3m0Y+uWF3y/WOnpFFrUhnKLvbgDcO94+LemhV4oFAm6BkzTJPki/Rh
         vyBw==
X-Gm-Message-State: AOAM532HHrvxNr7VOSDf9ZcB3ip6BsWr87SMWeIPJqI/wGWEP1rlqVvR
        s3Z0SUn6iOq8eI72osptAZ8=
X-Google-Smtp-Source: ABdhPJwjwTKxP7fFRPD8ScId17DjLWpedh+FBlMyBdUspu0XMlJ7w+8mTKVvnx/1qE7LQkBF68vXUw==
X-Received: by 2002:a9d:2cf:: with SMTP id 73mr678597otl.28.1614802128858;
        Wed, 03 Mar 2021 12:08:48 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u15sm4665580oiu.28.2021.03.03.12.08.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Mar 2021 12:08:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Mar 2021 12:08:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/773] 5.11.3-rc3 review
Message-ID: <20210303200846.GG33580@roeck-us.net>
References: <20210302192719.741064351@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302192719.741064351@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 08:29:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.3 release.
> There are 773 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 435 pass: 435 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
