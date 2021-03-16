Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B1E33E01F
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhCPVOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 17:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbhCPVOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:14:22 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8F1C061756;
        Tue, 16 Mar 2021 14:14:22 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id r24so9280708otq.13;
        Tue, 16 Mar 2021 14:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cPdVQ1tjCdGuR2Lf4EQo9J2ZE36VVbgPKDG+NRpFOLc=;
        b=WSnoSpRHLiGVeaTA8a8HGPtfp0YnymG4xQagjjBlFmPRjhYEcXArlfLVpjcTDcdXOV
         GT0B8lCf+uocCbN+CDXzz+TheW66AbOQ7ND5CtC3k7qPL0cSb2fcI5NgLELre+5AqMwu
         11GknqOD5YsQSJIk6H/FuMjbwBWjOeDCHq6RPIQCgwZ1SSv5Ggc/CNMkdJ5jggG5gKGb
         cEE3ZLExvMEg3zDw9Ug9jheA4n8tCuixAZBmQ8xjTrwrbd3PfmEbOdpr/5G4KqTNXJnE
         XY+7Pkir/8a7/t4FhR1HFr7i2VXrr2KftHub4cIqqeku6B1K99fMJhhm3qAFJhHSwUeZ
         jWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cPdVQ1tjCdGuR2Lf4EQo9J2ZE36VVbgPKDG+NRpFOLc=;
        b=j/yyeFbtptCPojYu2sQ5JyW34/ktOVTKFQohRWjouMphPvZ4o/rwXxYqVFgZyN4Vml
         DWuJl0LOdAOOXZ5gL2XXtssEH/RtDdx7wGKHXWQlqEzjnTqEIhKYAuABYkPDDRiKUX4h
         PlrLAd3T/HVenkzQV5cS9fhU/jI1ghSpGcm5pSc1tlESlAPoVjrD7H+Mvc+bQiuK4xdM
         LaClL5K817j51Q79GDiWq9DkF/a5oMUiP9iv7p9ZsFHz0jNpuu/gJjeP6zYJ5S7tfYJk
         gLJ/mSt87ZDu9r+rktA4gi/E2un21xnhJV/TGLSiru3MQ+NIwOej5BeN4M4bHHUnyfe+
         7TLQ==
X-Gm-Message-State: AOAM5322lXdDJt1Eas51/Hoat54ePapym5n4NAFfZi/3A2dDNvCyt5bD
        YBxMFheSp88v5JbgKFDUwY8=
X-Google-Smtp-Source: ABdhPJy64TuHpUIG9E8gfMI4Sk4hp0LO6jvZ4my6vP73INJ7E0yncmiMOIWmbF+1GPUA3ghR3kn0/w==
X-Received: by 2002:a9d:761a:: with SMTP id k26mr574030otl.193.1615929261693;
        Tue, 16 Mar 2021 14:14:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v1sm8222243otk.67.2021.03.16.14.14.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Mar 2021 14:14:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Mar 2021 14:14:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/290] 5.10.24-rc1 review
Message-ID: <20210316211420.GC60156@roeck-us.net>
References: <20210315135541.921894249@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:51:33PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.24 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:55:02 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
