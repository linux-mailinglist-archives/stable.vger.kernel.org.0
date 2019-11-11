Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763DBF7777
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 16:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfKKPQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 10:16:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42176 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726877AbfKKPQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 10:16:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573485366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4JEdIJ6YhE+vvBuPhjZlUD+QEB3jTu1WEVSvfoYCqDk=;
        b=Q2D6ttLEoC5BsF+53FQmg8WEkhGlhus0UYYOTDh+VvxgHzimPjzzjKOXBzeCdHgo0x/pX+
        SU9LJPPBaXMCIdC00EEwK/wGmrWgP7VFAyUHUA+6o+dS6ANs90UL/igqdxjBoVG1MdlCYF
        RJ/637Wy5chmQ5SYcXB6O1p3+d6wUoI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-80TUFuYROAmlZkvacQyp_g-1; Mon, 11 Nov 2019 10:16:06 -0500
Received: by mail-wm1-f69.google.com with SMTP id f21so4176726wmh.5
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 07:16:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4b18bXFlRrcsnvWzoUTGbcgHNd52OcwtqpjufX+uIWQ=;
        b=TsL3v0NjWZajAt3HqaflRHYh+J2VRDzko2A1ZhKObfeXlodDYFXDCdVF360sLQkziz
         +V2CrVU5AanBYScJmLws6+0uk0w5yc2So/64Y4S34Y/5IeV+6pxX2C5ncCRVt3xxMXW5
         PpUkhn2wQEFFNWpGRdB/FBql2IQYFpzuUVTHm7wumInUuBlUAHIViapOLnk4yfMrcttm
         gaBUBIBSL1fxR7HbrWAeROxgF7PqKHnuL1qImANvPwzjNB5N7bY4uvj8ApTpoeKCYPe4
         1Al7NDXQpIhJR6ogl8mNkr4JWU3b/kR1Ux4iri7cku/4AssNsDCuvr0H9iXd+TCt/mcv
         1urw==
X-Gm-Message-State: APjAAAVndVKpIHAFS2oXKKqK/ywAb4KX9EQ+0ky1RRoAKmLOzkSElQcD
        VpJAF7tLODJNTrs0fokaFfk+asRS7yoHQxrNzbclH8sMd5czz8PjZv+5pMl0LZv1uiCL7mNj9xo
        yO6PfzXMb9g2/vwNT
X-Received: by 2002:a1c:9601:: with SMTP id y1mr20030720wmd.157.1573485364631;
        Mon, 11 Nov 2019 07:16:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqyTvpYTd8nyy5wzcmrMDiCP7mO/ux6vdfSjujSrtJIoQVVxue+GQUBA2j7Jdo1Up4wq6GRgCA==
X-Received: by 2002:a1c:9601:: with SMTP id y1mr20030705wmd.157.1573485364460;
        Mon, 11 Nov 2019 07:16:04 -0800 (PST)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id j67sm20071881wmb.43.2019.11.11.07.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 07:16:03 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] pinctrl: cherryview: Fix irq_valid_mask
 calculation" failed to apply to 5.3-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
References: <157345248387137@kroah.com> <20191111133618.GT4787@sasha-vm>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <b6bd328e-d0ac-4b59-64ae-585efb7387c0@redhat.com>
Date:   Mon, 11 Nov 2019 16:16:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191111133618.GT4787@sasha-vm>
Content-Language: en-US
X-MC-Unique: 80TUFuYROAmlZkvacQyp_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11-11-2019 14:36, Sasha Levin wrote:
> On Mon, Nov 11, 2019 at 07:08:03AM +0100, gregkh@linuxfoundation.org wrot=
e:
>>
>> The patch below does not apply to the 5.3-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From 63bdef6cd6941917c823b9cc9aa0219d19fcb716 Mon Sep 17 00:00:00 2001
>> From: Hans de Goede <hdegoede@redhat.com>
>> Date: Fri, 18 Oct 2019 11:08:42 +0200
>> Subject: [PATCH] pinctrl: cherryview: Fix irq_valid_mask calculation
>>
>> Commit 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux
>> GPIO translation") has made the cherryview gpio numbers sparse, to get
>> a 1:1 mapping between ACPI pin numbers and gpio numbers in Linux.
>>
>> This has greatly simplified things, but the code setting the
>> irq_valid_mask was not updated for this, so the valid mask is still in
>> the old "compressed" numbering with the gaps in the pin numbers skipped,
>> which is wrong as irq_valid_mask needs to be expressed in gpio numbers.
>>
>> This results in the following error on devices using pin 24 (0x0018) on
>> the north GPIO controller as an ACPI event source:
>>
>> [=A0=A0=A0 0.422452] cherryview-pinctrl INT33FF:01: Failed to translate =
GPIO to IRQ
>>
>> This has been reported (by email) to be happening on a Caterpillar CAT T=
20
>> tablet and I've reproduced this myself on a Medion Akoya e2215t 2-in-1.
>>
>> This commit uses the pin number instead of the compressed index into
>> community->pins to clear the correct bits in irq_valid_mask for GPIOs
>> using GPEs for interrupts, fixing these errors and in case of the
>> Medion Akoya e2215t also fixing the LID switch not working.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux G=
PIO translation")
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>=20
> I've adjust the patch to work around not having 5fbe5b5883f8 ("gpio:
> Initialize the irqchip valid_mask with a callback") and queued it for
> 5.3 and 4.19.

Great, thank you!

Regards,

Hans

