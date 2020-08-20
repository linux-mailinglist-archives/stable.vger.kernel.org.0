Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D762924C68E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgHTUGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgHTUGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:06:09 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5CEC061385;
        Thu, 20 Aug 2020 13:06:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h12so1657515pgm.7;
        Thu, 20 Aug 2020 13:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PhmcWgPHcTdE86ZfzhVr1WXHc9kFvyR2dZZnlfzMwiQ=;
        b=L2Mc0SzcHpXrSX27S5p7YoIKldL1rtNbXjJp5AEXLfdhdUcNF70iTD/u/umw3HLvq+
         Ae9LqmR1eW6o88zQGmG2sGPU9U1zGn1NwSttITQvcSmHlFLpFLCVK8al+nGM0Rl/jEb0
         7BH9p9SVV/nhTLMaon7dC0JcbxV3tDEtwrsFRAFF5WaTqbkn8snDZyaCyq2Qi+jQkyu7
         3XoKiTYgw3jrbp2P1a4dQDBN8dxwb9QtzXlAFm61g77pWDG3fGYf+JybVBSzE2luVvm+
         mdHZQU6aVjKT/cfBDQEq3hAAyMedPzQa6mB9mg7NFic+5od2I+glfeint5ZggxZ/Cyrh
         /2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=PhmcWgPHcTdE86ZfzhVr1WXHc9kFvyR2dZZnlfzMwiQ=;
        b=iB8T2t4Tn7deJinYvOBF/ckpDCtvgUSOUpcefMwSy90Azm+yXfRX73j+4Y3IOocHkB
         Y1UzaVgdPwqYoVyhmnpPMuNxIjsYqKL9UjEJWNi7vH50BJZhTPQz5s1zo+urtRsXzj0Q
         GnPsTGQ3QfYcg5uQajPgROCJFGP+AJ9vLjeGuWTd4Ym7aQSYXTiOd4scgA6jXDv1s6Uw
         Az1+w1vvIT4k5oN4ktFe7xTLVhspd91P9UU0NdWdhhzvVUSaKLg9pN9r2AKePft3VKB4
         QAPqvrtt51Iw6oy7xROdsOq8OYy/ur+X3d5wfz9Z8dI8zkkUBI6i3wD7WaygyScMplNi
         YTXw==
X-Gm-Message-State: AOAM531bNkzXc+Nf0oRGywneQZ/jl5coFFiTh1L+H5uTbYrNbProQp1/
        zqOtwdTU7UEoXck8swevP4k=
X-Google-Smtp-Source: ABdhPJzOuG7I7edEnWYHMWK+B1LfGHFg2qwofHExuAXGe/g+O0CF4nEazrqRUL8gvSNV/7MAIDYjTQ==
X-Received: by 2002:aa7:94b5:: with SMTP id a21mr273285pfl.237.1597953968170;
        Thu, 20 Aug 2020 13:06:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s18sm3565871pgj.3.2020.08.20.13.06.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2020 13:06:07 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:06:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/204] 5.7.17-rc1 review
Message-ID: <20200820200606.GI84616@roeck-us.net>
References: <20200820091606.194320503@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:18:17AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.17 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
