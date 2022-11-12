Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399AB626B8D
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 21:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiKLUY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Nov 2022 15:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiKLUYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Nov 2022 15:24:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A523C13D67;
        Sat, 12 Nov 2022 12:24:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EDE8B80B09;
        Sat, 12 Nov 2022 20:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC7EC433D6;
        Sat, 12 Nov 2022 20:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668284658;
        bh=OgGGy3ir/ylHpb6vc7XDL74sKOCi3Yd9cAl4wZo2P0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CkQfUPYp7SPz1uD66d1ag8TbSE1vbygsam9m88HYrDMZ7Xp3FTleSWrGtGqJ2PiD/
         WF1ai5ZYo9oybxNUcw3ndFvYkLAo5qPnyDvziRKel44Fojsga38P+CJQ9X6ADYvwZn
         IU7X3u+k1gMnFa7GxnsEC7J6vEsJJYR0LyFKzlODtF4Gs2OO7YljG1rEZVWWYMmm1e
         qzkHrK4q7xVytzJZpJxTWsAYfAVeLp5BAB6yr7IcKXzPvCOq8r+8SbU7Aia58aa2jb
         Ux4uqC7ASJZwNdM5MZTYXM0DFPjz6H1y57NrOsUdIAh2gMHosQn6/qsIW0Q9sAm7E6
         +nLfQY8fsDkxg==
Date:   Sat, 12 Nov 2022 21:24:14 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hidenori Kobayashi <hidenorik@google.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] i2c: Restore initial power state when we are done.
Message-ID: <Y3AA7hZFvoI9+2fF@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hidenori Kobayashi <hidenorik@google.com>, stable@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
 <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2wdPUaS0AyfgHMFP"
Content-Disposition: inline
In-Reply-To: <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2wdPUaS0AyfgHMFP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 10, 2022 at 05:20:39PM +0100, Ricardo Ribalda wrote:
> A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
> power off a device that it has not powered on previously.
>=20
> For devices operating in "full_power" mode, the first call to
> `i2c_acpi_waive_d0_probe` will return 0, which means that the device
> will be turned on with `dev_pm_domain_attach`.
>=20
> If probe fails or the device is removed the second call to
> `i2c_acpi_waive_d0_probe` will return 1, which means that the device
> will not be turned off. This is, it will be left in a different power
> state. Lets fix it.
>=20
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org
> Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's po=
wer state during probe")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

Adding I2C ACPI maintainer to CC. Mika, could you please help
reviewing?

>=20
> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> index b4edf10e8fd0..6f4974c76404 100644
> --- a/drivers/i2c/i2c-core-base.c
> +++ b/drivers/i2c/i2c-core-base.c
> @@ -467,6 +467,7 @@ static int i2c_device_probe(struct device *dev)
>  {
>  	struct i2c_client	*client =3D i2c_verify_client(dev);
>  	struct i2c_driver	*driver;
> +	bool do_power_on;
>  	int status;
> =20
>  	if (!client)
> @@ -545,8 +546,8 @@ static int i2c_device_probe(struct device *dev)
>  	if (status < 0)
>  		goto err_clear_wakeup_irq;
> =20
> -	status =3D dev_pm_domain_attach(&client->dev,
> -				      !i2c_acpi_waive_d0_probe(dev));
> +	do_power_on =3D !i2c_acpi_waive_d0_probe(dev);
> +	status =3D dev_pm_domain_attach(&client->dev, do_power_on);
>  	if (status)
>  		goto err_clear_wakeup_irq;
> =20
> @@ -580,12 +581,14 @@ static int i2c_device_probe(struct device *dev)
>  	if (status)
>  		goto err_release_driver_resources;
> =20
> +	client->power_off_on_remove =3D do_power_on;
> +
>  	return 0;
> =20
>  err_release_driver_resources:
>  	devres_release_group(&client->dev, client->devres_group_id);
>  err_detach_pm_domain:
> -	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> +	dev_pm_domain_detach(&client->dev, do_power_on);
>  err_clear_wakeup_irq:
>  	dev_pm_clear_wake_irq(&client->dev);
>  	device_init_wakeup(&client->dev, false);
> @@ -610,7 +613,7 @@ static void i2c_device_remove(struct device *dev)
> =20
>  	devres_release_group(&client->dev, client->devres_group_id);
> =20
> -	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> +	dev_pm_domain_detach(&client->dev, client->power_off_on_remove);
> =20
>  	dev_pm_clear_wake_irq(&client->dev);
>  	device_init_wakeup(&client->dev, false);
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index f7c49bbdb8a1..eba83bc5459e 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -326,6 +326,8 @@ struct i2c_driver {
>   *	calls it to pass on slave events to the slave driver.
>   * @devres_group_id: id of the devres group that will be created for res=
ources
>   *	acquired when probing this device.
> + * @power_off_on_remove: Record if we have turned on the device before p=
robing
> + *	so we can turn off the device at removal.
>   *
>   * An i2c_client identifies a single device (i.e. chip) connected to an
>   * i2c bus. The behaviour exposed to Linux is defined by the driver
> @@ -355,6 +357,8 @@ struct i2c_client {
>  	i2c_slave_cb_t slave_cb;	/* callback for slave mode	*/
>  #endif
>  	void *devres_group_id;		/* ID of probe devres group	*/
> +	bool power_off_on_remove;	/* if device needs to be turned	*/
> +					/* off by framework at removal	*/
>  };
>  #define to_i2c_client(d) container_of(d, struct i2c_client, dev)
> =20
>=20
> --=20
> b4 0.11.0-dev-d93f8

--2wdPUaS0AyfgHMFP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmNwAOoACgkQFA3kzBSg
KbYgTRAAtAqac5nCS8x0gLNUqMiLdGMtQYkeQ/Qcuj+QELVgdohk6rbWDVBFJkMF
hJEdJxDCmm7Ry//JTvkrKcQSY688Uc5aH1B8z+KTHnGPNAkHwsAhZQ9/N6iKl8x9
zu2pNceNHPYkPuUrLzTk2EtDF1E07Qy2o48SX1I4+L42LKbf4diUH1jf9VRaLP3l
ehETMcWtbBN5r19LDAg/dlcT7Ume3uvSKMEBEVC8wFwaqBR2VqQW9CHexLGmjJpt
QpS2k9TXjmh4E7VPLLimVKYDQayjhhzK3qiDMOiQ1cI+6US+h/EvmneMAeLrHoq/
HPLU/dgZVLAefIFqqT2VQg5hj9TavJxbvPkMzl2KeXMBwW7mxm3AE3M7VtxvNxaa
xk+7zA/774xixiXu4ZU1letECi6Ob2vFfDtDis6tPgBYn8LiE2c2TxBH107GhLqk
+gUHUzVEFQQwSVtlkP9Dl+YYu35u9suGvujIepCZwdTlOYnwLrSUXS4XVMppCway
1aXYzBLE56NnImbzfbjQW68IX1YPKa+uJByCkFiaGVBNzq498DlJV76PSzX6wLJ4
reBTvTdFbFktbC/RT+65tbhXoGrAaUDcOBfufs7UCamIiFMrGKxRvSAViAGTL4/5
yqgplQKNsEADfshnXaFztT40cCRiEbtHjDLHu0vnBriklY/+0kA=
=Nc62
-----END PGP SIGNATURE-----

--2wdPUaS0AyfgHMFP--
