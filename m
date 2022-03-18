Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19274DDF0E
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239209AbiCRQb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbiCRQbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:31:51 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D451AE61D;
        Fri, 18 Mar 2022 09:30:16 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r8-20020a1c4408000000b0038c8b999f58so11065wma.1;
        Fri, 18 Mar 2022 09:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kcmXH38zPS2rAxVrwWkivQQGcbofMIpObPEJuL/wR2c=;
        b=h1jlEsGBtCiSXlujvj2LuQ/3j/TC/5cU3VnPWj+UTKqImdG5dVH0L2HEG9iS2e15OG
         yjb6mJbElYNXjfSZeNuMMrJWKg5YlU+NSOGKl3v2BVlaC1xL408SJI7tN/5w/yp55SLC
         Qet2f1urNG891wqWjjPGDasW0Qf2ObzXwxfOJ0VFDWhpG9+s2s944k3tkkzmxZq1ZjKj
         faqHwEdEXti46M9XOq1qTghzIyH+u+aTfN2oDRRqxp0wRG/QUHAuSFelkSYq6JOBmNap
         swJHwLQ/0HXg81ObPWJr9Bm69TvczBpdme6nBT50mLI6zBiX89BURnVBg55cXt/GRG5/
         o4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kcmXH38zPS2rAxVrwWkivQQGcbofMIpObPEJuL/wR2c=;
        b=Pqimy0JYRjrDdbIN04PuYNOAK85NMKC8hP+o1WY3Y3eLhkF80mkKVEQ8aDOXGDvyu8
         /HmDMXB/HVE7vXHgtVlQ5wOabxGCUmWUtyXvyfzVmz9//ZuZKb0GUidpUDKGR600Mp7k
         1qQzd8CHNDy4iyQtGikiDHsiApqwmWo2gKkLPNDd7wByrrf1VghSSq3mQXscueIe+klb
         GMoLSYQQ+QKL/Jdp647qBqWoCuDDZCXRsLiDlTZDsk+UF9/CsOszcBCEazxiqN9fry8Q
         ZKGQfmWwgzNRd7M6wJ2h2Sp/NO2y3Lg/olUXeRzcE7kqcD9yV8D3v3ih6lIyOjhEqpJa
         2GOQ==
X-Gm-Message-State: AOAM5313xdQ0Xv9Vq1EyqFH+uYSZ1rFxWRurvUJWKRuNiuRxW6LOhyB0
        dBk01Cg+G67vhOFe7tPfxC4=
X-Google-Smtp-Source: ABdhPJy6KrkwlrfVfkXEX5lE7YOid/qKqI5JAEvkg+SpLkFLTOb/vlEUFX8qKGC7ECPCRHFkJgJprQ==
X-Received: by 2002:a05:600c:4b83:b0:38c:8b9a:482 with SMTP id e3-20020a05600c4b8300b0038c8b9a0482mr2502512wmp.153.1647621014668;
        Fri, 18 Mar 2022 09:30:14 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id g6-20020adfd1e6000000b00203f8effc22sm2369935wrd.63.2022.03.18.09.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:30:14 -0700 (PDT)
Date:   Fri, 18 Mar 2022 16:30:12 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/43] 5.4.186-rc1 review
Message-ID: <YjSzlPhT7GxQ5s+v@debian>
References: <20220317124527.672236844@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
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

On Thu, Mar 17, 2022 at 01:45:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.186 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 65 configs -> no new failure
arm (gcc version 11.2.1 20220301): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/902


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

