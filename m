Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB3952ABFA
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 21:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352715AbiEQTbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 15:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344679AbiEQTbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 15:31:20 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177E415FC2;
        Tue, 17 May 2022 12:31:20 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-edeb6c3642so25496172fac.3;
        Tue, 17 May 2022 12:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5jSPIhzDByRmCIfEgCtUZkw25AHr5PHvPNvrelLP61o=;
        b=UO7wNJTOXBxK9eBVc3sypvUhEZcKxBiwRdUzwNzBqf+nZTu8KgjwveZ1nZpHrJL60f
         f6nRq81HiA5wR83SNu83ej46BwdG5rasJv+fua4LBwxDIZHw5pD1aQfawrBFY0d2Uy5t
         TWCvj+1UUsk/5Urg0FBmSGHIaC7a+IDLOVZu7AL4yl8Z0NBFcDZAUZbNxBf20QdgKgfU
         6GzGPjpa2WJUXipioGKq2Vp2jzxBhVXnfQZVPt5cUV+766JGFeHt1OGh4GbwYDFi+wBe
         zQD6zPbbP0ml3Y0SlDPFEz3A8xEbOUuWqklnWPX87mLCfdi64K3JrLFpZpKcuhn9NoYi
         5/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5jSPIhzDByRmCIfEgCtUZkw25AHr5PHvPNvrelLP61o=;
        b=M3XKxqG05q8gGy0n6za9xJaPxywDDJsHwkhsjMUXDjzqihCTVLVn5Sdy2MeWjblsGY
         w2EvzIp73FK+MZ79Bfe1gKGoq4fdFbL+AXJpD9o1gvKcQYBR8GWi9qsqGKjUTnigDJyS
         X5AEREkBBHh747Kx6/p6vq4ok5Xb3OvS+vfLhNUkfzVqhVtVgeKsE3VDKviqFu1wOHek
         XQQw7GuLTzIuDYGt5FuLr9hR0qypnNKSBC9QwOnwvBaCh0fwE0w6T1A82nH3jf6xKhuz
         3xr/gOUnYmeS/ni03o50uefC028rCjW8CjXgKdPYh+QVL2lH4F2VYMH6gZyLljxtTz1h
         0f3g==
X-Gm-Message-State: AOAM533EmjHHCiHaMv52c9tpLkvY5QgQ6byEH61nhMHfshB2kTsUNVBj
        iQy+RoSP0vNuteMuFubuIZY=
X-Google-Smtp-Source: ABdhPJzcjwGxYn4oi6crj0qUttP1yM5v4saCFpADBpHemyi+Qa0xWtZ9cZIAdPq3EJ1zOmsBxezHVw==
X-Received: by 2002:a05:6870:240d:b0:f1:b878:e97c with SMTP id n13-20020a056870240d00b000f1b878e97cmr3921920oap.193.1652815879455;
        Tue, 17 May 2022 12:31:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a36-20020a4a98a7000000b0035eb4e5a6cfsm111785ooj.37.2022.05.17.12.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:31:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 May 2022 12:31:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/68] 5.10.117-rc2 review
Message-ID: <20220517193117.GE1013289@roeck-us.net>
References: <20220516213639.123296914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516213639.123296914@linuxfoundation.org>
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

On Mon, May 16, 2022 at 11:38:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.117 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 21:35:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
