Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745C234521D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhCVVzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCVVy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 17:54:59 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD13C061574;
        Mon, 22 Mar 2021 14:54:59 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id i3so14732570oik.7;
        Mon, 22 Mar 2021 14:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DKmF6215jWo3mOSpzDSgc14FUwZw8O5oO2ZH/DHpW+8=;
        b=Af0q2vIX5h5GX9hi6ACnFcuHdVkR1Q/icOuncvxTD+7qEl4gKwiOQDWn19y4onsTUx
         mHZk4bKWBUPu3FZLGuD1X3kiJrLWqDdPsm4nr5vFKYCrUxnVRNCyl7fr8AfL7F7/8liw
         +QlsE6Iu0IPZOy8F4l6m7ORPZWlsAODNBchKrwPR2ufGMd/BD1p1xJmgRHM8O6lca3Ks
         YGhlNcWGQOBNhjY5Jq/PoEJHgZ/NKtFOJWnrSj5ulxdWns7zkK7rAwNoxE2nCqexT43W
         v/QWupw64x53J1V8tfj3jxHd+RgYWOm/gxDHSSzmomJIDH/l0a3Hbs3+ikm/KhsaY1ci
         H85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=DKmF6215jWo3mOSpzDSgc14FUwZw8O5oO2ZH/DHpW+8=;
        b=Xf3sMvAmV+QcxExbz8lotrhBGzx7kZchY1uVvyR+FNgZTzQR9o+CfM3AaJcr5jzpz8
         bc6PNNl/mT4kWOEEMUqaKnWDNaeVEe48GSOEFYr/AL5e223g8i/apgUpGlm0Ljn758T6
         kRY9/sEXp6yMkChl8WgQzTF0V3DFNqnQ2eoitELw0jDYui5rCpWCo/A/5tOAMt5YWwKY
         Zxk1qgpxbwzK+sUDoA9aW00Gzhm/uCIKoFdMkMjQdWP4yhfobeqleJpj6dGLKKIBfz9/
         Oy7lnrnO6pRm6I95hbYJJp3y9YyCLMktTsxx4RyclPHThF4GPUIJuueaRjTKY07v0lbJ
         E7JQ==
X-Gm-Message-State: AOAM532JqOKPNM2v452YnaL4kKpvC6D6iEAW9nbwxHiY4f56RiyUBI7e
        79FbOZwwrFDWUeZa53Y6txdtFVT0BoE=
X-Google-Smtp-Source: ABdhPJz4W0Fap4kgOv1o0y5Cri6Op4r9x/PB1iBp1IV8wYYHzRGlmg5wCiTkTp/wMw9VoW1PTBb+1g==
X-Received: by 2002:a05:6808:14cc:: with SMTP id f12mr826397oiw.166.1616450098633;
        Mon, 22 Mar 2021 14:54:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 101sm3711554otj.44.2021.03.22.14.54.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 14:54:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Mar 2021 14:54:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/25] 4.9.263-rc1 review
Message-ID: <20210322215456.GF51597@roeck-us.net>
References: <20210322121920.399826335@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322121920.399826335@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 01:28:50PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.263 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 166 pass: 166 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
