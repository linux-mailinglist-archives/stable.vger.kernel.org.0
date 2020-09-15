Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1A926AFCB
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 23:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgIOVm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 17:42:57 -0400
Received: from mail-bn8nam12on2106.outbound.protection.outlook.com ([40.107.237.106]:50336
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728117AbgIOVbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 17:31:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDOQv5hXs1fj0ZSsq3dGSiTeptG7WSyEepFq1DIEB1FRBGEzJA8xaWvyqrPkTSMB5WwqHgrIL4oz36HOtnHQwzbUMbvV2kQTn5+bpSjZBTyU/sTDY8deLggdQx5Jw0KCJ9iZY4LjirXEUUDIhqlT7qt7JQJ6O3b1uyy5xxBg26CzWxKGu/UCfaHp2N0CbdmW1RjSQ10+qxYIW2FDJSrVMXYGhUdmLvmV79JIlkFW5XkAFfwSvPfbRyHamznpjDKHldU7oEPb9E4QIbcGtfQmpYDcD7gLwknrGmx2XFQubmJVqGfrbnoh72MO4HUk2bQeVeo93DanTJL7t82CiaZcpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3C4zmL8mafDJiYrDkD1G6FvRM0LyTtpHN3tNOpu0JM=;
 b=ZE/8AnmkO6H/elwIrAfbc8m9u+hd55NIPCfENIymxW+2gKf858Kp3/Am3OognNgwFLMn26aavLk2Idn89Y6Ab+kg1uPWO71VAF+Cwp91wYACh5ZOTnPi/PTsouF9v6yayTKw6fb4VH+irLyJwdEszhGsjClfutHieO5cu8JCtV8I74q+MMsBr7gX7U0IuFIej83wVXokWP2Wj+z6rYGEtgjJLxJxIat1NBCW1Cn5shE6w2ixlL+SmOCxrhuzsjhx1aLrWy3gQuBOpOFqIpVqY23nR4qPAC41EOB8UhsaeTg6UvIVtEQxnIfkuVmgyyv+DuFrgboXxn4BQ2S1va9xvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3C4zmL8mafDJiYrDkD1G6FvRM0LyTtpHN3tNOpu0JM=;
 b=p4TBQkkxNHjweSgY959UPi9wTEZarCPByt7Sxg+PGVLbnKyyfvmj3fRE588P0hUn3ef4G3Oh0wyYcSRv2YvfM8kIs7OWwlTM9XgzHUu0eZIvu/VXBc8lRZb5xKBqFbPFplkaNeSjqkLem9j2UJnT9V4K1aR6v36BMecIGctieF0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=os.amperecomputing.com;
Received: from DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17) by
 DM6PR01MB5516.prod.exchangelabs.com (2603:10b6:5:153::22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Tue, 15 Sep 2020 21:31:03 +0000
Received: from DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b]) by DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 21:31:03 +0000
From:   "John L. Villalovos" <jlvillal@os.amperecomputing.com>
To:     stable@vger.kernel.org
Cc:     "John L. Villalovos" <jlvillal@os.amperecomputing.com>
Subject: [PATCH 4.19 0/5] Add support needed for Renesas USB 3.0 controller
Date:   Tue, 15 Sep 2020 14:30:34 -0700
Message-Id: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY4PR14CA0040.namprd14.prod.outlook.com
 (2603:10b6:903:101::26) To DM6PR01MB5802.prod.exchangelabs.com
 (2603:10b6:5:203::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (4.28.12.214) by CY4PR14CA0040.namprd14.prod.outlook.com (2603:10b6:903:101::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 21:31:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [4.28.12.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 518234c6-bac2-42ba-57cc-08d859bea58e
X-MS-TrafficTypeDiagnostic: DM6PR01MB5516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR01MB55165A0916C132AA26C95935ED200@DM6PR01MB5516.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQRDZT7dsZdPLHpiOqrgmienrcf5SRzcNkGdHxJ/yyFMWfKq7BTnFvNvhB2EFTf04y7tzMfAST7447sKcGSljYPmuYOzfVUudzoyO1GLeg+dhD5pw6T1iw5WaUF2UmsukXoLiMJUbjKoUel3Khpoh1o9q8V7jMz0eOZGPW7OdwSicHt3jfdzU0gDTQ6tPjZr1ok8HapZ0eHg6HWGND8L8WOsMtlyHa43StP07SmVFpONSrGNQvMwKsdOnTM7dayZIoMuxeGu3thDjpvrr4u0cioXRRJXgjbOcfKIfXJsRkWka4D+fTYlK0ukV55mQop6RSbDITtVspp2gCwP8IrTzmzKPCt1UiympLqYyIJlWu+1RlyB2QNk1Lo3tu62EskKLbv3FevzE5rCNqxAYEueqj52J92aggfOdNvZQWss24CBs9ZNYDlp3G+zz760q5kR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB5802.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39850400004)(6512007)(8936002)(316002)(66946007)(16526019)(8676002)(4326008)(2616005)(6486002)(956004)(26005)(186003)(1076003)(6666004)(6506007)(4744005)(107886003)(478600001)(5660300002)(86362001)(2906002)(66476007)(69590400008)(66556008)(52116002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: FwoZt4MVIZIExPRfZv388Dl84OSVPw0QXjZ2MDo59XMryTTtjUa5iL30QZ8OWkD30V5Shb1tTmbkG/BpyVLl7MxluWwkcLeutzH9i3vIlkT1ZMcl9pCMJ3EvTwPUmxaPq5p9ripXoXPExQ+pN7fZQWRn5v7w5Rez3ErF60FdKdW5g9ztrpK314FXUBi3Y60iQ29F2UiQj/RafFWMAXTec+H5ULOo3bKcgJTYiyb6zEOFA72U1fvCwvcq6wetP5bgimOq6gMVvQfpSTB5W+YhU3UZI/MlJ86AalC9UKjd78YA5pf/2w7M2xaHjJB8lA8yNC8rkXkrrwE49TCty8mPV5Dhb3UMyov6eCGOP1oip9pnIbx+0tzyGAwAHSq530DUBGkukz9lb6tNo78AGbdZ2foGf1IPdvGltlQVscqId3+qRn1hq15wp4D9PiIx4NJeA/SvHDQwn7i11tGwr5dtOSQ2Ys+Fv8djRDn4E2McduCKsODZ3unyL31N1+BGjshQcEdphqJD8S/nfkt2JzqwkTgt4cvXOfLWLXwcyDpeCRp40DAAlAtebV16u7G9UCzF2W6b0H/dGs81BWGEXfgMVlizkLTgM5iYjD+5QwYkDHzO9GtnTidK7y/4gYBqJpgdRHRXre+ZuiSwb8by+agc9Q==
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 518234c6-bac2-42ba-57cc-08d859bea58e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB5802.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:31:03.1081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pQn/adyU99nl5jEHPE32cyLVldnqEVMTFr7L4TYmvjGxHG0BgsaJ2xJ+ffo0SbiQoYswAXH5pV74//9pR/3jat2IKDebdT7oqSHdCC9IDH+qcoBv/mMdi1OIMNqth+B3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5516
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add support needed for the Renesas USB 3.0 controller
(PD720201/PD720202).  Without these patches a system with this USB
controller will crash during boot.

This patch series backports the following upstream patches:

01: da83a722959a82733c3ca60030cc364ca2318c5a
lib/genalloc: add gen_pool_dma_zalloc() for zeroed DMA allocations

02: b0310c2f09bbe8aebefb97ed67949a3a7092aca6
USB: use genalloc for USB HCs with local memory

03: 2d7a3dc3e24f43504b1f25eae8195e600f4cce8b
USB: drop HCD_LOCAL_MEM flag

04: dd3ecf17ba70a70d2c9ef9ba725281b84f8eef12
usb: don't create dma pools for HCDs with a localmem_pool

05: edfbcb321faf07ca970e4191abe061deeb7d3788
usb: add a hcd_uses_dma helper

Signed-off-by: John L. Villalovos <jlvillal@os.amperecomputing.com>
