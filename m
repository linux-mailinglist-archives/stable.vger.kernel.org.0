Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3D5271EC
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiENO0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiENO0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:26:07 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF1E13F7A;
        Sat, 14 May 2022 07:26:06 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k126-20020a1ca184000000b003943fd07180so6171976wme.3;
        Sat, 14 May 2022 07:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Ibwgo9kMXrq789T7CgEdIWGaZoChbTv3X0i3RzzY0A=;
        b=GwAsvosKirzfXhuEHcBFQMZ3atTXd1/1/hqGmMFtlGXhr/rpWRqI/nKkA4KJ4iN22L
         YkozfJ0A2oqf0SkcPAKLgsOKESo3Mn5tZesvWIYs0lUAwBxjpSEUzEysG1TFtS43bqic
         xoeOM1yMYa8vv46jH2yfG/CGweU7B1469OXuHazQl3xo8sz4ROIcR3INaNkbJoVgTyua
         NUlvpSWCTeKJlQIpGDZjWErEMGxawlXyibVpTgG9fv3+GIAErFWlqSLxuxJpf5lmu1X0
         GvIDnOSlh72ByaMW04CTEgOZUdkTJcIRbetuXncS9pUfUJ+POdIf2jvolD8hcFuQzElr
         KZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Ibwgo9kMXrq789T7CgEdIWGaZoChbTv3X0i3RzzY0A=;
        b=k/GZ5Lq1l4cI+YxKZxDjbVr9N1X7h9BjY0RvI43VmNr66iUgyk26iylDE/6Qv8O+Hp
         sYtL0Pnc8p6RhFALcjQ90vG6SC5CQgFtpdTK1vPTb0LJhMf058CkOzoqXO1c3dCWGgdj
         IVHgdwned/lyetKzXujRGbVlZtox0vONw7Ix+bWQYUU3LBLgvQJUqEiowbmY5B8QnkfF
         mtj5yvWuKuh+sz/IYC6iQsLI0JI/seCiHSPwPAvM5SKxPSwhe10IAW21biDcUuNSSm9W
         8jR0rYN5dOURbbxUPpjrS1V4qnkX5FsKBStgrVEttZNKGp74RffKyP4dCkYt8FmWIJEe
         Uhmw==
X-Gm-Message-State: AOAM5326C6U7ntYjNOP2Tq279usIMNcYC/4a1FpjFmI/80l9dlOOLD7E
        f3ntwYiylRyHEP8YNqrIFghDZhOX/io=
X-Google-Smtp-Source: ABdhPJx8IjQ/FJJIxJShcuKSm1vQZ7XP2Ftv2kaJqcHmyZpJ3Ia8eWdiUii5tE5bSGK9bzV8nk4NfQ==
X-Received: by 2002:a05:600c:1d18:b0:394:6469:abec with SMTP id l24-20020a05600c1d1800b003946469abecmr9108599wms.89.1652538365208;
        Sat, 14 May 2022 07:26:05 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id i8-20020a05600c354800b003945cdd0d55sm5740858wmq.26.2022.05.14.07.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:26:04 -0700 (PDT)
Date:   Sat, 14 May 2022 15:26:03 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/21] 5.15.40-rc1 review
Message-ID: <Yn+7+6j428/KQFbN@debian>
References: <20220513142229.874949670@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:23:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.40 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 62 configs -> no failure
arm (gcc version 11.2.1 20220408): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1141
[2]. https://openqa.qa.codethink.co.uk/tests/1145
[3]. https://openqa.qa.codethink.co.uk/tests/1142

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
