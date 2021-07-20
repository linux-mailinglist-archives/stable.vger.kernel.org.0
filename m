Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF4F3D02C4
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhGTTcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhGTTbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:31:25 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2F5C061574;
        Tue, 20 Jul 2021 13:12:01 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id p67so512360oig.2;
        Tue, 20 Jul 2021 13:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G//mpA+vZ/TD9Vw2AzYjXY810ZGCt8G3xDpHqv/4Bxk=;
        b=QcY9Ncjze5eN+dZYyoO+8PLj1cKKFTE8IkgVP1nRJaz5LVafPwyelo7pUwXceUqt2H
         l/VpiKmID5ZPdN2g4WgdSsZwLPBK1UjElJ4vALr9xdXHtTdE/lLVEKfMAm9IdOhF6ExX
         /rYpRaJTjcYds+kKeXgythHU9cqaJtqZxV5ybMTzQW21Ua4ABb0+Dzo001c6juaxBPqM
         jkRRv6ICqp0iCPYMQjA8W5eUIwU9fPNJR5jeov4BAgw4SzCpBLNJ5hbZd0WvKdfyOMvV
         HWgoi6LSkC0B0dm7HDIZ/Zl9YaLO8Y+cJ/xlJ5mQf0B/fiU/SQIMfIfqGNCsNQoZ663j
         3n5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=G//mpA+vZ/TD9Vw2AzYjXY810ZGCt8G3xDpHqv/4Bxk=;
        b=BIWBt5QJOhgbNagKp+ERUDrOJwZMaU5nzVtrCPjUvTkC2yLYrKK8kC/jtcnnty9n6J
         F1Mzene58TkJRML9RlocA7YuYScUGoGmZPatrdWRgSbvXaE+uQoc1/WYsri6UFrugz/E
         i+ssRDsVMj3soEsynst7u5eLeLuCvzuusf4tHrNRYZsjdS2KfiAisfKol/TdVww731n3
         dusyyyk/XhhvZCu7FKGteF8u6bb77bo1Z3bkhBrNEyzX3a/hNuWuaTmtaGCB1lXqqA+A
         udWCnQTW2Zm/HgOwV+iotRwaBLZUj9ZctC3qTUvbpKwK0MT9ddD9pMdGYqW29fD6aOVf
         MVwA==
X-Gm-Message-State: AOAM5321zDsvFR4uzuG094iFxS7S/CsDwn5EmE96C2OfratdIrL40z7k
        O9halQQZ0gjmQsqZTdbNUTk=
X-Google-Smtp-Source: ABdhPJwcxfdwAuNB/C0FXJtlHZrQObRFRtoCOIBL4GTqF4yvqVN59lreD7PNaySNV+ZOcdz+mWrV2g==
X-Received: by 2002:aca:4d0a:: with SMTP id a10mr118901oib.71.1626811921424;
        Tue, 20 Jul 2021 13:12:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h96sm4367686oth.25.2021.07.20.13.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:12:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Jul 2021 13:11:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/349] 5.13.4-rc2 review
Message-ID: <20210720201159.GH2360284@roeck-us.net>
References: <20210719184345.989046417@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184345.989046417@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 08:44:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.4 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 465 pass: 465 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
