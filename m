Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDDA2A6C38
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 18:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbgKDRv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 12:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDRv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 12:51:26 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E31C0613D3;
        Wed,  4 Nov 2020 09:51:25 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id n15so20078889otl.8;
        Wed, 04 Nov 2020 09:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iWdS73/yAKQZ5Z5ysqFEX3PXbQqUrnRUEbA2Shxv+aY=;
        b=ooahY6l738Qs9OmU6khtF1Enw0qmqpp+rgMk+5CbBxl9AKTEGkyvYJkp2Plqt6vtdf
         BGOboF3SvK4P5qdwGX3LnBcxljJDD9QZvYYbtw0rfXd5zmgva6v1mO9P4DZgVXT2gttS
         UBUVUpkGhcsRcUMW2IHuEZRjk6V+99i4mjnH7eXaY47UDR9Hs8cMiELoZBjKYsNwfTab
         rdH/ZuZ+zMRD22KdnVnCIbpcTzNUuIzSudauW1sYWI9MYCV/GpcYUkcNjQit4xF8ixhq
         4uzptI7XJw4t4DHwwM+Go4N/o+EMyV6R+kUJQxI/1u87ocoxflWPUxX3467/W+VLucvU
         RVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=iWdS73/yAKQZ5Z5ysqFEX3PXbQqUrnRUEbA2Shxv+aY=;
        b=aHoYQYSEbJjBppB58QyNxINS8VAHyXGMWYDF6/1I/VTAc866im4Fh3kE1ByilgK/++
         Hk+0rlJJ+mGOTd1IvfU6A1DO9qi8/g1lyvGJzsy1Qmu0QHcuBFoXBD9ypcHPJqoqBYW/
         +O3kFnr8KXZO6uS6Nyy4PkcQXeSQ7eXtKwX6HYgBlwBNggrosXwh3KiyqiKhkMxs0ZLJ
         uhzerszodL9X7pEE+Eowxqt3Pl07pAv5rHxzlMFW9SQZmgkqd5gXXOgeksE91EqWIZw2
         zK5pEuv4YX/1evvDfQKAIX8ykFHycIYIql55LHoo8IzQvBZUifUIe1hLPLoxwJm80GP0
         XZgA==
X-Gm-Message-State: AOAM532ULac66uV4n+C9iByjJSrkUQP/LYF4DeDmO428ksaSxg40mX8I
        YkkQh+3+L2SJnkotCQkwB8g=
X-Google-Smtp-Source: ABdhPJwUtc813wlWnrRgmI/j5mDmAxQjcq3ogSRc5aj8yoOnE2FjnW0Ea/2/D6UCtw7xKTRmB57bXw==
X-Received: by 2002:a9d:4588:: with SMTP id x8mr4731459ote.169.1604512285397;
        Wed, 04 Nov 2020 09:51:25 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o30sm562008otj.47.2020.11.04.09.51.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 09:51:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Nov 2020 09:51:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/391] 5.9.4-rc1 review
Message-ID: <20201104175123.GD225910@roeck-us.net>
References: <20201103203348.153465465@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:30:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.4 release.
> There are 391 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
