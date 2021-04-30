Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D032436F598
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 08:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhD3GLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 02:11:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55958 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhD3GLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 02:11:22 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13U67qXK002559;
        Thu, 29 Apr 2021 23:10:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=o3FIU054a1dICRoT83SItvustCc0szB4CcxBKjzVWcg=;
 b=Yylyw1c+7y8xz/97K6zv90vGyoFTTxa8H2SQu6NEIsfYK1G2Om7uW3vZZ71UmCXKBbCd
 Etr2GL8y5oRTjJ9LzZMXFMwsfVx1yq2iTUdq0O/wd0XRQhVF5VqwWMeROB71JLnxGDOa
 86Ir1FHMXF/4mEtIy/nfD/hEDEjFxn/1ZOQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3883fqtch1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Apr 2021 23:10:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Apr 2021 23:10:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zvf8vq7Ojo5ECnatisysKP+i22QtJus/cemNqci7Me/YDm2RmRm7dnxBVhZA0pgaXZTNRtAYstqCAVbMUwR3PNFvyXI39hSnQhuhszvuZyV5soXMCmXRPP90Jvli2gY1WLWy3dGwSIjVD62Y7zU1mqc7oiH8sH/4oIRG5icWPzzPezfSJ3dZEy4KUphiPWE3sHMXvIMG03/O+yYP5rYQVf3nPJygJG6G4IUxp5mgH5w9qhiJX464QulEb3SYpOJJZ0cyjGFprGCj/doxusoa/as3k/tNXzhvQu4tSyonXxFeWrUAR7Wu++2BbWSfDkzZRWzE8E+0TdnPv9/c7bflhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3FIU054a1dICRoT83SItvustCc0szB4CcxBKjzVWcg=;
 b=kUQboANjrZt/OfoqifPC8Lg9PBKhGtCyTwHWSyaCJhd1N4Ss9uAKo1ZSR+EwaDZTaeUpAUpkAP0+EmQOAzzdNWY3jfBP+4/KDLPnzzW1MMyBdOTj0xRWYknMikvpwu4+M3SmW2mDNFZmWe0r/DhiAgCHJbuppgK6F+E9JWJoJ00CFIQb9428ySM4SdK3rJtwHtNQ9FX5QEEFbjCVZsTCgR+Sh35GlLy0DJ9Nd0kLtDMR3ImLaFZx+Q8j4eCQ3vpuElpaXIag22v5Oc5QlgqMAPyAd50/NYy47VUX2+YRpG/b1y6VmJO9aKXpDeSI6foje88buQTJPauAj6SBdrmWkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY3PR15MB4977.namprd15.prod.outlook.com (2603:10b6:a03:3c4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Fri, 30 Apr
 2021 06:10:25 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4065.033; Fri, 30 Apr 2021
 06:10:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Guoqing Jiang <gqjiang@suse.com>,
        Aditya Pakki <pakki001@umn.edu>
Subject: Re: [PATCH 134/190] Revert "md: Fix failed allocation of
 md_register_thread"
Thread-Topic: [PATCH 134/190] Revert "md: Fix failed allocation of
 md_register_thread"
Thread-Index: AQHXNq9BJ7/u/5Jha0OLmyLLbbYM+6rJdjEAgAMrdAA=
Date:   Fri, 30 Apr 2021 06:10:24 +0000
Message-ID: <14DC41E8-99F5-491A-93EF-598D10E381FE@fb.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-135-gregkh@linuxfoundation.org>
 <YIj2nsovH/+ujHL0@kroah.com>
In-Reply-To: <YIj2nsovH/+ujHL0@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c8dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81010c5b-7f1d-446a-4655-08d90b9ea519
x-ms-traffictypediagnostic: BY3PR15MB4977:
x-microsoft-antispam-prvs: <BY3PR15MB4977A710EAE24F04B422B068B35E9@BY3PR15MB4977.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WDiZLk2zM76WxfcQFrRcBEN0uacQbmS76p/pXHdz5k7EMXOQ7FPn1kENfnqgPL/0TADDETdEeNzxmEAiBf+OV2v3hSi5TryXN23SVObQdL4gqsDz2raiCMI6c36bv0zmd9x47PyGaWeyvOAbslxxEja9otYwkD7nLucdffKobBlptXSvsSO3XPOYpgpkyhF4zYw/FK1vOB5Kxp/2A8WJJOaEuGfXaQ7ihE+GOhgrCkK2ae0Fv8F5u7jsg7FhNlz5UcYhE+nS5g0PcdSxXqOC4QTqFnou/VKraa2Agulaa+Ex9kfslxIgkQ19QG3u9bhrdwOxZ1IjiKydxedBJHW+NBPsApV3pRg21M1WzHx9cgFX2PspmCpcQoBa+3VTgcJl0KLEk3eHWc6agJlQevRJH2/unEQ/TkZVdlx0vW7GybJeanwaUKzJQCvZqJRis2IP6FS2QYzKor3h0UJCeOwvCmJRfidHYwdlsHJ2bkBVaDcLZXp1CtmmHkyx9aOQREZkDzPBmqrBJuQe+5nxqsetTkHnIuxAeBxAr6ZguCqmshEbbmQCYBR0LSI+upELTVDhf2jnknpK2jqaSE5yAxsn/bWZzst8mOO9aZa5Ud+WfG1A4uEStuepApHrzrGlkIr3fvaPEJbTQ9JADWqdaSZbcFClfXyfreT4GlSIYSG0GAQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(186003)(4326008)(6916009)(8676002)(2616005)(8936002)(54906003)(2906002)(316002)(66446008)(38100700002)(6512007)(122000001)(6486002)(83380400001)(66556008)(5660300002)(36756003)(66946007)(53546011)(6506007)(66476007)(64756008)(33656002)(71200400001)(86362001)(91956017)(76116006)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xUJQOTA4fCLHG1Swjv12Cl2T1O7ZU92vjPFN8+VJgLJaY+Scgh8cAxR0uhYt?=
 =?us-ascii?Q?fQFd+P8EOO20+RjlxSys9takabqy7oyBH+Ggbs2NgaKudTvdxmPpjbeorPHY?=
 =?us-ascii?Q?tSIoIbzduAwUZ6Z9SBq0DpqlSzjeAxRQOtQotb7VdwYerpQICaVQxy9bnCUr?=
 =?us-ascii?Q?w0AYnoLNnqNRLBFMSoZyJBcW0KwHYYtBU2IuvfCc65eo3268RFQaVAQSrYXf?=
 =?us-ascii?Q?h+6/jWLla2Bhgjof2vrPYozAgrkO2R9tAOiclfDuuLYGmsdZOhw5MnlCMaT1?=
 =?us-ascii?Q?PRM+oD9l2jDTlOXoHaiI8l9W1UFRAeePZwxEitRcn7m6qDVMna3Lv++QKcgm?=
 =?us-ascii?Q?lbhwNjYDMpRE3rKVpB69/jWJviS6z+W2PwuC7ZKKq4LXb2wGOsztP9CsiVQG?=
 =?us-ascii?Q?a8dANdEEKuy4RBY81On+ty9XjbTZ+XgeV5mgkk6TEb78Z5IYLFhnwoyyh02R?=
 =?us-ascii?Q?Jsnbvz31ZFWbd36wvikZdZR6KY3wkA76sj5NjllZ16a4KqtpxGHH1SYA7kRY?=
 =?us-ascii?Q?6ceTNm197WRJtIw1a82u/YuIY/qlFB6F6eKSsLOb79wXP/guwh/9r5vWAa4E?=
 =?us-ascii?Q?MtY21KV6OH9GvzI0XqcAXmbiX+x3Gu3lp67QoA46REsl+/oKNKt9ZeAUoE0R?=
 =?us-ascii?Q?uJHIlPclUuD2VQyf2mE0tSRZIfm78sfsAH+XTJX6Q9aLF+wyez5YUNHZRY8U?=
 =?us-ascii?Q?UI9XX1pBUBJrVfq3z8MJE40a8VwKWtVXpAMnf490lxRi5yW+J2XtZmW9j/AP?=
 =?us-ascii?Q?4rFJgbUhdxKPOHlYkbO75+/3ZZzERczu5gIw4KyhSKnLijCrZwf2tXv6bpUT?=
 =?us-ascii?Q?ax/mOVLcqCuC5Bdhfric0uDmbb2At0nhA4eDxJJhMPZazjPGKv09GcYz9ff0?=
 =?us-ascii?Q?Pt7ajFanozs2H6dM2dSGuWsgoNeVtSh41x4OPHSIHGPn3+5lmdBL+pwaCO/w?=
 =?us-ascii?Q?gwRpkjheNKZpON/dBG6p7/8eFft4SITRUtTb9ZVGfyfJdfi6UR2OHBY5/jfK?=
 =?us-ascii?Q?wd9n2qrBKcyZsrCDgOjc/LZ3ltw3neA3hmSmxqT4AYx2uAdRrc6TH8SxkFV/?=
 =?us-ascii?Q?/VJw4sbziksGv1x/EXyU+Xy6eitWGWfDClnH03OrLbr3XI83AfwVtDz2yPTb?=
 =?us-ascii?Q?a2aH5x5x2uycSB5RL7gpyMpaDUpBhBWVKKbC1gKoEa2pZ7v2PTEFW0h8V+gJ?=
 =?us-ascii?Q?5RIccUcOAKt+UvVmTu1jzS+KqU9faKMNF1oNTqeER6TDADHetIJHxWPlLsH/?=
 =?us-ascii?Q?nlXXbaXq1VbrUOVJil2i/p5ptMntIeZ5OAsP0Zz0rigx62KPt0kW+6x4eiGX?=
 =?us-ascii?Q?s1fNWMthxxFOSUGzMU792wdXfjhoHTV8luuxrr4NGhlNqASe+CTcm95YraVA?=
 =?us-ascii?Q?GPtpObk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B5228A78659F804B865470F3376B071C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81010c5b-7f1d-446a-4655-08d90b9ea519
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2021 06:10:24.8653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FqMHlJVXZB1hRfgWo6naloh4MOnwF/AHAVW0nFXGZQ5A+i+5m9Zzc7VFp84fUxsT/GfEt5otC0j/2dddXOO5AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4977
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Ul5_-stOT5qnTnmtPJ7t_mfbqqmXkTqs
X-Proofpoint-GUID: Ul5_-stOT5qnTnmtPJ7t_mfbqqmXkTqs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-30_03:2021-04-28,2021-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 clxscore=1011 spamscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Apr 27, 2021, at 10:46 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.=
org> wrote:
>=20
> On Wed, Apr 21, 2021 at 03:00:09PM +0200, Greg Kroah-Hartman wrote:
>> This reverts commit e406f12dde1a8375d77ea02d91f313fb1a9c6aec.
>>=20
>> Commits from @umn.edu addresses have been found to be submitted in "bad
>> faith" to try to test the kernel community's ability to review "known
>> malicious" changes.  The result of these submissions can be found in a
>> paper published at the 42nd IEEE Symposium on Security and Privacy
>> entitled, "Open Source Insecurity: Stealthily Introducing
>> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
>> of Minnesota) and Kangjie Lu (University of Minnesota).
>>=20
>> Because of this, all submissions from this group must be reverted from
>> the kernel tree and will need to be re-reviewed again to determine if
>> they actually are a valid fix.  Until that work is complete, remove this
>> change to ensure that no problems are being introduced into the
>> codebase.
>>=20
>> Cc: stable@vger.kernel.org # v3.16+
>> Cc: Guoqing Jiang <gqjiang@suse.com>
>> Cc: Aditya Pakki <pakki001@umn.edu>
>> Cc: Song Liu <songliubraving@fb.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>> drivers/md/raid10.c | 2 --
>> drivers/md/raid5.c  | 2 --
>> 2 files changed, 4 deletions(-)
>>=20
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index a9ae7d113492..4fec1cdd4207 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -3896,8 +3896,6 @@ static int raid10_run(struct mddev *mddev)
>> 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>> 		mddev->sync_thread =3D md_register_thread(md_do_sync, mddev,
>> 							"reshape");
>> -		if (!mddev->sync_thread)
>> -			goto out_free_conf;
>> 	}
>>=20
>> 	return 0;
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 5d57a5bd171f..9b2bd50beee7 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -7677,8 +7677,6 @@ static int raid5_run(struct mddev *mddev)
>> 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>> 		mddev->sync_thread =3D md_register_thread(md_do_sync, mddev,
>> 							"reshape");
>> -		if (!mddev->sync_thread)
>> -			goto abort;
>> 	}
>>=20
>> 	/* Ok, everything is just fine now */
>> --=20
>> 2.31.1
>>=20
>=20
> These changes look ok, but the error handling logic seems to be freeing
> the incorrect thread, not the one that these functions create.  That's
> independant of this change, but seems odd.  If someone cares about it,
> it should probably be looked at, or if correct, a comment would be nice
> as it's really confusing.

I don't think this is confusing. raid[5|10]_run() creates two threads:
first mddev->thread, then mddev->sync_thread. If we fail to create the
second thread (sync_thread), we free the first thread (mddev->thread) in=20
the error handling logic.=20

Thanks,
Song

