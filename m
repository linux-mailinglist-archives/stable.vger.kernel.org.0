Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D95473558
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhLMT4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbhLMTz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:55:59 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E4DC061574;
        Mon, 13 Dec 2021 11:55:59 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id r26so24606801oiw.5;
        Mon, 13 Dec 2021 11:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+2N8yACAi2gcLMOTQITP6JLBx16WUF05cLk0bwMwxqo=;
        b=kjYHUf+MWQpJ++QWTL0hUBiVB3b653BDBAyWc5CD6e4+IncEq6hNPL8DT2GN3u7roY
         mkQC3VKU/XDlV3rgGBTGSZ0/Bc7gwz0NvjZuvcV9EfPBL4Fs+6qK2yX3t2PN5TQoyi5s
         rjCkq2Zz72lNL+r28CgxhKt6xx7s2QGe0e2h3aEoCdBzZc+mUwRDlgbRVmD3eKum2uEt
         Q9SM470I2lLw1OL1P+8jaIYmYUQAYAbfeQNNBV+ae//o/UVhDY/fJYPYQQOLRbFosxXG
         tKWTjbyVxtq70hW5mT9/j8vIhRDksKlMVgLB2D9fmPSBHOwCeBQP7qB50D5FX4hyZ2pK
         ch6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+2N8yACAi2gcLMOTQITP6JLBx16WUF05cLk0bwMwxqo=;
        b=lmlclR4vyianhwWXx15LmeaUlOMefccmDw3a0jZQrY1gPcxYwjHhWLIcPvPtVWAK79
         3uawauwOIV/T934E0uGMBLFS0CT/1EcjD9JRTrRodWtRSw0/DtPxT1U+ub+eLR1z5U6O
         pZIhT6etI8lwZUVUD6U59kaWawFxal5/aMq+rTi56WmEtbas7V4MFtpPc+XuSm5VO6yw
         muVa6gJEGA4qaVsFliYZm+ZjVnCcdbjAnhcDsySOI2eqL1Ejfaur7dBQfdUWY+XDpEZ0
         XxQx5Pi8UOUHVVgoAagbxASHNFls+JlE3NrdAJqfd0l9nAZY5X89PhpobTI3Z/kr2/sF
         4NmQ==
X-Gm-Message-State: AOAM53075gKEOkN73ROv1eAHuXKKiOK6BjmmJ+kBffxy3k4cwpnE3cE2
        HQgGjH0JkAAY2VCrYcqzCaM=
X-Google-Smtp-Source: ABdhPJzbzZ0qfVQIUyY7Wu8hPwwDPZwqrrs53EmCqwruGCtJkQdgovSO5dMQ/ZDIJpz163Yz8nTftw==
X-Received: by 2002:a05:6808:11c1:: with SMTP id p1mr30869197oiv.113.1639425358673;
        Mon, 13 Dec 2021 11:55:58 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o6sm2360907oou.41.2021.12.13.11.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:55:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Dec 2021 11:55:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/88] 5.4.165-rc1 review
Message-ID: <20211213195557.GE2950232@roeck-us.net>
References: <20211213092933.250314515@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:29:30AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.165 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
