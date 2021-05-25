Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221DC390B3E
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhEYVYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhEYVYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:24:17 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027DFC061574;
        Tue, 25 May 2021 14:22:46 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id x15so31594817oic.13;
        Tue, 25 May 2021 14:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JPEI9I4tD2sn2pkNj8OTcBeOmQuuSbcZCW4MG9y+zl4=;
        b=RBD4RDO9pN3NXyWXTmORhOsr0kn6qohrgsoVj25KiPW79m5Kl0MRII1ueopE2NiC8y
         FvxD1OmDnSqzLQ3cj4KzEs6JBwWhmWeUVDeeL9l5wKbS6TBc5D7GJwlEgSzxSyXDA6BX
         SKJa4yd4L5GURAxI2yK/+wlnskjljtdQ3AFms+2ClszVFW2TJawmnhUWZb+0yv+iT5vl
         jEPNDExJ/cZQnD4A4Tz7xqj6C5Rhzv/IZkYyMhGwVPdRDmublcV7+9sjcBsHjOj6OKna
         +sR7MI5LZ4zWSRN75avSXNRgOpbEmZ/qRuM9qp5O+6NbVRPOCbhAKH2i2toQaeglQN7U
         07fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JPEI9I4tD2sn2pkNj8OTcBeOmQuuSbcZCW4MG9y+zl4=;
        b=b5P8Myvrf+0RkzE4R3eBDUy8Rn6yxh7G2StdhT5U7W9erS1AWbJPS8UzmA7pri7TDq
         XGcjQMacxysSJHR2/mH9jXrYbDgMGrZAtO0Tdp1LiKteAGSfiBMpEnmXTLJ91Tnf4rjg
         h7eC/x8+gBJayXUAWJS2tpJRnJg0AoT2Rondl4IifXnAwhp3E1aamJKm/9Mfnx4prVXw
         1bnTAHIqPPZGwq+3E5DsCWKsN3NoFjwKEsA6EHeRlrrlg9VWohUA0Fx6xvouNzEhzhDv
         m3CkKj7VYe2Qp8MH2S++Iu+WoksxXiQlh5HkqLOmQyMT8OtYo4vNUxj5rrGWkyct2FzR
         J+tA==
X-Gm-Message-State: AOAM533NSS08gp+HprJsvL4pTJ2FncfrBcMSIGivvaCz8aC1DxLSluAB
        kbXNIZl3PTDcCoc+jM0cWD8=
X-Google-Smtp-Source: ABdhPJxa9gUpk8kCFUr+Bjqbjlezm8+RP+9rTdFPvC4edOcKiiqBYPRojwR4YHAEcMklE8o5JehEiw==
X-Received: by 2002:aca:ed8d:: with SMTP id l135mr15496057oih.4.1621977765473;
        Tue, 25 May 2021 14:22:45 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u201sm3444034oia.10.2021.05.25.14.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:22:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 May 2021 14:22:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/36] 4.9.270-rc1 review
Message-ID: <20210525212243.GB921026@roeck-us.net>
References: <20210524152324.158146731@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:24:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.270 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
