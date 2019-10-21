Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 566F3DF225
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 17:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfJUP5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 11:57:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53716 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728205AbfJUP5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 11:57:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571673421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2tFRZlOvIgHzGsOY50Q9X5enGn3XtVTsJKLdNE1jHZY=;
        b=dowO80kLwDY1Ia7jDE4VPLOh2ZbPB7oNHtGXcAn2LgelBrG+uCRmirqOGC+IeOuNjpW8lr
        9EDM5hQi2HrIOmohLuJJeP2aNItQha2waorcaYc+qVDwQrLLLV8K3ZpBJ45jbd+KDeyKEB
        lkGakraXBGw4isdPspRwfAahc1Z4LkQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-jAWxgZJeMCKYgp3a-dSzmA-1; Mon, 21 Oct 2019 11:56:59 -0400
Received: by mail-wr1-f71.google.com with SMTP id a15so7566250wrr.0
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 08:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YvFrcyu8DvgIyxxeiblPi76YG2Hq9swys16D2sk2thI=;
        b=paJR38dE1OCbBA5UTY0/HpCWt+sFhRu8zOcVet4RoYZNLdOg+DMUoqxK+zzMp9LPNI
         hp4niDBe9yrJ3I65kWL8UD6YMvHSSGkB4nAHlswjkXI6xO12yQDCFypX3jRbJPbvWc6l
         +Nlvna96u5LdmSqxECZn9hyEoMq+ERghz7+znfb8grADgOVlcvTJnor2Bmpt8otXbQ24
         /tSNA/SJsYc+xCb5Xnmr6nvKOcZqOhp4xkAIOaNUalFeBPlEgwDmG8CDL+kUl5xlnzgK
         7axhjNp0H6QmKWTRgADd+XNsMQdGMqpoJRkUd6iDhrHecb0Yn4uP6NqLNfiRjppAO/TP
         xi8Q==
X-Gm-Message-State: APjAAAVjPwPLCCnF4MSimsQzjGQpsoXDjV9rpRIgp5roXoZgk89yMdjF
        lTS4qqOfMiRgUVd56u7bXeQHJmhKmv415hZUL7R65CoQ/z4ONIDVYyM+j9EwB9FlunFdH573I69
        JEDGQ59TS2fE1lZab
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr20453575wml.169.1571673418328;
        Mon, 21 Oct 2019 08:56:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwPfUSXwj2RBQAOL+Bs6XgNsrB/x5EQDokVunT5lvWqBC6nAWQYxZ5p2uqJSVkkUprv7ruuQQ==
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr20453563wml.169.1571673418145;
        Mon, 21 Oct 2019 08:56:58 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id v11sm13140430wml.30.2019.10.21.08.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:56:57 -0700 (PDT)
Subject: Re: [PATCH] tpm: Switch to platform_get_irq_optional()
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
References: <20191019094528.27850-1-hdegoede@redhat.com>
 <20191021154942.GB4525@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <80409d36-53fa-d159-d864-51b8495dc306@redhat.com>
Date:   Mon, 21 Oct 2019 17:56:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191021154942.GB4525@linux.intel.com>
Content-Language: en-US
X-MC-Unique: jAWxgZJeMCKYgp3a-dSzmA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 21-10-2019 17:49, Jarkko Sakkinen wrote:
> On Sat, Oct 19, 2019 at 11:45:28AM +0200, Hans de Goede wrote:
>> Since commit 7723f4c5ecdb ("driver core: platform: Add an error message =
to
>> platform_get_irq*()"), platform_get_irq() will call dev_err() on an erro=
r,
>> as the IRQ usage in the tpm_tis driver is optional, this is undesirable.
>>
>> Specifically this leads to this new false-positive error being logged:
>> [    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found
>>
>> This commit switches to platform_get_irq_optional(), which does not log
>> an error, fixing this.
>>
>> Cc: <stable@vger.kernel.org> # 5.4.x
>=20
> Incorrect format (should be wo '<' and '>').

According to:

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

the '<' and '>' should be added when adding a # <kerner>

> Also, not sure why this should be backported to stable kernel anyway.

Because false-positive error messages are bad and cause users to
file false-positive bug-reports.

Regards,

Hans

