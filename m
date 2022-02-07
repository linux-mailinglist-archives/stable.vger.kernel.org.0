Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1298D4ACC02
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 23:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbiBGWVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 17:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiBGWVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 17:21:51 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4812C0612A4;
        Mon,  7 Feb 2022 14:21:50 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s24so10971692oic.6;
        Mon, 07 Feb 2022 14:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lPXC3FVhSeiaRdsexrbahMW88tLzqmC/XGAn3In3Mg8=;
        b=byCYhyTGnY2z2YvCwYCTycfwXEN9UjTCAabOTHjE+uCFgNt7E/7JLe77ftnltASoCC
         ijyDIYj+SqzJPqeDGYNeThBdQzlOY703ly7Mxc/PpBhkKE+WjLBjwDxqdcZVw9wKWpui
         wRfT1nuv4RG5FLNQ1qOsXUTZ3zH87eHfBSeO+o4wQOB71VdmVPKY1yF9ow6D+ykA4ZvP
         oHp3IvbOhkD9idXuEdaNQkE6cjxffeL/+YevG50eELzSmaYmzW+AjSs9TsR9ZmlDStWP
         tEFKxvu4zXsug0eH7Ttdx5MQoF2GunHDnm7jnVUqUB7ceeo7gtvl/beXGIZng0OuT4lS
         ydxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lPXC3FVhSeiaRdsexrbahMW88tLzqmC/XGAn3In3Mg8=;
        b=TNCMFYz+aFL8eBOztIvZLVEEo6sNUjcVkcWHDIrwJikvjRX7cnfxe0bJPS/VktnXnj
         Ypo896aFuQaUMJ8AZsxNaKkF/rxW9qNCa+9vYbd1X16X5NW+hUens3lZ052Ql0m8VwOq
         F9nRKWew3sFgqJizh5r1Zg0vfpdxq6xDYX35R4q3jtQ1pfUcqYuJX/ZnxvhyQm3FSFRy
         14UftwZed6oE/q6wVQnbxVFLlxFqIWITh8HAVEBancZ6pSzUHRvNXYV1ZOpMGls8tsfz
         yqFpP48mLCnXpqVYovSEWe3RMCLdYtyRGDfMFRLNCPL61XPRvANTsglFuCTkt9MDZaZq
         9FHg==
X-Gm-Message-State: AOAM533rJ6kl1xEkAsh9mure/ftQBPRHopVAGKLqeGDOQDIws+TaSc3O
        s7M/879hWIW1SpPiqYsEME4=
X-Google-Smtp-Source: ABdhPJwFwmHElxZUbsWVsWWmjPD9RRn7IXtz3J7BgGxck6a6MrwtCq4VeKsgqPA2LlbHh7tpwuHDzQ==
X-Received: by 2002:a05:6808:1b13:: with SMTP id bx19mr490613oib.284.1644272510198;
        Mon, 07 Feb 2022 14:21:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g10sm4442077otn.65.2022.02.07.14.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:21:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 7 Feb 2022 14:21:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/111] 5.15.22-rc2 review
Message-ID: <20220207222148.GE3388316@roeck-us.net>
References: <20220207133903.595766086@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207133903.595766086@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 03:04:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
