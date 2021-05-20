Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C41238B9D6
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhETW7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbhETW7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:59:19 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0E6C061574;
        Thu, 20 May 2021 15:57:57 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id t10-20020a05683022eab0290304ed8bc759so16334540otc.12;
        Thu, 20 May 2021 15:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jRbFLcPT1V3GqtBWqvBWuFzBTt3zbNq0NKZ0/EY1ZH0=;
        b=InYZET3vf8anD9UwiT6Z9U/VxApJSnmeobAE0KDTeg4WjdhIrF89Ba2+lOQJ7A62LJ
         lpsoBwBSbIxLn+oW1TU9M8bzfPGCuWzNJE02RKhxK5/H//YiW/FEGDG1kwU3htF7Zri6
         eO31BZz7+qF5o57C0+vDlTDj8HG1R+pfuQ+IwqrRB3Jx5oOWYYHmqpgM+V9XOrs9uQ8E
         +//mM6SJlwbkuZD/1qCx/0ojvo+mDjidYZDNEQOddwnd1I/TkbQe0tQc06lYZUIE694T
         tFnFoKytCrvkw4W36oWhZooN67kxItR0M6GhBtRjeLcIWFSkNBxnr4qQEo9BMpjhd5Zg
         oVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jRbFLcPT1V3GqtBWqvBWuFzBTt3zbNq0NKZ0/EY1ZH0=;
        b=gNO9fqTegBMNXfq9jS+AgIZuxyiTZRcZ4HNNHK/lkKdth7khZLGzx345VViXc0tgeW
         zt7ZZAHZPlQvq7hHwaEtSqq+2N9b0fPF+Skyqz66fx63C2CbL3XXIKL7vRoim2s42RqD
         /BLM78nSPWSD5m9ITzB31xxBhLLrltN+VQfmtplcmLJYVLlLI1XUa+5MridJm9TB+elr
         F+XyyPOuNQi/a7uUTUousZM9/yqw+i4FQn39TWbT3GRL5qlsSCsE5zhb1mkjHhfljcaS
         zp23CvZjWC4Q3NSwGiI7o0dBkrw0DF5xEbKmvaqHR90FkwgTJS8jq1cRUeKhs/50Tgkh
         XNQA==
X-Gm-Message-State: AOAM531JBGJgJ3Iu2CYzgBsC6exaC0znHUJkymROelgj3c263AJFXGuW
        L5ctt5mkGdbpnmrZ6orPOPs=
X-Google-Smtp-Source: ABdhPJzEUsxFzY3pMpAgniD/sqEz5RQvMOlJH3+XTuKxABC73ldczq8jOkhzxRiYgurerltJEmVOhA==
X-Received: by 2002:a9d:2e8:: with SMTP id 95mr4179209otl.174.1621551477205;
        Thu, 20 May 2021 15:57:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 2sm930300ota.67.2021.05.20.15.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:57:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 20 May 2021 15:57:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/186] 4.4.269-rc2 review
Message-ID: <20210520225755.GG2968078@roeck-us.net>
References: <20210520152221.547672231@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520152221.547672231@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 05:23:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.269 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:21:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
