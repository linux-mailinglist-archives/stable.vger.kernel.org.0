Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EAA14ECAE
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 13:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgAaMrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 07:47:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31196 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728556AbgAaMrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 07:47:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580474866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJ+Vssnv3mqgwqCPy3HNMUmYarPoBbULfP/Tpg5cTWw=;
        b=PSUOkVXKwpQ0d3Dsg4W/K7U6zhQ/TPbJ5OcrrJsBZzys0VLHMbduAM/KUia7LIHdeLDd9v
        6OT+jXTcB3GGVsZL80WAHLtFdK09uxwK3obT10BteqoFmJSqlY7nmFgvBrf0AAWaAU3+v8
        ZP1BSgidExzgrubMSnZ+8DnG5oBJdxM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-E69ELYqWM42B1AnAh9MDVQ-1; Fri, 31 Jan 2020 07:47:44 -0500
X-MC-Unique: E69ELYqWM42B1AnAh9MDVQ-1
Received: by mail-wm1-f69.google.com with SMTP id o24so2765812wmh.0
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 04:47:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FJ+Vssnv3mqgwqCPy3HNMUmYarPoBbULfP/Tpg5cTWw=;
        b=HcbBgCC2DrFAuksTyiiyKSzKpnmdY95z2X09vYpS+xPjhVAxwjmeWPaQcRxZqUQaKO
         EZ/UoI2jliUCrUIER3472L7VJR6B2Vn387KfS4R040GAoKv1ku2nChAOehZrVLcD7TKT
         1sYhU1npCTrWZU23OFIUh/bjq7ZQgbQpk3nRlShhFf8PLz7GmLCxWPNXK0rlJ/ib2Vgg
         usyalss/flF9zj4uE2uZXhxdMNqsREBZdPrr4OgpZHXLgQ5nbXCKe4+hRmL+yubUzD7V
         GkVgnGwxYUHbiZdzMb8afv9vwmLzZG62VyC9e5Xg6R5eypfhP76tlqMyDX1QaFMQABG+
         N0BA==
X-Gm-Message-State: APjAAAW+41pVbbbqJdpTM/PbiBWqksk26NyYx9MKoUnyqNSTPx0G822d
        x3lX+Z4GkiRZuMJAuyMfU8JoyrQeOaBcf1cPcGE7foMS0bFDEK9o8OtPhhtA1js1pU1KJTRvVB5
        7bjHXFa5RV0xXpJWb
X-Received: by 2002:a05:6000:1292:: with SMTP id f18mr12352605wrx.10.1580474862739;
        Fri, 31 Jan 2020 04:47:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqxW7kuP5CGzJjB/fF/tTwc7/YXnVrTraYzsjTV7w5Tdm6z/9dzYrH2tGvhwtymRrBbRGTfprw==
X-Received: by 2002:a05:6000:1292:: with SMTP id f18mr12352591wrx.10.1580474862545;
        Fri, 31 Jan 2020 04:47:42 -0800 (PST)
Received: from localhost.localdomain ([109.38.133.176])
        by smtp.gmail.com with ESMTPSA id b17sm12019897wrp.49.2020.01.31.04.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 04:47:41 -0800 (PST)
Subject: Re: [PATCH] efi/bgrt: Accept BGRT tables with a version of 0 on
 Lenovo laptops
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20200126150231.6021-1-hdegoede@redhat.com>
 <CAKv+Gu_dE+pi7CSANOXEP2xenRirWQg5H71t5f4eah8-XZpbxQ@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <1e7dc0f5-6903-0382-cf32-54b1b095930f@redhat.com>
Date:   Fri, 31 Jan 2020 13:47:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu_dE+pi7CSANOXEP2xenRirWQg5H71t5f4eah8-XZpbxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/28/20 8:48 AM, Ard Biesheuvel wrote:
> On Sun, 26 Jan 2020 at 16:02, Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Some (somewhat older) Lenovo laptops have a correct BGRT table, except
>> that the version field is 0 instead of 1.
>>
>> Quickly after finding this out, even before submitting a first version of
>> this patch upstream, the list of DMI matches for affected models grew to
>> 3 models (all Ivy Bridge based).
>>
>> So rather then maintaining an ever growing list with DMI matches for
>> affected Lenovo models, this commit simply checks if the vendor is Lenovo
>> when the version is 0 and in that case accepts the out of spec version
>> working around the Lenovo firmware bug.
>>
>> Cc: stable@vger.kernel.org
>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1791273
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/firmware/efi/efi-bgrt.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
>> index b07c17643210..3a2d6d3a590b 100644
>> --- a/drivers/firmware/efi/efi-bgrt.c
>> +++ b/drivers/firmware/efi/efi-bgrt.c
>> @@ -15,6 +15,7 @@
>>   #include <linux/acpi.h>
>>   #include <linux/efi.h>
>>   #include <linux/efi-bgrt.h>
>> +#include <linux/dmi.h>
>>
>>   struct acpi_table_bgrt bgrt_tab;
>>   size_t bgrt_image_size;
>> @@ -42,7 +43,12 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
>>                  return;
>>          }
>>          *bgrt = *(struct acpi_table_bgrt *)table;
>> -       if (bgrt->version != 1) {
>> +       /*
>> +        * Some older Lenovo laptops have a correct BGRT table, except that
>> +        * the version field is 0 instead of 1.
>> +        */
>> +       if (bgrt->version != 1 &&
>> +           !(bgrt->version == 0 && dmi_name_in_vendors("LENOVO"))) {
>>                  pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
>>                         bgrt->version);
>>                  goto out;
> 
> Hi Hans,
> 
> Given that the ACPI spec only defines a single version for this table,
> which is version #1, wouldn't it be simpler to just assume that
> version #0 means version #1 in all cases, rather than using DMI
> matches for that? There is no risk of misidentifying another table
> version, since none exist ...

Ok, I will prepare a new version doing this.

Regards,

Hans

