Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A9B30A7E
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 10:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfEaIlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 04:41:24 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42188 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbfEaIlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 04:41:24 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4V8efOA032616;
        Fri, 31 May 2019 10:41:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=TL7GoPObRQHZoQw+6HnAh8fO5ps044p9LItA6uibSU4=;
 b=v1rGuOCu7slmDHdiFgf66D5CP25JcT8WzhD/jJsIgHhJn3RCGU6CGS9DU2xtPnPS/DIc
 rOBlMP52YGP5p7CBftaJZ7wWcof2bMb5x2MDNXhuEAWoE6zHyZBVWPjGJ6g/xAaG+FDY
 glk65eNvS5O0iDFAAvjhXohnxqwUqFIqyIuH9T2iF1DvNO6/JNxx84bew55C/yerS17d
 TDEvEYirLMJTH+q5lLaHZ6dwVJ8fIxcnRLH3M+2xbj2Qk2cho/lbv7bzr/aXl29j9CiX
 bS8MKxoHJ7EhfTSUaYdxGY06jV+sc0FQhFEWDNy/ubY4eQHrH2Mj7kCEFbdlOpdkQIVb pg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2spu60u285-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 31 May 2019 10:41:17 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D13A710B;
        Fri, 31 May 2019 08:39:19 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D48371863;
        Fri, 31 May 2019 08:39:18 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE3.st.com
 (10.75.127.15) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 31 May
 2019 10:39:18 +0200
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Fri, 31 May 2019 10:39:18 +0200
From:   Fabien DESSENNE <fabien.dessenne@st.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 070/276] media: stm32-dcmi: return appropriate error
 codes during probe
Thread-Topic: [PATCH 4.19 070/276] media: stm32-dcmi: return appropriate error
 codes during probe
Thread-Index: AQHVFpYZYgpvcJwbS0WT+YmI1l46AKaExGkAgAAFjoA=
Date:   Fri, 31 May 2019 08:39:18 +0000
Message-ID: <180d29ba-74cc-08ae-35f6-cb58c1d79297@st.com>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030530.607146114@linuxfoundation.org> <20190531081924.GA19447@amd>
In-Reply-To: <20190531081924.GA19447@amd>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.45]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <BE3CF23C01D54B46B16CCA9520F56C74@st.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_05:,,
 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel


On 31/05/2019 10:19 AM, Pavel Machek wrote:
> Hi!
>
>> [ Upstream commit b5b5a27bee5884860798ffd0f08e611a3942064b ]
>>
>> During probe, return the provided errors value instead of -ENODEV.
>> This allows the driver to be deferred probed if needed.
> This is not correct AFAICT.


The driver gets defer probed *if needed*. *if needed* is for the case=20
where platform_get_irq returns -EPROBE_DEFER, which happens if the irq=20
controller is not ready yet.

Of course, for the other cases, the probe would just fail.


>
>
>> --- a/drivers/media/platform/stm32/stm32-dcmi.c
>> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
>> @@ -1673,8 +1673,9 @@ static int dcmi_probe(struct platform_device *pdev=
)
>>  =20
>>   	irq =3D platform_get_irq(pdev, 0);
>>   	if (irq <=3D 0) {
>> -		dev_err(&pdev->dev, "Could not get irq\n");
>> -		return -ENODEV;
>> +		if (irq !=3D -EPROBE_DEFER)
>> +			dev_err(&pdev->dev, "Could not get irq\n");
>> +		return irq;
>>   	}
>>  =20
>>   	dcmi->res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> irq =3D=3D 0 is clearly means error here, but will be interpretted as
> success when returned to the caller.


Thank you for pointing this.

It shall be 'return irq ? irq : -ENXIO;'=A0 I will send a fix for this.


>
> As device is not initialized at that point, I'd expect some kind of
> crash later.
> 									Pavel=
