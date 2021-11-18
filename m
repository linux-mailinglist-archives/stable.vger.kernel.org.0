Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731764561FC
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 19:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhKRSMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 13:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbhKRSMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 13:12:18 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03C5C061574;
        Thu, 18 Nov 2021 10:09:17 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso12420051otr.2;
        Thu, 18 Nov 2021 10:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IcFB8gYjjLB7mVdFbNYINpla/WNywThwEFYJQ31syCU=;
        b=T3gAzIv3tCTr8w+UvlWLzDDRx440cD0XnGKxaT84YGbEKy7tA3CK/o0Kjq3hkNhZ5b
         Ojk3LtB4hqv2CEcUxyjI2lTZFMT6ZAvyDXGuDeqEtGsqK5RqX91L3A7MBEuWa89Oszen
         t9M9/7ZShHpXw9+xvRe9NIbS5MludVsdxw40YkI+0tQq05Ol2TW9UTXL2kLDqgtJwnF9
         I1ociPkNXUFtplU7kVUejEMUNRJvTLgq/Jtiros2ZJYNXLmGEobIWeH/Qq+tDCfoQ+qX
         sEGCctG6WY2uOPNzFnP/pjk4CM3+uo/5NxfJsa+UwhUFamlh/RCfx2DBh3fu1bgsQ52T
         aaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IcFB8gYjjLB7mVdFbNYINpla/WNywThwEFYJQ31syCU=;
        b=Sx6UL8Jt688GkmStjrEwXN0TNunQRDqyB2ijs+v6H4XHks02ijn63DWmBZQOe2E2Kc
         klEI+dcQxUNSZhKmMNj5IbK9Elr+82WwXjgrURMeDEGALdUmKrt6aPNb49AnaJym4lJh
         45jxJYUCzn4XUXPgOsgkPZNOpffmlUT8NEMe+p0Q6hhCktZSMnzGGbpomKHfpfLmmZQn
         ImW6dFwExKuxqSLdOk/7yRl0M7AFJtOcw38ogWUCjbnvBBK+e2KTGOq8Dio3P8YN6H/C
         HlBtBLk5RD7XLqOhnkP2e8AnB6c4PlhOkoXgVrb8ni0r7Z2YkII9JClyxEEDkuUXHh9C
         X45A==
X-Gm-Message-State: AOAM5303mOqflEIglKkgYaPk0PiZLdUiTNC4Ft96M8pItnAAjAnMzWsX
        SYE7ImJvtZG9RezCiv7joXQ=
X-Google-Smtp-Source: ABdhPJwyqfmI1pi15/e9MpErb1Dbtt53M3K3UaxFXzRiFs+GZSrITOoDrEINtGVWpnGx5R9Vp14Msg==
X-Received: by 2002:a9d:67d5:: with SMTP id c21mr22624062otn.128.1637258956979;
        Thu, 18 Nov 2021 10:09:16 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t14sm97598otr.23.2021.11.18.10.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:09:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 18 Nov 2021 10:09:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/920] 5.15.3-rc4 review
Message-ID: <20211118180914.GA3320814@roeck-us.net>
References: <20211118081919.507743013@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118081919.507743013@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 09:25:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 920 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Nov 2021 08:14:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
