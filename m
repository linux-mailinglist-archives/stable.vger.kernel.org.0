Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25D44A55E7
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 05:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiBAE1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 23:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiBAE1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 23:27:45 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90136C061714;
        Mon, 31 Jan 2022 20:27:45 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id w27-20020a9d5a9b000000b005a17d68ae89so15054620oth.12;
        Mon, 31 Jan 2022 20:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pJiPgkMTX6YOjxiBVK+eiXXSZiz0nrv/hnN63/Hbt/0=;
        b=CBoTSrVhIFU0lAKcgIHNq3oAM4gY6KIulQhcSsDTItv/Bg7ycomGDSAdS+0k4GHMxc
         pjFWwJcPupsZgQkhuBXfitQWvGKWYaRI//GOIvE9qkjkDwS3hq49Pqwf47P2UCMgkWD5
         CrKVeQZyNCPFTSbaO8ER0pbFHOhXmqviwCCbh7zZLUl3aw4PTN2LCUMZ+Wvx4M4FPIso
         DhjveD09feJy8gTejV2kJSjN9qYceMmrJAAPtrFFH7x5Sup907it59fX6+36rG00ZwRV
         x59GRTyS4nYKWYAtEDjGPVypPloKFZHVGP/7o3ohUqVw7PmNbbgt/b0QDRCRlpU+HaGt
         dJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=pJiPgkMTX6YOjxiBVK+eiXXSZiz0nrv/hnN63/Hbt/0=;
        b=B3AISph5dbvNH4xQP7nT9tlC4RGvnKbYB6Sqzlb2GUKh8A3jputVqZSfXcGJ1WXSUI
         nBUNFNpV60/SMLKz7MDvKDPaVr8Z/pptZ98xD51lnS8yCChajSxTV1dcfPhwzomf12yw
         OtqbuKns+jinxhkElv+LTAQctQ9arcHT3P6I56CjC0SEJ0tGIfOe6U52Fth5hrGYqKrK
         Kkk5116vGhzSWpgop2pBjyArelBkVkk6pVFw1jqE0c2cdwcSMB+i/zuuerD4Q1lliXp6
         VDMsulYLwxbLDFQScPARfgMNYynd+D73Xt+RBt89SvbL2zy0KC9tiWatzCgsV/fCYVYF
         1B6g==
X-Gm-Message-State: AOAM532Vy2RfLlcj8K+lbCfk2EgLKgDNWSB86cD67ZTzJIlccd1HFNk4
        KvCq4WcMvIlnUmW98GhS9Ok8DsTeGfC4Sg==
X-Google-Smtp-Source: ABdhPJwqDX/PNKwGbcUw3dn9gffRgot5+UhBqzXwjcCg8+KQcGyBYRA9Yw0CF/V+AGrcUc75Bbhiow==
X-Received: by 2002:a9d:7856:: with SMTP id c22mr13495252otm.192.1643689664981;
        Mon, 31 Jan 2022 20:27:44 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j3sm11868201oig.37.2022.01.31.20.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 20:27:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 31 Jan 2022 20:27:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.15 000/171] 5.15.19-rc1 review
Message-ID: <20220201042743.GC2556037@roeck-us.net>
References: <20220131105229.959216821@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 11:54:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.19 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 155 fail: 1
Failed builds:
	powerpc:ppc32_allmodconfig
Qemu test results:
	total: 488 pass: 488 fail: 0

The build failure is not new; I did not build powerpc:ppc32_allmodconfig
before. The build error is:

drivers/mtd/nand/raw/mpc5121_nfc.c: In function 'ads5121_select_chip':
drivers/mtd/nand/raw/mpc5121_nfc.c:294:26: error: unused variable 'mtd'

Fix is upstream commit 33a0da68fb07 ("mtd: rawnand: mpc5121: Remove unused
variable in ads5121_select_chip()") which needs to be applied to v5.15.y
and v5.16.y.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
