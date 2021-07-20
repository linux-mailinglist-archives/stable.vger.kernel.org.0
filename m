Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221723D02C3
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhGTTcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbhGTTay (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:30:54 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0259AC061574;
        Tue, 20 Jul 2021 13:11:31 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id p67so510934oig.2;
        Tue, 20 Jul 2021 13:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h+dLi0y5JJkUS/kshpb8lKBfabybbvACwq+2LS0PjWk=;
        b=IDrqqdAkYdwnKwStY05lDL687sUcsIM7KukSEPxUq6W48cISBlVQWp33yZaZ++kI/W
         2yrJaMpsTn9ZMmlRe29QD8kqeSKMIdNnVVI7T8x11Vd2RKMv7vP1FdfhxmEkigOXuFwb
         GV9rlB3xaVaKrIQVR8Sj6P/n0raEgsQ0v1llJKkEbDYk29VzaLsMaVCywKsGCBHr8gQ7
         B0c7SxuyQfrOCj4xreg91s1podeYys+a+b9wm9ohWMeUCNMBwLh7wBi1Fi0Cg+rHB+iF
         9pWqOp3gZcZZEurm9y15bjfzuMAXZ2shKa+BThlXDrhK3z7Mi5fIXLOrH0qmK23S67b0
         0SIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=h+dLi0y5JJkUS/kshpb8lKBfabybbvACwq+2LS0PjWk=;
        b=APdsVMM9vI39aKrM9u155RptN/Vxyp2HFHwAOGQ+J/2flxCV0gmTmSEXZr/FswvczH
         bJjgMqwIReM60yLnA2yC+BRq8rvnIcjZrygbBbeisTuG2FPoHFPBxcewAcnBX9+tmrcR
         VX4CU6C+cxyWr41FKXGg+kxfEHD8GmuUmsH6X9fpGH9VXUJ6AfY6+verxPQoLEcVl0qp
         o74iWh6Y2bQkD/vEffg9GYPPa+nOnir/VUSJ3xl+w9mCIJdWNIt91FIzf0YzK5kTxDH1
         OcZhw0RDT6liziLMfcK7Y0z2hEyE2h4/46u2c9VygjLW7/e1qy55laucwZTOLbwbmhHs
         Glwg==
X-Gm-Message-State: AOAM533aG/XxDFKP3qEkwN3eFvq1uP8bOQg37RW8EG/QC4bCrFThOdZj
        u3AD5ypg5gQSpmZLSdr8kk4=
X-Google-Smtp-Source: ABdhPJxjLxeppVe8hlgxAhrMpLj6JZ7hM8KCAhCEWrR5xEEZQZ52pr37uIIwELaEAMeUMMIg0EjDuA==
X-Received: by 2002:a05:6808:1490:: with SMTP id e16mr107735oiw.91.1626811890386;
        Tue, 20 Jul 2021 13:11:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r15sm810320oth.7.2021.07.20.13.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:11:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Jul 2021 13:11:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/289] 5.12.19-rc2 review
Message-ID: <20210720201128.GG2360284@roeck-us.net>
References: <20210719183557.768945788@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719183557.768945788@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 08:36:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.19 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:35:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 152 fail: 2
Failed builds:
	riscv32:allmodconfig
	riscv:allmodconfig
Qemu test results:
	total: 465 pass: 465 fail: 0

Same random riscv failure as usual, still not fixed in mainline.

cc1: error: '4936' is not a valid offset in '-mstack-protector-guard-offset='

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
