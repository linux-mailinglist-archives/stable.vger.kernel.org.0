Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5292E6C3F
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgL1Wzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbgL1UZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:25:11 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12FFC0613D6;
        Mon, 28 Dec 2020 12:24:30 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id x23so2459109oop.1;
        Mon, 28 Dec 2020 12:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mpgdo06G2MJ3Ovx5E1thu4LgBiE86lTGSA2yG+EAtm4=;
        b=VVQ2honX+RV8CKFoFkAzyPrk4damX9DcKn2EKU4BSR/kaBJakBrFBEi1ZfZn1XDfif
         cpOlKmwqDVEGwqjbQMvHlUL3gAoUKCMY8xS6ALo6ud/KO6uoCa/vQ8FKaKI7eQT1rZqf
         YTs37iPX8i+TaGTIRpRmGEQeR77N4Xmw+PT9oNKCVZ7IoKQjRqEVQYG4U9cGcQ1XvY3O
         jqk2FMYOGFwFNMtrMRhDkXJ/fY8QjBlNBJ2KOor181M2BPwQXFxpHajYu8d1S225hGfd
         UUZiMJ4NFpvZRHRB8uAPH5fHhEYuBUHuEiXj07xCkz1O2/HMGU9svBGBN0Dh5GsB4IAB
         RvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mpgdo06G2MJ3Ovx5E1thu4LgBiE86lTGSA2yG+EAtm4=;
        b=A5fiRWxLqVPn+p9iTqiKrXQAMO2dJe4u/pg2VrCv8S5mWAKpus3bO9zK9gJ8jKaqXn
         i25cEcBE0Wq3RWzcFJTXfWDgTuaJia3odZLa8HhykCq53YpJORY3gRYYGu8ffzEVlelZ
         PWnFcwXwZRRo9IyOR/92KEhBDO3EKZuRZPonUGAX5XSWQ5F6NSBihDRgGBeMXdgQWClc
         pLBE4T7c0kUOkRNOlz4EJjVI7cCFn5FbgHiuZaoclATOnicgww+ve1/UQETcbJ3/yUBc
         gWK9dMXYb+Mgu4eKBEyzIZeWUDicgY9vJxQuC5QfaNsVWJMEfTGnM6+k29ETDz4zzNKc
         wqzQ==
X-Gm-Message-State: AOAM533IFAp2j/sI1I++sAInPzhy2Kmo3qe9SXtMHYXsLvOZioPo6e0q
        CVOltNUpQWF1HRYKUJT0msM=
X-Google-Smtp-Source: ABdhPJzVHw4Gu6HeWHF5strsg4JX35vlwKBaUjuyvu83sFSxPpaStvPM/rCBrkWuC/STm22b9ECvPA==
X-Received: by 2002:a4a:2cc9:: with SMTP id o192mr30407447ooo.66.1609187070312;
        Mon, 28 Dec 2020 12:24:30 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a26sm7666495oos.46.2020.12.28.12.24.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Dec 2020 12:24:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 28 Dec 2020 12:24:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/132] 4.4.249-rc1 review
Message-ID: <20201228202428.GA9868@roeck-us.net>
References: <20201228124846.409999325@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 01:48:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.249 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
