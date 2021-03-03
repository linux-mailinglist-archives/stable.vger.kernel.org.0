Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AD432C835
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377032AbhCDAe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387972AbhCCUGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:06:50 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A217AC06175F;
        Wed,  3 Mar 2021 12:06:10 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id h10so14181845otm.1;
        Wed, 03 Mar 2021 12:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PDkU+/EuFYN6TjDhiI5EZrWVjyFG3A7qSvAeShWO9YY=;
        b=AM1cHVPYydPJDu86uomptwT4217mlsc/UDB3OJ4TMngtyyU+GQm9Ce6zjzzeGVhrTn
         EClJcIYPi3IngjaYUZnXyZ9dw2GVBn6KJlOFo6k1wY+1L86Gw5LrDNCu7MEq0vw/zMu6
         aMSp3Swxt9KyZJJ3m9k5PSxMfavXEeKoRdNANxmJn0XV/akGUqRuCVY4NJH4rg48u+sQ
         b9rRkawHQcOL0cxpNnK6TBH1f4ScO1KGk4Otj8R7w1JfIic8FgI81tE4ceWmv55iDnhk
         RUyUxMZRyTUk0W5JH/zg2zZu8QsT6n4wRnWIqQjmxKhsT3jk+OYyf0dsHPWCMxirjdEo
         XyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=PDkU+/EuFYN6TjDhiI5EZrWVjyFG3A7qSvAeShWO9YY=;
        b=rAkctkwz33VaT+VBprXRZwPUGb9OYonyNwDVu4hZMHsO3RCDTV5kJ+i0p3B1EeuSd6
         l4GhnrjqGQSG5jWA/CqIw6tZVrIMPPlareajAOph7u9vYLJ1eRqvmvNfCTabb/ASPVvA
         csjxg3IKKi4/LkaGlKk9iWxGlgWWX+7knyhDfT9p0CllDh/V8EALHByPlqi6HoLDYEU+
         ERzkICUctZTohDDqyulcnqg5fABpzPKNtlpUDxClfA8nEY4ODbbUNDP1zxeVyEYBDMpi
         UEOzHFlGmrDbuv4UIs7k5ef+Tp3H/Hom0UGvS9+5tSvpbVAuMKdcmF0wQKqw0Bz/Xg9b
         a/YA==
X-Gm-Message-State: AOAM5335A1N+q/c9MbGQvamfzH+ZSXyM1KVwhuOTP4GZhZoGapoKdnSj
        agl/egdUTAiWg3SoPO4RAP8=
X-Google-Smtp-Source: ABdhPJzVYLXpezeHK8zelVrfIGDPdyGbTVqz+tUHRTCinin+sEhPjntCxJHEhycc0jVU2P6nIZQT4Q==
X-Received: by 2002:a9d:6381:: with SMTP id w1mr640181otk.236.1614801970139;
        Wed, 03 Mar 2021 12:06:10 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t188sm1742685oif.19.2021.03.03.12.06.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Mar 2021 12:06:09 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Mar 2021 12:06:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/134] 4.9.259-rc3 review
Message-ID: <20210303200607.GB33580@roeck-us.net>
References: <20210302192532.615945247@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302192532.615945247@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 08:27:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.259 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
