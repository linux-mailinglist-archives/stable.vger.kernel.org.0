Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E728311612
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBEWuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhBENGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 08:06:07 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FA0C061786
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 05:05:14 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id r20so4870482qtm.3
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 05:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KoL6M6l9RNM0EewcRBWafbibsTr1Ax1UE+SarTxAsR8=;
        b=n50KaEWl+Syw5ubG+Z6GsS620BPX3hwGK3sN1D08MwSLO2q/9bhljMmAGMUvS7p9yE
         6SShdGHOWe9d2sb9xCdcL2rJyMj7d54EwHokStdaAEUOagNV6R40ZVjvR0SbskXfXf/t
         r3UQFXB9s1TUasODXM7G9gty3ZLZmV7HswQyTbDFTP9RPL34cXZJ5qQQGDKLrkdlG3ys
         hJdGM9ZFefNM1W5R89HEX97qsZV3VrztTISiQJNYETK0zP8kjvvI/kceil6UE+pWZWHA
         EjgaovnDf1ggNbbOez53uyb+ztC2seQBCLyWxVgYRSiwUWu7664xkk7r59LIvVhisONZ
         p7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KoL6M6l9RNM0EewcRBWafbibsTr1Ax1UE+SarTxAsR8=;
        b=SnwzRj9TMzn19Mi8+2shnHY7wj0GccRTv7v9GAxVfc7LBa/b+iVOOffsY/OIWu1BWY
         v2m518msnaNiwh0/TMxONPaXUYu70MFItelRQVtRKqqx0ThqDK1Qk5J/jLRihqUTTD8v
         20wVwQrBFyWkNiTKLs2K75YsVIcxQEP0Zc/wM4bqPCq+jOunVlYW/GWdpGE1dY26yMtF
         JvFj67kw4tdBbHFEkdZh/idmh4VtfjSOBnLSy02V3zV6xmPtCih1vBb1Lou9JYgXWm0E
         AFNOkvJshwzvQfYqNzCDaLExU+1gCNI26c9rjFd4V4z19piYtWnvTS2FDfn9BdpUU+KM
         gT+w==
X-Gm-Message-State: AOAM532vD4ITuDYhMH+Mb8nAkEMwCrb88dyWfVZN3Xksb2cHSbbV3Pyq
        ttRr+NfUmB/80FuVKi4VuTroh9DvK875aTJb
X-Google-Smtp-Source: ABdhPJyrPaatnEF3EQoyj/Wy2PZ1KQ7pMnWbi0KMDU4EU41/Go77mUQxNQU85CDc37SPJ/Q6Bs9lIw==
X-Received: by 2002:aed:3145:: with SMTP id 63mr4062664qtg.189.1612530312637;
        Fri, 05 Feb 2021 05:05:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id e7sm7783668qtj.48.2021.02.05.05.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 05:05:12 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l80nP-003pgK-Ip; Fri, 05 Feb 2021 09:05:11 -0400
Date:   Fri, 5 Feb 2021 09:05:11 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
Message-ID: <20210205130511.GI4718@ziepe.ca>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 12:50:42AM +0100, Lino Sanfilippo wrote:
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> 
> The following sequence of operations results in a refcount warning:
> 
> 1. Open device /dev/tpmrm
> 2. Remove module tpm_tis_spi
> 3. Write a TPM command to the file descriptor opened at step 1.
> 
> WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
> refcount_t: addition on 0; use-after-free.
> Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
> sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
> brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
> raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
> snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
> CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
> Hardware name: BCM2711
> [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
> [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
> [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
> [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
> [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
> [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
> [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
> [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
> [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
> [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
> Exception stack(0xc226bfa8 to 0xc226bff0)
> bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
> bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
> bfe0: 0000006c beafe648 0001056c b6eb6944
> 
> The reason for this warning is the attempt to get the chip->dev reference
> in tpm_common_write() although the reference counter is already zero.


> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
> extra reference used to prevent a premature zero counter is never taken,
> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
> 
> Fix this by removing the flag condition.
> 
> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> already introduced function tpm_devs_release() to release the extra
> reference but did not implement the required put on chip->devs that results
> in the call of this function.

Seems wonky, the devs is just supposed to be a side thing, nothing
should be using it as a primary reference count for a tpm.

The bug here is only that tpm_common_open() did not get a kref on the
chip before putting it in priv and linking it to the fd. See the
comment before tpm_try_get_ops() indicating the caller must already
have taken care to ensure the chip is valid.

This should be all you need to fix the oops:

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index 1784530b8387bb..1b738dca7fffb5 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -105,6 +105,7 @@ static void tpm_timeout_work(struct work_struct *work)
 void tpm_common_open(struct file *file, struct tpm_chip *chip,
                     struct file_priv *priv, struct tpm_space *space)
 {
+       get_device(&priv->chip.dev);
        priv->chip = chip;
        priv->space = space;
        priv->response_read = true;
@@ -261,6 +262,7 @@ void tpm_common_release(struct file *file, struct file_priv *priv)
        flush_work(&priv->timeout_work);
        file->private_data = NULL;
        priv->response_length = 0;
+       put_device(&chip->dev);
 }
 
 int __init tpm_dev_common_init(void)

> Fix this also by installing an action handler that puts chip->devs as soon
> as the chip is unregistered.
> 
> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>  drivers/char/tpm/tpm-chip.c       | 18 +++++++++++++++---
>  drivers/char/tpm/tpm_ftpm_tee.c   |  2 ++
>  drivers/char/tpm/tpm_vtpm_proxy.c |  1 +
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index ddaeceb..3ace199 100644
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -360,8 +360,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	 * while cdevs is in use.  The corresponding put
>  	 * is in the tpm_devs_release (TPM2 only)
>  	 */
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		get_device(&chip->dev);
> +	get_device(&chip->dev);
>  
>  	if (chip->dev_num == 0)
>  		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
> @@ -422,8 +421,21 @@ struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
>  	rc = devm_add_action_or_reset(pdev,
>  				      (void (*)(void *)) put_device,
>  				      &chip->dev);
> -	if (rc)
> +	if (rc) {
> +		put_device(&chip->devs);
>  		return ERR_PTR(rc);

This isn't right read what 'or_reset' does

Jason
