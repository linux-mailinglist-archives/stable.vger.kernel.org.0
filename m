Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC34397F07
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 04:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFBC1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 22:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhFBC1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 22:27:01 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CFEC061574;
        Tue,  1 Jun 2021 19:25:18 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so1145862otp.11;
        Tue, 01 Jun 2021 19:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sxmNI2gtkNn2i8j5Q48ybDb0YLuu7cj+QVvQ8Fee3ho=;
        b=CrawSiP5HLG1RLGoHW9hwJKkhlpIGUj7ewXW16QOeqPkTw2lrpmV3/7rypTx8U/7fi
         jfHX6+2HuOVXAQXnnYTNlPOhqTCDw7jSMiCuNl+rhm1T3rdazkHsTsETD3ptAwF/uKWa
         C+MKyXRRpJYuWk8ETjZM+hHbYCVW/kPHd6wUOxMSozSM6l1nNwWzJhpdiVUrug2T0dxg
         amywoy9A/TPsJtNz6vkaTD3p8RVYYHlkr5dN9n3SUXOqMmaIk5+0CdxFa2w3sFQ/sdvZ
         neEbFKR1Aibw1HU6wPC8PnXS06/B5NOEhL27ZQudvSl8HYeVi5/hMr45w+OuKzbNi33k
         G/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=sxmNI2gtkNn2i8j5Q48ybDb0YLuu7cj+QVvQ8Fee3ho=;
        b=IAhrEg25547ZIqUoKjUnUI1egklGEJ7ct1FpOCqYSvyaNOrpwTOLkIo+MwBdYmfw9u
         +lZzaUhabORMOgy09ijyuzl2RgK/2cYBqlny3HLKNFQ4i+wMBlcc+wDWY542tGd66P+6
         Htb8WSX+4qpBnvex/xkJsvWD25pkP5A69PXXB075s4UbsJOITmLSQ333a54yjywHSLt1
         P0648Egu+QGjdaAt5ojwCNqenywdREtnMj+trO9VicK1SybeIhuhO+BlptrpV0gkYUYd
         qcFU2LaeJfneGuimNvt+IIIUukjBjQYfaJEOMO13M9IwuNyGZq4rNirZehh+qFUk4Bff
         a9zw==
X-Gm-Message-State: AOAM5316K2LwLSw5x0Ha66ezwoCYfYP0Yw0EGQXFBtc39rJFIn3ONnB/
        rsas76uzbysXqte4xlBv32c=
X-Google-Smtp-Source: ABdhPJzgmBNUH27/AQkFpGzAdMqenYfNyjo/3TTuqHzbGGoMRRxHph+/MK2/C/q0beKNxkJYRoA1nw==
X-Received: by 2002:a9d:1d45:: with SMTP id m63mr23795948otm.302.1622600717858;
        Tue, 01 Jun 2021 19:25:17 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q17sm537770oiw.9.2021.06.01.19.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 19:25:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Jun 2021 19:25:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/296] 5.12.9-rc1 review
Message-ID: <20210602022516.GG3253484@roeck-us.net>
References: <20210531130703.762129381@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 03:10:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.9 release.
> There are 296 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
