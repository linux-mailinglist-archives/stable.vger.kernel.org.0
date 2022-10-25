Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E833260C2A1
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiJYEac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiJYEaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:30:23 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C6720F44;
        Mon, 24 Oct 2022 21:30:17 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-13b103a3e5dso14305830fac.2;
        Mon, 24 Oct 2022 21:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s4O4jCAqnrzfXmXnvisr4ZgbO6qKzAjNgUzhsO3gN4I=;
        b=gO9j37n3lPYpc0Ldrx51SnCgHlXsKWZ2y7WM8W/v5iaOf5ahuHQpGXtkcNp3GXEKCG
         NLjGOkZk+lhCtsYxm9eavFg5VbgHZzxpz1+sdhIRlszb9mhhO7VZn2O317LYMlWLMLyJ
         keWH2BJ9HbyosZgumIbx86Ae+kRpK72gNqzcEybLMquel2VBpxQLJxzUZzckYQhtB5kv
         78hXfCYY1Clc6ziyNr+xo2/4mFuncoZzo9Ba/oyTS+zKL5OvcUVB5pDXc+6iNfpyWtDD
         vbMbzN2BlObZ+Zy4/SSHR/pnaCI3njzZVPH0QPZo3nr3C1ty9RSBSK3k1Lpna7Qwf6Em
         VXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s4O4jCAqnrzfXmXnvisr4ZgbO6qKzAjNgUzhsO3gN4I=;
        b=NhM8XnFtyrrQP7VO95UJlvyCibRast40QlAF3LAWlpvDcZ0tYdMCVnDjDTZKDK+elP
         uPfkPyqpJq8nMRKs3vTaviKp1/q0p41V5sluobJRnqZ6QtNqEwo7F23e47EHvKpyp8Jp
         QFVHHAarhQGYGcHFDnCkJaMMGYwY5rOc/ABQbs/1hrseyoR56wVExIePKwb6+shhC7iN
         hMGbDZLAIgArXsK2sygbYILm8G6QzXLzxkdFAj64C6rrLA+d5DUjdz1D1o+w0aX2fS0J
         R65LEKGdUzHXl5qaFi8wNTjUWR+JCk6+ZL+LxQSQPcSSPoJbgWN8KkRUO5dQGEh0pz5x
         wefA==
X-Gm-Message-State: ACrzQf2deWhleyqh03cXu9gpIT2X8p8xPJizt12r0O3HbKPDRAgfTKY1
        q0haxyixq08lDpjsNdU9KDo=
X-Google-Smtp-Source: AMsMyM6d7YxZ78J6LH9uIIvrPOGui/Eq1YT8oHZTBrNfvVRrrOUwDEiV33DGRYUXTr/ZYsnnX9UveA==
X-Received: by 2002:a05:6870:f202:b0:13a:f34a:9f31 with SMTP id t2-20020a056870f20200b0013af34a9f31mr15415592oao.57.1666672216353;
        Mon, 24 Oct 2022 21:30:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k3-20020a9d7603000000b006619483182csm593619otl.18.2022.10.24.21.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 21:30:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Oct 2022 21:30:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.19 000/229] 4.19.262-rc1 review
Message-ID: <20221025043014.GC4152986@roeck-us.net>
References: <20221024112959.085534368@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 01:28:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.262 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
