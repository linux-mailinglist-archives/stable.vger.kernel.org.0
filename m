Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB48F66DDE4
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbjAQMoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbjAQMoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:44:09 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87645113EA;
        Tue, 17 Jan 2023 04:44:05 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so24336490wms.2;
        Tue, 17 Jan 2023 04:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6sBlRrq3xEogAt7tAHbEeXzaCTTRziq/T8p3ux/5hj0=;
        b=At2l8PbLlvpWYqlVDkmtncf6GV9Uo2jZsIe7XReevvrXLiyGVFVc6+tZH35hQgAEgl
         3QTDKCiirZoSSep7UGm7QVnMFP+AHD3lSMVlqocCPDYN1nsHxMAQxlQCSlwQ6UVwOadF
         BiC9vnqSZgatGj9/udLFEDw4AhMcDCIJUykIXrjt6CDLwIU3BuNGgqiatcQKrcEZC1Ni
         cGIbDXyYS5HSG0y1t6MZJG6Cj+L7s71fJkDDL+djNlQtz/XbaAx4qbi4B++lGgKa0C1v
         l4UNz0c+b3tg/odmRqs5W21kgiwhKuhqnMKugTNYrd7eWC6HbC4l2KrecpP3AhtMguAM
         0VHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6sBlRrq3xEogAt7tAHbEeXzaCTTRziq/T8p3ux/5hj0=;
        b=wo9msTgkFNNhpZUkjb39NQIamA9u8BTpRhhIL8prX0sz0PySju5g2mnMBTb9YriS3E
         87R3F235p2NzOOdmX+I8qJwpKLEwwAtGizB7XHQQdZ+aGNe4OjvDEwu+pJgg2QEmbCQp
         zMLK1wGuhVVhKQx4lFEcSTqWGeYR8Uae6RKwgQv0hfHOuKZ1VsNnfG0hc8l58ta1M6IM
         7wv6PEqp7pj+GeG6ZQXvXy9sY7B+P4hBSpLKyuB9kRkvEmIi89u3EghZdPdUj+bru41z
         uRYCT4OuJPBLI3CIzJE+yZUqH+PpWY2Qy1wxu+NDQ0nKTJYWMmXm7EkamR6qHv+LEVWu
         mamw==
X-Gm-Message-State: AFqh2kopOIuhDq8q5WPRNAoX+PW+W9iwWMKR3Ql0VI49z9l/uqidae7I
        25eQlzifCUW+R2VGtJelxUY=
X-Google-Smtp-Source: AMrXdXsG1xem8vC1jgKLFmv0kfx6zvU9tZ2Nf0M5Rxn4Ho9aapYvS4laZCVZrdPBQV+UBolQsDrFRg==
X-Received: by 2002:a05:600c:3c8a:b0:3da:2a78:d7a4 with SMTP id bg10-20020a05600c3c8a00b003da2a78d7a4mr2927016wmb.21.1673959432094;
        Tue, 17 Jan 2023 04:43:52 -0800 (PST)
Received: from debian ([67.208.52.125])
        by smtp.gmail.com with ESMTPSA id m2-20020a05600c3b0200b003dafadd2f77sm7377031wms.1.2023.01.17.04.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:43:51 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:43:49 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8aYBRwC5Opnxdrp@debian>
References: <20230116154803.321528435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2663
[2]. https://openqa.qa.codethink.co.uk/tests/2665

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
