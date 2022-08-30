Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E205A624A
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 13:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiH3Lnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 07:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiH3LnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 07:43:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8436E18368
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 04:41:53 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m2so11357247lfp.11
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 04:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=PDm4CS+d3TEzVN3RfMYIEm8la5mbkwV+TixUxTpSbBk=;
        b=w4Cmbu+fAEL1Kt+9VlmpNmDTQ20cWAN+cKiJsYvp0WZ5nNswwvSfZSTPvk/38TOZw7
         HlkcEQriD+Kcfhizg4FzDQIUCp6davqWYa3PDBteiXORxFuT30zyOeYBw0Etj64fuXFQ
         wMmFFxqVqZFeXCsISzO3vZ7XFzzHBAxwuX+ColpVKwYmL1fl5ohl9vddVeqJpL5QlZbj
         YxNqEN8CC2aEhOFy6MzM0+IYXo6WODt+s8ikUBGcDlfokfEINExBAVcI8+iOJMQ1YcJf
         GE/H8fjCdp4eCMC0c2Wnt//fUmXKbDlHWQA9wlQL/KXlruwaUoAWGv3ZiFvqvIT8NcDq
         pAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=PDm4CS+d3TEzVN3RfMYIEm8la5mbkwV+TixUxTpSbBk=;
        b=6Yh84nToLV8SEACMZs+7sHApOouTi2vcfCRi+3r0bG4FHiziqxfLLCLwJV+HPpUdDO
         EwwDg4YjkdFg2xaziRpLhCedPn7nUGgBGqo1VFmhgZtMguSib/FIQIlg89aahUgQmZ1L
         MW4HjlPkafw8CWgvAU4fTr9dlaV0hkRl1ohd/1i1KgaKdrokXRkrWzqH6/WVqP/RvHeU
         BAJCvkbLfEI0aNhWtTdS3f66yocMxyoMSDkZpuZueEx7qfp9qwMHB9aK7Lq5WlH2hwOU
         ZjdHeTBN4pyyhVjFLe17zl+oeYbFYJxu42sNfvRIZdJZdHhucQodLLWBU2pvW8+MyNgq
         oecA==
X-Gm-Message-State: ACgBeo1yJi9ZNMy7LYHgyQO0XonekI4ERjGcmuWuv5G6+ZTlR9uBGXOC
        7LsZShOZ8A3ktQWD3sjeosrSDg==
X-Google-Smtp-Source: AA6agR4QAoDP2/7MQFH7BxWhaGqK/kvTaiTH0IY/zf9ryscS7pwN8gh8soHETxiWuLNfYZMQRRqDRg==
X-Received: by 2002:a05:6512:b89:b0:492:e4bf:adcf with SMTP id b9-20020a0565120b8900b00492e4bfadcfmr7317851lfv.203.1661859711050;
        Tue, 30 Aug 2022 04:41:51 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id f9-20020a0565123b0900b00492e570e036sm1586569lfv.54.2022.08.30.04.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 04:41:50 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc:     "Isaac J . Manjarres" <isaacmanjarres@google.com>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Guenter Roeck <linux@roeck-us.net>, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3] driver core: Don't probe devices after bus_type.match() probe deferral
Date:   Tue, 30 Aug 2022 13:39:40 +0200
Message-Id: <20220830113940.331931-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220817184026.3468620-1-isaacmanjarres@google.com>
References: <20220817184026.3468620-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Both __device_attach_driver() and __driver_attach() check the return
> code of the bus_type.match() function to see if the device needs to be
> added to the deferred probe list. After adding the device to the list,
> the logic attempts to bind the device to the driver anyway, as if the
> device had matched with the driver, which is not correct.
>
> If __device_attach_driver() detects that the device in question is not
> ready to match with a driver on the bus, then it doesn't make sense for
> the device to attempt to bind with the current driver or continue
> attempting to match with any of the other drivers on the bus. So, update
> the logic in __device_attach_driver() to reflect this.
>
> If __driver_attach() detects that a driver tried to match with a device
> that is not ready to match yet, then the driver should not attempt to bind
> with the device. However, the driver can still attempt to match and bind
> with other devices on the bus, as drivers can be bound to multiple
> devices. So, update the logic in __driver_attach() to reflect this.
>
> Cc: stable@vger.kernel.org
> Cc: Saravana Kannan <saravanak@google.com>
> Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Reviewed-by: Saravana Kannan <saravanak@google.com>

This fixes a QEMU regression for me:
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
