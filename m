Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FAC56AD7A
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 23:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiGGVbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 17:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbiGGVbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 17:31:13 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9A72CCB6
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 14:31:11 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j7so11404495wmp.2
        for <stable@vger.kernel.org>; Thu, 07 Jul 2022 14:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fortu-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IucSNIUmv3bfoSWC2fpPpGIdntozHM3LrGlPGnTJnoo=;
        b=Z3+FvPR9cP3BN9xckeRw/vR52t06mLNibswiXImMS5IzyLigK74GbhAanYRUKC7JvH
         5LpEM946RK8Yn8D3lYqK2wKe3NVlOedv4WcnCIHbp8/8A+u8vn+DUEXuKnXDdoA4aHH4
         6saI7pVWqbI5+m7DC2YK+H3NIe+DkhjhNLfyEOHTdAtlf2SaO/qCHE5HEgRRkR7HlX2M
         KIOaZIlP1oRAga/+8hOfZI7mlP/lorTH9AdYycai88iGBD7UhUfPoMehq0G8sEEj1ZdY
         GxHVy2D0Yn23SPioQ/Tq+WxMPwCAcFfclfvnNaEdd31TDp7hFpXumwNN2/cCYyDhLDoM
         J2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IucSNIUmv3bfoSWC2fpPpGIdntozHM3LrGlPGnTJnoo=;
        b=ESifGT46DrK8ZfdEU9MlK0yzysU4HVSpjHRSCDoJUEz0was+vfwOpG1pdPSMk9brx1
         gzCKrhp97sqgOFAB/R+EUSYEpnwILg54+XO+Yyl6XFDtbjy/ySpBOBultIx70WHJuXaz
         5rLnYOTAipzo4MB5Fvm7RyUMbyfB+6n/B9EiiC1OeU+ZEMK+pxrecirASbYtrXBHazdm
         +t52k4a6xOmxu/hJD/uh4xRH4ZH18zrtBGDFjO63lMfaI2aN4kFY3UEwfE66Ieylzm+e
         5Dadb8lOO/0unYi+E3BJ34tyocndpkkKUNYTrZxhoDWLy4llGYiTqQBjSi27b+q7bnou
         2amA==
X-Gm-Message-State: AJIora+tVN5EqLESJIaWrZE5CPJmaC3ylN+8zWGHvyDmoEvk3HTNb95z
        NjFkfpNm8FwfHClpsX1TGcBI
X-Google-Smtp-Source: AGRyM1uzwSj6DHA7nKZebCyj2PA4fxLtm93WKT/k4GBSSZ3WgMlcewtZo8J7N/2xpNmtUbdtgSW8vQ==
X-Received: by 2002:a7b:c410:0:b0:3a0:2d7d:732a with SMTP id k16-20020a7bc410000000b003a02d7d732amr6819484wmi.113.1657229469856;
        Thu, 07 Jul 2022 14:31:09 -0700 (PDT)
Received: from [192.168.1.18] (10.pool85-50-98.dynamic.orange.es. [85.50.98.10])
        by smtp.gmail.com with ESMTPSA id x2-20020adfdd82000000b0021d62e30a62sm15210806wrl.50.2022.07.07.14.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 14:31:09 -0700 (PDT)
Message-ID: <872f2a21-7bf7-0cc3-298f-f817429f6997@fortu.net>
Date:   Thu, 7 Jul 2022 23:30:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH AUTOSEL 5.17 42/43] Revert "ACPI: Pass the same
 capabilities to the _OSC regardless of the query flag"
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mario Limonciello <Mario.Limonciello@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        rafael@kernel.org, linux-acpi@vger.kernel.org
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-42-sashal@kernel.org>
From:   Tom Crossland <tomc@fortu.net>
In-Reply-To: <20220328111828.1554086-42-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, I'm observing the issue described here which I think is due to a 
recent regression:

https://github.com/intel/linux-intel-lts/issues/22

sudo dmesg -t -l err

ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC], 
AE_NOT_FOUND (20211217/psargs-330)
ACPI Error: Aborting method \_PR.PR01._CPC due to previous error 
(AE_NOT_FOUND) (20211217/psparse-529)
ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC], 
AE_NOT_FOUND (20211217/psargs-330)
ACPI Error: Aborting method \_PR.PR02._CPC due to previous error 
(AE_NOT_FOUND) (20211217/psparse-529)
ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC], 
AE_NOT_FOUND (20211217/psargs-330)
ACPI Error: Aborting method \_PR.PR03._CPC due to previous error 
(AE_NOT_FOUND) (20211217/psparse-529)

System:
   Kernel: 5.18.9-arch1-1 arch: x86_64 bits: 64 compiler: gcc v: 12.1.0
     parameters: initrd=\intel-ucode.img initrd=\initramfs-linux.img
     root=xxx intel_iommu=on iommu=pt
  Machine:
   Type: Desktop Mobo: Intel model: NUC7i5BNB v: J31144-304 serial: <filter>
     UEFI: Intel v: BNKBL357.86A.0088.2022.0125.1102 date: 01/25/2022

I hope this is the correct forum to report the issue. Apologies if not.

On 28/03/2022 13.18, Sasha Levin wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>
> [ Upstream commit 2ca8e6285250c07a2e5a22ecbfd59b5a4ef73484 ]
>
> Revert commit 159d8c274fd9 ("ACPI: Pass the same capabilities to the
> _OSC regardless of the query flag") which caused legitimate usage
> scenarios (when the platform firmware does not want the OS to control
> certain platform features controlled by the system bus scope _OSC) to
> break and was misguided by some misleading language in the _OSC
> definition in the ACPI specification (in particular, Section 6.2.11.1.3
> "Sequence of _OSC Calls" that contradicts other perts of the _OSC
> definition).
>
> Link: https://lore.kernel.org/linux-acpi/CAJZ5v0iStA0JmO0H3z+VgQsVuQONVjKPpw0F5HKfiq=Gb6B5yw@mail.gmail.com
> Reported-by: Mario Limonciello <Mario.Limonciello@amd.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Tested-by: Mario Limonciello <mario.limonciello@amd.com>
> Acked-by: Huang Rui <ray.huang@amd.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/acpi/bus.c | 27 +++++++++++++++++++--------
>   1 file changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 07f604832fd6..079b952ab59f 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -332,21 +332,32 @@ static void acpi_bus_osc_negotiate_platform_control(void)
>   	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
>   		return;
>   
> -	kfree(context.ret.pointer);
> +	capbuf_ret = context.ret.pointer;
> +	if (context.ret.length <= OSC_SUPPORT_DWORD) {
> +		kfree(context.ret.pointer);
> +		return;
> +	}
>   
> -	/* Now run _OSC again with query flag clear */
> +	/*
> +	 * Now run _OSC again with query flag clear and with the caps
> +	 * supported by both the OS and the platform.
> +	 */
>   	capbuf[OSC_QUERY_DWORD] = 0;
> +	capbuf[OSC_SUPPORT_DWORD] = capbuf_ret[OSC_SUPPORT_DWORD];
> +	kfree(context.ret.pointer);
>   
>   	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
>   		return;
>   
>   	capbuf_ret = context.ret.pointer;
> -	osc_sb_apei_support_acked =
> -		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
> -	osc_pc_lpi_support_confirmed =
> -		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
> -	osc_sb_native_usb4_support_confirmed =
> -		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
> +	if (context.ret.length > OSC_SUPPORT_DWORD) {
> +		osc_sb_apei_support_acked =
> +			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
> +		osc_pc_lpi_support_confirmed =
> +			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
> +		osc_sb_native_usb4_support_confirmed =
> +			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
> +	}
>   
>   	kfree(context.ret.pointer);
>   }
