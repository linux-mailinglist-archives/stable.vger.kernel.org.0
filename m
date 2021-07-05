Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196EC3BC20F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhGERLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 13:11:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhGERLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 13:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625504946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cpP3oLwWEvN7Jmq0aeYg9XO29HaHfIVyRVLgI+GVHg=;
        b=Mdl6JQ2EBstUMXg99UNdBMJz3UuhSlVdNKb1rpRhNQvi3giO+fMUANSCAd5vb18v8uTWXi
        A+FOleZwBRMpOL+s3k22qQtUCyuZr8onEYXuyTRH7XGWionWzaLDQUaq6v6qXf2U5TQ+Tn
        O95l/hi8ifvG0Myma1hqaz93PufmIGU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-hSK2Ir3FMke5nHo1uvcD4A-1; Mon, 05 Jul 2021 13:09:05 -0400
X-MC-Unique: hSK2Ir3FMke5nHo1uvcD4A-1
Received: by mail-ed1-f71.google.com with SMTP id j15-20020a05640211cfb0290394f9de5750so9321597edw.16
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 10:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1cpP3oLwWEvN7Jmq0aeYg9XO29HaHfIVyRVLgI+GVHg=;
        b=ucJ18uSo7rUvKNR5LMtZ47jN5orrISF2cxILzJTmKvBqecmUhfrmUi/3u+Rx2sC7VZ
         UjH3fbXcELjkQF2uJm+gmCrPKVoGxDCSkOMDDoE/ZRUQxvDO7sUw/aDeKtKR++/LSbjl
         jGqcPNeedx+FUT0GN1/tPRNdRHd5uexzLxJeoZ3ykLbXmMaEeJNsuEVEmGyxUm6O3E3n
         tFkLhg+AFVqFNjOtZwwtfyGELa8qrffs2mn4AwV4BZ3KA2tZY93Km4VCCS5h68Vb/ryp
         sLH++QKrUNwXd76L4rXhf5Wf8SJNqAuKcIHIc0tmyOhLqGH2pZeuyqc0YtWCgP9jxtJx
         POoQ==
X-Gm-Message-State: AOAM53207wXZlpoisEa+pLIdFO8sA9lbN/u6YahG38Tku9mtihgjMS+5
        u5NrJKAYWyydbfOvi3bTWRTrQ6+d7TVjnkmKYadFfhrD38g7PjJ3Xk0MOeOAO2kKJ7K2taGovzu
        7Asw2qKvhgcWhW8SW
X-Received: by 2002:a17:907:778a:: with SMTP id ky10mr14229495ejc.32.1625504944236;
        Mon, 05 Jul 2021 10:09:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznvs4TNbweq++v2M52oWrHrhml8/xf8BwbB+rq4lN75LXV93FLEJhvo1YPWvz+cU/HEU6hKw==
X-Received: by 2002:a17:907:778a:: with SMTP id ky10mr14229485ejc.32.1625504944025;
        Mon, 05 Jul 2021 10:09:04 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id x1sm5527174edd.25.2021.07.05.10.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 10:09:03 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.13 31/59] platform/x86: asus-nb-wmi: Revert "add
 support for ASUS ROG Zephyrus G14 and G15"
From:   Hans de Goede <hdegoede@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
References: <20210705152815.1520546-1-sashal@kernel.org>
 <20210705152815.1520546-31-sashal@kernel.org>
 <c8ecb9c4-d6b7-bff5-e070-2504069d57f5@redhat.com>
Message-ID: <826c32c5-0b00-b3ad-008f-7264bf5254e6@redhat.com>
Date:   Mon, 5 Jul 2021 19:09:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c8ecb9c4-d6b7-bff5-e070-2504069d57f5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 7/5/21 7:08 PM, Hans de Goede wrote:
> Hi,
> 
> On 7/5/21 5:27 PM, Sasha Levin wrote:
>> From: "Luke D. Jones" <luke@ljones.dev>
>>
>> [ Upstream commit 28117f3a5c3c8375a3304af76357d5bf9cf30f0b ]
>>
>> The quirks added to asus-nb-wmi for the ASUS ROG Zephyrus G14 and G15 are
>> wrong, they tell the asus-wmi code to use the vendor specific WMI backlight
>> interface. But there is no such interface on these laptops.
>>
>> As a side effect, these quirks stop the acpi_video driver to register since
>> they make acpi_video_get_backlight_type() return acpi_backlight_vendor,
>> leaving only the native AMD backlight driver in place, which is the one we
>> want. This happy coincidence is being replaced with a new quirk in
>> drivers/acpi/video_detect.c which actually sets the backlight_type to
>> acpi_backlight_native fixinf this properly. This reverts
>> commit 13bceda68fb9 ("platform/x86: asus-nb-wmi: add support for ASUS ROG
>> Zephyrus G14 and G15").
>>
>> Signed-off-by: Luke D. Jones <luke@ljones.dev>
>> Link: https://lore.kernel.org/r/20210419074915.393433-3-luke@ljones.dev
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Note this should only be cherry-picked if commit 2dfbacc65d1d
> ("ACPI: video: use native backlight for GA401/GA502/GA503"):
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2dfbacc65d1d2eae587ccb6b93f6280542641858
> 
> Is also being cherry-picked, since the quirk added in that commit
> replaces the quirks which are being reverted here.

p.s.

The same remark also replies to the 5.12 and 5.10 cherry-picks of
this commit.



>> ---
>>  drivers/platform/x86/asus-nb-wmi.c | 82 ------------------------------
>>  1 file changed, 82 deletions(-)
>>
>> diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
>> index b07b1288346e..0cb927f0f301 100644
>> --- a/drivers/platform/x86/asus-nb-wmi.c
>> +++ b/drivers/platform/x86/asus-nb-wmi.c
>> @@ -110,16 +110,6 @@ static struct quirk_entry quirk_asus_forceals = {
>>  	.wmi_force_als_set = true,
>>  };
>>  
>> -static struct quirk_entry quirk_asus_ga401i = {
>> -	.wmi_backlight_power = true,
>> -	.wmi_backlight_set_devstate = true,
>> -};
>> -
>> -static struct quirk_entry quirk_asus_ga502i = {
>> -	.wmi_backlight_power = true,
>> -	.wmi_backlight_set_devstate = true,
>> -};
>> -
>>  static struct quirk_entry quirk_asus_use_kbd_dock_devid = {
>>  	.use_kbd_dock_devid = true,
>>  };
>> @@ -430,78 +420,6 @@ static const struct dmi_system_id asus_quirks[] = {
>>  		},
>>  		.driver_data = &quirk_asus_forceals,
>>  	},
>> -	{
>> -		.callback = dmi_matched,
>> -		.ident = "ASUSTeK COMPUTER INC. GA401IH",
>> -		.matches = {
>> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IH"),
>> -		},
>> -		.driver_data = &quirk_asus_ga401i,
>> -	},
>> -	{
>> -		.callback = dmi_matched,
>> -		.ident = "ASUSTeK COMPUTER INC. GA401II",
>> -		.matches = {
>> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401II"),
>> -		},
>> -		.driver_data = &quirk_asus_ga401i,
>> -	},
>> -	{
>> -		.callback = dmi_matched,
>> -		.ident = "ASUSTeK COMPUTER INC. GA401IU",
>> -		.matches = {
>> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IU"),
>> -		},
>> -		.driver_data = &quirk_asus_ga401i,
>> -	},
>> -	{
>> -		.callback = dmi_matched,
>> -		.ident = "ASUSTeK COMPUTER INC. GA401IV",
>> -		.matches = {
>> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IV"),
>> -		},
>> -		.driver_data = &quirk_asus_ga401i,
>> -	},
>> -	{
>> -		.callback = dmi_matched,
>> -		.ident = "ASUSTeK COMPUTER INC. GA401IVC",
>> -		.matches = {
>> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IVC"),
>> -		},
>> -		.driver_data = &quirk_asus_ga401i,
>> -	},
>> -		{
>> -		.callback = dmi_matched,
>> -		.ident = "ASUSTeK COMPUTER INC. GA502II",
>> -		.matches = {
>> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA502II"),
>> -		},
>> -		.driver_data = &quirk_asus_ga502i,
>> -	},
>> -	{
>> -		.callback = dmi_matched,
>> -		.ident = "ASUSTeK COMPUTER INC. GA502IU",
>> -		.matches = {
>> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IU"),
>> -		},
>> -		.driver_data = &quirk_asus_ga502i,
>> -	},
>> -	{
>> -		.callback = dmi_matched,
>> -		.ident = "ASUSTeK COMPUTER INC. GA502IV",
>> -		.matches = {
>> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IV"),
>> -		},
>> -		.driver_data = &quirk_asus_ga502i,
>> -	},
>>  	{
>>  		.callback = dmi_matched,
>>  		.ident = "Asus Transformer T100TA / T100HA / T100CHI",
>>

