Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C44588114
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 19:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiHBRdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 13:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiHBRdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 13:33:20 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB0D13D46;
        Tue,  2 Aug 2022 10:33:18 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j1so10368540wrw.1;
        Tue, 02 Aug 2022 10:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=BavY1Tzh3YCu2l72D/MPQIKDEgSE7XBuJIIQTzol1a8=;
        b=NcYVkME75WTiHZrGD6J7ZPwGrfMc338IwgWqxn6lRvP/16iZUuehs05ZX0/Dywc2g9
         c4WWfdmky5kvSK9hiWOnpOtyADjkOjrZpCNZ7KbUwg9JFVPxJ/+g/1tjf8WNiZVkHpRS
         BEF8bGDZanELpn+I1smNmuP1WL3mRBk+pcalv3YIJHDMz4/rxP60VDyk4zv2GoA68g/+
         qFGwZEXoZczBDb9SB96wXdgUun7GyqZZY9j+fU/36MEe7ir+8SItuGSWnYs9APP5gpvm
         C1yf5Gjdr42MVpUChD5yGuos+V7RjRkKnGvlz3SakLsItbhmNxcpzW9J9hlfVPIFz8BK
         uS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=BavY1Tzh3YCu2l72D/MPQIKDEgSE7XBuJIIQTzol1a8=;
        b=GnernW37dIn5lXHH/ivl5Tuvru897bZ4b6TgW12JTC6z1CC/aFwQS6d8xcRukWNCDi
         v8snoijCDXMruX44dqze4iJ2wZlU2MWP34PLDFu5mlScR+bSYcSDwb0wFz/iLXxsMYJL
         DSZfngk+hcLxTxraWyyxzlBrRFI7uRXLd5PtFzZAHtt7SgPIt9WAGq7t8Q7BO9Ve5Hvp
         mT8RfZCEfmZ0DFtCzX0skkGYytOwW4mwQ6tOp7RcEB2Jx3WV9raLlOK14Ldby+NV5jQ9
         hXapGN0C9It2aDiTWXqicSRpp1bnreq8FN+d4w0nex4e9bwEcBqxy4U5vkgELJ6xY2+P
         UPIg==
X-Gm-Message-State: ACgBeo0W3gOWJB2OIuyUD/VG5WaJfsOoX80uX+GatTG6COfp9Xf0nAZB
        nJU2+g1jkqPUoDLNC/NJ4II=
X-Google-Smtp-Source: AA6agR78wspfEPUXKLH4kYUzZ/8yXVlR8op2JuIYSxz6svA1DgoHCjzFVr7D9EHpZy6ShZhUeNXRGg==
X-Received: by 2002:adf:d1c4:0:b0:220:78cc:5edd with SMTP id b4-20020adfd1c4000000b0022078cc5eddmr592513wrd.86.1659461597380;
        Tue, 02 Aug 2022 10:33:17 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id q14-20020adff94e000000b0021d7b41255esm15540360wrr.98.2022.08.02.10.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 10:33:16 -0700 (PDT)
Date:   Tue, 2 Aug 2022 18:33:05 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/65] 5.10.135-rc1 review
Message-ID: <Yulf0WjBHIB8OScG@debian>
References: <20220801114133.641770326@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
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

On Mon, Aug 01, 2022 at 01:46:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.135 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220724):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1603
[2]. https://openqa.qa.codethink.co.uk/tests/1609


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
