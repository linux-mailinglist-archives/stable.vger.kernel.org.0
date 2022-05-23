Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ED9531273
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbiEWPsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbiEWPsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:48:22 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9008B202
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:48:20 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NDtLDs007426;
        Mon, 23 May 2022 08:48:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=w5lW3mV+pT6ahGjfoBX7zbqcRWrosjbQQveV4mUn21M=;
 b=qw/8HHyXJA8Btqy5igrQNvV30L2ywjMm2f22RpjBtfcycQihNklWGhfJ4/o+/AELVoOo
 VsZtmUJwj0p+jESg5KHpw6+bIkPuR4dFQxEPQ53g7FArDglbDyUNAmIRzEtEF5nrTlR1
 BMrhbKl4EBVWgsIatNQoKohrry9X4WXXVLzUQCLLhixmdg4u884Bj9acFGNKrdyQ+TyG
 QzNGwoTN3vx6ee26gjLg3LMbzV6DcB/T4oa/ST0mUT4IpqiYCrn6m+oRh7ox2tvgknR/
 /Z+Xp0EYarPxZYrfET/2vQrAVrXb3hmXMSns7m/odyOqcYRTG3G3e+hD99XMF1Pi9onF NA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g6uc19e2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 08:48:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNsYaHtm2cKIX0GYoeP0QSKsTsUS4/S2v9umlrEXkAziSr7zYaiFMBQ4QO+4xfHgvQsZgzThFtsKgv8/GBLXNz+7VuxVtgRj24mrupwJo4nbiIVKzDFfoC1+vm+4fPgZKM3FyZmFT2RyZHAxXr+foC7AKnyYAhbNVzXgb9855WrtyBUWy1pwyWWuMJFLBtCT0LLY+GK3n+BWxtRznQGyMlZV+qpdRuXGZNSx8TcCB7X4wwKDTGT6f/BMAH+/gcTpc1EatQjz9N3QyK8pBsBsQD0VIOhs0dWUCA4NFL72vez+ElGuxZdilTHaF7viu9kPoRMWtDnN5ZT9S49D4tRyhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5lW3mV+pT6ahGjfoBX7zbqcRWrosjbQQveV4mUn21M=;
 b=BY/PJ+ai/mDzdG/m8hT9pAs1ZG9yBr4eepJqxeU9lIJxaYYLFPe8iIJNyL6Y/c7UD9mk47vnopuFXcyJQhU1webVWBrt1ohfBh76XSYPDY1cX+sqdnPDtXsWkmPkAAJN9xf6ktpjCKUCe7pDYo2VkRg5+UK3iUqo/UFg6SF0rCQn8B1hmXMt4Cksb4tg9Pzk8Bk+wsp8b3c8rdB5yXbS0Xn1klPqevAPF22WYKibb1PqB3uaD7s7Uy95MY1xqH7ROKijlwprdKe3ui2D4UwCVjGOGCJxf2OzqrBJ/Fg2RiaqLA0aHWTBiXQgxtKBrKTDlLN+7jf6O79hsCX0NRZHqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4677.namprd11.prod.outlook.com (2603:10b6:208:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Mon, 23 May
 2022 15:48:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 15:48:05 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 2/2] Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""
Date:   Mon, 23 May 2022 18:46:24 +0300
Message-Id: <20220523154624.1141489-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523154624.1141489-1-ovidiu.panait@windriver.com>
References: <20220523154624.1141489-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0ab5a50-7936-43bb-d14b-08da3cd3a09d
X-MS-TrafficTypeDiagnostic: MN2PR11MB4677:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB467795E417A6A23C83D06871FED49@MN2PR11MB4677.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49cMsf1c3ljh4Fz45VrYU5qw0cBWOJICpHMhfYKdmmqyZXMTqs/qritUzela/kGmZjbva7nSxWl0g4HDLXkOgUv6C91xHg9GFQOgCXdXowRZ5FldhyB90A0q8eZ6ES/9NwOB9FE5djYZGia49J9/R06nKXdcnuoiMvvg9LqZ4P2NFbR3x807uWjYaO2d0uQ6qoNrqGIQSKgmkG8IXkLXjZmz+EUndV4Ho3nNhDPmshIsf6hqRr6fIl4823+WK9XTvLYIGe5D4EWqljqNeF8uDt+GbFTZ2kzHnydEGvxUHBPEz8LeXX4JhLcVSX9sgThE478B3tloPb83bArpO2S+4GLW/jV++midbvKO8vSpN25rHD66V4sVqsdr5PrhPd6sa3vCifaPQ+Qgm7nsFXJUNP0E9gsL5H5U0ojG5ukkInsQDXssRCb3MRTzcZSqUFZLVW55trCkw+PNxBLzYPF8YiudYAHpUY5K3W3hy+LFSGlV7NX1e3DsgpctX50oUAUBPsXPAD3owpcjPf3R+vhariKCAYHhme58zuzohHqY7KkoONec39LQJRjWfT2v4HMT5KOw8TJRhRZEBlrKEKI3Kx2hUfeSZqeQp8BNTmEaq4JBBhatHost1Ih9Ciu4in2ZRE44tq/3sxy+Rmf+sn+xcBPndxip//U7HbSAHIgR/u86F20hzSbPnpLkXqdyf3KI0SLE6SbzV7MdhkmF6DLbah7vlrTf4jN9CSw5g/dsnht6yGlDoniNu2B/EgESiZ7JrpVke0scImAOuwnhh3IRbYqQqyPPy7Dnt4ex6zMez8nxkGgztD5Eq0f2iOJCBWHFYOBAC3qPsMjVomPn4lBFGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(316002)(6512007)(4326008)(8676002)(38350700002)(38100700002)(6916009)(186003)(66946007)(66476007)(66556008)(6506007)(1076003)(52116002)(54906003)(44832011)(8936002)(83380400001)(6666004)(2906002)(86362001)(508600001)(26005)(5660300002)(6486002)(107886003)(2616005)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWFibjZEWithNjEvV2V0NE1OVHFUTG9TRXNUWW51Q0c3U001QkdHbUl3aHhR?=
 =?utf-8?B?Q3VxeXRLVzdUanpvRmtLWkJmcmtvTmQwWlZCb2haUHc1aWo4cTRVblQ5cGQ3?=
 =?utf-8?B?S0NXUnBROTF5Ni9sTUtaeDUyZEdXQWJUYWdqdEIvdHpldUZjSUo3S0UzbXNn?=
 =?utf-8?B?eTBTT0FYb0VlUG1xTE0ybS9xa1gxalhFTmp0MU00TmNmbC9JaTcxK0NqNVgw?=
 =?utf-8?B?WkZ5bTZncWt5dHNCaFNKd1RIbFUzSjFRa1RZK096d0hGdDhIdWNzMVJZb1lE?=
 =?utf-8?B?MzhSd0ZIdDc4UHQ2NWNNUWZPTnhoMDA1UVlLUTJMYTgvazd5SW8wY1pNMjJv?=
 =?utf-8?B?bE94SHhPV3lZc1Y0TS9ZTWpzdkpqQ2RWeVYxUGNOK3NaM2ZTQVBWZ0Y0Tkll?=
 =?utf-8?B?WnpBZlNKdTBwOGVURktEeTBhbmppSko4Wk91dDJGR0t2NEF0cUFIMXptNjB6?=
 =?utf-8?B?Snh4ZlNhemdXYU1aQlN3YnNuMHI1emZxQXlNMmF0NGtrSkkweFJnaS9qRjRH?=
 =?utf-8?B?MFdpRUY4MnkxTWl2QVJBT0FBRU9VWXNPVWVMRVpSV3VWYU9FaEZCdkI2TXM5?=
 =?utf-8?B?NE91bUh2TXRLK1ppRHYzRXJiS3UzNlY1eThWcUF4eWZad1g2SDhMTlM4S2c2?=
 =?utf-8?B?NkdITW9GZzBya0tYQ3hXMEd6cFgreDBtQ2xBUll1NnFkQ2ZTS3c3Y245aGFY?=
 =?utf-8?B?cUs2WHVhMVBsOHpuZ0c3ejdQc29vMWdUZ1VJcXU0Q05GSUw2eHI5STk2dzY2?=
 =?utf-8?B?Nk9kQzF3VUI3OFNqeVJjeVJEWkRBV25oVUxUSllnMStxRUp1NXZiTFpvRWc5?=
 =?utf-8?B?TFhKUUcyTFN0VWkweHRTRlRXKzdxVUM3TVpzdDBOMFBXSTRqVHBEU1NPNUZF?=
 =?utf-8?B?Q2xLekZuUDRNOHNsSWd5WTlnekVHM0s2bHlFZFgxUzZESk9Hd0xZVk9pZjY1?=
 =?utf-8?B?N3QxMHJWa2pEK2ROVlRHL2VpNnlBWjJUdENLY3Z6MmcwdDhGVzFPSDVMdVN4?=
 =?utf-8?B?OXVuRU85L3RROFdyczZaMis5Sjc1N2xXUlBJS2Y0dXFwOUNtV21uZkNDYyt3?=
 =?utf-8?B?bDhPcEF2WjJWMHNKUkd0bnRtMHhHNTd1aU5FRTI0UDV1QUttSzRwZ1FkbEdE?=
 =?utf-8?B?OEJkL2IxcW1RcTVYb3Z5bEV0cHo5SDJBejRsaFpXaEdXeFZ1d2c0TlJlVThj?=
 =?utf-8?B?K0ZJbFRHUUtnYlF5ZStESWMyZGtUeWFrSitGTk5wSGh0OVhLamV2Z3ZUKzho?=
 =?utf-8?B?Y2paYUh1aUQvdzBmOEdrQlZUcUorYkgrK2FJblhJV1o3MjVFUWRZZFMrN25z?=
 =?utf-8?B?ZTZVUzNxWFprRlVEd1VhT2pwTzQzWmxYR2czaHh4TlQ2RGZhMi9TejNXVUVj?=
 =?utf-8?B?QVVSREZBWUVSVXhkSzFqNEh5RmUyNXg5QlVzZUVlU2FUWkZ1VUhGWTgvRXhO?=
 =?utf-8?B?N1FRYzUvdUc5L1BUWVpwVnl0OFF4Nm1CelF4ckpSanpJdlptZXpTbTRKWkh2?=
 =?utf-8?B?bG5LVXgrSSs1S043WWxQSjVKUXJXa2pmcXVBTU5wbzNLaVRvT1JMeHl6aHkz?=
 =?utf-8?B?a282SnBCdFhUYUkxWXhwcEZmc09TWFBwT0xoK2x0NFhYNzRRa29NTDJ3RHc2?=
 =?utf-8?B?ZkQ4bzAvemZ1OWtuTHlQeVNBTWdtQWs5eUJPNEM4ZnYrMTRNSjB1Ump6VkdW?=
 =?utf-8?B?OUc1U1FsZm5tOTljdnJiWjhHRVNNd3FuQ1lTdTN4dkdrc1lPU3Zxd3NESWVN?=
 =?utf-8?B?Qnpad3NCdUt1MlNrNk0wZ3h5ZEtoakx6VTlqbzdJWllUNnlhalBkTjhadExs?=
 =?utf-8?B?a1FxbzkzSXhYQm1jL1l1YnZwS1FaWUpTdWg2ZmYyOFBpVC9WWDFSLzJIdnpp?=
 =?utf-8?B?NjROcGNpbnpDY3c5b2NSOGpCSFVPTWIzQ0I4YW9YeWR5MHo3MmJoTlJicUVn?=
 =?utf-8?B?bUs0UTZNMWhvWXd2cVkvSDFrVlBwbXNlV1d1d0xsdnV2bjJ2OFJsdDM1ZG13?=
 =?utf-8?B?Ri8zWms5LzRpZytFS205NklmZ3BZc29MUWVYTlliS3c5ZHZCdGNIT3VzQ284?=
 =?utf-8?B?OXJwZkgwNU9ocWwyc2JjTGwxZUU2TWptRWJMcFBoVTFHeS9hbnRmOGF0VUhD?=
 =?utf-8?B?TUNYNGJzemc2VTRsN0dBTEhsT3Z3Qnd6S0tXQllKL2lOK3NnLzRsa1RXTi8v?=
 =?utf-8?B?Z1hObjgyd00xTXJGRDN4U21iM0xxWUQ3aElyUmMxWmVKa3pUTXgwYjJ2THVG?=
 =?utf-8?B?a3QrOWpjT1lENFZFMEc2aS9URlNXdGlHTU1UcUFWOHRpcWdkUDZEY2FlZ2lL?=
 =?utf-8?B?OWowMWIvV3JMV3YrSUprSlY1TEZyTHBmZkExQ0RDWFk0d0ZaMzVia3hYaUhm?=
 =?utf-8?Q?PYTq7JS7IwshHxm4=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0ab5a50-7936-43bb-d14b-08da3cd3a09d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 15:48:05.8215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7o57CufypsFj1iqaA6SEXzBZSPQXO6reKsLVRikrT+GwmwNzIHII+XFaWh2mYI1Wou/xQ4urUMCM2ITaKynsMHL5x7ifGWzw4btF3C3VjUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4677
X-Proofpoint-GUID: ekZIr0QE0VPN5zj393ZaZ8CkvqDu0huA
X-Proofpoint-ORIG-GUID: ekZIr0QE0VPN5zj393ZaZ8CkvqDu0huA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230089
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
[OP: backport to 4.14: apply swiotlb_tbl_map_single() changes in lib/swiotlb.c]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 Documentation/DMA-attributes.txt | 10 ----------
 include/linux/dma-mapping.h      |  8 --------
 lib/swiotlb.c                    | 13 ++++++++-----
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
index 93fa253f2a37..9aee5f345e29 100644
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
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5796aa1e5cbd..bdc2b89870e3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -600,11 +600,14 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
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
 EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);
-- 
2.36.1

