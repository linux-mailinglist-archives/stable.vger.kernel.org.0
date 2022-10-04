Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA75F4220
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 13:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiJDLlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 07:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiJDLll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 07:41:41 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A17E4E628;
        Tue,  4 Oct 2022 04:41:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u10so20776092wrq.2;
        Tue, 04 Oct 2022 04:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=PjATV6AFt3O7cSwlwzhJIma0FMFIHMnip2KNJZuWX0A=;
        b=Q31SGCKr7/fIphu/HvZz66iYDjZ/N5E0mFSCR1P7rqfWaUtpjUojnc3kTRoB0ZeA8+
         7lDr1i6JRQX5tp9+2FZq4jsprQiIxvcLLlDLWwkrYX6xafWYTFLFwJMHoeuVQgJp5GIW
         wdZS9vDOrz2wb9iCiDcxDnj6YsMKiGrCKRsoTMtH5CnzV4o7r65vCJX6G25kvNAWP24I
         YIyzp0crPYvZp+57RDVL5EdDIDEflSFU6Y8k7iYF+NGoJxscf/+puCyHy1DbyvQY/7HW
         /Jz3JMX4bWjP/M28NOK4+oYkY82zOfnQ6UOa/areA7jkDAzdoVze8K/fTwuiQRoJEAg4
         EFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=PjATV6AFt3O7cSwlwzhJIma0FMFIHMnip2KNJZuWX0A=;
        b=Eh5dz9nPZzw2RLR1+btg6hFty5wazjtFoYBaHP5U5QYmayExtNEmT6fi72BsYnKR18
         wi3oSoMdqU/Tk+tMtEqVdNCFzC6vxU7A2EorlKCE3gLhivvlEyAX+cCymp7oCkPnM7J4
         aWA83EWwPpgV1AvQimyaElXCnpKbDsxGHiBJVh7bfNLF5qT/ILmNDB2ZRY6/AKkhlfZi
         k4M5P7dFqLkcUxPy9oWPzlLIEU2vqFfUx8CpucRqaqVwICZj4cPgpO84hscgUNEhe0Wr
         pW5cy0V+8zGfmayu+31FyVQ1wICgNjpaweIzXfDP0bxSfNr4pU87CiDg4y7Zi0FKlWfE
         MVkA==
X-Gm-Message-State: ACrzQf2XLG1WJzjKCrlYJBuRzp5TAogfqx79uWc8QG7ewwDDc4BWpHCQ
        bgORhy/Nr7jFYB1pOJrFwXo=
X-Google-Smtp-Source: AMsMyM6qH4ss0ZUaeqw2pLb2SZBilQywIJ3PY/R+YUYWnOVNofQ7KW9QCzXxGv6H6d7vImXyQ6oRWg==
X-Received: by 2002:adf:edc3:0:b0:22c:dbe9:e3b6 with SMTP id v3-20020adfedc3000000b0022cdbe9e3b6mr14331079wro.282.1664883696133;
        Tue, 04 Oct 2022 04:41:36 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id l7-20020a05600c4f0700b003b4c979e6bcsm20027569wmq.10.2022.10.04.04.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 04:41:35 -0700 (PDT)
Date:   Tue, 4 Oct 2022 12:41:34 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Message-ID: <Yzwb7v3ZcLh01eSd@debian>
References: <20221003070721.971297651@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
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

On Mon, Oct 03, 2022 at 09:10:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220925):
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

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1946
[2]. https://openqa.qa.codethink.co.uk/tests/1949

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
