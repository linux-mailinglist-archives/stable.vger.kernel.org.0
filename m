Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF84A45E6DA
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 05:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358256AbhKZEdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 23:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358195AbhKZEbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 23:31:45 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0953C06179C;
        Thu, 25 Nov 2021 20:13:35 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso12243664ota.5;
        Thu, 25 Nov 2021 20:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ohiHQlZY4MZgjg+/jtcs5wSQWq7bMZ1dPPO8w0LvKVU=;
        b=TRTftHrm+qj8xP2G5DiEvBlWFsTOsEFqkWMaBhuhNaXStD9SRVy0KOaW0Em0wm3o3A
         7XQdsfnZePcoVW0WrT7BOTONkbicGqLmUbfrPVk6uEdZeg5rkmvb93HSTeXh4Ao8ASvA
         Zbcp/9Gv4w0fhRpGzl4Hz2FG1SQkCAVlrRQgW70F/qAefqlpcOxocyd9gePo6T+DbtIO
         Pjdgi5S1p1oosEB7NXkbFDbh6dgPZ8FVm4205C7Meb5DZ0PxwB4FJqew1gaSZNyeMIQo
         /pW4PbaXgJ7iuSqL+mUHJ2GfmFBzcktEgN9Adha4qGeMv8acWWKBS5I7DoQiIcQfX2XQ
         ZN+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ohiHQlZY4MZgjg+/jtcs5wSQWq7bMZ1dPPO8w0LvKVU=;
        b=6SDIpujKjFme2WSIjo5zH6jcKIj8c4uLP/xYx7mol5fWXtktKhksmk5BeVibWiEjs2
         lpKprCmlo9tQn1+vLuFhS6PPsthCeTURXWKrHkrhkWdaWFWwWlxaLY46JY7Z2iAryfnK
         CjamHrv0DeSLHC3eZEc2Jngbq0RreLS2tgBzIfFrws+rhFLzE+rtAtJoTPJSI40OxDHz
         imDgk26EZ/Iq5TwqnbhQknlL0b63q+RHLupp2532dsQhnV3DE3JZgWuv5gwW2d4WwOBR
         5UFMHpvlcHWp+HWoEHJri/XHMKT68r2MB2sgYuQHtKsTuwp1ikPp+s08Aeg6rBwvpLzf
         ROaA==
X-Gm-Message-State: AOAM531g6ZEU0soHxvujAMM2cxLAbdRt8QgJICYxOFgrSz5DmtDataGd
        dxOtAFjppNutu4Q1LpjjW6WJLe1mgSk=
X-Google-Smtp-Source: ABdhPJwTYwtTetEPjn0cOwSuegR7eZKZuEgFQAru47W0jpzdh4kB5waB8q/KuKrpBhWGMtbtLO4kRw==
X-Received: by 2002:a05:6830:22d8:: with SMTP id q24mr25096618otc.170.1637900015361;
        Thu, 25 Nov 2021 20:13:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w71sm1034095oiw.6.2021.11.25.20.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 20:13:34 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Nov 2021 20:13:33 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/204] 4.9.291-rc3 review
Message-ID: <20211126041333.GB1376219@roeck-us.net>
References: <20211125160515.184659981@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125160515.184659981@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 05:07:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:04:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 396 pass: 396 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
