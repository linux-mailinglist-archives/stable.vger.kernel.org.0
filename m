Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDBD3C3307
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 07:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhGJFVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 01:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhGJFVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 01:21:45 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5FFC0613DD;
        Fri,  9 Jul 2021 22:19:01 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id p8so15105050wrr.1;
        Fri, 09 Jul 2021 22:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=Jtn56XLH2QkfaDg3gwg1AB2JcOKA++ICyx4Y04ZigbI=;
        b=CV8/BoCUCggAdPmhCBSsdRk+it7M5/aY/bMMjBn7FghfzE3FmI0UCgyOqVjRVi7FAQ
         lqHOJiZCy0niHpnbJiWF2bDc1qfKP7cQCPlGmXbObtYdK6lytu3vCMIlYIkVRjNvodpu
         z5mAjxILqLH0mf++ZU4mylU5u4nv9/Jj/gL9IJR+KJtfmykpT3AFdspewpl7y1ntzT67
         45v0VJzvONqA/kr/+fE408/1Nus1I7ISNzXZ+OSaG1rYL1DxIjm2owM0nC+YsEXXrQIb
         ZsVe9llhKPdknBVVwU8EestZDoa/6wqwJoZjHdB70ztgw5dE86fO+aTtcQIq/ZniMahQ
         sRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=Jtn56XLH2QkfaDg3gwg1AB2JcOKA++ICyx4Y04ZigbI=;
        b=cFi52FH0apGItG8gZQg8ZksrRK3EfCpTNVhSqj0DkhMlJoDDyXmTpALuFAQrFiJKv1
         37Z1nTcUnn+x2NcJIQ/G+Bz26T9aafaHEsRRZhUuDfal/Lj3tO36c/jMWvb0Ua1sRraX
         cOJzKLckQxpL02vzh4YP91BI0MZAgYXPi9uHcCh9nKB/zEPZn/yRr1Os7L2ytAD4htj8
         a8Yig7AbDziXaEpp9xUbd7ZUvoRMsaVB3vJym5qDkbED/YiV0JcBRlrtqIUwENlVlR8h
         TDTUjVyXGB8feLTdqRLQKp+56OSeYLANRl5TLIcllhvOvboF4buDhtLnCe+No4k9fq1n
         IAuA==
X-Gm-Message-State: AOAM531jtBqK/UporU2kEakKlOpGJS30SDaSg82YJ2OqOFe/Ecm1+nxg
        n2qpdM1H413KzR2wWyFfLGc=
X-Google-Smtp-Source: ABdhPJxDt2aHyCzWTNWavgeqsBRdeUXaZZRzCnaXR+bHXxtcU8Op+e8uOYL6+CqMWuQN0Tbo+TzbWA==
X-Received: by 2002:adf:ec07:: with SMTP id x7mr19360436wrn.262.1625894339814;
        Fri, 09 Jul 2021 22:18:59 -0700 (PDT)
Received: from [89.139.72.61] (89-139-72-61.bb.netvision.net.il. [89.139.72.61])
        by smtp.gmail.com with ESMTPSA id s7sm7268565wrp.97.2021.07.09.22.18.58
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 09 Jul 2021 22:18:59 -0700 (PDT)
Message-ID: <60E92D53.50704@gmail.com>
Date:   Sat, 10 Jul 2021 08:17:07 +0300
From:   Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To:     Sasha Levin <sashal@kernel.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 5.13 053/114] char: xillybus: Fix condition for
 invoking the xillybus/ subdirectory
References: <20210710021748.3167666-1-sashal@kernel.org> <20210710021748.3167666-53-sashal@kernel.org>
In-Reply-To: <20210710021748.3167666-53-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha,

Thanks for trying, but this is a NACK.

On 10/07/21 05:16, Sasha Levin wrote:
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index ffce287ef415..c7e4fc733a37 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -44,6 +44,6 @@ obj-$(CONFIG_TCG_TPM)		+= tpm/
>
>   obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>
> -obj-$(CONFIG_XILLYBUS)		+= xillybus/
> +obj-$(CONFIG_XILLYBUS_CLASS)	+= xillybus/
>   obj-$(CONFIG_POWERNV_OP_PANEL)	+= powernv-op-panel.o
>    
CONFIG_XILLYBUS_CLASS will be introduced in v5.14, so backporting this 
commit will break the kernel's build.

Since this patch was created for three kernel versions, I'm repeating 
this response on all three, just be sure. Hope I'm not being annoying.

    Eli
