Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E01F290C06
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409643AbgJPTCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409245AbgJPTCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:02:22 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BD2C061755;
        Fri, 16 Oct 2020 12:02:22 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m22so3407723ots.4;
        Fri, 16 Oct 2020 12:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vfFHTKx08iZLbAJ+08AHrgQAlqd5kXpu8B8zYnPjr/M=;
        b=Heg2ekgGPuPdU8O41wMhpCdkbD++oNnyzpZ4Vluy81Ps6JbWQ8tiNtoqKSmg1/MO98
         t5Z2ZS4iv67CwC/dIAAJZTFHuFDDZf56iWRgjuuv8uET5/D0+jrKN5G3aOOjZm5sDAv9
         DDTAEC352bw5Quku4eW6uf6d91K29akdyMc7OWhu1XAQjLyP6dixaPv/v+Jd44FPLKb0
         gIDdT98VNpMVhBWvqZ2o9qC2RMWDTd9W7OnhdD8Yv6cgx2vV1RrMceiDrB/Llh/0v0EO
         mzX8rhSbrIC6Mh/i1h7c7DfqtE9Z24IVOewYxRwXt6zL2cKMA/z2iXh6PTjyKHgJVLOQ
         cc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vfFHTKx08iZLbAJ+08AHrgQAlqd5kXpu8B8zYnPjr/M=;
        b=k412PrSbuXsQBAf/Df+fv/VPzj2hXFMaYljjToCjcXQd7zyL0GNHEy8BekgN2yv6lY
         EAg/j+NXupQDtJP/g2/DR1H0cQFuCEZklhho9SIg+SHlBSfckT/+I8OegZ31G6LWA2Lm
         2VYgOocbozC7tLDct0Ampn7q6Nd46LbdFYaK04YGRyWqsMe7gWVXbcySmRuUMz3Oahwa
         +VtPvZMlCVGK0TZG067EHOw0Yb1QohzzqwEmeyEPejOxrWiPveayBmxnHR12amTYXq68
         PEr8u8po+ratFxj2Awxso7yhEiqz2KcMN7KSYwb8bZ7SjjjGIUxhwGZL8IQ5UXkpqytV
         tn8Q==
X-Gm-Message-State: AOAM530EqUsSw6uqmcVSnusjzRkD1LO06VinUjIzWDdisR2nnNHnuPMa
        8DqBSglqKaPc9E7m+i4NIgo=
X-Google-Smtp-Source: ABdhPJxuzlFcNhQedtdju3l6sii+vYhG64MbiyBO54XRmMkiTHK/NxJuCAgNE9ptgbh3pme1AHl+gA==
X-Received: by 2002:a05:6830:1df8:: with SMTP id b24mr3605666otj.256.1602874941682;
        Fri, 16 Oct 2020 12:02:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k6sm1209852otp.33.2020.10.16.12.02.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 12:02:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 12:02:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/22] 5.4.72-rc1 review
Message-ID: <20201016190220.GE32893@roeck-us.net>
References: <20201016090437.308349327@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 11:07:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.72 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
