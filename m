Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3614D0727
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 20:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244920AbiCGTDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 14:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244917AbiCGTDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 14:03:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC142DAAD;
        Mon,  7 Mar 2022 11:02:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227ISbDm002094;
        Mon, 7 Mar 2022 19:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=EiUIzX1Xb5W8F+EungegBUeN15VaZWJ1OOPtqlFLS8U=;
 b=iwfYbzdXLqS5BbU2B+TGVV9kL0mq5aiywR1xYHnlgDs7HzeYp1SSyOU+gJEuA2DafbN3
 liNJ4l2/qVJaiIuoba/ZLNzC1p5KKxH0MJ2IS5A02THndLqwmW7NEYbi8SE4cevyqwjz
 4iCyBKmiYxFaWMFcJEMxcKNxJq+aP0/FiuCJzRXWiMgutOueM+lv47DOV4uno8IMimm/
 7XKEwcNFQvOcGWYbrTPNg+6cAHI8I7cSxtMHJP+evedhPaJlWUNdwgKMpVKqOCeScqeu
 e4AJAnmhfpReqbGNE11Y5ZGyw3HQamnh+RV+RI+xHZBTA17H/IecHU3b09Q9TN3PMchE Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfscste-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 19:02:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227J1ZlB153606;
        Mon, 7 Mar 2022 19:02:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3ekwwb83g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 19:02:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrCIIOCqUmkF76YYGiJvGL2tbCkkCpcSk5wXXbglmZlrz3Lcawiuc5m2rmxfSGkDKMHPJP6rXe+QIZq9n5vEprfVDKhjpMOuCpXT7dfN+fGtUrePrW6uY7nicEQCGbn866dU/EqnOfVTLdH+8uqG/Y7za4HlWFXowmVMXGP0lJy6lsJiz/Z855pvrb2SKUi13Vmwakx9RzLyAVQgITPBGCk4rfIofDLfA0JfLLg+Ogdh1xwIMSu/LxqJjXZ2qns0CcOTUBcj75itXqBdpoR25RCzItLZDRL0QCt/hep1O1+8wm5Z2Ew6mUt6j0cw3Ioz49ewXIpiGPY+iN/bARaF/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiUIzX1Xb5W8F+EungegBUeN15VaZWJ1OOPtqlFLS8U=;
 b=laZifPaRy0R12J9+hj6NgzI82L1GIIPbPNI38kNW/7I+7mTddD7KgJcP5qe/S8JRzlSJdF9v1iiBxOwbOwq5/lot3M5vcTmWOnbTzLfCvXewPQgUOCNO8VURPGzzqmg3U7pNklIpFtUAjwAMPc1SBvYJCOwT1GgOGjylaz4eIFvyRBfa6QwBP8Ww7SCn88kkGvnB8e6giHULcpoK+vJnmNkspbUGuqkcdyNweIQJftxfwVkWgOqcE2psx73yp5j31BXe+Qz+akl17ER/rc0dq0T5ygLBsUfOuIDjrg8b98X5VqIBKMpatLsAeHtAhWmLLOiKWwJwuWCjF+TTkOnfLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiUIzX1Xb5W8F+EungegBUeN15VaZWJ1OOPtqlFLS8U=;
 b=bs6A6N+9MHx/Fiw0IdE5vXVE4q0fHQZf8xiBqzyXcia3Ig2HYi/e4jfb54jDYq7AaJYjr+MAOs7VXGoLzFkYrSATyw7LE4LTXEbJLhWb+c6zHXgf/6h8EJfBbxhmV/W8XpNu1S2UeziYi5bi/Jx6Xip4zGGDb2xthj5ymyfOrYs=
Received: from CO1PR10MB4403.namprd10.prod.outlook.com (2603:10b6:303:9a::17)
 by SJ0PR10MB4622.namprd10.prod.outlook.com (2603:10b6:a03:2d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Mon, 7 Mar
 2022 19:02:24 +0000
Received: from CO1PR10MB4403.namprd10.prod.outlook.com
 ([fe80::3027:414a:140b:9bd7]) by CO1PR10MB4403.namprd10.prod.outlook.com
 ([fe80::3027:414a:140b:9bd7%6]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 19:02:24 +0000
Date:   Mon, 7 Mar 2022 13:02:17 -0600
From:   Alex Thorlton <alex.thorlton@oracle.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alex Thorlton <alex.thorlton@oracle.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/paravirt: Apply paravirt instructions in consistent
 order during boot/module load
Message-ID: <YiZWudMX7Yt3QSs2@linux-qygv>
References: <20220307180338.7608-1-alex.thorlton@oracle.com>
 <20220307184505.pvwzjujlqoyrpk44@treble>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307184505.pvwzjujlqoyrpk44@treble>
X-ClientProxiedBy: BY5PR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:a03:167::27) To CO1PR10MB4403.namprd10.prod.outlook.com
 (2603:10b6:303:9a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 664a4adb-b856-4ce8-dcbb-08da006d03cb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4622:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4622C951DDA5287325B0646C85089@SJ0PR10MB4622.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OU4F3GcW0Vyr6fdyYjY6oqGaaHUh2IR2lo+XV54fpzSvbV0aFE52WUW7c2yqjwqxhM64eak94Z2nNI7uHZf2tusoejE3B1hcJJP1te3P3FmLfJI8ajpThTCtx2vkKmCOSEWbf+OyxqbfgHhiiPsBw0JQoKMOMhepv5R/7SnaBZpksk0+MmFkLK3WuBzPyyqOemPWnSbusqhvsLaWnx83WxcrUVPonYBCX5HfkXSe2f0H2Z+cpd0mXt+R3G4eAav8Vt8ZIQkwJEEBgbzwYUBzguYWKVMqL+Q9Nea5CQVZCPrEeVk13EgF3w9JJ0hDaIptQKgA15VCrLYEvV80t0u5FO2jMxvlYQTT05w6qTl01elPHUy6miGHBi30PFpQkD4EShxxBotXsILlQCNmpi/tA6JzDkkbltc0lRLJgeM3cUwBe9vXeeImBMwC6qXELB+4JUTV+tfO8Jb83hS4PQ27Jb9VsyDjS+jQDBnDJfgGmdjkW/GLn64CX7EBPUwV/VNB4gp6pvwZtfrhpxxZLYGe5BN36aBHoCN+bWbWKE+ULvkxOlKgED+q0h8KrlIPG+iz8i/5pcKDj50+c+m8fy+3XGcpzVpnwMMd12KqUPdrz/kigxC12g2W9l5b2XYo7GUfilGEQyhjpCTq275XLij6IgkKSPnrwQpW1/5iYwH7wESEr065KfWBfLhQ060Xv4ruiv1STLNeGeDug9/Jfuir9sPPun7IWfqf4VtMiptLcU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4403.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(86362001)(4326008)(8676002)(54906003)(508600001)(33716001)(2906002)(316002)(6916009)(66556008)(66476007)(66946007)(44832011)(38100700002)(8936002)(7416002)(5660300002)(966005)(6486002)(83380400001)(9686003)(6666004)(6512007)(6506007)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tu8bMv/IfrGR6PK1ciMAr4dEJ1/ygWyG/tm9WMzp+iw75Rx+XReru10CGuJN?=
 =?us-ascii?Q?ZgD5rduZeN6XEq4z2gKdS0pboS2PsQTBByNLCz4Iyfs7yBkG4AQYzXuRLERm?=
 =?us-ascii?Q?WQw9/1PCWgNuq+7ppYdB4kGyMjmXgjwd+wCQT55p0G3LS21Cegjj/OwBZAfY?=
 =?us-ascii?Q?Tsgbglu3LzNZl0ZlappaEjOb4zuzNGchicj34N4QdcUhC/ThfsMHqC2rXA9T?=
 =?us-ascii?Q?xXwhZzNKB5YKf9XHaSDM0YyMIjpTdDWSVhW3aGdtBAbIxVooCJRuiZzVDAoU?=
 =?us-ascii?Q?9VmK0fvstQV64Q1FklwELsQlNR5iMA4zXIKNfvbxCEJbKPVHq3TQ8q+A3psR?=
 =?us-ascii?Q?KHQru4RFSwwlnS7F0yMQRgT1jSntKb1AoTj1nXttm43J9jyP8hy0PAg6Xm8W?=
 =?us-ascii?Q?6H3fZbcWloyJkRJyzEnMy/xL9MZv6Euftt1VL9WSeL23ewoBXeTWvvX7sRAN?=
 =?us-ascii?Q?rG19vz3DjHPdwvh2AnfVSuB6/815pZT6xTAZDdHZnq7qqc6WSHpDs/fRitTV?=
 =?us-ascii?Q?gXl7RlMYpSBkQkFqxBpnXaYelfepDYmhTyrRXewSPp8+JNyeAccyBRhKJ/Kr?=
 =?us-ascii?Q?5nLVspi85oWmfnUKPWYdhSb12WJasbna012CP068E83yPzeaLbqqfw6EX8dq?=
 =?us-ascii?Q?BMUMQOPDJIDAgMkZIo7U6ccKfg4DFWaimXm0gp0DWDQCfMCAMJHE9gwRX7Qa?=
 =?us-ascii?Q?krCZ0EEysauS0A4KsliDcdJZvKajUx4ZalYFDFATtPvA5++uTrWIeK6zGNai?=
 =?us-ascii?Q?qET7AEDfAZDanquX41JWdumt14mniGkbyga1Ym0TDpbZOVzdKSAqhh90Wzbg?=
 =?us-ascii?Q?ygKrs5sppQ2BiNdENGf8jF8pJ0er9SdCsuDaULrGflFSSBrGxRR65SPD2QZI?=
 =?us-ascii?Q?XSY3d0MIhtUvVL/pbqnWjgNsX6oZ9/Msc0I/on+4pGGbNQOPMHGpPdAIf0vL?=
 =?us-ascii?Q?civ8iMCM8vCE8FH2LNR2eSlTatAKlH4XFrwyUkdZrNBcu1eLus61r3zFWZqC?=
 =?us-ascii?Q?BYKlsL9Nc5fRY2U1le0rri05cyKTD3Oiix0DHuYEZo1+V8Muvu1d/cAyz3Y5?=
 =?us-ascii?Q?u6cQcbN7EjXMeEFRE0XaQgTC8TsfRBkWtlKOxi6FhHzXOCeYF8NE0k66vyrD?=
 =?us-ascii?Q?oUqXzgvEswYyCb4USl8FF9MAdc8xlG+0PWD3VRj5K/2i0bGkvEJj4nlZXs5o?=
 =?us-ascii?Q?ejD2HRjlzWHoxR9L0sWG1CQEUUu4D/wM7BeLvqONw8E57Zb/mtz2v2dfXDnQ?=
 =?us-ascii?Q?J1zZIWANnEf/xvdPShkBBb2rRK4U0SIyDAW8yQsWegXdB43IfQKWDSfC54+q?=
 =?us-ascii?Q?0Y6gg62FvPYk3FJd/wgRR1VCcJvm4uVMn4VciXf3KUcDpp37slFUqpqljKT2?=
 =?us-ascii?Q?im6uAdNOoIiIZnJONjhBaUGJa5eJVTE3gwSKupoVnN9cXBnA7Zdq1ktH9s/L?=
 =?us-ascii?Q?3i0trq6p4mEUYjj8WUuj++Fl0X6UTEPy07yneOPhEIdLlCBNO4InYhBSHCw+?=
 =?us-ascii?Q?+xq6nqouhWnXJBykLgkQo/wq/7qf9OuL/rkRupORZQ+i6EuUiLPWYdfNKRLm?=
 =?us-ascii?Q?95qZn4wsTuBAms62xH8RDNPq/MFifiGMqV7jDQrDaVGOaQDiDbWIAqydt4aM?=
 =?us-ascii?Q?rSApgeBH1duCFza+A3D8SQHacZ/e5Pkql6hxtuDC5BmsErzP5Wb5jPBRSTAe?=
 =?us-ascii?Q?dclUFf/CX0U/tkgakRaK+P/4LB3ZOQ0Huvq3T3ho/T63xYVZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 664a4adb-b856-4ce8-dcbb-08da006d03cb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4403.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 19:02:24.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OX3o/95EpkWzc8l9uVzokfPwfojzHWMQvuJ611ycyWVaedFsj/ZI69eg3pOVlf8eyhMhACBaGpAtMPB6tUd0N2d6kon1AFQT07LdorJnc84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4622
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070106
X-Proofpoint-GUID: xAE-nr5TmRGocmBx8x7ROFXBpcJBGBF2
X-Proofpoint-ORIG-GUID: xAE-nr5TmRGocmBx8x7ROFXBpcJBGBF2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 10:45:05AM -0800, Josh Poimboeuf wrote:
> On Mon, Mar 07, 2022 at 12:03:38PM -0600, Alex Thorlton wrote:
> > Commit 4e6292114c74 ("x86/paravirt: Add new features for paravirt
> > patching") changed the order in which altinstructions and paravirt
> > instructions are patched at boot time.  However, no analogous change was
> > made in module_finalize, where we apply altinstructions and
> > parainstructions during module load.
> > 
> > As a result, any code that generates "stacked up" altinstructions and
> > parainstructions (i.e. local_irq_save/restore) will produce different
> > results when used in built-in kernel code vs. kernel modules.  This also
> > makes it possible to inadvertently replace altinstructions in the booted
> > kernel with their parainstruction counterparts when using
> > livepatch/kpatch.
> > 
> > To fix this, re-order the processing in module_finalize, so that we do
> > things in this order:
> > 
> >  1. apply_paravirt
> >  2. apply_retpolines
> >  3. apply_alternatives
> >  4. alternatives_smp_module_add
> > 
> > This is the same ordering that is used at boot time in
> > alternative_instructions.
> > 
> > Fixes: 4e6292114c74 ("x86/paravirt: Add new features for paravirt patching")
> > Signed-off-by: Alex Thorlton <alex.thorlton@oracle.com>
> > Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> 
> Peter previously posted a fix, buried in his IBT series:
> 
>   https://urldefense.com/v3/__https://lkml.kernel.org/r/20220303112825.068773913@infradead.org__;!!ACWV5N9M2RV99hQ!YARvXhahbleGAt689pqTXJU7ko-rePIjzrbuGmemJXgFRViFZ8FDfOy7mHZQ7CPaG6Y$ 
> 
> It should probably go ahead and be merged now...

Ahh, yep - hadn't seen that one yet!  In any case, I'm glad this is on
other folk's radar.

Thanks for letting me know, Josh!

- Alex
