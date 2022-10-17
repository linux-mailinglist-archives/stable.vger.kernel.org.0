Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5086F60097B
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 10:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJQI4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 04:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiJQI4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 04:56:45 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006DB65BC;
        Mon, 17 Oct 2022 01:56:28 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b4so17446214wrs.1;
        Mon, 17 Oct 2022 01:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M0mgrk1iUfOOVZeIfhX75/5UxnPtGTlQYULmUB7mpOk=;
        b=mRKLa2mV9PsdH21Wdu2DoFPbYSOcIUDnARbMBLR3DeeJAnjf43tuaLmpGAodc02ohH
         ZRajvZOXuV6vWEwoSQAOEXp9Zl9DAxRscmr520Vtc+/uoRGKlzJuweNgKF+Xq8UJs+IF
         BeYyqlQZUTl2mXmdWPDpOhXsejLq8IxxpiNYtqx+7JzEj3p+u8NKK8yYDXO4oQogAkwz
         r5QM1mK2K01sZ380acyjumL8p5njIsqGBXWWbaWjTULBEQ5OYR8OhME8Y/vtNRo+N9Qx
         yaWYkEQVzDxFL02EnPK+cXmXBj/Y/SvKAQGGZly4lblHAmKQcXdN9v20RyqQR1NGDrhz
         PcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0mgrk1iUfOOVZeIfhX75/5UxnPtGTlQYULmUB7mpOk=;
        b=1bNA+82snCl1pbkbgNP/ZHnnJF9XYKYUZ2ptJOYzUAxmJomrMcEkfAEFQZxXFOUCs2
         GrB4VanlJh0iVVFKavuRYFkY1kNCZq6IAQHodEGwYRFK66L7NcNpg8GSUdF6a2pYKky4
         45mazO2o5Eizr/lxYmdrpLe/CEbgzLwAMItPFIYvfmDMv96+ZuQdSHcRNU/olzvdpnb6
         nETB4rgXxCq046Txj1HTGcx5RLtvApy4MIHOlbPwF2xzklm+evHjLdWChiuYsgwk28bD
         j0Yk7+0dw1tNkbayXOV7UYMGNHVrlJil7egO8q/6SruzYs6+8icBJ35ShQOGAc6LK6ta
         Wc3g==
X-Gm-Message-State: ACrzQf3K7o7pIy46Osov8hHlkiJoKNtwQwog6rnn5S4M3mOV9+T2vbGl
        +m9X+QldI7mK3FRrL8cVQ8A=
X-Google-Smtp-Source: AMsMyM7LfDwMMiBumD7jgvQtjuu17C0UYar7nODZasjfn3oSc0adUkKo/kOxjc/Ifln66QtpNJgVIQ==
X-Received: by 2002:a05:6000:1561:b0:22f:7201:74ad with SMTP id 1-20020a056000156100b0022f720174admr5468917wrz.340.1665996987346;
        Mon, 17 Oct 2022 01:56:27 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id e26-20020a05600c4b9a00b003a5537bb2besm9460660wmp.25.2022.10.17.01.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 01:56:26 -0700 (PDT)
Date:   Mon, 17 Oct 2022 09:56:25 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.4 0/4] 5.4.219-rc1 review
Message-ID: <Y00YuWKtKKpCoCFC@debian>
References: <20221016064454.327821011@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221016064454.327821011@linuxfoundation.org>
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

On Sun, Oct 16, 2022 at 08:46:22AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.219 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2009


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
