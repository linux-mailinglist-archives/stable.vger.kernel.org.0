Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A93C3D7D09
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhG0SDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0SDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:03:37 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E024C061757;
        Tue, 27 Jul 2021 11:03:36 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id a19so10203408qtx.1;
        Tue, 27 Jul 2021 11:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B2hXLgO5AiXq5tjtPT4kBIU2th5HivdhwGkknuw779s=;
        b=I0SUcvgOXwQajMByH+g7geTBkfr92U2vQ7Cg7Gjp6EPFgTh7ve2hKRcBjVBbJMzawg
         tWojuRHDyNCOmVSlK/7ykl0P4nj5RY5IYwCsy5sKAtKZBcW5+sh9tnYQlY4cYBdE5tJB
         5lRAMVVFTyGkdJvGO95fwGQquUc7lhjQiL4xozoKq5ebTiT7WafRSgSfeTLSXe8fm3Q0
         Ep31l+toQBzqSNEvUvdv+E5g6ZylCQO9TjX2fNl8MX898yTBqjy+d+jGNhpvy8nvrtxx
         ZxSqEqMvL9ZHnUZbntngaB1Qs1RyG+kG5+9qkaVwqQTWNLay9SOmIV7lFmsgkhcgb65/
         kEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=B2hXLgO5AiXq5tjtPT4kBIU2th5HivdhwGkknuw779s=;
        b=h8z0905ebhXTg11Cdjt66Vn5E9RCke5/u+uCv7ujmx2bNsidTX1ZCbgCPnX0o8SLul
         /dd2PibrYDJ31MUYIZ5KXD2g5OgEYEvJpsQx741vFbUWhJ7MqpcOw627KK51iogm/iMT
         o0uiUZHzsQk9DEfGf8t0lpHzQ8XRrVFgbXV5dXiHI03c7sKi8kybZ1qLo1fUgh9hD5Kb
         rV1hg7w0GX9rZ3tb3uKqNlO5cWg44t5rIroPBDFj0xGbQci/SQs1Zwuw0Ci7W7FDsypK
         k6Y1Yr++cUl9gPqPJAEkt1x+kPaDjPkYCQhuIJ0PoLLahmVt4r+NH8lZYV0x4IEVib20
         UclA==
X-Gm-Message-State: AOAM530m7GnLa5w2KvnjotLFdU3hQ5nXivVGt2DrC06zKWYcqtyVAKrE
        pKM1u0euMKutm88ljJcccnQ=
X-Google-Smtp-Source: ABdhPJwMwRKCwYHs1glCMQMkEmBB5O+2I84tLgPeZefkG7VWpmOdikNSYARQtdsYZEgBvh4ST79TVA==
X-Received: by 2002:ac8:6e9c:: with SMTP id c28mr7308361qtv.84.1627409015545;
        Tue, 27 Jul 2021 11:03:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n13sm1582905qtx.92.2021.07.27.11.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:03:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Jul 2021 11:03:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/168] 5.10.54-rc2 review
Message-ID: <20210727180333.GF1721083@roeck-us.net>
References: <20210726165240.137482144@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726165240.137482144@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 07:06:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.54 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 16:52:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 464 pass: 464 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
