Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E89315607
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 19:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhBISbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 13:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhBISYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 13:24:41 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DE7C0617AB;
        Tue,  9 Feb 2021 10:10:18 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id d7so16054431otq.6;
        Tue, 09 Feb 2021 10:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BRmonsXisd21CnA8y5uSVP2bPn16H0B6KUMehP3zZVM=;
        b=r/18rHvOIAug3+X4rYvckSBUYLpGaxn0lnDvGFvFJTbU4aeNUFILjQP99k0DsjeZdb
         piWXtwuYDw07xORhLBjsFRYHy4sBpZUp0H+txYR7NXnlmJVXJHNx2dWB/3i8GUk0HKwU
         IxBB6Kj+imHlnPp7/FBzIMF1LSNT4HiCM+uXXBe3223UqNNlMyDgwfmDE6fDdwvd5E8e
         sWHWOiNKgKiqWt8sjxJdiu4ibAe3gOgPH/7jPdQE4ZdnWUdCmU5UMlPxPXmKa7pVbLeM
         XIZwMZUdtstVwWs6pAQqyULwI9ZjtJ56GRh+zz83/6kTYHXsRnbGUxatPZhD1Qwuya53
         fNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=BRmonsXisd21CnA8y5uSVP2bPn16H0B6KUMehP3zZVM=;
        b=M6QpiPk7hNkQsHjA9rXXkl3DiPyPZWuIMOObUjNEbpBD/sKsW73dd7lPgbM5qHqhX2
         mSzTB0A86WlHsYCvePc1PmcjKGD3eqf0IcIjgYPD9vECmVZ6cPwSVFcWCoIu6FGztJI0
         aAK87YLFi1G2ogqbnATID7w0WkALF6yagdlURYKDVTrxZCXVH1dWK8zNVEHm0sp0uvmq
         1OBos/UJVKdsswZLYhq2WPCSKfitjW7h7NPZGnP+B2l0bmIUeWKlEdpGvEl8hHtMXc1l
         T7SRTxn3UKakmfWtv38XTsfXaktAOdOtC9PvoGbWwYG4J+6BhvTSKcVuZR6EFEzD1FdU
         i7GA==
X-Gm-Message-State: AOAM532jPEjyWuQshU1bYT4KMIZUOLAA2raoaKIjbd2GBwsg5Gu7dwop
        FPj+hvsB5PFObzVKs43k6sI=
X-Google-Smtp-Source: ABdhPJznomZt384DJkwq1Stmy4ASb/tlcyypj7mo2LygPTQv2T9ms4+rTtMWQBpimBfN4hOHEeIJWA==
X-Received: by 2002:a9d:3b26:: with SMTP id z35mr16409685otb.192.1612894218073;
        Tue, 09 Feb 2021 10:10:18 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v10sm864291oiv.13.2021.02.09.10.10.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 10:10:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 10:10:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/43] 4.9.257-rc1 review
Message-ID: <20210209181016.GB142661@roeck-us.net>
References: <20210208145806.281758651@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:00:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.257 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
