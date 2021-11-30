Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736494634D7
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 13:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhK3M4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 07:56:37 -0500
Received: from mail-ma1ind01olkn0169.outbound.protection.outlook.com ([104.47.100.169]:36189
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233549AbhK3M4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 07:56:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNhXdiH5Lj0VaAPZ7gNO919cYBBrBSO0YXOcKngvaV5gLCOf0CK7PCSHdBGKHBxWGdzcOlO/Eh23T1A4Y74EOqvrVrGgtvwqA7NmT8Z4Joe1iYpPqK2oviSFfQ+DHvkHZe4X/E3BmEkPGAGTGhcvp6IgruawRkgAxjmGiLvgFvjvb8EJi01XMGPk+jMRrIbLHmteUdI8bcyIvhPE7meAPDf8CcvDuhc+1VkP2nt2wMftnuXw81YQLJGJG6oU5YndzM5alfrjfCPdpbQ1fXblm2vN6YyvP9WKDX28A22wSR6MnHNOK3VocTCc5NeLghUqXmzGDiSnsMDUFZwPusMgbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Qa18C9CEJ6gA+PmIjcMJUIL4qKC4c5AKijqHSePM2M=;
 b=GQNumqks26aOMs+86J+XDxS9qMBVJM+LBS6Gt4ZkKDVQFVKcOBXeOMRYCihYLbY8N1ugXydFXOLjwFyyCBLcuok5FZcE7AsaaYB6rQdf3CL6Fm677m3+LW5YzVzn27OVmV0QpTp/4RpQ3mg9FiitsjkwuRu5DMj1FLDpyeew6hJvDfKTKWnilzu5TA9yjgoGDVo1iY3aMfeGMwqW3mIuxz+1TlPWOBEcIYqel6P9xnM/c9qKKGZo2wPZtxNGKGKh6S5Uw7VhUESkVfLppGTY6QwhRdSJOEIQFhOaesXQG70EqzC8UJdR0sZvZyrvBvd0cp1yueC7I+JHQUm4O64aDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Qa18C9CEJ6gA+PmIjcMJUIL4qKC4c5AKijqHSePM2M=;
 b=khCZHtb2dz3qi833HszRpxX4jiuNgzF20cHcXPGGePWZi3TjMbzta3LvKdmaUEYl5cLp/xgiM94XFAQlkMA82SEzIi+E1FGv+Gmo7WJFZAQ+sQ64mqt5+c2OljWDM1cWj1lMBllYp9PWrgD5rOgAbkbLwLNb5V/Qp4KtxtXXF/2SOgBC4I706AgYXvZtCnVzpD0rKjlSMQ1Dsvki7ChIpgWaxBWRsVomezN8y+QluFbB4wdFmCm1CzMQwIU5eWu5vokAYJ/97CwTyZYAhmqtgPzLNc0JH4IMDHhfyCJlt2JMFExIKZ7x4pCNjDUKKOOrcD8kn9Vlo0aIGu2VsV06nQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR01MB0832.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 12:53:11 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 12:53:11 +0000
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
Subject: Re: [PATCH v7 resend 1/2] Bluetooth: add quirk disabling LE Read
 Transmit Power
Thread-Topic: [PATCH v7 resend 1/2] Bluetooth: add quirk disabling LE Read
 Transmit Power
Thread-Index: AQHX5eAvfAaO4sHJPkSUGFA0w8PFBKwb+LQAgAAN/4A=
Date:   Tue, 30 Nov 2021 12:53:11 +0000
Message-ID: <2B5507F6-4E39-47B6-9BDD-B0CC21C9E2A1@live.com>
References: <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
 <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
 <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
 <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
 <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
 <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
 <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
 <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
 <312202C7-C7BE-497D-8093-218C68176658@live.com> <YaYS+OeOa68EGPa/@kroah.com>
In-Reply-To: <YaYS+OeOa68EGPa/@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [/mJ3qqiqDw8fydk4rtv+7MG5DZhPBwheQ7KkaLjpN3506l+PiLAY1eixhGlBsDoI]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7649ebcc-163c-4512-9fa0-08d9b4005daa
x-ms-traffictypediagnostic: PN1PR01MB0832:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +rMEpkvIeLGR3OxR1oM6hTNIkEM2VoEAykwEYcbT3/QI8wyK2quVbYDhatuEAFwGHkgz9KBB0i/Z1QuV754AB5O+iAA4kspajmnxx8bJElSWZnyNnfyE9LvRBNpi/8ATfgogEUMoRFYYfQp+7MRmANlX0cDeVOMd0HjRptziVDMkPGzd2ylAMapFnItccg2d4gLC0jpUjpi+qLgh9kJbTHw2dxRONRzgikJOuuw4ma9MpVMw1QbAMRj4fKGUQoVTmSzC5VUqk7NPslx17SrDgM0zdaVF9E4TeMAcKQYClyYw79oRSJKsBHKEAhS7N/VL7I/jw7Fwgs2OJER3ppAmNmY/9nQNA8tjLq3shUQ9fKO6E16fMyw33ahMECxpMV2u0LLS+uEXkqQe5IGZenu09SwTgIPO9ApA99Gduj+UeamKlVDVy+SZWgBRKLsumUl3gYeR+CkEGaUfsS0Hqetoged4/Ff1kOvmWmzsElDfTt6w8b+dP04CZkXeiItcJYhmsh7Eki9Sd6wG/B8Ok0WuHGKXGMkZs1gQn058PzwYAUDBj0dYnaD77hrgCrF0f+Dk2jfYILoAdO+Jbpp5V9ju86R2K1OO7aARS/v36l8U5zcxaf8Fl+iuCc52YyOPgvHd
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: G6yWixGSfHJjzWrrAVuoSGtSta/7XfBjCqe1kPol5Q1PLBNK+M12GBMAv77Lvgk1qps8qV/lMKl4kJRrmhRQoNtU7Wckbg7jZZigvAdFK9MKVxn7SFqy3eb6m36xxh8LKhIDWTtu0+PN7g1Sgt17mqSnICQNNf1yDkSLtR4KbIPMSAEuKZKBSH7mUesjE+jwD3UySqF2sq1dEZPPzlau8gusqJFvFGSLwVeDEugxmu6Sy1V6EHZzRf7qhtqbEjCfJlpIfls1dVN9nYKW66uyrnuCcvu502XA2y9I6xw6UMtJtA38H5LX+74LQbuQDvhxrUnnOAYYS7cOPf2BHkx5QTbO+/RlrdnXU3NqqA3gO2MaEOSPeTH5MFNIUSorvDFEkp+eX3TRZjcdhWAK6vs/WWbGEpKb0QkXRqCZGlMdpAoMeC1Q/06iM+0s7Q+NyOlsL3iZF3oNHv1/whivdeI4zg2SYSSgoprNIFAwKguXPXm1It8IMuRMaQ9+kSdvbSzbY0i8G4NuHBVVgpF5BLhe/qQ+qs3QrIOj6kPErvbbxs+y510EnJUGWW3GptA/vEbdNYQhyYRKtFqQLZ/F0Y46CBELZCCAXW/cyCYi6p7SGwchEif6UJSTgvuPhx7um11SjNIMh7d19qsnHFYU4PrEnPS9t8e/qzdgw8hXO3lDvdE3Q9LIfLp46NZjqgKoLg/lrCs840NVdjhwDVppgyqphN//F1jzvcd150AbRy5zuxlrHYDkmuEfkIAXwnhm58MGjh6IHFDpm+iJchZEU9Y2dw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1062799441A434498E265ABAA707911D@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7649ebcc-163c-4512-9fa0-08d9b4005daa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 12:53:11.3341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR01MB0832
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 30-Nov-2021, at 5:33 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Tue, Nov 30, 2021 at 11:48:25AM +0000, Aditya Garg wrote:
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
> I am getting tired of saying this, but PLEASE use scripts/checkpatch.pl
> before you send out your patches.
Sorry for offending you. The thing is that I am inexperienced in the field =
of submitting patches upstream. v8 shouldn't disappoint you.
>=20
> If you had done so, you would see the following output in it:
>=20
> CHECK: Alignment should match open parenthesis
> #49: FILE: net/bluetooth/hci_core.c:623:
> +	        if ((hdev->commands[38] & 0x80) &&
> +	        !test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks))=
 {
>=20
>=20
> Please fix.

