Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C110114D4
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 10:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfEBIIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 04:08:02 -0400
Received: from sonic310-13.consmr.mail.bf2.yahoo.com ([74.6.135.123]:45448
        "EHLO sonic310-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbfEBIIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 04:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rocketmail.com; s=s2048; t=1556784480; bh=eqPLWwwRqRVmzP2YKccqgKJef102gkry4Z7Y3+dSxpU=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject; b=a54Ac64R6FQZoKZfwg4EGrzpULSchLC4M/3V5A0ntvSlJtUEWkaoesIogY0i7Yr5bxFOPZ4bsTlkBNc+pueyj7wEObCrDGyV5gRm6E/OmZe26xEVsj1osIOMSXN4/l6fgx0hHhaugsNNdo/XfgrVQL9a6HtzGgRmEmq1UK4zk9L0kgmhn3+nmmCIDuyEiiK90HlQIWrbPQZzVZ3tMYt8z3ZGp3LqDuoh/5NB0qW0LFKjsgLHSA37bYFY01jJTMsCVlhfgwypWwyAMU27jU0Qzh7iBTdeWb7qxQk/mh6+TAqlnLykUEv0DM/hnVZvWnz2xMXwxmHCfmT3tNgyPuZoDg==
X-YMail-OSG: 7RoG7rAVM1lVcMBwOFiMzuVHlXnke1Jh.1NnEcWAeIOHaSSoAuW8QxaWKMU_QM.
 b.NKhsTu.eUxYSaEXcxNzoDsyVW1yATu3URu8Sqx4jo5xr.pY1hEAmB9BiffJCQzUQxP9byJ5HAD
 APcJLTxCu7UKHzal7MAUpuPe6zp1geIx3GuFGoQCNW.UVXnAFa3akW6.0Jx3I4XIogNafhlihnMT
 5cyNYutPf8j.BxsG_Ns5O5IkkP.K1D1329WFSJPac51.Mor2mNxqIXAUG8dxjTHN0mfOKHIY7CQT
 RumQHgEEzTD5fpYttrlfnInTj23GtkG3gquhbw2Gw91ax8VudufNsdNAFh5xAMHFa_5WIiXJ6YdK
 E7WE1R0KSJ7muX_MNRT6juK_YLtYoZSEwUmpWIRjzVHF0UhyGPh0.fBgF1fZXYSaSNGhtNnb3dqn
 ncPvioX_39bqIHAPvsqqMi80Fv.YirXTNgX6D614l8sSvHt9EwoYB8dqxRKCqZ009X4If6l4ZL6e
 N4MNOUbjuVQZNcfgfnHbybnbRqL1xWTOzQ99OoRZRzc0AAadEh.PZi2RmYIc0yBe7XTSLHmyUlTz
 wgqK4QSOTnUp8O4nVEshTHd9phqtPZiKWc_XCxoK1QEFKGaqS267R4w7PErcflg7F6XRcch5ZvdF
 Bz_QiyIEXcae7tv68lNgTrgyMy7A3cGCvG5xnmlfWn0etQ4wguhZNr8mRSKP3oxtzAJxH9lbh12H
 aPx2OyUvQN.32CETmpsl0fiB2sY0xqe594uHAZVR8uC_zcDmj42apPsJKee_0A4hzFDsVHSLBxVq
 oX.xtqlPfrhrRx8gNL9Y5wBIkUwcnn4QlyrzLsw1smkpfd8omcmEGuA9nSr2YOFitsIoi07IH2Ji
 HrJuzotoRYKAVD3RiaHhByjLS9Esj3fambpf3edxup6hLSNYvLdLpJfUjUbQwZbIAi.ZRbu2IoV.
 cKkTLFXRN3EyAJkbtXr9XUCI8BGi5v67teOkpDbR6oRlSEYR1c2Ytbxqcm9s6CgHtVuKm5UtO48g
 meYV8JH9GkQwxhEdMXwK88VDr.Q8VAuWr7LS9_epkCmbuBTWSvQuY20_rOOoqBkZzw0yV4medu7v
 ZUVT.q4bS6_wg1XYIFCANZsDj0t5BETj1SB9sOXHTYPF5SfALO0.d_lu0yMzAV59F4F.HisQk4.N
 Z2Z0S5gUZLtAQH1.6dwIQ6jAX.bGly2U_fS.gbJ6Q7nYBTeLTZQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Thu, 2 May 2019 08:08:00 +0000
Date:   Thu, 2 May 2019 08:07:58 +0000 (UTC)
From:   Keijo Vaara <ferdasyn@rocketmail.com>
To:     linux-i2c@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     Wolfram Sang <wsa@the-dreams.de>, linux-input@vger.kernel.org,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, stable@vger.kernel.org
Message-ID: <1541197134.3231703.1556784478268@mail.yahoo.com>
In-Reply-To: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
References: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
Subject: Re: [PATCH] i2c: Prevent runtime suspend of adapter when Host
 Notify is required
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.13554 YMailNorrin Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 4:23 PM Jarkko Nikula
<jarkko.nikula@linux.intel.com> wrote:
>
> ---
> Keijo: could you test this does it fix the issue you reported? This is
> practically the same diff I sent earlier what you probably haven't tested=
 yet.
> I wanted to send a commitable fix in case it works since I'll be out of
> office in a few coming days.
> ---
>=C2=A0 drivers/i2c/i2c-core-base.c | 4 ++++
>=C2=A0 1 file changed, 4 insertions(+)
>
> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> index 38af18645133..8149c9e32b69 100644
> --- a/drivers/i2c/i2c-core-base.c
> +++ b/drivers/i2c/i2c-core-base.c
> @@ -327,6 +327,8 @@ static int i2c_device_probe(struct device *dev)
>
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (client->flags =
& I2C_CLIENT_HOST_NOTIFY) {
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dev_dbg(dev, "Using Host Notify IRQ\n");
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* Keep adapter active when Host Notify is required */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 pm_runtime_get_sync(&client->adapter->dev);
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 irq =3D i2c_smbus_host_notify_to_irq(client);
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (dev->of=
_node) {
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 irq =3D of_irq_get_byname(dev->of_node, "irq");
> @@ -431,6 +433,8 @@ static int i2c_device_remove(struct device *dev)
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 device_init_wakeup(&client->dev, false);
>
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 client->irq =3D client->init_irq;
> +=C2=A0 =C2=A0 =C2=A0 if (client->flags & I2C_CLIENT_HOST_NOTIFY)
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pm_runtime_put(&client-=
>adapter->dev);
>
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return status;
>=C2=A0 }
> --
> 2.20.1
>

Thanks guys, I've tested the patch and can confirm it fixes the issue.
