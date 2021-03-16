Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B09833E01B
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhCPVOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 17:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbhCPVNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:13:53 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F82C06174A;
        Tue, 16 Mar 2021 14:13:53 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id p2-20020a4aa8420000b02901bc7a7148c4so31166oom.11;
        Tue, 16 Mar 2021 14:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ii/H6r1YBjUxl6sH6n57NG5ty3TsmsKtMM4jLBoRy7k=;
        b=flsI6oTwM+Z0A5zteYw8GpXDGJ7hjrV3xk2nVh6DVgqTOlXrmFrmXrtwnyvnDI9K9u
         rwHY4Uy7ltOamu3eOokBWMQdVHKo1nd5AsD9eb/Ain/Wveme0CGd+9tnxbNz3FJUyWLN
         MqBwt1+dSeyixc7kWWBLqqJXkSIuazYi0wBiIlEPwfvbmuI3/rS/DWPlxugm0I+uGqZn
         3W6L3phxzUHayExaBRU7e3mCd8EWKoLDY8dCwow9ApF2AOy3I6gyUx+/GYWO/S2xEA/T
         w3T8WDBDwdOCsTmsFuN79eawEhPplmpJbZDpFI77Ii4SA6ZCW8tGzghUtDqcWXvCsYQD
         CQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ii/H6r1YBjUxl6sH6n57NG5ty3TsmsKtMM4jLBoRy7k=;
        b=AdtTJzXJEf6jx2MmK5tuZBTJ1ANG/XPH49Re6uPCQTj2j6iUD18EcUpNn9aJqiaQ9A
         DGEpTRc5H7eoxOLkLVWgz1SqSQ4NTf+XaZO/FSGdfD+q2iAhxQHz7xd4ATpSl7aKQrhU
         jxKtP/4aXiAa7FQ+3al7brz6+c6tXrQJq2i5KtBbkQ8+ksQybjdsFTDQKZR1LmfS9ISt
         v3rFzvwgtkxOTXKCpanmdA+N5mn439YMixbdbcugHdEt5h6EzyG/hhNDDZRxOYl2TtuQ
         kB8oMFtLid6rOTudyNDATH3ui8rq7qF6XSJVS+sbYXivrJ9rktTmLyvH92GLFi7VFG6e
         1MYA==
X-Gm-Message-State: AOAM531sxa+LjH321SmIoV+qEpuZBwHABHYvMRw0gVX8ofxFloe7ns0c
        rE7uQJOMzroUXUAZZeodkRA=
X-Google-Smtp-Source: ABdhPJxQ88yz7VeTtQ2KxH4oMKTAcYiiPKwpCiOlq/ZIMOcMZYjhhoHh9L6RRz+2H5AoOjbRq87FCw==
X-Received: by 2002:a4a:be86:: with SMTP id o6mr601449oop.70.1615929232720;
        Tue, 16 Mar 2021 14:13:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v7sm7973629otq.62.2021.03.16.14.13.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Mar 2021 14:13:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Mar 2021 14:13:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/168] 5.4.106-rc1 review
Message-ID: <20210316211351.GB60156@roeck-us.net>
References: <20210315135550.333963635@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:53:52PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.106 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:55:26 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
