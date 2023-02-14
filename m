Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D746955E9
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 02:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBNBY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 20:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBNBY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 20:24:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DCB13525
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 17:24:56 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31DMO9R2026626;
        Tue, 14 Feb 2023 01:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=WV5ttf0zQFPLFLRMrHFTWdA3fWyx2OPdvOpHwLAs8ws=;
 b=OkfU+dDYr9zWv0TO3cAxap87Ew9frnANQuLvpm4hwd7qYueVVkspk7jvqHyzNwiD5qpN
 4GOSQFUx5xafYx2gVd8NV0JY/fvm07TxZatgePCbw+fbEt+sizHiDiq7UOyLhwpnPGEL
 uI0m6H/Vwo2kYaxsqgbR0S5sjMNh1FmLAMirD+ZRuPMkEvQIiPayZbOv4NikeE9k/nJu
 4C2Wz/EV2uNM8aCK6zUBzi57h9a+Pgplp9yXOfr8AV0RMLiMKauWwrPGRFU6EWrEnD/Z
 YfWuee2jiK86+kwhoDWvq+Fk41gQkVWwTC+p6do4+QeR21t8pFBUoRWFmX7xk40K5GRU WQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m0vafd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 01:24:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31E17DXE028858;
        Tue, 14 Feb 2023 01:24:25 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f4ks43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 01:24:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTxs1tyfQCVSrscBw7VvugRcoE0WqjIOcVUBLfcRdEojdXM2POn8ta7grq4l1j8ZQhC0Iq377fyv0efSnKqeBlwmaAVaiKpGvC2Y07OZrNm2TnXRFnKhIY1TOgBJ5QEpPprVYKEiJvtdN6an62kqJ6pvTsQO1/t1GDykOIGDlFkG2y3xH2KyUlg7wp31f4A5I4J0I/xe1KdNqZYyxWGWSEedyqJLR9C3wuUin9HFypFwk+/GcHqPhYafRtFu5RIMVh7H9IkCU4Hnix036nT4Jydr2s/AVjmSl6y4So+4xKPA+wwgIwEjC6xnCH+okTgbCKNvcPv2LuukfH+da52H6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WV5ttf0zQFPLFLRMrHFTWdA3fWyx2OPdvOpHwLAs8ws=;
 b=QMsh57alwozpP84ec7dEBJFro7maee6Kk3fKosWofFCDJPCzy2Wp8kOTqdcyE1Z++fo5kmBRtZUEli7GwIYROGu5vTaLNtVE2GNQ77idPM09dAZZSW/MpvzE5yQ/J6qZ3sPzxeM5mXgz3K8rPclckeduUeUFk16SM29B7QVZs9+Qn4v3joChveN64tZ/sAxsmsKpYS9Qgu7BwiutVjrWekmyAImZRfDbU49M3V4Yj9rWykRWBm/5mHN52stYt3kIBuwHfkA0IrAoQHFUhMNXVXJfxyHZcebTxt7bIDJ9DE7Cg9KHMJr8Yl8b/p8aRP8IL2jvf3ENRXkDlq7U19nb8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WV5ttf0zQFPLFLRMrHFTWdA3fWyx2OPdvOpHwLAs8ws=;
 b=yQAMx56aGqe+D63Id7TGL4UfanBP88KjCtYQa9mNlJnLSfmLX4fZ9CdPr+OsXjoUbJpQ0gEJx9HYPApu5gLWeqCvC6aSwafHqC5EyaUxyDpGALzBnulyK82JdnSNQ852rNWATYWnHoLuA24Vh91KrEqRx4amud9e8mo5h1y0oqw=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB5598.namprd10.prod.outlook.com (2603:10b6:a03:3d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Tue, 14 Feb
 2023 01:24:21 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a%8]) with mapi id 15.20.6111.010; Tue, 14 Feb 2023
 01:24:21 +0000
Date:   Mon, 13 Feb 2023 17:24:18 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, david@redhat.com, jthoughton@google.com,
        mhocko@suse.com, naoya.horiguchi@linux.dev, peterx@redhat.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, vishal.moola@gmail.com, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] migrate: hugetlb: check for hugetlb
 shared PMD in node" failed to apply to 4.14-stable tree
Message-ID: <Y+riwvFpenV8pE8R@monkey>
References: <167576136678198@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167576136678198@kroah.com>
X-ClientProxiedBy: MW4PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:303:8c::25) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SJ0PR10MB5598:EE_
X-MS-Office365-Filtering-Correlation-Id: b3d3e095-6ca4-4d35-6ffc-08db0e2a335a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgwbGEjXjF4TVRRhjOmHjUjUeGaJmzolrBQjMzGD69iqgaapIN6W8I7UEQHtuwF8jOiNk3PlfDNcUZjAYQ6NWmcEbIz3rJrS7aaYnGigKwMRTxzcW8zp5QuRysqxRRMr/COI9x5nLuAaykaCjKxfPD1a9dB3WcXNsxBqkeiQSm7PxuvBZLOrU9krPiL4axrZRS8Knn9JUdvRroxgKDQVn3Xi3/Dd0TcjfiOxi9cBWUAA5QOG83MrqynMBcIoS1AbH6ESZR4ul+ORqNQ6PIAcv+CeqhNr5sVfqq9pUjF1dRlj3jH/1JfFZ96GvdTjZcH/Gi70nqyL4kAsYCXO0Tq9822WsPIc0DFBY8i7PPZAtpXKw6bbwmoZ30jpl8VQ+/0ylD+YsNMXGseShj/jnW0GtPDxZ/5kROh6E2mEoA5kHUGyTSRCNpr0c0hc3yLxZKYjXWmuCEnd3rfz6gwjhwqR4JxrC9YAcNIdL8SJt8DnAWBoUv+BVSoE8TQplJYL8LzjKHLyMYQjeXgUeJ0hdFc3FizSdsbXdYvhsg6VScM6+O6JF91LaFD11wSss6Iw4JED3UrkjHNR8VK4XK9lcTCyMtRpAjaEvV2rdyTMAB1EfNJnjc7Y1sKycuxX/s+LqqxXwqOclmcyu38syhm4zNpg9DlDA4lxyve8T6oIcq591RDOwz9BhsJWCdol8QvSDsFD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199018)(66556008)(7416002)(4326008)(8676002)(26005)(186003)(6916009)(9686003)(83380400001)(6486002)(6666004)(6506007)(966005)(2906002)(6512007)(53546011)(86362001)(66476007)(33716001)(66946007)(478600001)(41300700001)(316002)(5660300002)(8936002)(38100700002)(44832011)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R22ByfAYJr1fvxGex7tmM+J5MwMraeGVTNGwrbesU0V77QYkMgC4QPNDOvx/?=
 =?us-ascii?Q?lOHfwtshDp9XkELw6KQeozuJpsRokfUjeicSxm/sJZ4AgAn8jj1Ldme609F3?=
 =?us-ascii?Q?CB/aToJqCljyMmA0wRZO7PTL7kP9N8/wed6hXzEkZncvC5QKsxtoOIBtjNd4?=
 =?us-ascii?Q?fdAEZ1+477ifWN42xIYMGAszHzBuN0/tEZD50Re5GxEP0unAhUuho1ofUw+C?=
 =?us-ascii?Q?89/yOtkVilvOV7wKItAFLcNyWWd4ZJZW49AglMiyAvyt9BCaN3FwSGpGkf0v?=
 =?us-ascii?Q?kz2SW2AvGvjLaM+boLe0m7Q2NnQp4PoUJ1Qp7ZDfIADkaQJ1AN96fYY231UN?=
 =?us-ascii?Q?FrpqwoYmHNNqdUtacnAR7qjVxJ81QTLPoXd6Tep/PGrj4vdPyKQPHah62cRi?=
 =?us-ascii?Q?bSh+JqV0z7h9qnzwR2dunkCBXB6UGYZds+H/HUW41WKuzlMelYJsbpv9BqKp?=
 =?us-ascii?Q?CYw+ce+KhrrwEBRpGM4XCc7+K/2TbJzz4eP6dnKhAxxf61WbIIXDcGXU+cq+?=
 =?us-ascii?Q?D5G3Oc3+2Yy5mvoIuo06bjTkZQDNuKbfBOe6v905U6mm9YlcTZgl4P/Aw2G2?=
 =?us-ascii?Q?vnaO3Nsnt2a7RsPlzS3SgrP2T9uePuGJT/xFExTNCHnEME9eDXfPpBvBfYIb?=
 =?us-ascii?Q?PmMKiGRkvj9yV4rORDFI1vH3+poZ8MSp+2lhG4G+4Aio1KQb28rcZRc7Lgi/?=
 =?us-ascii?Q?1KIF4BUZbOqoZXacvhks6Bhx0YjXLYC0HDHzXrbaEqWsHqJuqgHQmMRnuphz?=
 =?us-ascii?Q?QrwBYWvfZwCsJxe0HBRy3izr1TesqaJXcaS089rgRNU5f4QCCKjajZEPGtzf?=
 =?us-ascii?Q?jwNW8J86hd87Z7Y8UjFvGnnQl5WjQfZDpYZmNKYWOlQB2MJHRl5FWzOxb6Wv?=
 =?us-ascii?Q?tla8R7jK0adv6fK9ZVlPdv7KKbWnD0wcna58ECtqLDDn/RWUs+4RHLRaUNW7?=
 =?us-ascii?Q?UvrL/afOj9mQKkxioS1A2wkFY3otJrFQDwODKG+LdowJuUUaLti58PJXvnpv?=
 =?us-ascii?Q?vUALuvjReSMmXK5i92iZys0qsr4heh/h3N7J2WviZ8zE+ek791frixPOLYkR?=
 =?us-ascii?Q?Nozm39coiKWXtGcDiICL5BeJ3TVUF5IXt/75zGd9K3rWuFVDulKXmKBWc6eA?=
 =?us-ascii?Q?O4s2+bIiBOFAxRMM7brmGNbzpBtxh9t4/gzgxCdccdWlchaYMSevaVyYs/wh?=
 =?us-ascii?Q?kh4/C0wxqDcIlAnr2xv9XUumjf5Lmxg3i08ujOWnII5XeEhorjuQjs5kemG8?=
 =?us-ascii?Q?HOzSZscrC93rQreQr+BtZNtnWWuDYgfKEeSye/g80Kn1QZfEOM9zNzncy1Kn?=
 =?us-ascii?Q?Dg6NU3LgHwgL3MZDtEDHshXy1tPXt67iWh4IRjXRld4lsrZUZHofTy6JaUiq?=
 =?us-ascii?Q?OEaV1irj5RZYdhLNmH30th95CLiauc5WH2W33NW6D6qyDe5iJOcEo2X0RuaB?=
 =?us-ascii?Q?hDIGgfvRUE5Iry0qcxHu2iMSCmdT6qI6VXm9G1Q1RUjf8zJe/2wXrCffvhLX?=
 =?us-ascii?Q?C1Iidif75xdiEMjUSpx/0D89U/XkF9YZESS+ivwpiD+YUDfZsKdrw0sNuWxx?=
 =?us-ascii?Q?y6nBQ23nuse4BhkIvVrItVvYrUt5TtmJOQTLoqqR5vWAGC5QIz26pdZEhqFg?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?WrCXUeQBtj2uBwmgHstidfhcmfyevIC1PtCTgaPFEQ77/H4TJKTnMntubnFF?=
 =?us-ascii?Q?pFp2RKabZrz2+Ewpd+cuGG3ESFeJC2iwCCj1kMrQqBXhYkoOzvffXcggG6pt?=
 =?us-ascii?Q?6HGSo7qBRN3j6/h9nTYEHlQ3bpjH6mGh40TkUX0Tf39HWQwZ7aDS9kHaly8K?=
 =?us-ascii?Q?BtMpv5Mhz3YPZI5zul6id1/6TlumTozDghgPXOrMg0bdMvp3LTYgwv3awuyA?=
 =?us-ascii?Q?+31WHnmJ1im8DHNWQV4oPZUQ5EwOrDa2n6VX9F/uxcPnTTgTateoaP/loaam?=
 =?us-ascii?Q?gg3yQr9QIlN6ivh0ic1HAzAvpFIbcBGb7m07I4ESTLY7LaWCA6TBW64G9sT4?=
 =?us-ascii?Q?GCu9268UiDe50sFNRLyJ7pdaonYaonm7qSk2j8J5AN38q45kRjsAsFQ3Qm12?=
 =?us-ascii?Q?7u7mQ/zXzNlA4mCmuyP4sxinadeE6C+GKWuE9fXFdX8Vv6RQPB7f66trw9NV?=
 =?us-ascii?Q?gSfAolRuVn+UgiPDsY4D1s9PZLuU5dgI/DlHcjeLeJrtsI22BkALwNfM/2ei?=
 =?us-ascii?Q?hFDqgUUrqfGroJkDk1HAiqAKV8sccAbWw6ojfv7fPpTArWU8z0WuRk02A8lQ?=
 =?us-ascii?Q?L6PyjSIwvjsX8Q4YD6IygxCM4ifFjuXjj+urX83uwXMY/IPo4+TBnpDbChLg?=
 =?us-ascii?Q?hAuo76TzT6a+3UXEgKyNFu/vgOUhQvtqU6rmQ6IbVQQ+Q66s6mFhFhjO7NRN?=
 =?us-ascii?Q?Kyj8omJCaaF47OqHA9gMtYgSizlxZDvjhMvo1oaWY/nf79MJ5yX8w3xK/6Es?=
 =?us-ascii?Q?Xv4VBVFhqScnFvSw7fyD1iV6LiBJZmz+T1ks29Il9+s09i0uv3Max4FEnKOm?=
 =?us-ascii?Q?eNV2jcfLVlqAXufhtUKYDLs1dbg1L0CpdsfEi0sCm5NpASlQCdps5sfZdwye?=
 =?us-ascii?Q?+xpUspg2ZrbCbiZkxH3CCftVebrYRYWDFpXQbcI9cxMwhM/vwiNCKemIRaBz?=
 =?us-ascii?Q?s9iaNn9b4oOFExXZ7DeQSZQH9PE6JaoW6/4NMapUWj8RhGYP8q3t4fSipYIl?=
 =?us-ascii?Q?wQgqwP/1bhUUzsY5Yq5oihJFISYe8SXcjwsXKvXveENBqSJl8Axas1drg+Ja?=
 =?us-ascii?Q?uE9GvYat1X1Tz5uTnp0vWcJRz4qwmA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d3e095-6ca4-4d35-6ffc-08db0e2a335a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 01:24:21.7443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ESwGGGyaCttnjxpUKxcI+/1IMeYF96oT40rmaGXI9PBVI5NnPasGBF4IwWSllXzNmrPtp4FcVKtdoIakmNeQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_13,2023-02-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140008
X-Proofpoint-GUID: LdY_jKN2iYWrudv_gq8dK6byH3d6uhEx
X-Proofpoint-ORIG-GUID: LdY_jKN2iYWrudv_gq8dK6byH3d6uhEx
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
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Updated patch below.  Note that this depends on backport of upstream
commit 3489dbb696d25602aea8c3e669a6d43b76bd5358 which is already queued
up for 4.14-stable tree.

From dbe06348491116c4a58d972f5b6441369e8834c8 Mon Sep 17 00:00:00 2001
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
index aa2a88c09621..19552bcc592d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -574,7 +574,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
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

