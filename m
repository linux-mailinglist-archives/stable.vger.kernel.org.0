Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE0049D419
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 22:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiAZVFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 16:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiAZVFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 16:05:49 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D598C06161C;
        Wed, 26 Jan 2022 13:05:49 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id p203so2003445oih.10;
        Wed, 26 Jan 2022 13:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gNQC12hn9F8dVuK4M0QfVja0uPmD/mvPu7aoFuquqys=;
        b=dQLGqTCj3pHnUzAT6aNm+nbShXkH9hvS96P2BFWxjVznEoqriOCX/e45/awpNgrbuH
         Cpb7aERrREbi+6D696PcO5qa8J2WCAYVEQp90HbzzKEceHH2VvExQsYc9CceUnQdO1NP
         WxjwJzNC7NfXLmKtbeskKK5E16vtj2jbpoCm4JhlmzXWYS/srHdPD7rFCXiX17Gn1lzF
         XJWZfIonLM5x84yfb5F6Nr3vRl/hkGEpDTG71qolp7xDQf5AuhS040uoPUnhmqhFxWe3
         n3uHhPJfkI/1Ccm4aL41wU/NjtIdcglOz4vVU9rbR9ncZ8DIVQFFrPhovxAHuRxXGbmS
         2qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=gNQC12hn9F8dVuK4M0QfVja0uPmD/mvPu7aoFuquqys=;
        b=lyRqt872GGDncV7ELPvln6F8rpBnf9LHt/JJndAObE+l6k9XLLBtziOC0MXrOG7YQ4
         MkZ0ZQFVILSajcn5IshrhWHAx0yb64UYhCsOiktBHWnDUQ+bSO75dAPC5mt5uKwZiips
         o0Cm0TsMFrCN31HwEyV2mH4sFRf8g2mS2Dijp2ym0zF6SCb/IVLoD5hjX27eNmK7gCMQ
         HmD0WP4F6EIrMie3qv6w1TVxXEUylyeBF/ajyp13ndlMb5R2ag8Cr7Ajc5EUK8AYn17z
         GY1cCovT1/FNo+gVkC6hqYBPdl/nzU+PxePA0AIws0icLGlc8k8XVsEqLXcNWAM2U0Js
         nl3A==
X-Gm-Message-State: AOAM531wr/iTvXKwdtVcCBhuGpqihua2dM0sZREwGBzXDXGUIMe2ky23
        qmnB06Y46YaPnQIsV35gYnnZcPVzBPM=
X-Google-Smtp-Source: ABdhPJxd2XmlmTYvu3V+cerEFa8gxtuZv3N4vthizhbsO5aLxLiyVjKv4O9WbDIHcpka8maTWKCZ9Q==
X-Received: by 2002:a05:6808:2128:: with SMTP id r40mr34898oiw.96.1643231148628;
        Wed, 26 Jan 2022 13:05:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b7sm8012217ooq.30.2022.01.26.13.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:05:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 13:05:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Message-ID: <20220126210546.GA3265892@roeck-us.net>
References: <20220125155447.179130255@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155447.179130255@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:33:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1033 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> 
[ ... ]
> 
> Chen Wandun <chenwandun@huawei.com>
>     mm/page_isolation: unset migratetype directly for non Buddy page
> 

This patch causes some of my qemu emulations to crash due to lack of memory.
This is seen both in v5.16.3-rc2 and in the mainline kernel. A request to
revert this patch is here:

https://lore.kernel.org/linux-mm/20220124084151.GA95197@francesco-nb.int.toradex.com/t/

Guenter
