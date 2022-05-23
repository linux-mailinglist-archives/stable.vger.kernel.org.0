Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7780E5310CB
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 15:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiEWMh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 08:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbiEWMh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 08:37:58 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800C14ECD1
        for <stable@vger.kernel.org>; Mon, 23 May 2022 05:37:55 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NCO9tY017331;
        Mon, 23 May 2022 05:37:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=zQqx4NS4bsXISWYTb2BzU0VS6X1ohgJPJwQthAzKP0M=;
 b=YhhN54BOu/YH1h6sJPcl16uEftRTaGqG/oki4dG1xuG5JZZTQ9XNAvUoL5XJUX4dozzm
 VNQKuqitrwzNBGIqbHZPVczLvXlTU3nkv3picHSk4qD04CAzooPXCq21VD7H/6JHQlCL
 vgvL0QpzWbWIizVi00vHHgVSDRwnyQmSFCOA3WjEJP+Ww2sPcnDnfW5+EkkJ+8so+qz/
 qHm932jbe2EISiTY2gG/aWKOLKEed82IRogOLYSgo1eZ7S2XqdMWfVBU/Aq5H3bGndCq
 L/Md70ugGNUIAMCg/5quHQxpBtl/yKLsZzHy6TJi/pwAtbfChwIG5JvODmuovzuoZIQ2 Yg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g6uc199nn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 05:37:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTOk+guzYp7kEF01I/euJlHPFNcnu1hxuiVS1YE9f6kDZr8AFu06hD5TmSHEan/nWumAzmPFhQrCpUhZHeo8ExlQwd5I2jKzE7atdhLph5X+wL+q602JBS/9qh/8gCohvcjqrVVG10+uKrNYy6+t++nyWa6Ihv344tiEEc6Cay1wfRlTD0Nf/CyMHHJ/BG/hvYhcexBBIEC67OKPIwSpZsuqmdVvcGVZGJyQ0GvUPIKQrPqb1Xyi8EYXIjEWdQTnUDIeIqQFVHF52GyIZZlVhUCMW0MvleNX+3BotKBqyjfR8I9TU5Pi/pLrUpnH3IxVquftkqV5v8+iJCfbey4EaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQqx4NS4bsXISWYTb2BzU0VS6X1ohgJPJwQthAzKP0M=;
 b=FMgBToQCfS+rzSRLueis077KSgAdChKoIWs6IybsK3ivKOpRrlNz6s++ZtIl7tCbTyL+6jZ4Hn2HrX5SatItg1ZBa/0U5KvDC6jyf3LzrlhzPm4pUP1ceq1u8HRyWB127QUZ/w1pGE6nJNOhagVrZXt5tX2MphW0ys3roUs2cvTKe0F7kTyzodp5HOpmzqYFLwANzS7DroNhk0aAn60Z7VDi7sSpQ+SwUj1XYBzdJl55fK6TR+kGSCeOv6vgW89O3S+WG9sNewTc1C9eYwBTqDkud3NUAPwAoYiZkY3RGpvPeak4P9s/R6/iW6qZF0rZgHgEiNjdNaKZZkczFMVC+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2268.namprd11.prod.outlook.com (2603:10b6:4:53::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Mon, 23 May
 2022 12:37:40 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 12:37:40 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 2/2] Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""
Date:   Mon, 23 May 2022 15:37:22 +0300
Message-Id: <20220523123722.439088-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523123722.439088-1-ovidiu.panait@windriver.com>
References: <20220523123722.439088-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8P250CA0004.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:330::9) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f38c4442-8fb6-47bd-4716-08da3cb906a6
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2268:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1101MB22688B88C555E1381416D97CFED49@DM5PR1101MB2268.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ytuDHucZOcFYidbWWJY5Zm23oGeqB07ExXEYEd11ohqIV/i9pmqEx4NJVFUobtC3OEOPe2wUGTjtb4VMzb8azJ8GEQaQTtQUu58jAbKKK4g2w9Nso/B8eAx4udZMBPxRqaxD+xQ9xX+HCTw3bShkbHQE3CsN5QljM+/PmRrDspVMLy5mHEO5itUc0AaQvClBpz4iWInDGum1UehTkAnCwgc/ghRc2/DG6DeKCcbGxrwKWeMKb9YQOryptoSb+ENcagpXD+7TYBIhZtjrBtfqc9yGzu2j2jSv0pMJCwGnPuS9BmSTEZrMZOQ97nknVPSxcpJBiAakeXCB+6cHSLIeedpPGKZ/AuGk5DKx2Xy73fwxOg6CeHt2A4TBfxB+UHPg4QBvBitg76clTXMvuLyai92fx7XncXCXAm6wlsWiANmUutKMC4nRqylGrUUUviJoEGCteb7pSoN5BgC5RJfqHk8KDWgOJBPYPcsF6Jr3acqNUTxqNhQ10STJln1NS6jEEpoCnJ1aoNvbAuogc7t62ry71IrrW0SS3qRC9eo6yRgtB1zmhVkUqoK+3Ta6Lk8/8yzpK3rA9jPU+ITT2axauOjzUq+wuW+4uUhPvV7epqu/7UmvdT6AtHryPCTSOsXpkxCgb4nSCS3ACM6C75LwRaaSVXRrHLlSkD3Zb5HXhYAAKAyDY/OnsIjTLuVM6EblDzLCmOTVnpSrzqfhi1kt84mSNxgESWJWM6St3mKNHP8tc1HgiGMIaKyqhI10xoWKOB9OYRRaI5UmHAdIqIJT0DaqraV8+uKZYODoCo6+SOYzBeXg0brmxq1D5S6w5mhpfPI+uaocaOFYEAvJIyefUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66946007)(8676002)(6512007)(86362001)(66556008)(66476007)(26005)(6506007)(36756003)(38100700002)(38350700002)(966005)(316002)(508600001)(52116002)(6486002)(6916009)(8936002)(54906003)(6666004)(1076003)(186003)(5660300002)(83380400001)(44832011)(2906002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eldqc28vM2xvc3NTYTdFWC9oUUhQeEZpb3llRWJpcE9SRmFtcVdyQ0ZTLy9t?=
 =?utf-8?B?N0dYbDJQa2FzVC9UQU1Kb0R4SFZ1ckNWU2dBa0poaERBeDFzN2pRN0lOdk1z?=
 =?utf-8?B?N3hPVDkzdW0wQzVNKzNiVERLRHJ2TitWRVZmQTZHSHZJWEYrNytQSlNEUTU3?=
 =?utf-8?B?SnR4S0ZxWTF1N3REQkhiZndpUXFaOWZBb2lBcFFrQk02UzQ2cDJORzcvYzFB?=
 =?utf-8?B?SzdObU5tWm94NWpheGdpVHRhL3FPVFZVRFpRS1ZwdkJqNGJOeDlNTU90eUhC?=
 =?utf-8?B?emtJUmJNbTBQbEVNcEhkOTBSZFNtMVQ0d0Jpd3hzQ3ZjRWtWdWRCRWZCSldh?=
 =?utf-8?B?UWlqNjNqWWpzSVNLODN1RWdJN3RzU29zRDVVS2JIV29UZFlKUFpVZHRvdmhv?=
 =?utf-8?B?WXA3ckhvQjBLWWM5SlNsNTRyZmJ6T0tBWmI0NlFJak9LbXVpOWdPR2RiMG95?=
 =?utf-8?B?dWcxR2UxQStIL1FmeHkycVUramdJSWhLZ2VuYXFhNWhacDgvYmczaFhJWCtV?=
 =?utf-8?B?SWJpRFFhL2p6VDZOdytxaFVMWkkvWjQ2OVFSRUwvSm13TGowc3pkalFlekxx?=
 =?utf-8?B?bUQ2cWlwcWZVOGhTNGJoZGlRTzFwSk9tbEVyYmRBRVNTRWs2QWM0bkwzTWw0?=
 =?utf-8?B?NkN6UG56NnBrb1FkaTVBcXFFR3NrZzZva2NCM0c0SkQrQ1VrS2RFM1F0MVFn?=
 =?utf-8?B?ekRxeWRBZFFGSDZkM0MxT1RkKzd3UjRyT2tZZk03NTlzeC94OGpDc3podXhz?=
 =?utf-8?B?aHVlalNhM215RThTSEVyMGF6eER3N0lrL1prcWdnTW40TUphVjdWMGdPMVA5?=
 =?utf-8?B?anREYk1jaDlKaHg4ZVY3TTdPUk8rWDV4YTA5eWo2OGFvWDQyc3pZemt0dkox?=
 =?utf-8?B?MUxtN3hoanJtd0Q4Mmd0dlJCaUxGNkVoQVhBclhrMkVsSmR6REhqdDIydk5P?=
 =?utf-8?B?bndLMkE0dEZDcVVqZDNEYnJ0V2VOekpoWnJmYTFEaWg2NHU2YUlLc1NWS0l2?=
 =?utf-8?B?YW9WbnNJRVJuVVNLbkE0T2FmckFQUFV3MnlKRHFjT0VGTDdRcXYwSUp0M0sz?=
 =?utf-8?B?WCtpOFBFYTkxU2tWQit5WjhwN0FwZHoxRCtuK1JpU1pDWXkvei9QazBlT1Jv?=
 =?utf-8?B?azJhSE1TWjFGTkZkQ1hxRXY5V2g2eEZuV2tOWVFWK1JUZlFwUzlhc1J3eDJl?=
 =?utf-8?B?aW8wUGNyT0hRREtEVmNQbkwzZ2dYaVVSNDAwT2xnUks5OTdxLzVON1lqMXNO?=
 =?utf-8?B?R0JQNWU0ajk5QWdGK1FIdUpZY1NnOWxZT1hpQzdIM2FBY1RjMmMySWQxOTZT?=
 =?utf-8?B?LzVIYXJldFdNb0JVelpnMzRQWFUyWnhzekxjVnd2Z0Fnd0tjNEhwY21RTHNP?=
 =?utf-8?B?aXNlazlMS1JEZ2ZBM0EvaFU2Unh2dEducTNNUFpjOHlJVUZzbE81bmFkMEV2?=
 =?utf-8?B?VkY2V09oK3crNzZvbEgweHpzTHhWTFBWajlmN3FsVkcrTHZCM3lhUzExQVpJ?=
 =?utf-8?B?ZDEvZGhsQnB5SWhqRGJ0azhZREM0MWdlN0ZKekdZOVBNbG5MWSt2VHFUYm5T?=
 =?utf-8?B?S1dYUTF3UG54cE1TN2ZDT3F3QTF5c25Vc0IvUmcvVFhuaDkvdUx1d0srb3FU?=
 =?utf-8?B?K1htUS9aTnlLRi9NSmtpbk16S0E5M3FRUG9yNmx2MzdTaUhIYVVLSXBMS0h0?=
 =?utf-8?B?YkhJVWJUcXhtdnBNdkNmTnI4U2R0b3BxVUhuZ3Y5elpvSmIvUklTdnFoTHp3?=
 =?utf-8?B?cG1hSVFqQkdnWnNhUWFnNDhEbHR3UGsrSzFXOEIramgzR2l0VjU1KzU2WFJ6?=
 =?utf-8?B?YUFEUVVtZnBPVm90SmpiR1BkMWtmT0NPU2JmZXNFS1BWaDMvR0gvek5yQlRM?=
 =?utf-8?B?Qmw1TGdCZ3NRUkRLVU5MVGNRMnlBYWxJSWNnSDYwR1hPVFJXRE5FUFRaR0Fo?=
 =?utf-8?B?TkI1djM2SFY3UjZvS3RIdnJoNFFoUXV0RExuY2poZUFIL282NW9Ld3paM1ND?=
 =?utf-8?B?MFJubUZkb2VXNVRXM3FjRmxiUnlnRHpaRDg0TTFwUVkvVUpuMUFlQ2gxQkl3?=
 =?utf-8?B?Z1IwWmIvWlJXTCtNazVSRTV6cjFBWUNYTWZqVUpRZmZPRWVxdWZuVFNZL2RN?=
 =?utf-8?B?MCtWUnBOVG9YcWVCdmtPc05lU3NQbDVuMTcvb0tuci90dEpKeUNvSURCMFlw?=
 =?utf-8?B?cTZGTlg3eG1CS08xWDRNR3Q1WHlwWGJKbnBuS1o1Q3dhd21rVnJ1ZE9yalZ3?=
 =?utf-8?B?b1FBYUFWem9uSTBEcWNyY3dycHY2ZmYvSDR4WmdYeWlGemdTZkdRNjMrcmhR?=
 =?utf-8?B?b0FPOCtmUmRscTcydk11T1dXVWVzeEJlcmwzY3phY0kyVWhWa1RabjEyUU1o?=
 =?utf-8?Q?TZiW5YBYoQaIBElY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f38c4442-8fb6-47bd-4716-08da3cb906a6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 12:37:40.5616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcFa0VKkMt5Rva+XN1XG53Z8ADZ5ve71vsBIXlgaPaxOpuzTpEPNGlv7kki7cRcAfOqKDQ1iF/H6m0bQF36rQPXySyw+r4WXWVZ7HFwdEIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2268
X-Proofpoint-GUID: XGAsrAOVOYmUDAYR790uHap5bicdGSnr
X-Proofpoint-ORIG-GUID: XGAsrAOVOYmUDAYR790uHap5bicdGSnr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230070
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 901c7280ca0d5e2b4a8929fbe0bfb007ac2a6544 upstream.

Halil Pasic points out [1] that the full revert of that commit (revert
in bddac7c1e02b), and that a partial revert that only reverts the
problematic case, but still keeps some of the cleanups is probably
better.  ￼

And that partial revert [2] had already been verified by Oleksandr
Natalenko to also fix the issue, I had just missed that in the long
discussion.

So let's reinstate the cleanups from commit aa6f8dcbab47 ("swiotlb:
rework "fix info leak with DMA_FROM_DEVICE""), and effectively only
revert the part that caused problems.

Link: https://lore.kernel.org/all/20220328013731.017ae3e3.pasic@linux.ibm.com/ [1]
Link: https://lore.kernel.org/all/20220324055732.GB12078@lst.de/ [2]
Link: https://lore.kernel.org/all/4386660.LvFx2qVVIh@natalenko.name/ [3]
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[OP: backport to 4.19: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 Documentation/DMA-attributes.txt | 10 ----------
 include/linux/dma-mapping.h      |  8 --------
 kernel/dma/swiotlb.c             | 13 ++++++++-----
 3 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 7193505a98ca..8f8d97f65d73 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -156,13 +156,3 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
-
-DMA_ATTR_PRIVILEGED
--------------------
-
-Some advanced peripherals such as remote processors and GPUs perform
-accesses to DMA buffers in both privileged "supervisor" and unprivileged
-"user" modes.  This attribute is used to indicate to the DMA-mapping
-subsystem that the buffer is fully accessible at the elevated privilege
-level (and ideally inaccessible or at least read-only at the
-lesser-privileged levels).
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index a0ccba8ca1db..669cde2fa872 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -70,14 +70,6 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
-/*
- * This is a hint to the DMA-mapping subsystem that the device is expected
- * to overwrite the entire mapped size, thus the caller does not require any
- * of the previous buffer contents to be preserved. This allows
- * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
- */
-#define DMA_ATTR_OVERWRITE		(1UL << 10)
-
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 33bed537a64b..361ecfcecacb 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -587,11 +587,14 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	 */
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
-	    dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
-
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
-- 
2.36.1

