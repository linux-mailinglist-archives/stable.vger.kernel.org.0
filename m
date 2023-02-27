Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D496A454F
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 15:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjB0O4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 09:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjB0O4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 09:56:04 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2434D22037;
        Mon, 27 Feb 2023 06:55:57 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id r4so4078734ila.2;
        Mon, 27 Feb 2023 06:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fIZrbcYhhaV6jhmoNmRMCVDORccR0aGA9PJtZWw33Mk=;
        b=jhlY8WbJ1Bl5eCLzE+nliO5pdQxyuMSVerLIuOI1qp1L8HyFsRnC5awUHkd73MkIH9
         pXFmeVPTTkRncoEuJPy0axMCtPwd3U5/O0CA3WNr7qrdTjwW+cTbDCHCHpz5qdYgJFUf
         6JhtEaRtbyOiVfOjqjlTwkPC5AImqdIpS6G4uknMj+wipZ1KSHUEjmfkswY3TIpaK61+
         FQRayGCdnDPDBp4nDeoNw9vsfgR6F+HVssORjoRP4s3hn67B5FEOPSvh9tUyrg0PQ4i3
         YpNkyY6UhCnXY5I+n+a+o/qPW7FA59KrBJO9WiOTffx9YQUF8QpL1YavZrmmm7lTdKSZ
         OBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fIZrbcYhhaV6jhmoNmRMCVDORccR0aGA9PJtZWw33Mk=;
        b=qDFwN7cwTjmmvH3WDqhvEAZZz3ajlQkXtlyBzMqs1goiljpMIOA4Vg2LEbtynr3gPF
         ymAEHAdJ7S47ErfHPDOiQ47P53CshKvc10X4dj6jzGdvIVWBBPGEeAYUNtlXu1c6Fe4F
         8OshIsHKNi+5jyezPZZeS++SFrzRbXksM7n8OSDw0mmr/3v84cHBb+ymaRxn41VhpwpS
         MZdZ25NfZ7KAgPUaPlY/Sx0M67RWAc7lZ2OIuywUpfrP+JLM90Yq08BK+NUs5s/zBAxG
         0CMHMjgyzdE4QkUfoyMYI5oUvMuvBOskXQtcTn+HKnNIe7k9pFU7KJgEz/YHaGpHCWE4
         ioUA==
X-Gm-Message-State: AO0yUKVjfSvk8N2iasvgY8SqieJ5edT3Qw1lC9WaR73Jw2qutnwNvxKg
        WU62AiOrcs6c0MmTslDG8xPuxeY9+bA=
X-Google-Smtp-Source: AK7set+NBlgXCYY+OUn3mJlYLEJ2ojN3RdiwQEj5I+KV3052OBljjjTdo4tMNItMpSk5XDC0Z0y5Dw==
X-Received: by 2002:a05:6e02:152f:b0:316:e64b:2367 with SMTP id i15-20020a056e02152f00b00316e64b2367mr17776530ilu.8.1677509756379;
        Mon, 27 Feb 2023 06:55:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i23-20020a02ca17000000b003eea9880111sm298109jak.163.2023.02.27.06.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 06:55:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 27 Feb 2023 06:55:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <20230227145554.GA3714281@roeck-us.net>
References: <20230220180729.23862-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220180729.23862-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 12:07:28PM -0600, Mario Limonciello wrote:
> AMD has issued an advisory indicating that having fTPM enabled in
> BIOS can cause "stuttering" in the OS.  This issue has been fixed
> in newer versions of the fTPM firmware, but it's up to system
> designers to decide whether to distribute it.
> 
> This issue has existed for a while, but is more prevalent starting
> with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
> hwrng kthread also for untrusted sources") started to use the fTPM
> for hwrng by default. However, all uses of /dev/hwrng result in
> unacceptable stuttering.
> 
> So, simply disable registration of the defective hwrng when detecting
> these faulty fTPM versions.  As this is caused by faulty firmware, it
> is plausible that such a problem could also be reproduced by other TPM
> interactions, but this hasn't been shown by any user's testing or reports.
> 
> It is hypothesized to be triggered more frequently by the use of the RNG
> because userspace software will fetch random numbers regularly.
> 
> Intentionally continue to register other TPM functionality so that users
> that rely upon PCR measurements or any storage of data will still have
> access to it.  If it's found later that another TPM functionality is
> exacerbating this problem a module parameter it can be turned off entirely
> and a module parameter can be introduced to allow users who rely upon
> fTPM functionality to turn it on even though this problem is present.
> 
> Link: https://www.amd.com/en/support/kb/faq/pa-410
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
> Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
> Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
> Cc: stable@vger.kernel.org
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Thorsten Leemhuis <regressions@leemhuis.info>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v1->v2:
>  * Minor style from Jarkko's feedback
>  * Move comment above function
>  * Explain further in commit message
> ---
>  drivers/char/tpm/tpm-chip.c | 61 ++++++++++++++++++++++++++++++-
>  drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 133 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 741d8f3e8fb3..1b066d7a6e21 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -512,6 +512,64 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
>  	return 0;
>  }
>  
> +/*
> + * Some AMD fTPM versions may cause stutter
> + * https://www.amd.com/en/support/kb/faq/pa-410
> + *
> + * Fixes are available in two series of fTPM firmware:
> + * 6.x.y.z series: 6.0.18.6 +
> + * 3.x.y.z series: 3.57.y.5 +
> + */
> +static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
> +{
> +	u32 val1, val2;
> +	u64 version;
> +	int ret;
> +
> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
> +		return false;
> +
> +	ret = tpm_request_locality(chip);
> +	if (ret)
> +		return false;
> +
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
> +	if (ret)
> +		goto release;
> +	if (val1 != 0x414D4400U /* AMD */) {
> +		ret = -ENODEV;
> +		goto release;
> +	}
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
> +	if (ret)
> +		goto release;
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
> +	if (ret)
> +		goto release;

This goto is unnecessary.

> +
> +release:
> +	tpm_relinquish_locality(chip);
> +
> +	if (ret)
> +		return false;
> +
> +	version = ((u64)val1 << 32) | val2;
> +	if ((version >> 48) == 6) {
> +		if (version >= 0x0006000000180006ULL)
> +			return false;
> +	} else if ((version >> 48) == 3) {
> +		if (version >= 0x0003005700000005ULL)
> +			return false;
> +	} else
> +		return false;

checkpatch:

CHECK: braces {} should be used on all arms of this statement
#200: FILE: drivers/char/tpm/tpm-chip.c:557:
+	if ((version >> 48) == 6) {
[...]
+	} else if ((version >> 48) == 3) {
[...]
+	} else
[...]

> +
> +	dev_warn(&chip->dev,
> +		 "AMD fTPM version 0x%llx causes system stutter; hwrng disabled\n",
> +		 version);
> +
> +	return true;
> +}
> +
>  static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  {
>  	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
> @@ -521,7 +579,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  
>  static int tpm_add_hwrng(struct tpm_chip *chip)
>  {
> -	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
> +	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
> +	    tpm_amd_is_rng_defective(chip))
>  		return 0;
>  
>  	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 24ee4e1cc452..830014a26609 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -150,6 +150,79 @@ enum tpm_sub_capabilities {
>  	TPM_CAP_PROP_TIS_DURATION = 0x120,
>  };
>  
> +enum tpm2_pt_props {
> +	TPM2_PT_NONE = 0x00000000,
> +	TPM2_PT_GROUP = 0x00000100,
> +	TPM2_PT_FIXED = TPM2_PT_GROUP * 1,
> +	TPM2_PT_FAMILY_INDICATOR = TPM2_PT_FIXED + 0,
> +	TPM2_PT_LEVEL = TPM2_PT_FIXED + 1,
> +	TPM2_PT_REVISION = TPM2_PT_FIXED + 2,
> +	TPM2_PT_DAY_OF_YEAR = TPM2_PT_FIXED + 3,
> +	TPM2_PT_YEAR = TPM2_PT_FIXED + 4,
> +	TPM2_PT_MANUFACTURER = TPM2_PT_FIXED + 5,
> +	TPM2_PT_VENDOR_STRING_1 = TPM2_PT_FIXED + 6,
> +	TPM2_PT_VENDOR_STRING_2 = TPM2_PT_FIXED + 7,
> +	TPM2_PT_VENDOR_STRING_3 = TPM2_PT_FIXED + 8,
> +	TPM2_PT_VENDOR_STRING_4 = TPM2_PT_FIXED + 9,
> +	TPM2_PT_VENDOR_TPM_TYPE = TPM2_PT_FIXED + 10,
> +	TPM2_PT_FIRMWARE_VERSION_1 = TPM2_PT_FIXED + 11,
> +	TPM2_PT_FIRMWARE_VERSION_2 = TPM2_PT_FIXED + 12,
> +	TPM2_PT_INPUT_BUFFER = TPM2_PT_FIXED + 13,
> +	TPM2_PT_HR_TRANSIENT_MIN = TPM2_PT_FIXED + 14,
> +	TPM2_PT_HR_PERSISTENT_MIN = TPM2_PT_FIXED + 15,
> +	TPM2_PT_HR_LOADED_MIN = TPM2_PT_FIXED + 16,
> +	TPM2_PT_ACTIVE_SESSIONS_MAX = TPM2_PT_FIXED + 17,
> +	TPM2_PT_PCR_COUNT = TPM2_PT_FIXED + 18,
> +	TPM2_PT_PCR_SELECT_MIN = TPM2_PT_FIXED + 19,
> +	TPM2_PT_CONTEXT_GAP_MAX = TPM2_PT_FIXED + 20,
> +	TPM2_PT_NV_COUNTERS_MAX = TPM2_PT_FIXED + 22,
> +	TPM2_PT_NV_INDEX_MAX = TPM2_PT_FIXED + 23,
> +	TPM2_PT_MEMORY = TPM2_PT_FIXED + 24,
> +	TPM2_PT_CLOCK_UPDATE = TPM2_PT_FIXED + 25,
> +	TPM2_PT_CONTEXT_HASH = TPM2_PT_FIXED + 26,
> +	TPM2_PT_CONTEXT_SYM = TPM2_PT_FIXED + 27,
> +	TPM2_PT_CONTEXT_SYM_SIZE = TPM2_PT_FIXED + 28,
> +	TPM2_PT_ORDERLY_COUNT = TPM2_PT_FIXED + 29,
> +	TPM2_PT_MAX_COMMAND_SIZE = TPM2_PT_FIXED + 30,
> +	TPM2_PT_MAX_RESPONSE_SIZE = TPM2_PT_FIXED + 31,
> +	TPM2_PT_MAX_DIGEST = TPM2_PT_FIXED + 32,
> +	TPM2_PT_MAX_OBJECT_CONTEXT = TPM2_PT_FIXED + 33,
> +	TPM2_PT_MAX_SESSION_CONTEXT = TPM2_PT_FIXED + 34,
> +	TPM2_PT_PS_FAMILY_INDICATOR = TPM2_PT_FIXED + 35,
> +	TPM2_PT_PS_LEVEL = TPM2_PT_FIXED + 36,
> +	TPM2_PT_PS_REVISION = TPM2_PT_FIXED + 37,
> +	TPM2_PT_PS_DAY_OF_YEAR = TPM2_PT_FIXED + 38,
> +	TPM2_PT_PS_YEAR = TPM2_PT_FIXED + 39,
> +	TPM2_PT_SPLIT_MAX = TPM2_PT_FIXED + 40,
> +	TPM2_PT_TOTAL_COMMANDS = TPM2_PT_FIXED + 41,
> +	TPM2_PT_LIBRARY_COMMANDS = TPM2_PT_FIXED + 42,
> +	TPM2_PT_VENDOR_COMMANDS = TPM2_PT_FIXED + 43,
> +	TPM2_PT_NV_BUFFER_MAX = TPM2_PT_FIXED + 44,
> +	TPM2_PT_MODES = TPM2_PT_FIXED + 45,
> +	TPM2_PT_MAX_CAP_BUFFER = TPM2_PT_FIXED + 46,
> +	TPM2_PT_VAR = TPM2_PT_GROUP * 2,
> +	TPM2_PT_PERMANENT = TPM2_PT_VAR + 0,
> +	TPM2_PT_STARTUP_CLEAR = TPM2_PT_VAR + 1,
> +	TPM2_PT_HR_NV_INDEX = TPM2_PT_VAR + 2,
> +	TPM2_PT_HR_LOADED = TPM2_PT_VAR + 3,
> +	TPM2_PT_HR_LOADED_AVAIL = TPM2_PT_VAR + 4,
> +	TPM2_PT_HR_ACTIVE = TPM2_PT_VAR + 5,
> +	TPM2_PT_HR_ACTIVE_AVAIL = TPM2_PT_VAR + 6,
> +	TPM2_PT_HR_TRANSIENT_AVAIL = TPM2_PT_VAR + 7,
> +	TPM2_PT_HR_PERSISTENT = TPM2_PT_VAR + 8,
> +	TPM2_PT_HR_PERSISTENT_AVAIL = TPM2_PT_VAR + 9,
> +	TPM2_PT_NV_COUNTERS = TPM2_PT_VAR + 10,
> +	TPM2_PT_NV_COUNTERS_AVAIL = TPM2_PT_VAR + 11,
> +	TPM2_PT_ALGORITHM_SET = TPM2_PT_VAR + 12,
> +	TPM2_PT_LOADED_CURVES = TPM2_PT_VAR + 13,
> +	TPM2_PT_LOCKOUT_COUNTER = TPM2_PT_VAR + 14,
> +	TPM2_PT_MAX_AUTH_FAIL = TPM2_PT_VAR + 15,
> +	TPM2_PT_LOCKOUT_INTERVAL = TPM2_PT_VAR + 16,
> +	TPM2_PT_LOCKOUT_RECOVERY = TPM2_PT_VAR + 17,
> +	TPM2_PT_NV_WRITE_RECOVERY = TPM2_PT_VAR + 18,
> +	TPM2_PT_AUDIT_COUNTER_0 = TPM2_PT_VAR + 19,
> +	TPM2_PT_AUDIT_COUNTER_1 = TPM2_PT_VAR + 20,
> +};
>  
>  /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
>   * bytes, but 128 is still a relatively large number of random bytes and
> -- 
> 2.34.1
> 
