Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6525685E42
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 05:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjBAERE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 23:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBAERD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 23:17:03 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1FE552BA
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 20:17:02 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id g21-20020a9d6495000000b0068bb336141dso4226708otl.11
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 20:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:sender:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M50v9270E31xUKEbbRTMtxhBIVHHQZG4JYjzSNjyIbQ=;
        b=PtVN5bO99+a3eSLFjUINLL4YCuc2JOkBQ/4sxFFlTafh5XrexNLd48DYE6hs5Tq57n
         ASibi29gOr1thbSfphN2tLF4ys2snJR9P99KxEOhPtAo6/F839Ix3C707zZPhVGblHgh
         gbftVVRmUKidYO5uKevbPcr1BQrKt42wzhDsz9ytQc4j5v2JgkDGHc+xJ44NRz8ye97Q
         Iz9JxbK6Dw+L9OjX7b5qW8YTorq4plJxoDN18iaynUxhlaYClcoGYV+WvT5OC5sHrMUm
         niq1usG7r1/weEf7upPHTWm9T6vyGITdSsbrjNl6IwYtlzZ9L9S0Z4+N80bTj10lYDe/
         IUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:sender:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M50v9270E31xUKEbbRTMtxhBIVHHQZG4JYjzSNjyIbQ=;
        b=expxJk5VtvhIJdKnp6BVu+hiQW0nB+453/EutwdN2hm6Ht71iaUi67j+y5uLqJyMbP
         6hUvfOYFHvI9dJ6f3RLCMfSsQi4W/8X63F4MqbFinx8S3zdrLAuWdiEbagApLwV5VTxY
         4YZT2qNsIOLckmQPtCn/l8Ylq2ciV0el8Eqb0LJF3ky8+/j+9UPD4GWaVlKZ2N3+FsOJ
         aSBqcukb8bCYMTBRwD3RvWneJJlVYfwNrg7Zbwhne9/ntezuP66r8di4AWgvM8tx/XQq
         GUNzoY+KNKET/VhL3K/8ex8/711Vs1VVjQQFe3x0TBthrgjrgK8HKJ9wSfvxukEL1k3W
         aq5Q==
X-Gm-Message-State: AO0yUKUVrdf5A5Dy0UqfcPmiZDIYMQSe7g099t1Dh6NmQIMyFATa1Cbo
        AevgpGhNUazVE61j++6IVlvw2ZeIfgo=
X-Google-Smtp-Source: AK7set9BENTC+UdHH42ZcR25gfUs+qPUyHMiEMl6+hdjsQQ5E1j7rhvovNjXf/dsw1b+eQYVyiy31A==
X-Received: by 2002:a05:6830:2b1f:b0:68b:c04d:79ca with SMTP id l31-20020a0568302b1f00b0068bc04d79camr857447otv.33.1675225021205;
        Tue, 31 Jan 2023 20:17:01 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k96-20020a9d19e9000000b0068bb3a9e2b9sm5839573otk.77.2023.01.31.20.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 20:17:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4b9007db-923d-8394-175f-22b16c078d51@roeck-us.net>
Date:   Tue, 31 Jan 2023 20:16:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failures in v4.19.y.queue
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I see a number of build failures in v4.19.y.queue.

Building arm:allmodconfig ... failed
--------------
drivers/memory/atmel-sdramc.c: In function 'atmel_ramc_probe':
drivers/memory/atmel-sdramc.c:62:23: error: implicit declaration of function 'devm_clk_get_enabled'

Building arm:imx_v6_v7_defconfig ... failed
--------------
Error log:
drivers/mmc/host/sdhci-esdhc-imx.c: In function 'sdhci_esdhc_imx_hwinit':
drivers/mmc/host/sdhci-esdhc-imx.c:1187:31: error: implicit declaration of function 'cqhci_readl'

drivers/mmc/host/sdhci-esdhc-imx.c:1187:52: error: 'CQHCI_IS' undeclared (first use in this function)
  1187 |                         tmp = cqhci_readl(cq_host, CQHCI_IS);

drivers/mmc/host/sdhci-esdhc-imx.c:1188:25: error: implicit declaration of function 'cqhci_writel'; did you mean 'sdhci_writel'? [-Werror=implicit-function-declaration]
  1188 |                         cqhci_writel(cq_host, tmp, CQHCI_IS);

drivers/mmc/host/sdhci-esdhc-imx.c:1189:47: error: 'CQHCI_HALT' undeclared (first use in this function)
  1189 |                         cqhci_writel(cq_host, CQHCI_HALT, CQHCI_CTL);
       |                                               ^~~~~~~~~~
drivers/mmc/host/sdhci-esdhc-imx.c:1189:59: error: 'CQHCI_CTL' undeclared (first use in this function)
  1189 |                         cqhci_writel(cq_host, CQHCI_HALT, CQHCI_CTL);

Other builds fail with the same errors.

Guenter
