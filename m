Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DEE44DF7A
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 01:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhKLBCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 20:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbhKLBCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 20:02:43 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68136C061766;
        Thu, 11 Nov 2021 16:59:53 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso11489510otg.9;
        Thu, 11 Nov 2021 16:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Shm9sJi3PE7QlxR4VGJ5zzobrIXxOkhAqBca5txzeDg=;
        b=LSs0UIZdbELZXUwqozDLrTQNWW2f2OG8fIOhq5M4IRmdfA1tzOGKhbbBnw8kDLpml5
         XNCiWq7a7vZqL9kmiXYe8BHpoRD7FmwxDS+hn6q7cygr16Goerj4J2hZuHvLxP1WmJeI
         Dyvk1wjsYj36raKv1E5lxFSf/dt1E30Ofn7iUutlzp4BeKoXsY2uH5MnBOBO+GCTHHtF
         oTQVeJeYgJeeMWjVA4fScgBMAsRFLIEOkqZdriub2retxW8Q+KxxYRKlz6m/O6Lc+Sp1
         g+w1OmuANKG0qF/Ivc2lQ27BNAJQKV1qdzzh4cOiqZ/BKcdiaEUT9N6dVYWDJRaTUeJ8
         k5Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Shm9sJi3PE7QlxR4VGJ5zzobrIXxOkhAqBca5txzeDg=;
        b=OLrQAVH57hrjx2ljEPSaMmwIguVRI2OCHEhrYOSGZDBiD77IW87ZL/BliVB/0Zd4rg
         tbxwW0JUjUbgkqai1IceZA4b8VApjmGz2hPwC2RdtfKIe8cp4g0SDTV/9PIAYuMg0Xnb
         JCyPWKeKlYiWH3+297YSpUDTLQ0kM0B1Ep4e9eAxvLkDvrJ+WrvrECPWA0hjzMLx1Z7+
         Pf8t3SltVr9Z/6ZnzuHp381ZoQZ33QoAVQRQDgAkCYnPo3U6tU1NmC7QvXT22yAP4XiZ
         EADaXGiwM88TyF5WHJV64JoAmYW1p9+4DyhB51Wo3TlcHaUgR/Vl+rNtoI42wu6Ks6BL
         EKjQ==
X-Gm-Message-State: AOAM53012EVTDzhn/mgjy77WeZiOe3MMdy6BdRg8G78aCQ2YvawlGZ9w
        6lN6pijg8Q+TISwwk1PUFTY=
X-Google-Smtp-Source: ABdhPJx3pBMZTPF8yEzYBdXW4uoF/WR5bZ4pwmMurHT4roJ/obskSy7XSZEwCOds2A0j3C0+u2UnHQ==
X-Received: by 2002:a05:6830:441f:: with SMTP id q31mr2872698otv.164.1636678792878;
        Thu, 11 Nov 2021 16:59:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8sm938373otg.31.2021.11.11.16.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 16:59:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 11 Nov 2021 16:59:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/26] 5.15.2-rc1 review
Message-ID: <20211112005951.GF2453414@roeck-us.net>
References: <20211110182003.700594531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 07:43:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
