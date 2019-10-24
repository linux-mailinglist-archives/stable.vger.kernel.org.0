Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634F4E3E7E
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 23:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfJXVrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 17:47:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32046 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729727AbfJXVrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 17:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571953653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WCDRuQbS/Z1gMxTsY2RofqKVcujdzy6VlI52XxW4QvQ=;
        b=JaU7d/phsEgb3VJ8Apv0iiML8G9YLipJoOLeTKAk9lS6F7xtMiYUEI3l8gh3UH+ifWJK4g
        NDFMh9ALPJCSS5dgTiEQxdHM/0C1+XUbYGlFp1zSUY7E+BWG5E3c2Pu50epNzfHdeayQKt
        0lREi4CtoCWb+Es0GLP//P4TmdgynQ0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-utle80UtN6OZoBFmOFbzEQ-1; Thu, 24 Oct 2019 17:47:31 -0400
Received: by mail-wm1-f70.google.com with SMTP id i23so172316wmb.3
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 14:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r1jDnrSSRBpTNywi5Sd+tbO0RQK/lSWgY1GbB7xeYmA=;
        b=Nikl6vRx6pjjhNEVHqQOr8/CRlcHIe1Xei/XdTQw+RrPq+qyDdZ6Lp/fHbItYtV6hE
         P0S7SKLNnzIJyLyusIz3TfFh2aaajOesUrrJ1u5tyLVgGMWXDz8hqZlS3DHdTOJOVVxP
         ivixYtl8aS9S3Hl1JaWabDF9IrOPZ6bZlx9iRCExXNEAejsShDp07ZCR18Nz1/YGz1ny
         K+JoVIUdkfPRb35MWYsPzJpAAfqVct7dO8/ljusqq7vwU10W8iWBEZh2PJHxXou7LtyA
         lgl25m+x2cl1VpqTAgHNiG8En09059RGSNbzCYTjcSkIhGSrUtS+J1aokQciLZhKZbwN
         OyDg==
X-Gm-Message-State: APjAAAWiX49VCvy5/lFLquefj9/NQYMkkzmHHnUizXiJFbIXk6zhUmeg
        Ku9ukSXhK3Lrcy7gKnE25Rw0Nsf3Md5xKHU+7UiJytSoosZ3D07t427znUTniQ9TeyajbtgtPWQ
        UkLykf1GYE0q5cOgF
X-Received: by 2002:a05:6000:34f:: with SMTP id e15mr6201413wre.232.1571953649892;
        Thu, 24 Oct 2019 14:47:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8ZZfydf2VwijweCRsVTs+X3Ye2kl90Ol53cbx5a3kYbFqG5t/ruquXD5C+vx+IVWPcNPjFg==
X-Received: by 2002:a05:6000:34f:: with SMTP id e15mr6201398wre.232.1571953649661;
        Thu, 24 Oct 2019 14:47:29 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id o4sm71859wre.91.2019.10.24.14.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 14:47:29 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to
 lpss_device_links
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
References: <20191024214248.145429-1-hdegoede@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <bdbaeb49-5b56-9dc1-edb9-2a0600acc890@redhat.com>
Date:   Thu, 24 Oct 2019 23:47:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024214248.145429-1-hdegoede@redhat.com>
Content-Language: en-US
X-MC-Unique: utle80UtN6OZoBFmOFbzEQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 24-10-2019 23:42, Hans de Goede wrote:
> So far on Bay Trail (BYT) we only have been adding a device_link adding
> the iGPU (LNXVIDEO) device as consumer for the I2C controller for the
> PMIC for I2C5, but the PMIC only uses I2C5 on BYT CR (cost reduced) on
> regular BYT platforms I2C7 is used and we were not adding the device_link
> sometimes causing resume ordering issues.
>=20
> This commit adds LNXVIDEO -> BYT I2C7 to the lpss_device_links table,
> fixing this.
>=20
> Cc: stable@vger.kernel.org
> Fixes: e6ce0ce34f65 ("ACPI / LPSS: Add device link for CHT SD card ... on=
 I2C")

Self-nack, although technically correct, backporting this that far
may lead to trouble as some fixes in other places are necessary.

I believe I found a better commit to refer to with the Fixes tag, so
I will send out a v3 shortly, sorry for the noise.

Regards,

Hans


> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Add Fixes: tag
> ---
>   drivers/acpi/acpi_lpss.c | 5 +++++
>   1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 60bbc5090abe..e7a4504f0fbf 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -473,9 +473,14 @@ struct lpss_device_links {
>    * the supplier is not enumerated until after the consumer is probed.
>    */
>   static const struct lpss_device_links lpss_device_links[] =3D {
> +=09/* CHT External sdcard slot controller depends on PMIC I2C ctrl */
>   =09{"808622C1", "7", "80860F14", "3", DL_FLAG_PM_RUNTIME},
> +=09/* CHT iGPU depends on PMIC I2C controller */
>   =09{"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
> +=09/* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
>   =09{"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
> +=09/* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
> +=09{"80860F41", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>   };
>  =20
>   static bool hid_uid_match(struct acpi_device *adev,
>=20

