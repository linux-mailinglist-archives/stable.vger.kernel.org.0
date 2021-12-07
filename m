Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D853D46C4C3
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 21:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241315AbhLGUns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 15:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241172AbhLGUnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 15:43:47 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6D6C061574;
        Tue,  7 Dec 2021 12:40:17 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so420094otv.9;
        Tue, 07 Dec 2021 12:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0qk4gzOoofV3mybqyUDJ4DaX2eViFI35pJPT8HDOJvY=;
        b=aWsxf1qTybFkfdIEU+f1czVZGpSUc/uqVCUF38rYnycezmCD74zg/uyTcazZfsMSB5
         YdRJTC7XdPEZYcQbniRNXqHHTemCc1cJ2dlGdnQrcH8G6YZ//NjVx9KdZCH1YlgIeBL2
         CCWKlbDMFkDC9v9tv9ShXfasNjLNILfrd2Roja8rjMLQzyzYfg4wCUeXQjSZb3+pSY4r
         QewSwnp55GGliSki263RQpmtW95cJdpPZNXfIUPayG+eq9zQ6Z1N1QRGdYEeT/UrJ4Nb
         qbPHGVc4y5LqIGrNnCelNvMYXx1Cj0n9SlG8wqL5qrxVpxVEATw3+N9XyxU9tN9dD15F
         vMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0qk4gzOoofV3mybqyUDJ4DaX2eViFI35pJPT8HDOJvY=;
        b=HafL11jPqjSmww0qevlnbP40asuBm7+eqxFYLYmvh8tRY1wv6kzUf+Sm6GyYjUNA+L
         wpNPs+rx3pVI5HZp5/3EL/93yuWxdE/Ji8iqLa6m1fNDYyVwsHlpesUV4W+XU3MciBSv
         uHOQ/4ur8IZhoTA/SOcjpbfpRlRhpsTJwyPSDi2i3cSF7R5OzgbDzk/zd75xWNbp6xvq
         NuBHw9Is1lJt8uDykGGOp3Do5A1RCNLrdmTdN3zMSt3hVEG9dtzgREi9RuZeOzcjhcda
         qi09VvXcsB0KVvjpI5W/uEsJwAbwOm6MLQbbmWo92rP1PlxbphT0+o3edvqPVhUY9T8C
         KdJg==
X-Gm-Message-State: AOAM531rSwQpCVI6SulgUKzumaPnJ5tBFVUP/EWrtjtZ+o+C24iLdDGO
        ffX7n98Tg0zWC+zI2H1R/3s=
X-Google-Smtp-Source: ABdhPJwiKWz1/BQ7Gf0Q01whzdTMhE0gRIVsktF6Pw8i3Yp8rg1ZoH151VYNnHS7gOt3R7IFqCQIWQ==
X-Received: by 2002:a9d:12f3:: with SMTP id g106mr36979055otg.175.1638909616498;
        Tue, 07 Dec 2021 12:40:16 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l23sm131662oti.16.2021.12.07.12.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:40:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Dec 2021 12:40:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/62] 4.9.292-rc1 review
Message-ID: <20211207204014.GB2091648@roeck-us.net>
References: <20211206145549.155163074@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 03:55:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.292 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 396 pass: 396 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
