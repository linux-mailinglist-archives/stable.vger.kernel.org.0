Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6963BC20C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 19:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhGERKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 13:10:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229689AbhGERKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 13:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625504885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLgweaTFwFEgTKZQi0sNPpLZ/ToUk9Ou6e3vo2daig0=;
        b=EA4hF4QwXamSWwY31anxsYv0k4GKfMlpM2/6dYcVOMwupKNZvyzsS5QTz8BIjqdZ/QeXt/
        Qb94Iou2GPWFVLzb7x1tf2/4H81PxO/xCskECEIhXFHl+a78AGmGWr9EWAbSBaLT8+GcOB
        rnuvDCH36kSs1UMQUiiO+gnzsOIJOoo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-IlAyNkdjMgC4xTsw2WWVsg-1; Mon, 05 Jul 2021 13:08:04 -0400
X-MC-Unique: IlAyNkdjMgC4xTsw2WWVsg-1
Received: by mail-ed1-f70.google.com with SMTP id m10-20020aa7c2ca0000b0290399df423df0so1168541edp.6
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 10:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WLgweaTFwFEgTKZQi0sNPpLZ/ToUk9Ou6e3vo2daig0=;
        b=SvsK676gnGoFyw2GZZTu8nfUraLDvEQT3RR2uCfquof4ruwG7HAvdYBoVMUu04GRMp
         OJofevwKHQYiTtvGqmJfk0qllFVmFPP9L6L6Kx+ovobcjRaJjTfhAwLWNkdtJVycIX4k
         G7czgUfWTReVPwnrCNGwMy+LYWPtCS5Ol0IprMFUh6S+fnok5A/2bSGkF7fMttGolLhS
         LbPA/9+3U6llDX/rFZxgofnEp3G+eD/mQWDgrmLv7eZx/8JtNsSkKWvcEaoQrnLrJgNj
         KaKtBIaW7Zt1CKYmg1fV+BWcev1OlUEMcoOkl4ScA35EHgtDUChM+J3ccfLKoPVjTGUi
         xBYw==
X-Gm-Message-State: AOAM53392cyzWJbrpt3NkmsD+Wonz7vIAOnWRZ7R5sstm4ANjj4NP1QM
        h8+57IHxGqvePRVOylHBvZVjpKDKdfQxdJFYRxkYocv1MaDzlbGAIVW292t0En9zsOYRZrbYAZt
        cuGxfuFodu25GD8bH
X-Received: by 2002:a17:906:c14e:: with SMTP id dp14mr13911420ejc.349.1625504883452;
        Mon, 05 Jul 2021 10:08:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjpYanp0l21slndEux6Cd4y9xPA6azwlvCw/hMav4smccH/M3DKFpEE/qiUNOWhzycClToDw==
X-Received: by 2002:a17:906:c14e:: with SMTP id dp14mr13911405ejc.349.1625504883288;
        Mon, 05 Jul 2021 10:08:03 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id j19sm5743230edr.64.2021.07.05.10.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 10:08:02 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.13 31/59] platform/x86: asus-nb-wmi: Revert "add
 support for ASUS ROG Zephyrus G14 and G15"
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
References: <20210705152815.1520546-1-sashal@kernel.org>
 <20210705152815.1520546-31-sashal@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <c8ecb9c4-d6b7-bff5-e070-2504069d57f5@redhat.com>
Date:   Mon, 5 Jul 2021 19:08:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705152815.1520546-31-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 7/5/21 5:27 PM, Sasha Levin wrote:
> From: "Luke D. Jones" <luke@ljones.dev>
> 
> [ Upstream commit 28117f3a5c3c8375a3304af76357d5bf9cf30f0b ]
> 
> The quirks added to asus-nb-wmi for the ASUS ROG Zephyrus G14 and G15 are
> wrong, they tell the asus-wmi code to use the vendor specific WMI backlight
> interface. But there is no such interface on these laptops.
> 
> As a side effect, these quirks stop the acpi_video driver to register since
> they make acpi_video_get_backlight_type() return acpi_backlight_vendor,
> leaving only the native AMD backlight driver in place, which is the one we
> want. This happy coincidence is being replaced with a new quirk in
> drivers/acpi/video_detect.c which actually sets the backlight_type to
> acpi_backlight_native fixinf this properly. This reverts
> commit 13bceda68fb9 ("platform/x86: asus-nb-wmi: add support for ASUS ROG
> Zephyrus G14 and G15").
> 
> Signed-off-by: Luke D. Jones <luke@ljones.dev>
> Link: https://lore.kernel.org/r/20210419074915.393433-3-luke@ljones.dev
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Note this should only be cherry-picked if commit 2dfbacc65d1d
("ACPI: video: use native backlight for GA401/GA502/GA503"):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2dfbacc65d1d2eae587ccb6b93f6280542641858

Is also being cherry-picked, since the quirk added in that commit
replaces the quirks which are being reverted here.

Regards,

Hans



> ---
>  drivers/platform/x86/asus-nb-wmi.c | 82 ------------------------------
>  1 file changed, 82 deletions(-)
> 
> diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
> index b07b1288346e..0cb927f0f301 100644
> --- a/drivers/platform/x86/asus-nb-wmi.c
> +++ b/drivers/platform/x86/asus-nb-wmi.c
> @@ -110,16 +110,6 @@ static struct quirk_entry quirk_asus_forceals = {
>  	.wmi_force_als_set = true,
>  };
>  
> -static struct quirk_entry quirk_asus_ga401i = {
> -	.wmi_backlight_power = true,
> -	.wmi_backlight_set_devstate = true,
> -};
> -
> -static struct quirk_entry quirk_asus_ga502i = {
> -	.wmi_backlight_power = true,
> -	.wmi_backlight_set_devstate = true,
> -};
> -
>  static struct quirk_entry quirk_asus_use_kbd_dock_devid = {
>  	.use_kbd_dock_devid = true,
>  };
> @@ -430,78 +420,6 @@ static const struct dmi_system_id asus_quirks[] = {
>  		},
>  		.driver_data = &quirk_asus_forceals,
>  	},
> -	{
> -		.callback = dmi_matched,
> -		.ident = "ASUSTeK COMPUTER INC. GA401IH",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IH"),
> -		},
> -		.driver_data = &quirk_asus_ga401i,
> -	},
> -	{
> -		.callback = dmi_matched,
> -		.ident = "ASUSTeK COMPUTER INC. GA401II",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401II"),
> -		},
> -		.driver_data = &quirk_asus_ga401i,
> -	},
> -	{
> -		.callback = dmi_matched,
> -		.ident = "ASUSTeK COMPUTER INC. GA401IU",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IU"),
> -		},
> -		.driver_data = &quirk_asus_ga401i,
> -	},
> -	{
> -		.callback = dmi_matched,
> -		.ident = "ASUSTeK COMPUTER INC. GA401IV",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IV"),
> -		},
> -		.driver_data = &quirk_asus_ga401i,
> -	},
> -	{
> -		.callback = dmi_matched,
> -		.ident = "ASUSTeK COMPUTER INC. GA401IVC",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IVC"),
> -		},
> -		.driver_data = &quirk_asus_ga401i,
> -	},
> -		{
> -		.callback = dmi_matched,
> -		.ident = "ASUSTeK COMPUTER INC. GA502II",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA502II"),
> -		},
> -		.driver_data = &quirk_asus_ga502i,
> -	},
> -	{
> -		.callback = dmi_matched,
> -		.ident = "ASUSTeK COMPUTER INC. GA502IU",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IU"),
> -		},
> -		.driver_data = &quirk_asus_ga502i,
> -	},
> -	{
> -		.callback = dmi_matched,
> -		.ident = "ASUSTeK COMPUTER INC. GA502IV",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IV"),
> -		},
> -		.driver_data = &quirk_asus_ga502i,
> -	},
>  	{
>  		.callback = dmi_matched,
>  		.ident = "Asus Transformer T100TA / T100HA / T100CHI",
> 

