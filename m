Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDB154A2F6
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 01:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbiFMX5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 19:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbiFMX5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 19:57:30 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D37BE0A;
        Mon, 13 Jun 2022 16:57:28 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o17so6405403pla.6;
        Mon, 13 Jun 2022 16:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4R3w5J+2f2eKXC2fUmaU5MpidiTLXwSmKmDDxLp//cw=;
        b=QU8MTAQunnc2zcbaUcaszElO/cVtoeenlVP57CgXWV4WIg5o29R34E4ia4BzFbgL9Z
         oMF+wvCC+QUXuls5Sc4KSWs4Cu4Q2HjJs2s9u9CrJzZiHW6uvmJBEbk22ufhWr+oOCH1
         s3ajo4MKHDmTEVitvRqUHPwvXVt2S9aiGRWjww132+109hA/s3h/HIABW5lAq7IcZ4Z4
         z4hSSnhHptD7LR0z5l46dN6V7Qsk8ClRqIuTeA19bbY75c0CsVXFo4X0nt2QaSgKV8x4
         UWCQhaTE1A3jdigFEZA2kgg5vCn9Re7LwKj8wYgqTG8I0NCDZGoXxy+lwTr/WdBzhA8z
         XPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4R3w5J+2f2eKXC2fUmaU5MpidiTLXwSmKmDDxLp//cw=;
        b=XaEjoMoGYa6WSvbPp+C1ODBM/ETDP7Rbg+Vy7Ud8uC9tVq5IKqQNgyGNK+nnj5tOqX
         4xVdnOe1XQrjrJwWxOh4Kw5Nj6KMmhfM+F3/jcrRWdOw1z+1jGvDG7tdpoyUWgwjKEVc
         ELTClBjrOLukPVIg+E/wGomg+/qsQ3wD92fOaXVoy9Df801JeqGa8rWTBxMd+LLaxGu/
         jHcYsmS4ZcMDo2RqhY6iwRjoivIvYLLlRm2NhFRX+VcSaAhqWaOdEaZSwbU+/fDSmWTy
         mZl7ZYQbUzuy5DEVT8yQX1DVCpyYsSDygWp02bdXwmP7Bm8z/ciPvVNTr6Yn4Uxfh94D
         +97g==
X-Gm-Message-State: AJIora/vU3wr0lj7Yrg5tRGVpZaMHlcuoxy1HeNORJCvGd8TApCsxKHa
        e6pD8ex1ND9hZoJnxjjjAuM=
X-Google-Smtp-Source: AGRyM1vHtdk9O0t1g5vn5U02r+P+vKpgqxrsmUYOXVk1d9MWIm3/EEXI0YUXW2k2OAyUwCBF9C7TJw==
X-Received: by 2002:a17:902:ab08:b0:167:7fa1:60df with SMTP id ik8-20020a170902ab0800b001677fa160dfmr1413106plb.71.1655164648194;
        Mon, 13 Jun 2022 16:57:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y196-20020a62cecd000000b0050dc762818dsm6003503pfg.103.2022.06.13.16.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:57:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Jun 2022 16:57:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 000/287] 4.19.247-rc1 review
Message-ID: <20220613235726.GC1666524@roeck-us.net>
References: <20220613094923.832156175@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 12:07:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.247 release.
> There are 287 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
