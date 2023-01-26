Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF83367D85B
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 23:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjAZW2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 17:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbjAZW2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 17:28:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB661A4A1;
        Thu, 26 Jan 2023 14:28:00 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QISwhE019405;
        Thu, 26 Jan 2023 22:27:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=tzIdewK6SfV/Cp2+h/gk4FjPJyI7o56RWPQRWULdKz4=;
 b=mrha1A0NQHx1UtIuZ/1fZGqmIXqvx2G6hfiDtbK0uitZP0pJFVgeLjczLbzuJK6iupKA
 ngSXQmZqcSakOT0QtKFkwTBrX7t+j/GzN9mTbFVm8F46bUECS/ya2GAAOzTBvLY9RJg6
 LceRxZ9OrdxY6pLctqYddMlnAFFFkybj7+y1ba8soZgvHDXFsM7J8CGXfIMPayQamxP7
 Att7Cr/D55Ajk8PDhnDnV/rq1NdhOwwYbhYi59uPDMx6hVB1qvBy4zXrVK4MO49JK4sG
 uM1gFDnrhNsgrbexQLFV7+y2o1BfeSz3+4ZsuJFe0LP9122vrVMwRhDzBTWVQqwNNRPj WQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u33mf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 22:27:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30QLJJmA010591;
        Thu, 26 Jan 2023 22:27:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g8fm39-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 22:27:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsO2MptoLJIskMQi+IPHu6vuSt+CXW0EBwKdpVsRrtR1xREutWdsj6eGwwdtvBTmi5onX9G0xTz1wZVI1becFwuFtnYOkrZXgQr1GO/VVZSkJ4GMGBP/d1cl7p82kfww8w6l9fVIls3gMcCaLh+f6xo+JGXj7yUxARGRDtL7s8DFmTk9U3vgSf4jDVfnFV71jdZznEnflz+ZWN43IK7YJb6lTNYm1n8iQRjEPCQnBCJbDnKMgiWLrQPMI8m1ly0dQNqNtVgm5C74EzMiQJ9OhF8yzezo7/JWrAeJ26e8oeSp3DvksOOkZm6Ge/0o4UHZSs9HRzv3cz+rVHJFXDmPpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzIdewK6SfV/Cp2+h/gk4FjPJyI7o56RWPQRWULdKz4=;
 b=DCWqMoVQjXSBEEF3aGMfdQXPeIaE//LsCSimd2SuD83dzHqQtoyb1xlWzJjdDYuDXubs33w0PvFxOam4ZOJYhzGbudAwnS7klBwuaUwaGHpkmhscJ4qcLjfD+5uwB4EzB2yhU7dk+LIzUBG6mjenMHycjt/y0Ru4UxwPk4J6n+4OVIl6J+xh6EqxOa3KAiRp9WkgfytQ5QzOu3fvzPeIYLCegx04wrxztTx2wHae5bC41oD1I9wupPwHKoRh4xgWVzoyNkiif/yKjsUtWdLSmwvue3h70LSkXgm5Q9GFA/Nj3eIsO12Rf9Qad6qJbnZ25zmcprzsFj3FDqBKdEZBAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzIdewK6SfV/Cp2+h/gk4FjPJyI7o56RWPQRWULdKz4=;
 b=tZSIY0X9j3+AeBQI9MMaA09DszhizOiTuyaCOCIbieK0VzGuQ/3jQwvH4B/Kh1yMsbT82Ilbz+78PvOvLdBC6g5VW+DPpOrNPhyrYylo4P9RjKwVrIY5vtgCfSgO5KXQtx3Kwz44kPpXsZ/g40Q06bnxG/NFB/jsp+FcULc15wY=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 22:27:32 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%9]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 22:27:31 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] migrate: hugetlb: Check for hugetlb shared PMD in node migration
Date:   Thu, 26 Jan 2023 14:27:21 -0800
Message-Id: <20230126222721.222195-3-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126222721.222195-1-mike.kravetz@oracle.com>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR2101CA0015.namprd21.prod.outlook.com
 (2603:10b6:302:1::28) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: de110378-14a0-4aa0-63e3-08daffec83be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ss6E4bjf9To2W5p6ZaPFWewi/F1wp/BGgHJ06jB4KCZ9gUkWbtO/QzJI7NxsDTBTS7UbUU3eCkY2UFCxk05L5jkNPlMVZWKBEID3FR58brvyYKxAppiH0D2LfnLkENQZlbnN/P3hA34jUyK+yOxAH0cAahV4AF16VBdzBuS+WyXODbMraKgJS6RqRckZjdq7lGkRd8fAzonB2pZhcQQ+ZhIs5az+T+/YEzx9zK9XrueHAFcDoKVZ5O3UMppqXnSo84tPv7Zz7pJvIklJMRtnr5c1GAmyx0D4jcJg0SilBJQ+j0OdAghVQaNzCzYWzTUhPKUwFkaocTaadKsdUgCLnejBL6tOS7J0kj+ysY9IMfpgOD9J8lSoSwu0wAKhCQDtIb5rWETu0/IgzfyIoBFmR1DY1pYeAwg/bu1pfKAMFypPFQHGEEMgIG1tNDKc0M6oUBt32RX2pIY9QW+LFmASeBGfFii80mKbaDvpqL+BvBHCO9A8mqKqPhItmo/ZJgQ24sfjsVBK8A5Rij9jT+NNKd/9DCHVAxgntFnTU0nvwqxCyelzYLf/28F7IC4ZnuAlMzyvbYZAxHTidIP2rP/UUnMymPCRB1D8lTQACOQF6HWK0IcMyGsrBhiWll2E9+toM5OhGUrDqMC4nIHhElDsGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199018)(186003)(54906003)(6512007)(26005)(6506007)(6666004)(478600001)(1076003)(36756003)(2616005)(83380400001)(86362001)(8676002)(66556008)(4326008)(66476007)(66946007)(7416002)(38100700002)(5660300002)(316002)(6486002)(2906002)(44832011)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x0SjNm/K/jsf3549BIUdyQbZ1/aa5ei2aYpDvwYrMulbryK3D4zg/uSAp08D?=
 =?us-ascii?Q?bArlXs/BE1pZHfrghio0/nL4zgFvU13qgG+XkwljlHYCV0u8SA2pgwH6mL5g?=
 =?us-ascii?Q?3i8aQejMB5mnG7DaOv8raVAb3icfp5jESXaywHmvbJf4uk9dqc66DB9lR9CI?=
 =?us-ascii?Q?X5IQ+wi5TU4V6W1y6+J/BFzkckYmBtK2myYG8/bmkBB/Kt61TO/zFZU+p1xD?=
 =?us-ascii?Q?rRKsvgJnSOvqJzxO8XcrOF4XGkB30fILQk3qbWENAZI3set/6YgwN/52j1Mi?=
 =?us-ascii?Q?1gAl5haE11zVjsqI2IVZTOMcMIhiquS86KK+q1LU35x1D1+H8abaHBwiLFef?=
 =?us-ascii?Q?UrH8K6NHONa/ywPFiM+P4BrG1F6DxxEEEv9uLghwvINEqIW5T71gb9Hw0rhK?=
 =?us-ascii?Q?N4x+tjk3QbL8hD2KR8ruTs7myldLlzgDVb+AWtGu273xKARfUHsjLK7OX4s0?=
 =?us-ascii?Q?hZ27InZwM1VX9Gpp8Ym3laud3QRho4e1w9TLIaYojmgKFsp91mrd0MI+Yg8q?=
 =?us-ascii?Q?ZbWbFS+XfnEPIV5PKFG7bmh08vjN41J8RvweD9Uzc1fe8qleefahl+zHcmep?=
 =?us-ascii?Q?v4g42cneXXp/iInzCm6ihUZSGa7LoS9Ik2XZA/D0ifjlkzc8TzbW1BIcwCnQ?=
 =?us-ascii?Q?UOv7EYqB09j+/obUDdc3SfZo7TdKAsucr0jc4LisuN3pT6Md51fO49t938HV?=
 =?us-ascii?Q?JwF7kUsHvzjuvkMzPY0pvZandprzR/2B8BU17xPO9NnV8V1IRtUsqyTD6zy0?=
 =?us-ascii?Q?W6zMCXDeVBYkOR0J0w4pxVG3tY0OJ1qA7ttWxfwBTmKyXqqWXEuy/LHS/JQn?=
 =?us-ascii?Q?DPQZJq23iHDI3hUinBQHFmVAVwAr6Grmatg9aWbRFOJ+OTQyk+hIOUCNPzeQ?=
 =?us-ascii?Q?Y6b9xd5qZWPwSWKEckIc9emsPKvY7j0G4kizj3eKnRmGqNdUgLus5B2huhub?=
 =?us-ascii?Q?95ktcRW91FvdLXIqOxVQzUC1ITe+Wm/C2AVy2XtIlSg8S6S3M1DkukEefiLE?=
 =?us-ascii?Q?KpT58NvV+b7wSSVu3XvFqSC7C2fGr9IfNkuQvIMpTGz7CBfbLxxMOe6Jg2I9?=
 =?us-ascii?Q?KfE+iZyEhSBpCVGGwJgDAn5SCVdylQaO6t3lhETTsgs2E3Tv/JJdSk1puPym?=
 =?us-ascii?Q?SdAHKDJsSU7tLNXaYg+JHr7kxUgnXHv2JRcfmPUIxTyzc318sv9Q8+5ykrnk?=
 =?us-ascii?Q?OnrR9C/yEif/JBnF7M5AsvOk0vZ5yNVAlL0UfLkAgEW9vzUhemK7+Ic1HBdT?=
 =?us-ascii?Q?Yr3NpKHWQWg0cdTznHMvQyJIisJBjYstVC5jxrjGPEVyzGoRpo//oME6chov?=
 =?us-ascii?Q?rV1BBANHEiupQt+ubetmJFZMPFzc+JwxW3+/TGbDJB9vm75jKolmpweoJ8N0?=
 =?us-ascii?Q?zgl+FBeFT4uuwJ7lMOLad5OJAoMApXEyFtQDcDl39yqDyAxAYTx4ca2JDuHa?=
 =?us-ascii?Q?WnlaWuOImMY+XgVbMnItRFMEutD7Gb9Zm22QTuD4ArHePhKTUR9Br40R3soA?=
 =?us-ascii?Q?Hu31LUUWbK4yHEt2X1u9EUCNZmPXshVnT3Dz+ND+WEKulpJKmHrQCerd7I5s?=
 =?us-ascii?Q?PgZQI3WPkbaefyzxE6N1cwsAECV9xlLXqa7k/ifjxp/lJ4A5TDsnADNB8xgk?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?b8VmvJ4MYHFPpydTrwut4lTrRCOY2j7myxo2XPgOc22Ni/gvrjxGgGcmmkIX?=
 =?us-ascii?Q?5ij3lBBOjSShUvBf5Xw9WtOQ0tLUVmEATC07mplT9hv7+VmTxXjNtKaNIfG8?=
 =?us-ascii?Q?/j8TzaYavPpAlVlbsCMDmHFo8JQsuVsiXfvlbCbFZ8TPvZ/OTDUWMhw40vH7?=
 =?us-ascii?Q?AgaCjNICrXQNrD7L40yIAHnqrh4jeMCCtjWmRqWwNCyd/I2gm4rNM6USz1aO?=
 =?us-ascii?Q?ByHXAaJ+d2oQibqB6ANEqXcPgQsQZepCScn2BrH7CsKYMIwSTknyN9mEbfSz?=
 =?us-ascii?Q?XaBgpPqPfnJiN+YiDdFSI+U8fjVm5AdEbs7WkF+Xum1qKgS3/d+bck72Efia?=
 =?us-ascii?Q?OKVGyQpQ/KFFLefi+lXNgtE7vkDdOH2BUdmE8LesAT4bcUo4wWSbfoMAi2Ch?=
 =?us-ascii?Q?awK/0SI398Ui0KqyQ9iUqqZfjxlJXwbzcJuZXit1STs4daauvjb8PqkdTVG6?=
 =?us-ascii?Q?l1YnquLuJBX0We+JG2FqB4b4lU8BIP6YiOQi3AfCueNFVgD/ZDvu4UGjaOdw?=
 =?us-ascii?Q?TnZHq3vaH4HlcaTGL1eyij56/CK7W4/Zg3WvOjcBPHd+79R5Tz/HKUgiRkwZ?=
 =?us-ascii?Q?0lGAPbHTEGsS+MKinm6lNbIgmEu7DA7oFVwYFl0vA76LPLIwgNw1BUtaInMx?=
 =?us-ascii?Q?zBs9i0J1Rw+kdjyQZJFL/8X8Dj6m6V9R00nQLDnDdbZVXUHHwJ/Z8gihQHnl?=
 =?us-ascii?Q?5+D11IGwlFDyBZGq91gETQNmB2m+DiKXg9qsCQA4CWt70+HA2V6kU3cyYA9v?=
 =?us-ascii?Q?V+4QYapk3mm/UwosVV9d63r3IrwgZtzZgDmLLICSJuJRc9qD9h7pcQB9wFNM?=
 =?us-ascii?Q?nZx9RHFFxRDPmDwzo3QWipIDQUw8aDfF7qcwH1JryqduaOfVrpzEZ2hE+VeU?=
 =?us-ascii?Q?dmrFAGRbncn3THbY761EwnuGXrZzRk98yeQhAP/xGw3OuT9Q+SobXPXdYp+6?=
 =?us-ascii?Q?UGsxDe0ZqsMZg/Oi1jgyfJFhS0IsK+W8oyhOClNEbRKSC2fTIAMtqHrF+ids?=
 =?us-ascii?Q?WyzVhTPsBfXkUjjNTugl5JBbEM8Bcr8wbjPLqP7hdLJ7fkcBjLzmRJ4pXK/W?=
 =?us-ascii?Q?bKes3rnn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de110378-14a0-4aa0-63e3-08daffec83be
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 22:27:31.5254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJ52ML4B2pOlIDfrC93SOWaFJLY7DhL2klszMnVBEmIHZu8FZcgVhV1N3cXOBuPLJWGEpfwM+P2nIxsxbw1H4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_09,2023-01-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=811 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260209
X-Proofpoint-GUID: kxo3hd0rXT1RV0eFdQ_ulo4F0MmRqrxN
X-Proofpoint-ORIG-GUID: kxo3hd0rXT1RV0eFdQ_ulo4F0MmRqrxN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

migrate_pages/mempolicy semantics state that CAP_SYS_NICE is required
to move pages shared with another process to a different node.
page_mapcount > 1 is being used to determine if a hugetlb page is shared.
However, a hugetlb page will have a mapcount of 1 if mapped by multiple
processes via a shared PMD.  As a result, hugetlb pages shared by multiple
processes and mapped with a shared PMD can be moved by a process without
CAP_SYS_NICE.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is
found consider the page shared.

Fixes: e2d8cf405525 ("migrate: add hugepage migration code to migrate_pages()")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 85a34f1f3ab8..72142fbe7652 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -600,7 +600,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte))) {
 		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
-- 
2.39.1

