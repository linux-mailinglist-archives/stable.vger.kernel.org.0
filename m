Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A721D1BD3
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 19:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389431AbgEMRDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 13:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEMRD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 13:03:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6595FC061A0C;
        Wed, 13 May 2020 10:03:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mq3so11379105pjb.1;
        Wed, 13 May 2020 10:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mteLG302SDv6O1LHZdZapeGH7XY/9R6hk4XYfbaGd4o=;
        b=tb4AK0vZ3DhX+9Grv0A9JGO2YmZyb+6M3JrE0r7yPbhyFW5aOdpQxOiuOreFlXYR/I
         X7kxYBb49oda8jMXFRKr73XZCEM9q9vJfrUpq0JMBLsYQZSeTBYuZ0SJa/JJchRoAGip
         XIy8tUExVfiBC5+A0DhfF10s9YxKA1r3szArRaVFsjw6C/KtD1tEzYyPEwXQz2PwSU5r
         xr4qH0FsyRkU4RFVM5jQudN0DbJqur85mYijIvgcscu4i7NqkxVAjpm68jLxfm6f9LFu
         GB2JjxOcGDg3LQlW6jxF/kFxcMnM2VCnv8GwzMnX79zd9YP7VT+dv6I8504+382uTj/T
         lEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mteLG302SDv6O1LHZdZapeGH7XY/9R6hk4XYfbaGd4o=;
        b=KBe8whj2f5VwJhsmlaRk+jHVlgMxyvVeRZMFcMa2WgmGPwThuePvJ9Gh1h4X7D/yN4
         ACqiDKYW6+kGIUNHH1iuMTD8cmKOngkkkjD/Aw+sq4/G+TiB79cXgqrJozV3Z/ZVVckS
         2CmFb4mSE3h+xi02hBvO+kQ0fUMQ+oJOrunzxKhROyd/MNaVOQJPWKytPATWKUtnPYQm
         9BYm0ebFrRnBGUMj+T18Tc1edKiKON5Z821DL+8/W2SSmgUIBhe6J1vcSXuigayhoyLm
         aS6PtZTwo3I2iZoW+o5mA/wvDbubIWvhLk9snrHsGPqDaxcDouJUULK5s7geF4pAFFzG
         AetQ==
X-Gm-Message-State: AOAM531wbjSZ7qOGRlNhl6AkobMbaKBAjInKkZfizAEPzfii3CMjV6KA
        k/F0eCVT0HWqlyVCwKtxG4Y=
X-Google-Smtp-Source: ABdhPJy5eXtlxGaOfurDiWAnsNFyw3menyB+3BAV06D7otLRifTvFYh+nNBD4uW7Xq4GrEZNJBLLbw==
X-Received: by 2002:a17:902:5588:: with SMTP id g8mr113400pli.321.1589389408994;
        Wed, 13 May 2020 10:03:28 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a6sm89225pfk.159.2020.05.13.10.03.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 May 2020 10:03:28 -0700 (PDT)
Date:   Wed, 13 May 2020 10:03:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/48] 4.19.123-rc1 review
Message-ID: <20200513170326.GA224971@roeck-us.net>
References: <20200513094351.100352960@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 11:44:26AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.123 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Guenter
