Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2610424B35
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhJGAn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhJGAn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:43:26 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E850DC061746;
        Wed,  6 Oct 2021 17:41:33 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id c26-20020a056830349a00b0054d96d25c1eso5371692otu.9;
        Wed, 06 Oct 2021 17:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+e2FcOxDgM0GzyXG1tfbTkwdgc2/G0IBBKbouZ6i8zQ=;
        b=lkHPwrwVC6+dgLuLWsMspjJSot4YwUeGGyOTHIeXiuO33xFr0gQXQJs72OHvEjs+pl
         Gl7Y/hG2culyvBwZONCi7gnl5NWgnrzKft39KSjIPYxht6hJ9G2LYEQYG0cUCLXm1Kmg
         7huH6p0ZvvtvT6Z6GF8izJmtBrakkHFbbIB0jeMlEkXtK2UAhVUbOC1D4QublqtQiS7I
         xQ+iq3G1wDqraUsojs8aQxTBkWsg5Qh5Q+f1jJzyV+tSMlNvGYx6j80rvLvqZyozsFwp
         fRY98QVo/0TlWHKTAOsTXcw95VJK6oBzvZceN2efn0D9Ocgnpzfj3cewefXxcI0FRcM+
         dBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+e2FcOxDgM0GzyXG1tfbTkwdgc2/G0IBBKbouZ6i8zQ=;
        b=fMHkc2N1Sd+0rqbru4te+pJrRdlKPyQXd7n5EHiyF/HfSE5Jg5oc1pvTFgwqi2EsJI
         NL/pQNRRG32/yC4JV1nEe9mr9GK4D22vyiLJ9S9T4ZG0exsTsxzj1VVoSf/t6Bbb9tVr
         /pCGJnzLq4hcOZvZzXYdQzXKX7+4VP/rbjOXr8JGPydmMNAngBJ3WsvfxSBX0e3wlLR3
         6YESfaEgMDZBusiPVdutd9EW5LPhThgAK6bdnQEGQPV8wyoCZuOLRPhu8TSm4+0QyjfW
         oUSINg4+db37UMK2fQpyCnPAV/eUuEL+xjlFG6XS9G43EVXTnsh+Y8VDNVG+cJXOLbba
         Nocw==
X-Gm-Message-State: AOAM5331SM7JcKixg9jUcoUBdkd/fybtDlDliTo5aCojs2R7p89qNLq5
        8DwNVWh1OKWIstzkIT37PnY=
X-Google-Smtp-Source: ABdhPJxpJppnsFnwL3Ik1zGA/Vq/1ik/MN8o0PLE4odbfdAWdc0GUPWeAhUhfxiC8zY6k1oj2ELe4A==
X-Received: by 2002:a9d:3e4:: with SMTP id f91mr1177148otf.327.1633567293342;
        Wed, 06 Oct 2021 17:41:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8sm4043155otg.31.2021.10.06.17.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 17:41:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Oct 2021 17:41:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/41] 4.4.286-rc2 review
Message-ID: <20211007004130.GA650309@roeck-us.net>
References: <20211005083253.853051879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083253.853051879@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 10:37:55AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.286 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
