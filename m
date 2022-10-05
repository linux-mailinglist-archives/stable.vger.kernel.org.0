Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698E45F500A
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJEHB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJEHBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:01:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A7D6CF4F;
        Wed,  5 Oct 2022 00:01:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hmkj016892;
        Wed, 5 Oct 2022 07:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=VcaYS49LB++pG5ACHbpADnxcPJzawTYnYa+O5pG/d9A=;
 b=y6ipuGcwClR+HSTCSxZXqR4tD0E6BARD1nQp6rZkj3LEFY8lmHIaPI0urcanThEbKygy
 MHvT045vHQb3KYzRQfbVcQWIdfef0W88TVkq0azfVrYALBMdcc8YtwLSm2ngztLOKhFp
 uV6EhNBZiPfhVgjfoot2AbgETpsPSBLso3hWkD9uNXaMMwZq3bazEWshYNs7RJOudnPo
 /89jpTCGuRTg8lyXZTfce2DJPdXT0mapf/MPnkChry7DadATDjvVjsZJDT+EsBHFoCmp
 zUrGwnNjilnti3wq+3iS1lhfXRzWMx+t00rx3ANh3PR0+uj3CvmBRGKbHp+oZo7ke895 4g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea8gg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29557Ql5033831;
        Wed, 5 Oct 2022 07:01:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04wpe4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTqCTz+xkZFluT7BCmfPQi8/n36YN4VD+l8J46XlzV6b7S8hV+zIbQJIYVVR4O8IPaK+8Hio1eIQKfUZ/Eokfu0pqvMLIq4ppROac7b7rCYWGdHlNGbPRyR9Dg6DMC+rA0glP+i870msmKn4mhmrxozd9m0LRgl56gcrGo33y/Ex/6ZXDNHcha8GTqH4Lq1L+a+Ixtu4BX6Kk9UGXYntPG5YMzVXxHQieCwN3vf4RZN4QgeSA+3ClK9V5oZnwLlmliK2q1ufmShrYOdVyDhzwPftmeLecWwGDrtmK2QP+k6iqtpfWNC3Rm5VrCNFNL4OWVy7XJxscnQ6V6WEy4Tacg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcaYS49LB++pG5ACHbpADnxcPJzawTYnYa+O5pG/d9A=;
 b=LWWgj4Quyu6E0xBZ9M7OJu1aee314ryS8dIqZq4m3+I2Nqzki9i/bdFDRBm3XIi8nFFvcSbV8rpCNsocsL4CJyYohhs0N6p9gYCyUOqEl4K10ahfjf+aGP6s6l9yRyrIxPgE0t0IhVjs/Ipl0MWpsITaGxaOJn+yw3HaKCN5gkr8AgsTw4r7mZ5lnMVy9zSDoHzWjqV59nPK8eYhD17aAgygf9CiUF9NDaojlkErxR57gBgfXldTGtIVoX8sLOuxgItyIN65XQ/Kc7ZFyg5xHYH7EbB+0XzojcTexmqdhUtSzbpz+lHKg0Q/KpoS5W6RgamwqfJ7nMQ84P6zoK9BRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcaYS49LB++pG5ACHbpADnxcPJzawTYnYa+O5pG/d9A=;
 b=pMQClhaL2sntuqdI/CbrmQ2Z+GmmNtXPdJM+vTmEu+68RTrINqaLB8ECC4YzVxrZLYil8pinLvxxr+PvbzOpGxllVEuJ+DsrsSDnxxz/1zYw41T0z36kOOpFaHXCcnw88oGY/PI1ZlXZ8hASzRMhcNF2QYV7fp3lo05S+sRe0ls=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:01:42 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:01:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 04/11] xfs: fix s_maxbytes computation on 32-bit kernels
Date:   Wed,  5 Oct 2022 12:30:58 +0530
Message-Id: <20221005070105.41929-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:404:56::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cbb84d2-bdef-40d7-e583-08daa69f7521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcIJUhufBAS6u6Mp+0QuWktahc4xZEqnH/IUyLzpjLpHEfVx1CO0n9e3+7xHmGRjLZD+I5q+czmeXDp3oJOyjgfK5ioPIEisUb+3f5lhN6adGpxJb3QTCFtynznyicGPOC1rb00XHQiRA2gUUhkd1G/hWz2QQx6WzKacHDYKZZ71f0OSLKlBhRfQRFGSL4V0S2u6DgwsHU0W+iHw2Y7NrsEzeD0uFXByh3uQC6XzPzP8OE3+KOiPbFHu+89f5ZGhBpv4fwuW9yJ6oZfl4JmOlqGjYxCVOUTPmqJucoQ/Mo5spf2zUKHFhWYb+bLSaqDbfqhcO5oGnpWXaOCzmbgOeJ2wGmbJXHvib+tC8xSeSjs4GDYcuMN9Sa+Y/4hZ7SWeYjlLWNhIYJF/ENxeUqPx1cD6DZN2ZhgudzY1Ekv2rv1Giq6zAQqC/gc0o0cKGBwaCqMXQgOrz/ufMRwEGrIus3ruLnt21oN1azitdI0H+Ud4OK6Hw11DDQztahyDRlWLuYVGRgPkGbEu6z5aa3FRSpsYMvjkZuFubkRaX8d0GiVR17t64Z94XXDQT1ihPQuTqam3JAepKLq5BdZkME0gTvVlqpP6wHERm7GKJULSsrqQ/08FnTkGkjbtrsRSf1ShCnhtB0kj0vnYJnCjbx9110XrAI9K6zaVAac5vZcPZH5ewrlnJ9QxzJY2bLjoh5lv+3H7p4bvTTS/8mOVyC7Ykg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(6666004)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P9zfXITEHLS5k91xUUqmr1unp1R/ecEvM/Ram9xZ+uqf6oGbQz7XU8f5SOqm?=
 =?us-ascii?Q?/EUZc1KT0QJwcLWGZvFH0SWK4YAYG1tCQophh7+rYankSQ5QHlPQkwRO/HRJ?=
 =?us-ascii?Q?Vi1Vn57Oz0JDJIZBwaul1rK0F8lI0lvogXMPF9ZTJifESTXrd/iG8IJiKIZj?=
 =?us-ascii?Q?1x5uWEtcNfef+q4ssFnGLLAovCNNC1pVdNKfsi0/poT00nKYN+iftxnNnCM2?=
 =?us-ascii?Q?IZazGx3Acl7G2piIOzHn8u/kWq8iJdnpnnpJEK5Zj6H21CQqwGZNlHdM6zyh?=
 =?us-ascii?Q?7Dfos/sBd4uXmM7RF9lj4W1o4HftaDfLda3uwNBUqfbKWD2xL+HDuzT+ygGP?=
 =?us-ascii?Q?ECZ5u243hlUMq7EmKVNWNA10Mn9ji3MhNPF+Ge5d5VV+D/WOOU0PEbj6w/Ro?=
 =?us-ascii?Q?BxTOqsekdGpWFSntBfWDXPk9K8oO87r7ExyxwXWR+4krmjYFbEA5zwmpcJxG?=
 =?us-ascii?Q?VueuCmucvmDD9ntnb8NLEGKhPMUlZFpIXNp5H+o09vxlgnjc2cNtc7dnVI+Z?=
 =?us-ascii?Q?doVlkrrcmy3UG8UjNY0e5nJ4jPeMw3xAx0KdrkEMSO7ksfhF5IeY/R0GTecC?=
 =?us-ascii?Q?qgvH3Ti0meD0wdGEIgquaPa1FM4GUFuYlY037NA4FaLdUC3BVWpCivEnMyIz?=
 =?us-ascii?Q?Iw39am0cdnVwgrHXYquMOuj25eNdCDCapVrkH0z/DYkOOYdGa1lvHRwzXoai?=
 =?us-ascii?Q?Dsf8JL/uW95u0YHciCUBvp5a4GQWr7bTDxn0Md3YoHAgzcr7gUNQF59y/4OR?=
 =?us-ascii?Q?Fk8lTNSCL9YgjSw1q53RKc647gj6ugTTfWqPrAEtgvTUr0z9KrHYYNamwe4e?=
 =?us-ascii?Q?BJJwdreBHF/sCvVv08m+t/GMsnhBs5sQKue7xHxVS5m6r0BlPM91RVvPGWNj?=
 =?us-ascii?Q?cvaFfSiL5msmW93xRzO6PlrKs4oKMfWGsSzu/Qm97XnCiddzqJerYRu+Lzwf?=
 =?us-ascii?Q?45Z1SlkoTDJYqDIMKLLYkjKgoiIYqbCxAz2fr5HOYRHLWr6m9N13rU3CdSCR?=
 =?us-ascii?Q?0tuFf2hsCrVg88kz+H6lt98H+s+eBptb1KUHQIEIeDrZEmzylOu88RpkGplZ?=
 =?us-ascii?Q?Q3IEMH0GXcjKZCovG+wajggW9xH6WIaNHSpuDwqwZVAQ+c9QGuVsLbvB87hY?=
 =?us-ascii?Q?fqg5H0YyHKNe+vYQy5PPg9QupzsT6a0I+p+GAPAhb7QNpNMG4N0WDmKuNqev?=
 =?us-ascii?Q?YYDZJXGrc/xmcyQNoPFjcolWEHwfSrClDX61AB1HmM099S04kiuXCjEs+kX3?=
 =?us-ascii?Q?IR1A9sL8tfr2VwnrGk0b3uEZZbhvFvP+fwDhFU2+rH3GAZoEdCgwUSPNi/LN?=
 =?us-ascii?Q?PFWbzPxjTeaqK1AZWCdmfGELSZPVrUzgQ0QMXFx/wcSC6FUhC9jZU1guCFDK?=
 =?us-ascii?Q?yC4uWYDQPyv8H8Ieqs8zF9EsoFRVEkDDIJG+hdxMfzAbXP8yGV/G5iAYmsYd?=
 =?us-ascii?Q?RYQXCQDEQR+bdM6/hgDWSBef46FD0vhsHBcYSsUH9uISeKHq1bucCEtnlsGl?=
 =?us-ascii?Q?7sr/HY/810MwAr3jMrCLDeJC/Ekrza8VDnFGNa9bF/+T6+Ojxa6R6Krs9yUT?=
 =?us-ascii?Q?tM3HuyCa6gaSQ6u1IFgOzVZuF7hNDo+qc7Fhcw0O5U+wkTqDzttxU1huf7Zi?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?hGmtXEC8NbLMOJ5d/znBDkyBdeGopaZvvvfcdhrs5RBhcsRg/h1T5V11D0ZY?=
 =?us-ascii?Q?exbTMsBc2Gy4s4KuHPjHydUTv/kcqCTqljl5JzXcCCUk1p2v91oID7U+ySmT?=
 =?us-ascii?Q?2YhwLFxWHJxAdKAfRrk0MA6lAqnf6Bm5QplAMcKYhYPu5R5KHcEdqv7ihsA5?=
 =?us-ascii?Q?WMC9NDcbElvLfNkpaH4UuOieHk4Ki/SwEGmJ/zTwoQErM6K1HuQxH1hDVxr7?=
 =?us-ascii?Q?3CR/oEWCVaF6JoWTw6hjmiEGWQIkAfs7bt6FXhOk++Z4+bNjJKFHnCRwnDO4?=
 =?us-ascii?Q?i25RFUTI1pLdJ//f6C0hjrGwyMboZuiA6Z30s91qV/x6mH4pS2xX+iygcU74?=
 =?us-ascii?Q?vd29puP3zY164445b1LvQGi6Y7BHhlQIj680k9W293AAenlx9rZzoYtELYDc?=
 =?us-ascii?Q?mcg0ukns1oNwbopWdOvGUnUqpqIqvbYPs8Hzy8SzG4DU+GOTYHvFRGDe/Ypb?=
 =?us-ascii?Q?uwc8/DWGgBy4XkSOwggSkB4r2lqIqEuyNx6ELsfU3vhOWE14wGOEAuGQHYLs?=
 =?us-ascii?Q?xop04frxBGcxfeXWZsns7ZhIah7g3agtWtPyt6sJE6gXbDFVyX/PIhNs6rM5?=
 =?us-ascii?Q?ILHMc1EMpoquQBwjLTTRLv1ElRixwpCby3h6UxmG2JKHGhZGf6PLI0ulJt+7?=
 =?us-ascii?Q?cAZp/CWlkdRFt8HoRC8ct6Bv5KEi2lUV0NO3Af3IWuPYObq4DwEULk2PpF7v?=
 =?us-ascii?Q?ZC7w2Epi+b+N+FSvRR1ECfXvv05qM1UcmuDUl/WBmFhoxcjrkN6qUJLKXBLA?=
 =?us-ascii?Q?dCCJJ3dBupIagqAl9iGGSu3bHdSLm79iBjwHJUVbG6it79xOc71RKgOS7tJQ?=
 =?us-ascii?Q?NKEaCTWyGVd3ctaYa6lrlNa3ccqy4LL2AV0Z5ypUZBZM6GGw0rJVsAdhNvjh?=
 =?us-ascii?Q?ZEnKxZUt0CRJGqKLqzX5xXutkj1skxAK1NXU125lateBOAs4xCQvwtm9OuMJ?=
 =?us-ascii?Q?Voe6rF5HwofEOz4gAiBR08BS6U8fXfG1vlUCMfZ5DwD/n1QvfbYjPXaZL7qu?=
 =?us-ascii?Q?NOih?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbb84d2-bdef-40d7-e583-08daa69f7521
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:01:42.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jeim6uyvqE0AcwCdQJ61drh0yFa/gaNMZHGiepT6Ge2wwrFR4CETEcLur7SbJhlR/H1qsP8X36APAlmpbI6t1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-GUID: duh38Blc3GCE6mKm4lcEkVgJw3Jjc7GQ
X-Proofpoint-ORIG-GUID: duh38Blc3GCE6mKm4lcEkVgJw3Jjc7GQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 932befe39ddea29cf47f4f1dc080d3dba668f0ca upstream.

I observed a hang in generic/308 while running fstests on a i686 kernel.
The hang occurred when trying to purge the pagecache on a large sparse
file that had a page created past MAX_LFS_FILESIZE, which caused an
integer overflow in the pagecache xarray and resulted in an infinite
loop.

I then noticed that Linus changed the definition of MAX_LFS_FILESIZE in
commit 0cc3b0ec23ce ("Clarify (and fix) MAX_LFS_FILESIZE macros") so
that it is now one page short of the maximum page index on 32-bit
kernels.  Because the XFS function to compute max offset open-codes the
2005-era MAX_LFS_FILESIZE computation and neither the vfs nor mm perform
any sanity checking of s_maxbytes, the code in generic/308 can create a
page above the pagecache's limit and kaboom.

Fix all this by setting s_maxbytes to MAX_LFS_FILESIZE directly and
aborting the mount with a warning if our assumptions ever break.  I have
no answer for why this seems to have been broken for years and nobody
noticed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_super.c | 48 ++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8d1df9f8be07..a3a54a0fbffe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -512,32 +512,6 @@ xfs_showargs(
 		seq_puts(m, ",noquota");
 }
 
-static uint64_t
-xfs_max_file_offset(
-	unsigned int		blockshift)
-{
-	unsigned int		pagefactor = 1;
-	unsigned int		bitshift = BITS_PER_LONG - 1;
-
-	/* Figure out maximum filesize, on Linux this can depend on
-	 * the filesystem blocksize (on 32 bit platforms).
-	 * __block_write_begin does this in an [unsigned] long long...
-	 *      page->index << (PAGE_SHIFT - bbits)
-	 * So, for page sized blocks (4K on 32 bit platforms),
-	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
-	 *      (((u64)PAGE_SIZE << (BITS_PER_LONG-1))-1)
-	 * but for smaller blocksizes it is less (bbits = log2 bsize).
-	 */
-
-#if BITS_PER_LONG == 32
-	ASSERT(sizeof(sector_t) == 8);
-	pagefactor = PAGE_SIZE;
-	bitshift = BITS_PER_LONG;
-#endif
-
-	return (((uint64_t)pagefactor) << bitshift) - 1;
-}
-
 /*
  * Set parameters for inode allocation heuristics, taking into account
  * filesystem size and inode32/inode64 mount options; i.e. specifically
@@ -1650,6 +1624,26 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	/*
+	 * XFS block mappings use 54 bits to store the logical block offset.
+	 * This should suffice to handle the maximum file size that the VFS
+	 * supports (currently 2^63 bytes on 64-bit and ULONG_MAX << PAGE_SHIFT
+	 * bytes on 32-bit), but as XFS and VFS have gotten the s_maxbytes
+	 * calculation wrong on 32-bit kernels in the past, we'll add a WARN_ON
+	 * to check this assertion.
+	 *
+	 * Avoid integer overflow by comparing the maximum bmbt offset to the
+	 * maximum pagecache offset in units of fs blocks.
+	 */
+	if (XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE) > XFS_MAX_FILEOFF) {
+		xfs_warn(mp,
+"MAX_LFS_FILESIZE block offset (%llu) exceeds extent map maximum (%llu)!",
+			 XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE),
+			 XFS_MAX_FILEOFF);
+		error = -EINVAL;
+		goto out_free_sb;
+	}
+
 	error = xfs_filestream_mount(mp);
 	if (error)
 		goto out_free_sb;
@@ -1661,7 +1655,7 @@ xfs_fs_fill_super(
 	sb->s_magic = XFS_SUPER_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
-	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
 	sb->s_time_min = S32_MIN;
-- 
2.35.1

