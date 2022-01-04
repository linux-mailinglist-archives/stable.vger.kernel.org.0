Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA314839BF
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiADBXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiADBXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 20:23:30 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27068C061761;
        Mon,  3 Jan 2022 17:23:30 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id v6so57192629oib.13;
        Mon, 03 Jan 2022 17:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iW7Oiw/r2W5/frHdKEVvvSYdg14xKn60JgBkvfrC0Tw=;
        b=B2A5/trJTwhuBndxAjnp3ZMZEmAdHw9Xsg0EGpHZrmBGYVDGbUlzDghirK0vARmUNk
         quaeq3tb1FnXDU/JZFY1lb9tJral7P/WqXpgmPPXLyG/3yoRu0RQ7/Oqf/E7l7LNVpNS
         +ewBX7sdi9vPkLq3Hyr6tRc8YLjjILssIo66+gOZg4oquJavdgYlrnozzadqUgTfDRpa
         jevoZcuhQQyIQu5C5dYvSaxxCf/m/CTPMsBhG0Rh9f55wHzXbnMSTYEiBZuud0nn6qWi
         Xobn1aafCyB+TiA3XqfAMNL+R9rdULcY5M3vdVYWWfLJ0krbciXXkbC4+pdKMZyfBtrn
         rJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iW7Oiw/r2W5/frHdKEVvvSYdg14xKn60JgBkvfrC0Tw=;
        b=ncSpr9V4GIC+cOQNjA5pauqciOkEHyKZNNS6DYrRDsRG86/Leixett7bL+IHarWje3
         Pn45fcDe5pDiNHL8yF/gY+Ud7lez6QdcikDEsh/XLvnOyfKEP0GpsgR9ev9bF8AlaP/i
         SeaeoHYVZAKwnAf4Kv9d76Qin3Mmb8jSSoN+pP6uk3C0H0I6Ly4EN7Gif2d9qHo1Rm5H
         TtM+puaLXzAs0NOC/dN73AjxEFbxnXUHwsX1EYZ3A8ifsVOnkfagnVDscy9hGJY43vAp
         0YTe5+oc1LY7OOo4HA6O4dY6Uqglf6ji5cfI7BmPQ9hjh1Csn/Rkesf5B2h1R0lXIDcM
         erpA==
X-Gm-Message-State: AOAM532AzfSZpSHyKdhNLBvZPXPjeWG+pby9UIi6cBfOXSTarZ6gSKBT
        pXNRhUQmOqb+lt8cqS/QjH0=
X-Google-Smtp-Source: ABdhPJz8KPVSm0WmC1UmVUyYvuAvqwdxCPA3KsSlv2Rv1VXqwEB837K45pn1nlSMStuGoJ90mkmGNw==
X-Received: by 2002:a05:6808:1283:: with SMTP id a3mr39815505oiw.29.1641259409523;
        Mon, 03 Jan 2022 17:23:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o19sm9506497oiw.22.2022.01.03.17.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:23:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Jan 2022 17:23:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/13] 4.9.296-rc1 review
Message-ID: <20220104012327.GA1572562@roeck-us.net>
References: <20220103142051.979780231@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 03:21:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.296 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
