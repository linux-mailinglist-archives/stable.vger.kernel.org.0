Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAA966321F
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbjAIVAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbjAIU76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 15:59:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCB890845;
        Mon,  9 Jan 2023 12:55:46 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309KjKxr005618;
        Mon, 9 Jan 2023 20:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=uTjAIQ3jB03hD0g7DtJ7IE4ha8lxf0lpeJzPzPkKYCA=;
 b=Mi4AGlvqRpbhVI2e1WPFVQD9BLVkjGqj5ETFeL6ww+yakCmQZ56DUbxUqNAwjgQ79GHG
 pvbjNNe9TrBkMx55av+CRZ7aSHYVDZFRu+GWUMx1MZW5IDkBFXgzpRgfIfmRAjLhzA+B
 vasTqUWZ1gBz0EOSVr5xTPquxlg/SXoVkAjk+MxaT9UOaiMkgPkGDCNn39CXMbPsUSWT
 ATyH5TvCZG+DuceOtWXDJl1PpsoWvV3ifxYwq1GKvVpQRbGAL08OTtMLm3257Ghta4NO
 HL+t2Pf6rpNB+tA+ko7xrDdKfZ3p/kdOkSL6gCVrcJlcp1AIbSVG8TOtggsRrYI9tlWS CQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mycxbb6nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:55:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309KKoRT007804;
        Mon, 9 Jan 2023 20:55:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy64gb6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=if77xaBbOq4jxUN56I0Fl0wajcyuZFsPgIjn154mzwjgjEnpnYiN2A+7qneRC3Ns/ZRNBCo9zeSRJRvOOs5SCovZj0vN64Eqk3YhI61P1E8fr2z44yjgxhcoh1E/6wfw5wfJ2ZTwvsXeUOWaOfRUu32efieHpophmGZJVZax3xiUiNK5lDpfWeI44MjJXroZobnMfWg3HTxjk/TiQTZi5CsD3MfILiay1OVUzrbKDmW7axXWb5oOJo2wNSyiSqgi0yPLzKReWSh/kBirocFtNO/0JWr/2u6lgiOr9F/OOTpVRMxQ1BURSHNWeANxq2cuc3Doji81/V0uEa1t026itw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTjAIQ3jB03hD0g7DtJ7IE4ha8lxf0lpeJzPzPkKYCA=;
 b=ViVYAtMvt0+Qk2bMfVQyPtOjI1x5K9c4MuOyF4gdZmep159RzzxClQ0IDiyrV3RYP9MqUigvfsGjlnzEAXdbR200S3DeBaC8NPe9nb3TlJyeoqjLrvCKZl88PCUuD+1gZpjExTRN8hEX+ufhlbDfIYP0xWPUaopU+7lmwX7YsmIiGstwl+Z6qKH9fBd2LZwNjJR00hEhxXqSETf/JoTKFun/Tbx5fdMatvyZ+p+g+sVudS5wBikFsHIOpc7tLp8UjHuzLW7gIE3QLCjsIbfxP1bkhFZL2jxsnj7pGp9U1HRe3v2+bRf2Y4Id4XnxprZxU2FrooWvtYftIXm1qlJ5ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTjAIQ3jB03hD0g7DtJ7IE4ha8lxf0lpeJzPzPkKYCA=;
 b=q3q9SsxxxIsBhUstn0bZo2fx+Cvkb2+fcF+jl/DNaQqb6uxPXV9ziJWbGXCuyaMrEwH8ijLLYV2q7a8UK3t+X7xdk2kmlZm7/TzGdrIRgYqZo4g9u/GNPEbio/kIrOhTUYAXt8ShiPgWWYAcQAzuVgDSyJtfMUTyPawo0FjIlXM=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by BLAPR10MB5185.namprd10.prod.outlook.com (2603:10b6:208:328::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 9 Jan
 2023 20:55:21 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 20:55:21 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>
Subject: [PATCH] nommu: Fix memory leak in do_mmap() error path
Thread-Topic: [PATCH] nommu: Fix memory leak in do_mmap() error path
Thread-Index: AQHZJGywtsxzN9b0sEuRQ4Z3PR4fww==
Date:   Mon, 9 Jan 2023 20:55:21 +0000
Message-ID: <20230109205507.955577-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|BLAPR10MB5185:EE_
x-ms-office365-filtering-correlation-id: bf78d85a-a2a8-49dc-f3ee-08daf283d2a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9DDfr4ydx4Ebtg+hKPWoYKH5VTjEtyydRFNoDzB2PzSk60XerFNI1Icaa6x2gpJ6vt8hve4n0oxrBZO4Bc8CFPgZrSuWep0T4sPphFtQWVSD2hKFz1ngi6c1h8+NQvJMGVfIPVjySCeOXAv0gppO398pMTNxTvvykko3VFRQvbwA0+ELPPRwuL5bWSr8nN1cwX88F/qyvJxPd3HUeFeBW2krmwLjv06uoLO17mqOvaOgBP5MXUYYU0y3SXMXU6IOu6VyQsqdqcqAfoRuSryf9XMBzKLOsVIw0UTWVLHslZCKsIj1HR9Kqt8jz+X2P242zTnl7cY+WNr330PlotAmklMxCG3YWS70sh6y9ue3LK2jVJM1CuDBwlLW4y9Bl//jn0oUD6TVd/TD9vNrkilc0AxWCdNLAI83TIq5KzyPIrsIogxtCKB4Xbsg7QgCi16HiHeM+0qJrCTWCc3XoGhD/GfIPpUezh3Uv6Jelz2N6BX0YqdR3XhKt2ZGRkF5XmIw3DKUTTzFLtEeogAXfGyW5jpBw7a30eGKeCSxa95y92/fXBhEMEnVnqNs+QNewhGFIvG2ZvKXKwPsoy24G3bOkGsI3KcSwUyIXlbjoyMMzfO6VxajqGqMTcgDRea849apQ5yUSP4DQa7u2XKuJ8TWQu/ARBSnhy2zL0CnHpZeSfieJznV2ZWD+4tNts6gwSHVUvAQ8nCKuCbD+J/PRUghFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(38100700002)(36756003)(8936002)(91956017)(2906002)(41300700001)(4744005)(44832011)(86362001)(4326008)(5660300002)(8676002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(316002)(38070700005)(54906003)(122000001)(110136005)(71200400001)(83380400001)(6486002)(478600001)(1076003)(2616005)(6506007)(6512007)(26005)(186003)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?O5khSgFbq8t1KnYB/l5LdOyo4/2B6Try1UrXrxLxgRpGxfrWLcvBP5NW30?=
 =?iso-8859-1?Q?CiLBs+clwROYeHFJffwqmfLwGfz8mbA6+dxgqLynp1o0KAHfV/qlPP2TNg?=
 =?iso-8859-1?Q?KKXsgALYchhxhRdcb/lZCnXt5Gpmw35/VShH9lUTFb6Eh+CMUYUZoJURKW?=
 =?iso-8859-1?Q?BiJPOx02ZBH7hnFqAgqmS8QqDNbm5uhRjmIbcPHnCnD3dkGoutpEU50+S3?=
 =?iso-8859-1?Q?19a77MXYUaYFie4gskehKvaSUqoW/osvc12//YRFCdk+Q+6QF5qaSQu1L2?=
 =?iso-8859-1?Q?GFxA59VKmbqMDa2UnyLJnewbYeV7g6k4EmMNlvmmktsDQWnoC35vkhMRDF?=
 =?iso-8859-1?Q?e3HBrv+k3YYREBJ/17pMZrVlOkBxQ3bPwfVYbOYBGKjA5in8SeAOxfZoRY?=
 =?iso-8859-1?Q?nOCvNyfk9wrH77nIoe1EOBYK1GBo3niVEI1Wqagb7VUGD+ghKvle/iXazy?=
 =?iso-8859-1?Q?zq9yFZ+uWOlGMug9XjY9W64nsunj6noEiT6Fww3wyg9imGuvHnPlTOJtMf?=
 =?iso-8859-1?Q?W5iO/uI/BWLeQ0t3/uejqUGBimuDxJVquhIOLb7b0pJ7qn8pdZeOlYeoYb?=
 =?iso-8859-1?Q?Tzue9e0tuQBTcTYgO1WRQtmdtOi3hAaCujY0ntF4zTXZtI/gdtk6peL0uG?=
 =?iso-8859-1?Q?bkaqKGSA9eFCSwMiT2v0Vh7vYes4jcX8ZTu6PDmKbbs5jtRC92B7EN/5MC?=
 =?iso-8859-1?Q?xFGtYoxIMI5JF6auTlqDZttic4i2V+cXXYNpzaqOyFb/+Zx6eC520U+u7f?=
 =?iso-8859-1?Q?4zsVA8mJKrmx2zhD8svvpSTYox7QMmdHgPy3R4FVZLh8O9fs0n3y4r/iTW?=
 =?iso-8859-1?Q?0+uNwyg+POSUFgQV+sQSn6gK63SuUsDOmsu80PY4lFSmgbBpzkLxSaiQfF?=
 =?iso-8859-1?Q?nzA2Ns7dphu7/I1bR9fktX+jXHTMc4MEq3R6XDeiuPtPlgJ3hySDgOXR61?=
 =?iso-8859-1?Q?7cCUueQ2U2QGPJMUSkjI8Shz1LfrefIdeEpte/jW4yAZHmv2TTHyHVUTLj?=
 =?iso-8859-1?Q?rc4caWaTqnG2JzHiXPqiYrhodqKzKVeusziayNdw5FPl2WeLiIWrOWry5S?=
 =?iso-8859-1?Q?JlQR9/m1BruJvtzgn50t8puCKo3gxqWvtG03N7Ij5wTQMbHzk3anux7IOt?=
 =?iso-8859-1?Q?YsVVutPmo6azy+N8+EKq0OD6lacO6wCKwKJgWDZd3iCDHh7is6kHixzq2t?=
 =?iso-8859-1?Q?dy9uQDAteWXwPtFzq3QGXic1VFkzOF7zWOBLOc0E70iXV61Yb3SuLfk2CY?=
 =?iso-8859-1?Q?keF4gm1fUpumlaQIvUo8cdiT6NyyD5KCMlKenpYO88KlKX1eNw58o6a1bt?=
 =?iso-8859-1?Q?rzC2RxVqaGKmlOhWqRk9ac4fgjZXgYD80OoMcoWcYokLw69CsiblzTa7Jp?=
 =?iso-8859-1?Q?FsFCIT3Hwm5Jd44+i432c5Btxsbg0nXe+9D/m6PaiyKv1TzP9ATaUGAW0z?=
 =?iso-8859-1?Q?hWPn61eDE6qp3u3ftVXb11WKm3kUCL/P+E4ugLVS1gEl1ScW0MRQCqj27t?=
 =?iso-8859-1?Q?YFDbqFyjXSqZsnJrsFki71eR/fBbm0A+5MRnnkRMK+ioyMLDMntbWVcvr/?=
 =?iso-8859-1?Q?KKiN13d1Ay+zB4/17UCciPlC90Ru8oujS1o6lK6knl3C/KPZzZIbymhdJw?=
 =?iso-8859-1?Q?hErIB0F4tohhmtOEC4DO5g3sj5hYzHX6BQ1d934XnjX8c/Sqnx+JwLPA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: H0uy87v2ndmCzr7m6DpK5LhOrUreOcJqF6cj+r/xk3RkqYeOdXhMywMkAyDIoy1zP/ArDmE1ltW9DiESOguZgucxKFa3XWz7LnnBiJAAbWZRIwmZ3mUNQM25CmjQLj7FIqVEiI3bBVviJIiWkQv2HVeMd2F+lzOMnUmPv/WinlUCfgZ+yZVKO4EEEtV7BffF+rmMpsOJojNDgKc76y19NIhUiGzfJEtSNnUPTPFdR246fnBicXsTFfVDzdpLhZPHNo7NnIjEPmnd1P5OBV2p/NJs+VjAbk0n2GBjZZIayVwUPfbkJlRD81ZtYQ3pvzufC8lqTY+EVMImC/NmoLlWnahiVz1k+dPBx7pu34UYJOKgWCT3lpZ2T+u+tG4awNUBciscWKbAE5UZ1V2s8biYIPUbrJHczB4U6/I+Q5SXWQyxincHU9jE6T/qUqAVWTQzWlzdpgk7NXguGNLL4+lGT0DkIvYUu3vNOowUcMDp7y7EwKoD3+ncRIwy6wQuoA2a+qiSFqf5srrquZvGEY1Kme64EfmVtqKhnmkkSs+F1WOYUK0jvzBqOH3t+59mQ+61RbrJ7R0FSgij6SoKz3K6DGgzAsqGICUsKZoX1iz3iu1H75HcNQk00hwxVFzXDpvFkWg1n0ohJ2nQnsDulruEGdVocoRVHvXE0HVy707O1kUgwsLrlOAInVfWp4RyDiePkhLLcnYDYn9tkY4wT2Jgt0lX6zCS1gzz2hK91NfnrM69MdvJHMGQ1uj8wEbmkPXYmLNyM4ouxgp5ZLRHIODfnMw4mFQbCkK+BxwEdXEYLLE5YhOhlr9xrwaabozDJGrDU5WCNevrGvDfWL7wRFMDlvthq7qazGm200IY4jlvibDfbalj3LSVPs8/qBzQv2Ne1Tkbpcm/dA4nOxE+9ho5WQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf78d85a-a2a8-49dc-f3ee-08daf283d2a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 20:55:21.4959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KDYo2C+TNg6N/6uBSMBVWXub3Kqjy36G4eszk5gpG169El1+74JKX9dXMZI6zplB4AOUYNG/KWy3130aO36n0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090146
X-Proofpoint-GUID: 5HBzvC9FSrTN1w1zT0P9qoL0zkVACP1o
X-Proofpoint-ORIG-GUID: 5HBzvC9FSrTN1w1zT0P9qoL0zkVACP1o
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The preallocation of the maple tree nodes may leak if the error path to
"error_just_free" is taken.  Fix this by moving the freeing of the maple
tree nodes to a shared location for all error paths.

Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/nommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 214c70e1d059..c8252f01d5db 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1240,6 +1240,7 @@ unsigned long do_mmap(struct file *file,
 error_just_free:
 	up_write(&nommu_region_sem);
 error:
+	mas_destroy(&mas);
 	if (region->vm_file)
 		fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
@@ -1250,7 +1251,6 @@ unsigned long do_mmap(struct file *file,
=20
 sharing_violation:
 	up_write(&nommu_region_sem);
-	mas_destroy(&mas);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret =3D -EINVAL;
 	goto error;
--=20
2.35.1
