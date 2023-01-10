Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED4A664A94
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbjAJSd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239307AbjAJSck (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841C62AD5;
        Tue, 10 Jan 2023 10:28:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AIE6x5023204;
        Tue, 10 Jan 2023 18:28:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=ryq5ykfW8hyb5XMulMyq6cEQa+L00s9lDWKmuxRTQhg=;
 b=1xJb2n1HhqysQlppCfu6BRGZvJncF/AUToIId7yfoRrzqmyi0qHxFTNka3tJyX6MmAQd
 cjP/AmY6NlVfaK93lOvafDLS961lN0MEvuy+mdLi8vi8A2JAsqf4T36QSVHfd6o+tKLa
 2F3aaXeUrCY1eDbu4R3cK1tzHaAp7AFNKcqoFREhCL/uTtrV+Niyq696sJfM7PA6oAZh
 7hBCt+oZ6lHaogxTsL59Wo/BFzJYUNFbK/vXkWjWFTKbATBWU/xqtSNvLSJVd40QVQZz
 K87Ou6YSKrl2ygbQBcxldxk2pXrKL8sRV4GuKP7tIvfBqam2tJrOcfrqYoWzVde4JlO9 Kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n14nf9bt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 18:28:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AIBExv004227;
        Tue, 10 Jan 2023 18:28:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1b080n8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 18:28:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQLTS5U8r5qAZY+m31iBJRoKpiSWZbvw33cFBl/1DYGxcCZoSA/+R+lwacyhVHFLZuAiR7wUtV4Tf68KATAGZDk6CdeKYUcIjRkFpU5KxEn4hoZr6vMqc6BZZHlOMkjEwZMKQb+rU0Rd6zeFO9xxxpeUkM0lhVNJK6wiEHg+7Od/68ceF7yhB7SF9qVtPhERCr/+H1H05Gj+dyh/Wqn3+f/HzKLj85Aak4Lf8s5DaXQyX9CUKbIIMmTmdIeqNFhnFBJ3EHSjARhYDGIqm2Sy0BKbuy1l0TP7MWBgwHKzDyxsyYzk+37w7fub+4ASeVPTQpkaGFV0HPs5PIu+RRB1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryq5ykfW8hyb5XMulMyq6cEQa+L00s9lDWKmuxRTQhg=;
 b=Uqws9l4dsw6HGolLK+SJTSrd5xYTZfhMpRONbP9u1zONZvsg7g7irUju7QdkL7lnKfmbb5rwyFD9vw1+ixFlC6FC55IAtu90nYQmClyqecw7+ADiw4Z94AeW8CCq6CP3SVqEMOzTv1/1ciGj9GFiiyl08GDoJ6H/UFCkJWT86BqGFS99ZHU3eXDfj7Y3TqjvlUWejBiVhI7uvJxl/U+lBbYLITlhTilbzf5VeRvz67ybUxKDDTPQp5AyCSACGKrrfmvdJBvcFcC0FHdWV8aiNFZvFbiFZn9rAswo7iBXuQJzSNjbBnwy+D8Q9AGUwb1hVKN/lj/KHQq3x9FquODkRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryq5ykfW8hyb5XMulMyq6cEQa+L00s9lDWKmuxRTQhg=;
 b=fwDUzz8U9TqBL4Jco9uZjIGD7+Sc2RrCXiWDFvjnkQRTE6bZJwH79jvIXyQ1ob3MMjC0yPj8M1DmsSW39XmL/6SjXrJDjjUdTHcWtmGLssRMrvCoc5Wn4e1QUHeReGb2yUxl0mMkxMm42p0A1IKxzZsXOMPUMlauLznkTqqKovI=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 10 Jan
 2023 18:28:40 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.6002.012; Tue, 10 Jan 2023
 18:28:40 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     Liam Howlett <liam.howlett@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] nommu: Fix split_vma() map_count error
Thread-Topic: [PATCH v2] nommu: Fix split_vma() map_count error
Thread-Index: AQHZJSFc91hbkBNDZ0G1LcXL+sGTDg==
Date:   Tue, 10 Jan 2023 18:28:40 +0000
Message-ID: <20230110182819.1265381-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|PH0PR10MB4614:EE_
x-ms-office365-filtering-correlation-id: dab5931f-265f-4c59-4180-08daf3387f3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7IeJkWg5WcTq6llfvZtktEhZkdSUSkiCbw1eXTnQelbabbL1wNGffbvqQMvBYcb3QXc4M+/JDdStr6SJC9OH9w36sIyZHePkdYJBPxXvGyLKOuT/btIC3gi4kE+/t9jQBUavUQXsEM3mfph7fJi0Eg0yjYd8FzxNFuVmUbznLoT59SbCHBxNXNubHb3dHxUyl7JDNe8/1KqMZLZPZHlFvI6KXYoibpGm7i18Dwfuplc9mnxm2p662grYNxJbqN3scj1eCsdRRZj2mCzy8ea2N9GOqRIo1x5p1pmgfSaA0mNl1WtrjY2EVDkE8n4YDBltXoxFEaHhMY7ubYvuXE3G+APKLgtpBZFPGhFgrbz3hPv5LVuM6FKA75CHBdBR7yj30OabBTWx40S4uQm7oHCyDFdbbxQ8PeMBZBi/ScwDVgh4J2KEoG3Xw5jdwrcsgawReTIepgzk8ZxA0vS+ZNLIGYxla44Qt+MQTbljHv5FVAbf8/GaBvMV44Ds9bVzAJ4wE/CbEBLnNfcvVd/1yR28AFXQyOZMpJOGoR5G5P/I70UB/kNd+F4HEDYrgsl5eIT3gLXuxvSzdq+px78tqvwHGqJlT6N4uzBCl02YUIlajvqTRoQZfe9p3YOVvYofigt0r2RCjb19JYBPK58Uk3or9CkTMRfTeCT+4aL2NN0j1egAMnvk5BKSCdy78NJBMyVgdWU0PZbCdIPKGu5mi16ioQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199015)(2906002)(110136005)(54906003)(5660300002)(36756003)(86362001)(44832011)(8936002)(41300700001)(4326008)(38070700005)(8676002)(66946007)(64756008)(66446008)(66476007)(76116006)(66556008)(91956017)(38100700002)(122000001)(316002)(6506007)(6486002)(83380400001)(71200400001)(186003)(2616005)(26005)(6512007)(478600001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?wlwfoxFqbK2Rhv4dAzeX0t/3c2Bqpanc1HGZqy6iZFoSeQZhRVcq10HI6J?=
 =?iso-8859-1?Q?bauHC9J7toeiUBSrLE3jdWvoB8wpgjRgIg3v49vNV+mAY+4YDQOs79KyBG?=
 =?iso-8859-1?Q?bFghuYhMsoTROfNDkgZsxPulrGKPLh9Iru07ufRfXtHJcUhy2Jhp9pfiG/?=
 =?iso-8859-1?Q?3nvom+kICG41hoeJxbLpzLMBwDmS26ZdbHjkM8onAA50Pc9JUaXwbi6Oie?=
 =?iso-8859-1?Q?Umm7yYnPGSrD9ckBconLhwC4I9qlM4Oy4tLeQAMmFGz8vX6BpxwnR4XMC6?=
 =?iso-8859-1?Q?TXlsItEtmEpsU8RyISPEpf36k/NxyZRUtx7T7TmdmP8bL+l7eRd7MliT5c?=
 =?iso-8859-1?Q?1ERQZrCdGGu4Rh7UVZ3Y3ARaMy7I+hizA4cs1Q8d684vEISJtYwSUUAcJg?=
 =?iso-8859-1?Q?PjIpcnqiAuIzgO4q2yrtNPSq/YmlOAN1SxTn0/zVRgAeLx3O+3JJCCWNl0?=
 =?iso-8859-1?Q?3wvroSYegVhYOVN390D0Nqg4TRT+MzHfF6QhLg4xCP5Oq59LWKbvvI4Eyt?=
 =?iso-8859-1?Q?ALR6e8HqDEJEWeT3Fpf3iGfMkCAkH3sX8eSys8UBNTN4/l3POLh3NMtDnM?=
 =?iso-8859-1?Q?AVynONY5CbFcnjHzHbQVADvQIfAc8vc6YK7aFma7VWnhvEzYibjl/0O4oS?=
 =?iso-8859-1?Q?ZdxKAYoVn3ekNQKeeGWnsqJIGd4HuXG0oGxsVxHIWbAbwkcq3Cfr8fXmz/?=
 =?iso-8859-1?Q?nBo8ewgsukCle+FIHeDEvQFUAtHQdBe1zMQUZ2e3MDxAjLMM78jarNFn4R?=
 =?iso-8859-1?Q?RzcbyPKc4kGU936rEDKjWtOska4pupAIpO1/P0sIvntcavspmCFcLsRBCB?=
 =?iso-8859-1?Q?nzixlo29AyRMvh2qS7yG3lidGHiEuw6iMt+I2ctxS7aRGOvU3xUgeD5SWy?=
 =?iso-8859-1?Q?juWGdvVp8IRswXmcMUs4W1bOMlwIISGayGfQaFHU0HMEpTnWJufgva0Ni9?=
 =?iso-8859-1?Q?CQdTdNBxHaMWCiT7sbo1XO5yI+rtq9pdeRZrFbVZwhfKLcBkPh92Sz7TBg?=
 =?iso-8859-1?Q?wYfPz15yoVf8AeB0R8/4gA9dnO5QEEFO3u7mDrYWxdKZJ1w9RCkplvQrVa?=
 =?iso-8859-1?Q?LPAL+adyGo8Rbe8UeRMHmsTE5Y6VIhxOnDtUS9Yb9Nps8nHxGmrs74d6wU?=
 =?iso-8859-1?Q?Po6H9B8Hf00BnSHEaDEOS8Yd3Ilin1zXXZlod9XhZQfDLyg3ZayrDuhZwP?=
 =?iso-8859-1?Q?jfoZreAjaerw595ZzQaVgceEv0BPfp7MCrelWnLP8QVWkMl/6ir8XMzjSz?=
 =?iso-8859-1?Q?o+WYhkB7yedwIrBbtqep8DZarTuA8MVLxM874ILKEOArbO4+JZua0TUMhD?=
 =?iso-8859-1?Q?m4+cNKS88OOuGwD2rRS6V7Hbx5E92pSI9IDXBtK5BedB0NKnti066pOmnS?=
 =?iso-8859-1?Q?gO9ZF1tZVABiVUhaH3e9YUHsUHk/l7hE7cRdFLNiVIcRRb1dd7nCUR2AXj?=
 =?iso-8859-1?Q?IKrDIAAzgyUu4VJ+m73KKzcyv6RJms3zpUoJY2LX8yMXM3YIe2XOPzxph+?=
 =?iso-8859-1?Q?Fm2p9on93bs2aIfPh4HxNuG0KEfGmbSpuIKevXGhTV2MFh+z72haOW/Eff?=
 =?iso-8859-1?Q?48DI2gLyzjg3haeS0zVDMNoqWRt7KibTYD8l7b3boQ6lvEkNP/04OgER9a?=
 =?iso-8859-1?Q?P9hTqdaVAdeJAzpGVb9dUUz6fe2FNgkElpglgVZZXbYqRN0H1HGP8HLw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +lIEzPwQvPqF1I8PgNG04nf6wnjWB0MX0leXYHQYdAUNnvXENw9buKgMHz3duTelhrCbc277o9OfliOp9nUjITEAvJcdC/LVgEVlQ445gknCT9zqi+TW+nypGN3RacTBuEELQgjlsc+LPeQmQiDXJu2IgxEdb2lYeL0ixP7TZzSqfPmfEazVt7c33JM8+ZyIY0BmfA+/4Vn3ZEGmeM4kRERYFITPUKspzk5KHtb0j6Nfq4ytKDMkDLMh63LlGOBPuk8Dj+bZTYnyrjBVeshPXuGBFu7LAi1FsVqL8HyyXq+u4NZua3IypJk6s7tWHEmibAuq0Xq9SaWYr8QOyHy1ZQQ3PVOW1xqS+d136BFaC6rxy3bt66kAxNT2a4Zt4dKfEZJHcfF9jrAmFilj3SoM2k6pTCMn+Yj5yxO8SoGjnDxPGNfm800tPi/raUZvsZ45iw7Fbjd8FSESYU2HlTYlix22ZeE6BA/RHB1dG4fdFcB/LesSu/8DLsMndIn9ZwKDrnLfBm/tYY5RNKYSPXVHay9jigWkQciIkljfroxlVqMYHwDRKXD9t+RiOkBapjS3Vulk5XIBfRh61Sl+/16q+jTfGR2z8h7KqmSYVBqM7Z7TcAT13X8STHCP4Psi7BCzglCw+U1Opqu67wNYiUvfXO9lH9+3H0dBfVeOzxUbSMWSZ6Odnl5srKFoAAJO1BrAYz3lhEPT/qM/x1te4I8k3E1V0qOoGZq+5QwGzId9KRk58WVNvpy7FAAmZ70L6wdntmnmYBWB2bn0BGL6Psx4F0cwmxKhfr+LAkS+l3z9G1EBmWCSCNnKfw4OxNwpkWdj4ti7jtvNbNF7sdNR2EgPKu707DIx432w4PWfEZbqt1dhOjaB4VtY0t7rYrX4EBXzntoDZI5ps5/ShcWeHgLSxQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab5931f-265f-4c59-4180-08daf3387f3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 18:28:40.4604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CJEwqyffO44m8T33rwTvsE+MBax84S02UieomdgaTJe1+L3k8/TpW+1liCKqyV11eJpU1yJJI3w+R5XDTs+u3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_07,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100119
X-Proofpoint-ORIG-GUID: HFWmMLK4uoEI2VjwXzja8yTc4GdyXT40
X-Proofpoint-GUID: HFWmMLK4uoEI2VjwXzja8yTc4GdyXT40
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During the maple tree conversion of nommu, an error in counting the VMAs
was introduced by counting the existing VMA again.  The counting used to
be decremented by one and incremented by two, but now it only increments
by two.  Fix the counting error by moving the increment outside the
setup_vma_to_mm() function to the callers.

Cc: stable@vger.kernel.org
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---

Changes since v1:
 - Added 'Cc: stable@vger.kernel.org' to commit message

 mm/nommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 844af5be7640..5b83938ecb67 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -559,7 +559,6 @@ void vma_mas_remove(struct vm_area_struct *vma, struct =
ma_state *mas)
=20
 static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *=
mm)
 {
-	mm->map_count++;
 	vma->vm_mm =3D mm;
=20
 	/* add the VMA to the mapping */
@@ -587,6 +586,7 @@ static void mas_add_vma_to_mm(struct ma_state *mas, str=
uct mm_struct *mm,
 	BUG_ON(!vma->vm_region);
=20
 	setup_vma_to_mm(vma, mm);
+	mm->map_count++;
=20
 	/* add the VMA to the tree */
 	vma_mas_store(vma, mas);
@@ -1347,6 +1347,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_st=
ruct *vma,
 	if (vma->vm_file)
 		return -ENOMEM;
=20
+	mm =3D vma->vm_mm;
 	if (mm->map_count >=3D sysctl_max_map_count)
 		return -ENOMEM;
=20
@@ -1398,6 +1399,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_st=
ruct *vma,
 	mas_set_range(&mas, vma->vm_start, vma->vm_end - 1);
 	mas_store(&mas, vma);
 	vma_mas_store(new, &mas);
+	mm->map_count++;
 	return 0;
=20
 err_mas_preallocate:
--=20
2.35.1
