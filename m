Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8AB6AEE0D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjCGSJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjCGSJF (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5F096609;
        Tue,  7 Mar 2023 10:03:19 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327HwvTr031006;
        Tue, 7 Mar 2023 18:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=myk864uxv7PQ66OQH5z6ZuRs8bZGMnaNKR8rsm4mdNo=;
 b=ZYb8noM6ggrUvBkUyJmJYhhkjnYRgPHGxUmCSyCuCuEdFU80jArWmu0Ku+URBu3Rtoj7
 6gdLU/ZowyetIvrVqkE3WI4ME0+Yko11HnX+c5e8T1a8ii6NXJMhf6y7TAx3UT+EKjp1
 UwOFzrCzVc9H5YmUI3xGoJnQ9y3zmrdZZSKcT9sTC0cbb6vdpMv77k79zkcVS7H1vn5A
 Dw5wQpMGluo9i1BZWA9TN+unoMCSAkHujXZuHk0aOoQF3EzYOzO20XGwqKMKF7CGTgo7
 vRhTQoHgwrYNN4MyrMfBvGfCXy31sCKTuFQw9RJUtVFV0JDYxgmWoa9wuXt9lke9WEiK zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wp7xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 18:02:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327H0btN029145;
        Tue, 7 Mar 2023 18:02:55 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u1fcrn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 18:02:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LI4pTNMoueRUPDqiW8NttLl3nJLCa7bz6OdPRC1uF7ilgfwB/PGVylxmKx50JU5nWjbXJ1F5sAaj+pfV70Zz1/SiOZAxQvv/NLdNRscXQm17Ii0zNytWPudpr5A4iQZ7EfjRMD2x54uwPkk7dT0F5A/f5UZfe2MX8xujBSLVCKliizD2ZqzOmzQCuAo4i29b97zKAZPprfIjj0sTJ9C5l7GHPbVZKXcSLMrVaO09hG6Y1kptzl5eM6xhfd/dZJcQq4IM/6zDdWR4DruZykinBcbyfG/DgH8vFmNKgAfFt0Q86frLyCEAyRWwE+MZo224B7jsl+p7oiSAToYSjKuhfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=myk864uxv7PQ66OQH5z6ZuRs8bZGMnaNKR8rsm4mdNo=;
 b=lGreAkxELU0twyHuMV+RA1qkadq0t99TV3B6OYNUJOL60dhJYafCJjJO2gbgLqI/JPSnDF/jJgpuTZYHQNmCjaJT6PcOBbge2Q5/QbepI/hYK/Fdo1Nyb8YEmI2phKwNiiaKuV5jrm4XxFQQsAA2aoGopBpOWKlAPYMWVpNvizT8D3qXkBSkkKHpRJ8s+cF6U0LZknHGUl2f9MiIC1jK0pb088XDdLsyE3eqiUdGWrxmhU2rkzk0scJyAPw6VK3l3n9oTKXtfyBNHBQH3tvWgt8gtcTlt5itWCiQkZa/UHqh8Xe0nuUtWumUmK9VHXONiQ2+ahha2JRRjiBYqUBMNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myk864uxv7PQ66OQH5z6ZuRs8bZGMnaNKR8rsm4mdNo=;
 b=axorLpRb7wqsVcSe4tqCgTLx0n1z2pPD448TVa02dRBAwkeIMfqeo1u476wSuOHZSJ8qfIdwBaP93JeSCrPzoPwfXpz/kFwWej1DM+9AcOqkRPn9FpiD3oWO0wPf4UERz9Jg+stwQ3BLY/vja7yG0KhVZ8s+DAeVUDhpT79UIKc=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA2PR10MB4650.namprd10.prod.outlook.com (2603:10b6:806:f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 18:02:52 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 18:02:52 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable@vger.kernel.org, zhangpeng.00@bytedance.com, snild@sony.com
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 1/2] maple_tree: Fix mas_skip_node() end slot detection
Date:   Tue,  7 Mar 2023 13:02:46 -0500
Message-Id: <20230307180247.2220303-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307180247.2220303-1-Liam.Howlett@oracle.com>
References: <20230307180247.2220303-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0002.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::10) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SA2PR10MB4650:EE_
X-MS-Office365-Filtering-Correlation-Id: 896caedb-7582-458d-a5e0-08db1f362bd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+p0UdkSPNW7tna87xT4zlawE71TgJDLsTBBbVtvdbYjHFeJmxFE7RQgbYx5GRTf96zwCWOpe7dv6r0pwJwteRByX3yB1q1FFVBpLLmHse1YIRZ84zS1YwvoxrfJCrQX/v9GSSq1kGqFUsuJwwUGi5A5mVHe+10EdE6muwSA14RHWhNxcVvnYQmJymR/8DeKvhCSdO0VdD06RSTYsjtnsnZlzM+2JG6NXuo+wYciWW0ktfrb+I2lnxw2wySFpedKaGqT0wcAYpa6etbHUPAhPv6DnXh3wsTy+dd1HI5w6COwjMnhtGwk2VIB6D4Ou1UQyXxV1MeIX5PasiaXcameH1HpzKdZj9uINPxUkQlxSjo4qV8EFPMAy0ZX5HOYrG9LyTdJvZ5m7gAn8DfSxOmbftQYf7N4ZEcnfP4wZalS39lQFVjAnUfbvcuIF5FkwXD02riNrcMAS1kjDLUA/FIVlPzwOI/78/+lRzdC542UvJbOH70dZz8iNBDDLFZc3hJzMnOG/VZFRSCjIbyYijLvsiw+rpWHxKZ/AJvCXlp0UEaizcUWCTgd+lKmKqSnQ3CTyTDPF/FynroW/yQIFC14Q0qLmMIU1jllh390nVyL3cuuBOp+QIxZNTFfsbInPqyg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199018)(86362001)(36756003)(2616005)(4326008)(66946007)(8676002)(66556008)(66476007)(316002)(26005)(107886003)(6666004)(6506007)(1076003)(6512007)(6486002)(478600001)(966005)(83380400001)(186003)(38100700002)(5660300002)(41300700001)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2eUfP/2qwNfbq31r3p/O50Ur+nDiVXuCOzjCnrqpAzipGyDdzAC9h5IThpQR?=
 =?us-ascii?Q?jMvyCS5SKu11j6SfweD2mUgHB4yDQniOw6vslOkuuZAnVgUAiNF29xOs2dn0?=
 =?us-ascii?Q?h87qoo3CcZCurzc1mPOPAkeP3LAySu/gr41tGW53ekIPPbZIuTzoU7sKWqJ3?=
 =?us-ascii?Q?4XQ7VSy0wDpe+Vw1JFnSs9482cpwcepoh9505zphKTlxxSblrx4yW94g8e20?=
 =?us-ascii?Q?Nhq043xNNEY7qsV4TbLwM0MB1cR0SIazcBOhPHyYJbUrigDGsmSKUfCPIpAX?=
 =?us-ascii?Q?Dw8XSiAVGqm3pKbOjQFAPa1zXPchMtVHgh4LYzQSCVsHqy0M+Gydwd26MSyR?=
 =?us-ascii?Q?k4sOjL2gfNt2wKek6Cb5tZR3V7nj4u3znuJTxTUDNk/BFlHf4uzTRhrdjMNT?=
 =?us-ascii?Q?dva4GBTjaAm46W3Kh0jDKSuirykY0dmXqZyS/QpF9qLQh5baOVNvRDJgbWnY?=
 =?us-ascii?Q?ud+EEOLMDVDfcMLPRtQHzNCImCJq9LjnBXMyMO5OcONQmSef7Wx3mQ1+FNe3?=
 =?us-ascii?Q?mNrY2W8ueFKjQNv5eOnlcbAJfmvSTfUDOltcO69e91xSzynNELFZCWxio1qA?=
 =?us-ascii?Q?pID904mmkudIMBp1FBnyQfHdDSgnihl9PrPv9GEFCD9k9JJxhVWBPgWmro88?=
 =?us-ascii?Q?jsU1KR/lE0fagfmfsoTU7fJJeRZI8+2iqaRUxF/72WqxB2LUNMnhlQB8kvvT?=
 =?us-ascii?Q?b5NB+xr4OObP6mXMgT0fTilLodGycD+1QEaIiNec+V52MtI+Qa+CNsjOlAZ+?=
 =?us-ascii?Q?pQuL/ALCuZLyq0YBQ0SauRxfzmJ/6HxJaLO8VwMmPrPHqdjRON9TTAJWAo81?=
 =?us-ascii?Q?sp+fajTvSorsndVfGycHYhd+pYpZNu21MvIfzD0VRdptKwJ6iO4ijy4ssirZ?=
 =?us-ascii?Q?9vh1d/8FegDmqP5cUB8LeZ/3rKC0ysHVgqV2uk1hxwgRlM7s6YJYBw+DFL5o?=
 =?us-ascii?Q?X+gdY6UuBbZqEDJTpoYnNfnU0WoJPj3443fT0AXMemnGyMJSaGb5XRdDilyv?=
 =?us-ascii?Q?W9DhWSvwDETVPvhnN736Yw8kHgBPoX58VTN2xNuZo6Il1B8YJgJ0MZPLnNMi?=
 =?us-ascii?Q?fPrv1vPutAMKJGxuZHQkO1//FNcq709Jflxz0G4bkEzROZAOLmZgu7jO9Uqo?=
 =?us-ascii?Q?GnvtznoCDpnn2vU9nHlyQt44xA0OUOpjWYAWKNrk82mWCoanoDFFEAR2mxPR?=
 =?us-ascii?Q?EQ+rhfYPhrD2Mvw3KWq+WFABGyCiebV89OBy/tKlSYL7wUNzFWHK+qBDa6lY?=
 =?us-ascii?Q?9WfqXHm+fdpNNazcoQMR4o1ogPjSNBBqykjAi67OxEQv2F/4yVYMA04YAvht?=
 =?us-ascii?Q?xAvPQEVQPNL04hTelZZk+WrdynOScZ75Wc0C+E1cox+0HyYRSOwNcE7n0vMz?=
 =?us-ascii?Q?nPJVLsd2SaQyu84+LbG6wP7TJ0yGF+7BhdPXOJUk+OqTIO5u+kNktNfO+sy+?=
 =?us-ascii?Q?VYzo4VWOebggZMuMwkeLDaps3sL7GAeens2lpqbonA6pqZRgtAEdnpw7n0Ie?=
 =?us-ascii?Q?uX5thU2WQW0Tktv+vI4x8gDAAYCtBoxOXGxwltaPGyJsIlTLWY7OcIdgc1BS?=
 =?us-ascii?Q?Wg0ZeQLxyGuhCXh4jG4NFOTvaY8CFPe2jkxJTpUAoevz6JKAizPPhOQnlhv/?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?XfWAJrdOmQVTcT0n6aW8QM5z8z8A8wmGYF1BOqxQofp4w9PV+HLn0F+3NUyr?=
 =?us-ascii?Q?kNCHer9jqNMfCS1U24xnBFp10MXg7COVF+wWsU4bPiIFLKMiqyZL7snUfWb0?=
 =?us-ascii?Q?qkk25uO6FjGE2405k0xZT0ckhU9FbbHQmNLAN3TztBHlVVMYp6X0CTR3HCRZ?=
 =?us-ascii?Q?aer2wHxw7GNqHziNPhVCtyy+/6T7C+nuMT/lgQCIW94SjRdv4nTDKVRH4gNp?=
 =?us-ascii?Q?dvelA5gY81gSs9UmhAVGnCkzMXb+pRcU4FQ3RsWJ18F+3dZi8bq8/QaYj+CR?=
 =?us-ascii?Q?oVrKHnI9dGfnMZtbrJKG3eCWfVmNFB84ALYDj+JRCvtMzyjywYbHYj/6FnET?=
 =?us-ascii?Q?NwX5XAkgEuWfsU2ndjv2Ryo6+yhn9w069rtsgJp3omkjqs6Yf9g8D74HsR7f?=
 =?us-ascii?Q?uXWE42eSsgF9uqwtoDAbGTaPw9xOSc5pBo0JN/RTt32EahDLJJxSU8sq2q/F?=
 =?us-ascii?Q?2rTmk3MHYuUFM+BmXCc9hAB8NK4mZi61b4dM1/vnqFhIOsnyN0HD9Y2afTCb?=
 =?us-ascii?Q?AB+qxY9TTAmlKeKULN0PY0z439jOhgxw8Z2Dao6JKLZjYGE5I8vYmo0ojv7L?=
 =?us-ascii?Q?0bGv5vxzlRaX8Aes1ZhKapEKrUH5f/617/ERI0pZUA20rjjyedotqPb5M1j+?=
 =?us-ascii?Q?I6Z/KJMQfSjkE2kf7ryv1Kpow8f8YIoufODQ6LNhxolf+JcO56e7imOnblVc?=
 =?us-ascii?Q?o4kFfm0I7SL9rNIaZmyFRbkJgX3QzW64q2vzxo22oG2eWmOhztY5qwp0pnhM?=
 =?us-ascii?Q?lbKXbiwtSkwjZ47dnQBrXr33Y6uCpRsZ2J0RPVQCvnbvau/iCONbEClqU6aB?=
 =?us-ascii?Q?eecj3xFjZafRKfloVSxwJuuxKcLLn74mUXMhOLWJ2xg3NH36bgUqQ9b6ZtBY?=
 =?us-ascii?Q?Hmw7xlmnVWI4fRhmXQUeFzD8DTQNcsv8KtLV3JYWVvyZdl8NsqJFW0hxD5yf?=
 =?us-ascii?Q?1mAshz1hAqt/rco040PC1A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 896caedb-7582-458d-a5e0-08db1f362bd5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 18:02:52.8111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7vlMuD6Z2clByMwPUHfJz/MbbwsFHdwj0IgsE83sJcTC3y8oYfsMEOl4e+bZ5NQAcJ6sZyShjbZbHdhbpB00Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4650
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_13,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070160
X-Proofpoint-GUID: YdmZPtyy1XFh38cGod2xytr6FYufmcMc
X-Proofpoint-ORIG-GUID: YdmZPtyy1XFh38cGod2xytr6FYufmcMc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mas_skip_node() is used to move the maple state to the node with a
higher limit.  It does this by walking up the tree and increasing the
slot count.  Since slot count may not be able to be increased, it may
need to walk up multiple times to find room to walk right to a higher
limit node.  The limit of slots that was being used was the node limit
and not the last location of data in the node.  This would cause the
maple state to be shifted outside actual data and enter an error state,
thus returning -EBUSY.

The result of the incorrect error state means that mas_awalk() would
return an error instead of finding the allocation space.

The fix is to use mas_data_end() in mas_skip_node() to detect the nodes
data end point and continue walking the tree up until it is safe to move
to a node with a higher limit.

The walk up the tree also sets the maple state limits so remove the
buggy code from mas_skip_node().  Setting the limits had the unfortunate
side effect of triggering another bug if the parent node was full and
the there was no suitable gap in the second last child, but room in the
next child.

mas_skip_node() may also be passed a maple state in an error state from
mas_anode_descend() when no allocations are available.  Return on such
an error state immediately.

Reported-by: Snild Dolkow <snild@sony.com>
Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Cc: <Stable@vger.kernel.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 2be86368237d..b1db0bd71aed 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5188,35 +5188,21 @@ static inline bool mas_rewind_node(struct ma_state *mas)
  */
 static inline bool mas_skip_node(struct ma_state *mas)
 {
-	unsigned char slot, slot_count;
-	unsigned long *pivots;
-	enum maple_type mt;
+	if (mas_is_err(mas))
+		return false;
 
-	mt = mte_node_type(mas->node);
-	slot_count = mt_slots[mt] - 1;
 	do {
 		if (mte_is_root(mas->node)) {
-			slot = mas->offset;
-			if (slot > slot_count) {
+			if (mas->offset >= mas_data_end(mas)) {
 				mas_set_err(mas, -EBUSY);
 				return false;
 			}
 		} else {
 			mas_ascend(mas);
-			slot = mas->offset;
-			mt = mte_node_type(mas->node);
-			slot_count = mt_slots[mt] - 1;
 		}
-	} while (slot > slot_count);
-
-	mas->offset = ++slot;
-	pivots = ma_pivots(mas_mn(mas), mt);
-	if (slot > 0)
-		mas->min = pivots[slot - 1] + 1;
-
-	if (slot <= slot_count)
-		mas->max = pivots[slot];
+	} while (mas->offset >= mas_data_end(mas));
 
+	mas->offset++;
 	return true;
 }
 
-- 
2.39.2

