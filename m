Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7814BEC68
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiBUVTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:19:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbiBUVTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:19:13 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91A163ED;
        Mon, 21 Feb 2022 13:18:49 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id a28so35317269qvb.10;
        Mon, 21 Feb 2022 13:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7gX0PN6REx6b44EP+9zZTrUFki7k9rxBSgVme0obgn0=;
        b=Mt9rSScJPk57eIGQFzSa1lSdH3jAs7dYFdvOgYcGcBDvAY2RC+C/zjkeJtZLzlY2Hi
         rnFYpE8HYvi+GvDD2Hu+42BzYD3o3G9cdwDtFresL7zDHAc++0p3YIb/NLs7JhJlfcv0
         0oF7jUFuBj9+XOU4NB98YgEXFeu8QCuwBef/6NMJKzVVBWUHyvogwGFUbMD5uNimCw9c
         SlLD5hkVUxHk78SfRsg8kkaKqtUWv1jFXOgQYI3sKD3tzvmDo743XiLq1muBBOqoksaq
         +B/DnuDxnoO+lhZWPicbA7touc4SvUmpAAlYS0yqa01rdiKEpdGMEDJlVO5hIQO//4eI
         p42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7gX0PN6REx6b44EP+9zZTrUFki7k9rxBSgVme0obgn0=;
        b=xKVoaOHJ1SwZ8Dzw6s4Om26VZaclF6SCSqDlkf5nUB6bwQjhI4Ke/5I1lbg8QIGl6i
         iKb5pzCpwFKu8E/+ywLbdfmwNeB3XtJ/QP385kbjUP4pOKA6CxZnxOaxrI1v78FHgVFi
         camK3dpQGjuQ+1SV6puCDGmH1kGzvpv2FlehmTDrDmnUDAHcHQm5EgVL9WMNl9lE0TnR
         zEk7l9KyNYGBAjbKG5jQFvWbO3b+urQtIN8rC4bjQfZ9dAN7/+N254B33fJQ4Z6wRnzP
         udUzzTTMps7aztqeVERMsKJouneeJgiMiiG50UyDVZxkJDlsqpD7exM+7nTtlkov+ay6
         n7YA==
X-Gm-Message-State: AOAM532rB+nqAAGJqJZVYbwzosUz9ZHfIik2OnuNhZ9s6qHA/pwXXZD0
        VdtV5EBjacwhuUNs3/2sdUA=
X-Google-Smtp-Source: ABdhPJyLPLk0WGhcuZ1Xapo0vm+MW2TsGIFJHIbszoS4+xfA4PbiB3zdA5OowZr8n/gaesnnyAgyig==
X-Received: by 2002:a05:622a:492:b0:2da:74a3:c472 with SMTP id p18-20020a05622a049200b002da74a3c472mr19096310qtx.658.1645478328939;
        Mon, 21 Feb 2022 13:18:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i6sm763231qkp.79.2022.02.21.13.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 13:18:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 21 Feb 2022 13:18:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/121] 5.10.102-rc1 review
Message-ID: <20220221211847.GE42906@roeck-us.net>
References: <20220221084921.147454846@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
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

On Mon, Feb 21, 2022 at 09:48:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.102 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
