Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53066955E3
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 02:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBNBX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 20:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjBNBXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 20:23:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6156B14EA2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 17:23:53 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31DMNwsT001455;
        Tue, 14 Feb 2023 01:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=HSjIm4y9FU5tSPb0Xe1DYPqxFf9Vnk7/oKKZAy5C1Sc=;
 b=kpW8rm5h1Ibeu7jdVxT23HZdFHR2GLDlnGJPT2zJOMtvxAN/mZ2sefJk/HoWKmd/tGSY
 r+ItZXdsSmh0c9pdT8aSQzYW2ppiqOKdRlz7qxnO39cfYiJqQ1IRZNXZ4uVoiIKdb6Gj
 dVpA55qgxsdES+i6WAv3pvy5D9VziCyAYiYa6q/EHmW8gqnFLmRBFAyAwcQONiZGJGoQ
 t+qB1+eN7E4okO2dkEET7ut8nRN6cIaenLYbp1yMy+FjcwJrJ0voolv9lEtOFTbERKZc
 /6vb8AqZlyUrVWX35Q/Bk5oI6Y2YZpfjoIKCgCbsvh+1Sfqb9b1BS3iEJfpNcFSt66CN 5g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9v8d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 01:23:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31DMocrP028887;
        Tue, 14 Feb 2023 01:23:19 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f4krdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 01:23:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ae04fP812HVDNNjLv1ysyh5ojD5CbLTDud9AGShJr/Qgx+Q6MMRR5mCfo6iA61Q0h26UuH2OkeBI3BXDCXDUYmV8edmdELn/qYh5MYEiUxXxdS5mWY+m12x6RNDYM5zraqDKOZZt1MxsZVfnYxb/bE06BiQ+mkFNf/On0sMyhYGEce5+PpmoAv212wnE2wim72aFVbLK3hJIEvcTnWRIBAQvUQPN+7QAQ1XOR3wljqSW6kKBLcWJ4Ztn1rVZW7VvJOTXfuApzB/EGsfJz/W7lbDsFj8khDPJdiaEdnbumaF37KeklQpR+93ZHw90pxizdCUHlc1J1lDG484HGr68Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSjIm4y9FU5tSPb0Xe1DYPqxFf9Vnk7/oKKZAy5C1Sc=;
 b=iEDv57hI6wbab0XLf/zlde96qcoLQ3co0kERPSTwOs6BtmIN0qFoUqc9fUO1I6rz5//II1WE/QJmROSLhAUJ8DPzsErOLMG6pIycp4BWmbiLSla2QBEwY8qDv2WmMls6N+ZO4DN0isykPp0tbpIu7pCp91Rtaq6/EE0vl+zc5cFwdCE4IhcwRUqZmcwb9yhqsZX6sZwIDnOiSE2C3dFPZ+clo6dUOZ/uIN3PxvTeKRn1bytb6Put25Nld7J35NvxNqHD4D+8In1a7QrRC38/BSNQ31Zw05NgSSUrFdd78DBbipz4ntm4enyUFEj6xbF0QVm8UEVHp6tPUnlhSvbjlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSjIm4y9FU5tSPb0Xe1DYPqxFf9Vnk7/oKKZAy5C1Sc=;
 b=tTfNqEXa6PIMbX5VOWm2wjX9zyV5MbKzMRKRSrM2jdUPDHWL3FmypzusFhOkK2pJoKnrG0H7hsRlTSgu4PZFu3U036Xkje+p5eilsdZ5J6qW0jFlVIXdTcgr+H02bU+qhq75zJTvhcEvnFxr8rBZi+7HQrlRG4RXG/BybUeU5M0=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DS0PR10MB6269.namprd10.prod.outlook.com (2603:10b6:8:d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Tue, 14 Feb
 2023 01:23:17 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a%8]) with mapi id 15.20.6111.010; Tue, 14 Feb 2023
 01:23:17 +0000
Date:   Mon, 13 Feb 2023 17:23:14 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, david@redhat.com, jthoughton@google.com,
        mhocko@suse.com, naoya.horiguchi@linux.dev, peterx@redhat.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, vishal.moola@gmail.com, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] migrate: hugetlb: check for hugetlb
 shared PMD in node" failed to apply to 4.19-stable tree
Message-ID: <Y+rigp14gGPGC6d7@monkey>
References: <1675761365143@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675761365143@kroah.com>
X-ClientProxiedBy: MW4P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::28) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DS0PR10MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: 65eaba1c-4f8d-4050-b11a-08db0e2a0ce9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MFhZjEMQczdlDo+qG87V0LJsl/B6YakCypAYwgMhevkcQCZabPCsBzIhZXrhbtiSCyzx3P2PQD3dyk1S8yIdTgef4vNmQJr1BboJ+bcvDzc9mSNT5jMU2kVjSrzLQLe4+WYXuvjyvwncb6HBXMo88aZkQteBFVXHHLeJhwPxXtB3WUFdr4Pt67hSUHavDcCktOSg1TcAOdw4Xw1hbF7ZeWRTAKA7p5UArKpdkRSswEv+6ht34c53Jtep+IvnRajp2DeEtLsj8vw9s1iVvbzsb8go/nRCT6TsVt8jbNSEegz6uohhp4VKAShruChu6ttP4RMRrKhqxMVMmXh1hnqvF46EW70Ds4324A1niV6aJqQ1W/Md+ifeQRjh/3oLJl2IKAxKqBemQwKRGtRPvuZmTKlmH9N77KcxKhuWOKbBUTLM869oyGBxwDPPFHp/v00LLO1m9zLbVKqQeMc+erCaS2ui2SUWRLw3uPhLMCLCKXf6zHWPmAPvN5Vp6cptzkUU1UN6O2ZRvG+LC6t4DtsbsZJW2aXYCgN8dEbWfbCx4/DaX6P1lSJZDXUzjcrKnYml7QRVZV++IP96SHLGu9w5T8ndo6e9K6/VPLxe9az5NRMPcBzWX99XnzLSUNpZBXB5OrJ0LodutVXyeFsDegSxHceMBrlusWunKXmmt0NWYZAVU/gYSeV8KsCaLLzOr79r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199018)(44832011)(7416002)(6486002)(33716001)(2906002)(83380400001)(8936002)(478600001)(5660300002)(86362001)(41300700001)(26005)(9686003)(6512007)(186003)(66476007)(66556008)(6916009)(66946007)(4326008)(38100700002)(53546011)(966005)(8676002)(6666004)(6506007)(316002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hn/nQJnC8tubfbuQ2treePSDIcmxzbcVqGzkI5Q8SWmYtj2c3chgPhIygpCB?=
 =?us-ascii?Q?alGPSMwiuSQSa8QPPh0w9tZ1qci0Lnz5XKyfRa2rTNdCveyIfW6JsROdWZ2G?=
 =?us-ascii?Q?udNyjHlwEgm56cJHvNtMJDEAPaG2vciON+RlJXazuCI3xFeohxuiHrK15cL2?=
 =?us-ascii?Q?EWqruuYzOD4sfyCr6ptWZnjtEs/oh2Dv+gX1TfG9qftKlW2tnp842W7T0NX0?=
 =?us-ascii?Q?/FDOK/r0PZO4Kw0pmWvQbZ0im7juzDWP/2a3mv+ZFOMgidhNKoKxAhGvUFJt?=
 =?us-ascii?Q?EKt0EEnJIXJU735ceAVdqbWgqh03ApM5BwqwOaf+Ih80qoFDM5pttgRw1v8v?=
 =?us-ascii?Q?aq/tYC3hyktOCvI6NDbccDiPJ9PQBD4YKAwQb/wHC51UWXS5GL4X21/ce/vg?=
 =?us-ascii?Q?dqYxs2ZZPhh0iln6KAaMKjt7uGtD39+fiJUAwLrV6EOynomLJm+T6YaDeGKh?=
 =?us-ascii?Q?jc5+zXKMhqY0w6FQRiVq1nkFtiDQKl4oku1RgKw0C6zmq/MANdC6VB115pAf?=
 =?us-ascii?Q?/nHuM7wRApdY8+nBbBlFD6JftLmNZWRxy0pbzZOpv/Iq3eghomov2PucrGAY?=
 =?us-ascii?Q?FUFutHIC42SUsdENhX2zXhZbLzSOuD/Ys/NUoTTWXw/3gBGCYFQlDaRVTr70?=
 =?us-ascii?Q?qPHCfvjzylJ7VIr1WuH42EoxUwF8p4eYRjocoGCD9FfQ3slTI/yFt/BjN2tY?=
 =?us-ascii?Q?wM/aaR1K8dSMkXiLEglz+Xk9URAvKpbqjbcWj2+s1VgDwGidvWrQ82/plPqi?=
 =?us-ascii?Q?errjVwTWO+oEuKNroR5s/TJSud3IIXgai6c7bUGQDqDWby3Cl7Y+fJ8Bcpd9?=
 =?us-ascii?Q?XqWUVO0VALXEJwfaofzbT6ZFeWCGxh9JRVBfrPhyPvvaO1/22mS3A3LlJvml?=
 =?us-ascii?Q?lXJa9pisEgycqg5cxf386nUSsMive4RaZ+6YAwOx8/UA6QHC5daFxm6XwnxZ?=
 =?us-ascii?Q?noqx7P44iPSi0TzdkOD1ue55MLOuvr7oFD89m1PsRnnCHYhEIJv5/PjwaWg6?=
 =?us-ascii?Q?JzJryZcF6QtYVp7cFrJV/loaz4EQJnGxTTMeQJCBTpO2+yoAj2109Hbpn1C/?=
 =?us-ascii?Q?lgamsm3pL6n+QP8I+Y9TP9RsXbGJnTO7lGfYRvm74hFZupq4GrVl9ksGD5jn?=
 =?us-ascii?Q?cY/UgC/7kvIJ/F2TzNpClXv+zBa2JIMjQpODrQeQlMt9kE51DsKicxeyV9lx?=
 =?us-ascii?Q?jUmOiRZ8HQF/BYD4ic2Cvur6Hxq3KxUwpbnMNMQGxqIdb458FD3FqF8wGIkp?=
 =?us-ascii?Q?IXzJPMguf3GlF6nb43jfPUozMoeTVJc7hyby6RltR4yjeXm/RO1PqtXdSPWx?=
 =?us-ascii?Q?ZtH3xVrynrhvl8l9nOXvp81fWYaL5JPHsvIqxuzW+2ZbyDLgB3lXLR+fTXZl?=
 =?us-ascii?Q?tL+pspNEGgSzDjhjxADCz2Cyr6tYlsfDjK+k9tK9xDarw1c/vi7qT4CnFwD+?=
 =?us-ascii?Q?6HQBH8qGV+2580M9W4aKAIVhQCYcC+HEZY4rYYtLt9RrL7fVEs35tcO8qpTl?=
 =?us-ascii?Q?e9n1gIpPK7vBZoRZ6eU/fSdtZCocGqwyDOA7oLyWqlYF/PufguJxUQN4cffF?=
 =?us-ascii?Q?tfBnJliAoRAXLpjZjIWl1nPK9m/BaMPrjf+PtzvIs7SkxI2tjT1aM3aA2Pv6?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?y0Vgba8vNVduHwq7iPX2TYCL5y+k9+dJIxZTuQbQJBfsYsKELobaJTbyDJG0?=
 =?us-ascii?Q?MztOWWm1MxpSGfKJv6jRUuz2zpPUSE/FjDxNItLN0Shdrt8wRwdWbesl9Wf1?=
 =?us-ascii?Q?Pr9w3WWBkjokf9UBn42scv7h15EsoNVswfnaFM4fPLdoegbjPnUI6akIRC4M?=
 =?us-ascii?Q?Z4h/3odxk4CQQh0Q7anm0hw2tWg2cHAkWX1cBBEjKJaYdvF7K1YbijX/OLvc?=
 =?us-ascii?Q?I8TvRrro7wjRCz5AVqrHYUIDfPNYsTY/cd1NjE0NWwK9IbJwDI6WQ4Q5Jle3?=
 =?us-ascii?Q?lP9GaxmpTkgDR4Bwx6ahFUZnoHw7v5HzWnNH+jSf7pchLTyLZ01qYoeH7OXt?=
 =?us-ascii?Q?89XkiRLMbpPeEiN62LtJS5tOs0dyWgGe8VO557ATWsgM/rZGS/srW7OnGE2Q?=
 =?us-ascii?Q?zvlEsD/zKBwjQOkGiI7eKKBvOBuVN3SMlA+9onAO76h7z9Mrxg75EkAtffwj?=
 =?us-ascii?Q?0fWKRU19zC6qCe7H1Bc47t/3zudP50fDqetjgJ429meehDYC0iu4UbPzl4UT?=
 =?us-ascii?Q?42mzohwQJnKaZx9s9x6aqv4kLwRK5HUrqciyit0sTogbaHjV46vE8EEf6DQC?=
 =?us-ascii?Q?YBfqfU7iKrqx2sYKYBZ6HXL1Ung5qwmFfrWFTsyWRhPy1brxk1Y/8w2ZPNQJ?=
 =?us-ascii?Q?z7FwtrYNlWRE5YL05x75ZJLb/n569PJQFo/miyB4FwABrw0+HICJWAZK+azG?=
 =?us-ascii?Q?H88YNGHlEjEQHTJo96JdhutHIC4klHmdYeMkbE1l/DPRZaWL1ZI/2tragvqE?=
 =?us-ascii?Q?gMXuA92HVQVt7ebRcIywbSddF6tu2DxgABcGBgTJ/InmoE7g0gXNCctV3tIE?=
 =?us-ascii?Q?C1H+opn0x43OsT0IqPDlnuscioAFmNM20iJP2V8XMI0JJAvYzeiGA8OB1Uex?=
 =?us-ascii?Q?jefW7X7J7DMnnhsR0sZVqkL2FotzsXnBj3CmEoMvNXlCfxNEfWUGMNkVMqBK?=
 =?us-ascii?Q?oFTGHHdPbvixa6FM7KIvwXLzbYk6eALI4ks5RCd+h+/s9as1+hY9d9KqTQPp?=
 =?us-ascii?Q?beGmECkI6l7NJcUjw89KxXqDzG+HUfC9yspo4Qzwo/9orVt2kdOVaoPXFrqk?=
 =?us-ascii?Q?hk3Gkh38pQYem8AJ1b9gUkw1xyAIeA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65eaba1c-4f8d-4050-b11a-08db0e2a0ce9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 01:23:17.3301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wp0eJeBgKhbZhaGi/6IcxnaOJ9DIEIrhKvkjRKoBezKd3izrE/e1uPwEPUgU61KFqqMF6bUcuwg6pZGm5vudtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6269
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_13,2023-02-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140007
X-Proofpoint-GUID: KxxmlAYePQa1NSy9EYqmFnnm4ltFch1a
X-Proofpoint-ORIG-GUID: KxxmlAYePQa1NSy9EYqmFnnm4ltFch1a
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/07/23 10:16, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Updated patch below.  Note that this depends on backport of upstream
commit 3489dbb696d25602aea8c3e669a6d43b76bd5358 which is already queued
up for 4.19-stable tree.

From 8f863a8bae356277b55b2ff909a52d12be5398a6 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Thu, 26 Jan 2023 14:27:21 -0800
Subject: [PATCH] migrate: hugetlb: check for hugetlb shared PMD in node
 migration

commit 73bdf65ea74857d7fb2ec3067a3cec0e261b1462 upstream.

migrate_pages/mempolicy semantics state that CAP_SYS_NICE is required to
move pages shared with another process to a different node.  page_mapcount
> 1 is being used to determine if a hugetlb page is shared.  However, a
hugetlb page will have a mapcount of 1 if mapped by multiple processes via
a shared PMD.  As a result, hugetlb pages shared by multiple processes and
mapped with a shared PMD can be moved by a process without CAP_SYS_NICE.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is found
consider the page shared.

Link: https://lkml.kernel.org/r/20230126222721.222195-3-mike.kravetz@oracle.com
Fixes: e2d8cf405525 ("migrate: add hugepage migration code to migrate_pages()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e44e737e90a3..35088e830bff 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -571,7 +571,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 		goto unlock;
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1))
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte)))
 		isolate_huge_page(page, qp->pagelist);
 unlock:
 	spin_unlock(ptl);
-- 
2.39.1

