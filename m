Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE143C65D7
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 00:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhGLWDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 18:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGLWDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 18:03:11 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A3AC0613DD;
        Mon, 12 Jul 2021 15:00:22 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w194so2946863oie.5;
        Mon, 12 Jul 2021 15:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XqmUpOeO2rRTNabMb2/cpreBORECk/VEQWTHy0JBlTo=;
        b=WcwGtbD74M+ArS8MF0qhyLlc6NdJn0Qo1Wjxfmreq7xOcGHth4aYufZ52nxTDXZp8P
         SSLJqB/jyKfcRxrRrZzY7X6xkCNyQozgVkU92BLk5mmcdtB3ww6rJP5ckgfExVgBxJWh
         snA9dAF1n3o1KwlQ4J/O2y8vmjS58jLIhM/TuJCRyTNy/z6pDHPdA/2OJQM9vrX7Lao4
         3j9z75XdzcxS2B6MPutmitVOdZl7yMQBHUazKEQ677OYWWtSE5RK/2D/RDxbxql8vn7o
         PJbzc7I6TY7Utx36rLMny/aKQUWupipmIhdfqt4JK68SVvyCGAgGTPxJmtfw+acNzbyq
         uWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XqmUpOeO2rRTNabMb2/cpreBORECk/VEQWTHy0JBlTo=;
        b=IuZX/VyfSccKsusrDvga8/tUaV/xNHUrlzd60PetqOSz7xflFsoRZEAp1TcQ2g3cUs
         XmlneFKdCRju0lDq7QkxHBXCAon93H3RF4PxgAF2lWlYXVbChKHcaGbYo8Mv35RIwdbu
         zkY9l12hWj3qIu4l5jh7qb7fZ4CYqVS6U1uxZPqAvzYDJ6ox8ae4Bwjo9aDvpYfq8INM
         vfE4fEYQ5QRdHeXjiCX+ojT+UuKnMf8q2dE1sujUzmvQajWCKQX4lPKr6IoJLtsePpF/
         zQDGkoly/x0DMYkTAel7RLmzuf3OZphdVkiwLKwJRPNPd5H1p9osbqrV9DS3QRL9wiH8
         6lmQ==
X-Gm-Message-State: AOAM530FN/LF24ESTN5c6PZ2vGDlmLrzznspwNaF74HssG5Z/szdp20y
        EhYrQeyGq/Xh+8oQEiuaQjY=
X-Google-Smtp-Source: ABdhPJw2cyN3d1D/Y+YqzFEd4fkivP0+wYgkEHdUIeBvNDZ8gyK4ZmBWPiJDcUWRAAiSsTZ9xbEeqA==
X-Received: by 2002:aca:4d0c:: with SMTP id a12mr11545571oib.159.1626127221795;
        Mon, 12 Jul 2021 15:00:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v203sm3466571oib.37.2021.07.12.15.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 15:00:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Jul 2021 15:00:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/598] 5.10.50-rc2 review
Message-ID: <20210712220020.GB2210980@roeck-us.net>
References: <20210712184832.376480168@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712184832.376480168@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 08:49:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 598 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
