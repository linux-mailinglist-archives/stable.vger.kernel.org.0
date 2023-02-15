Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E166983F0
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 19:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjBOS53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 13:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjBOS51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 13:57:27 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18C23BD89;
        Wed, 15 Feb 2023 10:57:24 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FIBBM9015918;
        Wed, 15 Feb 2023 10:44:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-id :
 content-type : mime-version; s=s2048-2021-q4;
 bh=9jgX6mIErNhpYzTd1ow3L67qwZwwO/qFGKr7/M/jtEQ=;
 b=K/9g9ayec+7Ojo1h/LrWnbNGF55KowLwtxRs+yJHokh1beV10XnkBK+fs9L8me9c6At2
 VDZ+h+LdyTOiX6R2ALt7xb3j+yu3GRPsWPiW8UXuNu8GIjgd9DvmThw4uiXApACkf7Vj
 QnoPTK5LKoqBsFkNPZWTDdShZW3/y1HLu24+w/sOXUwnJrcQhhK9c9Rkly6WpxVTXJQR
 pzKCS1G435LC9K0ncq1C8SCqD1qj6M2BJ+1MFvSTqvn9u5pWColO3P3AOJyqLa1hMwtF
 /SzaNbo517KWz3xrVlb0wFv/lKzSRvHEDnVKkYjYZ90QJxJ68kj3JHMn4xeWxGzUeykq Zg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nr80829fm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 10:44:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKho5TLG+sPYKa/P8pxuzRg8VuyJUVSkrWsO9pUhemBJ59yXhPLEtPrfkdHSu1GFTi0K43wmdeKMN32qfx71/v4n8ZT3xxF6JtTS4Lb2/dSHwU0Xtaqokr2UqY3tadpKCMtlhUPge9xyY3fae6pW3dhGm46GFwZfBbYfNcsToFG3k3pltygONxmX3Ea2kKlMtUP039c9CAqSw0uMiiGpQzfOpNFCm8UB3GB6tfeNj4inCzd2OV5l3hmge1MCBVhxdhjKvAkZ0+EeBurNiIBBvolE7/M9a3A3sGiVA4KzsqgclfmuTGEXwNHwKKRg4DapTFfcxxAOrH9aWw/mKn7V/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jgX6mIErNhpYzTd1ow3L67qwZwwO/qFGKr7/M/jtEQ=;
 b=BQgOKp1oSKlxeeDcgupCi5COy0SnMQXCVheAHT/KvTzUcq8g7ELngJLw46wloolWnU4CxqmMx7kcvdv3bXNEMBQjJv/txZMrA9kd8br68e3S+2qU4WyOZFLedYh5bnVOUHRbQRI4DKYS02hmb5YFIWpwPRTPJkZgHHWww9ZaNRVtsqNTS+vaFYgg1D/Yagqb9CuPMJrUJjOjcDDtgM8NI0E3s7p2YkZiQDZjSDfu3SmPCxxGt41mL7QAsZYUzxNlF+mAE3ZZQYes8Ab+HnNC9eSqYf/Y9WuZQ591H+NaYlpun/zIGg5U9CQ5PYwCxBoiC9hxg5xVhOX4+j0mVR7Zlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BY5PR15MB3667.namprd15.prod.outlook.com (2603:10b6:a03:1f9::18)
 by IA1PR15MB6222.namprd15.prod.outlook.com (2603:10b6:208:453::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 18:44:06 +0000
Received: from BY5PR15MB3667.namprd15.prod.outlook.com
 ([fe80::3c30:391a:54a2:5d3f]) by BY5PR15MB3667.namprd15.prod.outlook.com
 ([fe80::3c30:391a:54a2:5d3f%7]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 18:44:06 +0000
From:   Nick Terrell <terrelln@meta.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.4 09/10] s390/decompressor: specify
 __decompress() buf len to avoid overflow
Thread-Topic: [PATCH AUTOSEL 5.4 09/10] s390/decompressor: specify
 __decompress() buf len to avoid overflow
Thread-Index: AQHZPHh2gr/vRn8GDEKm9yLbCMBoaK7QYfkA
Date:   Wed, 15 Feb 2023 18:44:06 +0000
Message-ID: <E980B710-F76E-4535-A93D-10558A8B1521@fb.com>
References: <20230209111921.1893095-1-sashal@kernel.org>
 <20230209111921.1893095-9-sashal@kernel.org>
In-Reply-To: <20230209111921.1893095-9-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR15MB3667:EE_|IA1PR15MB6222:EE_
x-ms-office365-filtering-correlation-id: fdb7ed21-75b6-4566-5be5-08db0f849e42
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LRpR6N1hh5lsxCe6HnJQpVIskyE0EXwnvfzrsDNNKEs1ZpQ+bsEULlppz0nd+2z/fnhiLCkd5RR6izOpvHZULBxW3Y+dKRMIYq2qmXSFR8TjjoXEsNSwIZn+yK0l9STnw+AXGQILeE0u5SIKpuLRap/dfO7gS/s0se/6c4iYp5duHeB4bM4M3B4Uzpu6F9aoNYDYEux+GkPahw6lLtxIOP6hupZUzDWxXyWP9E65FvGmW5dZ5Zv0GZ8NReR2pAJ/CYhtxrP5KdPuVeWgMvGQFcHWHuIblWVeiiZ8sgUFMPcEwYrNUW91k8JobgAwqzZiJfkSJxv7H+pnEHXJbfYTmqjw5CbqCJ99ZyAXxI9jOQaXkuokYHuRXTz97ILMy788Ju695u87imA/8gWaxjIR8tj+2uTR/UKZuvCoOoD6BtCtqe79pMB3x5Chf0ENilLHCVUR4A3R9zNCW7Ulu4cJdKjIqr1qcKK+DnLlzd7+0nmzLp9wHlISYNlvs+FRPOlW0w9yM9a5yTJKEghFuo1qnl6RmR1FUqpozrVM7DvZeXWIeFy1VyufRyU2vuc/Jhu5/5dk2y+qv3cle34mFYpJF5jLG79ira1JzVOvCaG3jdysu/H2/YURyhjoSBEokcZXHRxjF0peikP3nBxqgFxvbH5DXiU3zytzUyDo+5YozZYKOT65s6qNawKpk1NMfS0XKJS3KrRudkRZHhe/E84EWsTf6xszK4sA/sPA1zTIsXo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3667.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199018)(33656002)(54906003)(83380400001)(478600001)(6486002)(71200400001)(966005)(6506007)(53546011)(36756003)(186003)(9686003)(6512007)(41300700001)(38100700002)(5660300002)(8936002)(86362001)(38070700005)(316002)(66476007)(66946007)(66556008)(2906002)(66446008)(4326008)(6916009)(8676002)(64756008)(76116006)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1hrxRCbQFk/6U/ReBLP97Hh94ekrL2AQnJewGt4sbRJcEhMoDMBcPJskPyM0?=
 =?us-ascii?Q?US7kyXUMUbJsKsUemeYAqgU8MXGew00zwvXN1S61MwYlRywY5YSxMp91xT6G?=
 =?us-ascii?Q?zTbGKQIOrIHkN9bhbcNETPw4cyoZMFCncrr7t67QprMDEMag24Su5v/A90Qv?=
 =?us-ascii?Q?MbUDzHsuY5qdNafnBf8KECIUzAxiH6W9G+EdqJu92/tEcnmuVMBfC/5tpu2u?=
 =?us-ascii?Q?//whorjv5UInRm7aIZDFfOdNho3rMFVrdRxPinw8rJ96hEZcF6LF8bMTiIxU?=
 =?us-ascii?Q?UDMom/2PxqmYQgDBBv9WAOkJzeMv/Ae7IjXzQDyFjAvD8HFlyAs94Q81hpUL?=
 =?us-ascii?Q?BW6qquAMiCexLM/8SHNqShIozaA/EtIrtYehRajMaorAwFgSEc2IAIl+mA/L?=
 =?us-ascii?Q?AWOeqbA1foooioAKJWmFqZiRdJuSfFCfzCrcsq+zMgWI1h76uH0uYHnjIyHN?=
 =?us-ascii?Q?lyqQpOa1rnHYP/uqEtKHAmUKpwNvGYYeB8YsPvtH/Sv7t3ZD0jLFdYljpcs+?=
 =?us-ascii?Q?K3A6Y1Ee7PwAsoPhKCB5p8IjDqbftbCowaWcdoC4ET+y6ud2o55CNuci7mIQ?=
 =?us-ascii?Q?y7vUmqt6wUMmqRjMJRnQY3hLFn60xkx6l8l52/R086bcZJNvlhVDiKhsoHvU?=
 =?us-ascii?Q?IQmk4ARQz/zxfcLZXmTljkco7x7aCQU+UY/qOVhhR9oK7dr2Y8w+lEV+N1ao?=
 =?us-ascii?Q?CGnhBVBAYbgVkIMlAA06xZbzXM6ZpgzXbzR6/72DpmGQsqcYTSNTjH/Luiat?=
 =?us-ascii?Q?myLnVBLFh+NpPx6ettYc+MzwpRg5U34Ro3zvicR8Nvc9QJ+LyF0UKn4oj51s?=
 =?us-ascii?Q?cspJZVRsiXwYOcgIF0Cbmd0EqwkNBo3G6YfpIeUszxpAidQ6CIScV+jkZIrR?=
 =?us-ascii?Q?O+wZEptcfN67OQ7N3ZVVJOzM/ySBNTha1M//ORqr3sNvyKYL4bwpAsYVKMnj?=
 =?us-ascii?Q?GWFWyUPzOyHbcjBavmGCzQ/0KPBOJcX1naV9tlg6AsBdO2D4Jsq2KSoGVs93?=
 =?us-ascii?Q?EnUGRozcPh+wGd7ce8OsMLcPjQBIloUPthTEKkWD45Dmn7LW3isM0rPqGR1z?=
 =?us-ascii?Q?YsyoW/gkFCcFArzOGmEbxw2yuId3j0k6McRO64tiRwO3KhJLM04wKpIBbEYP?=
 =?us-ascii?Q?pjv90WsO7/S0gJZygPOIipIfqZkRntTGMSJe5vo0K+CzF773b105QyrZ3y/D?=
 =?us-ascii?Q?YGHWKcNUFsJIlGCZVCuaOro+B7y5pyQhuyMUbuJPvyoIAnsrvNQjY2CUG+o2?=
 =?us-ascii?Q?f5jO08qSbZG/BAr2UAN9tFS+036DUkthvF1SBFpkSVpdQN3xxDbzSq9+Gphq?=
 =?us-ascii?Q?VHWSFEa1GRRG3aFGD1ZV5G4pg8avTHjFqQZnCdsefg5B74LNiRWULsJrKi8P?=
 =?us-ascii?Q?2bcBowFthrEh5fpE8ha7JteekkAJhXDEO91npnFQE4lrrHbtT08ipdSaQh5f?=
 =?us-ascii?Q?JjqypD4yvEeZsFOlcD+5k+r92MsJHEUfsXzEz7ws3PKtcAvT6WD5/+FBDtVm?=
 =?us-ascii?Q?9kzo1XnkKQX4dZw6CfBri7ydkJLeOw+nGCPDgbtV2Y9GYachjm1MdTSbcN14?=
 =?us-ascii?Q?pZbubTOLQN7dyEUsqSMbAlkjdjGInGC04/pKjzHAAmtlo3mGNtaiZf5asBd7?=
 =?us-ascii?Q?D/6p+WbAMbyRSN85By3VgDw=3D?=
Content-ID: <A8B485219A64314AA631FBE62E22D1FA@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3667.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb7ed21-75b6-4566-5be5-08db0f849e42
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 18:44:06.7837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FalWVHhWuF2y5w/PbnR5gMFuzmKag4qfxhBxRv70qugsey4xH+9n4ig3IQRddUM9TCnIAzSHzRMUTg66IQwdfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB6222
X-Proofpoint-ORIG-GUID: WEGCkRBs8i83opQPoVFzGc73s-Qft6ST
X-Proofpoint-GUID: WEGCkRBs8i83opQPoVFzGc73s-Qft6ST
Content-Type: text/plain; charset="us-ascii"
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_09,2023-02-15_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Feb 9, 2023, at 3:19 AM, Sasha Levin <sashal@kernel.org> wrote:
> 
> !-------------------------------------------------------------------|
>  This Message Is From an External Sender
> 
> |-------------------------------------------------------------------!
> 
> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> [ Upstream commit 7ab41c2c08a32132ba8c14624910e2fe8ce4ba4b ]
> 
> Historically calls to __decompress() didn't specify "out_len" parameter
> on many architectures including s390, expecting that no writes beyond
> uncompressed kernel image are performed. This has changed since commit
> 2aa14b1ab2c4 ("zstd: import usptream v1.5.2") which includes zstd library
> commit 6a7ede3dfccb ("Reduce size of dctx by reutilizing dst buffer
> (#2751)"). Now zstd decompression code might store literal buffer in
> the unwritten portion of the destination buffer. Since "out_len" is
> not set, it is considered to be unlimited and hence free to use for
> optimization needs. On s390 this might corrupt initrd or ipl report
> which are often placed right after the decompressor buffer. Luckily the
> size of uncompressed kernel image is already known to the decompressor,
> so to avoid the problem simply specify it in the "out_len" parameter.

Thanks for the CC!

Reviewed-by: Nick Terrell <terrelln@fb. <mailto:terrelln@fb.com>com>

It looks like s390 doesn't use in-place decompression, but x86 does,
and we'll need to backport upstream commit 5b266196a [0] to make
sure we don't overwrite the input buffer.

Best,
Nick Terrell

[0] https://github.com/facebook/zstd/commit/5b266196a41e6a15e21bd4f0eeab43b938db1d90

> Link: https://github.com/facebook/zstd/commit/6a7ede3dfccb
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
> Link: https://lore.kernel.org/r/patch-1.thread-41c676.git-41c676c2d153.your-ad-here.call-01675030179-ext-9637@work.hours
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> arch/s390/boot/compressed/decompressor.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/boot/compressed/decompressor.c b/arch/s390/boot/compressed/decompressor.c
> index 45046630c56ac..c42ab33bd4524 100644
> --- a/arch/s390/boot/compressed/decompressor.c
> +++ b/arch/s390/boot/compressed/decompressor.c
> @@ -80,6 +80,6 @@ void *decompress_kernel(void)
> void *output = (void *)decompress_offset;
> 
> __decompress(_compressed_start, _compressed_end - _compressed_start,
> -     NULL, NULL, output, 0, NULL, error);
> +     NULL, NULL, output, vmlinux.image_size, NULL, error);
> return output;
> }
> -- 
> 2.39.0
> 

