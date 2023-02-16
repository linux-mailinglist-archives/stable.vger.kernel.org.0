Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6590C698D37
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBPGju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBPGjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:39:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21481BDC;
        Wed, 15 Feb 2023 22:39:44 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2JhUn013054;
        Thu, 16 Feb 2023 05:22:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=duUq+9vqoVUyj+fz9aMnf5TWnGA15PWdnfXSjZ50P2I=;
 b=zXUKrB4tF4L7lFwjfwu+ew4eEDICDZ57fEjhrdNZvjgcrICxGj+sn7YaPIRiGm/IWIsE
 8CVzpy8Ioca057EzrSIKldWWRDkrhKdpEhxxk/srnoAm78Wsd1+D5kZOGemKqY6VNLdG
 YIRRf1AnPfxsvGkVBm5czWcFAf/y195VBoKKlxddrMy/oqpy95CnCmnRaq+sSqFbaiBo
 8udspiedtZFs8gztjDi5gNZINYsd1MHOZ1jzzEMmYAkpMOKX2lkDI4XK8e5tYryVSbmj
 l+NNElyMn/3aNfoIhx/IHUSgW1TT0CNy2SABLKFsLAIxS6qCJJaS9h3F2fRzWrxpgG0m zg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xba832-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2UwKT032467;
        Thu, 16 Feb 2023 05:22:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84ke7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/dFov7pga385yk+zMmdAjuxrAvgEEJ8iOWdAPfWVpzhOhY4bIHwsyykzRH/44yHnD6p0tjX7zuJDw1j7O5GI2yzdN7eCVdE9glY+IXYYxH1twJszTsm7ZfBloOUBjh5e0+xbK6O3TCkfCHjtbfldj0bzzE39vAvr30ErhfcvBNHSaK0brPT13b4Payw7sPupeaZliQB3EGsYFwWpDZEOc3jWz/d6TwuVD4bhvqOtZqz4KU+ovu3cmLdkqMZGfrY4K+C1hYGSMQuKaN3Hy3DLfELDzYXRjnqXZCKF9zCMh5UjY3DBRLtVq61RYW0xOIwBVhiVhKPHTl2F36hED7mrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duUq+9vqoVUyj+fz9aMnf5TWnGA15PWdnfXSjZ50P2I=;
 b=VJSXtF1juyIpy6IyVO9zNAXBC0Yn9xVPKk1TJpTRHOb9pfmYVtPmvncR6U+AutCpuV3MU5SnqlroKzSLeOSsTWN+/MpaVGCT+SwK2TMmn0yfAekslm6AGCynCf/AW289P8a91+B4gkCYO2DfMoc6Bqkz8A0X88uknpIPdAQ+qkKSubocVu25ryrcTnEy/fOnBgc7PJ+iznBqJCak+q/fH/pmc7ixLo4Ndaio9nJQ29owZgei14X+Zr6pMgjGqUQjW4Yg9SmVBf/dzDWRZ9M4vvT70mtmz2sBrwZwX+4dN5tKZuJdFpfjylpA3WsihwD6FwOJuW9pNqPOW/bW9cEdig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duUq+9vqoVUyj+fz9aMnf5TWnGA15PWdnfXSjZ50P2I=;
 b=ZXLSnSv9YK7fY7znJzkWgT/wlcLj5cJHO0mhDl0WmIVsnKp8RWs4daSdOU42TLCeQ/plWm3g7ZponM683YjWnrShVkbf10WVgAuBhJfu6I66d+f3wNUEMqPIp50xE5nXnSPUe+ViCH7Fqo5lKrSzpuCIObXTUw0L1WMYnN9sa6A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:22:41 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:22:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 18/25] xfs: periodically relog deferred intent items
Date:   Thu, 16 Feb 2023 10:50:12 +0530
Message-Id: <20230216052019.368896-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:3:18::36) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c5ba0f-bd7f-4f15-0fa2-08db0fddd36b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h/44UYDU6wExIHUJKWXfohrGMvfIHQgJdMKsxmjhG/Tk6jJkGbvCFeZXYo/ot3WPrl//33L+hq3b2X8s1Ac3jWM6f1oecw6vP2tmOYJnPP93DodCHtJnfYoMhfV0ztjaElF21pOJxsQT+qt2fI3UuxH/KNMi4XiBzUmRbsiX0EPnpST7L9rlcVzOyohuTvV+nvA9vSHTjsxYiAEGuJndFpTRdFwrSH7gZLYzyNaX+e6t/9EEjwthafBZWIAigimf2zuNh8foMWdfR9fqwBx8EYtOuMLuKDkhMsNwOhiAXNGxK9MwjNFLLCydUd61Lyls8Eu+oq0w4GQ86n0nDQ3n89FlBHBAOZl9/qI9UrTCK2q2YxbvDvesz9VYvcIqSqzh5W5DCkYtUNSvoSh2i4YAqYaGQ00a1X2WWPjYOrVy5T0Hjhfmye8BAJjdctrDvFJd57shFGs7FGdL6r6elVxly3mOdqT5mfJPXMpQbXvWidTsv6wjQADQijyuX1RaBsJqlYKj+uRN+ZaCJefnzQVzKtfYNU5w/hC1CmTpiVP8uOd5dTHyYIoT9udYYi/uz4sVQ1ju0w11hcAaEOs5zKf53B7wN4a/x6TrRKZ3pOJXQfPmKY0I1Qhv8p+Nqj3ym8gbvMQYK8lviLXby0AmLLVlZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(30864003)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sPebWHkWQzKIy2/ZCJwksGz4OuqzsgeZNUX3tBjAKuwna5J3TtS3WFBE2U6H?=
 =?us-ascii?Q?Eupf7AzVytuJVdKGTEavueY9tS0aI6Wn01cs+T1hfTfaI5EPnJZ6A8pwiVio?=
 =?us-ascii?Q?qMysI9WStHuv1THQlvo+7Vjaay5SzrMPZlRumucrPrOFosKgi8MuUIN29iQF?=
 =?us-ascii?Q?8zisiQOmQe9pWoEBT9FomZXOPsMUVgCqO4I852bXwssUDH7f2M8UdYcnVLE6?=
 =?us-ascii?Q?k4UiU+gQGmVJjMblIHCKNYaCqzvGIBywobqgAHhb6kNPomNgQ+gqOM1QoWOI?=
 =?us-ascii?Q?nHk1j7EZsRUFWK8K6h21n9ijvwmyEU1gwGYOVIAh7nHm7SK2NG7ynOFZnp04?=
 =?us-ascii?Q?swKAyHIT9/eJ20BBfk1Akb0yQUw/8eGKpSWAGGQP0b4p68AU8ABVrkB7/FxS?=
 =?us-ascii?Q?vp/O+6ZsSp0p51l3bCKQMmsSiJH6rzLJTQqHrt3PeGHeD8UHTheqTCPxabpe?=
 =?us-ascii?Q?nLjEsrxta2yDjqL4VR8s6Az3V+foCo6cVfwl/GGJJ3mZ9ulFropkHQQgNlK4?=
 =?us-ascii?Q?IifPxlnEW/0ui8o4Ph1nRceDfydoi9M9q/k2niJh5M4pZCU/uO59rEZDDZ/f?=
 =?us-ascii?Q?ODANTz02I/89BJi14cUCPWglFjMVAUjw9ADzZjBznQC63aX6tllsEVzbsvFw?=
 =?us-ascii?Q?abO2vnjkKe7FzzVYrWS5ckjbHLy1fEhhmm4ejCkrZIWWW8rNhRO6C33oVdpe?=
 =?us-ascii?Q?5GGvpJoQfYxokfZZSul7mLuqSWXWwqwDspnsca+6j5pE49cQOVPnqHytkcwe?=
 =?us-ascii?Q?fpOvdDJV/V+wMeLt3/VZmr4a0Hfzuc13Frx1IAUZGigQvwUe0G+9TBpds2xY?=
 =?us-ascii?Q?MBEznRsNzLd+ZmdoT1h0dWptydAhcqaHB2pe03bOQL7jhuM2ej23hBh4htWT?=
 =?us-ascii?Q?K3sk/8GqDW52s28wYJyfU/TiSiXU+T9EQMt9X/Q4iVVdkXsHFaTmyH8GqY30?=
 =?us-ascii?Q?gsHllMnA70iucsHKJ90GovgXSjq4arAal1Azj2XOerCDux7UhK6KSZvziERp?=
 =?us-ascii?Q?1dNceaUnxbeHHL9emtA4nqRcllbQG56CBgUJvbhNdJFTsw31fcmvDcL6/ukc?=
 =?us-ascii?Q?JQuyYtuwsJMFDVruz+jGu0lQr6A8ZjtEVu/H1GPAxXTdtWidnVjS6vH/XT8b?=
 =?us-ascii?Q?Azf0QWyHr/QdQ4/PdtYC8jUP6OfDwXmoS2JRB3c4kuNQdHhrhO7olFgP6HQW?=
 =?us-ascii?Q?TK3PtETv/8NJBOkn6TyxlsSTWNU2VipcpcU6DyDYWstJW4ABhO/+BQXrO9hB?=
 =?us-ascii?Q?RAXmKkxUOhukBHDAzD3VtSH7zX5ls3iWRtEPzJcLE0MdWhbDaE8SlSRE33Od?=
 =?us-ascii?Q?n1/4IL1Fv69YWp9Z/eIyrFsEbo843f2gpEbOYB9PMSmYqoXlBcdXKTGNSZ5S?=
 =?us-ascii?Q?U1G18tytJo3i2HD9Bpo/FobJ9hLhtBo+9iX+qPjgR8Json544CJCGJnpRa26?=
 =?us-ascii?Q?mjdYrkf5pmNfbIkWWag9Fy3Rh9Bo9nRP/D2K15vXHi+KXzAU+CAtarErqbGt?=
 =?us-ascii?Q?FdbxxXwjAQnUfaTG8J79XFc0+13quGZI4f6fjcdmQ9r2hkIXZmetiPHroiGk?=
 =?us-ascii?Q?Ivnlt8iwuc00FYQWfwYkbYzyJUdiLzvjf6I7cofOsBBj0OR5hAZk3lAuMMQI?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: c/eZEfhYF9vShCrnMxeMuJfYySBGSCFYOsMoeIKiUJpiVN4wwJx3Abzxin0R1q7BdzxAQ+LvX2+BD1c8aWFTpOPdI1cOlagjKMwdoAdnJpRAbigJv675nedBZnIUGFDaQAdXIucj+So+eaK/45xq251qHIYsn/FZ7daM/cYCLZlDeYIwmYA2kbBTD64jZZ1yh1EPNat4UO9lpJKuZ51/VCY7aCdf8kR3N8KcAHoeS8WTNDmjDmhA3FeUBGZSawzspgWEBllWu8rhDxtlccenEQyt6JIflFJSOx1NPY1vaRsvskOWi3W/2hY4D81fQdwnxt3R7wW7cy74PGWojxgNvb14Q+E26WBRL8STw4BJQSWMYbGkE0Y2dZPAgTOnVLGHSA8P3vUYfybQWjasLygM+lcIOoGrpdpla81btnXvHs5FnXMLRQWPMDHgzDEfWrsk9+IOBZiMYrQyUhymd2hWFPFLpal/Kttldd833HAK4Iv2FxVsyTECZZuSXI6BoTRUcV7OTTKoc5aovkbED+XFhpMa0nYt/140lNHDF4gUNggPHUPBrtSzIfPfyXEmM6/UyskE79G3wzlO7EnANQ+xBoTtUqck1hHSbhH9IP6WDSCdXuZPFurbFLfgyLQ1AJw+IQS/ySb7p73sirPOXMXnRqjCadDJvFnS903ANhaiDLn5bWhCDGplK6Oo8hr3nw1MtcBWzbbAjsPN8NHvi2zPbOd2TezhNGITtb/QpZgvhI0GCDSPLc4+dVplQFNlWe6FwF4eEAeZAC6jXPyhtEV6hBTVM1aGel1MPY2lloJcInugltA5WIIK9jmx4X79nXvKQHlcy0ACv+CZYdxGmKgexsU2gTs2lD5nQrKqw1ep1iD8m3vm8/d6IRV1eoRDEW5V
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c5ba0f-bd7f-4f15-0fa2-08db0fddd36b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:22:41.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BPizhPtAfxVhi50XS7cYa3TLVBgHo6irxBt4+AUoSw6lj+TFsnpymewycwBHYRcR6syeMLRZMq6bPTtc6xRskA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: QkH6KVNMFeGCP88kMFyl9cebMHALIvKp
X-Proofpoint-GUID: QkH6KVNMFeGCP88kMFyl9cebMHALIvKp
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

commit 4e919af7827a6adfc28e82cd6c4ffcfcc3dd6118 upstream.

[ Modify xfs_{bmap|extfree|refcount|rmap}_item.c to fix merge conflicts ]

There's a subtle design flaw in the deferred log item code that can lead
to pinning the log tail.  Taking up the defer ops chain examples from
the previous commit, we can get trapped in sequences like this:

Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
chain will look like the following if the transaction rolls succeed:

t1: D0(t0), D1(t0), D2(t0), D3(t0)
t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
t3: d5(t1), D1(t0), D2(t0), D3(t0)
...
t9: d9(t7), D3(t0)
t10: D3(t0)
t11: d10(t10), d11(t10)
t12: d11(t10)

In transaction 9, we finish d9 and try to roll to t10 while holding onto
an intent item for D3 that we logged in t0.

The previous commit changed the order in which we place new defer ops in
the defer ops processing chain to reduce the maximum chain length.  Now
make xfs_defer_finish_noroll capable of relogging the entire chain
periodically so that we can always move the log tail forward.  Most
chains will never get relogged, except for operations that generate very
long chains (large extents containing many blocks with different sharing
levels) or are on filesystems with small logs and a lot of ongoing
metadata updates.

Callers are now required to ensure that the transaction reservation is
large enough to handle logging done items and new intent items for the
maximum possible chain length.  Most callers are careful to keep the
chain lengths low, so the overhead should be minimal.

The decision to relog an intent item is made based on whether the intent
was logged in a previous checkpoint, since there's no point in relogging
an intent into the same checkpoint.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |  42 +++++++++++++++
 fs/xfs/xfs_bmap_item.c     |  83 +++++++++++++++++++----------
 fs/xfs/xfs_extfree_item.c  | 104 +++++++++++++++++++++++--------------
 fs/xfs/xfs_refcount_item.c |  95 +++++++++++++++++++++------------
 fs/xfs/xfs_rmap_item.c     |  93 +++++++++++++++++++++------------
 fs/xfs/xfs_stats.c         |   4 ++
 fs/xfs/xfs_stats.h         |   1 +
 fs/xfs/xfs_trace.h         |   1 +
 fs/xfs/xfs_trans.h         |  10 ++++
 9 files changed, 300 insertions(+), 133 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c817b8924f9a..b0b382323413 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
 
 /*
  * Deferred Operations in XFS
@@ -361,6 +362,42 @@ xfs_defer_cancel_list(
 	}
 }
 
+/*
+ * Prevent a log intent item from pinning the tail of the log by logging a
+ * done item to release the intent item; and then log a new intent item.
+ * The caller should provide a fresh transaction and roll it after we're done.
+ */
+static int
+xfs_defer_relog(
+	struct xfs_trans		**tpp,
+	struct list_head		*dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	list_for_each_entry(dfp, dfops, dfp_list) {
+		/*
+		 * If the log intent item for this deferred op is not a part of
+		 * the current log checkpoint, relog the intent item to keep
+		 * the log tail moving forward.  We're ok with this being racy
+		 * because an incorrect decision means we'll be a little slower
+		 * at pushing the tail.
+		 */
+		if (dfp->dfp_intent == NULL ||
+		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
+			continue;
+
+		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
+		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+	}
+
+	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
+		return xfs_defer_trans_roll(tpp);
+	return 0;
+}
+
 /*
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
@@ -447,6 +484,11 @@ xfs_defer_finish_noroll(
 		if (error)
 			goto out_shutdown;
 
+		/* Possibly relog intent items to keep the log moving. */
+		error = xfs_defer_relog(tp, &dop_pending);
+		if (error)
+			goto out_shutdown;
+
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
 		error = xfs_defer_finish_one(*tp, dfp);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 888449ac8b75..7b0c4d9679d9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -125,34 +125,6 @@ xfs_bui_item_release(
 	xfs_bui_release(BUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_bui_item_ops = {
-	.iop_size	= xfs_bui_item_size,
-	.iop_format	= xfs_bui_item_format,
-	.iop_unpin	= xfs_bui_item_unpin,
-	.iop_release	= xfs_bui_item_release,
-};
-
-/*
- * Allocate and initialize an bui item with the given number of extents.
- */
-struct xfs_bui_log_item *
-xfs_bui_init(
-	struct xfs_mount		*mp)
-
-{
-	struct xfs_bui_log_item		*buip;
-
-	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
-
-	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
-	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
-	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
-	atomic_set(&buip->bui_next_extent, 0);
-	atomic_set(&buip->bui_refcount, 2);
-
-	return buip;
-}
-
 static inline struct xfs_bud_log_item *BUD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_bud_log_item, bud_item);
@@ -548,3 +520,58 @@ xfs_bui_recover(
 	xfs_irele(ip);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_bui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_bud_log_item		*budp;
+	struct xfs_bui_log_item		*buip;
+	struct xfs_map_extent		*extp;
+	unsigned int			count;
+
+	count = BUI_ITEM(intent)->bui_format.bui_nextents;
+	extp = BUI_ITEM(intent)->bui_format.bui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
+
+	buip = xfs_bui_init(tp->t_mountp);
+	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
+	atomic_set(&buip->bui_next_extent, count);
+	xfs_trans_add_item(tp, &buip->bui_item);
+	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
+	return &buip->bui_item;
+}
+
+static const struct xfs_item_ops xfs_bui_item_ops = {
+	.iop_size	= xfs_bui_item_size,
+	.iop_format	= xfs_bui_item_format,
+	.iop_unpin	= xfs_bui_item_unpin,
+	.iop_release	= xfs_bui_item_release,
+	.iop_relog	= xfs_bui_item_relog,
+};
+
+/*
+ * Allocate and initialize an bui item with the given number of extents.
+ */
+struct xfs_bui_log_item *
+xfs_bui_init(
+	struct xfs_mount		*mp)
+
+{
+	struct xfs_bui_log_item		*buip;
+
+	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
+
+	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
+	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
+	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
+	atomic_set(&buip->bui_next_extent, 0);
+	atomic_set(&buip->bui_refcount, 2);
+
+	return buip;
+}
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 0333b20afafd..de3cdce892fd 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -139,44 +139,6 @@ xfs_efi_item_release(
 	xfs_efi_release(EFI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_efi_item_ops = {
-	.iop_size	= xfs_efi_item_size,
-	.iop_format	= xfs_efi_item_format,
-	.iop_unpin	= xfs_efi_item_unpin,
-	.iop_release	= xfs_efi_item_release,
-};
-
-
-/*
- * Allocate and initialize an efi item with the given number of extents.
- */
-struct xfs_efi_log_item *
-xfs_efi_init(
-	struct xfs_mount	*mp,
-	uint			nextents)
-
-{
-	struct xfs_efi_log_item	*efip;
-	uint			size;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(struct xfs_efi_log_item) +
-			((nextents - 1) * sizeof(xfs_extent_t)));
-		efip = kmem_zalloc(size, 0);
-	} else {
-		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
-	}
-
-	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
-	efip->efi_format.efi_nextents = nextents;
-	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
-	atomic_set(&efip->efi_next_extent, 0);
-	atomic_set(&efip->efi_refcount, 2);
-
-	return efip;
-}
-
 /*
  * Copy an EFI format buffer from the given buf, and into the destination
  * EFI format structure.
@@ -645,3 +607,69 @@ xfs_efi_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_efi_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_efd_log_item		*efdp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_extent		*extp;
+	unsigned int			count;
+
+	count = EFI_ITEM(intent)->efi_format.efi_nextents;
+	extp = EFI_ITEM(intent)->efi_format.efi_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
+	efdp->efd_next_extent = count;
+	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
+	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
+
+	efip = xfs_efi_init(tp->t_mountp, count);
+	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
+	atomic_set(&efip->efi_next_extent, count);
+	xfs_trans_add_item(tp, &efip->efi_item);
+	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
+	return &efip->efi_item;
+}
+
+static const struct xfs_item_ops xfs_efi_item_ops = {
+	.iop_size	= xfs_efi_item_size,
+	.iop_format	= xfs_efi_item_format,
+	.iop_unpin	= xfs_efi_item_unpin,
+	.iop_release	= xfs_efi_item_release,
+	.iop_relog	= xfs_efi_item_relog,
+};
+
+/*
+ * Allocate and initialize an efi item with the given number of extents.
+ */
+struct xfs_efi_log_item *
+xfs_efi_init(
+	struct xfs_mount	*mp,
+	uint			nextents)
+
+{
+	struct xfs_efi_log_item	*efip;
+	uint			size;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
+		size = (uint)(sizeof(struct xfs_efi_log_item) +
+			((nextents - 1) * sizeof(xfs_extent_t)));
+		efip = kmem_zalloc(size, 0);
+	} else {
+		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
+	}
+
+	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
+	efip->efi_format.efi_nextents = nextents;
+	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
+	atomic_set(&efip->efi_next_extent, 0);
+	atomic_set(&efip->efi_refcount, 2);
+
+	return efip;
+}
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 98f67dd64ce8..fa1018a6e677 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -123,40 +123,6 @@ xfs_cui_item_release(
 	xfs_cui_release(CUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_cui_item_ops = {
-	.iop_size	= xfs_cui_item_size,
-	.iop_format	= xfs_cui_item_format,
-	.iop_unpin	= xfs_cui_item_unpin,
-	.iop_release	= xfs_cui_item_release,
-};
-
-/*
- * Allocate and initialize an cui item with the given number of extents.
- */
-struct xfs_cui_log_item *
-xfs_cui_init(
-	struct xfs_mount		*mp,
-	uint				nextents)
-
-{
-	struct xfs_cui_log_item		*cuip;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
-		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
-				0);
-	else
-		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
-
-	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
-	cuip->cui_format.cui_nextents = nextents;
-	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
-	atomic_set(&cuip->cui_next_extent, 0);
-	atomic_set(&cuip->cui_refcount, 2);
-
-	return cuip;
-}
-
 static inline struct xfs_cud_log_item *CUD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_cud_log_item, cud_item);
@@ -576,3 +542,64 @@ xfs_cui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_cui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_cud_log_item		*cudp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_phys_extent		*extp;
+	unsigned int			count;
+
+	count = CUI_ITEM(intent)->cui_format.cui_nextents;
+	extp = CUI_ITEM(intent)->cui_format.cui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
+
+	cuip = xfs_cui_init(tp->t_mountp, count);
+	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
+	atomic_set(&cuip->cui_next_extent, count);
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
+	return &cuip->cui_item;
+}
+
+static const struct xfs_item_ops xfs_cui_item_ops = {
+	.iop_size	= xfs_cui_item_size,
+	.iop_format	= xfs_cui_item_format,
+	.iop_unpin	= xfs_cui_item_unpin,
+	.iop_release	= xfs_cui_item_release,
+	.iop_relog	= xfs_cui_item_relog,
+};
+
+/*
+ * Allocate and initialize an cui item with the given number of extents.
+ */
+struct xfs_cui_log_item *
+xfs_cui_init(
+	struct xfs_mount		*mp,
+	uint				nextents)
+
+{
+	struct xfs_cui_log_item		*cuip;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
+		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
+				0);
+	else
+		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
+
+	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
+	cuip->cui_format.cui_nextents = nextents;
+	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
+	atomic_set(&cuip->cui_next_extent, 0);
+	atomic_set(&cuip->cui_refcount, 2);
+
+	return cuip;
+}
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 32f580fa1877..ba1dbb6c4063 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -122,39 +122,6 @@ xfs_rui_item_release(
 	xfs_rui_release(RUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_rui_item_ops = {
-	.iop_size	= xfs_rui_item_size,
-	.iop_format	= xfs_rui_item_format,
-	.iop_unpin	= xfs_rui_item_unpin,
-	.iop_release	= xfs_rui_item_release,
-};
-
-/*
- * Allocate and initialize an rui item with the given number of extents.
- */
-struct xfs_rui_log_item *
-xfs_rui_init(
-	struct xfs_mount		*mp,
-	uint				nextents)
-
-{
-	struct xfs_rui_log_item		*ruip;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
-		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
-	else
-		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
-
-	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
-	ruip->rui_format.rui_nextents = nextents;
-	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
-	atomic_set(&ruip->rui_next_extent, 0);
-	atomic_set(&ruip->rui_refcount, 2);
-
-	return ruip;
-}
-
 /*
  * Copy an RUI format buffer from the given buf, and into the destination
  * RUI format structure.  The RUI/RUD items were designed not to need any
@@ -600,3 +567,63 @@ xfs_rui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_rui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_rud_log_item		*rudp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_map_extent		*extp;
+	unsigned int			count;
+
+	count = RUI_ITEM(intent)->rui_format.rui_nextents;
+	extp = RUI_ITEM(intent)->rui_format.rui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
+
+	ruip = xfs_rui_init(tp->t_mountp, count);
+	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
+	atomic_set(&ruip->rui_next_extent, count);
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
+	return &ruip->rui_item;
+}
+
+static const struct xfs_item_ops xfs_rui_item_ops = {
+	.iop_size	= xfs_rui_item_size,
+	.iop_format	= xfs_rui_item_format,
+	.iop_unpin	= xfs_rui_item_unpin,
+	.iop_release	= xfs_rui_item_release,
+	.iop_relog	= xfs_rui_item_relog,
+};
+
+/*
+ * Allocate and initialize an rui item with the given number of extents.
+ */
+struct xfs_rui_log_item *
+xfs_rui_init(
+	struct xfs_mount		*mp,
+	uint				nextents)
+
+{
+	struct xfs_rui_log_item		*ruip;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
+		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
+	else
+		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
+
+	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
+	ruip->rui_format.rui_nextents = nextents;
+	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
+	atomic_set(&ruip->rui_next_extent, 0);
+	atomic_set(&ruip->rui_refcount, 2);
+
+	return ruip;
+}
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index f70f1255220b..20e0534a772c 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -23,6 +23,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	uint64_t	xs_xstrat_bytes = 0;
 	uint64_t	xs_write_bytes = 0;
 	uint64_t	xs_read_bytes = 0;
+	uint64_t	defer_relog = 0;
 
 	static const struct xstats_entry {
 		char	*desc;
@@ -70,10 +71,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_xstrat_bytes += per_cpu_ptr(stats, i)->s.xs_xstrat_bytes;
 		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
+		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
 	}
 
 	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
+	len += scnprintf(buf + len, PATH_MAX-len, "defer_relog %llu\n",
+			defer_relog);
 	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 34d704f703d2..43ffba74f045 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -137,6 +137,7 @@ struct __xfsstats {
 	uint64_t		xs_xstrat_bytes;
 	uint64_t		xs_write_bytes;
 	uint64_t		xs_read_bytes;
+	uint64_t		defer_relog;
 };
 
 #define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f94908125e8f..4b5818395406 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2418,6 +2418,7 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_create_intent);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
 
 #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..941647027f00 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -77,6 +77,8 @@ struct xfs_item_ops {
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
+	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
+			struct xfs_trans *tp);
 };
 
 /*
@@ -244,4 +246,12 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 
 extern kmem_zone_t	*xfs_trans_zone;
 
+static inline struct xfs_log_item *
+xfs_trans_item_relog(
+	struct xfs_log_item	*lip,
+	struct xfs_trans	*tp)
+{
+	return lip->li_ops->iop_relog(lip, tp);
+}
+
 #endif	/* __XFS_TRANS_H__ */
-- 
2.35.1

