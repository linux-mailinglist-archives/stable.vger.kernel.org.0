Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065812076F4
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404010AbgFXPNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403831AbgFXPNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:13:43 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECD0C061573;
        Wed, 24 Jun 2020 08:13:43 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d66so1288747pfd.6;
        Wed, 24 Jun 2020 08:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9+mtE2WC+f/Hq+xostZKldaTgjgrERe9OT0QuHtTKLc=;
        b=EsSqjwY+ZLj7UswvQjBLing0fL2GvcBlSE87H9rg2F0Ewv06Ey5BjryQF13o6EexZK
         7YPwktLxHaCR1OCyw9tK8Ek7NZdNAK9loSICUnRCcjhChhR1Zx5ux2YGY77+aSgT70fy
         KPqSejT2nyb5Xge8H34w4nnayMIhlzvxbcATDuEZq2iQFAaU5UiS+vXfOVpOxzWas5CV
         aBs7PTT25YLBtPXCl0Y50kK2+4QoeHmjZ0yRVHIGuCe26Rbpt38Kd7FiP3hKBT2f7my8
         YQqqwI/zrU9B1cgrM7BdTukfbfts+j1/4rp2yU1hH3rr3GmMvsN0e/WYcxPVlxnEIAvg
         bG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9+mtE2WC+f/Hq+xostZKldaTgjgrERe9OT0QuHtTKLc=;
        b=CpJIHVUbU3s5XKMAjnQ7aRiVpjoVg7qBjdrp/jpOCHdDQula12BoFBSW+lxBaWJR9Q
         a80v7tsIVCVoab9fgZkWv171PaS33jKRD+VWlbLHmYX1Sr8gbgUbis+wyWDS8N6MENBe
         1e85VTMOynKzYqHvSwgs7U8MrNfR7mG1I2l8QtMWx5IEUhWgpkVMHOiQ7hOt99GCzYBk
         gUvWqSIt/LLhsU05I63HNWDRRLWhB99F1PORFcybVEPuddKpXGEoHrpxcadgJb5/YPBC
         CMoki/LbuYosaHr6C9fAoyHIZR2+1QCFPwBey63PSwZ6pL9xXhXCD/2Ua0PpLneJcVqr
         fWVw==
X-Gm-Message-State: AOAM530GbRV0ASy2Ff37NhtYlrBwHXhrK1qbkEC9/1yS7K8DMVYn3bhf
        M2GqQZtEMqaSWY2mcY8Q6IU=
X-Google-Smtp-Source: ABdhPJzdj7iMV6edh4quLpH4sWxWQb9kABEMo8JIeyVfnO6rNGvjnKCfB+AX6QXyLIM47PZ3p4xRcQ==
X-Received: by 2002:a65:50c7:: with SMTP id s7mr20980745pgp.298.1593011623091;
        Wed, 24 Jun 2020 08:13:43 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y4sm3705877pfn.28.2020.06.24.08.13.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2020 08:13:42 -0700 (PDT)
Date:   Wed, 24 Jun 2020 08:13:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/203] 4.19.130-rc2 review
Message-ID: <20200624151341.GB54105@roeck-us.net>
References: <20200624055901.258687997@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624055901.258687997@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 08:10:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.130 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Jun 2020 05:58:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Guenter
