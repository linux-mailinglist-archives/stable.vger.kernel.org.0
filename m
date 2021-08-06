Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E624D3E2F98
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhHFTAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 15:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbhHFTAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 15:00:02 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5823CC0613CF;
        Fri,  6 Aug 2021 11:59:45 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id t68so10980614qkf.8;
        Fri, 06 Aug 2021 11:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p6/1u1KqCpVSt9cGpO7GbIFfJWv7QwOJjFwb5VbHFqw=;
        b=ZdegmBt4a0ggoNFhQXP2ezMmPBCZHbb90dvX4WxDZnl3t08hqJDpXBBhPbn94T6nBZ
         2sqI8eE9cI6Bw99jNzmHdTYMFQx3PwZVKPCbhXw06q0LNddtTHCBnhBwhZzz0++PlX4v
         FgU/bWZO9yJTsWYx31Ct10nslO9WDuGfGDKW9EN4JJUtE/Y26o3UzYyurNS48yR/eRKj
         J/xrHUtRo3WI1NylYKaiZRgevgk7v9qF7yWVWnIRrGsUQoyUUKekrv1GqA5xCuB4gyCj
         6hVev9nUYxrYF1h6eLeRinIaVV/+IXsc8Boj2RrHa60kygQWOkWAmtGgP/+mFlczE+rD
         PG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=p6/1u1KqCpVSt9cGpO7GbIFfJWv7QwOJjFwb5VbHFqw=;
        b=FV0Z5+sI5DaBovIbcVj9eQSJinmP3/wpUhZ0RJrPnplrPqG6M8lvHeHKZbr1gT1EW4
         +715QN9rGNAPFyP0f9FJyNTHjwah7cnefZlYmK38mHAYQ5NRUDxe9Mm/xY3ZLmFjDUPP
         jwwRvjtRqZ2TMFi4ncSIljuI561hngXsD3EXPjAU/kKBbwiFqnkYFBo8lObmFHfy2jQX
         K2CUOqlb+DtuKCtHcYIHZaJSAUBQP7QkoJZoNhx3zf/i1/vq1lPZhoq3XtmR98wh1YQF
         AZIl2xUup6+EIZd4dk1F7rtAGGGIHIJV0tXHTPQmV2U78FkpAA0MYDYt4XjPFBAjmZHv
         e7OA==
X-Gm-Message-State: AOAM533GYyxWlGJw47d/IY/nCdsXaiIW4obrFhenPONbIuilY8EsGcKW
        212Q56tRtWzon23CcKsK3/g=
X-Google-Smtp-Source: ABdhPJx3Pansb75WO1jC+sW76/lAlTqazZS9yVjW7MqhsvotP0rearPuh/kuDdeqoNrVA3wjdnKgdg==
X-Received: by 2002:a37:88b:: with SMTP id 133mr878940qki.339.1628276384615;
        Fri, 06 Aug 2021 11:59:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c4sm3637632qtd.62.2021.08.06.11.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:59:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 6 Aug 2021 11:59:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 00/35] 5.13.9-rc1 review
Message-ID: <20210806185942.GG2680592@roeck-us.net>
References: <20210806081113.718626745@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 10:16:43AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.9 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 481 pass: 481 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
