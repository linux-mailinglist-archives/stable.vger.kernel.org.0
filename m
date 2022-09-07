Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DCC5B00B9
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 11:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiIGJkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 05:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiIGJko (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 05:40:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D79B3B24;
        Wed,  7 Sep 2022 02:40:33 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so9136493wmb.4;
        Wed, 07 Sep 2022 02:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+5dWEHCEhAzvKEwx8UCLDoNfDDl2EJg7AkXrffzSWRU=;
        b=B8Ka3JY2W7Zvs993XHxhifuM4SVVET56zL6ffLAvcccWcgTtwRGyJ5Wj7dHdv6ei7b
         1x8UoyCllAo4mUP9fmGh6cy9c/jjz4cQuP+zTQLCmw8RVOliJfQn85aJQ/MYJnfk/s5v
         05wRJgbYoycegDpxH891AH3hymyKebFtJ0uRJYVYKS/y999zh4wgAXYKnNQp06TwmpBI
         +Bjj6dqegtZWm9WV4hffUBeKhMbCNsbkVdYCSf5jh/NnCnkIOEMqwhBE5kpC1NAYuVPN
         kXw8kbUm8N1sMKi1CHMbrWh4hPq400OjzHtBVF0vmsrvCLgr4zX2e8Hr4AMquaTNVDm2
         H3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+5dWEHCEhAzvKEwx8UCLDoNfDDl2EJg7AkXrffzSWRU=;
        b=jHmSzzmoEH6gHMz2phDxliUKPVpXmvXH5So2x3MkEJYjau/622GljmPOL0UX82RLQf
         TONATuQOdt6o1cNP0VlnvaQaZ+T/wwr3kBBs+q19nUmG9gFL1ldC1+r5+9UPpjAqIkSg
         6Is/vs/2QejHCO8o5nvULQPE+/EReTnDqj0qmwfG/MVaf6HAKw4MCNL7YgGrqAxQlv/g
         KWNJhZdkkcFG9LhJLxfGW5xf+Jx+sOz5M5Ht1y/QLo18dRF7lkvE2w14iCKbj9lPGRyj
         3HUrrl95PtLVdEtsxgCXaO7WLU6x08wrOcB3+Y/weas0RMkHEkDzaMltAape7JFUGofv
         6CWA==
X-Gm-Message-State: ACgBeo3e59inFgZCnrTIbox7IBlZ9BDk5Mpk99CeqUwZi61sRY7OlhGi
        PMiofhnopTsEpJYroPtvnI4=
X-Google-Smtp-Source: AA6agR4IaFstfbUn+A9wnc7yvFVTesUGE6tAx1uY2QNWS/fco+iCWe0GHBtFUKhy2hhIqioQxG2hIQ==
X-Received: by 2002:a05:600c:3502:b0:3a6:edc:39f8 with SMTP id h2-20020a05600c350200b003a60edc39f8mr1473274wmq.200.1662543632347;
        Wed, 07 Sep 2022 02:40:32 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id t8-20020a5d42c8000000b00228daaa84aesm6068465wrr.25.2022.09.07.02.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 02:40:32 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:40:30 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Message-ID: <YxhnDip9k6TfRCCc@debian>
References: <20220906132821.713989422@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
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

On Tue, Sep 06, 2022 at 03:29:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
Except x86_64, all the other arch I built were ok with gcc-12.

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1780
[2]. https://openqa.qa.codethink.co.uk/tests/1785
[3]. https://openqa.qa.codethink.co.uk/tests/1787

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
