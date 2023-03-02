Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEAA6A794C
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjCBCGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCBCGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:06:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6B64FABC
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:06:03 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321Me2Or011846;
        Thu, 2 Mar 2023 02:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=Xek3nxDci8Rv94vGg5pnCEDwYxiy2nc2b3rTeDivDyM=;
 b=1Us2zoRHAmAh66fnIX6TvRQNLyYoc9+DoseaM63Eew/XMaKlL85ioAcMEdNvJ0+miPN5
 yhJTv4k3om9m1J4bOwrBQ+CSGdHLQt0qFoeEmI/2aMqtF6fD3Na+nd+0SjWoSQIPupZ/
 3p/FXw3BiyTLTEaPPuwlNV5hC96yEwPdR5HYk2nfZo9oBLptAp1mpTy36objJbv/V5J1
 voJ5j+0/Sl/X1dkgmW2gCKdYsTXSXIZ2MqxRB37aVz8jeaMjaaI8tvu86aIdRZ6dUj1s
 DhafCr0Og3YPKI1CudbuPKNaMpx9ivxWXW+WZXgH6SkeBkWY+tg2BSA9zR1KLhz10LzH qw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb7wth74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3220e8wV015944;
        Thu, 2 Mar 2023 02:05:22 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9pej6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Erg2Bh9Us8QpTPdQWtc/InKQ7mxvUlM0KgXJGuwz20xUhLjeR3tICyrtjk22/iS/zZN7lNdxc7zpuQ4ebcxPeKRf0R5NUlaz3g07tJ/AQyxAgQSzu/aKTlbzKCmwYY3Y1v/9lUTFnCf4kTGT/0uCJLHkDBnO9XbTEvLjEPUH/7Op60dY2kae5CUwZjURG43G/NmB0ADd/Gxl3EjWtRN4kpmYf7xvNYpmE+5XjJwJ2XZoEfQm3toNtXiL6LTARkIykON4KbxgEgQYj8hzn3PgVksRqom4X0U2Ei48NJwaZzAkL+KlyxQ8AADv1eYhfhD6Mtz2pz4ouriDDQp/WQVklQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xek3nxDci8Rv94vGg5pnCEDwYxiy2nc2b3rTeDivDyM=;
 b=Y6gnWDm8AMmsdZDX+Ek9SPLjYiHRhoITLwsXEMhSnEcsGG/uLf0xyOZW6XfA4mdePbg4w1T4ZS42W8mBu+evtJdEHRZc3GIOGWy0DNbyl1gE72GpxDorPJAVif5CCq4B8By73H1AfgEkz/F+ICupGjiADnaU05zFJMwUaHbxNKejT0+OwYgQg+YwOj2KwzGSjBIEEIuHciBYSEGisYE71a42SJBp5V9i/n0RihB3wfkKdXElcx9czZbRYR3vn4bGTHtBuQAoFPTow1ra5jrqkVmwF9ufTKtnw9qvpm6iU9GTGEzQ0nAffSVn2ySqAAVcEivyPjBifIw0LaDeqS3LTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xek3nxDci8Rv94vGg5pnCEDwYxiy2nc2b3rTeDivDyM=;
 b=y7RjE1J/j/z7IksYlebw3zLd9F2O+sgFMdj+eyp354xgVcGr57mSWATj0dBiplk4YgCSPoZOhcZRyi+TQ05pGj1Z8SeVYfvK17iLSLHvxPB623cm98YQR7M9uZtXpI3eKD1Euag9Zj8vjdX07zdO+uNyiS7Fn4s6bJKdYiP3CFs=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:05:20 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:05:20 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Ard Biesheuvel <ardb@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 v3 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Date:   Wed,  1 Mar 2023 19:04:51 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::15) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: ed3d6ced-d4c6-4bf9-84ce-08db1ac29399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hO7gvlPkJjZjH76qzwN2FMYkTzLeqhpgxaPvZYUI9gLj/ArpNegLPZq3l0G0qnFa7o3jIQNgGAOpGGCGwGkIpwEmufWRHaWhnGt38j7Btua9uL5DrCefniW+YwrCHMKWD+tClqkM3pul42nIUM2lrUaKwXUz1iB3hxGQnGUzY6ezFCqk76t+RxY9s2ROYu/fwUvGS+h0ahZ+HvcO5WSXGozzRRc/iki2UHc4M3j10SIfHMgSCSrvNSqqPJbIhcmr2ZHRwIbfAxM9syBVxuuisK/tz2ZMN8cqQBvVckQ2eFVAjOO7/I4z9lQRukEl08HvewVg4yL6bfWyV1cXD6pMxRaQnGjUHL5qV9TZcpsOvUCj5bi7wvfrAHbM9/aUgHlKAL6III7ZAH3KdBCbPz/BSD4LQir3DD2N1DYenSQCbnJzGQa45P9qBNZCiXabPif9dZ/d3Q0hltEIBc01uNLVKg+aTsuX+Hj3413ujhAkXcDn18nDkvVwuWlXer8dJNIsG+SysbQMOZ9lwWIMp532vj+F4czTKtZrfkezIoSiSOfkOJcva/lgVI2n/i1cQ899s0QeAEYTirXOnSg8e0fCmqnpweebAYhlFjjCSFVwUokc2FaKh2pY1NNtjRr31k89/NjbGb5y8FQXarXNpVfx8wBtt8Silb4BuiG0/cpRmOg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(8676002)(8936002)(7416002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVlWbkpaWlpnckNhYjg3R3U5RkFQZmdvcGFEN01WaTFKQ0g3dytqNFdRVTVa?=
 =?utf-8?B?d0dwUVZpcHluZG1wa1dJRE4yR01BUkR6bmxoTlVEZkIyQVphQW03dWVSOVdT?=
 =?utf-8?B?VHBQWmpobWlZcFZKa1BtR3ZBTTFVOCtCc3MvSHgvRkV6YnBMSUEzNm5kNUVD?=
 =?utf-8?B?MTJsMk1vZ1FyaG9QN2JwZGJQcktEbS9VNkhVWHovcjJ1Y0wvcm9OSDZWbW5n?=
 =?utf-8?B?UFFmbUNuQkp0MUR4K3dRK1JzeTdqdEdZN2gvTmZ0aEZicUptTHNmcG80Y0Zi?=
 =?utf-8?B?bDZ0RDBmTWhaRUpVUGx4V0huYTBheVZSN0xzYjBIaTBENHhacEh6c3hpdG1I?=
 =?utf-8?B?TURZM1hVZEV6YnBoRHNSZnpxbDA3Z1VxZkIvUnAyckNWVFBiaUREUVRJMmRI?=
 =?utf-8?B?ZzZNT29zTTlhL1dzU3c4QmU3OUM0TVNlczBKZ2orQWRjYXJScW02bjFtckFy?=
 =?utf-8?B?eDRycVRsbkkrK0ZNZmVzZjJFaTZNbk9YTXBUclZqaklTWHh5a2JVRE9Da0FH?=
 =?utf-8?B?OEVUTWRIM3dLbnNSR1ZNaEt0NmhOZy8wZG5NV0FhZGd6Nyt5cGRSOGRmSmdW?=
 =?utf-8?B?RVM2RkFXc2VrN0RkeHJRQzVJTVMwbUZYTFQ3ZSszN2hWaVZOS0FKRzljVWFH?=
 =?utf-8?B?M1JUd3FaditsMHBKcFZKY0svOThxTzVCV1JXanJXN0tBVjJMVzNiQzlqSVRr?=
 =?utf-8?B?NlIwWUxnWForWHpuQnp6ZU5RcjMzQ2FwdHhLNnNtYTFEWkVvaFFqQ1BYeUdn?=
 =?utf-8?B?TCttY3RkdXlYUEVMT2hwZ1FzekVtak55MEwxZlZhR2NGWThyOTA2VzFDdm9B?=
 =?utf-8?B?Sk83bFdvV1hIeFNTcTI5OEpkYzc2WnNPRm5rZlU2RitxQU4vOTh0OEh6TXN0?=
 =?utf-8?B?Zy85Y21jUmNMdm9FeGlMZm4xckw0TE9JanRzMEhtMVBtd0RYUEdlR0hsSkhw?=
 =?utf-8?B?S2dld0xvL1lqcWpCSnlpY0FqR2Mxa3p0RG1lV2V2SWl0ZGJPUVhwcExjSWty?=
 =?utf-8?B?Q3hOcGJaOHJRTW9pRnpQQlFCc3d5TER6eTRweE9KRDFnMkdVMG1OTmVYQ2FK?=
 =?utf-8?B?a04zYlAxdUtXdFZFMzFrS3RIcHliSEcyWVhPak5rYXk2cCt0eDVTdUhjQkZM?=
 =?utf-8?B?eER2b1luQjZsTjVaMzg4TWR2RkptZFM5elNDNUs5K2NBajVnRUliYnBEZzZs?=
 =?utf-8?B?Tk9lNEtwNmZmYlcwYjhzSXRLVE1UdC9iK251Tjl6MHJvRkpFZU13dEZGTlU5?=
 =?utf-8?B?b2k2Szg3MzgvU0VXVURsUytqaU00dVhtRjhjR2YvZ2FBcTUyb1FCWWx0eGZ6?=
 =?utf-8?B?UkZ6QjI1ZEVpdGZVWFdsdklpbXQ0bnB6OTErLzJRTlJCSk1xZDZ3eHhCOHNt?=
 =?utf-8?B?WG1ObnZaZ0xNelBJQWdVOFpYQldEUThqd2hwM0QwRFZjWG1BbFhnZUgyUjNO?=
 =?utf-8?B?S3d5VjlyLzdsb20xZStQMkZ5REJSOU52S0FYUklRczhwQ3AvNnNxVmpOZkZX?=
 =?utf-8?B?KzQwOGp0UFFUQmczNGxnb3ptSUZ0ZlgwUWdYZFhxQ0hVWlVwWEFJcnZlUHRS?=
 =?utf-8?B?OVpXMVVjWUR2cEwvVTgvMWMzYURNNW9adVNaM3l6a08zSjNOelJjUFhWTFVm?=
 =?utf-8?B?Y2RTVjZwaWhhbDdMSitGdUNhaS9xU2tsVXJ4aXk5VEZ3VWE4SmV1TlRRRjBk?=
 =?utf-8?B?eHBldlF4WkVUbGVGRkJiT2dzRUlhZCt0OVZTbCtKOWhFaTJ6bTdVRWUzMCty?=
 =?utf-8?B?dnhnWkxkeDF1NWgrdTNNdVRmSXVEcmdNbEt1QVFSL3FUMGpWLzVjbUNER2hO?=
 =?utf-8?B?aHFmZ0VhM0R6cHVhUlNlQWdXMXI1ZktMWVViRzJnNDRna0ROalpSV2thK21j?=
 =?utf-8?B?dTV1dkJlWmNWV21VMWRpd0F4TS9HTFI3cnlnVlNjenBjSGNhYWNxOC9vSTRJ?=
 =?utf-8?B?WEwxODFwMWp4QnByL3Q2dEkvd1hKSFo3MUhVQ0YzQTlyNDc3RlNkTEhuQ2w3?=
 =?utf-8?B?Vk9pc1dka0NGSGVYMk9GazVwS1h1Tk16eW5ONU01OVFOMS9jR1ZaaG1RVTlD?=
 =?utf-8?B?enZPUUNtZ2R5cmJnc1dlMlc0dWQ2aDRZcVcrOE15N0ZjNmFqVytoZVo4UDNN?=
 =?utf-8?B?QXYxMGtoK2hRZk5aeFltYndDcnVPbWJKdEFNaWM3Vm4wTmlzZUdKQ0FzUmpk?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NTRweWlJbU9BTHBZUEQzdS9HK0N4SkNnMnZHRWFqTFFEMWl6VzFSbVR5ck8x?=
 =?utf-8?B?SURsOE9VNFRvUFkrbGhWL2hkMkJYRlBNamJoZWtvR0NiQlFOMVhpNDE4Zy83?=
 =?utf-8?B?T1Y3RWdPZE11QUVOSDg4QXFydjRVRFhlMkhuWVV3Z29PWWhMeXo0OE1WMkIr?=
 =?utf-8?B?YTJSQzU1d0dRTXFwdUtZYTNwMHlFMHcvdjVzQndSOG5aRWJKbGpjOHltakpB?=
 =?utf-8?B?YU0zWWdvMWkvRFNrWHc3OWJqazZSVituVzR5RFBBOXJ4OHoydGtaOWZ4bUtj?=
 =?utf-8?B?T2I1OUZCREhTQ3V2b3ZvaVRNTG56VGxpQlBoVk9La2RGY3RRSzZ5Z21RekFr?=
 =?utf-8?B?d3RUM2lPSWs3c1ZvM29RRndHdC9ETWVVeEVPUGhHcUMwOHBHdnFMZGo4VlJ3?=
 =?utf-8?B?Y3pudHRSWlZJOExaTWNmRlZLemd0UDVLa1prWDZRMDBhZjdvOVA3K2JsZGl0?=
 =?utf-8?B?QXFYYzJUbjhzN3hlaXhZL29laWRtVThVMFhkSXI4WGpXWlMvRUhNZTZTdkJN?=
 =?utf-8?B?SDFOKzg4SDh0SExFTzRKMGt4UTlQVnBEUDlBcC9NYnlvNDJTWitXWmIrbVNZ?=
 =?utf-8?B?Q3BSS2k0Ry84cW1LclV4Q2hEbE9QdktwVi9uS0hsNTlCWEJENmp6V3B5b2NO?=
 =?utf-8?B?bHRlaS9weFlqbExwSGF4UnJpUlVLY04wZ1B0SGpPRFZ3VWxQMnZQdzhuWjZS?=
 =?utf-8?B?aVhHSUQrRWNvZExnaFIxZnJGVW5rVzJIRWh5eUt3dVNvTHF2Z1dTNW5SSGU1?=
 =?utf-8?B?QjFMV1hLRWg1Vnl1UWFTM1dOWjB3eFpGaFdYVUhuVU0yVDFLM0dGZnJLWFc5?=
 =?utf-8?B?Z2pDclRrOUlTUEVZV0FEOTZQeW5HbWhvcE16aDdmT1FUYTZ5V3JiUTFiRUpz?=
 =?utf-8?B?bnpJbTFoZXFrZFgxQ2p0NWlXOWxjWUhsWS92bVB3eFNOaTUrQnR1QzVqN0RB?=
 =?utf-8?B?enlwNmVla2ZIbzhTUnpCbmR5eDhKMnZ5dEx0bUI2anNmLzI0YVFNMGJhd0py?=
 =?utf-8?B?cllhckhVU3NkVGZTUkdLS0VPNDRuem80c3BFd1NPUmIrVVIxU1BiRWlxaS9H?=
 =?utf-8?B?M1ZvaFhBaVVlTVJpc1ozZHVVbXVQWGtqYzZrTGFlUHRoK2F5TXJ5bDBmd1VV?=
 =?utf-8?B?eDE2ME9Rbi9pZ0V1U1RETXdtN2N6N1o3MUpOVzZ1bXFra0hLejB2S1RNL0M4?=
 =?utf-8?B?Nmh4TWtaK3RIQlI1MmVON2N6WmxMSlZnTUpkQjdUdTZsQzNKdHBRYk5Samgr?=
 =?utf-8?B?cGE3Z0ZybTRkblNTNlY2eG9WOGpCQ3RKaG1qSG1LUHhRRTFYNDdIcjJUWFlC?=
 =?utf-8?B?SnZMYktDbmgwN21UczhDR2o0dWlRWHFmTWJhc2dheUpZdlhnWW4zOUt2Qm96?=
 =?utf-8?B?bjE2ajlEZC9FZGQzU0szSk02NEJmbnpBNHlvUVk1ZWNSUnJLblRSY2U5NXhQ?=
 =?utf-8?B?Q0dVWmVCRUNEamRKWXNhdVVqcWFoYVpuKzJWeDJEajdMbWZHdlY4VHY3Zkpv?=
 =?utf-8?B?dUd4N1FzRTF1MGZ1c3FNUWZOSWUrakhaYk1HeGVDZXVyTE1DQ2ZQaGh5OEVs?=
 =?utf-8?B?eUNPNmtLbUlGbUlYTDhHZndVY0RoRmpYbUdKbHBDVlJORVM1VnljaEU5bGxL?=
 =?utf-8?Q?DEuFTj6c+XtbHso9nJ8T+KfgyuMJsbbhIxmgrCuJWPY0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3d6ced-d4c6-4bf9-84ce-08db1ac29399
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:05:20.7221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AB7gvSY/pkPz/4Fgv4AMF/3WdyU0bVFlSDPYVZNvOxLG4Vx/i2FLeFftvr47E+RRuBbkgIk2Y9ms6vArW/SsXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-GUID: rzBG8sUciFFvVbycEzaXsbClbDL5yNEo
X-Proofpoint-ORIG-GUID: rzBG8sUciFFvVbycEzaXsbClbDL5yNEo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build ID is missing for arm64 with CONFIG_MODVERSIONS=y using ld >= 2.36
on 5.4, 5.10, and 5.15

Backport Build ID fixes, which work-around ld behavior by
modifying vmlinux linker script.

This has been build tested this on {x86_64, arm64, riscv, powerpc, s390, sh}.

Simple test case:
  $ readelf -n vmlinux | grep "Build ID"

Changes for v3:
- per Greg, add justification for backporting:
  99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
  which has "Fixes:" to v6.2 only content.
- rebase to v5.15.96

Changes for v2:
- rebase 5/5 c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT") from upstream

Previous threads:
[1] v2 https://lore.kernel.org/all/20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com/
[2] v1 https://lore.kernel.org/all/cover.1674851705.git.tom.saeger@oracle.com/
[3] https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
[4] https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/

Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
Masahiro Yamada (2):
      arch: fix broken BuildID for arm64 and riscv
      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman (2):
      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Tom Saeger (1):
      sh: define RUNTIME_DISCARD_EXIT

 arch/powerpc/kernel/vmlinux.lds.S | 6 +++++-
 arch/s390/kernel/vmlinux.lds.S    | 2 ++
 arch/sh/kernel/vmlinux.lds.S      | 1 +
 include/asm-generic/vmlinux.lds.h | 5 +++++
 4 files changed, 13 insertions(+), 1 deletion(-)
---
base-commit: 22d269bb30db7f5a4e71a8a813a0f4df5255f7de
change-id: 20230210-tsaeger-upstream-linux-5-10-y-e443820440f6

Best regards,
-- 
Tom Saeger <tom.saeger@oracle.com>

