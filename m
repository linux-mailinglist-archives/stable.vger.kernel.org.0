Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329523C368C
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 21:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhGJTyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 15:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJTyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 15:54:09 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3736DC0613DD;
        Sat, 10 Jul 2021 12:51:24 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id s23so2660623oij.0;
        Sat, 10 Jul 2021 12:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XEMoiOuGy/yvF9WFcgxd+CzEmhojvbl4JxwIvsB9taA=;
        b=n1Cz9u2FueuJwBs3V5mLUbs3W4vwQaSPZCM0rjHKPAjkWkCu9ZT1KzDiHa//om2Ody
         ZPGj/jFD6d+PZ0v1B/QCGJ6hlshRQw7NBi4iZd7TmWCYGMJQtqxkp77gOYi2pYxB+sUh
         gx75XHY0tqNiwD/Mn2wEgEo/7LEOAK4D84IKgiLht7eSHUF8znqvoxX0CMMNrIQGW1jC
         7FwQDrXPJMWB0h+E4hFwVu5Ns1N86yoiXwGdZbIC6Pd3iD3itNNZLpHzyBm9ESaAr2yI
         Bh5naI2rj99sL/L2evprNGbMjhAdAII/XGDpOwmOD8bdY6b4Ip4Q9XfYwvfnllpBVBhw
         vN9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XEMoiOuGy/yvF9WFcgxd+CzEmhojvbl4JxwIvsB9taA=;
        b=mPA2eajzSFb3NA2vb4YXEfKYtdMriSw4dK8EhYqEpqIOPvFKyOHglrp0EBo4sswaUR
         DnLLrzAqAb+Fox7P4T1/l6yF1xa1lkSsKZn+gKW7wPb1Yd6iwMlp+Uwmv5kvQ5IR8H+1
         BOBohE9xRVv/VhHV7qINInBXtTP+WKIJ4IoeV9ctBKqmAd09G9nICRS9bCg43GJkDjjP
         8f649En8kPUPcK4QaqFxa/wXtcIxteqjM8B7+UgwEwkJ5gvTP9vRqop8OWXff11c8RyC
         h3OuNeRZSSiYfELNyX6jOoMiHmMo+CausfTBpc3ub2XPhv1mLMopLWmwzIsAroI4i0Y0
         +zCQ==
X-Gm-Message-State: AOAM530NQkcbNvyk4AxWqnF5VN2aFA6QjHf4Me+xQoU4udZz+0nWUoPt
        hGyoDvTRTU3T7ys6zO131pE=
X-Google-Smtp-Source: ABdhPJwyEJA8TIaPeo+KH0RDzZUegZRxi9ZyXO4xdgc1PcUQYPIT/Ovpp7ZvEvw9klPAeQvBwTGpDA==
X-Received: by 2002:aca:d641:: with SMTP id n62mr4346268oig.77.1625946683667;
        Sat, 10 Jul 2021 12:51:23 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b21sm1699826oop.47.2021.07.10.12.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:51:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 10 Jul 2021 12:51:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/25] 4.14.239-rc1 review
Message-ID: <20210710195121.GC2105551@roeck-us.net>
References: <20210709131627.928131764@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:18:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.239 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
