Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F03536B907
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhDZSf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbhDZSf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 14:35:57 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB09AC061574;
        Mon, 26 Apr 2021 11:35:15 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id g4-20020a9d6b040000b029029debbbb3ecso20055393otp.7;
        Mon, 26 Apr 2021 11:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vG4edglK4goHJ1N8Tjx47gFEkaHCmvC4VOhyoiv4cEo=;
        b=PgPtbZPuQvQHqCr5BCq2N/nErmHlm6JueAj5QbmAa2jLcoMMzRkNylS7sHuft9aChk
         rZyZY8+0C2bL3Yqk7om7qn0/QKRBF8RsjYycFTXdj5QCmmqGol78wVVYChntSgRuvAjv
         kfibxKZC9Qi2E8oU+8aBuuY7pUYN77+DdStb3s3s4WxjVq1w3DAXEIeo5jKRrOqg0KBc
         d4xBNEdWHcDDVi9UKkL3gIRkPv2se93CJ1xvD5Y5sRdlp49mQfZDds+ikv9VnBoW5DOV
         Drz5bFdqLQHp6IAUFroz7hwfVBkOeek5da6C/DrRNHLGOE7IdguHkRG2yJsTnlHpLTiz
         S6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vG4edglK4goHJ1N8Tjx47gFEkaHCmvC4VOhyoiv4cEo=;
        b=rt0ImHI+al8FC9tv0iBSIQ4j3VEs+uX1G4n50KethIhUmXFxU3E/2mcwKApjiCYJXi
         CDdUsfJHaMjZnlYyW1A2HLcvXkb+fpl1BAcPMRfCDKXkP7fRdoU7ZMyoA47MnsC6HA18
         J1YNoDXEcN4DV2ZyC6FS6pitr5ehdRV8NV1/mdudLkhO+pj5wUrmfpXt+xkPafNi7wAw
         TArScOTVC8HSozZ6CeVZ7GzUMD6AxtR365t4ZWFcCRTmKUWdQYW+AvRZaCzU7nt5DaeW
         W3/BlTwjCtdRQ4ehTYqLWLblbc8GX/38MmahnUD6P+4RB3lPaCS72RJZOMo9LhLRygei
         LLug==
X-Gm-Message-State: AOAM533UNSmDM8IKumJUn/bdVS5ur1alkuWo0EzhK373uXoMrwn2eU2Q
        QamosxSeOcMxH8EtM5WFK7oblbI5gis=
X-Google-Smtp-Source: ABdhPJzk2+0958oXxHec5zpfQD39BJ7LId0iM/phCKzuUapHG7pfhvZXPkoMBTw847z9JG77uq8O8A==
X-Received: by 2002:a9d:7606:: with SMTP id k6mr15715118otl.223.1619462115199;
        Mon, 26 Apr 2021 11:35:15 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v12sm3591720ota.63.2021.04.26.11.35.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Apr 2021 11:35:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Apr 2021 11:35:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/41] 5.11.17-rc1 review
Message-ID: <20210426183513.GG204131@roeck-us.net>
References: <20210426072819.666570770@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:29:47AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.17 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 461 pass: 461 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
