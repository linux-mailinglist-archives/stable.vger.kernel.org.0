Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758FB43CEDB
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 18:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbhJ0QoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 12:44:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239722AbhJ0QoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 12:44:24 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RGZKXl027583;
        Wed, 27 Oct 2021 09:41:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=3fslI39LGFxCONxPHf3pgIJH+PJmClRXwWHeRTBpACo=;
 b=KK03VGVwPBsFma395J2WHSwe5l5fDQthrsgmL5siBhsLWjdYcqwbSbwI/QnN5LK4/9tk
 AsscnTEC1re5+3XDB7wCZvY3TT9TkhJtJ29G1/dfYNGYfChEIcVuMtN+2XR/EhjJx+Qb
 4Mqecn+L4H5+lIbNdouKONjJ08gJ3yg52oU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3by9w80pm2-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Oct 2021 09:41:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 27 Oct 2021 09:41:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H105IwVUv1b96mqtFgTs+/+kLAsr+Oy4hoEcZJxETTfMfNDvylA/HV+uvsQ0SgeYr8u0pJE+hQL9Kp1v/nROsC7v3mTaD0NDR3Q5fqWWx2MzYbDC9ox+FehNWJQpqvuDnUzbRJrixjr1AHlA2spFP2yOINwUyjSYxtAAkmOv6p99vsY4a99alWzZjwIVCYUUmeG023QM3d0i3/tY++Q8am6B+nnZ6fknI7BOCUjjvWaf56uPBNa+H3qiPvQffefk8dj+WDQEv6diF0ldF5AvoTo6MpFBtEgo5G71BaMScWMKVBXPYUg5J4u3//Dzs2V0OwgI58ScOAbiISlS7jXdFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fslI39LGFxCONxPHf3pgIJH+PJmClRXwWHeRTBpACo=;
 b=AtVuQBW8Ax84CRNlRZ68xEXcT4uMEfM9zGdEcjnzxFeWE1x1/Y9bRoQyoNJ8g495QZc9qe36vUD17llC/umZIYvtUY5PS3hb6y3IZMbH+VuXR18nWetckAsGfBtkTPANsKDu5dRBPC34vJHv/EYXPolOHHdVAId9BBAhQwfk2kGnxAMtmVzWCDz/bUGJZndjZv39goFC1RECsTTO30PZmSSLxeTIBvBFgQc6+8+283Z7Sf/wFI8KyYszYsse89lFZiitZ+xsSZHxpchwxpQs1UBD3pJoZgOxfXxjSEnrEtUV5NtO7NL17U+4O1IIiIEsqDdoNPYBxXTUD9FE+mTZJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5188.namprd15.prod.outlook.com (2603:10b6:806:238::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 16:41:50 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 16:41:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] perf-script: check session->header.env.arch before using
 it
Thread-Topic: [PATCH] perf-script: check session->header.env.arch before using
 it
Thread-Index: AQHXuOFH0MuKYzX2sEyZfCi7ygv5x6vm7aEAgABDrgA=
Date:   Wed, 27 Oct 2021 16:41:50 +0000
Message-ID: <806C5000-3A49-42B0-B0AE-7ED001CB11EE@fb.com>
References: <20211004053238.514936-1-songliubraving@fb.com>
 <YXlIhneZVyihywLt@kernel.org>
In-Reply-To: <YXlIhneZVyihywLt@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d8ee0da-53bf-4327-f460-08d99968accb
x-ms-traffictypediagnostic: SA1PR15MB5188:
x-microsoft-antispam-prvs: <SA1PR15MB5188E7EAEFB9B6A12B6BE288B3859@SA1PR15MB5188.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bet00dtqWX4NjmanznMBFBwzEiTsowtSMetr8HQmZQFLiHWJFrQKgBXg8jm9j+jSJgMxYOZ1g1PZb+IH5Q/OoxS6cQQUhzQT9lwagLpmKu6Uua9mjkbW7vaUneH3jh39x6B1qS0AI2A5eJuHHEHDAhipHO/vu03JyphoycdTKV2Pb2uM4CLIU7Cl7G0qqNnMmUH2TFIPxWYbCKsVobtUA2O9bPDQ2hmhuuH9J7iRcqfjEA8j/QvghnB8nNhsX7VMgAx6MDsnNlOBRNZwYSFLYnzXGGgPZZkxpF71Ie2nRtw8d2JBH8pBOTbg9Cs7+07kikOnu1DK7QBtguUVobWYEvlP1R8Xz4UFMgMtJFidrUwLx+aH5k7Z/PbF4b/eLBuIicC8ThQcCK4yXe30YZXcxR0DfKoB3X00iij0kT4fpsUXiiOhsX/MR35ia4ocXiAUlF2kwXJofmTbc2D9wlGht/Z4Jbq2Hxd1Q6dJ3mQlfEOC9ssrGuDRgaFx+FGy4tNO2eBSomZwVnocPsthgtNXb0L7W4Sp6IERqW+DL5FuXy19gd+uXZlIa3VIXo1YMS8e3VncfHvqRGaUoOarhbn+zObTTN9D/uIqOFXzMp+LanUAGjgFtkdR5koiMCpwlgBljCU23bdE4PIreBeUZtW/rB4Z692cXOC5olopmnjYkMcehUTpB4dK9ZBXwep3MkL3SBeQH6GFIgQ52IJGswMOssaPGmGhqRnww9MOirfta7K0yqz5mwyVGTYi4LKYVxAq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(71200400001)(6486002)(186003)(33656002)(86362001)(83380400001)(38100700002)(6506007)(53546011)(2906002)(4326008)(316002)(66946007)(66556008)(8936002)(8676002)(5660300002)(54906003)(6512007)(508600001)(66446008)(122000001)(64756008)(38070700005)(91956017)(76116006)(6916009)(36756003)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tQGtcBqn/Mrw5GLu5R/cxUVJHG0tD/xoo9Y2pn6VkDDa3jZsuHOECAPtZOc0?=
 =?us-ascii?Q?Y8mkgZHH4mFyS6hbFvAQtajoib3RQ8BCfCiC+qIHiHBbVMuOtjdn8m5vtHz5?=
 =?us-ascii?Q?S71d+4tHbLA0seshXulBt5HzUxU1bEHKmrZ4nPWf9wvZELj7rls2iCKmjwsc?=
 =?us-ascii?Q?UO4LekTwkdDxIXmtrYEQ4uWFdRWYe7EjO+ak2RJ+mR+xcmY5VpaQ+ETZrL8O?=
 =?us-ascii?Q?ce8E/QOEQTf4e9MFUwCn/5/LC3x2UEwh5v6KhK29z4XktgbMtrq6j+QMJY0V?=
 =?us-ascii?Q?ZwAUdma21eQ7heaHEYGXjWhsEG2/LkOD2h6m0xVLy/MdOm48Hz1GPHoDYe1v?=
 =?us-ascii?Q?wA7Bbr31ZKbeBqikzGERSpSGgEd9j1SYuhGhSlaAfXHwXEgbvI0E/ht+2C31?=
 =?us-ascii?Q?pP0OqNdNQighKtfngHX1FtmxcKfbN2c1/JXhicVLsufkfFQcKqfW63o887Vu?=
 =?us-ascii?Q?W9g7QgFIjQ+nHRDpJWicfAkyAxB0eiEbnEdZSNc4mu/pod9ak6LhksRA3QEC?=
 =?us-ascii?Q?kqFZjq//cLmfizjQKYfXsd+tmQZOkxI6M97pCXGvHH+IALNB2DIw0s3RkrWa?=
 =?us-ascii?Q?1fEoT9VdGDhoITAyJ4zET2V2LInuw10AgxmNV+I0YPeFSk3S2HaR/IVFFxCO?=
 =?us-ascii?Q?QpqBBvo6Zu5GVLlyLLuYTORWKf02NsgG/X6OKWLHyL8GCSHLr6AHv6HInzgN?=
 =?us-ascii?Q?VxvN1zdSmE5XAgqNn0/CCjNxx4gLDStJMPIwXndEaDb268BmBlp5NI9vhOvN?=
 =?us-ascii?Q?A2XeBbMrCcZNdmEdFhK12d2JwJ6ngZndfh211veXllo5QZjsP7xXm4iCSHEP?=
 =?us-ascii?Q?TxuJy9ZX5bCHeDSC/XRlAw7xUn+8x4jf6TKKdPIv0rN/mCTtX+2RxQeyiQSt?=
 =?us-ascii?Q?Hbz4fJF9Upi+ym9HA3HgjS9UxIvxs8/1RgSMJ8tOuAcNbmdrVRCEzD+xkETr?=
 =?us-ascii?Q?DlbLlX0ay7uVwCf2sSQIp/jbYa7+Egjyd4IChshevYe7tXSv7rdYWZ2dxcBB?=
 =?us-ascii?Q?rTegD3aK91mbGib7zdWblGpF7l+roskv31zN7RUDZv4U8HuPLpDamECZWtuq?=
 =?us-ascii?Q?2S2Ht/NpMWKKZP1oxuAtviAHx1+zarkVKwWNn+zNhLQZdcfmuvLBmXGONMT4?=
 =?us-ascii?Q?aY8caPhCjiKAKy1BoPaIr8r9GpF/n99DB/W6R0G6ZFU+ZqpXBdRn3MmOpB00?=
 =?us-ascii?Q?KZcoBmD4DmSEghuyBjzMoquSCVwyd5N976itjM99O0y5I0xS9ysu+8FzfXxh?=
 =?us-ascii?Q?EUXpaeHKclX4gZhrN6hK+yh6Q+vQdtnQmk3BYj0O4htHsj1Y6QyYy9Xg0NLa?=
 =?us-ascii?Q?xN7pzSlZ81iU2NR+huf7XaBepmokAKtKIIfyo7pxP3C+EFjLivc9IIewruIq?=
 =?us-ascii?Q?XBeQUuBTrwKECOYvWhWd+upidK5027AA6Pw86sbKDjtPJ1gFcQSLS4/b7T1R?=
 =?us-ascii?Q?g/8Mc538FDURVUZGpQOzlmssuxck5plcj+QVuDo8eJXyQpVMZdXgUgdf5mYw?=
 =?us-ascii?Q?00BrFzzDjsq9No54LNUrAZvxqR7s12Cd5cuw0ItNY0pXe5Gm9NxNTMs1U8O0?=
 =?us-ascii?Q?cjhRahTl3x9TnSO2Iawa2iY2c296zQHsKe3r+R2prUuHlBntCEoHs5gEHBkw?=
 =?us-ascii?Q?hrwra7Sv3sFV2skgEEQ2TP0v0enNC0iQ2nUmo5Wz0mdlBTs8KZdwz/P1QvOR?=
 =?us-ascii?Q?XKNo5g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB2AEE0583CDB54E87FC802C55A6901F@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8ee0da-53bf-4327-f460-08d99968accb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 16:41:50.3485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: syd1A8SGjv81msHYvwjcrXolh2PnTj4HSCAN5y0qWQPIaLVqm81fBPJOza4zUdPUkv2n/j9+47q6k45tqOMaMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5188
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: C1FafqcmEP3xCHU4BUi7WTgVBcrRgWkX
X-Proofpoint-ORIG-GUID: C1FafqcmEP3xCHU4BUi7WTgVBcrRgWkX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 27, 2021, at 5:39 AM, Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> 
> Em Sun, Oct 03, 2021 at 10:32:38PM -0700, Song Liu escreveu:
>> When perf.data is not written cleanly, we would like to process existing
>> data as much as possible (please see f_header.data.size == 0 condition
>> in perf_session__read_header). However, perf.data with partial data may
>> crash perf. Specifically, we see crash in perf-script for NULL
>> session->header.env.arch.
>> 
>> Fix this by checking session->header.env.arch before using it to determine
>> native_arch. Also split the if condition so it is easier to read.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> tools/perf/builtin-script.c | 13 +++++++++----
>> 1 file changed, 9 insertions(+), 4 deletions(-)
>> 
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index 6211d0b84b7a6..7821f6740ac1d 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -4039,12 +4039,17 @@ int cmd_script(int argc, const char **argv)
>> 		goto out_delete;
>> 
>> 	uname(&uts);
>> -	if (data.is_pipe ||  /* assume pipe_mode indicates native_arch */
>> -	    !strcmp(uts.machine, session->header.env.arch) ||
>> -	    (!strcmp(uts.machine, "x86_64") &&
>> -	     !strcmp(session->header.env.arch, "i386")))
>> +	if (data.is_pipe)  /* assume pipe_mode indicates native_arch */
>> 		native_arch = true;
>> 
>> +	if (session->header.env.arch) {
> 
> Shouldn't the above be:
> 
> 	else if (session->header.env.arch) {
> 
> ?

Yes! That's better. 

Do you want me to send v2 with the change? 

Thanks,
Song

> 
>> +		if (!strcmp(uts.machine, session->header.env.arch))
>> +			native_arch = true;
>> +		else if (!strcmp(uts.machine, "x86_64") &&
>> +			 !strcmp(session->header.env.arch, "i386"))
>> +			native_arch = true;
>> +	}
>> +
>> 	script.session = session;
>> 	script__setup_sample_type(&script);
>> 
>> -- 
>> 2.30.2
> 
> -- 
> 
> - Arnaldo

