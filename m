Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D79421C86
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 04:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhJECS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 22:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhJECS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 22:18:58 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9AFC061745;
        Mon,  4 Oct 2021 19:17:08 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id o27-20020a9d411b000000b0054e0e86020aso1219752ote.0;
        Mon, 04 Oct 2021 19:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=saTsyapLiqK2NG1iuHqVoKfHTk32y9AjqUJEf6bzl+0=;
        b=WVehmeNgpKj2fuodbu4dVnNp2TqH+eTvmkjUBztPnJ1+wX3r2a41NWQPGKk/TUw1cL
         7zsDoOMt1GvZDMzAGv0eF2eptyKts9H9s1prIHhfQIa1avWDSOQF44hA5igCfdPEFtRT
         WXG3QCgcMqzmvONSLgkFBn28hj2eAJWVZmpboFIbqtlX2wgd2jtmB9D95a7a4e5byP05
         QAjdXZ1IuBOm/o/7vnpDFW5lEqEpFxsz6qbXX/Cr4Ahml0VVrwVJzqlAkgRo6R+sTUEI
         Oz7VX8gLppNmftmNMVJG6FS/vZWRP5L1YE+gCWDP2yns6Sh+kJ3TrkSD8HbTRm53Lyy4
         azmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=saTsyapLiqK2NG1iuHqVoKfHTk32y9AjqUJEf6bzl+0=;
        b=yaUvK6MTtrk57Fl1+imMQfhamZGyxzjHTnNFiqc/GNn7NFUUTEY3zLbav7Op4L1qiB
         mjVjdlMtVTouDhDHYH42krJx6KkzSOIm6b44B0+mxOUWl6U1ltSJewUOHE9WVUUGm5Mc
         Me1kFUS8FimxMAyywUG5h0rG0SUsUutC6u/y0hCHcIuJRf6ySkP3IYx27JpbBD4aI8xL
         hg/sZnWkjj9xrKO3sXb80s6m5PhYGjygUJujLB6nNlooGsj9MWfsV/LfyYJ5wkBm0zqC
         2UyAUqqwERwH25vT7GVfYxvONG+6Va4mXc0XinK+C7xn/G7YCGXpSaNumbw8FW7WW8dK
         kZBA==
X-Gm-Message-State: AOAM533aTjoo2F+Dz0Z96Hrc8PkYfjMIVx6W1OTZ+/lbJ1YDCsItvGOI
        ycUaQbvUphRdA3sJv6PCDRc=
X-Google-Smtp-Source: ABdhPJzNJs7fyGtl3wCggYreYy9Tw/vjQMYcCZSA2DOUeyhXpBKItvkUbbeqZ85sx+mUIdbZHO8psQ==
X-Received: by 2002:a9d:2a8:: with SMTP id 37mr12175888otl.58.1633400227719;
        Mon, 04 Oct 2021 19:17:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v16sm3065707oiv.23.2021.10.04.19.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 19:17:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 4 Oct 2021 19:17:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/56] 5.4.151-rc1 review
Message-ID: <20211005021705.GE1388923@roeck-us.net>
References: <20211004125030.002116402@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 02:52:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.151 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
