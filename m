Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE55768DF
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 23:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiGOV2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 17:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiGOV2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 17:28:38 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6C3D2;
        Fri, 15 Jul 2022 14:28:35 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r18so7836555edb.9;
        Fri, 15 Jul 2022 14:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=vKP8LRUE0yFoYd2NSJtjDx8dGT5PCA4BqZdFt2yy0yE=;
        b=Lh9w6zXbZBZA7GiEpjb7SSyhQR9Z0cioFtyjFntBW3I/JmkDdVM4wZa++097wPJchb
         UNj/v3N7C2YYrtrKVPn7nkyFKlaMK+JwIotUu4/FQ3DYDFix7EpVQeHJXlZEihEiX8Yv
         8L9bgcuhwMBiq8pBnv8zsEJMjEsp4W/DzfWDwqQ2qqENb8jIgqn4qtHypmYi37VXT9Sf
         Gaf6hppROhI15zAE3EHbTjyoEUw8eAEQAjgF6OW8L3cDPFOlNz7PuruQ4LyqhUezXsGM
         QYpaKgqI4p+MxFSY+EqcvQawKQMBYpqeRIZapy7ekfXC5noYFNCgK83GPu0v1PCpNkYD
         8t4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=vKP8LRUE0yFoYd2NSJtjDx8dGT5PCA4BqZdFt2yy0yE=;
        b=LwUbPLEG4iRwIIxqOcfQgcfBwCdlObRGduQG6M7AgnvKJpMm4dL9z4RDklXBDrlk/o
         UtaGcCAMrEjzFJjy7F+mE5nFlEpspFdMXpMGo1jcQLuSSz6qAgT9PiJjxA6xNE41tDLs
         mCsleZiqgb3FtQTYSDcbjcmo3iWlnWMB4Dn1noBsn5D6+0Z8fRQBB7HZIuefYiHSkUc4
         C95zWnrAvtbGN9O9zGntl6x4I5V/mKzTz+emW4XH7zWHWMjY2ByYtZIPnQ40WsyAaZ9r
         0dCpdW3awkYyRBODbfbC3MmRrcEvKxjC5t8BRQYASCfb9WGzVVUXherKA6EYK03Hp8UH
         C2Mg==
X-Gm-Message-State: AJIora/l/W8qbBQi06NjXQMs/6AibC4k2exDO3Orvl+5JfUPIdZ1vf1K
        Da9OufFI/TsDDs+tHV3kwTAY8zLgGDNMNQ==
X-Google-Smtp-Source: AGRyM1s05yWcHFvP3gv214D8NvoaPGT9vm/UMlinro+VSSYis2KoGNKbdEL2VZPLMx5EOm85tzkSZw==
X-Received: by 2002:a05:6402:5001:b0:437:8918:8dbe with SMTP id p1-20020a056402500100b0043789188dbemr21343249eda.70.1657920514358;
        Fri, 15 Jul 2022 14:28:34 -0700 (PDT)
Received: from ?IPv6:::1? (2a02-a466-aae1-1-410d-5d2b-3240-fd55.fixed6.kpn.net. [2a02:a466:aae1:1:410d:5d2b:3240:fd55])
        by smtp.gmail.com with ESMTPSA id x25-20020aa7dad9000000b0043a0da110e3sm3526563eds.43.2022.07.15.14.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 14:28:33 -0700 (PDT)
Date:   Fri, 15 Jul 2022 23:28:33 +0200
From:   Frans Klaver <fransklaver@gmail.com>
To:     Reinhard Speyerer <rspmn@arcor.de>
CC:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frans Klaver <frans.klaver@vislink.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: serial: qcserial: add EM9191 support
User-Agent: K-9 Mail for Android
In-Reply-To: <YtHVfc40VGbB2Tkz@arcor.de>
References: <20220715095623.28002-1-frans.klaver@vislink.com> <YtHVfc40VGbB2Tkz@arcor.de>
Message-ID: <F3F460AC-05D0-4DF9-9C18-B95881B62F8F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On July 15, 2022 11:00:45 PM GMT+02:00, Reinhard Speyerer <rspmn@arcor=2Ed=
e> wrote:

>the qcserial driver used in the usb-devices output above does not seem
>to be built from the mainline qcserial=2Ec with your patch applied as USB
>interface 4 is ignored by the QCSERIAL_SWI layout=2E

Right, I will need to look into that then=2E I won't be able to access the=
 devices for a couple of weeks, though=2E It might also just have been me n=
o paying attention while testing=2E I'll get back to this=2E=20


>To avoid potential side effects in case Sierra Wireless adds a vendor cla=
ss
>USB interface 2 not intended to be used with qcserial=2Ec it might be bes=
t
>to use a new QCSERIAL_SWI2 layout similar to what has been done in
>their MBPL drivers mentioned here
>https://forum=2Esierrawireless=2Ecom/t/rc7620-and-linux-driver/24308/ =2E

I'll have a look at this too=2E=20

Thanks,=20
Frans=20
