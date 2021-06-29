Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728453B77AF
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 20:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhF2SV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 14:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhF2SV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 14:21:28 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D2AC061766;
        Tue, 29 Jun 2021 11:18:59 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id a133so25070206oib.13;
        Tue, 29 Jun 2021 11:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cWVOeBdbslgVGriSPKx0d++qAHzCCePul5bmQ5wSVXw=;
        b=pOyAk0dwsV0IC3wRa7Q8OUehuIkAKE/YN9EpNUTkeVlTXu9AGNo27NIhGnb2JZJzKB
         9MqPlmWKhfca8/isoXZwpIrMWN0OKWMF9XzxSYUqUitzagGGw9X7yEE0upkSvv9eGznx
         KBlrHdMrkuM/vfmg57q9jWj2905dCNGdn5I00Phfcuev2lNMwoKgxAvVvP8V6XwLMp6r
         iAYmhOeuHuyOjqZzWN3ADRjzw5v3CFlX4GBLUD023sgvF1YmCSl7pk/hJ0pm+aSKy+73
         BGz3wmawnXZmkx4qu244fE2lRRJ2T/8bfJGQRjcWfsRr9lmNqnmmGe6gebwVZPrJvUZN
         ITMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cWVOeBdbslgVGriSPKx0d++qAHzCCePul5bmQ5wSVXw=;
        b=AeOuvrB4n7wYrNJOiRzmYm61Xl9aayB9f54IDAmryT3yxfG1EGwoycNwavAbXOtE7N
         B3AiC1ZQfBY+u9evfjYEaoZ3i7ebJGSatJq3PjLSY7D2mdMyaZEE3HMrqGAYAGqttW7K
         2+kZt3PqzMH2qEGROvDe7MojY6ZpXeW0xMxqKCJ8FqthyWxTrTXgSn8/ziMX/kne743/
         7o41SOHYBQtgUznYWZfxF35c7H8s2Ihd+05KdcVBLd9zB13GPZGK3rslsmwdPi6HDCIn
         FCFXgD0Hs3H0B/+7TB7zqrk9mx18wNhbFWLsTITFjDmI9/RQkFN4121jez7LMnBNue4U
         KaCA==
X-Gm-Message-State: AOAM530kfUjy4gyPDBHc7B4J2CrGWdeIVrJuFdMJO0ihnRKLbr6pOYRQ
        0qUCrkhwG5zT1pt6rQHbcC4=
X-Google-Smtp-Source: ABdhPJx91cxOy6SSjMw2gXvvx7lrKNQMc9nD0i4JfRy5bKWU/pgVny7telIZzibtf95nmX7XRCy0QQ==
X-Received: by 2002:aca:ed57:: with SMTP id l84mr18908305oih.119.1624990738913;
        Tue, 29 Jun 2021 11:18:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l2sm2424142otk.38.2021.06.29.11.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:18:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Jun 2021 11:18:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.9 00/71] 4.9.274-rc1 review
Message-ID: <20210629181857.GB2842065@roeck-us.net>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:38:52AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.9.274 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:39:51 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 156 fail: 7
Failed builds:
	arc:tb10x_defconfig
	arcv2:defconfig
	arcv2:allnoconfig
	arcv2:tinyconfig
	arcv2:axs103_defconfig
	arcv2:nsim_hs_smp_defconfig
	arcv2:vdk_hs38_smp_defconfig
Qemu test results:
	total: 383 pass: 383 fail: 0

Build failures as already reported.

Guenter
