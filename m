Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA54B602C
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiBOBuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:50:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiBOBuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:50:39 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE1D1342E9;
        Mon, 14 Feb 2022 17:50:30 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id m10so19397060oie.2;
        Mon, 14 Feb 2022 17:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rsoyhbktrcaIGI94mlupdn+c4Acwpz5jvFUtS6JIkVI=;
        b=OLQVAW78AVJ1rB0OavAJxBg+4/JPEdOaeiqmudYRNuYMc3ChYqOck5Csj5jYOADdM2
         FosAqoPkRxrmk86H3bnPzsxc22NGsuVmaidow9RQwoKrbF90numWg9EaB3CS769kogbZ
         cgMOwtSkG5+vvqXTxWTUJ9CU/60iSWfmRWxJMwfDRk6uT8E4Ulb/Mt3Ovl7ZALZDc/1C
         gIQTppxtrDJ4P6NQz1zWDhjlQkIuuTl/bJkbRmPlOVVL+rWgcDFXFTspWi8aT+NwvNsa
         oIsVneXn9eQ7TeIjykVnKDftccr9gswhWNJtPJwPuLSyBQwUJ4xkFwROPoI2R56Shfoq
         FYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rsoyhbktrcaIGI94mlupdn+c4Acwpz5jvFUtS6JIkVI=;
        b=mCu2QY01s+WJrxln2oQQsG0u/PL3LP54gxpEh6VpxwHanB8ipEUSXL/nOXCqDgiF9B
         9x4BUJmFkD2Ntq8M/JrqmxN6Utkg+pRUx51VgM0KP/YeDwv+vwVDk+NLFQAZZYHFL+DS
         h97VAl/GszUPF2HeyYT5OhmwfRpT5xrucaY8n/5up1MoqMqLTXLP1lIsHqLT6E98Olih
         KxvC2VQOcux4m7FyF55yEoNzK181/9/yi41H7+iQQxJGdnFBa9701dgsr8DqFKDOBK5V
         p6fsu0dCqGW1dXGV5mDBdoIEAXZEaK9LzOYAvNYXjD/RrDs90sdydup/oIl4N/VZGNEP
         QVKQ==
X-Gm-Message-State: AOAM533MpfWwj1FCsCW59nCxOiRw/3zb2Qo7QhwNg4y3oDf+jOv4KITc
        G0PWZ4t0Z0ZLeos5lejD774=
X-Google-Smtp-Source: ABdhPJynQWXS1JatKhx+ZdnroqsAgH6OmpA6QGfhwDLf2Yp/d1qyXkv9lsent+hR798d/rfovB/MqQ==
X-Received: by 2002:a05:6808:1303:b0:2ca:c51f:4877 with SMTP id y3-20020a056808130300b002cac51f4877mr720477oiv.25.1644889829912;
        Mon, 14 Feb 2022 17:50:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j6sm13075028otq.76.2022.02.14.17.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 17:50:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Feb 2022 17:50:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/34] 4.9.302-rc1 review
Message-ID: <20220215015027.GA432640@roeck-us.net>
References: <20220214092445.946718557@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
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

On Mon, Feb 14, 2022 at 10:25:26AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.302 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
