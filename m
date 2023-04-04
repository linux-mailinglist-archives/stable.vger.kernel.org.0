Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085186D59E8
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjDDHpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjDDHpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:45:44 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC03E4B
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 00:45:43 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cn12so126924087edb.4
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 00:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680594342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WSqtZRoO+7oxS/Zs6qJTOEa2kJhX7hpILJFi1UXlEwM=;
        b=GvSetiJzd3iVYwQJxnNpYafD/6sVuAkHcFA15rSAN8yLZctPc4fHygPvSV6sJVCzVK
         uiyHWJGzpXQRS+mIVip1KHcWWANUYxZ6MQhFOLJfyRJvdhCYYcguNwZ+iWjqfLg/0V04
         tJKbGeztPA0OpywnHLEVe0ANxxC6qd++dLBEVSrpIgjTc3or1vecnYUYgr34QdZyT4I+
         k3kdIkMEbgE/gCD0doMh3r+r4wvn+F5wFT0faYIvj2tf1Hs+4pnbaHRdZL76GhI9nVnF
         IvjnNKD7qcE0hyXT4+lfTqzEuEBU3D6aICvOwHiBn7vDYlrs2Ka7Aw868zO3t7nNLG7c
         xDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680594342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSqtZRoO+7oxS/Zs6qJTOEa2kJhX7hpILJFi1UXlEwM=;
        b=v9YfUkiQLmCus1GjqXoKhzdFeEvccSG7filFNRf2B1hrhenga44LmeGYmVUVFQv92I
         2H2+u+9NAa2HmWkvKNh5Ne+EkiLA6GovC2MKg3ZezVkQoTqIJCCCA2oX5fCxa3jcuTw0
         96PRSI94AodAKcolBnYf13O5mhsLmXHWMSVfre8LAK+cZAFkZ0/cGhVWac+U9keEHERv
         s3P5SbkwTRIsw1Qo/w/054LXt1pwjcwihOljzTdkUf1J6MsbmeDMNxMwgCGEDWnEi9+X
         XusP1JR7KKYjbsQfYgXKF+wsyN+LPhkubO1j2NknzkYl2enVtn3FJM1txYyz5+Z+SS94
         acyA==
X-Gm-Message-State: AAQBX9dRAL2rPvig3gZAcTkOekTdXlxHJUaHGi+UePcPsZ7s0hUIhCp9
        E6qVnr4YnEpvtMQ7C3nlSWPTHg==
X-Google-Smtp-Source: AKy350Z3MM5JqSahgjKwjpZjaUWuz4ULqKos1WYldHF0rRpjXXUgAQJPvQ0r02V1I/6OZM/HPk1aNw==
X-Received: by 2002:a17:906:e24a:b0:8af:3b78:315d with SMTP id gq10-20020a170906e24a00b008af3b78315dmr1337161ejb.23.1680594341917;
        Tue, 04 Apr 2023 00:45:41 -0700 (PDT)
Received: from [192.168.2.173] ([79.115.63.91])
        by smtp.gmail.com with ESMTPSA id h11-20020a170906530b00b00922a79e79c2sm5603482ejo.217.2023.04.04.00.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:45:41 -0700 (PDT)
Message-ID: <86b0ce12-0933-1fd7-d9c6-6e18ad7a9c56@linaro.org>
Date:   Tue, 4 Apr 2023 10:45:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2] mtd: spi-nor: spansion: Enable JFFS2 write buffer for
 Infineon SEMPER flash
Content-Language: en-US
To:     tkuw584924@gmail.com, linux-mtd@lists.infradead.org
Cc:     pratyush@kernel.org, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, d-gole@ti.com,
        Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
References: <20230404071715.27147-1-Takahiro.Kuwano@infineon.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20230404071715.27147-1-Takahiro.Kuwano@infineon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 04.04.2023 10:17, tkuw584924@gmail.com wrote:
> From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
> 
> Infineon(Cypress) SEMPER NOR flash family has on-die ECC and its program
> granularity is 16-byte ECC data unit size. JFFS2 supports write buffer
> mode for ECC'd NOR flash. To activate it, MTD_BIT_WRITEABLE needs to be
> unset in mtd->flags.
> 
> A new SNOR_F_ECC flag is introduced to determine if the part has on-die
> ECC and if it has, MTD_BIT_WRITEABLE is unset.
> 
> In vendor specific driver, a common cypress_nor_ecc_init() helper is
> added. This helper takes care for ECC related initialization for SEMPER
> flash family by setting up params->writesize and SNOR_F_ECC.
> 
> Fixes: 6afcc84080c4 ("mtd: spi-nor: spansion: Add support for Infineon S25FS256T")
> Fixes: b6b23833fc42 ("mtd: spi-nor: spansion: Add s25hl-t/s25hs-t IDs and fixups")
> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")

Would you please split this in 3 patches, first fixing c3266af101f2,
then b6b23833fc42 and then 6afcc84080c4? It will help stable team
backport each for each flash affected.

Looks good otherwise.
