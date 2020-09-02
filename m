Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4AE25B1EF
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 18:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgIBQqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 12:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgIBQqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 12:46:11 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41071C061244;
        Wed,  2 Sep 2020 09:46:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o68so3158382pfg.2;
        Wed, 02 Sep 2020 09:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4Hh39jD8FlM3rEbUxChunRxu0EG/BCWjxBrQDpUt5RY=;
        b=UukQGiWvf0viQ+Gb7gZDBNGLFJcCtfeLExanwqNn/TyMs/w7QOjEBtoXIiw/RE/iPL
         jKwFER2GVOXlVPrQzukS98q2LxnKdAe7TvjvNvcVmmzF2n3RbOIBqhe3wDeRVI6Weoaa
         h6oWHFRFptgW9C0MV6itE6VOK3VXecm4umSw+scZrS//YGc+mXxl25CrvzBFq9nHcwqb
         7TzaSp7mz84QQqEFLiweFe4dDVMlQNdsaBgKdX6Z0lVauMdCJKChiHdLlroyNZG5Nyt/
         B81DJY5IvmE0lErLmaGgoUqrSZ5QxH9yWArAmeENJtvlG2YHSuueDQE/wLqQLA/DBrPR
         UZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4Hh39jD8FlM3rEbUxChunRxu0EG/BCWjxBrQDpUt5RY=;
        b=BssiJLEKpXmWYtAK98pqCt2wrRWiLdghKkdGwDeyUaFMhE514lR/W1FSJExJ2OSle1
         NcN4pyPnEw0ksO+WBfQQK+vs9PCXevxaqj2HemSs9OWpCMHym9UNCFKLeTOJR6o3ANMc
         AQN9RGw7u+IJW4abC9BRYtYYyIGOFm74g+rmgzIttzMNbkV91uzb5Z2SzgpLkE7tRt3+
         yrB1yw13poiPXaoa13c4UXANu6j/A8n2jhVj4goDd85HYWUjsBBkYa222qYoBcL9scQn
         /l4u+Q4fXnpX694Q7AI3XBjrzqt7/Mk4i0Y0jNgW/9uDAzMotOAJWT5/2p+blVtJjA1Y
         Ufeg==
X-Gm-Message-State: AOAM531plWBfgYayeXIKd/yNY9QDzO5lxOeyZ7De04Pw1+B6B6XA3a4w
        ReIx8OHUiy2ieEOFWzD19kqB1UyPGZg=
X-Google-Smtp-Source: ABdhPJwb13EKlBctpzL8nrzztXXfc8MuRvMHxDVqBXRO3D992wZKuvN+8cJ66s/jVa2KXSqw66PRYA==
X-Received: by 2002:a63:1b42:: with SMTP id b2mr2373494pgm.397.1599065170859;
        Wed, 02 Sep 2020 09:46:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q9sm19117pfs.42.2020.09.02.09.46.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Sep 2020 09:46:10 -0700 (PDT)
Date:   Wed, 2 Sep 2020 09:46:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/78] 4.9.235-rc1 review
Message-ID: <20200902164609.GB56237@roeck-us.net>
References: <20200901150924.680106554@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 05:09:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.235 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
