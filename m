Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F387F3015FB
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 15:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbhAWOhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 09:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbhAWOhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 09:37:08 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB90C06174A;
        Sat, 23 Jan 2021 06:36:28 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id q205so9487110oig.13;
        Sat, 23 Jan 2021 06:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GqPtkkgCREVcp3MYTKPhmMzRJIpw0BX30WRKahk5j1I=;
        b=FBvveBuG0u1FgX77jzJwzndpOkKm5oBJa68rVB55wXCJN0M+e+Y6iMiBmffCfRUUnA
         piW+nPq4lQHj28q2gALJeQzUTWp1RB5l1T6IBVMt+YU+4eXJG9AsiOojdSjRIc++K0pv
         aFT9FpGfjP0+BHrwjUtIP9378hSjmZfqsJlmldSmUfW+QsbrcL0WwbAnNClCgic4GeVt
         qpbOwv8TlE6Qc7Jgf2a75yggPZiWg//9MMekh9SQwgmbKqpgBNP7kT+8ZUeiTgSzBURx
         G79oK7mp/qhIxHWlHJUGYqhUBpexAcukk27GoRteUmoat0yVcgSMEy6XDTpDhDnOhL4O
         1TqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GqPtkkgCREVcp3MYTKPhmMzRJIpw0BX30WRKahk5j1I=;
        b=LnisIwG4UYB+2w22EM08APCk1vtR6CNO3vA/3qZ6lIEEspQCY15nSWW+B2GkLH9SDp
         dzEw54KWrhkfYI9kYSdYzGE2eL/x3jgen4jFioGhAphMubzk0uhmUpIOwEKXlufZsXL1
         wSwvx3AKy5IVw1OXkbmB1QUTzJkgBCZVnqchy2sQ19xVNxv5UBPsIq6ACq/6SigAxpXu
         TNA96QOdVvAeqXm1J2E3i3ExBJXYaKtXg1S4r/r6yS0RzLwHKqziGwvMRayHfa3Rl6Ft
         Bf77Kh+Lt9PLjoyNT63wWlsMkRWhWUV9xlC5yX81e/nTQfp2vi1Wdpmiea2ahVGTwnFA
         XFrw==
X-Gm-Message-State: AOAM532G7dK/gSosP+8EViHLpwk/F5RDOQWxJ6lEv0OWfjWx6qt7zyz3
        Of56/6TBbFCaKrB7KBDqZq4=
X-Google-Smtp-Source: ABdhPJw5WeRNE5nWvBdiTMraeun1LYp8/yq1lcBPO1ymT28zAeOo/hyTtxve8Gldhl3k0wPmM1zR3A==
X-Received: by 2002:aca:7506:: with SMTP id q6mr6025637oic.95.1611412588010;
        Sat, 23 Jan 2021 06:36:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k19sm1443755oic.52.2021.01.23.06.36.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 06:36:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Jan 2021 06:36:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/22] 4.19.170-rc1 review
Message-ID: <20210123143626.GF87927@roeck-us.net>
References: <20210122135731.921636245@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 03:12:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.170 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
