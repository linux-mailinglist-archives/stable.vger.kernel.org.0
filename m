Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FA62E6BF7
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbgL1Wzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729427AbgL1U2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:28:10 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF8FC061793;
        Mon, 28 Dec 2020 12:27:30 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id q25so10141417otn.10;
        Mon, 28 Dec 2020 12:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mulHJ1nXguCKszBa7egioUWJ/dA7Q36evr4RCKBZvGY=;
        b=vN1f+7x+MXeOgmQZNIj6fMTp/+pEe2DKGXCCaWmrS1Xb1d7bsjExzCVKR8d+jLOzDM
         Dg6c524aF6t3XykRRqXeulP1B0TET20xtIxroNICu6ELVKJc2m3OTzQeJpOPcIqdGmHY
         AUztg4QDO+UTItkHFw/m4cOmFMJnumLwcT2JLjffC3Q49gr4riZXlt5I5YudhCk8+9C1
         zaA+3/XFeiC15F/y8mFMSULWi9mme+2CLewlyBlv3tOej5AO26vtbFNIyJgal67hflY9
         sz6IfPh0lv+n4vrmwsyBsbzlfJz0kt1ndiR3+JqgNYYOj5o1Co4SE1dHs97O7Iyb52yN
         4nfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mulHJ1nXguCKszBa7egioUWJ/dA7Q36evr4RCKBZvGY=;
        b=LMdMuxu4LkerUQ5lNhF0P5UXxTWjqquDnBgrlM4I/fvJ5sgVJ7l4wlHm4QTzRGwXEx
         UqpMUgt2WDxEVLxkrRq7Sg13pIJNcUEHDtRDD/OcNDhcuN1wzncYgwDnxoyATY6jh6li
         1YQLNu0/zW7z8dShmgwJY4aTObtLPs+qiAQJOdv5HkF5OQRVJPu2anBDbBQfC1ovh8/e
         bXMusH3A8rKbyO9q1R6F4fgqucfOEKnnmuf9IVfumnOcEx/2B8LcN1R+hxO191YfAoKs
         TjRaPS1eaDYndV49G7SUg+I3P78jMFRS6KV+0npUk71Z8btL7Z/WBICZankS7kZJ49pZ
         fSmw==
X-Gm-Message-State: AOAM530ZxH6qHmRAgGHrZsBfQL9usZ9aqyizogNCJtgA0U0XKpYREG3W
        c/6650nm9AFMc3P1hckkJcDSbyH00wY=
X-Google-Smtp-Source: ABdhPJyIB/ZnrA/x0lSUrLr3W+VvBtUMWouEjZV3RGO364x0/nbKVZTYmXGKt5690BPNEZO01HUm8Q==
X-Received: by 2002:a9d:640b:: with SMTP id h11mr22165700otl.224.1609187249546;
        Mon, 28 Dec 2020 12:27:29 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m7sm6205325ool.29.2020.12.28.12.27.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Dec 2020 12:27:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 28 Dec 2020 12:27:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/717] 5.10.4-rc1 review
Message-ID: <20201228202727.GF9868@roeck-us.net>
References: <20201228125020.963311703@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 01:39:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.4 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
