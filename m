Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5B533215
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbiEXUA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiEXUA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:00:58 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A6D5A2CC;
        Tue, 24 May 2022 13:00:57 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-e93bbb54f9so23558222fac.12;
        Tue, 24 May 2022 13:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xdqMHHqBDBxG4fAcbv9a3pbuucj1HKocdtacUijQBY0=;
        b=f3TW6LctIYA0rr2hs0QM9c05JYG/kaVoeAYYXwY1cQ+FtBFgQRazqvAM0u9gzOCAwP
         ydLjZBp601qeTyqC1YX5RXS0iTWYEiUwtrmobikSy12YDaYkn9Q1zpclP17Z3Xcz3OUh
         r4Bh3C19zoNsLGy/rWUZ4c/RfzN4hjAMu2s5KqeGTT4KSHoPha4FknAOeQR5mkG3LW2L
         i3bGtY3d4U7Y/I9dteNvldkAjld5v57QfXT5j59KYfqin4s2cMscRmf99GzRgwan3xaK
         P4vk1IwIX/hIvz4+TFBBsiClVheeJqUTRbsIpfSSyLHyrKy5cB6PVxc1HJsaVvU2zTiq
         xGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xdqMHHqBDBxG4fAcbv9a3pbuucj1HKocdtacUijQBY0=;
        b=g/c0eKlamRQERzhmdJfriMpyox/UGZAPR6RLOgjc7THRMjp55uUvwJG1NM+Vf7F5oR
         qhwG5lgUXz179SGrF3RVMpT7tSfJdMTLwg/YJQJ1FOsJnXr+dUZFRIB5UufwBRZQ88o1
         xQfCmxrtDUPRPkgDLJZE1MtVRtqRQ4jXXKVVDhyoOn2Gv0/P1TpELC2Vfsor4dpmXODz
         8iBXdd6/p2sODEf3AAhnCRY9RcrWNCmz6n7OZftHpYKsVJ29wUXYTf4JCANVI+Apbr/X
         65fDdd27FQeZ0SefvIKjyk27m3YUPdtR3aYhYP7Eut5qXBL2IQT6vDQjE+tZtGWIGADE
         ocQg==
X-Gm-Message-State: AOAM530JEM0KuJDl8xrTb4FKQPrMGg5FH2ZU4er4aBc2jxaA/Tq0varH
        Yg+Xa8z9L5u3Z09KT5frDa8=
X-Google-Smtp-Source: ABdhPJzsH4g80/KHIaZHGBEwZ3bJZKxpyWl1QV/M2QAcpyOpZc+6mDiBi3XcJ+Z4rrlbxESu26qdGQ==
X-Received: by 2002:a05:6870:a117:b0:f1:bb16:4606 with SMTP id m23-20020a056870a11700b000f1bb164606mr3562835oae.174.1653422456953;
        Tue, 24 May 2022 13:00:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o83-20020acabe56000000b0032603df9d24sm5464564oif.47.2022.05.24.13.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:00:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 24 May 2022 13:00:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
Message-ID: <20220524200054.GA3987156@roeck-us.net>
References: <20220523165743.398280407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 07:03:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.316 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
