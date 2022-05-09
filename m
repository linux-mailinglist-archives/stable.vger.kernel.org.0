Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FFC51F899
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiEIJvf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 May 2022 05:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbiEIJrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 05:47:11 -0400
X-Greylist: delayed 417 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 May 2022 02:43:16 PDT
Received: from mail4.swissbit.com (mail4.swissbit.com [176.95.1.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8B415F6C9;
        Mon,  9 May 2022 02:43:15 -0700 (PDT)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 07083123105;
        Mon,  9 May 2022 11:35:26 +0200 (CEST)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id EB509122CB2;
        Mon,  9 May 2022 11:35:25 +0200 (CEST)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail4.swissbit.com (Postfix) with ESMTPS;
        Mon,  9 May 2022 11:35:25 +0200 (CEST)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 11:35:25 +0200
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.022; Mon, 9 May 2022 11:35:25 +0200
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Ricky WU <ricky_wu@realtek.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Topic: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Index: AQHYJ7nTpeKajlBmYU+vTOb/+dRQe6ypG9+AgG2fl+Q=
Date:   Mon, 9 May 2022 09:35:25 +0000
Message-ID: <add6c326a5b04525965ffa1e9e96ea41@hyperstone.com>
References: <fb7cda69c5c244dfa579229ee2f0da83@realtek.com>,<CAPDyKFrYWgCbwk6-hNZjtx4mdn7Sx1NJLie+f8wEjS==_HXR5Q@mail.gmail.com>
In-Reply-To: <CAPDyKFrYWgCbwk6-hNZjtx4mdn7Sx1NJLie+f8wEjS==_HXR5Q@mail.gmail.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.153.3.143]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-9.0.1002-26882.007
X-TMASE-Result: 10--21.318200-10.000000
X-TMASE-MatchedRID: UWn79NfEZzbUL3YCMmnG4pTQgFTHgkhZScHI0MnRcnTIgofMgahPrYCn
        q9qtGcvVjTHLiFqxqhm2KCeDXdB69Y55DpFecYIWlVHM/F6YkvTVBDonH99+VujMOEZ5AL0S/L4
        h+S8DcywHKWdS7YRsIh1lVnMIIO2K9UAJ6IWwBzJO5y1KmK5bJRSLgSFq3Tnj31GU/N5W5BAtiA
        i8BOx+l8NoTajpI9VwnoDMZQbqsQl/4m4yZXmXb5JEUO2qIzlLphwRT0LbbAmwxkbalTMB8+aLX
        qTzHpREq9YyptElK5dM8DiwR/6/zYGAri4HrOLbl2fRVpVyo6TNc6i32ftlfJ6wS1w7uEucdGUC
        TIBLOQkCpRJ64odw58pjK4dbPxs8aDAi8sBNMoFWdFebWIc3VsRB0bsfrpPIqxB32o9eGclVaBF
        ytIQUtw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: ee30acec-bfe6-4faf-832d-d57c413d171d-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Can we get 1f311c94aabdb419c28e3147bcc8ab89269f1a7e merged into the stable tree?
I have some compatibility issues on Realtek chips because of the missing initialization clocks.

Thanks!
Regards,
Christian



From: Ulf Hansson <ulf.hansson@linaro.org>
Sent: Monday, February 28, 2022 5:12 PM
To: Ricky WU
Cc: gregkh@linuxfoundation.org; kai.heng.feng@canonical.com; tommyhebb@gmail.com; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
    
On Tue, 22 Feb 2022 at 08:28, Ricky WU <ricky_wu@realtek.com> wrote:
>
> After 1ms stabilizing the voltage time
> add "Host provides at least 74 Clocks
> before issuing first command" that is
> spec definition
>
> Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index 2a3f14afe9f8..e016d720e453 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -940,10 +940,17 @@ static int sd_power_on(struct realtek_pci_sdmmc *host)
>         if (err < 0)
>                 return err;
>
> +       mdelay(1);
> +
>         err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
>         if (err < 0)
>                 return err;
>
> +       /* send init 74 clocks */
> +       rtsx_pci_write_register(pcr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, SD_CLK_TOGGLE_EN);
> +       mdelay(5);
> +       rtsx_pci_write_register(pcr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, 0);
> +
>         if (PCI_PID(pcr) == PID_5261) {
>                 /*
>                  * If test mode is set switch to SD Express mandatorily,

As you probably are aware of, the mmc core uses three power states
(MMC_POWER_ON, MMC_POWER_UP and MMC_POWER_OFF) to manage the
initialization, while it invokes the ->set_ios() callback for the mmc
host driver. During these steps the core also tries to manage the
different delays that are needed according to the eMMC/SD specs. You
may have a look at mmc_power_up() in drivers/mmc/core/core.c. In the
rtsx case, MMC_POWER_ON and MMC_POWER_UP are treated as one single
step.

Moreover, it has turned out that some mmc HWs are actually controlling
these delays during the initialization themselves, which makes the
delays in the core superfluous. Therefore we have made the delays
configurable for host drivers. For DT based platforms, we have the DT
property "post-power-on-delay-ms" and for others, it's perfectly fine
to update host->power_delay_ms before calling mmc_add_host().

Would it be possible to take advantage of the above "features" from
the core, to avoid hard coded and superfluous delays?

Kind regards
Uffe
    =
Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

