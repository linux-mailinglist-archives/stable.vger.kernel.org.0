Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B055F5008
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJEHBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJEHBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:01:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEBC6CF4F;
        Wed,  5 Oct 2022 00:01:44 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956he1v021607;
        Wed, 5 Oct 2022 07:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4whA8gvOkO5F1TzKWPml3yJmoknhS5DSZD83NhPkk50=;
 b=kgf1yW9CXQlQhGGHbBaPE5iOc4v8WdF/Qfp2XMxMROGdKxDeeMlsSwkfjU5/pAze3Z3A
 ka/M2h3oEzXW7JuNFHWZsqnCHPSlvFp+nyjydsmDtDTopHcuT08ldJ7DtEqjI/LUEf82
 WSD4XjZyWv+1FPMxM7287/N1R2v12LIKC3xvBJf463DBMfe/otFbfa3SKULemU7bvmy6
 uVFrw3u0jHGkZQ4y+AR57IvT7uiPyWdWunCrrbUu1pov7j/lxd1ucI5NL+F2OvZt2RsT
 NuQg8yehxyYLgWcnlRThDo1ZDaMmLQgrLLa5w9bUkHo2DllLqObkiRF96nv7NRso19vD og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2rdxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29531o0r028361;
        Wed, 5 Oct 2022 07:01:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0awthp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4jFLU7KL80sNHLIW73eXYz04U0RNJXgy5MwXvfFzQEVxwmLOlVDD3i+l675CvnIL+YrOMBGMputG8WOKK6D/kdcclIML0yR5xlKIRVmOu+03+NmJd9lI44K73ywbTxRDU4cURIUAIMERlnY5toduYwlLyrmUUK2wJ78OsR5l8SQGED642UAEIy/xetiSDa4lKeC6f326IjBC5jDwsl2Zpvagu1O4pLPrOedkX4t6wGDyxZFAgZsrXPropAc1kq7wz/7reb3RidhRoolRu8Afl6VfPAoJCuBxNfU/cao/b3EYfFItjNtFjhmFc3iQ9t76dvrOZH/RIo4N3BT8AKvfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4whA8gvOkO5F1TzKWPml3yJmoknhS5DSZD83NhPkk50=;
 b=ChwNoAbwFW2q97cW9AGsxoOeogWHI4B9dYyOehwnL2kSVJL3Dv70qbM6OfS6v5hBg5HJUbjd9DmQVi6OjeC5KzcFAssQlved3ws8UPTVWaSU+XZEdH3ZrJuyF4pmKjeNDSIs588+jzpq/zBXUuNPe+6Jt/+K2y262w5jFFctVTkV2tvSJMzJe/mDNar2n3SXugy6E/f8T3eMM2AOIbMB/BRuMOAHj/YaPIbX1deuBNhNp55s6+zdXloh2MjoOBed0qy/qj9EZPhSTsKDtLE2DrFLpfhl9g95jGiAsg0bI2vIbfjP7wF8UdW8v82klFvg+l6Zz9hl8y1nB2qJiz7/Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4whA8gvOkO5F1TzKWPml3yJmoknhS5DSZD83NhPkk50=;
 b=H/tlSIkmfRWyBG6ftFvzN9rUXChCxHKlzmARECMbE5/CkBKUs4v1XK4lfEFhb1ilns0HHKMsVOXVyYOlb/C5TVANY6q9CrN7DpTiv+e9O+iSOBbqz/0sbd060DgzLyjRlUW7t0cqH001GLgmemVW+2kUpSf9IYKSnPX/9wqqxXo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:01:37 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:01:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 03/11] xfs: truncate should remove all blocks, not just to the end of the page cache
Date:   Wed,  5 Oct 2022 12:30:57 +0530
Message-Id: <20221005070105.41929-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0232.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::28) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fd6a75-b579-4411-8a59-08daa69f70d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPe9LDCNpFCPohWUJ6XIwCL84XHLubFWvB4eWdndxU5g5mGQO/VHPKRFU3pBFbBAiq+zxd4RTwgnw0vnWVwC7MzF0Q07PBMh+A1BXhBUK6uAbPf+oPSeAgnQBoJ2GvLgNzs8212NOUpb0GWpb3RreaRmBZPaH/tCMruowHVWl5UIEMFXUhnrxxI1nz5la4bxjiZmAn7FXyvYIqU1TXKd728K1GmMLSuBEhO9qVqrRaAi1JL9dz+zXCs2HEjabHqFveeZk15VxJSghCKGBdV4DWYwbikTnv9wyv3FMGHVjgOudngo5UTRwq1HYo8TMT0JMZbKEhuncppQa2uNT4z/z5pIicyiUKVkjYpdzlm2YhgVZh39fwbeeFq6WAdLpFoGVZC3Rv7+mGYkZaY+FOc2A61837dJhttJ8pmvpWr20FCc8L70GYsOTgwqIZcU3nV+B+NqLHqAqM8GUNW8VW6dbyt4da3DzXEpFftSU3JeBFSX2b4yrp6pj9HnJpPF0e1eEDjC0A+RsRaJsqSYUKZOcgHq/BI9sYhO0EeAI178ntAjHMqOdGYgu+vnwq5XCO2KP/3lTxaX2B8mvEJB7abNSbkpfFdEJsgkU62wCK7qYd1JLQDhqKVn07RLlVwX2/0Fne0GSeo0RWeU62bjL/DK2FlS+0+ULdRzaz3ufbIjFrVz/8lvc02F46Hg+jLwxrw2Hks24/HBYUjqL0+Iz19UnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(6666004)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D1MdMTIeojDR8GfniOCty6RZiJAEzSuWr1CLjwV7YsF/PLWw3HIw+Gz1Sj83?=
 =?us-ascii?Q?8dN43a2kGZ/+Q6rl6rbWU9H/OlSbqGRVdIAuEWOzgKa4tzzQwt0m4oljFrcu?=
 =?us-ascii?Q?4mX8K+6b0XQhA3PaI8Psc1tDxNG2MwFHXlscZ41J1Uh6SgXGkyto8HFdTcCM?=
 =?us-ascii?Q?tnD1wb1w47g+EjSymOYjEW9zeOXVmYmZejPkQnIMn/UhofYUcoSyO6U9LRIP?=
 =?us-ascii?Q?G94anbgZI94dOXexC+LwkZXqXX/f67ZvZ1udbnGJaDtHpQcdNzc1idLXz02r?=
 =?us-ascii?Q?Tnz4iJCLylbTmxX+oHhUG4N1XgV8Ba8P/F5Oi5GSqoMCPCX5/qEhYNU5UjWd?=
 =?us-ascii?Q?yqhATAWesPhfHjJcVuNS+evfGwsDbc8YDrf52p7bi5eldup+tAks4A6kXJiS?=
 =?us-ascii?Q?OUh5G45GxjOCHLKpxW/5kJ6799VqyGc8olZavOVsCzAigurNy3dUtvm/p4oH?=
 =?us-ascii?Q?kE0cDT1T0qqae8U3NGDeWS0uRkO+5KKPjsRr3U3UEvoJj0+JZQmL+3SDqGIi?=
 =?us-ascii?Q?ieuRj2Y1KLULdpiMknJ7eKe3/REH8fFoZKXC3CVYcrYxwI8LCP7V5ik7ywgI?=
 =?us-ascii?Q?4yrmvUyqWLwzGPNDRV65qyP64q+/9XgymPulGFMRh5Gg5k1FW23CTSBk1VPi?=
 =?us-ascii?Q?CG5GvNkIoSonemSihENt6TcX72rauHnQxJeLI6mFre5UoY3EHSwLiVg+s92Q?=
 =?us-ascii?Q?eFbp68Lw/z67fcFnIfJ1YXVwyRibZgmFF/ccCQcZzhYr2zgNJVbZbytWbrBp?=
 =?us-ascii?Q?i4rGXfaNsd6RxCZpxbHja02ZN2mNYdGLeUFFwgsykh20AGFrFuR7oCqCk8IY?=
 =?us-ascii?Q?cpexhDreeXUdvlUMgSmtN5tLNrMbiSpHuiaQw3Xz1XATXws6LrzAVebMiFmw?=
 =?us-ascii?Q?OvzY9ZaPQyJR4BOG+XL67DanrmiAp7r4D3+vZ72KmOVgJPLtd6URlKoO4aSf?=
 =?us-ascii?Q?oF0mlNH1RqdDAAJ1QxGReqRX51DaK6cRXp8lHY+VHunopHePMOOzEDcdd7kG?=
 =?us-ascii?Q?gZUJX8URGT81ymMugCzQPWN2koAHVvKDa/m7LMa3o3bW+luhIgkik3brLpRR?=
 =?us-ascii?Q?D4687kHMt+aG1C3D3MCIVWL2UiIun/HrEwrlcQO2g+9HZuvmSOOHGJikb8rV?=
 =?us-ascii?Q?8QbhkvzOWOzZzmA1+MuCbxVsgds/lG8rQi8pqzNkqvhhY/8DBrIHvfkoRX4w?=
 =?us-ascii?Q?/VKS3GwlkxKkHLEhGE74TqGoFBR9bUNp2Zik+u20xNsJEB1DNAuDziKl55MK?=
 =?us-ascii?Q?ZJ73Q1CAESPLZ1xRIGBKr7C+QqzMGZGCvJ6W+nZJeIXyMm2vbZhM5aJtvH+8?=
 =?us-ascii?Q?kT8C68OXP/3fEfZxD73YhgaW8zVkus+pMUMyrsxFjraMfud7eKKnoBNIBqDY?=
 =?us-ascii?Q?vVAvH8yNDgkvqJQ6vJXmPr3+tpRkPi01CZJ+jFkLJCLE0Rva8q7PjvbkTspV?=
 =?us-ascii?Q?GFc3IkUIUDt6o1y4N2W1ngwjo37ER1EmEx59iA4opl37j481K43uuBzY/R5l?=
 =?us-ascii?Q?5YuSCeSTr5ijUkjHB1usyo0IDYWTl3J4R5EcH3jBfBtjCkhJKN6fB0TF6imZ?=
 =?us-ascii?Q?Bj+oGi8qCHEzEjsQKH14B9XioKQeA/X78pUEEkaWE0gDf1RY76P7Tk5HfJ1j?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?XGmD2RTJoZ3vA/I9rh5aXsB3ehobqy7NDaAEirhapcw3J/I2yJBAo9QtaKsH?=
 =?us-ascii?Q?ALPhK/FFS3Q8BT+zachHu9xlEBTM7wRS/H3q9N5sXBnSgkDtu2kFDDb9UxLm?=
 =?us-ascii?Q?+MhtKUa3gDG9rS+KEQLe0DZ/eVR8W+v5KfDL1EOrD8KbuCR0EHIHV8V3TlRM?=
 =?us-ascii?Q?E6c4deLtaiygznVPWO4P2MznPKeFgDUivPQ5d/jEhQbd7Lr9fYAYpkiP+bvV?=
 =?us-ascii?Q?MFaj/lLYxqukxL0Td+0nLsEo0qbDnZArpQ2qBQFTi2uoOZF6Lj74xOz6LNWd?=
 =?us-ascii?Q?Eq3i/kaFIcWZCOtFxe1zso/ZMmx5yCPbeiQ5F17AO/5pQJiL4+Ltb1Oaxn0S?=
 =?us-ascii?Q?0qLjn2626cw2yyK2Ev9xDGh96kruPaR0GHXlZjSX9FEFpWLgn2VFTuvlgdkq?=
 =?us-ascii?Q?NMe6Rcxj4z8vIAf5RSSla7BH/URwXb533+oRiExcGLeOfcYjpOftprVNsD13?=
 =?us-ascii?Q?KlXpwYTGt8k+mRYh/ik9kLEUuyI78H3JDekNAhRNtOEvvX55oACyPW4xRN0u?=
 =?us-ascii?Q?JHx6oDwqK7JT/5BkmwyPWvVw7nfN66QNbGvKv3xUy746jbupPOzkTSkjU7EO?=
 =?us-ascii?Q?q4Wpa3b4Wu+wrBSaWOPwgakvTIcSRR/usWIxrM3CCPwbQffiWoRp7IhW0enc?=
 =?us-ascii?Q?oUxrliLUBwAnK2du46lOmIkFcHU+gPpDD3duUtePXpRtiAmcufigoZmVdnWo?=
 =?us-ascii?Q?mlHToTIsNXfvWCNqDwtLFld9zXq+4maOJPWuAug6oB4tNQScxeMDUnahg4ik?=
 =?us-ascii?Q?yjHZFgO3FQxQdCsbymBI/q/nDGIXJoLwYbLalhQNkercmnWyq9bua0MrQBjt?=
 =?us-ascii?Q?7To6yqVI2gu2ElBsKUHNb6s7L+m/ZseGrvf+ywSZSrPKPLZw12Ekm8NrQAty?=
 =?us-ascii?Q?+FlWrxeK5J+wNXUBC3MZD4sLpyvvyydBOloTfopuh6X5ICPS6qrxJUf1h9a7?=
 =?us-ascii?Q?lSKeBbCx3K9zord4pFHjrkTsErVow96KAlTXMSKCx5T49nZ92mh8GwNvZ5ev?=
 =?us-ascii?Q?Udu8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fd6a75-b579-4411-8a59-08daa69f70d6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:01:35.1652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRvp+8cuoBD2lZCyTYZnjpR9+6n6XnK8HCUMVQw4tQJjRTlmG/6Oc7oF/NgzIfWC0gF+yLc2JUvoN6DbuDcNGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-GUID: 2eDABjryYuXO-3VSzdCCpyDWXyOA-hHF
X-Proofpoint-ORIG-GUID: 2eDABjryYuXO-3VSzdCCpyDWXyOA-hHF
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

commit 4bbb04abb4ee2e1f7d65e52557ba1c4038ea43ed upstream.

xfs_itruncate_extents_flags() is supposed to unmap every block in a file
from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
bunmapi range, even though s_maxbytes reflects the highest offset the
pagecache can support, not the highest offset that XFS supports.

The result of this confusion is that if you create a 20T file on a
64-bit machine, mount the filesystem on a 32-bit machine, and remove the
file, we leak everything above 16T.  Fix this by capping the bunmapi
request at the maximum possible block offset, not s_maxbytes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7b72c189cff0..d4af6e44dd6f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1513,7 +1513,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
-	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
 	int			done = 0;
@@ -1536,21 +1535,22 @@ xfs_itruncate_extents_flags(
 	 * the end of the file (in a crash where the space is allocated
 	 * but the inode size is not yet updated), simply remove any
 	 * blocks which show up between the new EOF and the maximum
-	 * possible file size.  If the first block to be removed is
-	 * beyond the maximum file size (ie it is the same as last_block),
-	 * then there is nothing to do.
+	 * possible file size.
+	 *
+	 * We have to free all the blocks to the bmbt maximum offset, even if
+	 * the page cache can't scale that far.
 	 */
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (first_unmap_block == last_block)
+	if (first_unmap_block >= XFS_MAX_FILEOFF) {
+		WARN_ON_ONCE(first_unmap_block > XFS_MAX_FILEOFF);
 		return 0;
+	}
 
-	ASSERT(first_unmap_block < last_block);
-	unmap_len = last_block - first_unmap_block + 1;
-	while (!done) {
+	unmap_len = XFS_MAX_FILEOFF - first_unmap_block + 1;
+	while (unmap_len > 0) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
-				    XFS_ITRUNC_MAX_EXTENTS, &done);
+		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
+				flags, XFS_ITRUNC_MAX_EXTENTS);
 		if (error)
 			goto out;
 
@@ -1570,7 +1570,7 @@ xfs_itruncate_extents_flags(
 	if (whichfork == XFS_DATA_FORK) {
 		/* Remove all pending CoW reservations. */
 		error = xfs_reflink_cancel_cow_blocks(ip, &tp,
-				first_unmap_block, last_block, true);
+				first_unmap_block, XFS_MAX_FILEOFF, true);
 		if (error)
 			goto out;
 
-- 
2.35.1

