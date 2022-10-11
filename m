Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0F35FBC31
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 22:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJKUgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 16:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJKUf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 16:35:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28669DF97;
        Tue, 11 Oct 2022 13:35:51 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b4so23371734wrs.1;
        Tue, 11 Oct 2022 13:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yM7le9rhqxSXpgbFxwaPbQQ1TFrB7VRUEQW1kSUpXmU=;
        b=T+d2Slk5PbXg8XMD5Lg1iNy0E+lWg7JGmKWaDHQORIt/6M9zo1p/sCf1uf2Jd1E74Y
         tOxGSAmxiV6L3AvtJ/c/Otf0aQPYrejk48fs+4Rni8rhb0zkKiqqcJfcq/Pvkjw36MQV
         F2ZifXwkXJ2isQuYUrCbUtV8EE6TDU/1QIWGHJPZ7F7S/5X3V2GD2dqZqB+ddJtvYxdd
         bLNkjJHfb4lq/fJPnOZDIv5M9M6eeUjsKxXtJWYurwVYxTqT6a0zcOxz357Gqd2/CgUZ
         4DAE8dGdTnWWxjX9KaYw1GnvWH+JRg6USOzhRa17JrXses9NYUlwz2YH7BsdeOCViRnf
         pOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yM7le9rhqxSXpgbFxwaPbQQ1TFrB7VRUEQW1kSUpXmU=;
        b=pYXrEeYP0HLQjsmYx5W4N8ELlc1jJvCzsJLU8spiQ8dE4Dh2Yc/siL+oPL7wii6eq3
         1DotPh8PvEo5EJBJEyTUeWYo2NyqOpOAmmnd16NX5/V2KffVE/17pLHmrAausdOq/8MY
         kHsbJMws5yD/TuXqiIXsv9hxWtuEf1KSLZwgzsR97/QhWrA3K8QGe8ZABUNnoa3bpKJJ
         xnReqLFh3lZlmGWQ0U/zHwdByxXzkF2ElowpKHJV1VHjUJNK0ebDZopaCxdZeco5A4bn
         uPJa1LAmxAItUh64r+u6gcnpqHX9PdkMqM66ZDor3QArioig7NGfrtystT0TrzK26umy
         ieSg==
X-Gm-Message-State: ACrzQf19G62ObIrFJt2aZGK330oghkXn/yy6V15yyd9feSlaCjbiHhLX
        TWKIWWzYBDoAAEC2O9zp4F0=
X-Google-Smtp-Source: AMsMyM6sizIYtV1Qi03T5A5crlK+OcFeVVmzMXvjlAtziQBR7R5nRi8mpVjFGnhcOD/o19ihGzv9uQ==
X-Received: by 2002:a5d:59a4:0:b0:230:eaa4:88d7 with SMTP id p4-20020a5d59a4000000b00230eaa488d7mr6513585wrr.35.1665520549917;
        Tue, 11 Oct 2022 13:35:49 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c001100b003c6bbe910fdsm23178wmc.9.2022.10.11.13.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 13:35:49 -0700 (PDT)
Date:   Tue, 11 Oct 2022 21:35:47 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Message-ID: <Y0XTo4tY61WmnidK@debian>
References: <20221010070330.159911806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
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

On Mon, Oct 10, 2022 at 09:04:23AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220925):
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


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
