Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA943BA8A
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 21:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhJZTTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 15:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbhJZTTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 15:19:12 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3A4C061570;
        Tue, 26 Oct 2021 12:16:48 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so83731otq.12;
        Tue, 26 Oct 2021 12:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5auenMtHc6ZhDj10YEioF4UYZccWVNPzfdTx0p6WPEk=;
        b=af4Flfgoz3OO0kmf7ZHOC7oj+EeBJ6KGoEYdZtNoZBS/iQIbT6nqq/wOog7nFVXJ7f
         z0zPSLaY6jeonmW+tpF6+7MW0QffWm6tPXghpgfG1qGFDKw8lU7r30ki0MTBkv8t5Agn
         9fCsnhJsHos0HCNw9fLhd88TJ96sBz/p82NbLB1E06JpsS2QXxIpY5mWDS4s48dajVCI
         UvNqSBKbXNTrY3+c05pLlCN8zbhbEtkmEVGwXY9mZxRWDL0xBVUB8xGGHPogxW0wzCEP
         5Ya9efPGJTEFvkqEV7EqGSj04QRgfJO7A4p5KChmOvBsdQk7eLNeAd7vUBeoW5RaaB/C
         ifkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5auenMtHc6ZhDj10YEioF4UYZccWVNPzfdTx0p6WPEk=;
        b=ZOwEl4IwniqqY/S3ojJmg+ESmhW4hnTnhqjyt599vmTtbu4dOhiUjoOLHw5QZJcD+q
         FJQU6usHAgAc0RIwFK2a/XSkoFWG69Kjud0DcN8DqkfHkbiVP0GJBTsCvNKZC49ng+yR
         BxW4o7Xg0rdoeAtjKxJD/JuyAQ/bv75g5feLTzsKhfShD4v8ouk0RhPZeybrfxCBtmt6
         d1f5w+eLgRcIJOk02ZejCmojxpZkQoTa2N2QccFIm7C10Fc+KSmdXzBF3JPLZpPKMHYw
         vg2TQ1wAwUdk7u5r3Io8y8VzAXfYFPUJ3ZgetuPKVu/fAF1+E9IA4bADlYielHFel9p+
         A6nA==
X-Gm-Message-State: AOAM533inZHzqPtTg+GbXl9C5z5yemiZaQerEUXaCAhgGE5KWxdExQDZ
        xtOBBThpG2rt9z2Y4bEjv28=
X-Google-Smtp-Source: ABdhPJwNZjkKE5UF7/j3CuwU+vft2V01jhvnLlVqgDrKt8S5uqJNvLXFLeeH2GullUnKPtSMMJDeRA==
X-Received: by 2002:a05:6830:14d5:: with SMTP id t21mr21195180otq.341.1635275807747;
        Tue, 26 Oct 2021 12:16:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y5sm4827377otg.52.2021.10.26.12.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:16:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 12:16:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/169] 5.14.15-rc1 review
Message-ID: <20211026191646.GF2014125@roeck-us.net>
References: <20211025191017.756020307@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 09:13:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.15 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
