Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53B590661
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 20:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiHKS1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 14:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbiHKS1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 14:27:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30269D113;
        Thu, 11 Aug 2022 11:27:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BHsMqa010298;
        Thu, 11 Aug 2022 18:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=USOs7V35lgRcX1DuHuC+0T4iOkWj0Sr7+PH3UmmBopE=;
 b=kVn2ONKvOB3mPLMJJ5N54xB3np+4kZR1BG3sZSndvT8aBbQPGH29VV7tK2WPnmXaFMWI
 6pLOm+D+4+g41RX6VbR2X7JY8PRjV0xT8gaqWu1AiWHunjrJMgeL5YkdY8lqBiXcbrxb
 ZQcWF0nPg5YZB0TiIDxHph9C3Vwqlp47CCfs6eO1HXEIdnrlJF7SaPmcDn86gKwAc6J+
 Fts59xdKwzslbi7VjyQrnc36LW7eqa5PLzofx5dfVewwj+/9OdMvEq00u/zvEoagjcRy
 LQiLsloUtDL9pN+DCBbVZlNRRChAIWsmcAtu87mLA6urG9MIpoUAfSoukqt+r56IHnlM Kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdwkf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 18:27:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BHmmRM040673;
        Thu, 11 Aug 2022 18:27:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqh3h98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 18:27:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhWPKEbewZfzIxu4yoMY2n3K+CATJe9eCqkXli0p8EbLDEqqbS0xTngACt/1Hy5qOoJX6FiJhshaQxgVJsDLS2tqtolkpUbe5flx93A/+milv5TCxVyF91W2YpoYgUoseUuTNWsE/6ERPWIWQJaRCAotYt0/iQ9eKyhVC9oJPM2VdrAFFfqOUtfgzqFdXsyy4QCEzkr/1/IRTCUOxbq85MoxSa0jq/sH7eapadzHFlhwZtODpiFl32X8M50N65DrZMoLLd9C0+Ga/H+26KKXx7J59qUv6g0+YoyjX4TxJTTMWEPmL2i8QHYtQm3b6x1Mt6kWioQIzzP5677gsrFZoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=USOs7V35lgRcX1DuHuC+0T4iOkWj0Sr7+PH3UmmBopE=;
 b=Teas9sQV8547hFlD2DSjGbTxht75W14YvEuSkio3e39hBw9fAh3DcnbuOsbCGyvDhccYTYo7BxTiY5nj5teYf7EQRbLZLP8ruqPvSVVN6xez5s4JWFaTujtW45iMI3Y5AzBonqMTbSSRpSuCPG0p4pTFYVLF1rwvcqYawotiYmrbbrCZ+vJkix0f1ZCwkObBpYcAtyQXOzsNETTWIx+CAW1FYZsJXsyCC2EXa+j8FGoU5YhDAGKBu80YnFelqa0pVZVrGGvkEKy5n2xd0bRr8vBs/LJiJFYX7+8Go5n6l9fMCpPYSFIST9o5WmphOLphMlTE/uy0gmBiGCozBOd/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USOs7V35lgRcX1DuHuC+0T4iOkWj0Sr7+PH3UmmBopE=;
 b=mMKPXGQQvog9+B1U2Xa1/YB2lVEpJ3htZvD1zd14ADN84eB/WrTv2ZeLji4hjrOoGZTjnw3AKSXgxIiUUNCrfIyf6DAWlFbai1ZeEkTG3OQL7EcEN6kQG1sOr+qyP+XRcwgrcXOG4mriduiiyteoCjvxd98VfKOGCuoVk00LDEA=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CY4PR10MB1334.namprd10.prod.outlook.com (2603:10b6:903:28::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 11 Aug
 2022 18:27:34 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0%5]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 18:27:34 +0000
Date:   Thu, 11 Aug 2022 11:27:32 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/hugetlb: fix hugetlb not supporting softdirty
 tracking
Message-ID: <YvVKFLHSY6QDFzaJ@monkey>
References: <20220811103435.188481-1-david@redhat.com>
 <20220811103435.188481-2-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811103435.188481-2-david@redhat.com>
X-ClientProxiedBy: SJ0PR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:332::34) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39fe9952-c8aa-4e72-acef-08da7bc728ba
X-MS-TrafficTypeDiagnostic: CY4PR10MB1334:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Vv0K8tv1A1LDAWeZgDPxdKZtSAeipXwVNLs2NDV259rG4zv3AZiYKf8pIuU2FswCfs++mtTWFfR59iwtpWzjnIDtTkIF16K6f/zI0vxQUy4xl37tYblKngR4XGMFTSZ3dhqBMv694tRsUADjXNUNJBxWg4QxgJQnzPckRE+v1HOADU6vy4/8kOtXyQQ5nNbe1qg5Z+xCy9HKn7YdBsbor6PsiX8BKr18IoUs2zCoWkqoVpK/ikIA3OxVdDUKAN9r2q4ZBfIllUPUiHtNNM/mozfuEkkwcvPwOPr9REuwHcfTSuHoJGcj+PzBHzkQSVIqxyLBk/krSFf2H0r9w1HkgTME0v7syXPdG+Ud/QttC5oHgsnD56/PGKSYwkqNhYGeO2fMNjiLoXR+8Xk1EePPyHnftKHA0i9MeeTe6zOD3t3lE8CIGS/6zgvAGf2W11k+zXcK13TXbv4NybG0HtU1ynesfzv4gfue+lz07vEJ4xOSVSZBeaO9VtnJmSTgYdaTErESWjtP5B3057YMnUux+Idwl9t5AGxN3g52KD6c2GAEUxZY8Mmx+77Py1V4g6LYyEmBZgNqvmJLLM37PRLX1iHmw1u6IzfJws0QteVGsB3Qe8zJ/dp8mCveiLnwpwoi/YSO96gAjC2kzLgF+TR7HxeIV8IqHrblr21qrieH8P/h58mIb+WBqAKauh8Bqbrfis9p9F1VNJahpFkSTcp6aKlIbgkjdjgKz+WxrC/oZ9Nq7gIEh15KpRY/VrfuEZ1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(376002)(396003)(366004)(136003)(39860400002)(83380400001)(8936002)(86362001)(66946007)(38100700002)(66476007)(316002)(4326008)(6916009)(66556008)(8676002)(33716001)(2906002)(44832011)(5660300002)(53546011)(26005)(6512007)(9686003)(41300700001)(6506007)(186003)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bq/f/8nleUuJ6jZCwl5+7Fzc9dZiYlUW6x4wc5KVcE8pcgeZAySos5kfF1X6?=
 =?us-ascii?Q?aX5Bl+k3aiNR7t9gNmJE/QPMtYnDk+knrNf5IqQi7VYFqULaZ3DMayR6b/Qm?=
 =?us-ascii?Q?74VSybYWQjV4wrjN+z2OvhlbzVQaBhfjsKCc7Q985RhlNAIOwFqFFhCLlQSN?=
 =?us-ascii?Q?se2WBKZ48TdfPbTyvNpfuj3drbmDLHhqtt2nmtHoXU9jIrtMyw2YTGkAWlZv?=
 =?us-ascii?Q?AK3SRWQ+1U+S0EG6Y0UmLAYzgHQKp57KmqZTADCa7LJCQC6bFvg6OuuM8nIP?=
 =?us-ascii?Q?1ytYJsnlsPX0UGz1PXFJ0sfaa5v4daNx5GBeh2QxrV/8vx8H2Sl+DVQSDREw?=
 =?us-ascii?Q?1oxK5W6m7cjexN1iqHZhClCw58pS24Iu7pChTnrCR7d5nQCQrAxyWFKjIwCH?=
 =?us-ascii?Q?XthcL9QRz1Ex8NgIJpw4Dc7rV9v0L6XzRH/KKeQTTiLTQY0/bWyqX+e6vw8W?=
 =?us-ascii?Q?oj7gpIz+bD+k972jThv96ysTU/nu/iE7pNR5tEsCCF2Mfwut98708a6tVw7R?=
 =?us-ascii?Q?O+qUIvJBqHBfBZOIBVgK6xk/fr2zJNKY6rXtI1F77KvByGhNn9M9MESCfLA9?=
 =?us-ascii?Q?8V1ewNhGSKUul5LrRhggUQ8vGDrjJUEc5fiDr/VuvlpK7f9b+h56cvZYE6dr?=
 =?us-ascii?Q?2PFyqwuhVg4ymMLqjyyMCMgEG3OYg6dsVNfD1I8qv2hDRF3TU2KWpwnkc7mQ?=
 =?us-ascii?Q?wMfTN9M6k4d+JmmXabdz3SEFsq+EI5R/1QsM/oiifQ3j4dC75xOxI4VyC8FN?=
 =?us-ascii?Q?d2G5k/rNW27ZNtDCUy3GBeuyQ8KVaUErhQZqbGhkeN1LmnSjssngbtDcREFQ?=
 =?us-ascii?Q?XHxiF68YSPmXq1wOFMLN5Nv7Rn32HnADacOC+FqtpIn1o2LMFwaeI9hxo/8Y?=
 =?us-ascii?Q?zu+UYBl+S5JIuWANPGqixeT/cghcK5+BZ9pnQ8/TUHvrJOVqdeFo9kXy68ww?=
 =?us-ascii?Q?WCHezm3PYazQ77R0AjI9EhXK4vKhnhMJlxIeFKXpWGML6jovU9tLYuuEUUNZ?=
 =?us-ascii?Q?ODgbS8CsvhZVucHhcoGnLd8NxRdhGUfRYFtZT1HbBPRBR3uvH0vhq1mb/ovE?=
 =?us-ascii?Q?BFrAxkxkY4cPK14v9AaQc7JWiPjyEDeUYROF0f7GGKjU7lyHPVbzJZ2LNIKk?=
 =?us-ascii?Q?LTXbsjdcHzZ5bMkQ3AyERU1B1K+YNS5h2EiyyZSzJ4oo7+GTEGcDnWk+t0Hf?=
 =?us-ascii?Q?Z/0fX538VaTpdHydo91HK9LAOobDgmGWAyaPjzoB48CxwO/nFRHvD6Nv2Q1D?=
 =?us-ascii?Q?pLXkaGqy5mtkY149yQHYNPK5UF2NvONsgoxZUmlpvOK0XoEBZuQ78DEFmEQ2?=
 =?us-ascii?Q?uZWko8IZnV3ksgfwArYl8Z2L7cap1TFGEzm8w3Kt+f7GIcu+/PgGnrbp3Yuo?=
 =?us-ascii?Q?iTdQWFJHqlBGp2xMNsaQN6ND4p/AbzCYFyrRfnS1e2E9os0od84tMzboB4yV?=
 =?us-ascii?Q?8s8MNvDTCEvRUdWCxHO+rjP0Beq7l089MstHWHlh30RuRKxkeHLt/F/XLofH?=
 =?us-ascii?Q?IEYfUt8hkd5m4+/s3lyvMYibcAHMArqf1SNEhxPaYzd3oAA+EehNTkzLXYrO?=
 =?us-ascii?Q?3zRAJMkpINFKrKCEoV6bdxB9aN73fI7KABcQ6G9BfVtjWSo3gOKa3y4FvBUH?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tjHvg50sBr5/AHdO3F6q8pWb6bLK6hsWmEDPTCxBKD/KH8TrHWLzjNFjlCpZA2mrY7HMXbXgWnSQarP6y8SlJY6XWyTtpWnYYFjwuy9QJQVTrT4Q+2YyTUZ1tDbdjHV9dIm08Iy2MYg9udBGBFM8tVFlVBTQB5ftO1uCi65Ow1kf/nxv1t7jZJp7vYqjr98DM6GwmFcZOEPxqHG76CSXwjykuraHKFF4tDHw2BUCR14zmb7cK0QF+Hc+LTrEqeAxgQisr61tIgqVdwTaIEm6m+BippJrgWjdn5bncAHdWFMC023woGVf19e4vjGBOZobkHMlPwjmx/D5eAEZoyyT3ffOn3J/jMMGVUU/Gtko+KbX4joTd57rHfC0l5NQHnp+nh/rw/w9GOe3JXzTkWjaEj1UAaI3YVME4+4YExBTIkoJK6F7tHUoNPissF4MOF1br+fPhluAQeb500CfsFfn2s4BiYqaTm8tH03dMR4/w73tJUC/HYweq8ikAXLNcsbkXiAUkJVMjO/uad11ylwKM7G3KC5tnGJXwkw49JV7tEEwiTI+q2laWzTQfh1jVJqUZ2XP5+IWeJ3iXBMTrPXeB4rK/Ugr18ksLz45gOEulPEnEk0uShPkP2VgUieLmQ1KwQ94ZhUvpjg+8Oh/gsUOo/jjkPMw2qxgwQy25Gjhb6675xY6Ks7cy30zlBedoZwLMl+bg0qTxk2V9uzpSx0VzlzK5KTsgt9dGJs0a4YM5QZOKF5/s1Et2lUrYztYdWqGhKYMn03cWk4QBJfSMqOogp9UGgBT48CopQlj9U3T8ohgEgUxhA/uYik435mBq5YOfniE1RP7qZxmg7IpStrIXxXbH0UDZSdHqVpf1OxA+9J4JRArlcJYhlgg4EfsXKxW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39fe9952-c8aa-4e72-acef-08da7bc728ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 18:27:34.1814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yG/PbcrTyIuCgIySLwscEX0LxwKv0UkGTpjsxe3vPnfWXc/7ZHvRarzlGxv9SdYIoc3Igq9+OsKDv+7i/UaTkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1334
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208110058
X-Proofpoint-GUID: 4AMt9v9DoV-JVtVu1gMc74gt7XorxTiL
X-Proofpoint-ORIG-GUID: 4AMt9v9DoV-JVtVu1gMc74gt7XorxTiL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/11/22 12:34, David Hildenbrand wrote:
> Staring at hugetlb_wp(), one might wonder where all the logic for shared
> mappings is when stumbling over a write-protected page in a shared
> mapping. In fact, there is none, and so far we thought we could get
> away with that because e.g., mprotect() should always do the right thing
> and map all pages directly writable.
> 
> Looks like we were wrong:
> 
> --------------------------------------------------------------------------
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <fcntl.h>
>  #include <unistd.h>
>  #include <errno.h>
>  #include <sys/mman.h>
> 
>  #define HUGETLB_SIZE (2 * 1024 * 1024u)
> 
>  static void clear_softdirty(void)
>  {
>          int fd = open("/proc/self/clear_refs", O_WRONLY);
>          const char *ctrl = "4";
>          int ret;
> 
>          if (fd < 0) {
>                  fprintf(stderr, "open(clear_refs) failed\n");
>                  exit(1);
>          }
>          ret = write(fd, ctrl, strlen(ctrl));
>          if (ret != strlen(ctrl)) {
>                  fprintf(stderr, "write(clear_refs) failed\n");
>                  exit(1);
>          }
>          close(fd);
>  }
> 
>  int main(int argc, char **argv)
>  {
>          char *map;
>          int fd;
> 
>          fd = open("/dev/hugepages/tmp", O_RDWR | O_CREAT);
>          if (!fd) {
>                  fprintf(stderr, "open() failed\n");
>                  return -errno;
>          }
>          if (ftruncate(fd, HUGETLB_SIZE)) {
>                  fprintf(stderr, "ftruncate() failed\n");
>                  return -errno;
>          }
> 
>          map = mmap(NULL, HUGETLB_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>          if (map == MAP_FAILED) {
>                  fprintf(stderr, "mmap() failed\n");
>                  return -errno;
>          }
> 
>          *map = 0;
> 
>          if (mprotect(map, HUGETLB_SIZE, PROT_READ)) {
>                  fprintf(stderr, "mmprotect() failed\n");
>                  return -errno;
>          }
> 
>          clear_softdirty();
> 
>          if (mprotect(map, HUGETLB_SIZE, PROT_READ|PROT_WRITE)) {
>                  fprintf(stderr, "mmprotect() failed\n");
>                  return -errno;
>          }
> 
>          *map = 0;
> 
>          return 0;
>  }
> --------------------------------------------------------------------------
> 
> Above test fails with SIGBUS when there is only a single free hugetlb page.
>  # echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>  # ./test
>  Bus error (core dumped)
> 
> And worse, with sufficient free hugetlb pages it will map an anonymous page
> into a shared mapping, for example, messing up accounting during unmap
> and breaking MAP_SHARED semantics:
>  # echo 2 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>  # ./test
>  # cat /proc/meminfo | grep HugePages_
>  HugePages_Total:       2
>  HugePages_Free:        1
>  HugePages_Rsvd:    18446744073709551615
>  HugePages_Surp:        0
> 
> Reason in this particular case is that vma_wants_writenotify() will
> return "true", removing VM_SHARED in vma_set_page_prot() to map pages
> write-protected. Let's teach vma_wants_writenotify() that hugetlb does not
> support softdirty tracking.
> 
> Fixes: 64e455079e1b ("mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY cleared")
> Cc: <stable@vger.kernel.org> # v3.18+
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/mmap.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Thanks,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz

> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index c035020d0c89..9d780f415be3 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1646,8 +1646,11 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>  	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
>  		return 0;
>  
> -	/* Do we need to track softdirty? */
> -	if (vma_soft_dirty_enabled(vma))
> +	/*
> +	 * Do we need to track softdirty? hugetlb does not support softdirty
> +	 * tracking yet.
> +	 */
> +	if (vma_soft_dirty_enabled(vma) && !is_vm_hugetlb_page(vma))
>  		return 1;
>  
>  	/* Specialty mapping? */
> -- 
> 2.35.3
> 
> 
