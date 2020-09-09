Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3FB26324D
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 18:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgIIQkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 12:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731044AbgIIQjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 12:39:46 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37DBC061755;
        Wed,  9 Sep 2020 09:39:45 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n61so2824173ota.10;
        Wed, 09 Sep 2020 09:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7vBYcMUZyE/2A0iX4L24J7CEe/LJzQutosS+dhDIwwA=;
        b=AGsrjNXjzd6/xuttkG+IzxgAOK544pefabIZQn4ic/pcwMLIMcvJ4HN7WQLY9MTn75
         +p4hnjcVUGpZRtP0yCl/PSJp4Ayrj45y+7ml7YCdj7ovWQj1T5dmlcdJ0BdvnT4tBf0+
         5PIH55eLjcw534jhGWSnnkmasEXfjqJQPjwDTHYlWxeY5atJMstFsmG0pdOV4bkrfCP9
         gU8kj0//pAGM2JftQW4XkuYN3Uc2MXjTMZkrsMBdV9Rq69WjAtdX4Dg0UObRGn193z6f
         1evUe1Iw4AFANHGlpVZqAJwAlijonkMHLz4HMM4Yjk1o36b1BARq+F7MsKlwo2EEF+Ho
         fegQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7vBYcMUZyE/2A0iX4L24J7CEe/LJzQutosS+dhDIwwA=;
        b=mNLL81xtF+WJ4PtiMchZsJqGT90BceyujAlNwWLZ9vC95UzNdeshKLD0EdDP2DHzqe
         Z4CQzh415SRsLyrz0MNiDfYEQFA+S8D+Gbg5XOoGQLANe/aHPWbQ2SplL2yr1pIDVeVX
         PhqQXY6yzexY6fDiWxWyS10X3LErP7PjwOHea7ul0fQq0zq0x3jCMTSMldkhkxUVh7c9
         /64SYtgnpB9+rYk0fMmEoxiLU3qFArNWzf+SoFywZJUt5BCe+XuQ0kLd8o1tQ4k+y7hN
         KMmW1JGt5R91xfRo7Z3mV1GXXME0n7OV3iqxflgo42ugxG6v+jP3PB8jHaBGA4wZHpzN
         PyBA==
X-Gm-Message-State: AOAM532Xua4Hcrr1M6ME+v9B20KYcoa1FWseESjFNmEoMFB7EAV4u2yr
        raMXsfW51IwMYqQFa6Jd2Hc=
X-Google-Smtp-Source: ABdhPJyyk0ZNRZSr8wYcPWBdLbBVeOIW6JhN7DKm4Cp5USTwEAzaBWQNJnb/h6PLKDbuAPA+wUflNg==
X-Received: by 2002:a9d:14c:: with SMTP id 70mr1285863otu.369.1599669584322;
        Wed, 09 Sep 2020 09:39:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u15sm300295otg.78.2020.09.09.09.39.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Sep 2020 09:39:44 -0700 (PDT)
Date:   Wed, 9 Sep 2020 09:39:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/65] 4.14.197-rc1 review
Message-ID: <20200909163942.GC1479@roeck-us.net>
References: <20200908152217.022816723@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 05:25:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.197 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 

Forgot:

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
