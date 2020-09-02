Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDD625B200
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgIBQrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 12:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgIBQrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 12:47:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246BCC061244;
        Wed,  2 Sep 2020 09:47:13 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id j11so12252plk.9;
        Wed, 02 Sep 2020 09:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I4Bs5svNuGmbGsiBciaCwSFY4b7bKkZr2V0te0QU5fI=;
        b=qJAKv1+lnf76Tm3OtJ0n27i5+zY8JZd8kBUCYBX4aDozIG3NU8lDfbRjEjwaIoCJn6
         GxiWRo2B6cKbZNgeLQg+cFBnBoAEg6Wuo/Ammk7PrZb/crBhDAii9jLmLfbSv/E6PkoY
         PQr23PJ5mUBhva1kfNLwikjhQd1FzpHfIjcgYISklk2VYJsy6kLUjXEqlsxWTVSJQr8q
         5UgfqaxIeQP55wFEESKMCbpfh2rAVNE/R9zJrIFCwSq/+1iJaKPxf3+3RyZzj3BqkHde
         X7fm1uZjDfy70bT4oeeL3iXts6NaGfROkZo2EufG9Ansajd56QBhM1t/9Js/fv6RpGvA
         SYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=I4Bs5svNuGmbGsiBciaCwSFY4b7bKkZr2V0te0QU5fI=;
        b=lUw/WL+7yw2EhTj15YQPv89wQfOGA20hNQxgK+ezMiA/GJQj9ToryKAo0BJiWjV0qY
         fdC82rBefw1okjZdbqv7103H2d3VOd2wWvsPuaE53RY/F0ITOAJs3p2jKl9QS7pmniRx
         NvrLvF4dIrv4ldWexPxhAMzbtUYbyDg74NAFkR8dUl6yunkhoDyN3ncPPx/xSDz27TSX
         uBpkKuIkuqSceh763hrpl1kdnqUwselT6u0OqTHg+nd43M4dwUrNra0/m6s2c9icY55q
         zpM0Ru9DpqZPLzfYYVIAT/UmgJtmxUtAhTbBRrfR8q5HVo32YmYHMkhciayIzq4pHSxR
         CB7g==
X-Gm-Message-State: AOAM533zquyQpry6HJFw/bOLWPKR2eW0iaIElgNkEctrXaomZSJ96pUi
        uHrS2FiWyRy3TPpficfoNbVfc75JymM=
X-Google-Smtp-Source: ABdhPJzrRexNEr4o2b87Vsd//1ivvJm/5isnb5TZiJxJtdRiwCMquiFiD72udz9FX4Oow3Ch/JBdBg==
X-Received: by 2002:a17:90a:9bc1:: with SMTP id b1mr2947694pjw.17.1599065232650;
        Wed, 02 Sep 2020 09:47:12 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id lh6sm5068972pjb.15.2020.09.02.09.47.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Sep 2020 09:47:12 -0700 (PDT)
Date:   Wed, 2 Sep 2020 09:47:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/125] 4.19.143-rc1 review
Message-ID: <20200902164710.GD56237@roeck-us.net>
References: <20200901150934.576210879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 05:09:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.143 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
