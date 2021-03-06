Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523CE32F815
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 04:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCFDZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 22:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCFDYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 22:24:42 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC4AC06175F;
        Fri,  5 Mar 2021 19:24:31 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id w3so3798634oti.8;
        Fri, 05 Mar 2021 19:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ReJWn/QLy107vH9h7vJHuwvHvdhHZVmsnOtd8PtfFDQ=;
        b=iUUEDwpZ5To5N4EyHEvNO1yadUZxqBzwYiBHFxgZkli1j8Dg5Arq6e+M72vpDUfpab
         1yy3KBxlrwNrNneb/ikix6tcqHCf6QDDf9aV2JY4c7l6XukdgEBZgbGEWiZ958ZdaS8H
         eN7E4B+UeRWdLTWwXKbkjhelB1FAE3AIjIAhQ8pbz36NzH8k/+N1voOonfy7ktzJtNqg
         SnU/vtq0ZaAp89E6Wp3SE8us2ZK9nS//BUJi2xRp1RsMB3oX5M5Op4+Ig+0cQ81mAXdT
         ymC5VNKeCNsEkyGjNwRgU8DiLDEVzsinT3c+SSOiiZ77kCVeH3a3g3xtyjQzsSiKZLGx
         pjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ReJWn/QLy107vH9h7vJHuwvHvdhHZVmsnOtd8PtfFDQ=;
        b=F0VA9V6p6oStHvlMWTL93QE8ZTaWfOQBzNyIHXpEwiQ27LyQ9aZ63OElH4ROSFpQD4
         opnUGvyZt43NRR95pKhffM/KH5qNDWoepFNlJLSPxvNpjKQk6SxXqzeWlE3IQE0WaHr9
         Eq+xn7LRWAz6+j8HVZP6OwwMt6u/5vkUMMfyZfSCPHObldtimjEUFo3NxYHjE9wHlzGr
         IJ/ruBu6M+1BO4IQjkv9y074Ic0R5/fD28+dZZJCF9ZqOOn0tle8d9MeW0u8QKrXs7Ni
         4HwVrf1Apai8SmI/BOXVDOzRGOY14U5qO3VuAHF91C2svUn2FaK9DBJp85yQqw9+9yTv
         581w==
X-Gm-Message-State: AOAM533KjYdDtBPmEvQGHkL4QL7tWBFoMFQP8K77g9XRUC8eNWgTnrpB
        xzgpGfYRfMhzT8Fd0XE6Ehc=
X-Google-Smtp-Source: ABdhPJwh3TvySdwFL8gWEj8Lyq3I35mrKBYoyP25OVpFiDr4uoBTgfPBbxHy/uUYDKOMJFd/1hC8sw==
X-Received: by 2002:a9d:7103:: with SMTP id n3mr10298216otj.223.1615001070483;
        Fri, 05 Mar 2021 19:24:30 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n20sm1074827otj.3.2021.03.05.19.24.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Mar 2021 19:24:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Mar 2021 19:24:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <20210306032428.GB193012@roeck-us.net>
References: <20210305120903.276489876@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:20:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.21 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Building arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd ... failed
------------
Error log:
kernel/rcu/tree.c:683:2: error: implicit declaration of function 'IRQ_WORK_INIT'

Guenter
