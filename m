Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B13B4BEC66
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiBUVSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:18:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiBUVSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:18:51 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0896264A;
        Mon, 21 Feb 2022 13:18:25 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id f19so35277980qvb.6;
        Mon, 21 Feb 2022 13:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nx4IjY9e+E1FlCkez7buahzsJ8CqgLEG2UjzJWbUf8M=;
        b=PEQJTAavsPrFhhUWOAPdQuH4Ax479JP6rORrEsSbgnjdNOqvJejZ7Y2wk0UgDzi0pB
         PtzNebZViU8LteSddpMcrapd9wDIYesDsE3rUJ8eNFZc3N89T/n3KSuk5pFPazfjNgem
         ciIeubAFgVnNIytcdBqJ1hZujoQer2ZQAtoW8JBGJYtCOF6k/86gEgoxolcM3zgFadYX
         G+4x4cy6mmZjxRI+cHVwZfFjqX9qHMypgJWO5WFoHcwRBZ5G8T1kbTBZvdNPQwHRg+wn
         XTTLtD7MO2VIDsgY/LX4+2PzG+wXLl+wDzz6iutK3GPlLcMnt4XK6hivnBisy55nZ7YD
         UJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Nx4IjY9e+E1FlCkez7buahzsJ8CqgLEG2UjzJWbUf8M=;
        b=bDPmL9bjM1tkMWQAkjMT5vR+C14tnAbDj3LLQT9B7p7N9puuz3tCUHVtZNWA3HjM1W
         4qPuGB1+6CQKPfe+4RmWU3nueu1IbdhpQDs9QMkv+PFqGGA2rNQe8WtBObPgXuZaBXKg
         BcbIZfOV5ttR4QNwdExqNkg1s2jxtxXtk7iRG5hb3jKYSEEUEZafk2CZ7Cfxz9N/NFzP
         nZOdiWL3Gbh8ycATTCWHLeYyU6hxUQH7v4lnjMs7BxXBvgJ9bfmLKRZFgLhAtOcRhsuz
         kBJTUg69HpvHGBNS7rW+YgPr9QysRC/QPuBvTq+8DNg8YIFssXAz/vMNwCzZ7LMCFQyK
         ybag==
X-Gm-Message-State: AOAM533i/3/b6cwmsqchMZH8Ssggc3ASHMTQEabcZnPEE0jQTngMejgK
        KiyhtCYHnN15Epy5GqbVlyoEq9W/sswDFw==
X-Google-Smtp-Source: ABdhPJwy7uO4MqH86xUK7dfgYpvmdwvN7XMCUaeQp4IjDF6sIDsI/+YV2SXvH8RHl+y9uxaay9FNHQ==
X-Received: by 2002:a05:622a:1186:b0:2d0:5c73:3518 with SMTP id m6-20020a05622a118600b002d05c733518mr19155730qtk.367.1645478305028;
        Mon, 21 Feb 2022 13:18:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f20sm32307928qte.14.2022.02.21.13.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 13:18:24 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 21 Feb 2022 13:18:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/80] 5.4.181-rc1 review
Message-ID: <20220221211823.GD42906@roeck-us.net>
References: <20220221084915.554151737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
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

On Mon, Feb 21, 2022 at 09:48:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.181 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
