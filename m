Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4492F608DBA
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 16:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJVOqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 10:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJVOqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 10:46:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75323119BCA;
        Sat, 22 Oct 2022 07:46:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MEhxKf016758;
        Sat, 22 Oct 2022 14:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=k6x2SvuMR5/XEDwENpbBE7RATbQAl2l0jBCvVedgTcE=;
 b=wI/ttDZqzIjGHU2ht8rlUYD2DSfl4kJFz4ex88ribLE7JyeBpRvFMOqFpcTknaaEFI9B
 TENi6HpaSKY8joTCSGraUk5BnbqtTmuHhbkb5HvevOHbnvj5Tld5aNmnEH69qO1x97YA
 mIu6KEHK5/rDvFqGUVTgUd2GBlFDmIHeT5ckswn+zIeL0YuVprwLP5x/N7c0mlEM8kI6
 vXYgat8+Lqi7dhcSz5CbQl/82KMn++dttUL9b5HBiIRRnx9IR4h4+tsgd3vrPWdxxOOM
 XGHP3PCxDuxd6qlRSCqvsHUZsQtEduwwPYe0frCTNcwiiojPSR2t9esxDP+bKSzj0G/c Gg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8db8mvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 14:46:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29M9rHY7032281;
        Sat, 22 Oct 2022 14:46:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2s5jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 14:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQAbht1nC3Ha1uJ7+IpQ4URH0t5DdnysPiicfl8Ri9ZIUwbB9ZMehd/91Pmhu7OzQ/tPc5UTIbmRiootijaHO6JYMtNcfg5dkY71xecTsL9+aGCAWFtL65e3xrFO3lgbZ3lIVlXYFiz29B7ATFxdfVrhHhKDeO/kF6I7uLvYIpdfywhOzbTRKKPWkFF/l8A0yAkxPrm81xS0rOCoUZfqu2bcTxbIAFjZt6NuBFWw4Asc2mFpUYk+HpsazEDa53G3DDwWGQsZliI8ukmhNXqAKUEQO/zxkWXdqzrG3mzQ3WsDaeTS4H24oNR4bfXBc0yceIVDObZnNlui15mdS0EQ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6x2SvuMR5/XEDwENpbBE7RATbQAl2l0jBCvVedgTcE=;
 b=g4dyBDXzswoIVgJ103aIdnwcA9lQ4DXg6Wmn2AUGHPZatudVQ00PTSJpTslCWTx/Dah6R4LuYMAfdUpcNRh57lroLwVGtqeTZVz6CY8aPf5i27j2NQJrZwDijnqtocJQfV8qH2G/pY45Ft2k4qmpb0goZAY/f8wrnViWpBBuFWLIoL+wKJ29yk6cCsxsm/nAEtk/5iutgzzmDgJkSsavdm5ca8jXL6PtoXRMYGiWWaT8b0VZROuzkfoOPnZk4V0txNOv+pK3z/Q8f2WcPmLte021QfnhndHddwLB4p3FLmL9/GeWHl5RBLyYKdssK+EbPp9mgGw/sGw/6sE6kGvIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6x2SvuMR5/XEDwENpbBE7RATbQAl2l0jBCvVedgTcE=;
 b=pZQidrw9BhM93AdWA0tCtO6yC4wmT3j81a+YRRai9xU/yZeSDVuwIYnivvMmYEDyOECkNIi8saMDqa1MKcpey4R6oLcbEovv2KSwPzytp/6Alob20yloXNG7GszyYFPOu0ZXvQppb4oYfpO4dSk6EqhR2C0HaPLEC4ailLsvTno=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by DM6PR10MB4122.namprd10.prod.outlook.com (2603:10b6:5:221::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sat, 22 Oct
 2022 14:46:36 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::f073:4d21:3876:ff33]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::f073:4d21:3876:ff33%7]) with mapi id 15.20.5746.021; Sat, 22 Oct 2022
 14:46:35 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 554/717] NFSD: Return nfserr_serverfault if splice_ok
 but buf->pages have data
Thread-Topic: [PATCH 5.19 554/717] NFSD: Return nfserr_serverfault if
 splice_ok but buf->pages have data
Thread-Index: AQHY5eyW2zD3eq+/T0GdaBrfEjzLgK4aflGA
Date:   Sat, 22 Oct 2022 14:46:35 +0000
Message-ID: <E22D29B2-5740-46E7-9A4A-52BAE214FDA1@oracle.com>
References: <20221022072415.034382448@linuxfoundation.org>
 <20221022072522.883630640@linuxfoundation.org>
In-Reply-To: <20221022072522.883630640@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5134:EE_|DM6PR10MB4122:EE_
x-ms-office365-filtering-correlation-id: 974f2abc-e083-45a1-6253-08dab43c3818
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5nUuhkdm27pSzPjIZ5Jydk6w92CdipaKJnfd8A09+uzI0dz1Z0qKANxI+7x57Xb16cn/I3MvMFaoMwS5AXz4Gum2LyvIA3rAhkyiT9+ZrEBicAefoskiFo4RlHX8mblR6MDMiOc2tPy6iROA9+kM6Lu3emSTmaPInvDSNFMFYcp7LGK5j1aX4MKb8myHX/TtWM6SXEqIBsJLmKgNx5aCWVWWHKI4znfmzGIuD+5W7MeKK9DJsRfIdN4wxOJrE3a778EtbeENtY32F2d/5DprLxKqv8yf5i3/EP9JiSAVdFZNiBk/ANlCyRjcLZ/9XE3yo/XEwUY/R+L3og0wYHWzaqJEVJph41hkEm0SHbM92dE3j5RtUodFi+OQHOrrGvShvpgZW0heznvzJpNyi/G4CzDDRXr4NJsrBk4b92VCc0xWSIV0CPiL6D2FWqdpo+XsnkLhdYdepY+NsxnB+soOsXE57dmb42/SbfMxSyDdp0dHfZ8gbN8sr2QGSUO/2g2tEU8BegBza+8WH8KGbyon8Kzh0i9lRFjEhRTa+pqx/nB0LJYlGfMV6/ugJBnlL6Y4fgkamtqcs1fmheoaS9S8ApnqgUtOTr5BSkPpGNPHoWtzWjXwr4RV5DbZFh7Hy2qGtY2RpKygKQD/+2ptH2lciqG/zsnpX8SQdHVZB6R59AEBNEmJ5rPXgpFxUNT3qkQNB2+A/OR6MpyzWrRy4KzcyUgFolTOJPnkfq037+NgsVPAU5X9VdLBFJGc5cskkS51KviXdtsbgpIyDBi8YB8D8Mv4UAFjrJFfLAS2ko3NQnft/ipLd42X7hDjlN6472WaaVm/BqfdwMhwRSpEAhJJ8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199015)(36756003)(122000001)(38070700005)(38100700002)(71200400001)(33656002)(86362001)(2906002)(478600001)(76116006)(966005)(316002)(41300700001)(6916009)(8676002)(4326008)(66556008)(66446008)(66946007)(66476007)(8936002)(5660300002)(54906003)(64756008)(6512007)(6506007)(83380400001)(6486002)(26005)(91956017)(53546011)(2616005)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0MM19o7G97B4Aegw89zDzcVo2wReuD8c6B2SvaKlZ/kkfrvVfXVZqetROG+j?=
 =?us-ascii?Q?O2NT5RnLPWUosi4JKyPP9fG67pVAce8YnlF41uk0Am0yayGqXhBv+a1gh0bC?=
 =?us-ascii?Q?r8+U1noNC3hpvzTkrEoyLPAeRQ3t9i1NhozNcEMm89E8GXoHOafitrRxKhOY?=
 =?us-ascii?Q?nimS0lFB1NkzkP+YdBpXYoejkVOVXFydVyVzIZIMNOUHLj4SXvyLEaBDlj/U?=
 =?us-ascii?Q?BswAM1N8oZzx8GbUntrGGs4AQ7FdFG+LXtFuOUAiGECwydkoMlFTw1TeemFT?=
 =?us-ascii?Q?FyyYU6CwY0m0+HDI9Ci4Z7sySYT8++KH+nhysZFaHEeXOyL0aUtTkOpBQ/1E?=
 =?us-ascii?Q?dlfcitu97f2KVia8nvQukxeJhMDLJlRaGHIWMijnXYMv11Q6TaDhErGjriTc?=
 =?us-ascii?Q?7xaN3d3GeE7yvKoQKObKiEG4qiqzg8HzkF+lEjMgD06CcHRR/E6C4jPkYo8p?=
 =?us-ascii?Q?SZXe0X7SMvZ7RvSRcpejn+Xsjj9UbJG7uLPwRtmn+jmrrVUXlHTwVaqzqQ9v?=
 =?us-ascii?Q?u/Uzj4dEIg72atIgppFHwlbiy/h82Xioj0gNo0N3H3ZeyO//WivJocb0+KwK?=
 =?us-ascii?Q?xV7BIF7zavKlKrTCWiIryilrkvcu1iiFdBBlK7KVab2H4zxpbiav2xnJfyj2?=
 =?us-ascii?Q?NHreiN81B+01qF3Y+6g97Qm1TVIXLR1eLDXOTFpixhkoSnCHnygdkdqZsT7C?=
 =?us-ascii?Q?Ea2YL+aqd54zUf8+94sSC5JBhzak3zfxJRS+3iSXa9VL96121cXaJ60ZEQxi?=
 =?us-ascii?Q?XVL6U2sNff8grzqAOLf3mzAearTxW7EpVZEhYSUA9tPfWqbgSTCgKn1YaUHU?=
 =?us-ascii?Q?PSBoNFrBXEjm+t2nq31hw/9TTVpRte6J1MCbLfWYJvZOqtmt9TvRDmSZQ0ZY?=
 =?us-ascii?Q?GzteKvyoYmaTAMlqrI+HKJ9OXos9QexJRDTlOIOem0Zj2EyseT2RS948XKUp?=
 =?us-ascii?Q?Ei3uJhcnNtHvQ8zWtn+A9DVjy1t07q5yD4yQC/VbShDaaqAxPPCG1Isz7oK2?=
 =?us-ascii?Q?uCfw/PFyPaTMcF4hv2iJEK70OmP2bMYnlcBGt/mgmxuzZ88+cf0JfIzQ6+lp?=
 =?us-ascii?Q?MbCP7M+SMhpy11Sd90tDAdWyv5VLQYTI5kLbTrKvI3LgNUbCKI7ZAAV+7rd9?=
 =?us-ascii?Q?dzhDyXv2hYQN3HYk8hf4E1UgMwluTQGidgUQp0hL91/rPI3Q9oNJC7IjSW8c?=
 =?us-ascii?Q?AxqZC6c6Xs+Qwp+bdmQyoXjvrcS+2unkJeOYl6DLrWTsDvfG7biZUiysu8vb?=
 =?us-ascii?Q?Ijmf+yug5bd2Az0D1Ql+fXxlM706tosmUi1a72l9uqdM5j4Fcwr92gOk62pY?=
 =?us-ascii?Q?NihFd0SrCWGT6QwF1gmgLJj/Z7Iut3OpZjOHJzvMXL7D8nS7f/AbsJJU948g?=
 =?us-ascii?Q?LoxE538J0nP/W1UcvwfxDy/AVZ8VsJpqjPIuV2F6sSqAU56XQXmFlH2HPGKr?=
 =?us-ascii?Q?4PXJBZqJfudJKbThhhF6Z7Vdx3BDU8TgommO5Fc19S7l8xpUICRJfDWr/bDF?=
 =?us-ascii?Q?WX49BB6oSf2IqLiy7PRgb3MnMw3IEuyE379JBErYJCVv/I3T2fUrKKEA6E0l?=
 =?us-ascii?Q?ApesX93xeMPNShwYPKCdwFMHBAOkY85huX7+qVe8Y1dZnXrZUOYD0jdXGcfY?=
 =?us-ascii?Q?ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C8BC39C3AF54C241B78B0EED8653C5A8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974f2abc-e083-45a1-6253-08dab43c3818
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2022 14:46:35.8036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mdauUmFa0YQ2N01QycxLTTiSA9VlY3x2y/N4FfJXzy2VTytlRcQOx2Rj9P+4xrZr3MxgTWLmzUHyfTPLXyhy6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4122
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210220092
X-Proofpoint-ORIG-GUID: StBV1simoDOO9r1LJmOru0IfuLybKsHI
X-Proofpoint-GUID: StBV1simoDOO9r1LJmOru0IfuLybKsHI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 22, 2022, at 3:27 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg> wrote:
>=20
> From: Anna Schumaker <Anna.Schumaker@Netapp.com>
>=20
> [ Upstream commit 06981d560606ac48d61e5f4fff6738b925c93173 ]
>=20
> This was discussed with Chuck as part of this patch set. Returning
> nfserr_resource was decided to not be the best error message here, and
> he suggested changing to nfserr_serverfault instead.
>=20
> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
> Link: https://lore.kernel.org/linux-nfs/20220907195259.926736-1-anna@kern=
el.org/T/#t
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> fs/nfsd/nfs4xdr.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index eef98e3f4ae5..1e5822d00043 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -3995,7 +3995,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, _=
_be32 nfserr,
> 	if (resp->xdr->buf->page_len &&
> 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
> 		WARN_ON_ONCE(1);
> -		return nfserr_resource;
> +		return nfserr_serverfault;
> 	}
> 	xdr_commit_encode(xdr);

Why is this change to be included in stable kernels?


--
Chuck Lever



