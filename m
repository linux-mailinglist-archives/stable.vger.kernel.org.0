Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7435BBF30
	for <lists+stable@lfdr.de>; Sun, 18 Sep 2022 19:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIRRrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 13:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiIRRrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 13:47:16 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4E914D0B;
        Sun, 18 Sep 2022 10:47:14 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id y14so906846ljn.7;
        Sun, 18 Sep 2022 10:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date;
        bh=89ee56w1RlLqFBfq/ZqXmyMzTIcCP/U7ZCyROaV/Xdk=;
        b=P4l73nOTri3R7MmTO0pgyCWjjgVTbq7jaqLPZkkk27cGFQ9BKZtzLv8rEv6CejqmOf
         o+Uxyt/MaMIQ8h0UbG4Rb20tS19Y4cxM2s1yyYIhKytNeh6KYIOuIdD9WYZ+BPGu4OR0
         e0Pv3NMQIcLxA1shDCOHzP4ORrBKxqB5YwO1tZpdWIb51fy/N/cysXL08N2JrRPsJr9K
         IX9p6LKgNKeUM7oO+BP4f739RaLwjFJ8ae6UZp7i6UkOCbo8O/4z9fqCCrUKQmIRS5eT
         SSpg8PKD/jOVUSVToEcmsipTD/1SGbCJBQChyc2i5l3SluunBJ0dYXuuziDtIP8LdQRZ
         ZqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date;
        bh=89ee56w1RlLqFBfq/ZqXmyMzTIcCP/U7ZCyROaV/Xdk=;
        b=HlbDXf1vDNUMWuF9LAlfVjJULemS9RKj6IPm5eebMxRLbGsxDN1IpvN4RmaR/u89ln
         YBZJ9LoVOXrcyY3o6btIWa/sP/qoGBqiGAY/D6MnNXHTJo3ZvsEjzEuG/kkMKdyR6EAS
         rcDBdVqaEaBXrIGKHwE0MdMAW7sj2yUGetpo5SUg29oxtqq/pIBCdSu4NDA5a85B8dU4
         PRU7k+3qscnK8JVsf3QxubPcYm8//Q/1d491Q4YFTdjCXTVbQaU0R9S758c/S5hjLGcV
         re48iNMqmp5i4+JAJbVU12UQDmt0MyRf6lYUF1FqRHJ+JHuB8BBLtFq4KIbwlLnnaDue
         9M4w==
X-Gm-Message-State: ACrzQf2WhxgODslKMlaM9v/ZObr9WHqh69yu8qRQbf0kvL0a2oNatJ0A
        MFpnyHw2R4AHxJxz/j/ef2c=
X-Google-Smtp-Source: AMsMyM44uqyFXHEpqUAKlWZV8NJSMKrk6IoYw7LAyUaXSZYV1bHNtTT8WfQ9JLWwUJSyT2llgR2usg==
X-Received: by 2002:a2e:a44d:0:b0:261:cb9c:6891 with SMTP id v13-20020a2ea44d000000b00261cb9c6891mr4215630ljn.136.1663523232668;
        Sun, 18 Sep 2022 10:47:12 -0700 (PDT)
Received: from razdolb ([37.1.42.233])
        by smtp.gmail.com with ESMTPSA id b17-20020a056512071100b0049aa20af00fsm4288166lfs.21.2022.09.18.10.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 10:47:11 -0700 (PDT)
References: <20220917165820.2304306-1-mike.rudenko@gmail.com>
 <6779635c-a162-0b7e-d124-d88d1ed9e162@sholland.org>
User-agent: mu4e 1.9.0; emacs 28.1
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     Samuel Holland <samuel@sholland.org>
Cc:     stable@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH] phy: rockchip-inno-usb2: Fix otg port initialization
Date:   Sun, 18 Sep 2022 20:46:33 +0300
In-reply-to: <6779635c-a162-0b7e-d124-d88d1ed9e162@sholland.org>
Message-ID: <87tu54r2w1.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2022-09-17 at 12:12 -05, Samuel Holland <samuel@sholland.org> wrote:
> On 9/17/22 11:58, Mikhail Rudenko wrote:
>> There are two issues in rockchip_usb2phy_otg_port_init(): (1) even if
>> devm_extcon_register_notifier() returns error, the code proceeds to
>> the next if statement and (2) if no extcon is defined in of_node, the
>> return value of property_enabled() is reused as the return value of
>> the whole function. If the return value of property_enable() is
>> nonzero, (2) results in an unexpected probe failure and kernel panic
>> in delayed work:
>
> This should be fixed by the following patch which is accepted already:
>
> https://lore.kernel.org/lkml/20220902184543.1234835-1-pgwipeout@gmail.com/

Ah, I see now. Sorry for the noise!

--
Best regards,
Mikhail Rudenko
