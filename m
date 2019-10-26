Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8CE6E5DAE
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 16:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfJZO0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 10:26:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28608 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726185AbfJZO0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Oct 2019 10:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572099973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UeGDnrcYRS03+kbquaBmUlrmohx1QXf8Xm7pVh1ile8=;
        b=ejyFmhRFI8ju5rMTRJ14XqwFHoR1Gu9PVksAxJcpJl+B2Hg9ev08tOXOKF1soqyIB4UkLn
        4CcPNC1ym35ZMgPPCpiAwENoe1oa2FiVJfqbYVdxjWFf2uK5hD0vysEIzhJ1oH8J+OthHy
        Qb763IsOn1kTAGKEmbpp9+AskGI9mlo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-5Wn8LtmPNLmTywE7_GLpdA-1; Sat, 26 Oct 2019 10:26:11 -0400
Received: by mail-wr1-f69.google.com with SMTP id i10so3018180wrb.20
        for <stable@vger.kernel.org>; Sat, 26 Oct 2019 07:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIZRqtN84dQmAniq7BWIQAUQRqocsgrM3ZR72J2Llqk=;
        b=thfOUQUykRc0xAGmz6DzfFfGDNMuUqELYRrFdwe65PGAymRpZeRHxwWwxN9q5o3VRQ
         TNuIEIlhnOEzT9kzRKm24SeR+RSQZpxAK0x6zK56GzS7RcyHvwkhamz1xfIOPIp13gSt
         UQ0aR2QBxYq3WhYdry68wSLqoI/Iy3h+1lnuPp5CMjHr2ZU4Ihaw/JzWztCxEVmvbr4l
         32jQrsepTbLxEk5ByitJVWM4z7nsEa1H/NFfIwi2XtuiHUBq1LRu+w0OcQUYOl4/Z6HE
         BvARWF3q64JEzNjgHSzOqRCKuQd98Br0YwD/OSPr5lWPZcOkKTq0Vu+uGxn/crnvjopL
         BghA==
X-Gm-Message-State: APjAAAWrRApribJ/SD2Y2p8EmIUkCwyxOQmgu4K17zEkkGhA6b5ouojp
        WLE8Q7MV2f716/yA+1SM7NRQoM5P+l/H24LnARr8zDz/6IUFQFdxrOjY7g9bVmtvjNW1ldSbnnU
        BiF1ACY4okgIzkeIn
X-Received: by 2002:a05:600c:350:: with SMTP id u16mr1057305wmd.160.1572099970123;
        Sat, 26 Oct 2019 07:26:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxlEtzA5sBA1c8Z9+nc6hfadCg120TLLwkC6odT00c6TmZTkQQxwVlXv+e59SfwTSohRxInpQ==
X-Received: by 2002:a05:600c:350:: with SMTP id u16mr1057298wmd.160.1572099969963;
        Sat, 26 Oct 2019 07:26:09 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id b3sm4607142wrv.40.2019.10.26.07.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Oct 2019 07:26:09 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to
 lpss_device_links
To:     Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>
Cc:     stable@vger.kernel.org
References: <20191024214248.145429-1-hdegoede@redhat.com>
 <20191026131048.4FA3E206DD@mail.kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <18e64905-f42c-b80e-1475-dc7c981d0048@redhat.com>
Date:   Sat, 26 Oct 2019 16:26:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191026131048.4FA3E206DD@mail.kernel.org>
Content-Language: en-US
X-MC-Unique: 5Wn8LtmPNLmTywE7_GLpdA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 26-10-2019 15:10, Sasha Levin wrote:
> Hi,
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: e6ce0ce34f657 ACPI / LPSS: Add device link for CHT SD card=
 dependency on I2C.
>=20
> The bot has tested the following trees: v5.3.7, v4.19.80.
>=20
> v5.3.7: Build OK!
> v4.19.80: Failed to apply! Possible dependencies:
>      2d71ee0ce72f2 ("ACPI / LPSS: Add a device link from the GPU to the B=
YT I2C5 controller")
>      bd0f4e342e006 ("ACPI / LPSS: Add a device link from the GPU to the C=
HT I2C7 controller")
>=20
>=20
> NOTE: The patch will not be queued to stable trees until it is upstream.
>=20
> How should we proceed with this patch?

The entire series should be added to 5.3.z and 5.4.z, I do not believe that=
 backporting
to 4.19.z is necessary.

Regards,

Hans

