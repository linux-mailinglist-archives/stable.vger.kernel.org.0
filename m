Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7C711EB23
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 20:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfLMTgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 14:36:15 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:49420 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728686AbfLMTgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 14:36:15 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9F66CC00D3;
        Fri, 13 Dec 2019 19:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576265773; bh=91uhqlB7RaaqneClcmiKcRkHuHygsCCGkz9eJw7RUzM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cgxp6mE5V4owO6PKoGD3OHcpr2gi/jTNcQyAqe2xRrjO5SkLImo+rCsbPrqAS4PDC
         uCPsiFa4O7Me1GXs97/PmwWWMrtU8YHLeYBtVRbCE24w5LHt8fExe5K9wXrbQzBFB+
         Lvgk1EqeTc152PyjjUpprnqzAx2Bji2/WniPROuSNI9iZCngpcxPV3dRjsNPyzqry+
         E9dB9IVEiSJR+VcNY28HjWmyV7dRSIi7tv9k8hfgB9mawkYgKOvMnSi3v88zhfmFk0
         plwMEf95IgV2fcBSQc3daslb2nMEwY90UmwBSyCTAyGDi6ei4xTUI7+wSHEJfQXFXE
         LRfuzWybU9hLA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B7D3FA0079;
        Fri, 13 Dec 2019 19:36:12 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 13 Dec 2019 11:36:01 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 13 Dec 2019 11:36:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9X2oBW0BGwztGvyT7gAeJXhk5QjqouDaQb6JDSigJqvGYM7bbxgYU1xokPZOKD1isIzUORvkC+vh64YzX3P9mNjezb3nGAD07vJ1xCGfWAHhndVBjirjg/RmxgNYGF9QQFfVBrc5E9zM2ArVg8UGyzZQG4YXLeNGfLN3nA3YzODZpvjLKPRqnZQniz5tsYEf+OfrQBq+3nKhQPJqs+2oV8v91Mplv+4JrY6o0RU2KD1a6rcPMWwpbnvGKZjmkCeWA/ki34v7LqDx8i1t3maR2wHANtPTPlmBA9cBLZQGhSPNsOS3iEwssVDH2hBUwy5P5qHLGtbvTKLnjgOpX8cAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oRPx208h6uSb/xkDEoqmPvf7SCZPApvt2xSHXcQhoM=;
 b=fVGpuBPRY3MgSPdtJROgCz0t8ImaeaLhm7asD7oJ84BzsT6Fp5CWx7f+xWuUc1O/X1PKW4+DDQwlnxIC7c2OGOicdEaBZVTnP1XVvM27XFcxQtXvI7iwxGkzyI2efHhbhGBgqAyFVppYjnkBfSEJuTl4x+S193V+FV/rByS5MLL5gGjAsUix0hW+QrKs/HoZI47Lgow6zcHfLuudAry/EsVvHcOpb2a/AnybFZGFoFBDA/K2Lmv8kJPtxEIh5ANZKAi7i+e9Ls1Em/6Azk+f/lCB/9K+HnQdVduePbV6j5p2iX9Gbp38FzjPvMvMnUoqRHwFhiVAjkcKud3nOtZjVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oRPx208h6uSb/xkDEoqmPvf7SCZPApvt2xSHXcQhoM=;
 b=BOMEYuaC21x6fPyAEWzJqLf21nFewl32x5FoKV9VNvcGGxIeY0BDXVbwpvK8g3KZj1NROLimUoPuO8YJhqHTLf7DNIE6+IxR3/TQDUxjO7YDWkcTXLw3ZIOiqfqsm56RKat4/3iB2yOouCfazUHYBuWqJnPlBmJl2jUurmxjeG0=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB2470.namprd12.prod.outlook.com (10.172.116.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Fri, 13 Dec 2019 19:35:59 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 19:35:59 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 099/243] usb: dwc3: debugfs: Properly print/set link
 state for HS
Thread-Topic: [PATCH 4.19 099/243] usb: dwc3: debugfs: Properly print/set link
 state for HS
Thread-Index: AQHVsDaLtpPSN5OMLk2Tn5J854A5uKe30meAgACmQQA=
Date:   Fri, 13 Dec 2019 19:35:59 +0000
Message-ID: <a9710974-14d9-ecc0-ca48-f0690a8da124@synopsys.com>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150345.799359877@linuxfoundation.org> <20191213094055.GB27976@amd>
In-Reply-To: <20191213094055.GB27976@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [149.117.75.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b053b059-af69-4f48-bafc-08d78003ae58
x-ms-traffictypediagnostic: CY4PR1201MB2470:
x-microsoft-antispam-prvs: <CY4PR1201MB247021FD2F421819FDDF97DFAA540@CY4PR1201MB2470.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(39850400004)(376002)(396003)(54534003)(199004)(189003)(66946007)(31686004)(66476007)(2616005)(8676002)(66446008)(76116006)(64756008)(66556008)(5660300002)(54906003)(110136005)(6486002)(316002)(86362001)(186003)(6512007)(4326008)(26005)(36756003)(81166006)(2906002)(31696002)(81156014)(6506007)(478600001)(71200400001)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB2470;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 70vh28twNE8yyfx/kyEKAv/1+Q0LUK95aJ6b9wwTVD+wcgOxldugWDKgf2Cu9nDG8eD3i5yXlGYIC0vawWv6jPJ1GzgnDe9jbOuhY/MscL47rzdUKhYvYUogOm+q0pKuRUFpT+Asdb0c2Mljo3wrLZy6ua3TYNW6Prw/4st1igpi/3I/zZaPyMqNory6nOLOQIQBXXp2d0eBxbzBRMmgAvA11EX5d35aB5g1tsMaL09PYJwkf/N7OCxBb4ZBqePFr6332x2tCivIb2lLYiHrkKOmqsc0Ce3Po+c0a4gMBNxcolTtRylbSh+rWcwC60J0onjgI+EYFn4UsrGUKCxPczy8IwzkH7BvNWyw1m+d7HbvwBVyEkcnEvvSNXrT1JC1FcTe5scBkoCUWLVLtSdD6iUWwsLhhOh4vh50k6vN4LhjNTfg7+EthkF39gbsTWrBqQj9GkITe+YrIIzMWgpliwys1KKTsjUpE8+ma1EbRlzTCq8rwt3lf4l06D/M2AHw
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <65D8C2CA20E2D844B493128F226A45C3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b053b059-af69-4f48-bafc-08d78003ae58
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 19:35:59.3322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LZgqUE9KWCCHXB7ol2hE/xkME68qKBbUmCnoFq9ufpT/++me2IanK/OJ7EFkGb/Dv617VpMQiq8v0O6LoiNBKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2470
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Pavel Machek wrote:
> Hi!
>
>> From: Thinh Nguyen <thinh.nguyen@synopsys.com>
>>
>> [ Upstream commit 0d36dede457873404becd7c9cb9d0f2bcfd0dcd9 ]
>>
>> Highspeed device and below has different state names than superspeed and
>> higher. Add proper checks and printouts of link states for highspeed and
>> below.
> Just noticed some more oddity:
>> +	case DWC3_LINK_STATE_RESUME:
>> +		return "Resume";
>> +	default:
>> +		return "UNKNOWN link state\n";
>> +	}
> "UNKNOWN" would be consistent with the rest of the file.

Leaving the "link state" there may be fine for now due to the way it's=20
printed in the log making it clearer.

>
>> +++ b/drivers/usb/dwc3/debugfs.c
>> @@ -433,13 +433,17 @@ static int dwc3_link_state_show(struct seq_file *s=
, void *unused)
>>   	unsigned long		flags;
>>   	enum dwc3_link_state	state;
>>   	u32			reg;
>> +	u8			speed;
>>  =20
>>   	spin_lock_irqsave(&dwc->lock, flags);
>>   	reg =3D dwc3_readl(dwc->regs, DWC3_DSTS);
>>   	state =3D DWC3_DSTS_USBLNKST(reg);
>> -	spin_unlock_irqrestore(&dwc->lock, flags);
>> +	speed =3D reg & DWC3_DSTS_CONNECTSPD;
>>  =20
>> -	seq_printf(s, "%s\n", dwc3_gadget_link_string(state));
>> +	seq_printf(s, "%s\n", (speed >=3D DWC3_DSTS_SUPERSPEED) ?
>> +		   dwc3_gadget_link_string(state) :
>> +		   dwc3_gadget_hs_link_string(state));
>> +	spin_unlock_irqrestore(&dwc->lock, flags);
>>  =20
>>   	return 0;
>>   }
> The locking change is really wrong, right? There's no reason to do
> seq_printfs under spinlock..

Yes, it can be unlocked earlier.

>
>> @@ -477,6 +483,15 @@ static ssize_t dwc3_link_state_write(struct
> file *file,
>>   		return -EINVAL;
>>  =20
>>   	spin_lock_irqsave(&dwc->lock, flags);
>> +	reg =3D dwc3_readl(dwc->regs, DWC3_DSTS);
>> +	speed =3D reg & DWC3_DSTS_CONNECTSPD;
>> +
>> +	if (speed < DWC3_DSTS_SUPERSPEED &&
>> +	    state !=3D DWC3_LINK_STATE_RECOV) {
>> +		spin_unlock_irqrestore(&dwc->lock, flags);
>> +		return -EINVAL;
>> +	}
>> +
>>   	dwc3_gadget_set_link_state(dwc, state);
>>   	spin_unlock_irqrestore(&dwc->lock, flags);
>>  =20
> This might be ok but is not mentioned in the changelog.
>

I'll spell it out next time when I mention "add proper checks" in the=20
commit message as it obviously wasn't clear.

Thanks,
Thinh

