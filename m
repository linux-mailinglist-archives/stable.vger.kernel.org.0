Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25BE4B6041
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiBOBxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:53:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiBOBxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:53:31 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EA5140740;
        Mon, 14 Feb 2022 17:53:22 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id s24so19386385oic.6;
        Mon, 14 Feb 2022 17:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ubqb2L9ofFczhZiHH2mV/rWxWC+WC5qrei4uNq+4VYA=;
        b=fTYfuV080FyTcQBzEl80iXu3wOTMMUO2NUyX8Smv2su/d91IdGJAe7a5tGZdHnxErP
         ZhbFZxIQWmWQvglv6BXCjPyj5kwqDKomfP5m6VTcbGI4AFrn9hMlFKPutQd0lkBDpaY/
         fpSZo7YwWl2viZwG9G1zjeYTYLYtvT7Q2iWnq5ievz3ryo2cq1YfcUPB3ikBSU552iqQ
         j2zYLhaRCf2vowNb+BiBuKveS4uAV5H3qHLXcSTmUojY3AIOzwmH7/GUlCGMHiyJl8Kp
         zGUihO9CsJ1NCRAHncIR1H0DOhzPSMcVPGarKXJdIjXvyk2ve2bDAcQUSaMOCYvvONyc
         ZNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ubqb2L9ofFczhZiHH2mV/rWxWC+WC5qrei4uNq+4VYA=;
        b=1TRmfp+uQcY/0HxuEwv17p/D9WX6po8Zt5Gi/2qXH3PUGTATsVEegNF92iWd0ESdHS
         yQgxffTO4UOxvV4cRz+qgFClBftZ/Vv/grGQWbFjvglyjjBRw47lVoZ1n7v1bguJ6DKH
         UwUICUGd/E7qWPUr4+JFrgqW+2rg+hcIzH2tWhVxQ0rAQyQf/4PrwsocoqekczePEvuT
         oGSkzCLD9PqZV4sKb5FvKTdSA9XbQ4h8Y/9lQDXS4H5ngsos074ZqHnbJgiMAD+N4g5C
         wm3Pm2/KchRxzEdJZQ48UxhX+cNH/vjdB5TJxyzv19kKKPzXeZ3ZinzKG/QE/NzwJJ9z
         19mA==
X-Gm-Message-State: AOAM531U4Ns4C1e8jhnhF+DpstGp05TYOb7lzZ0KYCoXWJjvJlnlwOvh
        nxwKDlGWpB4kCcz2T7+HM1U=
X-Google-Smtp-Source: ABdhPJwLmIpXdy3eYgVjzDCV8fPiTmOh0uBKi38uqwBFKXCDnqIYA8Fxxlhotpms//RE9fDBf8xKFA==
X-Received: by 2002:a05:6808:1302:: with SMTP id y2mr743120oiv.177.1644890002211;
        Mon, 14 Feb 2022 17:53:22 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t2sm13397259ooo.24.2022.02.14.17.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 17:53:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Feb 2022 17:53:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
Message-ID: <20220215015320.GG432640@roeck-us.net>
References: <20220214092510.221474733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
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

On Mon, Feb 14, 2022 at 10:24:04AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
