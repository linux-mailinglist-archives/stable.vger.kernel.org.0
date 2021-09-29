Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D1C41C442
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 14:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245547AbhI2MGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 08:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245211AbhI2MGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 08:06:33 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F2BC06161C
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 05:04:52 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 66so2053950pgc.9
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 05:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=O+kwQC4M0E3sUw4dmsxYQXLtGg3AMi5EmwiMTeq0Mu4=;
        b=qw3OOrK/4e4AM3+2JQgTPdk7h8rozsq6Eza9GHl6/VAUmCBclH7pGUr5g++lfx0bX6
         3tNMlzhxym4xdDyt9CF1Tqhj3pMB+vQkZzqHv0cy4nRe4w6HxSITZX17o7XAhOfhwC7r
         SmO1k2mn/mxAXq9H0jCW3F2RPI+C6gOMpDA3yvL4kYSzJ/t66Xk1ZDa4BJ0hn5SjQKQN
         dGzINlNFFpnwSVSGmyRiqYetijRaX2iZhEilKlLsslbaXBzSy/jhQt1EQ8+EUhccp5gw
         VmV1ks/j9W/81+lqeNECr87E+lGSWJukUyj80XNZfNVfU3iRHsg5Q26in2aOwx7oluwt
         QFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=O+kwQC4M0E3sUw4dmsxYQXLtGg3AMi5EmwiMTeq0Mu4=;
        b=HzHwkgIbWwnl4vLeMBkfkX+4G2ffyo/nSVMjeorZNrnWnFQfKsvaAG1Q25/mbZzUPD
         Vr7pyT1OUQ66kXcTTuDGDJAieok9ID/EIQtz/ZvE593/mQmeL6mJ7RbeVQZrXP/Gw5Mx
         DANHXltuZPPm8amC+KdbwlYxHr6usePvFohARvg/eGvpRUWg7E2g2ziLbJvaXF1dcwda
         PdLG+eIeY+12zMntCQfpXfhz31dZwaA5Dd7kYu9s9dXxUYmQd2siaNKyqLkJ7rO5SyJk
         CKo9jWLVxPPCme7BQXaw4TsEDk2/VnkYNkIoYKTc+HqIQcWDbueDHgtLjB4aq60KITvP
         CdJg==
X-Gm-Message-State: AOAM532/ycgW0oEt7zHLFzqg7njlRPtyk4KB59l9k89Id+KiotGE4tU2
        EAUX3jv+b0qLrMiHrqg4BkW+0NJzszYE
X-Google-Smtp-Source: ABdhPJwL+JkaE70dk1RsNkXUtipXgEKGpAwvD9cskLR+DzQZHKm/4cbC08v9ZtzXnv0UxK19QjiQAg==
X-Received: by 2002:a63:7a45:: with SMTP id j5mr9243171pgn.369.1632917091886;
        Wed, 29 Sep 2021 05:04:51 -0700 (PDT)
Received: from ?IPv6:::1? ([2409:4072:6d9d:8ec1:20a3:9c79:fefb:80c0])
        by smtp.gmail.com with ESMTPSA id q21sm2381057pgk.71.2021.09.29.05.04.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Sep 2021 05:04:50 -0700 (PDT)
Date:   Wed, 29 Sep 2021 17:34:42 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Aleksander Morgado <aleksander@aleksander.es>,
        Thomas Perrot <thomas.perrot@bootlin.com>,
        linux-arm-msm@vger.kernel.org
CC:     hemantk@codeaurora.org, loic.poulain@linaro.org,
        stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_bus=3A_mhi=3A_pci=5Fgeneric=3A_increa?= =?US-ASCII?Q?se_timeout_value_for_operations_to_24000ms?=
User-Agent: K-9 Mail for Android
In-Reply-To: <f358044a-78d0-ad63-a777-87b4b9d94745@aleksander.es>
References: <20210805140231.268273-1-thomas.perrot@bootlin.com> <f358044a-78d0-ad63-a777-87b4b9d94745@aleksander.es>
Message-ID: <73A52D61-FCAB-4A2B-BA96-0117F6942842@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 29 September 2021 3:07:23 PM IST, Aleksander Morgado <aleksander@aleksa=
nder=2Ees> wrote:
>Hey all,
>
>On 5/8/21 16:02, Thomas Perrot wrote:
>> Otherwise, the waiting time was too short to use a Sierra Wireless EM91=
9X
>> connected to an i=2EMX6 through the PCIe bus=2E
>>=20
>> Signed-off-by: Thomas Perrot <thomas=2Eperrot@bootlin=2Ecom>
>> ---
>>   drivers/bus/mhi/pci_generic=2Ec | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/bus/mhi/pci_generic=2Ec b/drivers/bus/mhi/pci_gene=
ric=2Ec
>> index 4dd1077354af=2E=2Ee08ed6e5031b 100644
>> --- a/drivers/bus/mhi/pci_generic=2Ec
>> +++ b/drivers/bus/mhi/pci_generic=2Ec
>> @@ -248,7 +248,7 @@ static struct mhi_event_config modem_qcom_v1_mhi_ev=
ents[] =3D {
>>  =20
>>   static const struct mhi_controller_config modem_qcom_v1_mhiv_config =
=3D {
>>   	=2Emax_channels =3D 128,
>> -	=2Etimeout_ms =3D 8000,
>> +	=2Etimeout_ms =3D 24000,
>
>
>This modem_qcom_v1_mhiv_config config applies to all generic SDX24, SDX55=
 and SDX65 modules=2E
>Other vendor-branded SDX55 based modules in this same file (Foxconn SDX55=
, MV31), have 20000ms as timeout=2E
>Other vendor-branded SDX24 based modules in this same file (Quectel EM12x=
x), have also 20000ms as timeout=2E
>Maybe it makes sense to have a common timeout for all?
>

Eventhough the baseport coming from Qualcomm for the modem chipsets are sa=
me, it is possible that the vendors might have customized the firmware for =
their own usecase=2E That could be the cause of the delay for modem booting=
=2E=20

So I don't think we should use the same timeout of 2400ms for all modems=
=2E=20

>Thomas, is the 24000ms value taken from experimentation, or is it a safe =
enough value? Maybe 20000ms as in other modules would have been enough?
>

It was derived from testing I believe=2E=20

Thanks,=20
Mani

>And if 20000ms wasn't enough but 24000ms is, how about adding that same v=
alue for all modules? These modules definitely need time to boot, not sure =
if having slightly different timeout values for each would make much sense,=
 unless there are very very different values required=2E
>
>What do you think?
>
>>   	=2Enum_channels =3D ARRAY_SIZE(modem_qcom_v1_mhi_channels),
>>   	=2Ech_cfg =3D modem_qcom_v1_mhi_channels,
>>   	=2Enum_events =3D ARRAY_SIZE(modem_qcom_v1_mhi_events),
>>=20
>
>

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
