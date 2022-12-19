Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF79651032
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 17:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiLSQU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 11:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiLSQU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 11:20:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2739D133;
        Mon, 19 Dec 2022 08:20:25 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJFx185007009;
        Mon, 19 Dec 2022 16:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=Zt6GIyi/0ovSmFZE2k7ucx0nWEoyFmnxnU0Mj+LDILI=;
 b=Y0ZwqwzYMK0zdFeQHtZgwiUv8cOtV6gyH568sZL9oi8Xf3EtY4ZfHFISYZhb4WJvSlJq
 IEoFzrolyxvpb3n3WQdvrEiTlmgLKNWXjWVjDu5Xw61M7UBo5z8atj2i+w9B4oU6mlW/
 QhYh8uAd2r1PP5ZRNeMR8B7D0Tt7Imw/KiaH85kWzhvXKvFHYQYI7P9i465d6GJp0RN7
 9FdtexkYzji7FJ+c3mjrkLpIRQVdpDlKy21D3DNGGGgM4ed3Sd2BKmzZyfuX0I1zdhhC
 jN3mLxkvAo46i83se4D3k9m2u4CZp13ZFIxa/1+wBh6Wlr998OSbz7DD912A6dyO3JJF rw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tsu9xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:20:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJG14jI024107;
        Mon, 19 Dec 2022 16:20:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh473yhw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:20:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYs6aP5AZkfqd2O05PHRBovdLmH+eUOd5OWpf5+MOiRJO9kbRIoR/iyD7FQ6+RwgCAGO0rIZsFHwg0LDC5H+oj4wT9SJiPM/ca5j+4ypEn+wh2ssac67DR90KP4Z53Pa4zQhCbyc8tn1SMWw4Gr0dPpGq3YLwxKtCnOrp3JbDWBjxIFZ5sbsvy5b3AxxBDWwabEZO8q0LIT4/e2gl9ESCuJNZGZwKzggRlPPscJDkd5YlM9R5IR2swGqPF4CRhYLAaILSORVRbl2WP/LlajD2wfh+azAEIjL2CE1L6EP1l0MJKFdruE2/aBcFfAkJfotPAM8gWGmbHpe622nVQeeeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zt6GIyi/0ovSmFZE2k7ucx0nWEoyFmnxnU0Mj+LDILI=;
 b=oNPnm9V8BEI5d/YL1aq9YDUVl3iRluS8gT17LUiYptMvu47I3BGLBGrJx9X/l0FfIx+ejqyATlIypEbev0q5QWr5HM7z+kYZY+jUt3bIxNIn/whsahNaGzFrfcLhs2ARhgImeZVCeyHLWKnfjw6GYBKBUcGMT4HRW89HM4dVENNU+Qxb3UMAQmC1EkFXhc5YXuocs4at/f2Xo/2pEoqT23eF5Q/s3aIRhqn+FkOF1F5cI7gGeJwLKSgTN1Pq9D8osPhysQMBSm6mWESl5z+NGd/AIqUpzgKuuOmetNCeAErEbrGKZ3vIVlFtIfbJREvFU+17gx18FdM0wb5Flt5aYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt6GIyi/0ovSmFZE2k7ucx0nWEoyFmnxnU0Mj+LDILI=;
 b=GkQkUH4++7BeYuWX8mKJUVnfa4fyX+Rl1V2TBnpEIJ2fVdZebHt1pKoPr9HfAjbsFvZB5ivcwnOCER585YZJ7gpILxbBZAVAHgWf0xkwb85CDia0G1Pq23BxqlN3NE6qgfe6KH29pjKo1C04B9/jfQV6pGl+yABKQSGyl6IrHCg=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 16:20:08 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 16:20:08 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>
Subject: [PATCH v2 0/2] maple_tree: Fix mas_spanning_rebalance() on
Thread-Topic: [PATCH v2 0/2] maple_tree: Fix mas_spanning_rebalance() on
Thread-Index: AQHZE8XCFv42pUROuEOexRNy5qOdxA==
Date:   Mon, 19 Dec 2022 16:20:08 +0000
Message-ID: <20221219161922.2708732-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|CO6PR10MB5652:EE_
x-ms-office365-filtering-correlation-id: 8ce01586-0c2e-4fdd-9b39-08dae1dce568
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eyjHDEcIiFYoavbZuCFvwNziDM5D2MwpL2OoY5dz6jIjcXCDaXZtSCqz4Qctog0qnoeKlWdPzAlfZhZO5T0fy9UbMrAE7cUYSpONPkyakAUA4sUv0NJTwLB0cdTMX5CUANalWlNSQdTXrnbJcH/Dh1HBIg7pCWJusFKYDqld4zYzQHTlefKzYqqkMl8qjdBtISpGYjw9JOz7apv6F754lSCgWwgshcGMok/NExMy8GAU/+ador/9RzsDjgAqTMvo8emJvYReHaisDCPyANskKnyHb7G52DMLicRyFKSJCwzhC2hF/J4qK1SrA1CxxN4Gr3Q9EcQUhyhy/vLxyk1r8JiZPUBFp+pT8rEMLpLZzJUps3wsrkcWw86rh1RhPIpjwxHL2CD7a+KI4nlcIyw8/3jlhh8f+5chvxkVVAFTmS8tlCX/Xl0hHOqSh9JHUILivYeDpR71C9zIg0+ZVuhOPAv0qiEMi2eyPfiMawXVEOZXpRLW4lkCd0sanXsKB80nvA4EADAnkWrcU2yVNRRiHLlZ7iQleMh4h6LGyjtwZBxHF8/fbIDN128lNa9VMbrbA0Wg9EfdQCc2LQwDwbuiyrLFqu31QRkWTgMmepTkgqS4amJ2ybU3pGiNYeOYXlcF5LyNlGI66l3UsG4ady7pxEbK6MAv8ARd6damWRz1We9NWFvtAGMdzkHS/WUtFjUFXNqjoPpvILngSf2BPNKd6ukx6fH63geYHxwVuylMAU8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199015)(107886003)(478600001)(6486002)(966005)(71200400001)(6506007)(86362001)(186003)(2616005)(6512007)(66556008)(26005)(316002)(66476007)(66946007)(66446008)(64756008)(91956017)(54906003)(76116006)(110136005)(36756003)(38100700002)(41300700001)(8676002)(4326008)(1076003)(83380400001)(2906002)(44832011)(122000001)(4744005)(8936002)(38070700005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?iLagwMbjT0jBS071ZeP7Y9fUsx9Q4ST+hL60r7vUUyIdOV/q+IYH54a02J?=
 =?iso-8859-1?Q?ucBKxJ2HHHE04LZ3DiQkOSuHCO7OkoZWlOXcraY448O8ce2Se/UOp0k3Bg?=
 =?iso-8859-1?Q?YA4UswYPronZsY7wxLPJI4xpZD0Rg2AARaxiBVrlNU50eFzMDua0KNBjMC?=
 =?iso-8859-1?Q?9+uzWYROBs5MLlWKopNv4o6SZvdad9vOYQ2/Tua7SLejwZEbVA6CvA/hgE?=
 =?iso-8859-1?Q?Pu3ZCj+d+a6FdW39t0WmaavuM/K3ImtkdnOGGVqky54SDbVe0aOGo9CzCC?=
 =?iso-8859-1?Q?NdzcQ/KFgfi0AYIr4g52m77nkz7iQeFH7BE1kB9h+BPs0TJMQOQVL/52TW?=
 =?iso-8859-1?Q?1KVEwzoGZlcDRxpyZfO4f2wkwRzoGEmy3fZPoALa+QOq7qINz9zhrMfCz3?=
 =?iso-8859-1?Q?fvAvOhzVGXiaZ+97QRpcS1p0d/8sJCpjRcguZgq9xoDnfDk/x0BqrK9+kM?=
 =?iso-8859-1?Q?mvSLOjVJO5XFL5Fh8m/szXkEo7jm1mRPCulcy0+bbiI8jE36Qknqdy63W6?=
 =?iso-8859-1?Q?WK6fX19SV3hM2mY9CZmZR/aN0us25b+T6WYQ4oZgiQSniGCPhUfucxujlO?=
 =?iso-8859-1?Q?2CPaxdx+h1mNIbkrWUqAC4+z8A1CGe41Q7ZjYbgnNoyRnmjAOftVNOL4eH?=
 =?iso-8859-1?Q?Q8NM/n43cg2NPxNq9Gn85yza95eVNFrPd21BoLYFMjzFO3SuP4CVZm68+z?=
 =?iso-8859-1?Q?s3dj8pbjzCOuYaTGtQmWJgDjRL4sJLAUOfw4eb7yVcmQ0UfEA4jwOKKVxL?=
 =?iso-8859-1?Q?YJlU7XQHoS0q5JSy19jdOhP+RYe3D8+QU8VvjxkqZtbmSoQa16Pf9X7h3n?=
 =?iso-8859-1?Q?8j49pTynLxpZ5U+/muAgx2RW/4S/MU1ytxs5u2e+ykR4KsKtKGaDkIlKK8?=
 =?iso-8859-1?Q?L5AZHkzGhR8p2rLBmdOi2aXlvqOpFGW7/BSfsUknI1TwloJTWe7zJl2H9e?=
 =?iso-8859-1?Q?e/R1DlfnivMRUv/K7XdOkxrqqRVIRMCLqN9xFpyw9Po82fwwdQ0MWtCTxB?=
 =?iso-8859-1?Q?JNGH/oS18Kq/6MzxMFClAm3NKWFygefLsj8RxJiYBi+qZ5UoVkhBObVLx3?=
 =?iso-8859-1?Q?lBa4itfCSpakUsAUzn+P1+KLp5qbnQvQryVqhNALrcK/vSUhPiRaGaSb+B?=
 =?iso-8859-1?Q?Ed62VC74RFH3RG1AyuZwJ6YJFFEaCLuekOdHZoTYW/lf1Lo3kE1VjZaUIA?=
 =?iso-8859-1?Q?OoOSH28IW4pwKyVt0PPmWcwnPsUjdcNKXafr599PSLbv3lxX8CJuq4I5pq?=
 =?iso-8859-1?Q?4Ez5oAnVhkX6g/1HGcTMqmTXrQNsWpqlf+896uSyaqlEHptGyx0pePesPb?=
 =?iso-8859-1?Q?p6sp8/+VOdGp6PymfouX4Ii2wtjofoA6/qy1duhxRQKamtkSWSA/3FwzWj?=
 =?iso-8859-1?Q?iBGUvKdR5g1nCJ/xc2m7mO5n9zbjZng7eq1x4vTEVJiyNgk82eiLHXr9rg?=
 =?iso-8859-1?Q?PGAgQRfDMzVSbz/n9J5fizPtTkousl9lvl6igPH8cOKq5YLNzcDrQdGrfY?=
 =?iso-8859-1?Q?aTQWm11wLmbpPrwLCsUB1rFGyc8U4x0My056KYHZ5T/KHE2nH6+XgzKXPd?=
 =?iso-8859-1?Q?/hpIG/sXZfnsP9iIRM3qJwwOaYcubhnrsIuTTyGju/OZT4pBppKEnk7VLr?=
 =?iso-8859-1?Q?NQLypv9aN464ZTtckVMpbqKjBmbwtXJFB4oHWkG95y5j2KI/HduaCzvA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce01586-0c2e-4fdd-9b39-08dae1dce568
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 16:20:08.3926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /0B38p94I4WvTFWNN/67Ge9cFc6sJeM1YosWFFcjMglNK4Uj9P2CGdgdV9ABestQ8RNId8qdBPpTie7DcJRVLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190145
X-Proofpoint-ORIG-GUID: VAzp1tV7DRNfhiFfdDc7ewTbCmmOyA3P
X-Proofpoint-GUID: VAzp1tV7DRNfhiFfdDc7ewTbCmmOyA3P
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mike Rapoport contacted me off-list with a regression in running criu.
Periodic tests fail with an RCU stall during execution.  Although rare,
it is possible to hit this with other uses so this patch should be
backported to fix the regression.

This patch set adds the fix and a test case to the maple tree test
suite.

Link: https://lore.kernel.org/linux-mm/20221216185233.2036415-1-Liam.Howlet=
t@oracle.com/

V1 changes:
- Add stable to CC list
- Add tested-by to Mike's Reported-by.
- Moved test case to its own commit since the test code was added after
  the fixed-by commit and isn't part of the fix.

Liam R. Howlett (2):
  maple_tree: Fix mas_spanning_rebalance() on insufficient data
  test_maple_tree: Add test for mas_spanning_rebalance() on insufficient
    data

 lib/maple_tree.c      |  4 +++-
 lib/test_maple_tree.c | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

--=20
2.35.1
