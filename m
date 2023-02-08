Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901FE68FB00
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 00:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBHXQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 18:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBHXQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 18:16:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9050710FB;
        Wed,  8 Feb 2023 15:16:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318KxOAo003997;
        Wed, 8 Feb 2023 23:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=PvGlx4j+Z1mqR+VqDfiFKTl1b2RM+V7vMIvqjEdQUxc=;
 b=OWDlVB0G3phS8C1aOb+uJqdWBEhtm+9kmZYM7kLVuEjdHRK0wPnFVKHVEsM6fCcQZDoy
 bJVVsRfGhkjhM0h38YrrGqidHnJx9oBpf2BBZyktwkFNpe/8c12mDD6ThHIPfPRKe8c+
 qLiqi8udOynnsbOgCS3t+b2r4YPZWXTFHmPhPRLvq1TZbIrLwGfZR+klOdnUuomdARcu
 E37letQHCskFywtaCvSON+HzZ1JO7KtUtdMIkIRBwvIKGCe+CiQhbHCxb45NDB9aTqPL
 QtazTmlOAkJStKEWBAJBXZExVnSiQDx17d7DhEeKu8t/aKooRxjVDYW3NoBgJRlGiR4j TQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy19mhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:16:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318N0PT2035894;
        Wed, 8 Feb 2023 23:16:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdte7yq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:16:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAEdGNNJ1MDF1CFQvYPHLYwp3x80XteOuqca8eS78RH0N+UhIoOCzhwo7y6v32GSLXMGTK0JwxxHF2bdEW+Hv7MwdoROIC8MQ4is5RYdmqhrdGJySuFAHWI/KXw+W6s8ewXqVKN1AFLIV3d/uUo5+UzhqdgXg/axw2PVLzFkPFCXWdKJWCjogBTbQbcq7ww32PMmwrMA59xezFvdLOEfwhm5Ecgmp82uBPyDlqA2F008jFgHLocVWOeTSSyHg33rGmLo/NfkzTkmRNoStXF19QryAruYrGtLQKXsSzk6f1w7NDQ5zeVVoq9nXy3fJ6j6BzLxX19iqUv4AWaAvO+Qkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvGlx4j+Z1mqR+VqDfiFKTl1b2RM+V7vMIvqjEdQUxc=;
 b=P+lwmzXNRVmU9KQARA0ywnQA+qLvqsEdz0i368SlSeKsrDqClUSzugZzO+HdInYpwxAGBLqzztle4lcYOxJHy71cpUoh9+cQdR8NKiQQV/mqvQ7BlpPqLyIIkwGp6xMbCMHSapqJ6mpLzZhUgoBC1CmLuuXuay9PzVHv912koGj8LmgVLBpN3TMOhm7NEI60DojpG/xOS6NpN3wkQ67W7cx1muieYlFXGLozWM0dCaJVPcE1V8873/Fv9u9dDotL64tB/oEJKy6xG2orHF86ifJuqwaLckoFw8mKbwdBKfLZzQx20J9LCI/g+agG5bnALC7EvhzTeSEwBdgiTQA3+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvGlx4j+Z1mqR+VqDfiFKTl1b2RM+V7vMIvqjEdQUxc=;
 b=G/58fiu+i82oQQWUszUd+/MFCBSlW4S+x+elvZ8pVE3x2wGcX6Dh0/hLdU+Sm02qrq/ibxIPWUGZDgcfuL64QLz22kUBmYKkS3l+qokxatwnq6wzRhLZmcM/dMZOcTvKEC62LJUaKDXfInxjOID+E1MmkC1C+MSPS3Eh+04EXvA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4735.namprd10.prod.outlook.com (2603:10b6:a03:2d1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 23:16:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6086.018; Wed, 8 Feb 2023
 23:16:20 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: Allocate cmd_priv with scsicmd
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mt5nzr2e.fsf@ca-mkp.ca.oracle.com>
References: <20230128000409.never.976-kees@kernel.org>
Date:   Wed, 08 Feb 2023 18:16:17 -0500
In-Reply-To: <20230128000409.never.976-kees@kernel.org> (Kees Cook's message
        of "Fri, 27 Jan 2023 16:04:13 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0172.namprd13.prod.outlook.com
 (2603:10b6:806:28::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4735:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a2e17b5-5edf-436c-0fad-08db0a2a7cb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euT4hENR3DChKAMMTBUu0o42bkhxvedM0kjABSBPX0PbXNACdPGuUJrpxx3iYEDJbD5X7YNqPgLeo06uYi9ka4ODDx013y6ZVFYCskPzrNhbZiQY9qAuFPuYo99MJ79zk7aVR2hu5ioPqFDRbQWFd7lKTcUonOtPisGRGkFapefRX5F2GdG616vl0FGZSn2ogI6p1oSisDnkcKYRuz7EqPugm3b1B1SG0z4QOSAjIDOtdRi/YDMt7fqbhlw9s/JCHfuM2yROaL87FzwC3jDwNRUWHmSfi9lGpDIAxFm8MQsfTmcgLFMK/1qLlrtnTI2NHg7oS6myF1MOOze2CYjtWOX2AJd2/3p2ocvABHWdQzfiA/cP9MpewM6BKmM4UOZho56L+QgT5ASj7nQ5jiJ50/wuhr7UEC1Y4hpv8a/09xCZxrr6aTdcLIGmUmBb5GBaVOL4WvzaNvUl2DOkA7gOpdjwGPCl1H98m2fBk6NlWZSnGyp54dJ+jygLel2h9VegmWro+JRtM4YmkhNLgmMOjKZRPCT7OYC69muWxZqxlvlTAUnu3MInLgY/pWqqH/9boFNKiwHZAf+12fHzXUdy58bQepgnDaEJlEpKMCtyqXQlG7/EUxAA06rAcQHauoG681K0zyCZmROcJEBswqkLmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199018)(6506007)(6666004)(6512007)(26005)(186003)(316002)(2906002)(8936002)(558084003)(83380400001)(36916002)(54906003)(5660300002)(478600001)(86362001)(6486002)(66476007)(66556008)(66946007)(41300700001)(6916009)(4326008)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2cUKNmARrAzk4etnwkaQgWOTiNcDQ+ngIFVQl/th8Buc+dbzCjteZOi/SnWS?=
 =?us-ascii?Q?/uWEo9Kx6jwfoaYK3+HGWzPXxhPvqUQ4KJtBauq4Mtkg1C7AGPQ1KQ9mP8zN?=
 =?us-ascii?Q?6QhMUmiEWtmdgSN5jgJ0apOClq9pmhVAhUFMbp1Hq0Z/i2jR8gs/1VcA44GJ?=
 =?us-ascii?Q?EIGxCvkpnm7pCsWa308Hs6xt21k/c5gRoOrn2D+cIjZgrRk60aYf6kmArvYo?=
 =?us-ascii?Q?m7VvVNBKSIZK6ybrR4y2IoEyaBKATavN8cezclMUnaRNx8EvWmEERM1NRV0R?=
 =?us-ascii?Q?5EPuIGmwD3Z1ehJYQQmTG/1ooMwPJMrup/lyMnkrS2I2hpaDLTCPAF99CdSb?=
 =?us-ascii?Q?idUv8wo+O8eCcoR5MEokPJTXL5NF3eI+ll77bBMKMhD9opVDCTV9PsvZAihG?=
 =?us-ascii?Q?TcU+O35FWT+ZLxAwsZyZuvKX0sWBLGRWahHI1PzuVxOvnEIhzP88L4gldkix?=
 =?us-ascii?Q?KnB3vSXFaN47m3glrtVsLWnlx4HnZuggTASRuEFmhXlMJiH7mSIV57olEy6v?=
 =?us-ascii?Q?fP9wtRu1z60tGcjPRoh7MQOUQl7YReNDj5qhPups2CZjPlpWPaPoXB6EzRCK?=
 =?us-ascii?Q?+0/nPpjKZqnA02TAmfeIPXAnP8VhqONoAWlQonCeLVeh76UKGCX0afz98Mb+?=
 =?us-ascii?Q?Uq+9LgWBE+QkpxppIbh9iq5KQQWJ38Pcu/yydV/lHhreMi3Prhw+9w3k5RjF?=
 =?us-ascii?Q?pSZOhU0VD33+MmXExOH/72ntm1K5Gbn+p9hGzQj3I5c2Avi1yOp9c+FUk66d?=
 =?us-ascii?Q?C5xYkUQ8JoVD6SEe5saLf25rKl+H+d+6z0DwfT16Uo8zHkWp1JPtJ3kBOX4F?=
 =?us-ascii?Q?IfEChacLiUTCbALjy/3kDPbM//SmKh0e7BCIn3MdZ4uuTpXXXw/kokrjbH0L?=
 =?us-ascii?Q?/YJKjZSrFNF5oIEAhrwo1w8tqog8JtlyxJti+6NkzHL4tM1nop+SG/xmeHsP?=
 =?us-ascii?Q?6EkcPlCTwJU0Q5ay/VVWgVAcyRaO9QXNwnmang3EFtn+dmxNfbZ8pnKO3NYa?=
 =?us-ascii?Q?hc7Sj/7AiwVS7toYe8xQTl6OrofBDEbfjMi84ek6qUA/QHdO0LI8oG3JdAKQ?=
 =?us-ascii?Q?MLX41pMsEjmJGjle/wJS7mtmH98i2QE/YYMzyOQTFviJ+CbmPjNm/sKzC8SC?=
 =?us-ascii?Q?72TRNml4Utm2FoNX/k5IDXbHSi1xonY2VTDxtt0foOhxXIFk8wbk5UPnXs/m?=
 =?us-ascii?Q?uiZ3YpUKgpyifM/kLULoUe+dqiImWZZfHIWf7IKHDFCH4TcSBNmGpJYOlkFB?=
 =?us-ascii?Q?JsuoKmHcgjQDIH0TY1pWKAUwtnA9wB7mg+SGhb0famgT/P9kZMm4wPYXMzGl?=
 =?us-ascii?Q?mWh+cgCyzeUssgv2RDFpIEY7KG/1hGadpfyuAVNBIF14E4UfjfE8Qkq6vhH5?=
 =?us-ascii?Q?JtjfA2XwDDPLLB/zl9FIm6sAfQBuhWU2zheJ0yRgjjGActvv8IA8rcx2V4Md?=
 =?us-ascii?Q?7Vwb5LaCdmH90JlsNTO6lrZ3Et5tOGe5zl8AOTdasn7Fs/JDxmkBEVclACKO?=
 =?us-ascii?Q?OlO4397kkhEq1ACSVshbCpGwx0W3qThZRhpbQ2eoNsWpEOv+Q5/7eFN9Sjgp?=
 =?us-ascii?Q?wD+FhKzonOUqWv7HvxD1phKqjfhY2RxPf77rk8+DQtLNy9H6QQam1nAfMXXC?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: K+oDzd/8Lq1B6yBe+IX1WMtlDqjj3NyNAqGnIu03qbjv07YfxrtIcb1qdxGPXO2keFmPm1bhdtK6iylHPCCjsdGlcbR67bRv+1Vbw7ZhKPXAlr1Cmy5/ROavFbyOZjZ/eabXj6v8u5JNl3rl0pqXbLPZTjxq8DkVtA7RgMyvLEUS67SAHxnP/aOSOcSudVSPs1KFnA0V/zBVGt+ZOvNjs5fDra/m6/UeblcLJB/Tm7ZTSZpOUDrwNxtdU80TVFj9jrK+lnECs7VXoJg9YXw0/g3szapkgCKzc3UEQeqXA0oml8LcagHNvjFq+VN8CmkUiDuosD6P0TOI3SHstZ1MsOt3jemmkdhL/ZCEhZo5OGTHzFZQkWWCGqFGypSG6+rD6J/WOPl/4bB7IfqbrINw9kJfurN7SCFtfL135X2XQl4m2x9VzfAYTQ9KsZkWNJVGUqOzi/y3mW6GpcQ9K1vaq79TeRru3xH5w/1cq7uRmWNbKA4DI1AdjzcdVqqWRyO+KlNRyi8C1nU3kU6V/Ir1fcrsOOiET8H562tu0npnwPiMd8fgBUTi6BfZ9dPLyQ6BUg+TQgsHXOkjMrgLno3DXG5jMJMsKrJdkQ/Bht3FRZglG+5YlNUSRuZZWn/mzsvDfehxkXZ9mLq0c1FW6f/Hg1bkZtLcCUYRwzrGvwSxhwxPH8tCYBYXfgLeBwL3kyOtk6so/QWQwraL7mVAr05zo1AqWwiLUyyRSdHzWQmpJXWQBDgRt1k1fRyjD2PYwlhW8Yb27Nm/bnVHJ9F76yHdDtsQujioCtcveCV0ELRZwB/eQZopCCKgpDPrZhgSrZueB2GPaW40xGFrNxoLEvISg+nDGIQl9SiFxc8Y/MOFFvu199iUv1OLvXnXeyM4K5/ey/8Q/d5uP5aRFgsk1elS319O9jnB87IWBWBmCnEWkx4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a2e17b5-5edf-436c-0fad-08db0a2a7cb8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:16:20.2273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cEPcdUchI4aEJ0+s/inM2ZtgX/9wbGkzHTGVOfnFtFy5V80unVbYEmYwUwmgoUqHB5zFf1gx7/WGF418IKKT2TczIW4Ml3qwIC3WyDKxiv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4735
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_09,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=646
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302080197
X-Proofpoint-GUID: WwyMOThfVaHuPXsmrSK_nd5T_oC13cTx
X-Proofpoint-ORIG-GUID: WwyMOThfVaHuPXsmrSK_nd5T_oC13cTx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Kees,

> The aac_priv() helper assumes that the private cmd area immediately
> follows struct scsi_cmnd. Allocate this space as part of scsicmd, else
> there is a risk of heap overflow. Seen with GCC 13:

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
