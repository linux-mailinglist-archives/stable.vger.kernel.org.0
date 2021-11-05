Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372EB44658B
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 16:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhKEPRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 11:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbhKEPRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 11:17:49 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B58C061714;
        Fri,  5 Nov 2021 08:15:09 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id q124so15031451oig.3;
        Fri, 05 Nov 2021 08:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nRhfZqrqdZWGnOBfkyLKspl1Uf94yRkMCJhYCZ5LVhA=;
        b=hD2cRtdQ4bu+k3MRpzutZ+3nkHJk1j6LFy2Vmkk8teVwvTa+60CSoKA+roHXtZwQlT
         3/6KKydm+cLmlHO1kcyDYG3z9AWzBs+CjR3k5zgusSYz3EOYH1/d6x+N8ZL+NEqEQfzf
         SH8ZczwYDMyndK2Ef83BRKpFyLup5eTuoWF7zhyzx5cnktxe82Juz3XOM9VRXuxbUfAW
         WfDHn8Tqwjy0EktXxhwfSlq4cEUkJ3a8OnBvwpzegq3+35EQHSDzmZnZuBHXotUZ43eN
         mplpUQ29AAIwB5v9P0WK3HkAyKVyrw9zqQztnjwUDhDkQ5MomDMx5ynFrMg5e0nxWG11
         fR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nRhfZqrqdZWGnOBfkyLKspl1Uf94yRkMCJhYCZ5LVhA=;
        b=cxTF5eLReWD1HpyHJkFtHc/5axIjRerowlbT4U4JgNDeyxiZ4Bi34S4z3IqHNyUu0O
         aqqV+lhKKOgFoSdT1IihXIS1k4ZhZZPglT/RZXyGnBx1nLPLnMcJQ3dJ+iKzlhjt94O7
         jZTY3SoHxXZj38syfm5hBSJBFl6HJmxyn7GW+Z2oxSGkGBkue+5+9L3BVs8VnY5aBMtA
         Ta+h+yh5l/V2MIwlSzuCv9Hv7v6MRVQmfmBT+bU9Pn4JmVIQE/zQUIFFyJZy9/vyOuvV
         CZf7gs1/cSM7WOUBvaGVytZWrWllBrj5hRMhGWfWd4fp8d0hMcdG4jOGB1rfaDGSQIwF
         TdSA==
X-Gm-Message-State: AOAM533+rO5197/1o2ZA1Wr/By5wkLU85RRZ4cxt2YCNIKDUbrx/4YSy
        oGlIHz2UvjAf91rB43o4AcNJFr1d5zs=
X-Google-Smtp-Source: ABdhPJzV2xjTiJltBQqoQIawJhHFtmzbilMqrehO69REmAZJOAjHx1/qzSzbQLHL1PZyRXTCDxiJjw==
X-Received: by 2002:aca:6c2:: with SMTP id 185mr22608711oig.31.1636125309308;
        Fri, 05 Nov 2021 08:15:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u6sm2480295ooh.15.2021.11.05.08.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:15:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Nov 2021 08:15:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/14] 5.10.78-rc2 review
Message-ID: <20211105151507.GE4027848@roeck-us.net>
References: <20211104170112.899181800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104170112.899181800@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 06:01:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 17:01:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
