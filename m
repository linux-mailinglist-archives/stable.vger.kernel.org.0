Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9B16B102C
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 18:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCHR06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 12:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHR05 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Mar 2023 12:26:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D14FA8C78;
        Wed,  8 Mar 2023 09:26:53 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328ENpo4011534;
        Wed, 8 Mar 2023 17:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=n2bRPfHIB7eMKJAGvkTjtvBjSs1HwXGh+X0274WRG4Y=;
 b=BqcBor2/8VZKjZBVW+TvuFk/vuAeIdoZsYr4LiaQW/w9OQK0emR+EWVVXsPR4HYlu0Sk
 5Y86ryNrLQ7Pl0xfZTlBEm8rfNb/Yps9XcoWW/f6oHYCz/FTMSjqGS8CgoTysHLFaDKh
 yysE69NdrN9TwaZn1HRpTLXSSSucCvM/ptryG2mvZjdETR6w9RZ5pifR2lHkmJ5nxOW+
 sxQUzR6unOqxU3rXWe9Cx+/hMWFP5z1qPz/ZO4CYyE7LYbB2C4Fiq7G9y4Qq9SJsLFPc
 MOQeITmomejIa2GzIpahBcQdBsD5CIeYFE4SEnVHOwLefuzkOG2U91riePURiCMm2CWY bg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417cgq89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 17:26:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328GJTHo020871;
        Wed, 8 Mar 2023 17:26:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu89e42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 17:26:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iyhc0SOCX236gWuQcIA4QPlBDHMM9nEBrTkxVchGXX3UsKQ5UGqQfm2+Fu2zy1p7I2lAvm8gAlffP5kS+5ih1+YlkCLsiLdQY10RItbeHUG/ziYjFHfGz4TKxToHJgJb0dT0TSB9Y27yGfJwj6+g08pnvX/vyECn8Vt4qPmuP5sJm6IuIsiVm9p6fXxOgwgeacWJmg12/QVp8xunod+qKzPAVAX3HkYXGz5IBBjQmpmINCEIUI3MXyAiGYrUVGdlIbfQxNTz6m54PrxC2FmXJro/pd4OvWmMklds+DkT5ZSOUKC/W6jALuQaG228VK4Qbqr+h1yUIhDGy2aQpkhguQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2bRPfHIB7eMKJAGvkTjtvBjSs1HwXGh+X0274WRG4Y=;
 b=fur5PLTdUjpZ5ssuV2Nk2FYL7o+cRKjb2QkAfekclZLZ7cIg7igbiauoMcwu96imp89lmOlMLtnlc17M5txG4gESSiEEs8rv/OvRZ6MxWmqTOJP679UxD3yn6RBA6XggOfqIc6zeUCimb8B/NtE1FqWhgBEhmmch/6qX8Wy8fp0pIL+MNIrjkniW3L4vO3/exC8xuFUJbt/s1foWwhEkjoKrFvOIN4fj0SyEm2O/MtfIxsIJEDj/z6o9EPWvEjp3eZDJSuSKIVdhhSeZWOao94XlKipqWCadq84N0FwVFJh5/ifx6zMKCzw7V7Pb08peEypAQHVIwVZrhakKPX1vaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2bRPfHIB7eMKJAGvkTjtvBjSs1HwXGh+X0274WRG4Y=;
 b=BLKjgkICZvmMhcmAfZ3li5ecSTRewNJKogzCbyzh6hYoXLbv4Et9mij8OawaueBi6ARLEdIIYtlYKbyKZusr1EQsAaCk6IJlCNMeLNngSGLUdChrvNlcTdW0rN7JsHcUBZjx52QotxaGnr0p7N4yzu9U1KIa/0ysXTGKXZUHIOQ=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA1PR10MB6637.namprd10.prod.outlook.com (2603:10b6:806:2be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 17:26:31 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Wed, 8 Mar 2023
 17:26:31 +0000
Date:   Wed, 8 Mar 2023 12:26:28 -0500
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>, heng.su@intel.com,
        lkp@intel.com, Stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm/ksm: Fix race with ksm_exit() in VMA iteration
Message-ID: <20230308172628.3ycemzp4rqs4wtlp@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        David Hildenbrand <david@redhat.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>, heng.su@intel.com,
        lkp@intel.com, Stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
References: <20230307205951.2465275-1-Liam.Howlett@oracle.com>
 <d6670aa7-37ee-85aa-1053-96284a2f6720@redhat.com>
 <20230308161927.lb4npblk2q4vkxmg@revolver>
 <9c995453-8e18-4be1-9e9d-7464f3678301@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c995453-8e18-4be1-9e9d-7464f3678301@redhat.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT3PR01CA0030.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::18) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SA1PR10MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c1bd3a-5578-452e-4aa1-08db1ffa421f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjsqz/Kh9NHl7Lz3R9BmulDCwdXv01KtgQI0yzheHlNlVpfFBvQJcoYrzNuT5LBt1bkj3P2Rw/lhRj3C4MinfzkwaGRYuOsYO8LlO2qfRsIH7Fr9mcjeahlSRZ0YovNx9FJqHWcf0sJslvk5SkXa+LWcL0KYtQRFXUo+tc/8mtNctkndaYbUK3LnblGHJAfqyedzCGSQ3DT5l4GDv2+qMNGKtruok7LtFhWDqxBwNHgwWBmTv2MbIQ+73wuoUFIpJZwfB8dFAVvUPlAH0fdDjlFsGdLQk9UzlZrMr5hxSjaIC3sqId9+CgCgz8jE+5wge8StlNPmp5DB3AFUytnUCi3lMiZvVfrq913p5OllknE0WNTPv/awnTlij5pXku1wUs7YY0Ux7+ZvTdt7JKwl3L8C0JKBmSb4xTCPMbgch49/ymcCk5mMWRRTPKco7te/isk2HDNr8/elmPbPjNiWfy/CgigK+GWHXdPCqr32WS1u1ZhWbBztxpd9oRz9UlAZgntKVydDtwx+m7a1WhYXQQQozyJvDPTcMHwMyMnsshUGqRmt29sLj95FYvLweucm2eSBbGM+IGc1yDzB4fYC20jQeddsqVmoG1tiMbeWNtxRIigex6X3Ndt8k+N+/5ZtT09TFmpJ47xnAcvvFDkd/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199018)(41300700001)(66556008)(4326008)(8676002)(8936002)(7416002)(2906002)(5660300002)(1076003)(66946007)(6916009)(86362001)(66476007)(38100700002)(54906003)(6486002)(478600001)(6666004)(26005)(316002)(33716001)(83380400001)(6512007)(53546011)(6506007)(186003)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qs38do898hFHeTN+V1INCbt+qkC1jw6Qc+LmhAJ7k3v5CtXvG3egEyuezjBl?=
 =?us-ascii?Q?fOAam3FIcsaR4sdsuS6nA6WJbIj49GRWBjLbI1bW+dCiAAHWXjpSoZ2th3JI?=
 =?us-ascii?Q?UUPRVAmgProECiYSfoP3d9ZB6QzfpQ4WqHMg2HcWiT6S6s9enCkHu0PYuoLz?=
 =?us-ascii?Q?qGNmgxa4moM8rmDjxaD3J8hGf5LCwdUhaHYfGkBmImXiRJooUXpit0I5bbxj?=
 =?us-ascii?Q?1oZ61roNsCbZFzdtczQ+JIDIeannISlUrH9h7RRByO/CipXi2lcUVgMDPbRk?=
 =?us-ascii?Q?cwkxfmtnSGlf/zO9NVE4aIYwgwQgxbot+JIRPYqUs85kOiIpwnRxrultM8iO?=
 =?us-ascii?Q?Buz2doVSmmRMIvOzT/5gSLKacLNPxU9Tz44aklIK19+aR9OOAkN3cf1HY3xd?=
 =?us-ascii?Q?BhX4E2ifY/1Z/n7xGclc9NjBjPzxIEAstMU70VZeDA/DU7VRxaRkxO4F/KNN?=
 =?us-ascii?Q?NSRISRPgE5Ab53zsLnCD8WO/crgCiPDvgbHc3ZbZHSdkQZa6gNi/hOYLEU4h?=
 =?us-ascii?Q?ooLuJkNH+5JJX/pL+45sBjjI7YD25EZ0HWmi73ckE/63e4GBy8SefrrTIpi5?=
 =?us-ascii?Q?n6b9cNbWpnvwG8BSoesZLbCEEq3zLXVrT+22fU4rCgNBLeb4v91UYfgEQInz?=
 =?us-ascii?Q?vzO+VfFQ89dWNiYmG0Y2XqghV9weDTPI67CtPjwCoQ1T4h/fYmgfRUL/koMS?=
 =?us-ascii?Q?r4JMeuecL+M2Lv/J7fWrUnbVWwzhSx61UNaZwSira6qJ8DWA13kE9SH4oLfA?=
 =?us-ascii?Q?J9yi0LVb/txwnsHsH/IXAdBhpJ/QONEaCF+8TsGejpwPB2wHrNuagPpmsT8P?=
 =?us-ascii?Q?q2X/Lqe9qJ5Wi/v1hpd87OqWVFfTOJ+j5NEFcw7UEvKClTps13WNyh4gJZ6C?=
 =?us-ascii?Q?i/OB1ucLJe004ubQpMb5VVQ9s89RH+hhYceZw0VlD3GGRo9iZAhLuzglK3ut?=
 =?us-ascii?Q?UPoBG+WjyLQnLqSjwQ9dpcZSTmxdSKJhuhK6Lr9lveh0IHzE6FY4R6T9aRfV?=
 =?us-ascii?Q?Tk3mwEWAY8dsJopFpEYyzBEsLb9oMQfBiXCNWX/Dii4TgpXblXx0bw44J3lP?=
 =?us-ascii?Q?jWiRFFjrtjqS/RteMRSx44cHN1tjHqzuks6aK0q2dORqoQ8ip8E5HMCl9QTU?=
 =?us-ascii?Q?wPVpsKtZamsU2ULeQmS1Rwo4D4hzcigTDHPARGON4eraq8mPluObZVm3zhfi?=
 =?us-ascii?Q?P1b2DvYyAUzcxZq2KhXl16azgQ3m3W54W1AdNTHsiQAcpeevTf5hZfk0B99d?=
 =?us-ascii?Q?1st24uiYfYThs2Ez+iTvpqOU9AylCDZMpb0qgwbB6UNrHaKcnExnmOH9rvV9?=
 =?us-ascii?Q?r9u6rbxFOxM2sQcZmiMcVnDDKU1/eIRTrcSX63v7zRwOSHXCYNBALbD2nS2s?=
 =?us-ascii?Q?E7Lxu6fnonGj0F27DsZ5b8hjMidppRZ6xGmWIYBbForRHngyzghb0hZ6u7Rr?=
 =?us-ascii?Q?c/bQl24s5+PkSXWQFDMs2M7DnJ0N3dsE7EhcVgWQgQKDsMTo7spwY3cIxt0f?=
 =?us-ascii?Q?nVKLfJ+rDjoODLgxZr/ty9Su+m4GeBxLLM8IDzMK2ud6UQoy34+AzuxF6DqG?=
 =?us-ascii?Q?RpHElzBw765R30PW0Dx/p3BxrsQCZ7XFD6K8+i4PCWXiV/qHqcxXxKkpssca?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?LDZqqNkHfzClZBojjXsdKYo5ebCRoclS9tCPuvzuxxoe1FAc8EgBgjGCJ7NU?=
 =?us-ascii?Q?EWE0aZGwdL1ZkZHNKotR10XWvbJ6LyP9mhpe1L4OuE055guFJTkMF9/0mNUG?=
 =?us-ascii?Q?IEWlve1f/X9JzHRx/69MDdMvEmoa/LzTvjCWk2YdxEOy53ilF4bZ1J5wAQJ3?=
 =?us-ascii?Q?cYtyXbX75aletGHJHA8mirR175TGWfo8HXQ0l6x7wMW+r1ZkmCV0Bst37v+Q?=
 =?us-ascii?Q?rtvVXjFUA94O4XNbOz6/65YvongejMsgts/MTK55sl0xlu7+UWGtuCjIvhmh?=
 =?us-ascii?Q?YxwqFXf1Lu3dApifTqcLSIfcZVY8UibH4hOtVa+Zi0hssN3xkNVDGZFsFig0?=
 =?us-ascii?Q?tlp/gSLejv1lydd+AWFNP6X9YIc7uzbcsjdnEk+nkjE8IfhB+88464TqGGHI?=
 =?us-ascii?Q?d70/D/+DFGP4HVh12gN8Au8v484G0hpncbQo9LiBMztloio2yeh9vvsDmLNb?=
 =?us-ascii?Q?b7R7YcqYMWVJvwmDwh/q/a1qL3stLPz5dQ7dtfDsxBPqOSM4srDnfAfInyaQ?=
 =?us-ascii?Q?2dQBACXVq2vweyL28pbbOsqyJUYeMI69KbNmI51U8vbJ0SHeVGkt/X2Lu2wW?=
 =?us-ascii?Q?nzXkGNKZBlW/BbDGIUtCMT4SPH76kABp/ocy6HtaFEqdUA6LUr1E9y9i/9Z2?=
 =?us-ascii?Q?+fJ4MW14/lp4zW8+1P3V1wf4PZKhijVzh6DaHK847oKClQei3JrYzfozZwYv?=
 =?us-ascii?Q?6TgL294iTdurKLtIeb8wXH46dd/K5o44obzODIlPMajwQaweEb83K5bI8oDi?=
 =?us-ascii?Q?QSCwsHE+/TNVGEoKkDCRzmoHkAZnNlzR1Wmd2OhMGpcbd0Os6MYH1rAuke5Y?=
 =?us-ascii?Q?z6Ak4MqNy19GeRboQbV65MUHNgyIhApMBGDlyv+C6UXhzk2G0iBAQJXiciUC?=
 =?us-ascii?Q?+C2dJeJ2O6MBtcT6voVQp/umFbQZdbJom/Aa4SE5BMUgDlQVfSy/p5UA9h0G?=
 =?us-ascii?Q?1R0UNgPTolyVCJg3UybidlDKwhKgJCs7pcUDMe0Io1GAq1XlVl0YzW8VvhKE?=
 =?us-ascii?Q?TEozry+y6UPXhT5wPsfK8ZtixYTk2vn+/kipnY4yNH8Wr0nSDODEzd4/tLdb?=
 =?us-ascii?Q?69Fd4qwDcXym30ZCs/RKFcv5FyCclA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c1bd3a-5578-452e-4aa1-08db1ffa421f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 17:26:31.6564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhxVlNCmNB5oUQ+7x4YaLiJO9tUnNkGdTHawQcoyD5CA3rahBo8S8WCdhJqdk1hG2CcWdYhuINMKGHDdkRpP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_10,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=777 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080149
X-Proofpoint-GUID: 4mZ9pPQFBuXvzSBwVTYfcUiXapC_sDUQ
X-Proofpoint-ORIG-GUID: 4mZ9pPQFBuXvzSBwVTYfcUiXapC_sDUQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* David Hildenbrand <david@redhat.com> [230308 11:46]:
> On 08.03.23 17:19, Liam R. Howlett wrote:
> > * David Hildenbrand <david@redhat.com> [230308 04:41]:
> > > On 07.03.23 21:59, Liam R. Howlett wrote:
> > > > ksm_exit() may remove the mm from the ksm_scan between the unlocking of
> > > > the ksm_mmlist and the start of the VMA iteration.  This results in the
> > > > mmap_read_lock() not being taken and a report from lockdep that the mm
> > > > isn't locked in the maple tree code.
> > > 
> > > I'm confused.
> > 
> > Thanks for looking at this.  My explanation is incorrect.
> > 
> 
> Heh, so that explains my confusion :)
> 
> > > The code does
> > > 
> > > mmap_read_lock(mm);
> > > ...
> > > for_each_vma(vmi, vma) {
> > > mmap_read_unlock(mm);
> > > 
> > > How can we not take the mmap_read_lock() ? Or am I staring at the wrong
> > > mmap_read_lock() ?
> > 
> > That's the right one.  The mmap lock is taken, but the one we are
> > checking is not the correct one.  Let me try again.
> > 
> > Checking the mm struct against the one in the vmi confirms they are the
> > same, so lockdep is telling us the lock we took doesn't match what it
> > expected.  I verified that the lock is the same before the
> > 'for_each_vma()' call by inserting a BUG_ON() which is never triggered
> > with the reproducer.
> > 
> > ksm_test_exit() uses the mm->mm_users atomic to detect an mm exit.  This
> > is usually done in mmget(), mmput(), and friends.
> > 
> > __ksm_exit() and unmerge_and_remove_all_rmap_items() handle freeing by
> > use of the mm->mm_count atomic. This is usually via mmgrab() and mmdrop().
> > 
> > mmput() will call __mmput() if mm_users is decremented to zero.
> > __mmput() calls mmdrop() after the ksm_exit() and then continue with
> > teardown.
> > 
> > So, I believe what is happening is that the external lock flag is being
> > cleared from the maple tree (the one lockdep checks) before we call the
> > iterator.
> > 
> 
> Thanks for the explanation.
> 
> So, IIUC, we are really only fixing  a lockdep issue, assuming that the
> maple tree cleanup code leaves the maple tree in a state where an iterator
> essentially exits right away. Further, I assume this wasn't a problem before
> the maple tree: there would simply be no VMAs to iterate.

Yes, the tree is empty so it will be a noop after the dereference.

This is really just a lockdep fix so I don't think it mattered before.

> 
> > task 1					task 2
> > unmerge_and_remove_all_rmap_items()
> >   spin_lock(&ksm_mmlist_lock);
> >   ksm_scan.mm_slot is set
> >   spin_unlock(&ksm_mmlist_lock);
> > 
> > =======================================================================
> > 	At this point mm->mm_users is 0, but mm_count is not as it will
> > 	be decremented at the end of __mmput().
> > =======================================================================
> > 
> > 					__mmput()
> >   					 ksm_exit()
> > 					  __ksm_exit()
> > 					   spin_lock(&ksm_mmlist_lock);
> > 					   mm_slot is set
> > 					   spin_unlock(&ksm_mmlist_lock)
> > 					   mm_slot == ksm_scan.mm_slot
> > 					   mmap_write_lock();
> > 					   mmap_write_unlock();
> > 					   return
> > 					 exit_mmap()
> > 					   ...
> > 					   mmap_write_lock();
> > 					   __mt_destory()
> > 					     Free all maple tree nodes
> > 					     mt->flags = 0;
> > 					   mmap_write_unlock();
> > 					   ...
> > 
> >   mmap_read_lock()
> >   for_each_vma()
> >     lockdep checks *internal* spinlock
> > 
> > 
> > This was fine before the change as the previous for loop would not have
> > checked the locking and would have hit the ksm_test_exit() test before
> > any problem arose.
> > 
> > Now we are getting a lockdep warning because the maple tree flag for the
> > external lock is cleared.
> > 
> > How about this as the start to the commit message:
> > 
> > The VMA iterator may trigger a lockdep warning if the mm is in the
> > process of being cleaned up before obtaining the mmap_read_lock().
> 
> Maybe something like the following (matches my understanding, as an
> inspiration):
> 
> "
> exit_mmap() will tear down the VMAs (maple tree) with the mmap_lock held in
> write mode. Once we take the mmap_lock in read mode in
> unmerge_and_remove_all_rmap_items(), we are protected against such
> concurrent teardown, however, the teardown might already have happened just
> the way KSM slot registration machinery works.
> 
> Without the VMA iterator, we didn't care. But with the VMA iterator, lockdep
> will now complain when stumbling over a the destroyed maple tree.
> 
> Let's check for the teardown by relying on ksm_test_exit() earlier, before
> working on a torn down maple tree.
> "

I'll give it a shot.

> 
> > 
> > > 
> > > > 
> > > > Fix the race by checking if this mm has been removed before iterating
> > > > the VMAs. __ksm_exit() uses the mmap lock to synchronize the freeing of
> > > > an mm, so it is safe to keep iterating over the VMAs when it is going to
> > > > be freed.
> > > > 
> > > > This change will slow down the mm exit during the race condition, but
> > > > will speed up the non-race scenarios iteration over the VMA list, which
> > > > should be much more common.
> > > 
> > > Would leaving the existing check in help to just stop scanning faster in
> > > that case?
> > 
> > Yes.  But why?  We would stop the scanning faster in the race condition
> > case, but slow the normal case down.
> > 
> > This check was here to ensure that the mm isn't being torn down while
> > it's iterating over the loop.  Hugh (Cc'ed) added this in 2009, but the
> > fundamental problem he specifies in his commit message in 9ba692948008
> > ("ksm: fix oom deadlock") is that exit_mmap() does not take the
> > mmap_lock() - which is no longer the case.  We are safe to iterate the
> > VMAs with the mmap_read_lock() as the mmap_write_lock() is taken during
> > tear down of the VMA tree today.
> > 
> 
> Right. I just spotted that we have a ksm_test_exit() already in
> unmerge_ksm_pages(), so that should be sufficient to make us stop scanning
> in case ksm_exit() is waiting for the mmap lock.

Yeah, I don't think it's necessary in this case but that function is
used elsewhere.

> 
> 
> Adding a comment summarizing why that's required before iterating would be
> nice. Like
> 
> /* Exit right away if the maple tree might have been torn down. */

Ack.

> 
> 
> With a better description, feel free to add
> 
> Acked-by: David Hildenbrand <david@redhat.com>

Will do.  I'll give Hugh some time to look at this before sending out a
v2.

Thanks,
Liam

