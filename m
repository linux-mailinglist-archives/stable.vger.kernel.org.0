Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33CA4839C1
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiADBYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiADBYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 20:24:18 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97162C061761;
        Mon,  3 Jan 2022 17:24:17 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id j185so57191615oif.8;
        Mon, 03 Jan 2022 17:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kL/xDKMjuR1h/hMg5dp9ic+lteqkyfcAsUQXbThPlAI=;
        b=pG2keXEudoDJSGzwDhVn1MvdBWgyS/UZNBQhrMnwk4HGoHfXNPMVWVnzGxcilREfAF
         SJyBB0W4DIOzpFcoOwnpJ7zh2W8SV/kP+y3bfTwRfk0Kyn6lZq7VPmvz8FtDuIyKWtTh
         FZt3NrMIBJo8x8ZSnYanmj5k/kSMMBFdGQBYab5ahZemTezcgiuwdcCKS+uGzk39tWMq
         K6iEWmHdmzezOpfGXzseKOK9BO6HvtVjc3AaMN1Y/WFa4rRJ7R0B6e6ibzCQFd8qebLp
         tcYlmdPdnnpYPVweUE+O16NumkeA8KjlzTnco8oEf7EwjTlrdjAQegjYWzruzlHUz8MP
         e73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=kL/xDKMjuR1h/hMg5dp9ic+lteqkyfcAsUQXbThPlAI=;
        b=7vuEZEDEBKYRR8VA0d8F5Qb/qQ4xUUc+YRabd0eg4sB6Tg3Aw1UhyMIS3mQxv5r5n7
         1n4ZEiFl+wk0Tghbx+JrqqWNQ/yqr/IncGzPPcbTOhfNnw1+lECGfFzKbHtniWgq4qRp
         uir3oJno8jnt7ZyOY9/3xc9Z06w3VA+9rXb5C8vKxJlOBe18Jx8t3xcBrvuBUWyPQaGI
         PuL4l5ZHtU0VPvJr2+8SkIDbkNkc8POCxWgPIHCyrRs3Ugwx3dmj7wcFAoInsycSIy/t
         QTgU9SzXRmkUnZaF8a+NA1pwZtcprEtkXxQWTJ2K623+GUNsny3WH/1MYWL51j1te+ea
         SGrA==
X-Gm-Message-State: AOAM531yOAHvdj5UBZJ7NaTH9QuQVkmkMjugckJBAi/mOXoMNqNkOYw6
        XQ07eyDgZoyRnYpmK7OfeEk=
X-Google-Smtp-Source: ABdhPJxpPFce25QeFtcTOsdBf/4KQibdKxwe2RXTl9lsZKISWLI2Avk7dj5FbEVl7LRfw5/9uT/N5A==
X-Received: by 2002:aca:3556:: with SMTP id c83mr36922323oia.141.1641259457057;
        Mon, 03 Jan 2022 17:24:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u22sm9049582oic.0.2022.01.03.17.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:24:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Jan 2022 17:24:15 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/19] 4.14.261-rc1 review
Message-ID: <20220104012415.GB1572562@roeck-us.net>
References: <20220103142052.068378906@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142052.068378906@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 03:21:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.261 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
