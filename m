Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B0E4C8BD4
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 13:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiCAMmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 07:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiCAMmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 07:42:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E322983B;
        Tue,  1 Mar 2022 04:41:58 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2219icfl019215;
        Tue, 1 Mar 2022 12:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KuocmOSmhNu5ZyWz0bHoPnTEDpzN9+zPIobxaoBh7RY=;
 b=oq45qrNcTaIIVoGOJDhR/mQv9dr0YY+MCMGPkiUGb3Vpm94HMqOud8tHMHM/+pA+BmZ5
 KPBBSaO8prAhxxb6oTUN9cfMJ14a/T/n2pYoFiii+ePYTitGfIJdbqnoxgIATK5hCwCI
 7i2OgN77EFUNvD8vo0DxtimALR8tjM3anZGlVj1aFbelSSyAm+JiWcfhZGpi+mcjMVNn
 eLwOaHZroDcB2iGfHBwpOEf7PdVQH8DE8Do5EWhtS6kPCZyE3zmMv0LF3SIKD4fTZdQt
 tCsgxSbkKhAKEVn8lYgsWbMbAFr6R3j8mNeQOhPYNmbBDwv7mgPpvZ7mNaXF8DUVstA3 LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehh4h3t9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 12:36:38 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 221CIDhx010331;
        Tue, 1 Mar 2022 12:36:37 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehh4h3t9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 12:36:37 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 221CXRAP028187;
        Tue, 1 Mar 2022 12:36:36 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 3efbu9vj9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 12:36:36 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 221CaZCH30212456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Mar 2022 12:36:35 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DC5F112064;
        Tue,  1 Mar 2022 12:36:35 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3E85112063;
        Tue,  1 Mar 2022 12:36:34 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  1 Mar 2022 12:36:34 +0000 (GMT)
Message-ID: <99eff469-3faf-1e9a-9ad9-e087aeafc301@linux.ibm.com>
Date:   Tue, 1 Mar 2022 07:36:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v8 1/1] tpm: fix reference counting for struct tpm_chip
Content-Language: en-US
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org, jgg@ziepe.ca
Cc:     stefanb@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com,
        David.Laight@ACULAB.COM, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.rosenberger@kunbus.com,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <20220301022108.30310-1-LinoSanfilippo@gmx.de>
 <20220301022108.30310-2-LinoSanfilippo@gmx.de>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220301022108.30310-2-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X4Nu4BnQu-ZgguosY15w4kDayIH12KqR
X-Proofpoint-ORIG-GUID: Uypyva6UHZ5BIbPlcoP4z6YZMQ3G47pB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-01_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 clxscore=1011 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/28/22 21:21, Lino Sanfilippo wrote:
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>
> The following sequence of operations results in a refcount warning:
>
> 1. Open device /dev/tpmrm.
> 2. Remove module tpm_tis_spi.
> 3. Write a TPM command to the file descriptor opened at step 1.
>
> ------------[ cut here ]------------
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
> ---[ end trace d4b8409def9b8b1f ]---
>
> The reason for this warning is the attempt to get the chip->dev reference
> in tpm_common_write() although the reference counter is already zero.
>
> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
> extra reference used to prevent a premature zero counter is never taken,
> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
>
> Fix this by moving the TPM 2 character device handling from
> tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
> in time when the flag has been set in case of TPM2.
>
> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> already introduced function tpm_devs_release() to release the extra
> reference but did not implement the required put on chip->devs that results
> in the call of this function.
>
> Fix this by putting chip->devs in tpm_chip_unregister().
>
> Finally move the new implementation for the TPM 2 handling into a new
> function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
> good case and error cases.
>
> Cc: stable@vger.kernel.org
> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
> Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>

Tested-by: Stefan Berger <stefanb@linux.ibm.com>


> ---
>   drivers/char/tpm/tpm-chip.c   | 48 +++++++-----------------------
>   drivers/char/tpm/tpm.h        |  1 +
>   drivers/char/tpm/tpm2-space.c | 55 +++++++++++++++++++++++++++++++++++
>   3 files changed, 66 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index b009e7479b70..06beee4da808 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -274,14 +274,6 @@ static void tpm_dev_release(struct device *dev)
>   	kfree(chip);
>   }
>   
> -static void tpm_devs_release(struct device *dev)
> -{
> -	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
> -
> -	/* release the master device reference */
> -	put_device(&chip->dev);
> -}
> -
>   /**
>    * tpm_class_shutdown() - prepare the TPM device for loss of power.
>    * @dev: device to which the chip is associated.
> @@ -344,7 +336,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>   	chip->dev_num = rc;
>   
>   	device_initialize(&chip->dev);
> -	device_initialize(&chip->devs);
>   
>   	chip->dev.class = tpm_class;
>   	chip->dev.class->shutdown_pre = tpm_class_shutdown;
> @@ -352,29 +343,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>   	chip->dev.parent = pdev;
>   	chip->dev.groups = chip->groups;
>   
> -	chip->devs.parent = pdev;
> -	chip->devs.class = tpmrm_class;
> -	chip->devs.release = tpm_devs_release;
> -	/* get extra reference on main device to hold on
> -	 * behalf of devs.  This holds the chip structure
> -	 * while cdevs is in use.  The corresponding put
> -	 * is in the tpm_devs_release (TPM2 only)
> -	 */
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		get_device(&chip->dev);
> -
>   	if (chip->dev_num == 0)
>   		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
>   	else
>   		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
>   
> -	chip->devs.devt =
> -		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> -
>   	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
> -	if (rc)
> -		goto out;
> -	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
>   	if (rc)
>   		goto out;
>   
> @@ -382,9 +356,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>   		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
>   
>   	cdev_init(&chip->cdev, &tpm_fops);
> -	cdev_init(&chip->cdevs, &tpmrm_fops);
>   	chip->cdev.owner = THIS_MODULE;
> -	chip->cdevs.owner = THIS_MODULE;
>   
>   	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
>   	if (rc) {
> @@ -396,7 +368,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>   	return chip;
>   
>   out:
> -	put_device(&chip->devs);
>   	put_device(&chip->dev);
>   	return ERR_PTR(rc);
>   }
> @@ -445,14 +416,9 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>   	}
>   
>   	if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip)) {
> -		rc = cdev_device_add(&chip->cdevs, &chip->devs);
> -		if (rc) {
> -			dev_err(&chip->devs,
> -				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> -				dev_name(&chip->devs), MAJOR(chip->devs.devt),
> -				MINOR(chip->devs.devt), rc);
> -			return rc;
> -		}
> +		rc = tpm_devs_add(chip);
> +		if (rc)
> +			goto err_del_cdev;
>   	}
>   
>   	/* Make the chip available. */
> @@ -460,6 +426,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>   	idr_replace(&dev_nums_idr, chip, chip->dev_num);
>   	mutex_unlock(&idr_lock);
>   
> +	return 0;
> +
> +err_del_cdev:
> +	cdev_device_del(&chip->cdev, &chip->dev);
>   	return rc;
>   }
>   
> @@ -653,8 +623,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>   	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM) && !tpm_is_firmware_upgrade(chip))
>   		hwrng_unregister(&chip->hwrng);
>   	tpm_bios_log_teardown(chip);
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip))
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip)) {
>   		cdev_device_del(&chip->cdevs, &chip->devs);
> +		put_device(&chip->devs);
> +	}
>   	tpm_del_char_device(chip);
>   }
>   EXPORT_SYMBOL_GPL(tpm_chip_unregister);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 283f78211c3a..b7070ea9212a 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -234,6 +234,7 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
>   		       size_t cmdsiz);
>   int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space, void *buf,
>   		      size_t *bufsiz);
> +int tpm_devs_add(struct tpm_chip *chip);
>   
>   void tpm_bios_log_setup(struct tpm_chip *chip);
>   void tpm_bios_log_teardown(struct tpm_chip *chip);
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index 97e916856cf3..bd9fbd32bc01 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -574,3 +574,58 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>   	dev_err(&chip->dev, "%s: error %d\n", __func__, rc);
>   	return rc;
>   }
> +
> +/*
> + * Put the reference to the main device.
> + */
> +static void tpm_devs_release(struct device *dev)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
> +
> +	/* release the master device reference */
> +	put_device(&chip->dev);
> +}
> +
> +/*
> + * Add a device file to expose TPM spaces. Also take a reference to the
> + * main device.
> + */
> +int tpm_devs_add(struct tpm_chip *chip)
> +{
> +	int rc;
> +
> +	device_initialize(&chip->devs);
> +	chip->devs.parent = chip->dev.parent;
> +	chip->devs.class = tpmrm_class;
> +
> +	/*
> +	 * Get extra reference on main device to hold on behalf of devs.
> +	 * This holds the chip structure while cdevs is in use. The
> +	 * corresponding put is in the tpm_devs_release.
> +	 */
> +	get_device(&chip->dev);
> +	chip->devs.release = tpm_devs_release;
> +	chip->devs.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> +	cdev_init(&chip->cdevs, &tpmrm_fops);
> +	chip->cdevs.owner = THIS_MODULE;
> +
> +	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> +	if (rc)
> +		goto err_put_devs;
> +
> +	rc = cdev_device_add(&chip->cdevs, &chip->devs);
> +	if (rc) {
> +		dev_err(&chip->devs,
> +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> +			dev_name(&chip->devs), MAJOR(chip->devs.devt),
> +			MINOR(chip->devs.devt), rc);
> +		goto err_put_devs;
> +	}
> +
> +	return 0;
> +
> +err_put_devs:
> +	put_device(&chip->devs);
> +
> +	return rc;
> +}
