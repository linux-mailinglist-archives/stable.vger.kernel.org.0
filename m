Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C492E3E65
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 23:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfJXVmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 17:42:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54440 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727327AbfJXVmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 17:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571953366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGkV4YJUEO3qbrdqTa8x/8kmlCZ5hNe2TSncdT95RyM=;
        b=bqbk0H3kdaYXpesFAaAxhhv7KFlB8vT5yqtd+NS555EYTAJWZuP1nvBV+1naYFVGCvhNVC
        RdZv+4tRyZzhVYCft2R8c2G0uBBFvCPV9U7vKLVCznro/8jlfRZnQm5MEp8IknGGlC4vwV
        CaxhLxwwlcXnkzAbGs4XxJKhF/dj9KM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-9JqOTgAeOwuC-_-H_Xe4WQ-1; Thu, 24 Oct 2019 17:42:43 -0400
Received: by mail-wr1-f69.google.com with SMTP id z9so4399324wrq.11
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 14:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8CT1TODYQhVLZHx2+A61//ZvlfiWgxqGvqrGHfOtDiw=;
        b=FG8EvV1xE9G/aa5nRGsEM0dW7+NqRabzOOrcTp0eO2E9NsDoxHuKmO4oAhVqGfF62z
         BxoD8HfZFleThldBWSp0tIhv4NcOmehpsjjIwY0hUR7FRuRBvahC/sbKvnN/o+MVcDad
         dCHFbccsdplAevvV9xFZtn9J+BLY31OV41nrx7xJg4UXYGh+KuoADxgp55QSoP6MWWEi
         3E+T5YQgMDAAHxf4/fnq27tYaakymXD02u4p9NmE8E6u1KY7+jcRQMAMQHnwbgbvhgOi
         UKKgWzf0K2Rd07snpJsFSlsd99JuEXjao5S5bMLtiV4+RmQrIacFuHDGxPX6p5+e5g5W
         twDA==
X-Gm-Message-State: APjAAAWLKDBxzjQ5ZWpHUpb1X43IbZrGllAuAvQJ7VlVRN5SUbh6bM6J
        9DteRHzmxyPUkmg+Cynt3i7Wqpi+h4HvAMjSKxJnVLsBdxj8Vbzq86gqDGFDNowc56PSa53dbgB
        pbYz15iVQcY5w8aMl
X-Received: by 2002:a1c:ed0d:: with SMTP id l13mr406396wmh.54.1571953361925;
        Thu, 24 Oct 2019 14:42:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyEFOq5uxVwPaAJjuPoDKqxQbRpwXNg/ynJ9pBdXdDtlhxOvBmgrTpO/uXLu4upkzZdh/jtcA==
X-Received: by 2002:a1c:ed0d:: with SMTP id l13mr406386wmh.54.1571953361725;
        Thu, 24 Oct 2019 14:42:41 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id i18sm149304wrx.14.2019.10.24.14.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 14:42:41 -0700 (PDT)
Subject: Re: [PATCH 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to
 lpss_device_links
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Stable <stable@vger.kernel.org>
References: <20191024212936.144648-1-hdegoede@redhat.com>
 <CAJZ5v0jDuvEBob93wgYFuz0q1QyraOtxnbs-xqBOM_87jBnKqw@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <946835e4-10f0-4d3f-a151-983d54034aca@redhat.com>
Date:   Thu, 24 Oct 2019 23:42:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0jDuvEBob93wgYFuz0q1QyraOtxnbs-xqBOM_87jBnKqw@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: 9JqOTgAeOwuC-_-H_Xe4WQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 24-10-2019 23:34, Rafael J. Wysocki wrote:
> On Thu, Oct 24, 2019 at 11:29 PM Hans de Goede <hdegoede@redhat.com> wrot=
e:
>>
>> So far on Bay Trail (BYT) we only have been adding a device_link adding
>> the iGPU (LNXVIDEO) device as consumer for the I2C controller for the
>> PMIC for I2C5, but the PMIC only uses I2C5 on BYT CR (cost reduced) on
>> regular BYT platforms I2C7 is used and we were not adding the device_lin=
k
>> sometimes causing resume ordering issues.
>>
>> This commit adds LNXVIDEO -> BYT I2C7 to the lpss_device_links table,
>> fixing this.
>>
>> Cc: stable@vger.kernel.org
>=20
> Thanks for these fixes, but it would be kind of nice to have Fixes:
> tags for them too.

Ok, v2 with fixes tag coming up.

Regards,

Hans



>=20
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/acpi/acpi_lpss.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
>> index 60bbc5090abe..e7a4504f0fbf 100644
>> --- a/drivers/acpi/acpi_lpss.c
>> +++ b/drivers/acpi/acpi_lpss.c
>> @@ -473,9 +473,14 @@ struct lpss_device_links {
>>    * the supplier is not enumerated until after the consumer is probed.
>>    */
>>   static const struct lpss_device_links lpss_device_links[] =3D {
>> +       /* CHT External sdcard slot controller depends on PMIC I2C ctrl =
*/
>>          {"808622C1", "7", "80860F14", "3", DL_FLAG_PM_RUNTIME},
>> +       /* CHT iGPU depends on PMIC I2C controller */
>>          {"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>> +       /* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
>>          {"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>> +       /* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
>> +       {"80860F41", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>>   };
>>
>>   static bool hid_uid_match(struct acpi_device *adev,
>> --
>> 2.23.0
>>

