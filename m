Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EB6536D80
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 17:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237228AbiE1PZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 11:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237114AbiE1PZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 11:25:40 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE356379;
        Sat, 28 May 2022 08:25:39 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r9-20020a1c4409000000b00397345f2c6fso503628wma.4;
        Sat, 28 May 2022 08:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iCcNhyM6zqp+JP2s/nhVAwZzn6FcQLeW7/wEey8U9vk=;
        b=InMqMHEdIPCtUsGGMI9YYTYACfK9DIejbgRjwjE85QyaAvuB+dPsn07gk4GMYMHVhR
         2HNdEqPAjnktH4Cm3Vuz+NbQM9MfikOH4Ommb69vdRNssWc9YUl80RHAjZS6YYUh6qei
         rTLn/Y308LaRQhbKffYFOHOxdys8wCseyNpgSNmLBt4oAyxXLoJh0BxmN3xixkerbto+
         6hINeMGkULOA9LPKKk4ZtdVhFtLNJqoMdXsMVn4/C+Hr3h8JkS0q1lwwaSG0PXV7648r
         1+tUXT0qkb4KaxhRRck6zG6KZWwyeoXoYXOrwHI81U13gnJl8SnCSXkPNuk3LA8WlccR
         4R/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iCcNhyM6zqp+JP2s/nhVAwZzn6FcQLeW7/wEey8U9vk=;
        b=h7m+6AMxN2KmthDn+J6yEd4dmR65viy414S9V51Z2uu210Eg4ezW3GeGmDshyT/2Nn
         GyGX5flEmexA4pL5kpjR8a4PLX6OMX2EKlxbSiJ07uAGGWDtH5hbirRm1coYZrsGFQjs
         npMGYBn/fzyXpYeV/RXkrpQCUJdwexe7MqQM6+d/TbfocXg1hJc4hf+XYVgdG42NNYpR
         92RRNwFdBSR//ACclwr54ePnWwwCwgcr8dG4pcvFIFVrL9yJmmHYv18uzWptptC6bWlv
         +FnGUIRFC89PiiII0HuIJFtcVnlGNnmzWDoYMm09PRPpOur6CJRvsNWmpATlX1/RK976
         q5Cw==
X-Gm-Message-State: AOAM532jHStUSw3lfH1kQNYbu5JU0lW11srvJn4z5bERziKL2QN/JnGc
        CqnnV7qzJuYC7eGLKOeuGA0=
X-Google-Smtp-Source: ABdhPJzFIVYw3G+uLtGylp0NKAcMjv1c2kHDJTjLVb+abUfYsgdjHx99Q3N2zVAEvv1/hN5LiQaEag==
X-Received: by 2002:a05:600c:5126:b0:39a:eede:5bf4 with SMTP id o38-20020a05600c512600b0039aeede5bf4mr723149wms.81.1653751538388;
        Sat, 28 May 2022 08:25:38 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id bg34-20020a05600c3ca200b003974df805c7sm5769385wmb.8.2022.05.28.08.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 08:25:37 -0700 (PDT)
Date:   Sat, 28 May 2022 16:25:35 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/111] 5.17.12-rc1 review
Message-ID: <YpI+7yNURQTMq9G+@debian>
References: <20220527084819.133490171@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
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

On Fri, May 27, 2022 at 10:48:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.12 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:36 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220517): 60 configs -> no failure
arm (gcc version 11.3.1 20220517): 100 configs -> no new failure
arm64 (gcc version 11.3.1 20220517): 3 configs -> no failure
x86_64 (gcc version 11.3.1 20220517): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
arm64: Booted on rpi4b (4GB model). No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1223
[2]. https://openqa.qa.codethink.co.uk/tests/1224

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

