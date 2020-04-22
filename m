Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00A81B4E6B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgDVUfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVUfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:35:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9EBC03C1A9;
        Wed, 22 Apr 2020 13:35:44 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o15so1697890pgi.1;
        Wed, 22 Apr 2020 13:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9ztRV1bdsAUP6tZL+7Tyh0WeQ3qXgtEQOEYDTGXPYv8=;
        b=a0qubbGqFMExZ8/2oBh2SkV4o2/D+3vNmHF4KnOSBB2jOk+QGh7fHw3yd2qxjobTgi
         Xm+IrfKrGH4BkWcocEQjksl+8Cos5YaJF+n6OrbSGAdqJ5fa24mepH8Vx+XdN0C1bvYb
         epv0dQDcilaEqF+67x3Jq7DC97w1NKG9EBm1StPh5jQ3qaO00bo68my0bPMNN75f+ZEZ
         0a+2pyogmL+8YSSGfs7mDpDc1J4OxxwkLcyUMS9e6QHNeRibGpFIvVNFT+HTmi3oC8om
         BiE7CaW1XSvewDknQl17iDk3+I1Lv+V7jQ6l4+/ItB43Abg47jPvIQXxTQ3++jq28QBi
         KG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9ztRV1bdsAUP6tZL+7Tyh0WeQ3qXgtEQOEYDTGXPYv8=;
        b=abNgX1u9OTRFq7KtxJfhRCbc8VQx5ktuj9BVr2Rnades1gZIvdLGxw9yddaPktKzNn
         CfacGwCjbBcfUWTjhPdED7gXLyHe3v02KvoFSQfJwM8dncnLWxC7ma6S8pCJPLwF93lk
         hJswcyKvP8IfryWezDE/LnMOjx6i+LK6XOLWQl9mvRVcOUP3/wKQJTij7dq4v25rBn6+
         EljZdAOC+s/OGFAB6QFX62ivSOrhW2M2MKa1rDzNbWZnhuuZfDijQFqfsdVO2OAjO4JV
         +i83TkDIdlxw4vPEdvZ6eha1RDV2NyFyBO6ZDW95mFC4sgtJuI19sWQp8Q3ELCK5SNgt
         FPMQ==
X-Gm-Message-State: AGi0PuYliPamd8ZNdqqnm5YtIKt3BvALCg3g7s+bCU2dX2VcoPGpEZTt
        lLZvvAAQi0LXRxerJIrgG1E=
X-Google-Smtp-Source: APiQypKwuXWf4Oy/mh2e8aDMu02EgFov5mTwroJu91tlrhJhl2THd8zhVWBgFH4lg/Cj5xxecBXW1A==
X-Received: by 2002:aa7:8e0a:: with SMTP id c10mr353371pfr.114.1587587744521;
        Wed, 22 Apr 2020 13:35:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o15sm90265pgj.60.2020.04.22.13.35.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 13:35:44 -0700 (PDT)
Date:   Wed, 22 Apr 2020 13:35:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/64] 4.19.118-rc1 review
Message-ID: <20200422203543.GB52250@roeck-us.net>
References: <20200422095008.799686511@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 11:56:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.118 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Guenter
