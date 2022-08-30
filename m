Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4FC5A60EA
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 12:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiH3Khn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 06:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiH3Khb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 06:37:31 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC2BB2CCB;
        Tue, 30 Aug 2022 03:37:30 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b16so5983398wru.7;
        Tue, 30 Aug 2022 03:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1/sGTM9wRcjPahu1/s+ARvRUeTTtd8qkJ+JtVGLzxMI=;
        b=i1zs/72V+Vnz3P+wIhKBQSpmjHiqfppuxhGiHh5dcdD2vs8av675FbESyRQmd4J5SK
         wxDDHTHEEnwfvqgUOwzqls9kBQm9yRvyb5YyqGek+mUXPHPI7jTnhif1XVjlv+vsSw5/
         cYFa2GZIsr3J0TpgmzGTnvyVkfYx0XPRt94LTuOSlPQEmYVxljAxwi+xgqM8z7h5FZfN
         QERY0HbnD68/+9GGhBfF1t6PwpVdzwQxk9Zm5nFJBOd2gix8+X8ATkQZVa+8Z4huG2iZ
         Fb5EpVHNzTZP2XY7uryI/YL6LEA6UtsYMnSvu3pqmC07eJZrE0d5bw0rfu7cv2VZUP0P
         8y+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1/sGTM9wRcjPahu1/s+ARvRUeTTtd8qkJ+JtVGLzxMI=;
        b=gR6DYJxKfQpZs1JDZuhNPt2US2uPZVzvZdnu9nUhdfu/9oCUdGcnsIZfFitUyyuE+v
         WFYrYU2zWpYBhYCC3O+e+M9XQM/GuyR+4jTY44KRZkDImhJbab6iNKZ/dgkydJy+eoTr
         xs864gF67P2FfIQJxMZC9oF0NIA0a/f7UPV5lH7tJBDuIeZhzs8OxzP5xyIRVOECb9uO
         dd0Xf7pJyMu85qCIzrI/eoX43Ezl1U/3rFnhdi0qlJ33si7jA9yAfCn3Rd7NH1FfMRMa
         ofB9K4txrsL7fyddkcn1HWDcNillYrSISyvt8pU7xXH23D8fc1k1lFrCqeyH1NDbR6tv
         H9DA==
X-Gm-Message-State: ACgBeo2iQ0izNY0BywsuQoxEX5dhhKr3hcb2bHwcmGPyJKSZ7NN7hsSj
        6lybrX0V08fHf8ClQnC/fSo=
X-Google-Smtp-Source: AA6agR7sP8jjtxAZI0RZZT4ZFgv3QTHM0uqIBqLrt4Sinzm6G2HZIiCspY1iNai8S2Q06heOhs/FyA==
X-Received: by 2002:a5d:588f:0:b0:226:e03c:bc6a with SMTP id n15-20020a5d588f000000b00226e03cbc6amr2657596wrf.331.1661855848771;
        Tue, 30 Aug 2022 03:37:28 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id da12-20020a056000408c00b0021ee65426a2sm9984747wrb.65.2022.08.30.03.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 03:37:28 -0700 (PDT)
Date:   Tue, 30 Aug 2022 11:37:26 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Message-ID: <Yw3oZlIwhvJbG0rs@debian>
References: <20220829105808.828227973@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 29, 2022 at 12:57:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
mips: 59 configs -> 1 failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> fails
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

mips and csky are known failure. Fix not yet in mainline.

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

DRM warnings in rpi4b, now fixed in mainline.
Will need:
258e483a4d5e ("drm/vc4: hdmi: Rework power up")
72e2329e7c9b ("drm/vc4: hdmi: Depends on CONFIG_PM")

[1]. https://openqa.qa.codethink.co.uk/tests/1731
[2]. https://openqa.qa.codethink.co.uk/tests/1734
[3]. https://openqa.qa.codethink.co.uk/tests/1736

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
