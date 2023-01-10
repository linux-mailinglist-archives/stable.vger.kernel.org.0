Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D66664AC5
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbjAJSgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbjAJSfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5343D17428;
        Tue, 10 Jan 2023 10:31:00 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AIEEtd023564;
        Tue, 10 Jan 2023 18:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=P1zsPi5LS1TxtLS98/bIJ43a1f25CNwu5blWhcNQduk=;
 b=ItfO7dVQvcDHyzJmU2AN3rwd2k8Wr3SqfXB0i0GZa46hXHac9bpcIGA6IMBkNbwC92b2
 dj1jkPkHHAt9xD5hV8TBHVQr5wmeqFnVJRuxLG04ZDqmC6jKzi75zPNhNXhGtGtuXNAd
 5D+wNBO0clWcPGRKDF7jCIuKhDBwwRktqN3vJCRKt05NX8lozvZx2i097mcXSRg9VIHS
 uZ/GU+AiCHyXyc2CtjAuAwK0ZAQ4paIR05qhh9RUTyCCcZsDVI4R50T2QPNAY3toSuA/
 07qwjtTenzjeW6Skepq3VL6UqUHvwlQkNALL+l+6/7xDAhC8CLBz/yYM95jZDHvWZzqa Yg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n1au1ggue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 18:30:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AHrw6o039043;
        Tue, 10 Jan 2023 18:30:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1ctv1q6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 18:30:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYzoLNahSXw2qlVG3WNTffBX4SykS44KfrHxJfp2DiG6zVm7/qvcWO9cfjha5AUZhtF2Twph8mD9cXSlYDcJ7GYTEYDEedA/wBe0vatfmXx2ldFWe5mgKSjGJPUZcvuan3EigFJ3tV3jIxqyxATom1RGP8B5BQfE6hrQuveUx+OeP7Yjc5A0Du/LjPGQc1pbb8tZZLYrcRxz3h6dNWn7w83HArdwYA0nUn7RC8M9nrZlpGg9EfkVhixQv6TOn2L0ruBzyjmoG9Axiy7LyAidkHQZhSiGeNH4g8mxvYX+rko5lBUFnQzBn1D39HIumEOMJ9RXa1KWOAobpokWqXd9lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1zsPi5LS1TxtLS98/bIJ43a1f25CNwu5blWhcNQduk=;
 b=HSm/rDM0uHfmyGKTvjapkNUsazX/dXACazAFI+oHynDZ9c7Yabvkp/xofG2FA+LaBtW2Tc4t9uUjlaWUxG1ve0j7kMztjhqrqOdCRh61no3a6CA9Wv6SmnJyp5RrOdDTCb0uZl0ZAU+G5wqM6usqs3LpYz/bMa83FEvJQ6g+mytJ8AZ56WDvpvvtpP8j76ZbAtgdLTFaAm5VwjTc2+j/8JC76PhQO1dUOLQRxY+BcRPdHHM6SCDpmBRi8PWV+KyXyOzRXCM8et1rPYfvZQxBfGowGORrD/XQeDWF1SCbqjw9vXAc96dVruYwNxgg2qH82RS8gYFULeT+SwoTvZnvWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1zsPi5LS1TxtLS98/bIJ43a1f25CNwu5blWhcNQduk=;
 b=A8TZdObpeHbkklWqN//kOpiMwsD/hWzUeI5A5aGhwYqbz7sqw1UGzl+NsyBTTE16Vi31vziGlpL8z6aPpJEKs5fXn//iNdgjUwec2aMQlIOUA9qj9HbSub/uv0mitqG46SEeMY7nW/rjv+evQ75tBne3BZlVTk4mgBEI4qOzF2M=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB6987.namprd10.prod.outlook.com (2603:10b6:510:27b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Tue, 10 Jan
 2023 18:30:49 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.6002.012; Tue, 10 Jan 2023
 18:30:49 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     Liam Howlett <liam.howlett@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] nommu: Fix do_munmap() error path
Thread-Topic: [PATCH v2] nommu: Fix do_munmap() error path
Thread-Index: AQHZJSGpDMc2b88uFE21NhGfPY60Wg==
Date:   Tue, 10 Jan 2023 18:30:49 +0000
Message-ID: <20230110183042.1265916-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|PH7PR10MB6987:EE_
x-ms-office365-filtering-correlation-id: bb8a4b6c-022b-4b6e-db3b-08daf338cc53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GEo/WnolRkKvA7SBIuyMDdSbV3VTZPHn6OZsOqsbBe2zyfOh5reDp4I6+fvSs70V3B/T5Zhf6GewM108Jspnf7UYFgf6xnl7FD9Cl5JPcaEzbsazquOnDH4NW7pPzlat/EDhvnaX21h6N4pvYlu19AgZ4BSJYkstcAlJ8TTLKgkSUCgaCIFG1YIRrxmE2fZxW+UgfAgiNiNpvkFSMzaosaSsQ6XnDiWi2FAeAMpaDZ1jQT+3DhZZQEpVNIb0NYthYu9usbS2K40Ba+7CsrjLj/lfYqlcuRU012legr4l9IZtLY9Yx7Xxq+uQVDQwgzL4BAphYQ27Lj4uBDF+miv13tVhSHf68/2k7oeAq7qXLmT/Irm9VnTzMN9e9wbgpffLKfKKjoAMRxvuCzy+7cbkE7GrDEWofEAAZIZOKePVw41ccO604TG7xeyoZiXjuoaqJQI6Ll4Z9WMVnjgdVrdGCjVlQfeD1RbpC8pw16bhlrSzBzBMfZT9jO4hmgcTO1//0eRXyi9vsK5T5C+Jli47cU2bjwyjzgUYRJ3g51iwJqVnN0wo2YnaxQiUkUoTSDVx3QZIt+5VEhO7NiG0qlHeGLWZUuW0n+HwRM6o+AbJyLxjCA/euimWuUPo9iI7isfh/u1payuINhUy42SZX03jIbOwm9/9zUsb3iqhx2T1Ewuxi7IEemGNuwi6O8MhdxYtCWtubOSmyO0SqR+t6qR5+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(41300700001)(38100700002)(38070700005)(122000001)(8676002)(4326008)(2906002)(4744005)(44832011)(36756003)(5660300002)(8936002)(83380400001)(26005)(186003)(71200400001)(64756008)(6512007)(6506007)(478600001)(6486002)(54906003)(110136005)(316002)(1076003)(2616005)(86362001)(76116006)(66946007)(91956017)(66556008)(66446008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rxwrYDI3wA2MGIGJWClOHxzdyYDPp63M0lWHRdXUSP9oCPu/ou2w3A/Gw0?=
 =?iso-8859-1?Q?G8JdsgaEcLxphn64aP5BifmPDl5ldatZuBPs95hE4zuod/tswpZNqPG87I?=
 =?iso-8859-1?Q?jDz85nLVG/dBuwcKYkaLqXw3PmZUEEn4jhOd/tPNkDnwSEfZs7Eym0Mnyx?=
 =?iso-8859-1?Q?0ACvFO8KkXoSLkisQtQBNyYvgQWfwHu2JSJlrUVbC2TK6TfoOa0DF+Zk5J?=
 =?iso-8859-1?Q?kJsg2JBe9UGWPsNWlALr7Yf9O+pIuM0Gp9qJRpqy4zHe2N6MwABocyUpkE?=
 =?iso-8859-1?Q?7wW3jI/+CyjAhSnLwn7UO3bVr9r8QYxeJRG1lSJGnScpq3oKXX3PjwNiDV?=
 =?iso-8859-1?Q?UnBpr+X230G9Enip/3k02nPZ2Nh8y9cHP7qjqEsxGoJF8uuLPQVO/3mzuI?=
 =?iso-8859-1?Q?BkvisD0w7n0+8PqQ9GAsN9vK6yMB76a291sJUrk4pbJ1OwFkqDsCMZHepc?=
 =?iso-8859-1?Q?Jhp2cu+F0HrxAXSM67/Uc6/K0ARcAei7T2FAsPqJ/7WzgXGsncwPr0AEAy?=
 =?iso-8859-1?Q?rswq2k12wbuHJyK82rLikjwA2q+HQuR7hSH67FY5NGytKW8G22AatvkWj6?=
 =?iso-8859-1?Q?Yov8P3xZRiu/TeLkGjEg8vCzkekb9dnuBM0A5wkVNFXnwcKt5lpC5WRyc5?=
 =?iso-8859-1?Q?qJu3KUakkXxzk2z61yMhihCG4DTGG0xP2D3Zku0k2M6Ltd/9Z2XF3/VlH+?=
 =?iso-8859-1?Q?YCcAzLew4zIlxKl9eaibBo1Ju0YonahGskpxbqjyv7+//JQ9F7euSBDp/3?=
 =?iso-8859-1?Q?BDJh27UvHN2XmUdZ90qjsk5WssK49wPMkp714PN6jrlbzlT/ZPNFvnCBYO?=
 =?iso-8859-1?Q?wS7Wh47CvW1FZ0gNC4/UfKVrZGVkNtMUmO1W+SroflnKlGglOpLgmtTZ4s?=
 =?iso-8859-1?Q?rlyrGOCHhlWx1sANKgI3tcdl/UjYlbZ+ByhPso1yO6jDY5U+mB6He/v0ho?=
 =?iso-8859-1?Q?KWILCeI4C7Fn+bbYzM6eRVBqBnqEvEwldY/5iA9js5NyYcve0vciH53LXY?=
 =?iso-8859-1?Q?eDawIkbDYt1vd8kli7GeiznvV3aAV7NsRwP/lrcA5Ch/YLTVSORQ6/vqv7?=
 =?iso-8859-1?Q?DRRgGh62xcmQavXc9fMltNreOW7DM6duh20SuNN7QFEGn5vievoVuxmGKE?=
 =?iso-8859-1?Q?7bpi94O54xYkvaoStocjf8RhaWzcUexHzU0B59QaroPsWSaDpCS16GoQ69?=
 =?iso-8859-1?Q?oenXlJatRnI066FxF4sH3wRbGSRjRhgbadoGH6SEDF26AaGkmByg8+FYBr?=
 =?iso-8859-1?Q?adHAe/V4F4AGZjnxxDKNtz7SvdFPMBl/fqKTdwBbiypdUOURIg78t/XZYY?=
 =?iso-8859-1?Q?nlD3KRwMw/N+UDdBJVR2JCrPIICDHtNpiKv8O3M2wuGv9jKXnJOjfKJev9?=
 =?iso-8859-1?Q?bnPr1fgQsrYCnHYYAPFz7gAV88OQzNIWnOJm9ka+WSwEqN0KVqqMR9Yo3h?=
 =?iso-8859-1?Q?IA1EwaLe2jKtw6b3LuG0xRk6Egs++3V+b0PxmPETnplMMaHWvriZhJ7Juw?=
 =?iso-8859-1?Q?czvhFVsSY0+nsVhO9J4V6XKN00PlyLafjoNn0VNbdvi/S8eWlqk1Id7GWx?=
 =?iso-8859-1?Q?NhP3QlsEwsNooDRin9I4J+fiDWNBXn3IGoaI+qvjFrxu5d8XXfA1la1ZBx?=
 =?iso-8859-1?Q?qF2cVyBfafK0kyuPRkSFMKRpzTvmmVvMa5MltPvX3GmORDWHfTcNjdcA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rHQ2OdnurtZKBIfd4WSlhZFjfHPKWGgrofoVOPPoL8MrVEDiW9Ry/AyT4/fLG8NSo/fby64mUewgnhGKML5Tea8bnC2CGmfNFuCEUGUl6iwKiDSZiVL3F3aUlV8dGZlkFi4DChcNw6c5og5goCmWpYlQdKRrgOOchsW3HFEgglouSh/JpY9dUtsp3d6R23yP6dYsVUqAV8p/bhMq4dWljY2XD6pvD3KVoJOLoHAIZAAb1ctinzHU6ol78E/mqH7+PIN85Tv9Q6Rul5KuXD4H5pPgaZR1pYUCbxJHQfI8CR5OYX9WtZ+nu5QmlomhHp1nobDJKID0oqowyvVnUzvuQOEhwFZKbuEsScbcG7T5rtFvNaSN/ypc7GVZ6RiWEirjOaTMPHD9b407+OkceJk6TK59d/axKgFrN0KgTWm8S5JIU6a2ZrRCY6qfms+hwJOH9kSdW2GvRZ0ULYSfw8MqPUnLCb0eOYaDwlZgnWlyruOz+4A01eOTb7n/LundeMiOEclcGnMZrT+nnigqWEGTrc9t9yqLdVsPTJg/rSxAY5k39VEVx9+DX17QGj9PZ/Lh5vc5Esj2pEAlUkxNc+9eKcCo62Mnr+gTlafTuKNeTUSCdxVzbffN8nXuMoEQifgJdxK4vuJPpX82X7H59gPnNih2NaL8ru1CN28BknOwqeZJXVgfikWq6KVeXKnDvX+G0s6ceo2a2DqD2cfTg6jIR7roKbpomR41mRy0pv+bRuo4Q/OAZTzqxNXgqqtrUD5Pyc9/4cuDkpvJEiqCvccdcelbXhhh5pvgIerD+NzE9VRw2H42MKcZUcMzNWghfF+cKtnP+r/FutwnjfUnjJnS5K36RiKUWq2wp5mpBlLjdgk8c3+kZbO8z7Qy2ly2cn624T9ekErzdJo556jpxiF7VQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8a4b6c-022b-4b6e-db3b-08daf338cc53
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 18:30:49.7643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RQ+NaSSwKEhBYzjE917q9CrQLurlah5+mcYvlsw48NwNx4lxi+46Gc02jkL9L5a8WvrrI0DNwOTRZbzqsUugig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_07,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100119
X-Proofpoint-ORIG-GUID: VOMH4siUafVhbDzpitgynhptpDmH7Jeo
X-Proofpoint-GUID: VOMH4siUafVhbDzpitgynhptpDmH7Jeo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When removing a VMA from the tree fails due to no memory, do not free
the VMA since a reference still exists.

Cc: stable@vger.kernel.org
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---

Changes since v1:
 - Added 'Cc: stable@vger.kernel.org' to commit message

 mm/nommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index c8252f01d5db..844af5be7640 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1509,7 +1509,8 @@ int do_munmap(struct mm_struct *mm, unsigned long sta=
rt, size_t len, struct list
 erase_whole_vma:
 	if (delete_vma_from_mm(vma))
 		ret =3D -ENOMEM;
-	delete_vma(mm, vma);
+	else
+		delete_vma(mm, vma);
 	return ret;
 }
=20
--=20
2.35.1
