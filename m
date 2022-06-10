Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60C6545E24
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 10:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245131AbiFJIGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 04:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241354AbiFJIGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 04:06:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046371C91B;
        Fri, 10 Jun 2022 01:06:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A7sVtb026535;
        Fri, 10 Jun 2022 08:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=jOBrxoxL92j5ihaOnc+UPM+slCqxCloAyVHFnHTeRnU=;
 b=umCHwxy7+QAZjjmxGeFj8y2U668ERN8LaCUJ+2kCoK0Oah2NQGtXHo871Jo4p2W0q6fd
 vLDmbMc9kerbxIXo/n+sdEY6rauq/UPTpuui3fG1ItjxUl3sXgNKffzerWJTzHjLD5y8
 L2pqYsY38Lng9+lKeu8lnB44WQl3YJ2YWe4sfNdZ0qQ+NrqoRQdkp/LHB9ifAzQ7alkB
 +JxHRL/1GvpLmYmbSLdztnYR/D6yBDB3nk/LM21l8rXZrxeUwoHQlcDnMHnfOBYNyZSp
 Adfzfka+J6atMZZgCmFISbK0lmf6/9brV0ERTqCT9Q1H+OpwV/Zn7VBHOz5T/Vi6g0AX 3w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyekmywd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:06:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25A80Rm3028681;
        Fri, 10 Jun 2022 08:06:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu63yqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:06:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPbUlSydkxwWXRkqK0lqzE3uN5zfGMtUQ8y34F5P1r5kMr+xj0O3awb31VBX1r0E3TqCeTY0Bz/w9f1v/2ja2fUl9XyaEuIsBBqj8lFOV54uEsRdqC0oPkd5bH/fBa1D+4Vf7bR2M3OpLvzxU9EhRXo0tmlT6v2cX7pN9u5P9dVDTWtLGjIAD3ZpzmfwL/mmk3q4VC0AuP9ca7smwtSbag3MRXxVYBQf+nlauUX7XnoXGcWNC4rm/jhhN+HkigCkPjbM+D5DAX+t3CKEHn0giQiWUsOXnjBijr5J1YI2QpUXjVT3mfb9WpZUhiDJc0UkYkLnJbg8GtfhrSusrc2QlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOBrxoxL92j5ihaOnc+UPM+slCqxCloAyVHFnHTeRnU=;
 b=bJ7ozu8Q3S7CqRtAghplYL/9krUrzJIr1ufaLhE6727v5MjTFShuUChYY2u2v+Z61X6C636IU/lr1XI3J6cqpTYHUEnpkqeksDdnMtcBSYmQGGmM8BmAbUjHm7PNIoSOyh0rc7Yf/nMfir7Qr7KBS8KEwnniFBwgeEgaspGkWSC6RldCe5hdpn+ikAGCAJPACdtHBXW7UNU/rLMmMM4opRoV4NTTKPswNl9JZmov0BDH8THI14wPdey+a9Wlbr/naqR6cd9JSY7aQyrVQlCE9Kos+yZJikIlR9PnCZh9yF1lDhSaDKMgvh3FQGKCqjaHB2JRXYWzyNUHNsxnXiafMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOBrxoxL92j5ihaOnc+UPM+slCqxCloAyVHFnHTeRnU=;
 b=SPFfTq5eQXHxb2B+y4L35ImcjAOL702zoB7ajSHsq4XfnmCllwKU62n3soppId9N27/B/z3Z0yx9tIFEQ5Vf0UGDIr3D+AB23NRlGjTO0+raoW+BZG9Kf1N5C3jmfu67Me8UtXZfhmm4qlXllMZ2q2DG5UYyIsWrnIaATYDPgZ0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR10MB1948.namprd10.prod.outlook.com
 (2603:10b6:3:108::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 08:06:39 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 08:06:38 +0000
Date:   Fri, 10 Jun 2022 11:06:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Jared Kangas <kangas.jd@gmail.com>, vaibhav.sr@gmail.com,
        elder@kernel.org, gregkh@linuxfoundation.org,
        greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        mgreer@animalcreek.com
Subject: Re: [PATCH v2] staging: greybus: audio: fix loop cursor use after
 iteration
Message-ID: <20220610080627.GA2146@kadam>
References: <20220609214517.85661-1-kangas.jd@gmail.com>
 <YqL6A3pVC8LOqE4d@hovoldconsulting.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqL6A3pVC8LOqE4d@hovoldconsulting.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0169.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f747d4c-15e3-4e6d-fdfd-08da4ab82544
X-MS-TrafficTypeDiagnostic: DM5PR10MB1948:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1948927E5373FE92E56D0CDE8EA69@DM5PR10MB1948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZE9gLd6+u3OdByM9tk4S3oikuoJmwN67Y+GU9IQ+QCi6Iy/JFzNi5IZDf/4uX6oZKioZDLwbaZn8KC1HReIZh4gdmQIdAVv1U5HhT6+iYHwBIlyPh7mlPPT0iPljB7TY9Tngs80kpV48WaPoAQoyfx0We98hqGlVD4Qx8IyFz5BkW3+gXOoaDteK9iBntO3naT+kiJEJoH7W/fiYhBXN9vpl8ORL+q0zSLELX6z5x5bKEed/Ldr+lfkfSKlcxl5LU5B2ZKboAyy+w/C3w4IgUXhrV8m05zKaok9h9A1Z4ruaWyH5QbQw/pzBzCL3lyzTRDQ+E5j2s4osRBejJREBr5jHpsjy+Jag5sv+TF+vj9hdJ4xYcrYLnhYd8QwaHIiFEz/mrGrU1f3HPyLGjO8VbIKROoQeghICmuBgmZmKgu4zPSke5Yjiw8Z7IaVxTQTxN7ISf+X/PmuqE0JpHVF64G4K/wh6x+V8WCaADyb8qPPTfeZcEZJVb0f8O/404C2+WrdJNHOqSdAUfTbbyLL0Ld0Ykjz/Vqfgy4VMW9i22waUdxXApJviHHOB8q8LtgbFi10wVm8bwyhYJvf3+7q2X/eZdkyn34NIQycSKNPYURP7ZjTL76dYYhH7S4RSQIpJvvVfQA7aAtFpy4Q+uKfMp1xlVQ+mQk3CuboCI2jHghydoGPEig2rSaMdZ3izDVHiN/qyHFiEApIjzBfom7/Zf7HupUn+tPCRlAUiYsKBJ5RXH+X/t280SlPYOBjnvjLH3GLsHuIX4gLMvODAb4vm2S+CH3a6UuzyNrMokUcMUY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(6916009)(316002)(38100700002)(38350700002)(83380400001)(33656002)(66946007)(66476007)(66556008)(1076003)(5660300002)(7416002)(44832011)(52116002)(2906002)(8676002)(4326008)(9686003)(6512007)(6486002)(966005)(508600001)(6666004)(186003)(8936002)(86362001)(33716001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gRNVeWzi5DY/6XiRj+POG7CHBp9mDvVhobPtuucoPfkLuNZQqGbDFzBVk4pp?=
 =?us-ascii?Q?U7r3eVgpmvdggoNCcubz6IwHx5MVwUSjKhVRFWs3+YyfmSIGsLr1Rt9VLfSL?=
 =?us-ascii?Q?AGlN25Pnhqa/OOEPef8yPOxuFnWzGFO5OOuN0mY01pyj0OPMdV+9IutkhjO3?=
 =?us-ascii?Q?QiJetXd7L1TNZ8ff9pWQPpheJLk4QDnfRsJoE7X3AHWb5ozgowpTqCR+9bsT?=
 =?us-ascii?Q?EiDn7iyXs0BYNsRsNkjMoneEiqw2ZW0c/lkESqj10+pI6s26Bxms/eNUzisx?=
 =?us-ascii?Q?OQ1eGeUugZEEv7HbNIU+lEg4HoA2MTsQhYfUFVrXmgUxTeN5OAds651KKA7g?=
 =?us-ascii?Q?GyMdiAJypVIVpsDjxMgzlAzqaeCqJQzfqNx1hT6B30P1kSXakxL7e4QdA3nz?=
 =?us-ascii?Q?yDoGiWNirmwJy1SIIAicfcn2Lnh7/NKwXY8ul9Lqb4NF0TLDDe7J1M3z34Dv?=
 =?us-ascii?Q?ev+6XlbwNucD4wwUBejNbCChd+5nf0/a4CsP067pJVUR0Rz/d53Ri+0gQ8oI?=
 =?us-ascii?Q?xDEO6Xyp4VMh30RKPfb11QBTGw+G/Yx4giiwH/nkW3vZULNz9XoztcQgXJii?=
 =?us-ascii?Q?ivwFxCdWVmR1bUTgmaT2E8EgBAmUb8Di/gSNG4QrH9WiWtFryXg6RntbT2wn?=
 =?us-ascii?Q?oxmoC8wABt8oZpxIKAE1ZOJ3uwHG6Zu3FIQWEH4JQeRlWlW0WIYr5eaeRvDE?=
 =?us-ascii?Q?WAQAaib8K1UAYyeH+mflNHRp2xFYmBqxKZymuyOFphYgi5IoPkDQSXpaSNos?=
 =?us-ascii?Q?I24WPoptdGQmOFG+wsUixqhiiuG7PVCKlO2eb+i35A7D7KjRuUco0OqwDFVh?=
 =?us-ascii?Q?SyLRIuthrqkUrb/dg35THRxhHK+ca/5X1OVIx/ibemogDTTNyZsxs/MlbnTr?=
 =?us-ascii?Q?lOfmjHF51RxsBXNfQkAdufEVtkCrNUsxbjjgnlekTbFo1xaUoAiiWTIA9Zy7?=
 =?us-ascii?Q?uY9GyrWC4+UM7urZ2mROnW+JMJgGvcV0haDhS862MgF7XsvrIIetpvlOcsBA?=
 =?us-ascii?Q?v5phxXbhEXjimNHwgejEngoBhGTAt/ruUR77lyU3GHJWrZcN4be9sVYRPDZS?=
 =?us-ascii?Q?FjdAiSncXnAqrD6lZvBiTwC3rckbs5+Bcvfpm8sl3uofaJcZcM95GTELneIy?=
 =?us-ascii?Q?kNT24FMiq+JTVAE1+7ULBXESsJ0Be2h+JFNw7WF7OySAn5ET0pjAlJnLJaf8?=
 =?us-ascii?Q?fq6+Mhfppxfy/UuyzI/GRjsfA2fqnuO+X5mpRd/CjHLvFlvDCSpUXI4tQJCD?=
 =?us-ascii?Q?EYE7t1Px3KImWM4buxYmYUv+GAHBSLHp+S9wDxIZjc6vf/jHbwT3Zb6cvl01?=
 =?us-ascii?Q?XPG+9DqBcsY/V2KuUwjmvlUUUH2wFpbn4g3l+C67iLc3lONkC0baXfsLoK6E?=
 =?us-ascii?Q?ZqPYXqGtgXJsERml0+lIIRXwd+CjgFGbv0EbIUlNMbZqi4+c61CIJ8ThJTTA?=
 =?us-ascii?Q?xnhnWLBZCG+l5aaBJ+rohGITe57O3uHe51JuCVWifbX1BwYtM+Jfdj1kmR6v?=
 =?us-ascii?Q?M5btph6HCPfqS5QKfvagT40awIAFQswz1p9kd3BV/6fcwqOBlQBiLY60tTe0?=
 =?us-ascii?Q?TgwBvpvMuF+npr2qtqbAp51F6GPsbJynfmAmpb9W0GL8BHD1mvkamcLHvx6b?=
 =?us-ascii?Q?XpuBDrhUctCNYXn6Y04p41ICQWIQmGz5FJB4TQPsF4DO3+Iz2t2zGo0SEIse?=
 =?us-ascii?Q?AyeqZzXlQ9JnmJDvykhgbf6il+r4N2UYxsN9pV6bwskIQscABB5OTQWR1/LR?=
 =?us-ascii?Q?lbOg0sEox1c0meF/HtMby3+wq6+WioQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f747d4c-15e3-4e6d-fdfd-08da4ab82544
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 08:06:38.8718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mASLmnN3tNqqKEjo3+gftEEj9GnUEcByEaHG4Z8p7rQ1puCNGby0aSPCTT8RE+6vK/gC4o2Cz7Ck50iQxfszHKyy9W4KVJ/3NhwKBqEXbfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1948
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_02:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100028
X-Proofpoint-GUID: 0H3o_cx7UYGEvettKc36KCJ3RtgZi7ot
X-Proofpoint-ORIG-GUID: 0H3o_cx7UYGEvettKc36KCJ3RtgZi7ot
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 10:00:03AM +0200, Johan Hovold wrote:
> > Fixes: 510e340efe0c ("staging: greybus: audio: Add helper APIs for dynamic audio modules")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Reviewed-by: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Jared Kangas <kangas.jd@gmail.com>
> > ---
> > 
> > Changes since v1:
> >  * Removed safe list iteration as suggested by Johan Hovold <johan@kernel.org>
> >  * Updated patch changelog to explain the list iteration change
> >  * Added tags to changelog based on feedback (Cc:, Fixes:, Reviewed-by:)
> 
> Apparently Greg applied this to staging-next before we had a change to
> look at it. You should have received a notification from Greg when he
> did so.
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-next&id=80c968a04a381dc0e690960c60ffd6b6aee7e157
> 
> It seems unlikely that this would cause any issues in real life, but
> there's still a chance it will be picked up by the stable team despite
> the lack of a CC stable tag.

If you want you can always email the stable team to pick up the patch.

regards,
dan carpenter

