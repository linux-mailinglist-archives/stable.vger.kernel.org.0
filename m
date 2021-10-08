Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A85E4272BE
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhJHVEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhJHVEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:04:22 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B368C061570;
        Fri,  8 Oct 2021 14:02:27 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id o83so7900802oif.4;
        Fri, 08 Oct 2021 14:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9LwMkEt2o3zXaF9MQfLUm8q3q6vRwqYdfzOeYzfhtd4=;
        b=eYRULywNa7NeVybf0cINnaqmeOd3BtPUW+RvCLMG8+/yZbA6thygue1I2N/PqlHbx1
         Ym+NaCBvrOGvXniiOJjQ7HCuWY6EEKCHbY9yZwJB6cDy+IdcwWTae0V9GACCVJ88bLKz
         0WC7bKjAczkTcxaQOZw5ER/OB75Ssje3JoZoM8YKd2IVgfXX8wyKbQurK05mS/jHQDM4
         AQlzxO5uw0AbEliRrioR/99BC1p/Xi5EZXXv8tD2OCujNqgjjA8OgF5fr2mtpYwty1dc
         WHU434TtYgxBMoFbmiP4+XiPzHkHYrSZKcvcxQGvkuFxUinEFmDD1iZA8k31l+acjO//
         MGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9LwMkEt2o3zXaF9MQfLUm8q3q6vRwqYdfzOeYzfhtd4=;
        b=uNGErXqGb8TW60rwctvBLve7857JDr33MgOlyjZ180uWVw0Hqqc4P9WczSP7fmnutG
         o2Grwc6O82n3iGg1twhHBXgabMICRO9mnAPnxhfNfjeIvoxx1Clw9dg7s0HvzNyw1sDR
         YdgGSDTolAzQ+EbPysvf5sctXP9i7aFtj5M7M0uyB9lhSZf6S/Bfs9TnFQ3+YLkcHcBJ
         7lzoFdDjXhSFLH9oUiAQsHclrzn+cJ0jEMN2gH/VN8fTqISEN1eOmShPiicNtSxmyEc8
         qoyzP1wDVLslJmqS49MIDx2b3Ecg8PyHBZf9Yi84rsVDdF8HvZWLjb5VpxpNIacc5xTL
         ELLA==
X-Gm-Message-State: AOAM5311z3KowiB3NYlYIZ/OFqt55W4LwK5c91IuhESHqsmTr2vfH0V1
        lJZGMr7QTnU89DVhqE1o3Mc=
X-Google-Smtp-Source: ABdhPJxDmE7XsbzHDo8f5NWmjEY4D2KQmoT9O1sgkJnzi94WasvcJ2HMl4sOEjFQqGkI2LgWKROP3Q==
X-Received: by 2002:a05:6808:f03:: with SMTP id m3mr9531033oiw.23.1633726946490;
        Fri, 08 Oct 2021 14:02:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n13sm106287otf.3.2021.10.08.14.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:02:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Oct 2021 14:02:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 0/7] 4.4.288-rc1 review
Message-ID: <20211008210224.GA3473085@roeck-us.net>
References: <20211008112713.515980393@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008112713.515980393@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 01:27:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.288 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
