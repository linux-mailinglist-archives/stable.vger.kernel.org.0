Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A934138CD85
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 20:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhEUSe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:34:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbhEUSe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 14:34:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LIFBPg177637;
        Fri, 21 May 2021 18:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=kvdkz97AILfiPcl3q2PXC6LNqIAuPnNY27lPCVKOFis=;
 b=AH5YBj8MM6LKHxgzFIW4IeZOWIUOQZr242AFzxNYssB4Jipe0v7+hBK8AUP4R1gFpBww
 gyoKV/VR8lWitCUgUaOs8e3/qPb4TVWRy7gGxqdG0inP+ZwTTpcWAHlli6PWhDNxYR32
 q7LpcmPxNPlUi9xeWTc6EdMeslVgjq9OKP4SfIoXCNhax2iairWnR1D/8ivD917XVGTA
 Kl04PUmzwN+ZPGJue23krckVHPcMmBmYMHQCWrSyNSf86K0U1JEagzzeW1R49EriSajq
 CJsUEDAwI+yATMyPLTlEw+Z0068ef8xAfu33lYsljxf8fXhAA2UyAvEEJxljnOs6FV70 hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38j5qrgfnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:33:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LIFY5s182881;
        Fri, 21 May 2021 18:33:27 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by aserp3030.oracle.com with ESMTP id 38meehyy5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqUWFyxsAUznGUyLOaMj4eqbP50L8vc9QaGu8+Ph3HR9qQZv3UEwka7ruulBpXSUl20vnQUV2YdgMhkyt/DJCcutolmxRCTHLTcIMPu/AMefRigksSmoFH0kjnxdSs+s4XuZnxbx9uT803Sh+m8AcytvokrjrO9GYeYG2MRZhwcOh7CW3WZfXIjpX/I/B0FXYSSbGXdCFUs8fVK+DJHEZolSv6AloPbB/SSgj89uWfrclVCr4zvdxay/2FN/xoWp2G9OUkQtzLWHX/WRIPEtkcFDVMz4gImVhGmt6Wmk+jGu/iBZZPktcH9pwB3Yth6NBQdasIkJEort6490Tfnalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvdkz97AILfiPcl3q2PXC6LNqIAuPnNY27lPCVKOFis=;
 b=GDVq9EEGl6ZckQjagN2BZ9F2V1Nca1/4ODrZLkaSElfZVMOdJoZtxtzwu1I5Anqdr/5YNXl4/Q7vp1Z1TA34UD7b7AztTPJkNQK9rus25onf7hXr5PdW7MOI1niYfBV8op/dAVUOt+YfTZeE4+ced188C16VsIXa+n8kOOTCcUZq0eCubbacvje+OK2/jQK1ye5W6lIKYK9Qt45EMDF01Sa1ihKSbpTjJ5kDoHIPtTwWGA1D+cxG1mK6p7zS2/awjFyvQvE6TpDeRRW7TqWXX/+xRhiTiixupBvvJ8r2U7SnISs0rfpx6gaHPH6ffDPq6K65kh7lIvaP6lhFGjDHVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvdkz97AILfiPcl3q2PXC6LNqIAuPnNY27lPCVKOFis=;
 b=g/gtyn8vMVk0+02A0KDdBbWNAdWKVH2Zear8lQAGA/k/WwT26Sa3qg2hLAs9I6Y31Rs78pSGCJThYp7J1PnXQrlloJdamQr/WjSjipPCDTQWWtzUUfYHX/HcSW0mcY+9SrPFRiSgUJmVmpP2Rdvq9T0kyyLNzVbfNaMSqWgHxpo=
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM5PR1001MB2236.namprd10.prod.outlook.com (2603:10b6:4:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.29; Fri, 21 May
 2021 18:33:25 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 18:33:25 +0000
From:   George Kennedy <george.kennedy@oracle.com>
Subject: 5.4.y missing upstream commits 7beb691f and 51f644b4, causing:
 WARNING in vkms_vblank_simulate
Organization: Oracle Corporation
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     daniel.vetter@ffwll.ch, Vegard Nossum <vegard.nossum@oracle.com>,
        Dhaval Giani <dhaval.giani@oracle.com>, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <c6ba0ebc-41da-60b0-4c59-53ee76c60ba0@oracle.com>
Date:   Fri, 21 May 2021 14:33:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SN4PR0601CA0018.namprd06.prod.outlook.com
 (2603:10b6:803:2f::28) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.222] (108.26.147.230) by SN4PR0601CA0018.namprd06.prod.outlook.com (2603:10b6:803:2f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Fri, 21 May 2021 18:33:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d37873dd-b105-4692-a191-08d91c86eb83
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2236774F06DD189C95A76033E6299@DM5PR1001MB2236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kywGRDMMgtH+1KyvB6qaPQKTJwoH1GRGe9lKZG2IAgmpOHUttwi5mImk2cuYbiaLA7PF0x1CJ2szOT7cWEEAbNgY+4TV3sVO7j/m6ug5zLhmzJ97Qf04E3kLQHCTqWTMKlLc0UmR1COkP9q9lWelQfnzGtoxxrzFn5HbUvMsSycLa/vgHj3sPWaxd4UsFJuuiIH5gnC9PNUsh9GKnKEyB2IkBBKjHDlw8Y2jGN2HY/G/5zMlRoQRpi1kOcozhUvUdfeXsW/v8eHsbfnXMBVUniS3LKhuMAK9Kl5kPlcD8ne2VcdpDaR5QjO9Dhz2FQo4oNRz1SLnAGNZhhS10YI4bkYW9Dcr8oKYneCHO1SrCg4YSJ/7c81SuQPs0rdHJ7/YHGMt3iXZB1VuJgzs0s1NNTn2Scrtyro+WkeDnoCk2kc/MUMvIQqIrk22nQwFtiwROo3wfMJ95GmJrcIF1HxKWXtLHbQ+wYZsQGjiwxxqWipwSF0VRBnm6ANTVh3+LG8koeFHo2SYds6nCu0mJ2L3llxW4gXe0+40T9OsNyIq3zL7KPHLdKXoVY/zLcv4rks3tzuCTPq6GnY/GiUO5+3JMAGvQ8Ea9qY1VnbAREAXPor2qxJXt/pFk1EPkf8TqUj9KYts1fa7stS0hkPxEh4thh2UqT4nEGQBiuQCCPv+Av6IqCJnayj4LfVQ4kx7gI7bMNYMJwlxYPNG6KP+iKGYsyrMPvRNZBEvi9dqP0ZDU4vdLb39HQlx8tjGkY8dR9RwfzSv9nLBUvhU54qC48MOvZ7ZZqyfMsRieXcc0mL93SlrR5doN5WfxQkUL/sXZzXN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(36916002)(966005)(186003)(26005)(107886003)(478600001)(16526019)(16576012)(38100700002)(45080400002)(54906003)(6486002)(316002)(4326008)(31696002)(2906002)(6916009)(956004)(44832011)(5660300002)(8936002)(30864003)(8676002)(83380400001)(66476007)(31686004)(66556008)(36756003)(86362001)(2616005)(66946007)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U3hlTEVGQ0hlK3F0T3VkcjFDMFg1RVpoMUpwc3pCdnNhOHczSlRBellHSjlw?=
 =?utf-8?B?WlhHbnlleWV5cURQdDlPNml6a0dmMnNPQ25MZS9rWHpjQzJEQlFEK2NNMFJV?=
 =?utf-8?B?VGxNVDdxdFJDQTlPejF1U2g4bDBVWTErVU9SMGFYaGxFQmh6WGhadkw1QnBT?=
 =?utf-8?B?M0tZd29iRnEvdjZSTXBMSndqVGNhMDliUmhlQjAzME9MMmtSZXl0ZHlnTmxE?=
 =?utf-8?B?L0RUeXZ1UkJ6czhDV3plUE5FaE5ob1JRN1ZSK3lyWVhUL3llMXJHOWE3ZDFW?=
 =?utf-8?B?QUJObndiSC9NUzk3ZDVoam1GTGlDMk1GTlVPUURBYndXOTMxUlYxK0s2b0c2?=
 =?utf-8?B?ZWJtL0xNZWZKSW5NMGhRMEZqVUhqMzZ5d0FEcGExNkxzZ1VHS1ZqdmRKZXBB?=
 =?utf-8?B?UTBwTEpVbTkwY2I0dzNTTnRoVWYzVTdXVXVvL1dRMDZLT3N0YVhlSE9wVnh4?=
 =?utf-8?B?U29lM0J5L1luTTdmZWZlVUhYZmxGK1UwVGdlZmZNSWNoMHBGT0l5SDV6eS95?=
 =?utf-8?B?Q3k4djVLZWZhb2tVSXJ0MWg1dm5aZDV3eUJwSXRMdllsZXpQOXdBb2t4dCtv?=
 =?utf-8?B?MzdJMkxJRkpvYjBvWkFpVUlNZzh1WjRud2YrY0NEUWtuZVJheFMvRm5ZbHgx?=
 =?utf-8?B?NW1WK2FCNnZSbnk4NVhrYVR5cDZNYng1d0k1ZU1mWEF0OEp6cTZuOGtCUGhB?=
 =?utf-8?B?SVBtb21yNDV1UlRvbEpQTDByOVJnOGxmMHNTSjQ5VkNqdkdKZ3RmN0xhS2Jw?=
 =?utf-8?B?VlpyZWVTTDdYclFFNlFxRExReU1XUnVNOGNGbkJnbHVlWklLRnJBSVJ1NVY3?=
 =?utf-8?B?QlRaWlg3bDhLaFhxNEdWenJXcWs4NUtlM3cvLzZuYThqV0d3am1pTHpFN2ZB?=
 =?utf-8?B?SStVc2wzYVF4U2lSelZLeHlHVkhaRXdFVy9LaXJzSjlGeEhrWFkwMkpkTVIv?=
 =?utf-8?B?RitaL3R6NGxQYzV4UGxJZ0pCQzVpNEFUZXZmTTZKZE5RRnZDdksvRWM3N0JD?=
 =?utf-8?B?RmFuaFRSUmFPSnlHYkpzdjROOUxmdmxtRTBuQ09UTUZ2SWpBTUFBbEdQRkJi?=
 =?utf-8?B?VjAxclBBQlRQaENJQ2tscFVIUnlORkljNElHWVFlcCtZNEdGaVRGaXBpT1FE?=
 =?utf-8?B?NnJkbXVvczgzaVBsRnBZbGRpc01IMWFEVHpManVqWVdnTnJrVVYyN0lkNlNl?=
 =?utf-8?B?WHExTEhiK3JuVTgwT2hVdU8zKzNlQ3puNEFaeEVmbnhub3JFaUJJR0RneFRs?=
 =?utf-8?B?MWxEaDY2SGtWM0VkZXYwN1UrNjloWDdCV25uVExZQVBmaGs4WGZiemYvMzUv?=
 =?utf-8?B?elRYOHZmU3JYeERpNUZFQ0pLQ3l4Mlc0aDk0Zy9zdXpFaUdlRmI4UDVDRE1v?=
 =?utf-8?B?aTU5VWhEQzE2YU13bG1Zd0RSNENhS2dWbkNVOXBnMW94cFNFWDgyNEI4SU1u?=
 =?utf-8?B?VWxhUWpIaEJ1Si9lblZRY29QUkhQdGtlWm1iY1hsK1FuSGplcDJ2bGhPR3FC?=
 =?utf-8?B?cG9wMW9Bd0JFWHFOVElKb0FJRkRlNW9OYURNMXBLcHM3eWFBd3lNdEQxM1VU?=
 =?utf-8?B?ZEJ5bWhIWnRrM3ZMazk0RWZEUFh2M2RZdG9lckx3Nzhyek10SVdSQk9YU0NE?=
 =?utf-8?B?WkYzOUlqVXpTTEJudWQ1UjRLUWZsZGJHUlkrc2hHc3Bzd0FTM3JQeG9nZFBN?=
 =?utf-8?B?S0tmVUg0Y2RjbVhMOTBIZHovVlNLWnhCaXdVWjZrQjJnUTdQM29hQmptc2Vi?=
 =?utf-8?Q?nvmhulgbhMt6n77ALUBHQ+iKAQHduwdFe5pTIO+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d37873dd-b105-4692-a191-08d91c86eb83
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 18:33:25.3872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tOp4bkA7YrO82Ihql7dMlQt2TPCpKac/RUvmAR28E406SK+9P84lv3D+mwlkvNTayd+StQlIASQlOPz0lCrZQGHowNms1CJ8S3+9pJ7iO4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2236
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210095
X-Proofpoint-GUID: QU4J5Ys1pBM7g5t9600hCC2VcZNo5I_b
X-Proofpoint-ORIG-GUID: QU4J5Ys1pBM7g5t9600hCC2VcZNo5I_b
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

During Syzkaller reproducer testing on 5.4.y ( 5.4.121-rc1) the 
following warning occurred:

WARNING in vkms_vblank_simulate
https://syzkaller.appspot.com//bug?id=0ba17d70d062b2595e1f061231474800f076c7cb

First, upstream commit 7beb691f was cherry-pick'd to 5.4.y as upstream 
commit 51f644b4 is dependent on it.
drm: Initialize struct drm_crtc_state.no_vblank from device settings
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7beb691f1e6f349c9df3384a85e7a53c5601aaaf 


Second, upstream commit 51f644b4 was cherry-pick'd to 5.4.y, the 
conflicts were resolved, and the warning no longer occurs (rebooted 10 
times with the fix commits - no "WARNING in vkms_vblank_simulate" 
messages).
drm/atomic-helper: reset vblank on crtc reset
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=51f644b40b4b794b28b982fdd5d0dd8ee63f9272


Cherry-pick'd upstream commit 51f644b4 with conflicts resolved (showing 
the cherry-pick'd commit ID):

commit 39f1d9e81159fd1ff11c541b3310c0a204f8718e
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Jun 12 18:00:49 2020 +0200

     drm/atomic-helper: reset vblank on crtc reset

     Only when vblanks are supported ofc.

     Some drivers do this already, but most unfortunately missed it. This
     opens up bugs after driver load, before the crtc is enabled for the
     first time. syzbot spotted this when loading vkms as a secondary
     output. Given how many drivers are buggy it's best to solve this once
     and for all in shared helper code.

     Aside from moving the few existing calls to drm_crtc_vblank_reset into
     helpers (i915 doesn't use helpers, so keeps its own) I think the
     regression risk is minimal: atomic helpers already rely on drivers
     calling drm_crtc_vblank_on/off correctly in their hooks when they
     support vblanks. And driver that's failing to handle vblanks after
     this is missing those calls already, and vblanks could only work by
     accident when enabling a CRTC for the first time right after boot.

     Big thanks to Tetsuo for helping track down what's going wrong here.

     There's only a few drivers which already had the necessary call and
     needed some updating:
     - komeda, atmel and tidss also needed to be changed to call
       __drm_atomic_helper_crtc_reset() intead of open coding it
     - tegra and msm even had it in the same place already, just code
       motion, and malidp already uses __drm_atomic_helper_crtc_reset().
     - Laurent noticed that rcar-du and omap open-code their crtc reset and
       hence would actually be broken by this patch now. So fix them up by
       reusing the helpers, which brings the drm_crtc_vblank_reset() back.

     Only call left is in i915, which doesn't use drm_mode_config_reset,
     but has its own fastboot infrastructure. So that's the only case where
     we actually want this in the driver still.

     I've also reviewed all other drivers which set up vblank support with
     drm_vblank_init. After the previous patch fixing mxsfb all atomic
     drivers do call drm_crtc_vblank_on/off as they should, the remaining
     drivers are either legacy kms or legacy dri1 drivers, so not affected
     by this change to atomic helpers.

     v2: Use the drm_dev_has_vblank() helper.

     v3: Laurent pointed out that omap and rcar-du used drm_crtc_vblank_off
     instead of drm_crtc_vblank_reset. Adjust them too.

     v4: Laurent noticed that rcar-du and omap open-code their crtc reset
     and hence would actually be broken by this patch now. So fix them up
     by reusing the helpers, which brings the drm_crtc_vblank_reset() back.

     v5: also mention rcar-du and ompadrm in the proper commit message
     above (Laurent).

     Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
     Acked-by: Maxime Ripard <mripard@kernel.org>
     Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
     Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
     Acked-by: Liviu Dudau <liviu.dudau@arm.com>
     Acked-by: Thierry Reding <treding@nvidia.com>
     Link: 
https://syzkaller.appspot.com/bug?id=0ba17d70d062b2595e1f061231474800f076c7cb
     Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
     Reported-by: syzbot+0871b14ca2e2fb64f6e3@syzkaller.appspotmail.com
     Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
     Cc: "James (Qian) Wang" <james.qian.wang@arm.com>
     Cc: Liviu Dudau <liviu.dudau@arm.com>
     Cc: Mihail Atanassov <mihail.atanassov@arm.com>
     Cc: Brian Starkey <brian.starkey@arm.com>
     Cc: Sam Ravnborg <sam@ravnborg.org>
     Cc: Boris Brezillon <bbrezillon@kernel.org>
     Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
     Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
     Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
     Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
     Cc: Maxime Ripard <mripard@kernel.org>
     Cc: Thomas Zimmermann <tzimmermann@suse.de>
     Cc: David Airlie <airlied@linux.ie>
     Cc: Daniel Vetter <daniel@ffwll.ch>
     Cc: Thierry Reding <thierry.reding@gmail.com>
     Cc: Jonathan Hunter <jonathanh@nvidia.com>
     Cc: Jyri Sarha <jsarha@ti.com>
     Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
     Cc: Rob Clark <robdclark@gmail.com>
     Cc: Sean Paul <seanpaul@chromium.org>
     Cc: Brian Masney <masneyb@onstation.org>
     Cc: Emil Velikov <emil.velikov@collabora.com>
     Cc: zhengbin <zhengbin13@huawei.com>
     Cc: Thomas Gleixner <tglx@linutronix.de>
     Cc: linux-tegra@vger.kernel.org
     Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
     Cc: linux-arm-kernel@lists.infradead.org
     Cc: linux-renesas-soc@vger.kernel.org
     Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
     Link: 
https://patchwork.freedesktop.org/patch/msgid/20200612160056.2082681-1-daniel.vetter@ffwll.ch
     (cherry picked from commit 51f644b40b4b794b28b982fdd5d0dd8ee63f9272)
     Signed-off-by: George Kennedy <george.kennedy@oracle.com>

     Conflicts:
         drivers/gpu/drm/tidss/tidss_crtc.c
         drivers/gpu/drm/tidss/tidss_kms.c

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c 
b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
index 52c4256..d301e55 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
@@ -440,10 +440,8 @@ static void komeda_crtc_reset(struct drm_crtc *crtc)
      crtc->state = NULL;

      state = kzalloc(sizeof(*state), GFP_KERNEL);
-    if (state) {
-        crtc->state = &state->base;
-        crtc->state->crtc = crtc;
-    }
+    if (state)
+        __drm_atomic_helper_crtc_reset(crtc, &state->base);
  }

  static struct drm_crtc_state *
@@ -564,7 +562,6 @@ static int komeda_crtc_add(struct komeda_kms_dev *kms,
          return err;

      drm_crtc_helper_add(crtc, &komeda_crtc_helper_funcs);
-    drm_crtc_vblank_reset(crtc);

      crtc->port = kcrtc->master->of_output_port;

diff --git a/drivers/gpu/drm/arm/malidp_drv.c 
b/drivers/gpu/drm/arm/malidp_drv.c
index 333b88a..566b183 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -865,7 +865,6 @@ static int malidp_bind(struct device *dev)
      drm->irq_enabled = true;

      ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
-    drm_crtc_vblank_reset(&malidp->crtc);
      if (ret < 0) {
          DRM_ERROR("failed to initialise vblank\n");
          goto vblank_fail;
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c 
b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
index 1098513..ce246b9 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -411,10 +411,8 @@ static void atmel_hlcdc_crtc_reset(struct drm_crtc 
*crtc)
      }

      state = kzalloc(sizeof(*state), GFP_KERNEL);
-    if (state) {
-        crtc->state = &state->base;
-        crtc->state->crtc = crtc;
-    }
+    if (state)
+        __drm_atomic_helper_crtc_reset(crtc, &state->base);
  }

  static struct drm_crtc_state *
@@ -528,7 +526,6 @@ int atmel_hlcdc_crtc_create(struct drm_device *dev)
      }

      drm_crtc_helper_add(&crtc->base, &lcdc_crtc_helper_funcs);
-    drm_crtc_vblank_reset(&crtc->base);

      drm_mode_crtc_set_gamma_size(&crtc->base, ATMEL_HLCDC_CLUT_SIZE);
      drm_crtc_enable_color_mgmt(&crtc->base, 0, false,
diff --git a/drivers/gpu/drm/drm_atomic_state_helper.c 
b/drivers/gpu/drm/drm_atomic_state_helper.c
index d0a937f..9c16936 100644
--- a/drivers/gpu/drm/drm_atomic_state_helper.c
+++ b/drivers/gpu/drm/drm_atomic_state_helper.c
@@ -31,6 +31,7 @@
  #include <drm/drm_device.h>
  #include <drm/drm_plane.h>
  #include <drm/drm_print.h>
+#include <drm/drm_vblank.h>
  #include <drm/drm_writeback.h>

  #include <linux/slab.h>
@@ -76,6 +77,9 @@
      if (crtc_state)
          crtc_state->crtc = crtc;

+    if (drm_dev_has_vblank(crtc->dev))
+        drm_crtc_vblank_reset(crtc);
+
      crtc->state = crtc_state;
  }
  EXPORT_SYMBOL(__drm_atomic_helper_crtc_reset);
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c 
b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index 3951468..dbfd113 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -1043,8 +1043,6 @@ static void mdp5_crtc_reset(struct drm_crtc *crtc)
          mdp5_crtc_destroy_state(crtc, crtc->state);

      __drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
-
-    drm_crtc_vblank_reset(crtc);
  }

  static const struct drm_crtc_funcs mdp5_crtc_funcs = {
diff --git a/drivers/gpu/drm/omapdrm/omap_crtc.c 
b/drivers/gpu/drm/omapdrm/omap_crtc.c
index f5e1880..cfeb424 100644
--- a/drivers/gpu/drm/omapdrm/omap_crtc.c
+++ b/drivers/gpu/drm/omapdrm/omap_crtc.c
@@ -698,14 +698,16 @@ static int omap_crtc_atomic_get_property(struct 
drm_crtc *crtc,

  static void omap_crtc_reset(struct drm_crtc *crtc)
  {
+    struct omap_crtc_state *state;
+
      if (crtc->state)
          __drm_atomic_helper_crtc_destroy_state(crtc->state);

      kfree(crtc->state);
-    crtc->state = kzalloc(sizeof(struct omap_crtc_state), GFP_KERNEL);

-    if (crtc->state)
-        crtc->state->crtc = crtc;
+    state = kzalloc(sizeof(*state), GFP_KERNEL);
+    if (state)
  }

  static struct drm_crtc_state *
diff --git a/drivers/gpu/drm/omapdrm/omap_drv.c 
b/drivers/gpu/drm/omapdrm/omap_drv.c
index 2983c00..672b0d3 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -557,7 +557,6 @@ static int omapdrm_init(struct omap_drm_private 
*priv, struct device *dev)
  {
      const struct soc_device_attribute *soc;
      struct drm_device *ddev;
-    unsigned int i;
      int ret;

      DBG("%s", dev_name(dev));
@@ -604,9 +603,6 @@ static int omapdrm_init(struct omap_drm_private 
*priv, struct device *dev)
          goto err_cleanup_modeset;
      }

-    for (i = 0; i < priv->num_pipes; i++)
-        drm_crtc_vblank_off(priv->pipes[i].crtc);
-
      omap_fbdev_init(ddev);

      drm_kms_helper_poll_init(ddev);
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c 
b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 2da46e3..6d0280c 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -910,8 +910,7 @@ static void rcar_du_crtc_reset(struct drm_crtc *crtc)
      state->crc.source = VSP1_DU_CRC_NONE;
      state->crc.index = 0;

-    crtc->state = &state->state;
-    crtc->state->crtc = crtc;
+    __drm_atomic_helper_crtc_reset(crtc, &state->state);
  }

  static int rcar_du_crtc_enable_vblank(struct drm_crtc *crtc)
@@ -1196,9 +1195,6 @@ int rcar_du_crtc_create(struct rcar_du_group 
*rgrp, unsigned int swindex,

      drm_crtc_helper_add(crtc, &crtc_helper_funcs);

-    /* Start with vertical blanking interrupt reporting disabled. */
-    drm_crtc_vblank_off(crtc);
-
      /* Register the interrupt handler. */
      if (rcar_du_has(rcdu, RCAR_DU_FEATURE_CRTC_IRQ_CLOCK)) {
          /* The IRQ's are associated with the CRTC (sw)index. */
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 617cbe4..75c7068 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1166,7 +1166,6 @@ static void tegra_crtc_reset(struct drm_crtc *crtc)
          tegra_crtc_atomic_destroy_state(crtc, crtc->state);

      __drm_atomic_helper_crtc_reset(crtc, &state->base);
-    drm_crtc_vblank_reset(crtc);
  }

  static struct drm_crtc_state *


[  101.335429] ------------[ cut here ]------------
[  101.336576] WARNING: CPU: 1 PID: 0 at 
drivers/gpu/drm/vkms/vkms_crtc.c:91 vkms_get_vblank_timestamp+0x10a/0x140
[  101.338952] Modules linked in:
[  101.339701] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.121-rc1-syzk #1
[  101.344331] RIP: 0010:vkms_get_vblank_timestamp+0x10a/0x140
[  101.345660] Code: 03 80 3c 02 00 75 4f 4d 2b b5 80 10 00 00 4d 89 34 
24 e8 d9 4e a7 fc b8 01 00 00 00 5b 41 5c 41 5d 41 5e 5d c3 e8 c6 4e a7 
fc <0f> 0b eb e4 e8 3d a0 e6 fc e9 27 ff ff ff e8 33 a0 e6 fc eb 91 4c
[  101.351293] RAX: ffff888107a65d00 RBX: 000000179647991a RCX: 
ffffffff84cde2af
[  101.352976] RDX: 0000000000000100 RSI: ffffffff84cde2fa RDI: 
0000000000000006
[  101.354662] RBP: ffff88810b289ba8 R08: ffff888107a65d00 R09: 
ffffed1021651398
[  101.356361] R10: ffffed1021651398 R11: 0000000000000003 R12: 
ffff88810b289cb0
[  101.358037] R13: ffff88810a89c000 R14: 000000179647991a R15: 
0000000000004e20
[  101.359718] FS:  0000000000000000(0000) GS:ffff88810b280000(0000) 
knlGS:0000000000000000
[  101.361627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  101.362992] CR2: 00007f82b0154000 CR3: 0000000109460000 CR4: 
00000000000006e0
[  101.364684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  101.366369] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  101.368043] Call Trace:
[  101.368652]  <IRQ>
[  101.369159]  ? vkms_crtc_atomic_flush+0x2d0/0x2d0
[  101.370296]  drm_get_last_vbltimestamp+0x106/0x1b0
[  101.371446]  ? drm_crtc_set_max_vblank_count+0x1a0/0x1a0
[  101.372715]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  101.374001]  drm_update_vblank_count+0x17a/0x800
[  101.375107]  ? store_vblank+0x1d0/0x1d0
[  101.376038]  ? __kasan_check_write+0x14/0x20
[  101.377071]  drm_vblank_disable_and_save+0x13a/0x3d0
[  101.378265]  ? vblank_disable_fn+0x101/0x180
[  101.379296]  vblank_disable_fn+0x14b/0x180
[  101.380282]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
[  101.381508]  call_timer_fn+0x50/0x310
[  101.382393]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
[  101.383621]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
[  101.384849]  run_timer_softirq+0x76f/0x13e0
[  101.385857]  ? del_timer_sync+0xb0/0xb0
[  101.386792]  ? irq_work_interrupt+0xf/0x20
[  101.387776]  ? irq_work_interrupt+0xa/0x20
[  101.388761]  __do_softirq+0x18d/0x623
[  101.389647]  irq_exit+0x1fc/0x220
[  101.390454]  smp_apic_timer_interrupt+0xf0/0x380
[  101.391565]  apic_timer_interrupt+0xf/0x20
[  101.392547]  </IRQ>
[  101.393073] RIP: 0010:native_safe_halt+0x12/0x20
[  101.394178] Code: 96 fe ff ff 48 89 df e8 ac c1 fc f3 eb 92 90 90 90 
90 90 90 90 90 90 90 55 48 89 e5 e9 07 00 00 00 0f 00 2d 10 ee 50 00 fb 
f4 <5d> c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 e9 07 00 00
[  101.398541] RSP: 0018:ffff888107aafd48 EFLAGS: 00000246 ORIG_RAX: 
ffffffffffffff13
[  101.400326] RAX: ffffffff8db7b830 RBX: ffff888107a65d00 RCX: 
ffffffff8db7c532
[  101.402004] RDX: 1ffff11020f4cba0 RSI: 0000000000000008 RDI: 
ffff888107a65d00
[  101.403680] RBP: ffff888107aafd48 R08: ffffed1020f4cba1 R09: 
ffffed1020f4cba1
[  101.405361] R10: ffffed1020f4cba0 R11: ffff888107a65d07 R12: 
0000000000000001
[  101.407041] R13: 0000000000000001 R14: 0000000000000000 R15: 
0000000000000000
[  101.408729]  ? __cpuidle_text_start+0x8/0x8
[  101.409735]  ? default_idle_call+0x32/0x70
[  101.410722]  default_idle+0x24/0x2c0
[  101.411589]  arch_cpu_idle+0x15/0x20
[  101.412459]  default_idle_call+0x5f/0x70
[  101.413405]  do_idle+0x30f/0x3d0
[  101.414185]  ? arch_cpu_idle_exit+0x40/0x40
[  101.415188]  ? complete+0x67/0x80
[  101.415992]  cpu_startup_entry+0x1d/0x20
[  101.416937]  start_secondary+0x2ec/0x3d0
[  101.417879]  ? set_cpu_sibling_map+0x2620/0x2620
[  101.418986]  secondary_startup_64+0xb6/0xc0
[  101.420001] ---[ end trace 6143b67a4d795a3a ]---

Thank you,
George
