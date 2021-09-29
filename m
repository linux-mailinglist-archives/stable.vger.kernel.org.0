Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1704F41C400
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 13:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhI2MA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 08:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343565AbhI2MA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 08:00:28 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3894DC061753
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 04:58:48 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id bb10so1354820plb.2
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 04:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=xe4OX2IAROL4XHXtqnP6SRnXOTt0CNJYp0ngxrxDPo8=;
        b=OV5RWEtEpbJ3GrsHwcanzexLVHnGjHqavm3zSVZcuoe0UKmqUF+7Z4WImLSelE21te
         zfWn/rKHblUz87MGDZ3Psxt9dywxzuKEfGK7XBNOX3dhpLaR0m70tNj+6xwypNAIj/LX
         rZlIzdWAj+tBT8PboJ6CuHwoFYYcVVSrI/bFNIp6JUfTN3Pn5lusuYtbxQR9HK8nffdj
         cQND0/8z/d/wZOYcyx8ZPu6ZPy1Bo3P57Z+8ZI2yQvtbSApNBo5Jxv05NNHo8R/mw+By
         qoB/tQuo8zFxjowT0P0Sm1KpPWIJxUAnCn62oejS8uNF3Ys70Y7EnuB1h/Ri3K8OIYRo
         nnwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=xe4OX2IAROL4XHXtqnP6SRnXOTt0CNJYp0ngxrxDPo8=;
        b=ly+TdMZmR1hqqZ7NbIibBNmxRYIbfMTONpYKeDrov5/N6tPNKVKkZNDYviF2G7YpIV
         gDWWU1fRcIE7n/Nzps7EV9xgFgRlGpZriPK7zcUTVoDtqbtNM+34TQjVbHgx6OohvPL6
         x10vADvbW8HOlIohn8aCIhoZlN9IFkGaV1oNDUa3fHTIzyl4xF94LeRRXcPQif7uQAH7
         cMOc+qLBb1UcKZCqsUqsUbHwQFjzGpDgSv0QazecinV0LCK7urFPxcdrfNkydSLzjUAs
         ho5F5yDaVBJnusCV1DbieOehJl45bBRj/1SAuVVbSR9+iuqWQ4VGfdfluhD5pbDBcXNx
         Dajg==
X-Gm-Message-State: AOAM5326BUMgGMQQhrBDMuwgH90k/qL6I4M2SOE5O6l1fTxKxydOIO2k
        S3vpAk66VjZpQxBOx21Lyh/Z
X-Google-Smtp-Source: ABdhPJxfsqkvREMuyJK5oAtQ9l4F4lzbKzB6AVvYLiHB7or7DOrdovizQZ2w7k/KG3+YmfaS1bdmsg==
X-Received: by 2002:a17:90a:5d0f:: with SMTP id s15mr6000391pji.10.1632916727685;
        Wed, 29 Sep 2021 04:58:47 -0700 (PDT)
Received: from ?IPv6:::1? ([2409:4072:6d9d:8ec1:20a3:9c79:fefb:80c0])
        by smtp.gmail.com with ESMTPSA id k22sm2337009pfi.149.2021.09.29.04.58.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:58:46 -0700 (PDT)
Date:   Wed, 29 Sep 2021 17:28:39 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Thomas Perrot <thomas.perrot@bootlin.com>,
        linux-arm-msm@vger.kernel.org
CC:     hemantk@codeaurora.org, loic.poulain@linaro.org,
        stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_bus=3A_mhi=3A_pci=5Fgeneric=3A_increa?= =?US-ASCII?Q?se_timeout_value_for_operations_to_24000ms?=
User-Agent: K-9 Mail for Android
In-Reply-To: <5e1c5979b7fd35aa5715ed9b25ca3a59b7b259f4.camel@bootlin.com>
References: <20210805140231.268273-1-thomas.perrot@bootlin.com> <20210816042206.GA3637@thinkpad> <5e1c5979b7fd35aa5715ed9b25ca3a59b7b259f4.camel@bootlin.com>
Message-ID: <8109C610-8171-4FD1-8599-28A3860915B0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,=20

On 29 September 2021 1:41:12 AM IST, Thomas Perrot <thomas=2Eperrot@bootli=
n=2Ecom> wrote:
>Hello Manivannan,
>
>I just saw that this patch seems not yet been merged, is there a issue
>with it?
>

For the last merge window we had a conflict with netdev tree so I was not =
able to send the second iteration of the PR=2E Will apply this patch for v5=
=2E16=2E

Thanks,=20
Mani

>Best regards,
>Thomas
>
>On Mon, 2021-08-16 at 09:52 +0530, Manivannan Sadhasivam wrote:
>> On Thu, Aug 05, 2021 at 04:02:31PM +0200, Thomas Perrot wrote:
>> > Otherwise, the waiting time was too short to use a Sierra Wireless
>> > EM919X
>> > connected to an i=2EMX6 through the PCIe bus=2E
>> >=20
>> > Signed-off-by: Thomas Perrot <thomas=2Eperrot@bootlin=2Ecom>
>>=20
>> Reviewed-by: Manivannan Sadhasivam <manivannan=2Esadhasivam@linaro=2Eor=
g>
>>=20
>> Thanks,
>> Mani
>>=20
>> > ---
>> > =C2=A0drivers/bus/mhi/pci_generic=2Ec | 2 +-
>> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>> >=20
>> > diff --git a/drivers/bus/mhi/pci_generic=2Ec
>> > b/drivers/bus/mhi/pci_generic=2Ec
>> > index 4dd1077354af=2E=2Ee08ed6e5031b 100644
>> > --- a/drivers/bus/mhi/pci_generic=2Ec
>> > +++ b/drivers/bus/mhi/pci_generic=2Ec
>> > @@ -248,7 +248,7 @@ static struct mhi_event_config
>> > modem_qcom_v1_mhi_events[] =3D {
>> > =C2=A0
>> > =C2=A0static const struct mhi_controller_config
>> > modem_qcom_v1_mhiv_config =3D {
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=2Emax_channels =3D 1=
28,
>> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=2Etimeout_ms =3D 8000,
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=2Etimeout_ms =3D 24000,
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=2Enum_channels =3D A=
RRAY_SIZE(modem_qcom_v1_mhi_channels),
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=2Ech_cfg =3D modem_q=
com_v1_mhi_channels,
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=2Enum_events =3D ARR=
AY_SIZE(modem_qcom_v1_mhi_events),
>> > --=20
>> > 2=2E31=2E1
>> >=20
>

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
