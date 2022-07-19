Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D3557A588
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbiGSRis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiGSRir (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:38:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ADC5B7A7;
        Tue, 19 Jul 2022 10:38:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JGu6fh030727;
        Tue, 19 Jul 2022 17:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=GG9vSG2qge75b0qe8H8Dz1MLyEaq9zZ8Be++3h9I0nE=;
 b=gOlTvRdd+9bOr3KtW4M46cdUQIMOJj5xzn4Gh5+Azvadp/xxQopPHufznWMFVHdFF0xU
 kMVBetfvdKpJukBGnq0gMkmEcXSLQnIcKEbXb0QAa4Lhy5+gAlIIFqOaKIGc/Slrg4bq
 zZFT7gh/B454WBksma8yOYTglmF9Die8UsXebzmpAHTBR9coD9PdP2RwJnHwArxvZU3f
 8TsliQLzqeFHDqDpRa2LYBo8jkUcZiFv1MRAqlrGWJfBdlxdezNQrSxxXijIA5ZuP4Ag
 cF39GzVPld92Q5grUNQvn3AmsIG7vjXLnxdaElphwCMwFz+FgZuwRvuzgWnxoxKXzgCa og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc74us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 17:38:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26JG2lNt007941;
        Tue, 19 Jul 2022 17:38:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k3k55d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 17:38:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcYKg+jpL4pMMAbnQNHpcdN7TlScG1zbGkUhuqqhRdVW7f5PuMvtb+kAE8vW/kPZR5yc9RfaAnbZf2MvOu2Zx7P0hNU4TIA3gS/Io48NuCiMpLxm9loJHKD++romQ0k9MslrU6vJXo349QUMq21esMRwkSnZcYeRTg53SgIln0mGAUC3VRrIB0DoHpNhfqhJX6ldLNVWX3+U4QcvMwSkrkhXKplHjQZJB6TQPBitUBhf7weqfjbqCb6HeMur/IgjIbvzfno6BXnWVQ+wD7Hl2BKlkW87xd5kVYSnzmi+REuzai9gs5LwQgy+VX7HlJw1NaurKroWis1/WvzaIWhD2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GG9vSG2qge75b0qe8H8Dz1MLyEaq9zZ8Be++3h9I0nE=;
 b=hypNfyeE9qSK3mTY29eUgHIBmKsGLk5IRhVQCetUSfRSisRZGN0O0zhvPeleMxY5yjhef9mv6kKAnTuS8aoZyzu7LcWqUoTNPttw+qK6bwbA7CgVrFk7VU3v+YdiEGJ3vZsQb3l4X3CNPnj6+z5hjZFKR/L912Lz38AdARKHgxECtzmAd0/xRvMAs6YZMENDi8AyjImZZXEv3bwyT4viOjenlJ0LeRyZoIpaTapDlGvxCxyg+xPmeT+0dxEJWJIRXki9ZmLaz6CuSebohCIYCaV2zvSkVVKfuf3c8HFc2rd+V66bK2UzPG4AqoOHmOHpvFLzOLNmoXL7EfK0g7jWAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GG9vSG2qge75b0qe8H8Dz1MLyEaq9zZ8Be++3h9I0nE=;
 b=b8FnxY/ZT+qzonWdwQG14uAO2YBUGeqOrKHoKcioiTF0hp7peOv9xIGCRP70nNhRZixYHMV9RxENqA6aQBFD+gCGp6fO1V7jobDKOlFiw0MY3FtttGDSO7/hUS2cpNSLO16+DFEFs0dgphKzySuPr17+qks8+HOWvvTz7cFWetM=
Received: from PH0PR10MB5660.namprd10.prod.outlook.com (2603:10b6:510:ff::6)
 by MW4PR10MB5703.namprd10.prod.outlook.com (2603:10b6:303:18d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 17:38:35 +0000
Received: from PH0PR10MB5660.namprd10.prod.outlook.com
 ([fe80::29ce:70ed:1141:d773]) by PH0PR10MB5660.namprd10.prod.outlook.com
 ([fe80::29ce:70ed:1141:d773%7]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 17:38:35 +0000
From:   John Haxby <john.haxby@oracle.com>
To:     Eric Snowberg <eric.snowberg@oracle.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "matthewgarrett@google.com" <matthewgarrett@google.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] lockdown: Fix kexec lockdown bypass with ima policy
Thread-Topic: [PATCH] lockdown: Fix kexec lockdown bypass with ima policy
Thread-Index: AQHYm5Zfj1zmFrd/K0SmFoV1QR5XJg==
Date:   Tue, 19 Jul 2022 17:38:35 +0000
Message-ID: <F47EA986-6D9D-423A-B80E-2A54DB2214D5@oracle.com>
References: <20220719171647.3574253-1-eric.snowberg@oracle.com>
In-Reply-To: <20220719171647.3574253-1-eric.snowberg@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01584f55-7dd1-4f47-9433-08da69ad81f0
x-ms-traffictypediagnostic: MW4PR10MB5703:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TyikI5ClfdJTmz4oYuNjFlyK8G1+DYAWR+wq0NpC2LEvQ96k+45C5PulaBB3LXx3IUcOhhMMEYEqgfgbSb0uMtg3Jd1wAJ7kz1Lrzq7ooi35OmTFzhXSs7nhnPrn+sceId1UQMF/v4hCjEmmDKwXJGSDxgp8yhI3ux1mp7TQHnlhtzUmZFi2AMxi3JJgACLdqTxnlJRBMOkBueXkiehfdZtGOiP916kQSE7UN4519hldfI1B+a3aKnC0A6AAlI5d/BwiJGzDI8lrqBLpmVmDGyErOSRa4e5k1ORSN58HW08n+xNHQLACVWPW4N0+4bd003NXvE6vQi+54RLkAAmWXDJDZDLyz5+TpQZE0dD7ywaFUxkiiPzuxmGkPrVJr00OUapXY/u3nrzib3CMxiVqaSev28Cyhm6uPTYZEgI0BNIu+IIL3/06Cfl4+AE60FRmib0e//sXjP031sfuLOwp/8O1+RJm+NJyDUqidizjPBscjbSDWyhL9dHeqkyppkfhlVfyg0tydoo7lEA0i1cbG/LW4Hr3uVas0OvQxSi6pXaXNtqS9Px2GyzxQKXVHXCpEUip9Z4tbkIQYOGCjpRe0kCp6IZAGcJ0C47etJMWPqF7MHXbBhF8awPtAnXnfpBPFWRHsQV0tfeXsu7JFIGnTDgmEQs5fkpbnyS91b+K+2A6wqPc5jaYdofEhQM5fV6zN+dF2V0yQ4L9lEcSwGRMDCXY9E0+u7s8IzmVpUDdFGCftLkvGg5t8j72cGjuQbcasB/QhzrwqzdUrfvu1LWkNKFpJbJyCeCWTRMjrLQL1y3qJD4z3jKh3dgtzWldg1NGzxHFPNoAR9rb7JBRWnLFeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(376002)(136003)(346002)(186003)(2906002)(54906003)(66946007)(66476007)(83380400001)(66446008)(91956017)(64756008)(8676002)(71200400001)(4326008)(76116006)(66556008)(36756003)(6512007)(6506007)(6636002)(53546011)(37006003)(2616005)(8936002)(86362001)(5660300002)(41300700001)(44832011)(316002)(33656002)(6486002)(122000001)(99936003)(6862004)(38070700005)(478600001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eWSAJT4So0mE+xmNok59RNuFniJDQz8ZOfRlNU0imZqqYb+09CLUh3UhgWKS?=
 =?us-ascii?Q?kDbpjWN5maVvAuStEEMQHW3R1FyV0BG7LXZ78cRHfjCRWoeGCilMpSIg0KDk?=
 =?us-ascii?Q?ogK8ju1HIhbnFaV9XfHcANBmTjCaLJPiaSfEl5yCOLWb0G8o6P4Q8xs2bL5A?=
 =?us-ascii?Q?z7BnxWQlf54Je1+Qayssj5MZSQ6egibzERiFRC47BJjxdFIlARMbo8Cgio/X?=
 =?us-ascii?Q?H5mh33Z560u8khRkrT6oHULahdkZCBnlI5dGUWn5ScOP2zJ1Gt57+xZA4mAq?=
 =?us-ascii?Q?bOMAze3MkIp0eRPOdXvLeHVJ3xch1F8xnz/AErgKm63ShZasy3FFMpexgLkX?=
 =?us-ascii?Q?fLEoEHOJWTAPz+3dz50310cUn4WVGaMJwd1IXzFZOQXn/XcTpkeESIiS7Ppj?=
 =?us-ascii?Q?VPobr4MsFUcl8b3AI/bgWnrX+15n4ljw1AvaZJseWx2i4oJxGglM/v//eIUe?=
 =?us-ascii?Q?rCjKPPEinoyIyoE8/08wWI9dSjFlHpV0tHMqtJTUKQFlIc0jtQ2J1ENXqjkC?=
 =?us-ascii?Q?9kUxYwhRGbI+hnedeQ3bmjGHh88ZHSv0mJyoyiNHtU6D2BpfEpz5XJhdxLtp?=
 =?us-ascii?Q?LgbNSrOy36T+HekcXgM5wVl8Lom1TAT+nqbHI+UeiLk94MDrhiJfHh+z6UE0?=
 =?us-ascii?Q?L02kMlTIhYqh+Xg+I7gL1ecwO17/HMjBnazA1+nTts5YY+tYKjyK76V2Fnd4?=
 =?us-ascii?Q?3bc0ydgRyPD+5SjGWqZI3SzdMvzAxY9Il/xqqDhe2DgtFiZ1c9odJNtOHL2O?=
 =?us-ascii?Q?VtPbc79JVDLC8nR6eBMWa6JWN79ccycni+rTSdAfw0PJdoiI+FRomkwhJs9O?=
 =?us-ascii?Q?gGgC/SDXImoK5hA+XmVkeY+XRaQvFPMPIIgkXBxpoEec0GDAB7f+DIynUZr0?=
 =?us-ascii?Q?mPC8Bs/2Zbvs18w5Wx+N5UI6Yn4xR71zKLp1auIe1lThX2Sr3wVxf5xZbCGn?=
 =?us-ascii?Q?TOiMNRXY6SmHQDVUyZfwNtVJ8/XDJOix1sBNgfKWwE6vQ8uMquE8Y4tpxwdG?=
 =?us-ascii?Q?ei32D+vssNV2F5Dwtso0D8mPSTbknISekY66sEoApNQJqzKAbJPnz7gs/per?=
 =?us-ascii?Q?FW4E/DhnATvtaPtw/5c8zDrqQwpZ2+m9YikL83T20mwDB1RaAddC9HQEtCGR?=
 =?us-ascii?Q?oEag5zIAIcXc3Km0OhL8UcTPBYFC0hly8NiUU7LDKtvBsWhDDctkVh+a2axg?=
 =?us-ascii?Q?2QluuOP9EjZ5Gktx/mMcicjBGbUUjCNp70f1GTmhnr+cig0VvK94rtBFeIna?=
 =?us-ascii?Q?r24c+N3s1mBZR553Xu1K2gSsgLxcE3F8EGJocIJ8o79xc1doYBCIZqrUhO7d?=
 =?us-ascii?Q?CNjUycExIZePV/OqumOymxn4kyVHLLLooaaDZdV5rtsVfdIC9UGw9oxvWne4?=
 =?us-ascii?Q?aMpw+m7mkxYrhi1OxV0GgRFunlYqHFTcGsE3P7VTrOalYe2jYa64WPcpKJOc?=
 =?us-ascii?Q?ucB2D3diyUTJNkWdS4Ga6Cx6HsLXXIQPD39HnP6z+LmHXuoEgdW5W8D+P07z?=
 =?us-ascii?Q?WlRSgLyszgVSnhOYewpB/pRnGNHdF20R+MUqfYDVNqqCjZIq6+/L6xkh2kDs?=
 =?us-ascii?Q?hO0vFlzVDxPIASMnGSS0F+ZvxAqr0u0TM0biXFKS3ReA60nXteKyLcvYqRjO?=
 =?us-ascii?Q?cT6inunOOzy353WlpIDZzH0=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_63BF5564-F7F1-4231-970A-BF216D4C6B74";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01584f55-7dd1-4f47-9433-08da69ad81f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 17:38:35.6306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LFlpd/lldm+utEcY3T9oEUBVyDo1WF/E1xp36zCVMHY0k3pDYzK2Qps2IOfp/5Tx/JblWyWXAS3RAFFjwSYQAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_06,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190074
X-Proofpoint-GUID: 67jb8V0BBHVkqXlpAUuFpZTFeDN72lkp
X-Proofpoint-ORIG-GUID: 67jb8V0BBHVkqXlpAUuFpZTFeDN72lkp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_63BF5564-F7F1-4231-970A-BF216D4C6B74
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On 19 Jul 2022, at 18:16, Eric Snowberg <eric.snowberg@oracle.com> =
wrote:
>=20
> The lockdown LSM is primarily used in conjunction with UEFI Secure =
Boot.
> This LSM may also be used on machines without UEFI.  It can also be =
enabled
> when UEFI Secure Boot is disabled. One of lockdown's features is to =
prevent
> kexec from loading untrusted kernels. Lockdown can be enabled through =
a
> bootparam or after the kernel has booted through securityfs.
>=20
> If IMA appraisal is used with the "ima_appraise=3Dlog" boot param,
> lockdown can be defeated with kexec on any machine when Secure Boot is
> disabled or unavailable. IMA prevents setting "ima_appraise=3Dlog"
> from the boot param when Secure Boot is enabled, but this does not =
cover
> cases where lockdown is used without Secure Boot.
>=20
> To defeat lockdown, boot without Secure Boot and add ima_appraise=3Dlog
> to the kernel command line; then:
>=20
> $ echo "integrity" > /sys/kernel/security/lockdown
> $ echo "appraise func=3DKEXEC_KERNEL_CHECK appraise_type=3Dimasig" > \
>  /sys/kernel/security/ima/policy
> $ kexec -ls unsigned-kernel
>=20
> Add a call to verify ima appraisal is set to "enforce" whenever =
lockdown
> is enabled. This fixes CVE-2022-21505.
>=20
> Fixes: 29d3c1c8dfe7 ("kexec: Allow kexec_file() with appropriate IMA =
policy when locked down")
> Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
> Acked-by: Mimi Zohar <zohar@linux.ibm.com>


Reviewed-by: John Haxby <john.haxby@oracle.com>


> ---
> security/integrity/ima/ima_policy.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/security/integrity/ima/ima_policy.c =
b/security/integrity/ima/ima_policy.c
> index 73917413365b..a8802b8da946 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -2247,6 +2247,10 @@ bool ima_appraise_signature(enum =
kernel_read_file_id id)
> 	if (id >=3D READING_MAX_ID)
> 		return false;
>=20
> +	if (id =3D=3D READING_KEXEC_IMAGE && !(ima_appraise & =
IMA_APPRAISE_ENFORCE)
> +	    && security_locked_down(LOCKDOWN_KEXEC))
> +		return false;
> +
> 	func =3D read_idmap[id] ?: FILE_CHECK;
>=20
> 	rcu_read_lock();
> --
> 2.27.0
>=20
>=20


--Apple-Mail=_63BF5564-F7F1-4231-970A-BF216D4C6B74
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iHUEAREIAB0WIQT+pxvb11CFWUkNSOVFC7t+lC+jyAUCYtbsGgAKCRBFC7t+lC+j
yPQXAP9vi//B3U1QH+E6AyM4zzsjtOToUowka4uY5NQbIQydrAD8Co/p4W6l5S1f
CWekP25ZYBGsX39Vx3pdkt/OYRDBY2o=
=B5pO
-----END PGP SIGNATURE-----

--Apple-Mail=_63BF5564-F7F1-4231-970A-BF216D4C6B74--
