Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9A23E2F90
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhHFS6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 14:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbhHFS6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 14:58:50 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5C6C0613CF;
        Fri,  6 Aug 2021 11:58:34 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 14so10994547qkc.4;
        Fri, 06 Aug 2021 11:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LAPPVus9cdVF07fGY7V3VYDFjMri9vjVtukapqx2opk=;
        b=vHYKCagWEr7oSBqIo/OcZE5jestZ2a/nSzbPVF8kst0wFKDZC2RCizINZs9M96sWcD
         qmVu3WWb2en5hAc/KKDLnNxLopO6+nnLx+BmZoTDCoeY/MtwCE3Pz88w/ZYf6LFI7s1V
         k8vR9+EOpFEgr0Uw3tDI0W76GmIXGINg7S0/JROByK745sRAxUPQl5MdHCMtjNjD9obW
         JNkhHuApTzNWkuxVvvAWc1Ub9CAM/1ysZqfyv45jzZoGE7WE/134iorQxH3/Q6VJ2Kiu
         4pKxn65GVWCfs3t0xZ9q2Kl8tJQjsLH7UCCMuE41lVECrt5pPrdJQOaogxRDXAi9d/oc
         t/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LAPPVus9cdVF07fGY7V3VYDFjMri9vjVtukapqx2opk=;
        b=S6lrA3gNKTlTzUHBeo0PZX/xicSdyMe+gbpc1aQNvd+mdJK9eWtnwXqNyIRfeSJgd/
         zQVFrKWl8nUF80Ryw1ZSr6pGc8eeet7tJ1afw2B3KpwCDVonqoK7i8xiOceOADRkgp1V
         cwAjy+aap4sS48yMRyqqcCfl0j73xCK/zcHH9AovoDh4buk61F9LQANnj66RhzbDV1PX
         X7Pdqeudolvep2sT20HFVLAJqb/Wpo+C1+J4lHBPj4RXP/DnjHVsPWi+JXuA4wpKvoEw
         SO2VhhpsNkVzFX0KI9v1BGSDnyTFNeRN8S6pmJKSH2rJe71mHmhMPGaqy4obxcKKSbXb
         MJWg==
X-Gm-Message-State: AOAM530Tq5R76lNooLtbfPvaXqFQ5dtOJdvrE97nbQr2Q+hc0RqWYxXA
        uSKafByJZuLak6x1n1NL3cc=
X-Google-Smtp-Source: ABdhPJzIweZKVqHA/QxQGsed9QM/ODhNK0UGIiZAWr+GTRuTtfo+NgfbJ+iIYNdZXOHRHJ3KF9Tk4w==
X-Received: by 2002:a37:a2c5:: with SMTP id l188mr327859qke.90.1628276313377;
        Fri, 06 Aug 2021 11:58:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 195sm1030544qkg.110.2021.08.06.11.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:58:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 6 Aug 2021 11:58:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/16] 4.19.202-rc1 review
Message-ID: <20210806185831.GD2680592@roeck-us.net>
References: <20210806081111.144943357@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 10:14:51AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.202 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 440 pass: 440 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
