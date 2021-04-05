Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CD235464D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhDERxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbhDERxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:53:41 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B2DC061756;
        Mon,  5 Apr 2021 10:53:34 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id s11-20020a056830124bb029021bb3524ebeso12177947otp.0;
        Mon, 05 Apr 2021 10:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ei98igN5Zf1+uS2RQCx8rxddxbsbbVYP4rdN14L2nf0=;
        b=sXObEDqyWTJH2RA4oQ5hCzXBkKYU8qfZE6hZ3f78GKvTdT15AdmZskTKam+8fZMFxq
         Gg9huwvjBDoMy/fyDcUyzegkEC2U5b7VFUNQC1JLtkSwGLjHQyzN9cQU1HWkCi+pc8Ch
         JF2t8G3bHgi14LGZIbbT9nAkluXU40q+3CRXOeURcY888Q1WikG6fQmOGO3wgdRAMktD
         JRXXJ2hVFlUrRRQHa0aqxbcPeUDo+6d2ORTI9ELGi5/RJva/babkpqRMQ8PJ3xSzv7lQ
         HxTOmKQpZSP6cOv62PQb1khmi8SwHkRoU09unL1lITraui7Xb7z1eQoFZ7n93VhX3x69
         oPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ei98igN5Zf1+uS2RQCx8rxddxbsbbVYP4rdN14L2nf0=;
        b=c3y/aqxVk8KDWEtvLN86MX1dbJ3An6YufyE3/BqUAwhJiNKTobA2hcxkLxKxcPmV59
         QCmGvmSb2ydQJw8RiQ7oYMfEsLs7iy2I7MOT/yOJL0KuxjN3gzrHG8xzc4CbKzwD6KL+
         BE26yaIm2jVdaIQbLj13MoX7LYHhiyvHWiOTKfz6Ik69eHKmrmxp7DCoXFLvfaH+e/VR
         7869AdPhnpP3XlnSpcaq6W9q3RxMvh7xDi0ZIHaW+jAMMKcUkqe/vHkhZjqo1ETci1IG
         YmK7QDcryAkYDu+zgW4v47Aieb5qGhmRz3TZp08ZGqrLoKICXJe2wK0QJDSjv6b/kpsR
         UakA==
X-Gm-Message-State: AOAM530o+8CcO5AXaKySLDZWO5QFpzRSMoT5OMfId6iAxhyWAEHf4X1N
        LGu3tohaWjXUsSsaqxy1NkQ=
X-Google-Smtp-Source: ABdhPJxIfJPjB2cQEaJqE888YV65Q5DvuaRho4WqTlda9tawOhjPOy0kW+GUc5+IHutzBVQY2Ukf7g==
X-Received: by 2002:a05:6830:158b:: with SMTP id i11mr12310546otr.317.1617645213791;
        Mon, 05 Apr 2021 10:53:33 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g13sm4069553otq.3.2021.04.05.10.53.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 10:53:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 10:53:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/28] 4.4.265-rc1 review
Message-ID: <20210405175332.GA93485@roeck-us.net>
References: <20210405085017.012074144@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405085017.012074144@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:53:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.265 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
