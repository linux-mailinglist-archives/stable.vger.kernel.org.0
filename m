Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0279D49D4E5
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 23:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiAZWHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 17:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbiAZWHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 17:07:39 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450DCC06161C;
        Wed, 26 Jan 2022 14:07:39 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id m9so2262865oia.12;
        Wed, 26 Jan 2022 14:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b0mf9UmVjvg85GOaBqd55md8LL4MfsUG27dbOtZ1/fI=;
        b=T4UB/bYcoDLYBrtGZc1+p//2c2h0DbHVg+raXzHFU2vmjLOz7HyKjfaC4Af+4pUdVE
         hJVVhK9DfMshH27k1IMfL73Tk0VOdgKdN/BF1TVpbYel773vDGJdD+zKsEEzmnsbpY9v
         5l8PMPLt9duR4dybqYV3yHwiZmtzvIoypwXDIjNC6hLRCfY4LI6mj8mAU4gPtFV7FyPi
         Nc1r/s7V3f3lY+VBq3QPPqkkQdRzrQOO4LYCDkFuehYqIRsdaMHI77mYzcSH9+87C7jK
         uqagsOSZ+Fu3GW/6o2q5M2hiVZ8cB/+059a+rgair4pLtMeWeByAuquGOcO3i+qdVXYF
         bGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=b0mf9UmVjvg85GOaBqd55md8LL4MfsUG27dbOtZ1/fI=;
        b=mhc5reZDehMkisPUkvpf4B0b2zXmpPthnDMtMMKqAN1dTodsYjXFs8yvI83d/ZjMIn
         NB9vc8PmRcRx0JYs3MFfhbD5130ZFkujLuYYer4/e2XP8F6QiG5uyfP6kFMyU4q9quTB
         xcsV5MIcCkcUAxVvtdV959lLLyBTkl1jbKYoExHN+R/h24jIlSpexmrESV+NrPmvlFtm
         788X+sz+Zb01UflNr3bM6NHBxEtt137y7WXferLH9D5BXrDrpW8OOod31ZmpG5lp6rT4
         mPvl62D7AGTLwm/irzRvZteIYwd1/RTffI9qaMndO9Jfdxjkq6lxwwIiwruonI2SjfX/
         HlqA==
X-Gm-Message-State: AOAM530vXzFFlVyl+DBGEKZfUAI6RvbhVtT8/djz1EqA1UPPFUx8ixGg
        hPyOQd/fOD/UVjOLPb8O50Y=
X-Google-Smtp-Source: ABdhPJyjlcU0YpWWtdWk0TYLSRw6ZG2WjICpvPu3xxV2leYpSf8Un0AbPRvPeho1uDnd/NNHxEFz5A==
X-Received: by 2002:a05:6808:1150:: with SMTP id u16mr461891oiu.72.1643234858585;
        Wed, 26 Jan 2022 14:07:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bm6sm9131475oib.12.2022.01.26.14.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:07:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 14:07:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/560] 5.10.94-rc2 review
Message-ID: <20220126220736.GB3650318@roeck-us.net>
References: <20220125155348.141138434@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155348.141138434@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:32:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 560 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
