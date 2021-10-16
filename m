Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915BF42FF92
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 02:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhJPBB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 21:01:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63700 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234607AbhJPBB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 21:01:28 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19FK056g002528;
        Fri, 15 Oct 2021 17:59:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=c40t2Bc4Y3u04qXkP9It/KUs+KWl8A6DiipJaCTFCvo=;
 b=NaCzdQlv6xrbpTlxwmpCUuIpHUtG+po28AXuYRBi21pSfJlRQZPNN27PI3bnXAOZQbzj
 NEbqWm3qKP6iSHmHrfktRguetRjQsifT09JelUjeQAxCykY3uqdzk0oDIT5bx+aTtB0n
 MbL44FjlY2CuyHAzQLf12kWbEBwtEtG3ESQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bqg5vsnj0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Oct 2021 17:59:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 15 Oct 2021 17:59:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ0XpEgGj6S8gyHyVI9XwzNlkpFOGINmUAgOrrblguTeR6uXUe32PqUnaCR6u1hDzzJ1bOZ1GAvnFC5zZNu+xMOkAQTqh8ksn4rNDPczT64m/J8KskLGI4R6z+LawvEY2lc6SYqzSLTgQz9BGFJCtcuwrxuFsCdgoSvymd+mw2EdgzLLWTap7wzkHOGRa6jJTK7ZYnxB5Bhqh3DgNuco5eZYgun8VQkYTiV2lv8U04Cz2C84CBmdJ0WqYCaUbvWCx2wy8i9M0bCGBtQY7Dp3f7W+JTky5SmeFbT0p5SuWov0naLhKJJca6KVuUKKyF6tUF2S7g0/Xs5UXRiKNwaytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c40t2Bc4Y3u04qXkP9It/KUs+KWl8A6DiipJaCTFCvo=;
 b=FGAlbIhk3JcD5ZD4xFs5SygygSok97Wg/oyJfw+f0Kj0AmLIdNjUC8Q0AU13K7gheaUM0Vix4P5AX8lODsvxsCVlU/+ZnfFsimZ9oNDPKry0SrjRnTmNBTqpaqotLShCdsW6hSLuCY6j6xryXUaeaqM+l1BaGz9MbgWWMcZsf6l3htBOj9W659neshNEoynO5Q8FoBTttP599E+aeEUpkSIiaSywmQshFKxg4Jgr60Auw6k/nkGUFRVjkGWw6XWN3VYnItOSgWegOp8g+oCwoPiSBp3vWrvMzbJ8doYW6Qpe6Svdw6XdLZsfXLN461sNeUKlSGiQmoBfuWE8t08ntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5139.namprd15.prod.outlook.com (2603:10b6:806:233::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sat, 16 Oct
 2021 00:59:17 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.017; Sat, 16 Oct 2021
 00:59:17 +0000
From:   Song Liu <songliubraving@fb.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] perf-script: check session->header.env.arch before using
 it
Thread-Topic: [PATCH] perf-script: check session->header.env.arch before using
 it
Thread-Index: AQHXuOFH0MuKYzX2sEyZfCi7ygv5x6vU4FGA
Date:   Sat, 16 Oct 2021 00:59:17 +0000
Message-ID: <18D8F9F1-BF41-4C60-899B-53F6ED76FB2B@fb.com>
References: <20211004053238.514936-1-songliubraving@fb.com>
In-Reply-To: <20211004053238.514936-1-songliubraving@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20adf06f-c66f-4051-8af8-08d990402deb
x-ms-traffictypediagnostic: SA1PR15MB5139:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB51392AD8440D7CC8AB2363C0B3BA9@SA1PR15MB5139.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /RiltQJT7F2JMYJymd3q3MJ7E4ewTUL+v0op3zVtSa15MIR/9CoKzuwTNq0a3fpIgEeysEPGY9FOVxXwr/8D84XM+4Xzx2DgNqVZWRlvn/TMfxDlgaDGhGrNMu9Mg8Y7gSLMTpqAk7nohHzmFezeTML4AFomg6iEonzbClZQxU6C9p3yhucUfH9s7JvR9xLJARc8gCTgcGCzHaF/TLk1pG1OQezNcVAJ54x4A/jt7KMd5IjJYUkhjL6+qpbUBgJ/EwaI3Yw1C7EE5jSYwkWzAHVOemZxAUtlYwkhZSP2m2RFlJkJNz53agXwzgsElNeZvPPBv1sk8PHuCh/eZv+HDQdKk7QBgbOm4w3K44idTkQgVJes5kNzyZc0RAzvRsATWAzftJDrDhTdgnErMqQxHDPcB4xnDN3WRIxbLOcgRzqpPefc/s6uWSGfG7N1x//HzWv157xxuzP6dQLcptfl4tHTup1vTF+V05nw7PCJGNJdgjkYNL9EzHkaPGusCOfMl4SAhOMS2xFD6KI3M8fYbqtSs3AVnL/3K5Cz/U73YKjFdMCCCNtO37X2rRT8o0fXVnnWPkrO+AE2YDn4UAF/9cNZXZt5ux8B3SrKCG9wnhO07FUsSRzWesv2PQvBTO//pRItEEXbX+azvH5zhNrU/4jjc3CnEbHoBh7y13jzNzurIIK04mDIiJyC+AVzXfR2cpS6FkEwSMTJDLsusN0U/mTGnnk4i0qEDcjc6dCJk/ESCfVekckR7uMOYy/3gzg3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(316002)(53546011)(38100700002)(508600001)(110136005)(33656002)(54906003)(122000001)(6506007)(66446008)(86362001)(2616005)(66556008)(6512007)(83380400001)(76116006)(66476007)(6486002)(91956017)(64756008)(66946007)(8936002)(38070700005)(36756003)(8676002)(71200400001)(186003)(2906002)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l+ujdOYkpiv67+rjwQ2kZcwNS93sVCQOL8Ymr3CTMH4mWerv02vl9sx3fDFD?=
 =?us-ascii?Q?wKcAa2/amsSdGZJaO84U/hTDfui9KSTMIw7uxFsdOVF+mW48TgH+ZQ87Tn+p?=
 =?us-ascii?Q?1+WqamcNCWt5jipqiI34r8ZRaIu0Mfmk5cSGcl9hshvhnPlJ1QxRlJImXtE3?=
 =?us-ascii?Q?TnjOQePB+6FJ2Amlqcb3K8zFnjsBkXrOuIm524QbFwj41hM263+rj3zDJl3N?=
 =?us-ascii?Q?HUwYa8Cnkw2Jz/6JMmEBU1US4ZccgpEzn+t1y8NRe53nGwUJmoHY1G6VbkwJ?=
 =?us-ascii?Q?Glw4LlaVUKNHk1//z+2MhM31mi1NOclGjzT2Fan17TV4LFyeGh7w20e0obZ8?=
 =?us-ascii?Q?3BcuXh9DyMMHvv5WWiuvemzMesNluhFA+ycs8YUz3SCwpIQ4UTLeVT9EZpGH?=
 =?us-ascii?Q?PyyGT7t9XWItR9pGoVPxSJhsSRQ0xg8RqVl1z1Pw6zH5QiftbZmduST2af/H?=
 =?us-ascii?Q?6OZ7AEZEliqI9HG4rN0MGf1zSZZSskLVp/iUXoMBl11tRsdYa5cja2O0NNJ6?=
 =?us-ascii?Q?Xvxsuq7bdH2pzDYorR3hMoE1cr22DuLHh471n6WAHzs1X9DmDXWA8eLF3ILQ?=
 =?us-ascii?Q?fHzI+3Zv6ctPQK72jX3EkmqNcNdVlKlgvE3Hk5zM2TRjFLIYOn/+f45nwtSS?=
 =?us-ascii?Q?1FYhinT24fMcg5UTJVEGWil9lDZH0tDiNjRH6HqL8yU/5Af7iq03Fk34bw2G?=
 =?us-ascii?Q?pP4WTlrsHlyI1j1vWKjvZlM+R7fyLSoeUbLmpbQzrahE0ANrbOagWsJm7EAo?=
 =?us-ascii?Q?folzgdWzfKFQNbjHi1tJQvY6TLxRixf7H0yD3O30dp0NFCuGI7+q4zgkfr//?=
 =?us-ascii?Q?i1xtM2+GPUBQsh3Ci7EkUQFXGvuYW2kVhDW9Guw8nmZOmSVgXEtNB88/K7U4?=
 =?us-ascii?Q?8mg6dkMvfxbaxaTDw7LeDgvqlRDeFCFiDQ+WfjBGjGwx1YBWSgXFBE3qmMsY?=
 =?us-ascii?Q?1PAuFxupMd1opM21N0sD+bmiJ2Hsojt+CaRlltEDp24gfM500tROjgfeTo14?=
 =?us-ascii?Q?YM9VmfxshK1bcjVr14INMskREqqY+5YkMshre4/D97wJtl4LxxdvZd5wMahR?=
 =?us-ascii?Q?CrUrTRVrQoWMEsrRYfgA83G39qcZiGb8q5zaqn13YhZZuLwpBp67rotTQh7l?=
 =?us-ascii?Q?/BpcJJCCkCs4QlPt6XWElaWPiq+15wSoYx4fYKfoKLnNRCEpgxyz/vpT461v?=
 =?us-ascii?Q?YwwgpWjda/zfyrs0LGLg6Cc64rVvp0D2CW53rW9jQvsx1aFp3spW7XpZ8h+M?=
 =?us-ascii?Q?emFrMS5uIK5+VyXQqQpiMV1HiIpM0TStdNd7GinTVKhwSRaRba9UGlXh9nBe?=
 =?us-ascii?Q?SsNks+2PxmmfZtwQsc+oXBTPHISgcWPXxTjPOgP87xkFCFtPNLur2x7FB77S?=
 =?us-ascii?Q?LyO2Iok=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <397D536AEB299B4D86F780A9C15DCA7A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20adf06f-c66f-4051-8af8-08d990402deb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2021 00:59:17.1218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UDorqGoTgG0M82OKLbhqXWmlcAyfxLnfNgnDajTyzjSWWCo0Qi6/6QMLJQDq5enxhvd8SyUC7ht7a1/1p0VkIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5139
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 6_JAEfVX2PBq-RDKZET83ATkG-qcAT6D
X-Proofpoint-ORIG-GUID: 6_JAEfVX2PBq-RDKZET83ATkG-qcAT6D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-15_07,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110160003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Arnaldo, 

Could you please share your comments on this one?

Thanks,
Song

> On Oct 3, 2021, at 10:32 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> When perf.data is not written cleanly, we would like to process existing
> data as much as possible (please see f_header.data.size == 0 condition
> in perf_session__read_header). However, perf.data with partial data may
> crash perf. Specifically, we see crash in perf-script for NULL
> session->header.env.arch.
> 
> Fix this by checking session->header.env.arch before using it to determine
> native_arch. Also split the if condition so it is easier to read.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
> tools/perf/builtin-script.c | 13 +++++++++----
> 1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 6211d0b84b7a6..7821f6740ac1d 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -4039,12 +4039,17 @@ int cmd_script(int argc, const char **argv)
> 		goto out_delete;
> 
> 	uname(&uts);
> -	if (data.is_pipe ||  /* assume pipe_mode indicates native_arch */
> -	    !strcmp(uts.machine, session->header.env.arch) ||
> -	    (!strcmp(uts.machine, "x86_64") &&
> -	     !strcmp(session->header.env.arch, "i386")))
> +	if (data.is_pipe)  /* assume pipe_mode indicates native_arch */
> 		native_arch = true;
> 
> +	if (session->header.env.arch) {
> +		if (!strcmp(uts.machine, session->header.env.arch))
> +			native_arch = true;
> +		else if (!strcmp(uts.machine, "x86_64") &&
> +			 !strcmp(session->header.env.arch, "i386"))
> +			native_arch = true;
> +	}
> +
> 	script.session = session;
> 	script__setup_sample_type(&script);
> 
> -- 
> 2.30.2
> 

