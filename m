Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586664CDCA0
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 19:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbiCDSfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 13:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiCDSfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 13:35:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97108159EAA;
        Fri,  4 Mar 2022 10:34:22 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224HoA2m010670;
        Fri, 4 Mar 2022 18:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YdxrP6ISC8fN7Erz3D5Qk28mXkYrjLG3b0dWOhyh47I=;
 b=j3HWKOzMoAMyYUyCsdnMfmtCkQQ83OSSRgy54uxWiTQ9aFwLkxnkwjtE7eDm1Oh5VeE/
 obG7JavQAHEcD5CZKUezTRj+lehN/VZlkBLmYkTlGE3cEs4qJU+0Pj3A/O2cZSU1+hBI
 y5qFSfH9ufsOZF3+IH4B9EUwlL084gQRzMjUKrF5SCBN5JmTZtN4EAZsd9xfg5sS8JT9
 28xQRwcvIFygtmKjeytROQ/8c6UQSkjDa9W9mX4YkkliRJkqaGDSmGmnzOzzXHMiS9Y5
 VnG95AZVmmkoidJhOrCY9uWtRCO2oewOI0G2oZoOmrfOf9ih/RFbBOolC3Mg8q5IMww+ nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekqgsgte0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 18:34:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224IPilb006351;
        Fri, 4 Mar 2022 18:34:12 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekqgsgtds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 18:34:12 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224IHXxS006837;
        Fri, 4 Mar 2022 18:34:11 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04wdc.us.ibm.com with ESMTP id 3ek4kbemee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 18:34:11 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224IY9nj40632750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 18:34:09 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8544811206D;
        Fri,  4 Mar 2022 18:34:09 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E23D112061;
        Fri,  4 Mar 2022 18:34:06 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 18:34:06 +0000 (GMT)
Message-ID: <8b594101-f676-ca9d-ebe5-337470a3de80@linux.ibm.com>
Date:   Fri, 4 Mar 2022 13:34:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v9 1/1] tpm: fix reference counting for struct tpm_chip
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@aculab.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <20220302094353.3465-1-LinoSanfilippo@gmx.de>
 <20220302094353.3465-2-LinoSanfilippo@gmx.de> <YiFFCP3/KVl6uo3e@iki.fi>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <YiFFCP3/KVl6uo3e@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h9i3nsrFsvdPNGloOfsLgWKeC3o-gTFH
X-Proofpoint-ORIG-GUID: zXGS_d4Df-eO0cVUWYOjwRqRTi2R26y6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/3/22 17:45, Jarkko Sakkinen wrote:
> On Wed, Mar 02, 2022 at 10:43:53AM +0100, Lino Sanfilippo wrote:
>> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>>
>> The following sequence of operations results in a refcount warning:
>>
>> 1. Open device /dev/tpmrm.
>> 2. Remove module tpm_tis_spi.
>> 3. Write a TPM command to the file descriptor opened at step 1.
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
>> refcount_t: addition on 0; use-after-free.
>> Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
>> sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
>> brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
>> raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
>> snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
>> CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
>> Hardware name: BCM2711
>> [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
>> [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
>> [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
>> [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
>> [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
>> [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
>> [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
>> [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
>> [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
>> [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
>> Exception stack(0xc226bfa8 to 0xc226bff0)
>> bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
>> bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
>> bfe0: 0000006c beafe648 0001056c b6eb6944
>> ---[ end trace d4b8409def9b8b1f ]---
>>
>> The reason for this warning is the attempt to get the chip->dev reference
>> in tpm_common_write() although the reference counter is already zero.
>>
>> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
>> extra reference used to prevent a premature zero counter is never taken,
>> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
>>
>> Fix this by moving the TPM 2 character device handling from
>> tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
>> in time when the flag has been set in case of TPM2.
>>
>> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
>> already introduced function tpm_devs_release() to release the extra
>> reference but did not implement the required put on chip->devs that results
>> in the call of this function.
>>
>> Fix this by putting chip->devs in tpm_chip_unregister().
>>
>> Finally move the new implementation for the TPM 2 handling into a new
>> function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
>> good case and error cases.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
>> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
>> Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
>> Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>> ---
>>   drivers/char/tpm/tpm-chip.c   | 46 +++++--------------------
>>   drivers/char/tpm/tpm.h        |  2 ++
>>   drivers/char/tpm/tpm2-space.c | 65 +++++++++++++++++++++++++++++++++++
>>   3 files changed, 75 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index b009e7479b70..783d65fc71f0 100644
>> --- a/drivers/char/tpm/tpm-chip.c
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -274,14 +274,6 @@ static void tpm_dev_release(struct device *dev)
>>   	kfree(chip);
>>   }
>>   
>> -static void tpm_devs_release(struct device *dev)
>> -{
>> -	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
>> -
>> -	/* release the master device reference */
>> -	put_device(&chip->dev);
>> -}
>> -
>>   /**
>>    * tpm_class_shutdown() - prepare the TPM device for loss of power.
>>    * @dev: device to which the chip is associated.
>> @@ -344,7 +336,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>>   	chip->dev_num = rc;
>>   
>>   	device_initialize(&chip->dev);
>> -	device_initialize(&chip->devs);
>>   
>>   	chip->dev.class = tpm_class;
>>   	chip->dev.class->shutdown_pre = tpm_class_shutdown;
>> @@ -352,29 +343,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>>   	chip->dev.parent = pdev;
>>   	chip->dev.groups = chip->groups;
>>   
>> -	chip->devs.parent = pdev;
>> -	chip->devs.class = tpmrm_class;
>> -	chip->devs.release = tpm_devs_release;
>> -	/* get extra reference on main device to hold on
>> -	 * behalf of devs.  This holds the chip structure
>> -	 * while cdevs is in use.  The corresponding put
>> -	 * is in the tpm_devs_release (TPM2 only)
>> -	 */
>> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> -		get_device(&chip->dev);
>> -
>>   	if (chip->dev_num == 0)
>>   		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
>>   	else
>>   		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
>>   
>> -	chip->devs.devt =
>> -		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
>> -
>>   	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
>> -	if (rc)
>> -		goto out;
>> -	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
>>   	if (rc)
>>   		goto out;
>>   
>> @@ -382,9 +356,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>>   		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
>>   
>>   	cdev_init(&chip->cdev, &tpm_fops);
>> -	cdev_init(&chip->cdevs, &tpmrm_fops);
>>   	chip->cdev.owner = THIS_MODULE;
>> -	chip->cdevs.owner = THIS_MODULE;
>>   
>>   	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
>>   	if (rc) {
>> @@ -396,7 +368,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>>   	return chip;
>>   
>>   out:
>> -	put_device(&chip->devs);
>>   	put_device(&chip->dev);
>>   	return ERR_PTR(rc);
>>   }
>> @@ -445,14 +416,9 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>>   	}
>>   
>>   	if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip)) {
>> -		rc = cdev_device_add(&chip->cdevs, &chip->devs);
>> -		if (rc) {
>> -			dev_err(&chip->devs,
>> -				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
>> -				dev_name(&chip->devs), MAJOR(chip->devs.devt),
>> -				MINOR(chip->devs.devt), rc);
>> -			return rc;
>> -		}
>> +		rc = tpm_devs_add(chip);
>> +		if (rc)
>> +			goto err_del_cdev;
>>   	}
>>   
>>   	/* Make the chip available. */
>> @@ -460,6 +426,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>>   	idr_replace(&dev_nums_idr, chip, chip->dev_num);
>>   	mutex_unlock(&idr_lock);
>>   
>> +	return 0;
>> +
>> +err_del_cdev:
>> +	cdev_device_del(&chip->cdev, &chip->dev);
>>   	return rc;
>>   }
>>   
>> @@ -654,7 +624,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>>   		hwrng_unregister(&chip->hwrng);
>>   	tpm_bios_log_teardown(chip);
>>   	if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip))
>> -		cdev_device_del(&chip->cdevs, &chip->devs);
>> +		tpm_devs_remove(chip);
>>   	tpm_del_char_device(chip);
>>   }
>>   EXPORT_SYMBOL_GPL(tpm_chip_unregister);
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 283f78211c3a..2163c6ee0d36 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -234,6 +234,8 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
>>   		       size_t cmdsiz);
>>   int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space, void *buf,
>>   		      size_t *bufsiz);
>> +int tpm_devs_add(struct tpm_chip *chip);
>> +void tpm_devs_remove(struct tpm_chip *chip);
>>   
>>   void tpm_bios_log_setup(struct tpm_chip *chip);
>>   void tpm_bios_log_teardown(struct tpm_chip *chip);
>> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
>> index 97e916856cf3..265ec72b1d81 100644
>> --- a/drivers/char/tpm/tpm2-space.c
>> +++ b/drivers/char/tpm/tpm2-space.c
>> @@ -574,3 +574,68 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>>   	dev_err(&chip->dev, "%s: error %d\n", __func__, rc);
>>   	return rc;
>>   }
>> +
>> +/*
>> + * Put the reference to the main device.
>> + */
>> +static void tpm_devs_release(struct device *dev)
>> +{
>> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
>> +
>> +	/* release the master device reference */
>> +	put_device(&chip->dev);
>> +}
>> +
>> +/*
>> + * Remove the device file for exposed TPM spaces and release the device
>> + * reference. This may also release the reference to the master device.
>> + */
>> +void tpm_devs_remove(struct tpm_chip *chip)
>> +{
>> +	cdev_device_del(&chip->cdevs, &chip->devs);
>> +	put_device(&chip->devs);
>> +}
>> +
>> +/*
>> + * Add a device file to expose TPM spaces. Also take a reference to the
>> + * main device.
>> + */
>> +int tpm_devs_add(struct tpm_chip *chip)
>> +{
>> +	int rc;
>> +
>> +	device_initialize(&chip->devs);
>> +	chip->devs.parent = chip->dev.parent;
>> +	chip->devs.class = tpmrm_class;
>> +
>> +	/*
>> +	 * Get extra reference on main device to hold on behalf of devs.
>> +	 * This holds the chip structure while cdevs is in use. The
>> +	 * corresponding put is in the tpm_devs_release.
>> +	 */
>> +	get_device(&chip->dev);
>> +	chip->devs.release = tpm_devs_release;
>> +	chip->devs.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
>> +	cdev_init(&chip->cdevs, &tpmrm_fops);
>> +	chip->cdevs.owner = THIS_MODULE;
>> +
>> +	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
>> +	if (rc)
>> +		goto err_put_devs;
>> +
>> +	rc = cdev_device_add(&chip->cdevs, &chip->devs);
>> +	if (rc) {
>> +		dev_err(&chip->devs,
>> +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
>> +			dev_name(&chip->devs), MAJOR(chip->devs.devt),
>> +			MINOR(chip->devs.devt), rc);
>> +		goto err_put_devs;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_put_devs:
>> +	put_device(&chip->devs);
>> +
>> +	return rc;
>> +}
>> -- 
>> 2.35.1
>>
> LGTM, thank you.
>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
>
> Stefan, if possible, for sanity check, redo test with v9.

We need that other patch as well!


Tested-by: Stefan Berger <stefanb@linux.ibm.com>




    Stefan

>
> BR, Jarkko
