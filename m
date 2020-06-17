Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269571FCF3C
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 16:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgFQOPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 10:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgFQOPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 10:15:34 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E228C06174E;
        Wed, 17 Jun 2020 07:15:34 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r18so1330295pgk.11;
        Wed, 17 Jun 2020 07:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=llbvqScGaw1SQLgsvsAnASkmPUngs70hBefpUE/B/a4=;
        b=HG117iHYLZN5d1cJQIGtYWWnoemquZ0+C3cPB6hx9eeQ57w9Pt61ysa78By8ApETzs
         irghr2i6rEhJ6oJiymLu3ID8hucSubJ4s0KVppIvU8J0IXsHhM5Y8ELPTP9gD/PGmL6h
         4pME/1AlSni7YTHY9ueHZrDkVCZPqDQYie4nr+Vh17R0ddJvsbTo8wYNZNIfSkI9eG97
         as0oXucfdDYTLg52IidQJylIUYdQgR2jAsY75zk5S90oSzsHP8jK5Dyi7VV1az/ZwE5r
         cNVvlEEhfo1U9kmJ71yDmgopLs0UOWFXBj+9ngaBHnhcYddod5qwIibGOftvM4p7YWm6
         cJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=llbvqScGaw1SQLgsvsAnASkmPUngs70hBefpUE/B/a4=;
        b=Zag1UL/X7z4d3Dt64JbuYbD9AY77ul1hT4H8esBapKSFAHlev7iqR40x7MN9scOgjq
         wkeiQ6sxkdtlJOrYfur59q+j7/09NLLL3myjGYGzyytSWudiyvUdBHp4NfubmTMcLyGc
         n/iNyohQ9x+//nBfS9NsXoqdAH/xoE2XNd9n8eGygs6MjsXhMc32x1C69hlS5GEBpyiz
         rJ/JhUh8LogEXn+HbxDq6uwWd2NxPOl8EnOZc5gNl71w2t93IQSE1R0h41Aumbcw09Aa
         S/QTdE/a2HgCOUQw6cDqyMrrTHYfiFGfsDZEaoAd00oNf32COCNlcFDyZlaCMV6dzBTz
         me/A==
X-Gm-Message-State: AOAM533dY8AtyU5PS7gi9oCzJk1n2QOjciSR9m58UgXQzvzrPja7i6ME
        ulprLtpPHJEVpftRiEUBEV4=
X-Google-Smtp-Source: ABdhPJzhZBUZXNW8DEqF/16C68P9Bf38thJhQNINGAw4tVf+XXVuKgq1pp/ZYa2VuUqEANRxXcaacQ==
X-Received: by 2002:a65:534d:: with SMTP id w13mr6341887pgr.18.1592403334093;
        Wed, 17 Jun 2020 07:15:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o16sm82256pgg.57.2020.06.17.07.15.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 07:15:33 -0700 (PDT)
Date:   Wed, 17 Jun 2020 07:15:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/131] 5.4.47-rc2 review
Message-ID: <20200617141532.GA93431@roeck-us.net>
References: <20200616172616.044174583@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616172616.044174583@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 07:27:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.47 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2020 17:25:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
