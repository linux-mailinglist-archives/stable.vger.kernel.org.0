Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BC938F9D2
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 07:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhEYFNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 01:13:12 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:7926 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230282AbhEYFNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 01:13:12 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14P58vMZ005488;
        Mon, 24 May 2021 22:11:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=Ko8nfVOfhy3RUA1ilgjWs/+V2bd0I1YvgwKTjyv0gLs=;
 b=cLUsTeRNWbPIG3BvyopD176MDa4lPDDy49Hb3/IX/y1izJP7sw2jBAJa2i8ksnJo6+ZL
 XRRKflveQjfCOaAkb17YUorC2skqEum88UHWIgwCJogNNEWwDYy4+almeEByZmJCmo6o
 +Tk3GXAROItYev89aZ9DNugyG6XTtUc4Me5PQADzZwcXAyLZYA8mgPc9IV9uZO9Mxxwt
 Pxe0TDFA+3vUIrK2Z6ujKoELO47ygD1Ak0VOdPRWbKN/EapDTF2bxpvr/PAzMfOeGvXF
 Xh3vo8i8+RnI+sY6bCVOYnd/JGOhp/1rBkXEWMbS8Uk6Ql3A+f9KbIodg9PiUC/ezlQL QQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0b-0014ca01.pphosted.com with ESMTP id 38qp34dtrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 22:11:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeRCyublvTxGIuK33wjJUlSrpSuse6LP7x6YpYtwE9NcvDSmu9WZFMF/kSiJnnRGkZYsk+tk/M2w5PmIRKdXYfVu+jEn8HvO9d0jxt4+jmb8zoGon5sMe/yeFuOoXvg8ADCYkgveFzzKEeNHqkzWckRvPNXwyudZMeth5f2iDur33So4TMC8nTjgSTrQh6t9GVBhjiC56+EWOEE58c9btP5dGZbqjtK32TxR1kBkprAM/x21LXLeW6yuwdjoSnmWksJzFcEFNRetjAmtr+geFEKXkCd3xV97wb2Ej4lCkWNqpn6lTnUnoDu1gcnzDW22F8IcG4Ts9wKL+xS2wu+8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ko8nfVOfhy3RUA1ilgjWs/+V2bd0I1YvgwKTjyv0gLs=;
 b=DzJSAGIjQ8sLgTnVW97qMonSOUjVmFC6xUGfiEI/UkzGudbM/nUVPq+yCWnUWVoRYIY/Z3x7f2raoMzXoqdyHM+oJnpAoAF45VIknIoloUMXPN2gpibHPGYsTFkxGKvMvhUnkrBYcOeZcOYT6fKQitx36kJq00o1LZ9a4NvZ/RgM8EL2ZWDyfklQkhQTUUFTOPL0ExnHnE6Y7oMDlxsShBpGN89UbQKAYsfjbW4SH3KOb9We7lyHJnO3b/38wwBs86CxTA/nKkxCTUmiHBjfubct5FqiHui75pBwIqLHxmEVNu58Awvw4yRrj0Qt5TgTeNflK4slKxEHhauZfSFdsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ko8nfVOfhy3RUA1ilgjWs/+V2bd0I1YvgwKTjyv0gLs=;
 b=46qaDYeYa0nwRgzAieZGHw0jdAivMRprAGABDufY9VO9mehF8ESOGHl/4317mzEJtIHNSya4M+xKQfAjqEzAgYoSKpmd4JEn+fn81D2gPd9yXWeZSHPjBg7l+2UoQnB+yiX9CpiVRibhaGppfoVENhXRS/3FiciYI1ryWE4Dp78=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by SJ0PR07MB7616.namprd07.prod.outlook.com (2603:10b6:a03:27b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 05:11:31 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438%4]) with mapi id 15.20.4129.035; Tue, 25 May 2021
 05:11:31 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Rahul Kumar <kurahul@cadence.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: Fix deadlock issue in
 cdnsp_thread_irq_handler
Thread-Topic: [PATCH] usb: cdnsp: Fix deadlock issue in
 cdnsp_thread_irq_handler
Thread-Index: AQHXTVyBsA1aWGmABkei+mvVQ77+5KrvRjQAgAMyZSCAAO2GgIAAQHVg
Date:   Tue, 25 May 2021 05:11:31 +0000
Message-ID: <BYAPR07MB5381DFB0AC94D7A49B41C9FEDD259@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20210520094224.14099-1-pawell@gli-login.cadence.com>
 <20210522095432.GA12415@b29397-desktop>
 <BYAPR07MB5381074F9A2A8AD6CAF4C10BDD269@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20210525005349.GA20923@nchen>
In-Reply-To: <20210525005349.GA20923@nchen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctYThkNDIwZmEtYmQxNy0xMWViLTg3OGMtMWM0ZDcwMWRmYmE0XGFtZS10ZXN0XGE4ZDQyMGZjLWJkMTctMTFlYi04NzhjLTFjNGQ3MDFkZmJhNGJvZHkudHh0IiBzej0iNzE0MyIgdD0iMTMyNjYzOTMwODg5NDIzNjEzIiBoPSJKMDJ2YmIyZzdjVDhFTXBGaXFmYWVsT0UrU2s9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a5fd945-9cf0-4e3f-2d6c-08d91f3b8f26
x-ms-traffictypediagnostic: SJ0PR07MB7616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR07MB76169E72A8A3058ADA651B3DDD259@SJ0PR07MB7616.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HS8l6diMoBTBkGLgKd1ewMAehU+Y8/J9S9QmOVagZfqrMzAzZl3fp2fUHwpKLj1CbLv0JKNHY2NuBWgOLkzkLXsGF18mk9UgSP2xZFS2o30g0Nk3OcT4CIs3ulaXPC3unMU9VW8og7sVI8vh3horHXVl9aNt1ulRGo6DhanVxrTw9egfjVvc/Y8SUmJ1cGkh57k6gq/+3ED9VVvV0vAwilYg3nOOdwIZCZntAvmYXMWB3Iw3mXcbtWKD93H7qwg5y7O0TnrkF0MIq/MssRYwLnZGTWkZfTSdt7pd9Wv/pG1Yv7TZ+ymyG63+gsuMZlOT+w6pfCASEZR71fNsAPd++XtxG9gcnD0asNhJW03K5E+BUaVDFtJc0WZjAIQN+qQghz12xQFlcvLef05soqipcvZUY2C+EUqEju1f9kd1EhqEMYjhvHyhup2yCIV0hmA5vj/vNuftHZiyEzep9TXML5Pjr5kl5QLCNv1ZzApaVClA0UDvX+3HmNjrF1xSid//38UntXMwMqTZpy6dx7OXfUaPPUK8gj4t2KV0xD/YxWppcDCiDnZ1Vv1ovH5TwD3zLRO7B3T4/neD4qkrG/y25PzNxEkxtdCPFPjrWa0aEdV1Sk/Iyr7eRQL5ga0cyR4cbjmuIewR9yp+PK+EPmA2CCKJaXukVxVlu5HIUqfl0CZa3a8uI31Wrxuc8BGkIMKs3HY5GSOdXBzLkLCqqdYYR8RDVPiHulydAWOhkHQRMC61IWbD89WP3V9l03se8lJQV833da4XLQHm8fjHZMPuUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(36092001)(83380400001)(52536014)(478600001)(122000001)(26005)(6916009)(6506007)(2906002)(71200400001)(76116006)(66556008)(7696005)(64756008)(66446008)(66476007)(66946007)(9686003)(54906003)(33656002)(38100700002)(5660300002)(55016002)(8936002)(4326008)(316002)(966005)(86362001)(186003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hycK3zbvTXkCDuDQEue1j9zNnUCZCFn3DmaGepGdrm48+Xuxm33GqtH3+bEA?=
 =?us-ascii?Q?Ix2M0/YIplBypjI8/xRSsS7NRqIFmaMKNoPD0qjJakRuKkDd5UCMKJbDvZ+w?=
 =?us-ascii?Q?QL6C1EQiE5HYpPbIrNfCZJEiDoIp261S+NAxmOMT51WnqoB6vlXtW3e7D9IB?=
 =?us-ascii?Q?D+jeQKT7OsOeCGqY48ZdD0YY4mD3YUX8JwFs/SQlbsrBgGitwfaucI1TYwOW?=
 =?us-ascii?Q?Tp0je2Dx4g5Rp4ZOIKTfndtI4FVDQdhzcPUdpbUBu4XKsVkSCjn1u5H5Xm5D?=
 =?us-ascii?Q?4diVItvcBkonBEFhKHZGbJ68TeiJZuplBxMusr8/PiFeder9R52XNWhlGCcj?=
 =?us-ascii?Q?vLpry9pYXwx+GhsLMfYFoyqSYhxqTcyqIrIoZVbtXNa381Y4Axd3e9jtHWO5?=
 =?us-ascii?Q?RoizQtEv3U0FZxRxaLkjQyzUQYhZ5nKbEHkDXKFWlikDIC9I7f4vw4JQ5xE9?=
 =?us-ascii?Q?GDXPt1o0d/9fXRv3u79Wb9/wrj+nxuVHgJssJwnE8qsN+bZ+U6zFDMPsBT/I?=
 =?us-ascii?Q?FtJC1cWOLOjfDQ2YU6Urprew4Bu10CcEcIYZbJBpU6ewJ2oMiECnkYwHvGdk?=
 =?us-ascii?Q?X/xqlYwL7pa8pvZBBmS4EfHoWdGId2rZQMFDeo9xQA9lWndfD0wyQMbGZeAX?=
 =?us-ascii?Q?8LCejyq6th+l1CjD8vcXft3n446OUwhT1wPBjLHBxldd7Zp8bWyXh5aFS6FD?=
 =?us-ascii?Q?oT3Fs/VeO04ZUxXjU66Bqk87QXbcnYeD/NrO8GCvbJKu7a6rJeURyqp5DBv1?=
 =?us-ascii?Q?tuaB0j6XyNltaCzo7GLl0RBjJl+Muh1CRS1w7+r6lgRIMHTvkFbb/NEGty7D?=
 =?us-ascii?Q?DSDyRphomN5pc7RghoMGoUPRbS+6UXfo3IB1pGWKuk4JUTbnjZozIxsakqNk?=
 =?us-ascii?Q?x/oOlx+XSmsWXsyGEF2sRs61p6CC4JmbVZSO8GUiC8tVXL9qn6qqK20LMzK+?=
 =?us-ascii?Q?tLy/eCRaNTvE26B8RtIgIFWkGk1Sx5zJVoU3W3BSYrEABcmkv3OVDASpbFAL?=
 =?us-ascii?Q?/eNjOQ6xH/hvYvAt1qO5jydHmCZloINXXszzaYFHusSaL4DkBQZYVjVBW4Ai?=
 =?us-ascii?Q?MovjXEmMMaEYKiK0Mv5Fq5fbUe29nbLpSUHSIyMf1lhj9aBU6ACVB1nOT3C2?=
 =?us-ascii?Q?l5ZzvWq9DRRdW11OBO41hC6Hnn7tnTEMzYWFJ2lJXDoR59a0pGf9jU+pikvq?=
 =?us-ascii?Q?r+ZMDevnzektODjBGXVwDtadOqlIH8CNEYjwPMT7oviqEDBWjPawNQPGFEq5?=
 =?us-ascii?Q?kIhSFzQvlWg0OUssp02vCnpsRtTt4DnLENdZq8NMit923PUTauIAJo5JXVb8?=
 =?us-ascii?Q?Z8BG1W2PvkvMkLGx9cBD4kgt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5fd945-9cf0-4e3f-2d6c-08d91f3b8f26
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 05:11:31.3142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2UcUeEbUslk9NLXBPTQMaT2hTKO5VD+8t3mg7ejyGdpU2/1JxrR2gLtgHwQoICJ6LvysT80JChFQmm/NgLX+x7EtpwYmY15tF62WtKfny54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB7616
X-Proofpoint-ORIG-GUID: QJJndGXNmbVMdrV6xh2_HFg9b2SU34rS
X-Proofpoint-GUID: QJJndGXNmbVMdrV6xh2_HFg9b2SU34rS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_02:2021-05-24,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250035
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On 21-05-24 10:56:23, Pawel Laszczak wrote:
>> >
>> >
>> >On 21-05-20 11:42:24, Pawel Laszczak wrote:
>> >> From: Pawel Laszczak <pawell@cadence.com>
>> >>
>> >> Patch fixes the critical issue caused by deadlock which has been dete=
cted
>> >> during testing NCM class.
>> >>
>> >> The root cause of issue is spin_lock/spin_unlock instruction instead
>> >> spin_lock_irqsave/spin_lock_irqrestore in cdnsp_thread_irq_handler
>> >> function.
>> >
>> >Pawel, would you please explain more about why the deadlock occurs with
>> >current code, and why this patch could fix it?
>> >
>>
>> I'm going to add such description to commit message:
>>
>> Lack of spin_lock_irqsave causes that during handling threaded
>> interrupt inside spin_lock/spin_unlock section the ethernet
>> subsystem invokes eth_start_xmit function from interrupt context
>> which in turn starts queueing free requests in cdnsp driver.
>> Consequently, the deadlock occurs inside cdnsp_gadget_ep_queue
>> on spin_lock_irqsave instruction. Replacing spin_lock/spin_unlock
>> with spin_lock_irqsave/spin_lock_irqrestor causes disableing
>
>%s/disableing/disabling
>
>> interrupts and blocks queuing requests by ethernet subsystem until
>> cdnsp_thread_irq_handler ends..
>>
>> I hope this description is sufficient.
>
>A call stack graph may be better, like [1]
>
>[1]: https://urldefense.com/v3/__https://www.spinics.net/lists/linux-
>usb/msg211931.html__;!!EHscmS1ygiU1lA!WCxrsHL4OWKd3iPdyymp-dQlVCoiHM9QzjIZ=
PUC6-Dm6cnpU5CRLLOHrgiYSRA$

After putting online extra cpus, I've manage to catch call trace showing th=
e deadlock issue:

[  223.051673] smp: csd: Detected non-responsive CSD lock (#1) on CPU#0, wa=
iting 5000000015 ns for CPU#02 do_sync_core+0x0/0x30(0x0).
[  223.051690] smp:     csd: CSD lock (#1) unresponsive.
[  223.051693] Sending NMI from CPU 0 to CPUs 2:
[  223.052690] NMI backtrace for cpu 2
[  223.052692] CPU: 2 PID: 3053 Comm: irq/16-0000:01: Tainted: G           =
OE     5.11.0-rc1+ #5
[  223.052693] Hardware name: ASUS All Series/Q87T, BIOS 0908 07/22/2014
[  223.052693] RIP: 0010:native_queued_spin_lock_slowpath+0x61/0x1d0
[  223.052695] Code: 0f ba 2f 08 0f 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 07 30 =
e4 09 d0 a9 00 01 ff ff 75 47 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 8b 07 <84=
> c0 75 f8 b8 01 00 00 00 5d 66 89 07 c3 8b 37 b8 00 02 00 00 81
[  223.052696] RSP: 0018:ffffbc494011cde0 EFLAGS: 00000002
[  223.052698] RAX: 0000000000000101 RBX: ffff9ee8116b4a68 RCX: 00000000000=
00000
[  223.052699] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ee8116=
b4658
[  223.052700] RBP: ffffbc494011cde0 R08: 0000000000000001 R09: 00000000000=
00000
[  223.052701] R10: ffff9ee8116b4670 R11: 0000000000000000 R12: ffff9ee8116=
b4658
[  223.052702] R13: ffff9ee8116b4670 R14: 0000000000000246 R15: ffff9ee8116=
b4658
[  223.052702] FS:  0000000000000000(0000) GS:ffff9ee89b400000(0000) knlGS:=
0000000000000000
[  223.052703] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  223.052704] CR2: 00007f7bcc41a830 CR3: 000000007a612003 CR4: 00000000001=
706e0
[  223.052705] Call Trace:
[  223.052706]  <IRQ>
[  223.052706]  do_raw_spin_lock+0xc0/0xd0
[  223.052707]  _raw_spin_lock_irqsave+0x95/0xa0
[  223.052708]  cdnsp_gadget_ep_queue.cold+0x88/0x107 [cdnsp_udc_pci]
[  223.052708]  usb_ep_queue+0x35/0x110
[  223.052709]  eth_start_xmit+0x220/0x3d0 [u_ether]
[  223.052710]  ncm_tx_timeout+0x34/0x40 [usb_f_ncm]
[  223.052711]  ? ncm_free_inst+0x50/0x50 [usb_f_ncm]
[  223.052711]  __hrtimer_run_queues+0xac/0x440
[  223.052712]  hrtimer_run_softirq+0x8c/0xb0
[  223.052713]  __do_softirq+0xcf/0x428
[  223.052713]  asm_call_irq_on_stack+0x12/0x20
[  223.052714]  </IRQ>
[  223.052715]  do_softirq_own_stack+0x61/0x70
[  223.052715]  irq_exit_rcu+0xc1/0xd0
[  223.052716]  sysvec_apic_timer_interrupt+0x52/0xb0
[  223.052717]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  223.052718] RIP: 0010:do_raw_spin_trylock+0x18/0x40
[  223.052719] Code: ff ff 66 90 eb 86 66 66 2e 0f 1f 84 00 00 00 00 00 90 =
0f 1f 44 00 00 55 8b 07 48 89 e5 85 c0 75 29 ba 01 00 00 00 f0 0f b1 17 <75=
> 1e 65 8b 05 2f 77 ee 70 89 47 08 5d 65 48 8b 04 25 40 7e 01 00
[  223.052720] RSP: 0018:ffffbc494138bda8 EFLAGS: 00000246
[  223.052721] RAX: 0000000000000000 RBX: ffff9ee8116b4658 RCX: 00000000000=
00000
[  223.052722] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff9ee8116=
b4658
[  223.052723] RBP: ffffbc494138bda8 R08: 0000000000000001 R09: 00000000000=
00000
[  223.052724] R10: ffff9ee8116b4670 R11: 0000000000000000 R12: ffff9ee8116=
b4658
[  223.052725] R13: ffff9ee8116b4670 R14: ffff9ee7b5c73d80 R15: ffff9ee8116=
b4000
[  223.052726]  _raw_spin_lock+0x3d/0x70
[  223.052726]  ? cdnsp_thread_irq_handler.cold+0x32/0x112c [cdnsp_udc_pci]
[  223.052727]  cdnsp_thread_irq_handler.cold+0x32/0x112c [cdnsp_udc_pci]
[  223.052728]  ? cdnsp_remove_request+0x1f0/0x1f0 [cdnsp_udc_pci]
[  223.052729]  ? cdnsp_thread_irq_handler+0x5/0xa0 [cdnsp_udc_pci]
[  223.052730]  ? irq_thread+0xa0/0x1c0
[  223.052730]  irq_thread_fn+0x28/0x60
[  223.052731]  irq_thread+0x105/0x1c0
[  223.052732]  ? __kthread_parkme+0x42/0x90
[  223.052732]  ? irq_forced_thread_fn+0x90/0x90
[  223.052733]  ? wake_threads_waitq+0x30/0x30
[  223.052734]  ? irq_thread_check_affinity+0xe0/0xe0
[  223.052735]  kthread+0x12a/0x160
[  223.052735]  ? kthread_park+0x90/0x90
[  223.052736]  ret_from_fork+0x22/0x30

Pawel

>
>Peter
>
>>
>> Thanks,
>> Pawel
>>
>> >>
>> >> Cc: stable@vger.kernel.org
>> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBS=
SP DRD Driver")
>> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> >> ---
>> >>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++---
>> >>  1 file changed, 4 insertions(+), 3 deletions(-)
>> >>
>> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp=
-ring.c
>> >> index 5f0513c96c04..68972746e363 100644
>> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> >> @@ -1517,13 +1517,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq,=
 void *data)
>> >>  {
>> >>  	struct cdnsp_device *pdev =3D (struct cdnsp_device *)data;
>> >>  	union cdnsp_trb *event_ring_deq;
>> >> +	unsigned long flags;
>> >>  	int counter =3D 0;
>> >>
>> >> -	spin_lock(&pdev->lock);
>> >> +	spin_lock_irqsave(&pdev->lock, flags);
>> >>
>> >>  	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
>> >>  		cdnsp_died(pdev);
>> >> -		spin_unlock(&pdev->lock);
>> >> +		spin_unlock_irqrestore(&pdev->lock, flags);
>> >>  		return IRQ_HANDLED;
>> >>  	}
>> >>
>> >> @@ -1539,7 +1540,7 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, v=
oid *data)
>> >>
>> >>  	cdnsp_update_erst_dequeue(pdev, event_ring_deq, 1);
>> >>
>> >> -	spin_unlock(&pdev->lock);
>> >> +	spin_unlock_irqrestore(&pdev->lock, flags);
>> >>
>> >>  	return IRQ_HANDLED;
>> >>  }
>> >> --
>> >> 2.25.1
>> >>
>> >
>> >--
>> >
>> >Thanks,
>> >Peter Chen
>>
>
>--
>
>Thanks,
>Peter Chen

