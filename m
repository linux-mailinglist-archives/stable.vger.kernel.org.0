Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1376A3DF541
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbhHCTRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhHCTRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:17:10 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DA5C061757;
        Tue,  3 Aug 2021 12:16:58 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id y16-20020a4ad6500000b0290258a7ff4058so5443790oos.10;
        Tue, 03 Aug 2021 12:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ppJgFgalLLd3Z886fs33fNQQGYiugvDWKYq+Y8ic1zo=;
        b=OJEmqvnjDTjpOpsfSEeNaz22Or15my9YXLic1XCbhOEKI+PwAezlE+W94CL8JAqlwT
         Q0kVkQXNdkbdKyjZZp05EKmZV6S5XDxPa8F1U+gnaV6GEmzOKsFajiIm2DJ2UmTB7y05
         6rIJQez1j04seK+RCSXDoxNedeIyREU1AxlGFrIKwoED5gkQvhFrXok7b71AGg0EqPt1
         WTZL3S++csBHAtWg6CWfmWF1z0mNx/Virv/X8HJAIe65XuDdT9RuIUFZ56FKuHobQAdI
         P2zVE+hJ186+MKtGf8gZ52prF6xxiJ15JQu3v5/7Ooer3R8UAM//7/nmLatT9gycOOA7
         xF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ppJgFgalLLd3Z886fs33fNQQGYiugvDWKYq+Y8ic1zo=;
        b=OM/tspS/JLZ8O1ySvYTLyN+EoPrimw+4Jx+ktkRQHxogt0BVs2TarzELSkHLeVDZOp
         O3+lVZWDGkR+kLiL0FUidtuVE9VJCyIB/Xrz3mUx7FX6JvglJZy0u8e2UNkW6f2SoE+K
         gBb1fFHGuRJK9XqE8YgCROVlpBRvrvi4dT6ruTy9nhlyCkFsd31h+VTpiIEn7A30FrGN
         4xDK4NFezVFWOt2+U8M/7knKxM9DZOESgHq8sNZtSopL2pY4j1eDDqtrBi8BBZyBjnMp
         Ix3+C4r2dCswZsJs0IlN7FbCgZqJf+wZtl66pjaHMf82i6uYhQ95Q5Lw6Qq9satjTf2H
         BkHg==
X-Gm-Message-State: AOAM532x69M05RGl0/+AAjeHPS0pX0weMieiEG3gIj83ZTTqRYAjKX8Q
        4BmGWi5P8OHLXGcn4AxRh1I=
X-Google-Smtp-Source: ABdhPJwy1seQF/l/U/7+g3k0qICFZ9CLdxfjtUeNSlKjchMrFpMj+BNuk5JTQcXJkI54MDWd2cfg4Q==
X-Received: by 2002:a4a:5dc6:: with SMTP id w189mr15618895ooa.1.1628018217958;
        Tue, 03 Aug 2021 12:16:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s25sm2576007oij.33.2021.08.03.12.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:16:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 Aug 2021 12:16:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/104] 5.13.8-rc1 review
Message-ID: <20210803191656.GG3053441@roeck-us.net>
References: <20210802134344.028226640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 03:43:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.8 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
