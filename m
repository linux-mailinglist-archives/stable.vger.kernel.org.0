Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F244657F
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 16:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhKEPPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 11:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhKEPPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 11:15:36 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039C7C061714;
        Fri,  5 Nov 2021 08:12:57 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l7-20020a0568302b0700b0055ae988dcc8so10328908otv.12;
        Fri, 05 Nov 2021 08:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m5EQkUNmVSVZx2LcChoWjlZNlpCzKYh9NH+xf06/6ik=;
        b=hY8sM6ta0ppMS6FEV56Y+X+sOh0vZL5HHGp3IZIc4jZEB+t8NnfBKFN8XNnuQOnDq3
         J8Kn5FHlUGCXEBlKNU1L/f7uoG6l2tIhzA2t/ET+O5hwZ79zmbvuym8zxiNWg0p9Rg4B
         RTf1oF0XiIwibywDb6TGOo17L02Q5KzgacL6NEsJYx6+ZDROKhUQpR/VBQI1IEe1AatI
         2yQMAgoJ1Nl4pRgy3nNS0d3KKkyPZ10e4cZjvz9+L0Jv1Qwz2YAu0HHrFin/C6mJCP4y
         YTU9vXpM/Dtj2fxHjIbazNn81iahJaTweIr6SIsM5juzaEcffVmJfO0d7gXmacM/KEHK
         FkDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=m5EQkUNmVSVZx2LcChoWjlZNlpCzKYh9NH+xf06/6ik=;
        b=noXjISEB+Y1mOlE3dBzhh7UfWKK7ZPp0Pk8ml5/dCGf15Bcj3T4eWzkWayYOeW/HB9
         LMDoW1YddSHlE94CUYng5gkZeBehm8lA489BJfvbh2qyDiL0JRRbnwbsTgjaaLriIfdi
         zp5U1SnJhEW/zZgsPzO7Z8NeXJEHJg4WH6Wb3tlMIDT2xfRSYMMaHdw0P+LX/4ENRkTZ
         8b5dcqJM4aGhQoRg5WY33YETP8qgAgDo0po8i0l4xLAIxEZaevhc2P5GhbRwMxuFXhBo
         hjO2HhEc/4idJla2NdmIUnum8lJgrE0gzm8JIjVGqQiKmIewWGUH8/SIXjDkKGSw74/P
         gTzw==
X-Gm-Message-State: AOAM5314WxqU2faXfDSHzEuiP3mu7TJC/OG79Ad48xcbxTpAriOLgkzC
        okdfAvL8NKG2Aem8LF+9PzxSnCcqtDw=
X-Google-Smtp-Source: ABdhPJwY6groYaXn9c6U1k74h/XhhSmtSK8LkoOoGwUUlDGtN0mvNGsKiSn5k//Q/8m2D+TUyLBirA==
X-Received: by 2002:a9d:1708:: with SMTP id i8mr29668939ota.178.1636125176333;
        Fri, 05 Nov 2021 08:12:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m6sm8787ots.5.2021.11.05.08.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:12:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Nov 2021 08:12:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/16] 5.14.17-rc1 review
Message-ID: <20211105151254.GB4027848@roeck-us.net>
References: <20211104141159.863820939@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 03:12:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.17 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
