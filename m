Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED9E3DF539
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238581AbhHCTPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237379AbhHCTPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:15:54 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9ACC06175F;
        Tue,  3 Aug 2021 12:15:42 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id c7-20020a9d27870000b02904d360fbc71bso21641688otb.10;
        Tue, 03 Aug 2021 12:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k7E1Yc58nMCFbtFCjSNea0WFx2OCz3own7U22rUfGtM=;
        b=Y3uDyN6kcqyRZThKcnAVb22/iKDMCsIV88JNSyxNa0qgEif9kFu3dSrASG2OTlW97T
         RfO8QHNWhKwmJWB5XrGvihJGExDQL0XIpucjJzpRseDbpMi0VrjMcPKXxdMl3V09ReVD
         kasqhAHPRNgW69OcAS/RHxmn7aSYkplbYT/cNrFKtjYloWsYFt5Wky3ja0C6GS6WcLEf
         6IGWpkaE0BmnyTANKPsM71s55vqWHTDb8A9/O6TPrXI1e82iLvuRCH/iOEo1mN3ciIvF
         ybpqzksLK0aZWloB6maZO3Z9a1qdiZ1pYtGi9pcPl2YQaUxkEX6p4rIy9k6SF+fQqZji
         9lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=k7E1Yc58nMCFbtFCjSNea0WFx2OCz3own7U22rUfGtM=;
        b=THV3RKKZz2BZUMczinFTBW6h4u3ZVjtnUnT4L1A0I1Yh/eCmoMz9fAU0FdasbHz6ew
         NAtw1LZYoEIxu0SD5FLYUJqma3mDPBCSOU1g/VhP++huCeZrCM8fmH5HO9nszEGpLpGY
         CxJtUgBVxLFfK42LYtcJx4dVokGh23tH2VROvtRXFTa24y96mpsBG3qndQWWJycXbjW2
         CE+8iqZmdy8qf27Az6XgqpW6PIBEgV2rYtN0rQlO2tl1hi31R2peAhwfyzfwyN8OZgdN
         t96xyezgL1cD/e9y7oh4ZAAMDITSBalSNWEwJQRI1pTYcPINGTpn1bV+1/H7KIV9gq1D
         6ZzQ==
X-Gm-Message-State: AOAM531Bhe2iJaPojwDegdX/k88YP/Fjjprhx6qibf8sMp9IKLA9Sarh
        8PGWVQWb7NvPqKIJ+iPBZ2Y=
X-Google-Smtp-Source: ABdhPJxkNqmr5VZ10Atm6nlWX/DbSGT/c4nnP7fU3Gy+thZEhxTZ2uKlkdAz21GG768UlFNMoRhskg==
X-Received: by 2002:a9d:827:: with SMTP id 36mr16017391oty.322.1628018141513;
        Tue, 03 Aug 2021 12:15:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s4sm338231oos.19.2021.08.03.12.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:15:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 Aug 2021 12:15:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/30] 4.19.201-rc1 review
Message-ID: <20210803191539.GD3053441@roeck-us.net>
References: <20210802134334.081433902@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 03:44:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.201 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 435 pass: 435 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
