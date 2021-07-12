Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C786E3C5D91
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhGLNre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGLNre (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 09:47:34 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04209C0613DD;
        Mon, 12 Jul 2021 06:44:46 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 75-20020a9d08510000b02904acfe6bcccaso18860803oty.12;
        Mon, 12 Jul 2021 06:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JDiXV3i3rqyi++006FiTx4duGk4ywrBq3HXjBhSboQ4=;
        b=PYueBqCpoOt/mdHGyjusUbfdIJwqsO2X2VfGBUlExTVIJh0Zd/bS54K/n7poIOW7kz
         f/aSQt8bDlFtjfu7r2BPqOJHma0b9d57yRD2IUe61FnHLMOhugbFtX7e/bWb9FyddAne
         mqGPyCcBOW8M29thZ8C9Hl+/6u0Rfq1j8Hsl23PxdyG5owe4LvvJAmA2+emfvLAOpn+C
         bvyWvI4Mf1LrNvi09dm66bc8AjqJcC/8XIr6Bq3PBnZxuBjiPjVMHBmdWPBXJ9JQbu9k
         BSsw5xCmupARKl2PO3yyp0t6Cp4dN5yJ017jiWrZMUiFoT8acJYjXpyyXxHPsJSL/eS4
         EcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JDiXV3i3rqyi++006FiTx4duGk4ywrBq3HXjBhSboQ4=;
        b=glPfhqbB3mwlBmQWO3oow+buVjJtxLCET/TrGk1T4O8sK/H1Kh9+3Aw/TRnPCCAton
         iwSlyVegzLTapeSf/iUEfBnDvZDJsswzV8UVQ7hbCxThEiYXDHQ7b51kWvE1lNVURZpP
         opjm5Jiy4jFEQhlLOvRFnClKaBcg8cIMDWkAS6pFjxalccKlUiYOuCRcaO7WwkyIQ6bT
         cpqYY6G/3TzrwszGoWFAsa3oow1revNo+6Qez1rVgAaHKR+jTkwds6s6I4MpcKrbOyao
         XEEFIWX3FMV9bDWt4P0q3L2/Xpod+xGR94R13G32/97PVHdn4lbFaDOg2kAgtojZzecZ
         QVRg==
X-Gm-Message-State: AOAM532AfQPfpAaPuaGhA8UNUCzPzSQ1yvCuNbxXjNNOupI5r8aLC1Jp
        j5eDlZriJyYYJIu1+ofFZVelQEvcP3o=
X-Google-Smtp-Source: ABdhPJwP67e+bpOuiQ9Bh+LPaiqtH3djt/TdWug7UpC50CgXUm83jWsPL4nerj+zzWVQXPjTF6DeZA==
X-Received: by 2002:a9d:7457:: with SMTP id p23mr36834448otk.85.1626097485173;
        Mon, 12 Jul 2021 06:44:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n26sm2515960oos.14.2021.07.12.06.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 06:44:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.4 000/348] 5.4.132-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210712060659.886176320@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <806c2ec9-9e2e-f151-9873-6c53e20cd509@roeck-us.net>
Date:   Mon, 12 Jul 2021 06:44:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 348 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 153 fail: 4
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
	powerpc:cell_defconfig
	powerpc:maple_defconfig
Qemu test results:
	total: 428 pass: 404 fail: 24
Failed tests:
	<almost all ppc64 tests>

Error log:
arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
arch/powerpc/kernel/stacktrace.c:248:33: error: implicit declaration of function 'udelay'

Guenter
