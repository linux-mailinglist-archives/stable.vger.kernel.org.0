Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5AE547594
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiFKOSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiFKOSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:18:16 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF99910572;
        Sat, 11 Jun 2022 07:18:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m24so1884326wrb.10;
        Sat, 11 Jun 2022 07:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ITBoLYA2N5MuLO3gqnXnaF4OTMmFSVYBYZ7MPGfv98c=;
        b=CosyK9y8uyI6z7UiVBwQHZ7V3roQMVGBnGiDI6XrD6rMEuNsI+GrkViig8YkorsqzZ
         QxDTaPI+4iI+RkhZn2rzNMOhkCOGKOlHkYj9FAs1e69xXRdX4ygHFGY9w5CenwRMj/hR
         sDAkPzYyyC6bYt3JnAxdhMvSIWqpR1us/VzYgDiC1HFp8ktKRGxhELxaEMrU16bJHsoW
         vgL73GIquT3Jhq7gRhkLPNSVxD93f+/NVGrnHOCaotdU5wyBAYX4PR9MKzd70JrBIw0t
         PowbThrSchM5vvtRRdFQCNlX3muycViiIM7199UbU/wJtNn2S+rwA27nqh3UncKHJ6Be
         HHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ITBoLYA2N5MuLO3gqnXnaF4OTMmFSVYBYZ7MPGfv98c=;
        b=6PZaI4uBT5iUz8U6hV1J1DevCExW6Yt4IaAvWmI2WBmI/UsQB3z/kfp/CYd2/StapY
         QDRexTXLs3hIPGPA8fqQDkeWlRbIcMvcL92up1Pm51xp+doyG13TH72OycgqLqSn3sjU
         GgM0Q5IS7Jz6aNhQbqDUSY+sL+6wf7ggB/nyLURjSxH0691wE9K5Lu3OtSEodnw2KHoe
         MmyPcOJslXyiksH9EGbZO9HhPkCq+DD2gZaXusdzkvVVSrOPMR65xQPlb7j+d2qwffh7
         MiaWdmnkESnY9TBimEgMK49lIX4Ps5NzQMwjlhiNK7sBxNpR/ihtodN4gGqEgsL/WgwR
         K1VA==
X-Gm-Message-State: AOAM5321//9tT9H5GhKcIyEf4UxmmfnrDFyyZWbqXVYhWraVjSRVTvL3
        sW9tNTnX3FwKKBqLO88DnBpa5TBUPIi9GQ==
X-Google-Smtp-Source: ABdhPJzhksldhSpuMrQXGmaC+i4KujXhjL1ZD15ZkzgePaXPsBUiLjWfbR0ZYRlvgT7qv3JhL0MNrQ==
X-Received: by 2002:a5d:4c49:0:b0:210:353c:1c91 with SMTP id n9-20020a5d4c49000000b00210353c1c91mr49318338wrt.159.1654957093371;
        Sat, 11 Jun 2022 07:18:13 -0700 (PDT)
Received: from smtpclient.apple ([167.99.200.149])
        by smtp.gmail.com with ESMTPSA id i7-20020a1c3b07000000b0039744bd664esm6950127wma.13.2022.06.11.07.18.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jun 2022 07:18:12 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: Regression in 5.18.3 from "xhci: Set HCD flag to defer primary
 roothub registration"
From:   Christian Hewitt <christianshewitt@gmail.com>
In-Reply-To: <YqRFH2i3s/jL28ZG@kroah.com>
Date:   Sat, 11 Jun 2022 18:18:08 +0400
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        linux-usb@vger.kernel.org,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AF1EDC5C-7304-48F4-A981-CD8DDBFAB5EE@gmail.com>
References: <743F7369-2794-4189-8891-5DA62E4B62DA@gmail.com>
 <YqRFH2i3s/jL28ZG@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On 11 Jun 2022, at 11:32 am, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> On Sat, Jun 11, 2022 at 10:49:23AM +0400, Christian Hewitt wrote:
>> Commit 6c64a664e1cff339ec698d803fa8cbb9af5d95ce =E2=80=9Cxhci: Set =
HCD flag to defer
>> primary roothub registration=E2=80=9D added for Linux 5.18.3 caused a =
regression on
>> some Amlogic S912 devices (original user forum report with an Android =
TV box
>> and confirmed with a Khadas VIM2 board). I do not see issues with =
older S905
>> (WeTeK Play2) or newer S922X (Odroid N2+) devices running the same =
kernel.
>> There are no kernel splats or error messages but lsusb shows no =
output and
>> nothing works. Simple revert restores the previous good working =
behaviour.
>>=20
>> dmesg with commit http://ix.io/3ZTv
>> dmesg with revert http://ix.io/3ZTw
>>=20
>> I=E2=80=99m not a coder so will need to be fed instructions to assist =
with debugging
>> the issue further if you don't have access to an Amlogic S912 device. =
I can
>> share devices online for remote poking around if needed.
>=20
> Does 5.19-rc1 also have this problem?

No, and in the process of fixing up my normal patchset to test 5.19-rc1 =
I=E2=80=99ve
spotted some other USB patches picked from lists. Once dropped from =
5.18.3 usb
works again. So my bad, sorry for the noise!

Christian=
