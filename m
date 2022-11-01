Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1A661435D
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 03:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiKACoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 22:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiKACoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 22:44:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8273017591;
        Mon, 31 Oct 2022 19:44:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A12EIA2004915;
        Tue, 1 Nov 2022 02:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=2/9ccQ+M0IZO1oa6SVxKEB9fPTZf44CjgIw7wQQZ7oA=;
 b=cEYxRgQJvlYjJRQFTis3J7d0btvMdAS9tYgQBaYr97WcxJnTsswKTpGnoKVBEW/M7UiY
 T5hxio0u2Dv01uHnFpBDi+s+gRRGWwaWtH58uDQDOTcT1jLpSQBQ2Y+yIJfbvGOVxJK9
 wPYCAL1BteLjWYIWuUi8f/9Ybo4pez6ErN1Wn4iYdy1QUfZ1lnWiV/Lr8K7bPI9r59G9
 KDfsLEQZkigpo6blZWrM/lhAzYibYuTgZA7w9TlQA1o3Y0BCA7b/SYzvloHenZiX7dGL
 GTusF8yXz+vGLuU6Esx5fetEQ3DlawH0/W7qIpKJD/D97uj0RAWxRU3OBReHmaMNxBQQ Ng== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty2whjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Nov 2022 02:41:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29VNClDU037268;
        Tue, 1 Nov 2022 02:41:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm3x2ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Nov 2022 02:41:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbFiRE3MnyI7PSwVsT4LRDkQUkHmGquOyWd7htRDsXxJ2ZnvVFvalWSjfhatALSW07B5LIuPS1TkOlBMYZSQnRlm1qgQU88aqJSRGarfmzMFmQ/OBF16GDCFD1Nw5+SPkBV0dnKaPI88gkMCyzU37dnfbk96b5ek3i13aYkg6x4ok65dMJLfRm0QmdCk0SlMcbXbQnRbfBgD9ZqUxAYZLh4v5jlUW2Juudxwj9GOb4jaZATq1or7/K1irmK7FkdP81RP414DRwZQ4NdDxrYdXC9yJ1NAsaKcNsRT7wk8oOfkdZwIkWSGUW/0k92fR15FcsInyERYGi/vR3co195QNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/9ccQ+M0IZO1oa6SVxKEB9fPTZf44CjgIw7wQQZ7oA=;
 b=l159Ey/NKuSr8VNpBxBQ4Y1oEb5bVe+jSvfNIkHra5hAEu9NJkcI8gVjaBOis+oKTzSJo1BkdysQ01uT6aRMJlLXmeO86pshe9Lw9IthK5+B1NcMYs1aGJbo6jLezT24CgfYr8kRMJUbWE3MErEHKKpvPxE1lRcukwQhLyzpoUgOG/XyFl10g2TcnAKwCp8AZ/NIRfOedcj7ZcIJ5Djhknw0M8sYQbEio4m+vdBxaXZqD3+mAzeSsg+3hhsnT5cFf0xv6gpv0LiAwLFwlS53ifw1RdrQcNRGt7ZDGSBjNij5ne84l6KDRRsx6gh4hKP2TfRP63WMUyRYC+JIRcSKRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/9ccQ+M0IZO1oa6SVxKEB9fPTZf44CjgIw7wQQZ7oA=;
 b=szpQV3b9cjnYVeNLd2j/nJqV58Vc0j75mXHySNjA+VLf+PEd6IhC7EXCnWrA3/c3MyrdvaZMvu4tYHDXI2jINtg7yEXTMTDGAddLclF98N10lvRSKp+q+ZjPz6pLUJlPzILvFBxRZEW+6Jgx4b/rBxCQW7COiR+VL4v7pXxeA/E=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH7PR10MB6105.namprd10.prod.outlook.com (2603:10b6:510:1fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 02:41:47 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 02:41:47 +0000
Date:   Mon, 31 Oct 2022 19:41:41 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, riel@surriel.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, nadav.amit@gmail.com,
        harperchen1110@gmail.com, david@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com
Subject: Re: +
 hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch added
 to mm-hotfixes-unstable branch
Message-ID: <Y2CHZfg639UCoNFl@monkey>
References: <20221031224833.0023BC433D6@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031224833.0023BC433D6@smtp.kernel.org>
X-ClientProxiedBy: MW2PR16CA0025.namprd16.prod.outlook.com (2603:10b6:907::38)
 To BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH7PR10MB6105:EE_
X-MS-Office365-Filtering-Correlation-Id: 9acae879-77d1-43e6-a75a-08dabbb29ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: plr4gHNU3yyhwFJL4+b9mC+12RlM6h+m7NjADDWSPTwAN2cg4oj0/WfPQjxMuHekQBpJ3kdtYFnd+YKPsPuD62b9OOvjd2IZ1Zrap8niQZIxN5XQIXa3yRootE2Jsyn2lQdp02jAIGcISrLWqDFja6tCZvVI8yBpeIsy87tKyjF+3blHvESfzoA9OMnYRrMMV+QLumHLGnUhemScMFE9W1HGoWySBvlUQjqXasQFOZ1eMBAPE6Dsp/5gT1vsauFJ4Alkm23uITwSHL/86f4VCBu9v7PQtqkAe3Jiwk5fX1L0Q9Yd0ioXeFjWJHTvIXT5zpv7zb979q3ORsnSUOKR9P1S54stg/zofy2cUiXVExglEAI+hV51w865t5fCBkUxTXGOC7WyrBF/lxF+7cD26gLQC3HNvRjGpsi/rdYHZVU0qEwKWeYMJcMCXjVjXgOg1B2+Xyb+ZVuuoqCA1jedW3VjEb1HHG+6KkGQfQjM1jsl5wnpilZIHWGpEuQlXjHDG6gzWzsDMnEI9PejnBmiAmmE3NRIpgphOV0DALuey/HI7ms0hdNywuXIXTBqf24heK8XSktwyaGKehcztAiOqUuqLjCz+/6mwew7ssi5SE1azPq+BR52DEeO2ANlWhZtP02nMLaepSN9BFaCTTrSthsMMCflu03cC4EZJZkQ1a+bPbnmcIsQCUEDHuBB1045jK63iAcG241N2Q2sW9JEVL9Gs2rLrgbV2GFFJNgxM5xPYuP68+1kJee64l3BGJAY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(38100700002)(186003)(6666004)(6506007)(478600001)(53546011)(6512007)(26005)(9686003)(83380400001)(5660300002)(4744005)(7416002)(41300700001)(8936002)(8676002)(2906002)(44832011)(6486002)(86362001)(6916009)(4326008)(33716001)(66946007)(316002)(66556008)(66476007)(192303002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zqc4qNqwnsb/i0AAQMKuFdiQFIlob6xSl65ZlngCzYmXgAZkz6+29ng15guj?=
 =?us-ascii?Q?hkVvKSrqSXMiYcH4RaJ+KA1swHGt+5zngNLmLgXjlKMb8zyEIKPLgXLt+V/J?=
 =?us-ascii?Q?IVo4m0WMLb0F++BsU7aGOlZB9IitS09V8PH4xeq3/3ChJrZKF9IZSS3x90sW?=
 =?us-ascii?Q?O+prjkmIbCgVJchwI3pXO+uHjS+BpXQRB8k26SavqNheNClYpOLRabRnNP3q?=
 =?us-ascii?Q?YXI9klAsn/YlpSfXu6yP3CosrR3sNgpDGrOMk7vEWCCsv0kAWuo0i+C72Xjm?=
 =?us-ascii?Q?q9G6/9H8OtWiuiC2r/M+4QKSEkkeR2KopMKVaaIMbyYDBy04UkNUDkFPeVNG?=
 =?us-ascii?Q?/en4aXkvv516K5jAFd1CrnwqTaT1Kdibnn9H0/Ucqoqs5Usa4vPK99ewdXha?=
 =?us-ascii?Q?z15n/x/mWrw97zvGbM1IEvNigVxsFP1k/eChZ3c3uK8l+u3scPWcQVCIySrn?=
 =?us-ascii?Q?zIG5YyeUidhJOjEnPIZajc0qdkrfNH0PcZSnF00X/1kkjqPtr2OA40NxEF6H?=
 =?us-ascii?Q?y9MzM0Iu5useoSaCo+l9WblDJzk+x2/qQWJVtOESqJldsDR9m6xJYSh91lGg?=
 =?us-ascii?Q?WxheKkCqTDwLmGJmH9ZpR86NkB1iM+tsZ/JZGD5lpVpHHTfY6vbHOFHvWJPA?=
 =?us-ascii?Q?JL9hBLtcUaheYFfKQ9x/kxsosEZ02sKtGSWt1l2CtTrZhMrfWlR3WHZWbqt3?=
 =?us-ascii?Q?Avymq+qY/N+RV7QPDrwTB2fyJcFvTKsvfeCul7Q4Ch5mtBnSaMkjgCI7ZcYt?=
 =?us-ascii?Q?b3MqbTUBnWEf6jIsCma41XQgYfRr0rT5EuZQwqmcx1pdm2MdfO4XMiQMtuGz?=
 =?us-ascii?Q?+4z/iotD5XIRRBoAMhalcXjqsADXy5bdQrpSQJ3rBX1IejUvxyBXzlO9F9MU?=
 =?us-ascii?Q?Indt21x32mBL7EowMSiNhnpyHiFAOG/ThoQNGhuWtUEQbKqOUGFrNH8lqL73?=
 =?us-ascii?Q?CxLboAnzN8KTYcI7ptyUds22VhbrCIgH9NQKROkBElQcEXtvGP+THIWTsFZF?=
 =?us-ascii?Q?HeD2/heQs8jZn9pRpwq1huzV0GdueEuPJuWCOItxgg6XlwLMsh74obOVE8aq?=
 =?us-ascii?Q?LE3cWfJidXYylfH+g5LH2060BMnk7ddFW5PLjHKWs3w419HDnaQRSzw22IiV?=
 =?us-ascii?Q?SMD+rSbCDkKns3ACTCRL+gFU7Y3rP4iQ7US5IP64/ih8hHNT96z0EaiLI8/3?=
 =?us-ascii?Q?mpYuFJMkTC2hO6Pxd+HxyoLR5kJvFtmD8YCeBZLxoMS+Oibe7tkjXH8S80wh?=
 =?us-ascii?Q?1qxlBHbC0BirORZkF5DcM501qp5UIh6jY+gCkLbctViZ/svpldUwyxpUU5Xf?=
 =?us-ascii?Q?qXAYJIYzWQGYTtxsYrj6kM6HZ+E6kt3bzStqq5UrCqNnzYVOctvZgnuynvQO?=
 =?us-ascii?Q?0IOcLUMktj+IyOwNyla3X0Cjd0c6++kTEq5krrIr9AaFIpgRhab3kqn46ZbZ?=
 =?us-ascii?Q?hTGiKP2J/kTJMSaUbsAuKHDkxH1CQdhFDMX7Uu/HuP5T4W3LHSLi/TIMkeDt?=
 =?us-ascii?Q?hTxMe00en5AxPT/BBiZkbbu7n97K6ee9zQakKQpMBPu5Qu+X3uHILgvX77Gw?=
 =?us-ascii?Q?lEzlXiWxZyrpFBCmjWg0b4Pa20fF9H9okPY2+ndNNdLeu1aIciBHREGUYtJI?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9acae879-77d1-43e6-a75a-08dabbb29ee9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 02:41:47.3219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erG2PpR3s1vio3pm0O1ozwQsNrXO9IWr49+CWWFTrf6XJl5eEQOGvfu0ULWcN7bCRHkLuT8w2qTPL2JoucxYxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_22,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=970 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211010018
X-Proofpoint-ORIG-GUID: dEbAh-4WlpRyo3p5Wp_qPVEl09mv7LMN
X-Proofpoint-GUID: dEbAh-4WlpRyo3p5Wp_qPVEl09mv7LMN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/31/22 15:48, Andrew Morton wrote:
> 
> The patch titled
>      Subject: hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch

Andrew, if possible please drop this from mm-hotfixes-unstable.  It
contain left over/unused code and obsolete comments in the commit
message.

It should not cause any issues, but will certainly need to be updated.
-- 
Mike Kravetz
