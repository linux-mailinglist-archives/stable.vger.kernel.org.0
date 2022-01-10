Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7048A3F7
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243359AbiAJXus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242563AbiAJXus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 18:50:48 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67153C06173F;
        Mon, 10 Jan 2022 15:50:48 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id s73so20797460oie.5;
        Mon, 10 Jan 2022 15:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f2MXYRXrZOQLazhFDn2ZOTFFNzCbZf5D9gOpdt/r0bU=;
        b=a8OLmamOPvk3nVu0vA55PWenq7CXN37MEL02zeqyjSfgNwCJTaXuOxaSi2T4dmu5fF
         1JcIy0x+yZN7QjNqCsnmY8SPSI2dj6NX2Xectb7g5Is8DUCTn/WWqbuzr00tBCKv1lAn
         ykQROk6TTPxsai0keBHISbh1fmh5gY2mD/mtvbHUcicxdE6JA8PhzAZywYId2F60KfHB
         lksJnGWZ3WC++arjq5etd6vYBqReFpwbThA8L/GbMAJK9CRr2jN2RLAAhJT/zDHrxQrH
         hr/a/VBd5jsdW/3x+TVC8GqPE7hjN4vQGi75P+l3gt5CRNKjjddOdhU0SHH3v7JkF4OX
         QPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=f2MXYRXrZOQLazhFDn2ZOTFFNzCbZf5D9gOpdt/r0bU=;
        b=jGwDGTewAAoErb6Fu2SSa3K0iO9H9YH2nOpN+age6SgSHSiBSZORgJDl01nvk4aZZP
         AFatRke2qUHOYfu1Fg+LDkO/GxIxiRDScvZLi0LZ58N3zaLyhJF0ZCGJRK+EmwGYAQCP
         hmFIIhQI26Kg4esHYY+2WXZt+tv7ebbON8wqjDJ30WwdAt539N02/JDHfugDn5K01zmh
         qvvs2RoYyiAyBBcMtee2sqYqNtdNiJEVPBTaI1/ZU9NYTuuFMUFJ78UjeIcHZRjP9C6r
         FmjCRsJpWxS0+8zJISutiMerl5U10p7ypQwFME/obGY1sLAL5EZVMeUwdDHOC6wk/pGB
         vuCQ==
X-Gm-Message-State: AOAM532sUunIqaTRPNn6IAdb+D/Od65KG2zGYcwpFWK+U4CJWNLVnWOb
        MQmfkSPSWcyNQfSFPpJjc6k=
X-Google-Smtp-Source: ABdhPJw/E2vIkSLcPEn2oZlFDMliIOImB05WyY4MnIFTxkm6EAJltdG0VzyhL4mc0IejQXNWISiPjA==
X-Received: by 2002:a05:6808:258:: with SMTP id m24mr101817oie.145.1641858647861;
        Mon, 10 Jan 2022 15:50:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v18sm1795458ott.28.2022.01.10.15.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:50:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 Jan 2022 15:50:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/72] 5.15.14-rc1 review
Message-ID: <20220110235046.GG1633615@roeck-us.net>
References: <20220110071821.500480371@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 08:22:37AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
