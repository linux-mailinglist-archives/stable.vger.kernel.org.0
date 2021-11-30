Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0B3463355
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 12:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhK3Lxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 06:53:47 -0500
Received: from mail-bo1ind01olkn0153.outbound.protection.outlook.com ([104.47.101.153]:27490
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229768AbhK3Lxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 06:53:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYxW8IY8stAr5ymdOR+wIKmv3IB2e0VvOs1Kz0kEIaHDTOz6x5dIiIEUjhxipif4ZX8ISZwSknkxU6pYd9tdgvtZgSAi3ciOlUFtAUjhKvbwyzxAvrgGJWE1RihtuEV4sxCLNSBrfThZE3aqdcUJgERCge/LoGVftAYs/slg1g3lraQ3O35ThGlUyV/Yp1tCR0wTyZ5SEIwAi4nJXrzAQ7UJ4LSUhKUVcMLoA8USIjeNV5IbmiaLgURR5TXajitJZibtbv9cDpxmuNOoIA7fKev7d1bABB8XUwcpqrv+jugFBENEf0eXb9zpSMS+kvlHGffRGD3G+U3MEjpIEFaWTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtZ1vtIDAN0FUuJoZPBheK7iqn020NtZpmc3jBnqU/0=;
 b=nKn3mIpVxE32q5M0ru/SUmZIYFGHmEzLRc6emApItscwcZbtYyRAEyYCM4M/LBgUjhd8NWhBtsfskXYdlmEJ4AbA2pUI46rfn3Kt0c740WmegLXhl0xugKwxb3wEi4E4AATSlbL1t3pKysMHRkvEs8l2WxRHew15n+wgYzwFg6AP5ZWFUQUtTlWZP7aTkiKGKhuRyobUfRz80qucBdVOD0qi5xdrStxfTUcFSzAWoulw8KrBPQhJ1AGgqb0cuAlTJqnO726Qxo4fu7w/XaRmrfTZif2f1ksTr0fXmU7Ohu2QCzHHU9QmwrxIcVFcEnwBWURR0WL3FF6tnJCekdvJVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtZ1vtIDAN0FUuJoZPBheK7iqn020NtZpmc3jBnqU/0=;
 b=hgiG1amDKeLESaptrJynwwPnXXt2KohMKTqb6cEKVI43Pdk6JA/Ft7ky3AEottJfU1xX5EqZiyCSVrR7CUUh097arZR6vTAOO6N34tzNcvRjPG+2ednwRq+3p2ewh12GCSPtUr44TwPj+AxF0XRE9TQDxSrK4bEhMz3ciVqSnExDLYAEmroFfcSjs/iX4Ooww8KFCV76D7ikXwhki3V7IxvoOjoTEz+52NLRholS0ZNge3F+wsPVkLprSc2uyF7okRzP+neLjucf2+rqYXXJNF6stw44/5h9oTBDzg/JcCwBVPFCu3IKrXED1Qj8LThQErliCJssrjkjFNkklMtyRw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1903.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:13::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 11:50:06 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 11:50:06 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Topic: [PATCH v7 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5d7dHicx4XyL6UmjXwqFY5glRawb8qOAgAACc4A=
Date:   Tue, 30 Nov 2021 11:50:06 +0000
Message-ID: <AF3FE4B9-2210-40CE-93F4-A8EAFFD81E3B@live.com>
References: <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
 <YaSCJg+Xkyx8w2M1@kroah.com> <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
 <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
 <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
 <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
 <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
 <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
 <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
 <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com> <YaYN35NRBTV61qpT@kroah.com>
In-Reply-To: <YaYN35NRBTV61qpT@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [6244ijVRyFmR575fepgmURv9qn60FtfkmeElb7DWD4DQlYLsmiBqoSOapCXlnmdm]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7a8623e-37bb-4af2-6fea-08d9b3f78db3
x-ms-traffictypediagnostic: PN1PR0101MB1903:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IeVsYtDqtE0nYZfn1p/EOREFa36jnEytVWJ+zxaOM0ST5JT5mkqq+/oFoWAXgcwlVufKEZtCF+MUbCccDIT4un0F4b3yF/4WmLBzj6mmNp0jCcCcZcuY7O6qC8JepiRyb/FynxuWqFGgwB8F+qxx0gX8uDPVHfmsDatyygnAczLASc/xO4BDPYpRBzaRxgOmPonnA7Ir3Zq3sO0bMvvv8ieI4UML73KTnnS0yuJrwTJ9qV8iIKb+6X1P+0D5BWQv2ix7CnPaAzJWAausbUOAnq/uDIcza4UDWu1oezaNUCgvakdrmjZbO6XeljMuh7f7OXjKa5seuodJ16sgGORBZaZB8Ru3ZYRf3/TaYCamQf087xYfkJrwPCVeQ1ffVmj4SfZgZHJGnOq9lmlT2Ok+Za7hDD4iOdfTpqYtPB8bJBBrN+FxOSacDYyL3Y90VweYP7k7AnRSfAjBhh+DQgDbm1TSEir9GefclfBeHBvRhKTW+Hk+kqsw8pWxcGzP58qp9NRFSFEJPcI5IvJJZpLdUM/pG2Ta+KetWoq98CQZLNGztsv0TktFvDGD3UYrcRDzvZhnJuMomHIR+4B7Dw/v/+9AmoUiVfqFKxCCPpJaGgznioFR5CngNo9TM/74I1oI
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: h29pPmR0UJupkECY9uTKDpkfWo6h6lG/nvtYbE98FikYyJFC0PwcQ6QToK5TpRVv/tzyzn38F/VS0+htBkBdDia2BBEvzEpL1dRLXA9YWX8y+H+PXMHONhSYs0W3CcbSwI23t0Y6aqQd44X92ZhCSa8cAlFC2jM5wRwSDeaTAzO8ryGAhDOxfajR5N7OWeRK7FAw+PRCGnR/7ZHMh0BI1rwsNAwCVZliLyf7Q4UFYmAlhSXJteu85nBBOF9xNL3zAZ8a9aMzAHSajUnGOcq2VjFCGv4FT+OEoip6H+bKddzf+xZiHSSqTkm/CF6dHwDd5PWxM5wlHTuXdZEF7JYYmJmqrMsgYMJlEM1cuDNWSqVczBkYbDphGbOYT/4mbnhBcYccHGhk3OB8YykCrPM2JaE59mhiUnhST8KQ1BgMOqMgbakMSt2vjPzk8jyrJ7IuO9ZiU/phRvlewgHD6yhG9SnT3/nP9o/enursNn0CbFEA1+/TdfL4/DpgyBNHfLXaMKT6O+cOcJXyYLxqrggapLGE8QuRWk96/qiIaVGglNb/asvR0B9IPshEN8TZS1bpTfOvxw8YjqU8+KWMO6iTg92q3ph3VnOGhu4l33Q7HO05D0OJUQKil8ZPkgEAbyNA7LpWAvXSW48XcvQdomFQD5oWwVzcG7e0gAQPh6dN93teTKtIFASeozrYh6qOa4o5UfjS2uIPODGSrIfIV2shdu7nQQKdtgi/sQNqdNb1+0P6Alw8csPQ2oEjAo8ojwN8ZvwVeb3GMSMGxbqY3L0kYA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9109C2326066D14A92E1412E16E163FD@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a8623e-37bb-4af2-6fea-08d9b3f78db3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 11:50:06.4141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1903
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 30-Nov-2021, at 5:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Tue, Nov 30, 2021 at 11:38:58AM +0000, Aditya Garg wrote:
>> From: Aditya Garg <gargaditya08@live.com>
>>=20
>> Some devices have a bug causing them to not work if they query=20
>> LE tx power on startup. Thus we add a quirk in order to not query it=20
>> and default min/max tx power values to HCI_TX_POWER_INVALID.
>>=20
>> Signed-off-by: Aditya Garg <gargaditya08@live.com>
>> Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
>> Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
>> Link:
>> https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmai=
l.com
>> Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
>> ---
>> v7 :- Added Tested-by.
>> include/net/bluetooth/hci.h | 9 +++++++++
>> net/bluetooth/hci_core.c    | 3 ++-
>> 2 files changed, 11 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
>> index 63065bc01b766c..383342efcdc464 100644
>> --- a/include/net/bluetooth/hci.h
>> +++ b/include/net/bluetooth/hci.h
>> @@ -246,6 +246,15 @@ enum {
>> 	 * HCI after resume.
>> 	 */
>> 	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
>> +
>> +	/*
>> +	 * When this quirk is set, LE tx power is not queried on startup
>> +	 * and the min/max tx power values default to HCI_TX_POWER_INVALID.
>> +	 *
>> +	 * This quirk can be set before hci_register_dev is called or
>> +	 * during the hdev->setup vendor callback.
>> +	 */
>> +	HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
>> };
>>=20
>> /* HCI device flags */
>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>> index 8d33aa64846b1c..434c6878fe9640 100644
>> --- a/net/bluetooth/hci_core.c
>> +++ b/net/bluetooth/hci_core.c
>> @@ -619,7 +619,8 @@ static int hci_init3_req(struct hci_request *req, un=
signed long opt)
>> 			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
>> 		}
>>=20
>> -		if (hdev->commands[38] & 0x80) {
>> +		if ((hdev->commands[38] & 0x80) &&
>> +		!test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
>=20
> This line is still not properly formatted.
I hope its fine in the resent patch. I sent the patch as HTML by mistake.
>=20
> Please always use scripts/checkpatch.pl to find issues like this.
>=20
> thanks,
>=20
> greg k-h

