Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9A94184C6
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhIYVwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIYVwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 17:52:17 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA9AC061570;
        Sat, 25 Sep 2021 14:50:42 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id v10so19762202oic.12;
        Sat, 25 Sep 2021 14:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lra2EsvoeNTlw4NaYwSSQUP8cZMT8qJ1eGcHRJ3D2wE=;
        b=g0Qs4UienYUHrVXCnAB2YwUTeDYgyXn5TSKEDxTBkR68SoDQP4mHVdZ2DOzE17zLwC
         hxiScVxCix6toZVjbE6vi2966ndXqnKXNRn42+KJcGEFk8y16TCANQ8Sv2yFOEVRrIB9
         7sQ/9Bb4LTaZ3IXf37hC7y92rs3BQAIscvlP3POVxrptF0RMybAXTCEmzwMW2aLOmusl
         v+Yn22whm6DsKjzHCrDRaLfXDLNfKiZobPVC1E1VJQYM7aykwljBFFXS9TR2mY59HBo9
         OMWj+u5uKd20yEAApRRKFlqeZ6RQLORC7ID47SeLaZvK1Gw7x3Z35lnoCcW1Rd17eC8L
         S8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Lra2EsvoeNTlw4NaYwSSQUP8cZMT8qJ1eGcHRJ3D2wE=;
        b=5K6m3bxPH9+KFUijSJFe/0uZiKiKgJNL7pgTqi7xLwvAXylEpSaeySUQlNwYwA2HZ8
         h2RL0xBqfCJujvWPjZKWlkUX4jAktJIafa+huzQYI/OM/gRip7zrOYpFEs/BU41iCAyU
         J2Ulhu1zgQJDPtdUt27+Xm2gLZrMM8qLZI14bZTL23ymLyaPG0zHETdOlRbymqPEeCdx
         BCJULcO/fKmBe6uaq5Jf3s9C69lIjifYjdNw5AL4iENeZzz/jxXJEsKVXVlh31T2Fvqr
         mWmq37bSD6Ij029icBJIcR9fJKhqMaipiuaNQYdi5dKOCH8Wo9RGho2tihXfS95XcZGP
         KEKg==
X-Gm-Message-State: AOAM532nzOObNoYBV/S3XE4BefEjFx3sbtP4fDWR/s+0cXxxEBzfsMZc
        eTpipKyJy8HdkQvzI1ko96w=
X-Google-Smtp-Source: ABdhPJxn3Dy4VPH+JkfPlur7/epQbXp0YqZZHMJYGd/6ZQVFCexRGc/A2zBJGHyj9jZepNQ/TOqYzw==
X-Received: by 2002:a05:6808:144b:: with SMTP id x11mr6561778oiv.111.1632606641599;
        Sat, 25 Sep 2021 14:50:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q31sm2943042otv.57.2021.09.25.14.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 14:50:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 25 Sep 2021 14:50:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/64] 5.10.69-rc2 review
Message-ID: <20210925215039.GF563939@roeck-us.net>
References: <20210925120750.056868347@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925120750.056868347@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 02:14:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.69 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
