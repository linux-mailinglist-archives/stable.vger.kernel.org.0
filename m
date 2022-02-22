Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8870C4BF80F
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiBVMb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiBVMb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:31:28 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D0A9A4DD;
        Tue, 22 Feb 2022 04:31:01 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id f17so8046692wrh.7;
        Tue, 22 Feb 2022 04:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ytf3B0TUzpPjLZkjeVV4ovMnqxam63CdUAj7HAoJ+og=;
        b=S4aJFdu7ESFjce26eB1MIRYSKt9cw58AJ01xnESYdhee6eGT1jF8awIfYw7gGqhz/U
         T1qu5WuWvfpnr6p4QMts4lJr2jL+BhPIqMvWv8bifRQWSwqy5et5w5jn9/dSKcGwVJ9E
         82E6f10ke0KhT7OiCZS/PIEGU4E8CNuAtNOiV1vLtvd7wFDSWefFtgXb+Jkj+jkZ2XTR
         LWolTgZZXiwOjcPwacWzFHKMh8/ZTJxlk4iLuIJQl6qPbci9J0tgzCaEhoyTpYnquA84
         VUhffwxUXIYGSeBzxFFn3fItrDlOqnJ9c3a6ySwIN6iTXj0g9KqzMhJ8y8MoRNL6c1NM
         26nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ytf3B0TUzpPjLZkjeVV4ovMnqxam63CdUAj7HAoJ+og=;
        b=u65zFaKPxwUqWoUlJBfyOKOdSQ7gPDEOz/O8Bc/NHImk6K51GysPphnaB3r24galGW
         uyGSokVSunwOPJJlHBmxwbET1HPOyJQ5PgXGo3WUDyh0y1EexphewiyqaBMUTc1ggL+K
         4Gppa0Od/9n/rJ7hcmy12LPo5F5qOfe68fHE6ZqIVTjzfHzC/xYWzxwVIgOIGGIvJ2Wq
         O9tlulwIaCbTHFy+Zhqvb2802jVYHRyFd8QxmN1yuRlYRG5LC08wERkh9xemW4KYFD7e
         vovhte0WiwN9cA6Lm5OnqOrtFpiXAmGb6kP38Tup0l510chEV+jEfPet6aWdRz9dTt4G
         zjfQ==
X-Gm-Message-State: AOAM531ZO7VU2nHQA5Lj/EQUDPdd06HyeI8LhyunjTq+Vgac+uvduEhK
        newa0lwzVlhrIVPLOd+1Ju0=
X-Google-Smtp-Source: ABdhPJzWwW8IcKTuPO9AOzq1sTPEbYVE7yBhhBnybH0UlJtZEfjXBvWQHvVLF4V5f06l8XkRCmNBDA==
X-Received: by 2002:a05:6000:1ac7:b0:1e8:b550:a596 with SMTP id i7-20020a0560001ac700b001e8b550a596mr19112977wry.584.1645533060492;
        Tue, 22 Feb 2022 04:31:00 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id g16-20020a7bc4d0000000b0037bbe255339sm2296177wmk.15.2022.02.22.04.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 04:30:59 -0800 (PST)
Date:   Tue, 22 Feb 2022 12:30:58 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
Message-ID: <YhTXgiBmJqO1uh60@debian>
References: <20220221084930.872957717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
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

On Mon, Feb 21, 2022 at 09:47:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.25 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 62 configs -> no new failure
arm (gcc version 11.2.1 20220213): 100 configs -> 1 new failure
arm64 (gcc version 11.2.1 20220213): 3 configs -> 1 new failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Both arm and arm64 failed with the error:
drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:726:20: error: operation on 'rc' may be undefined [-Werror=sequence-point]
  726 |                 rc = rc = PTR_ERR(ctx);

Caused by: d7151f4ed49b ("optee: use driver internal tee_context for some rpc")

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/794
[2]. https://openqa.qa.codethink.co.uk/tests/800
[3]. https://openqa.qa.codethink.co.uk/tests/802

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
