Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DDB68C6CB
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 20:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjBFT16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 14:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjBFT1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 14:27:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB872DE7D;
        Mon,  6 Feb 2023 11:27:34 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316Ii3H9005748;
        Mon, 6 Feb 2023 19:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=ywtq7wJkODQAvqemVb9ACXOjPkl8JiDzsrrwMiN0eVk=;
 b=BNL/z6c3x0KzIDlWI64/vvIComy+L4cUQ5w7yv+aKDkZPX02fdHZ/Foz4dJ2tBfLYrdf
 OOiq/RkH6Es+eiRXDVVvGzOul8Hl+Uns/o0eDt44FhATcZ2BGl7jllrJ9SfSDBxRxJq5
 PjoGX513tO9sDNds0SrMMHqGSajKiXvb1WohPSsjaZbwf2vLYUpJ1tQAIWQDDlqgEQmp
 HT8TTTjKfLicKcNswgZNhSP/iR6uLMjY3/cpVgbAwguFZngR0fZI1h1E8Ev54ct7KXiC
 18ebsEkYwYSdiokorwnv8un5unmPSsvfq9P6Obpi0Zs/7vzN9CMdwJB3h03kJ5kqf3v/ CQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdku7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Feb 2023 19:27:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 316Hram4016864;
        Mon, 6 Feb 2023 19:27:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3njrb91x3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Feb 2023 19:27:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYif/5iMT9naJv/zNaCl7/6Qu+BYVL8h5nDv+0t7zQAuwE4zeOdBj5QhnzwkcN/ht7XG7naOgovIgBm3wlyh+/mMXZuR0UYkv2ZKhoEVBhjR+Q3QlwJLISfu8ipvFUez/gZ2bugg6XA4yrrmqnSBeU11E3ClxpOzPvilWIBy+9YXa+GL8/CRxRxZPMuiouxFy98G3kcCCXW5GDwjcVYLDELX0PVORzKyXQHkb9MEjrimCUAAji8urfzdzlJuvwKteeRY2mSAKWMOPaRdf50xSK7Qfg1BuGpcdaBWmLPFI7P94vzu+hm3qEoasN6UgT/ju+F7bRBisNI0PvUFldTMhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywtq7wJkODQAvqemVb9ACXOjPkl8JiDzsrrwMiN0eVk=;
 b=ObUPC/D0yWyuYXxF+pc0RklpNz5l/DE8CatLZL21lKZITMATg3ygKx71qSK912izAEECBbP+jBsORxXo7m9PXK8h/LHLi9LRJGTGOgKezW9uXs0V/17FySbcjtzlTV7FI7yKzUZ7BEFMjE1Z6/zJVbe1zDddbWBlh27nq5yPp7J2EQUIiweXuAlP9Vm6bsU8Hf6jgV7uPOl2xa/9MhYvGdGc5FURp1MhB4xx0w/rFOv4ed8R/zhoApSdKJpTLjUKY6ttWecU0CfrEci57xJqTn/ZIn0UThduB6bnXE2hv1Q3oScMCy8SBVNHGoW2JigNFfKB9d4tcSWqgC9P2l38PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywtq7wJkODQAvqemVb9ACXOjPkl8JiDzsrrwMiN0eVk=;
 b=qOyyXMVn2eSPqHhosKtEEbTcJWsJD1YL2JoIsrUM3fYgYaDibvkW0vIZ2YV7/egKWVjcMDnibZfXqwMhf5uRQnPasln+ZVMHhf1C1mIXS9nu3JeiTNZaPB0d4okj6hgT6joEAXUiEiclLVtiMleJ/YcsK0Aw3jpOAkhevRsuCes=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.15; Mon, 6 Feb
 2023 19:27:01 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6086.010; Mon, 6 Feb 2023
 19:27:01 +0000
Date:   Mon, 6 Feb 2023 13:26:55 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 6.1 fix build id for arm64 5/5] sh: define
 RUNTIME_DISCARD_EXIT
Message-ID: <20230206192655.ydjr333ljcirm26j@oracle.com>
References: <cover.1674876902.git.tom.saeger@oracle.com>
 <ffaafd3083a1738007a3043b698ec5ac6d8d83d6.1674876902.git.tom.saeger@oracle.com>
 <Y9TGN3ovx6qqvVa9@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9TGN3ovx6qqvVa9@kroah.com>
X-ClientProxiedBy: SA0PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:d3::28) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 51f4c66f-aebe-40b6-8050-08db08781eb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 525MiCt+tJiTbocdf1VOoayZaDM3VA+xRRl3RVk5SA+Tj1zs9qjlBGCYE+JcAYT23CvvKm6u37fL8xLLsIr9ca6YSSsYX+jNvTPLeG2qwp0t4TbgJaYHsf8fhrFXxzhTM2IRbjh5OYr75MoOG35Rgar7e/gMZLyBN55uOSSR5OU6LGtADE4tQ8h5ApC4vRdafRVsI+KUHAf0EnAiTcHU2+IUvTOCI9ZSMJmGsCSnhzRGdJbJUHNmVlA9BtHe5A3AtA25rg0P9SlJOYZ9z/Ui548f2hYZ5K94sY4GO0FQfqc8B2B1pnYRu6mgL9kLb1IcBv6ZMAEGoSbQ5m4aUDThRCsViqbPYpxVrijsPFCzVxCz2SSvN74BAD1YKlL3g9mXHKPBKfLhXk77lCmHtXbBW/QnhPzA9adIWZO0PHT7xHVjOq9nFuALyQbVbRATrQzxf311Y9+gK4MLjg1M4h1G7g3xihFAGvgySwgMnUF7IgouflaVsD36kbq/+u9zH4v4VXxPyGWy1QnfC2rSacsdND/87vGUvuGcjVclqaQ35lVfksNjZUistO8xLe9Xj94ssKCG666sE9ojHca5SWUEczTPLNFqX6J4eZ18yIsprcAeUmkjJsG6xjZM9yRhe7BY2Y6NmzicQJMYki++BdHfttQa1zWTpez7jV3XjYbePk+7wEgKE0X+0fUtFuJMNo0Mxcid0DCyQxgwuBYClMBvSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199018)(66899018)(5660300002)(7416002)(2906002)(41300700001)(8936002)(66476007)(8676002)(66946007)(66556008)(6916009)(4326008)(83380400001)(6666004)(1076003)(478600001)(36756003)(6506007)(54906003)(26005)(186003)(6512007)(6486002)(44832011)(966005)(38100700002)(86362001)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk12Z2Z2UlpMdzh2VE5aWTFZbmVMOTE0ZEVjN1RsUS9JNVJtVVE4Y0NiazQ5?=
 =?utf-8?B?ZWhuZE9LWnlrZzFDSmoxUFMzc2pyUjdqeE1DMzlCMFJvOGFZNkkrbGVsbFpF?=
 =?utf-8?B?Y2ROYUFheTVKVThQSkswT0QwM1RBQVAxVjhGcHNqeGsxK1BPdkZ6enhuNDlD?=
 =?utf-8?B?a2JGV0l6UDNNREFpbm1kYUtvc1dhNC94K2RFWUhyWm1XdHI0RWNXRUNRN3Vm?=
 =?utf-8?B?U2hQZUxnVGE4d0R2WCtjRnd1SklMTFQ2S3hkMW5SZ0I0amp6VWs4RTV6NEJR?=
 =?utf-8?B?MTNOUGFvWFBValplY00xQzhTWmF4TEpxeThhSDd3MlUwYnBUR0pMbnU5ZVhh?=
 =?utf-8?B?WklBc29DNFhQbnVuV3pCQ1Z4YzdDTVRnRDYyd2pRcTlZYU1JZDUyZFI4dGU3?=
 =?utf-8?B?eDU5bzFuU2ZBb3FCb3FrdkRrMkpuMlRlM2d1UERBMXIvVk5OVVVEKzUxcElw?=
 =?utf-8?B?RWo5Y3dxemg5YmZUVXRZcjljYzBhWVlTdkhJT1B3Wmx6NkdPT0hZN2hSUXdU?=
 =?utf-8?B?RVFxbk92ZWVLMXVOS3h3YmNkMm5aekF4dys0ZHlDTStoY2YvejE2NEpUN1hs?=
 =?utf-8?B?ZEg2VmpIVXg4Uzh0RXRXVjArb2xscnZpOE5QL001d1lxcXIwRndNMjgrQUZL?=
 =?utf-8?B?NktXOGh2VUJVSnpySnlBQ2VqN3pvdmd6bjRUYkgrT2tQbW9wbnQ2Qkt6c2Ur?=
 =?utf-8?B?aDBWc1pXSWU0WjI4Q1l6cVhodStwZWFZc1YyK05lNnZmaXhWZUhyQUZrNW9R?=
 =?utf-8?B?M2docGx4TGZBb2U4MUErMG0wWVpxRWgyRHJ0dzIwdU9UZTJaVHRYWG5DOTQ4?=
 =?utf-8?B?YkZ3bytYYTdBaStTN3I4OWd1cEVWZ1hvdjBTNi9keGFXT0YxQVhrcU1BMnF5?=
 =?utf-8?B?eFhNN1dpY1lkVGJMd1FUY2dnS09ZZWlvV2NXbjRkZHpLZUtGT1FQYmMwTkRL?=
 =?utf-8?B?Vjk5VjFvY0VWbjZwZ1hlRkQ5T2ZGb0NLem5jMXVBRnRwSitmRXczVlRmWWdY?=
 =?utf-8?B?WFptdmdDanJpVkVPS2tsY0lBcGJ3djkrQlRYQTNPZjJqZjM1RzRucXJDcGY2?=
 =?utf-8?B?a3A3UmlCS1p3aGpDSlFnS2d0WSsxUkVQUitRM0xxQkFZU3BwMm9SR2lDSytF?=
 =?utf-8?B?b0hialFRYWF4emtjWUJxQWxiZTgyNkkycDJIOXB5U252OEh6eVBkK2VLVTl5?=
 =?utf-8?B?TVNNblVoV3V0MFhJVEV1emNPcTBnRHlyaFpJN0R0Y2N5Yk9lOGQvS29jS0Nk?=
 =?utf-8?B?ZmNZdXkzZkwxT2s3ZFFiS21yYWE1VmVxenJwUk9KRHJZTjhuajRKWnRMdThy?=
 =?utf-8?B?azRiSHNoT3RkaGFZOVN4Yk5QT3duQ24zRExybTlWTVEvWHQxeTVCVjNCOHRL?=
 =?utf-8?B?ODliZU1nS3FVZlBqOHdaVXBrQ1VOb3l1OTVKVm16RGVpd1RwSFpiV041WUtk?=
 =?utf-8?B?Z2UzY3RlbUdLejNXa0wvYnNzK1B4VUEyZFZ5bVkvbjlBdUd4Y2loTnRRbnhB?=
 =?utf-8?B?d0xnSXE5OHIvOUpYeWZ0OHRyYUtxT2dCZjkyMmR1R1kyVTI1VTBTNlBNdy8x?=
 =?utf-8?B?ZnBGTW9LbXdjV0R3cDE2SGo5cFM3TlE0T3VtTVNMOE1Rc2J5Q3M5R0NvZ2Zs?=
 =?utf-8?B?SnIyd0FiMUlZVk9ENnh6UFNSbmxjbWhDU0w1QVRLazBsdE9HcDhnRXQxVGVp?=
 =?utf-8?B?VVRBNGVtREpDQUdrWDBUdjBCYTdZVWhOUnl2RzhHTFdoZmR3VnlqM1FBaTJu?=
 =?utf-8?B?ZUswWGYvY3ZBSFZzLzFIalFrVDRBNVhiY25TVFJOTWRoVFpyWDZxQ2plak5I?=
 =?utf-8?B?WWZsMDZLT3lOLzRuYUp5Z01iMERlY1c1TllPUTczVWt3ZjFld1h2bFRuQkV1?=
 =?utf-8?B?dGVlamdNYitHS0tkTXNsV0xxOFo1TWVqQXI0d0JQWENSOTdKQStibGxVRUJN?=
 =?utf-8?B?Y3BYK3NjWENXL0JDcWJFRGVjQ0NaSkpyRkZzR2lZTENoTmZkS2xxbG9IUW1N?=
 =?utf-8?B?RHlucVpYTnRYdXQxSUQ4cWM2eVZrR2hqUVdEU1c2eFRuK2o5dGNjWmwxZEZC?=
 =?utf-8?B?Z1BBNHVqWkx4bDhQcEg4WXFBemVCaFF3aytXN1hQRWN1S3VSNmIwa3FnNkhj?=
 =?utf-8?Q?ypa/PRTYieHbfUvN231Lcuk1S?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Mkh0QlU3ZERUSS8xbEF5TzhFRlFsd0NuR1IyQmR3OHBoWTNLdlVoM2xYSDVr?=
 =?utf-8?B?ZnIyUk9LZjQ5V2RlVWJaZGtsNEdqSXgrMGhCKzg0SzRXVW1JV0hKVTdRbFdP?=
 =?utf-8?B?WTJLZFZLa0N4R3AwUGk0NWNNc3V0VFh2aFdHRmtFKzQ1Q3pRa0VjMjVTWmFO?=
 =?utf-8?B?NkIrbUhQRisvZlB1WWpYd2ZWeERLTGZyV0Nacnhyb2lyRkxteUhnVSs4dDQy?=
 =?utf-8?B?U1ZXbVgyaS9JeGs4clFYSlZJQ0dKR1M4dXBZTXROQjh3ZDlaTTl0cU1aUUxY?=
 =?utf-8?B?bW1hK0p2aFkrSVR5aU5YUHBqNnBDMGh3NzVUb1krWElDSEd2T2tGalhQVDR3?=
 =?utf-8?B?MVJwYlNyQ2I1bFNPMGdMaThkbGtZck9TVG9RenRPMlY1Yk5sa2JXZ28rYUpD?=
 =?utf-8?B?NjdqcE9tRHZhNUtWdC95VExTOGNDRTc5WkkyYkQ5dHVzUTBPSlJJbGVuV3JL?=
 =?utf-8?B?OXZGQWZ4QUtUY2U4dzEzdUphbzNIYlk0RTB2cG4vaE8vK3dkUzNCbUc5TWx0?=
 =?utf-8?B?dWZJNUN1Y3BIWGRJV05CU21oRU8zMXVMZ2lPczhLeTU0RDFsdjNiVGVhQ3FF?=
 =?utf-8?B?N3dUZE1CamRZZ2VRa1FuUWU2SDZCR29YWTBmYURhOWFUdnRCeUNYaTZZZUFR?=
 =?utf-8?B?Y2RtUzFTS1M2aXpWdzFYSDlTUGw0VVgxd3dKVFRITjZQeVpqL0ZyR2E4TDR2?=
 =?utf-8?B?L2hXM1ozaTNnZmlBdnc3WkJlam1HWDU4N0N2WDhuQjlNbjNOU2Z0TDhUVi9h?=
 =?utf-8?B?VVVTUXR0T2ZUTElYcVpCOFJUbk45MXIwalpyaWRnVW45c0RpTUdGUTRhd0pT?=
 =?utf-8?B?OG1sK1FGSzhQWkFiWjgrcGk4Q01yeEFTakJKNS85MUdHMlJHaGRBV2lOZUcr?=
 =?utf-8?B?V2xSR2FJOEdjeVd1Vlk4SGF5eTVVQW02UC9HZzlsLzFqUWlJWFRBM2ozZThn?=
 =?utf-8?B?Zjd2d1lwNnVMeG1yMVo1ZE10N0lkYXVGdTRGTGE5aG9SbW1qeDN3WWFNTG11?=
 =?utf-8?B?MzlxNU1YTHh6UkgrcXNreHJFWXNOMXlhdElnbnQ3T294Zms5Z0VtekdZdnhW?=
 =?utf-8?B?eWRXQjN1VnlWcWhZazB4LzNJV3BCTUlOa1JycGVUWkI0SXZiNU52SytwSGl1?=
 =?utf-8?B?U2NPZlYzUUZ1Zk04WmkxbTNVR2hEdDl6d3V0Zm1VTVYxT0FFazNiMGR4cVRz?=
 =?utf-8?B?bWtIQ0lRaDFzbHpvV2pnMWpSQjkvbkhNSmFLUkxRMTJ2VTB2Zm1YV1ZyM0Nu?=
 =?utf-8?B?dmNhVzdzRkErenIwaVNpUWtXWml5cVZIbmgvNTdJcDRRRGtwd3k3Nkt0RHdm?=
 =?utf-8?B?akRSUFRyNGVkNGpRUDBtU2FaZzNJSW4rWlVlZDR1S3B0S0IvclQ5UFhmT3RM?=
 =?utf-8?B?NmJ3UHhCVG55QU1MUTRPVVlEcXAzRjZTcmVaZC80dGVHRDh4K1JHblJHdGNF?=
 =?utf-8?B?RjFRMlJHbWFWcno2SWJPV0Y2MDRNTWRaYVlmVGxBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f4c66f-aebe-40b6-8050-08db08781eb8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 19:27:01.0531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3+WVk0Ee+WLfUbpvrCRnRO6Uunpefrfdw0fYhEEBQkScy4+13oet8jYGWMhFDJi/SlPmn/IWs2SZV+AiYwzVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302060169
X-Proofpoint-ORIG-GUID: n34W6hlkARlN6YnUiv0Qw-60CnEyrmja
X-Proofpoint-GUID: n34W6hlkARlN6YnUiv0Qw-60CnEyrmja
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 28, 2023 at 07:52:39AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 27, 2023 at 09:10:22PM -0700, Tom Saeger wrote:
> > sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
> > commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").
> > 
> > This is similar to fixes for powerpc and s390:
> > commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
> > commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
> > with GNU ld < 2.36").
> > 
> >   $ sh4-linux-gnu-ld --version | head -n1
> >   GNU ld (GNU Binutils for Debian) 2.35.2
> > 
> >   $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
> >   $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-
> > 
> >   `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> >   defined in discarded section `.exit.text' of crypto/algboss.o
> >   `.exit.text' referenced in section `__bug_table' of
> >   drivers/char/hw_random/core.o: defined in discarded section
> >   `.exit.text' of drivers/char/hw_random/core.o
> >   make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
> >   make[1]: *** [Makefile:1252: vmlinux] Error 2
> > 
> > arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:
> > 
> > 	/*
> > 	 * .exit.text is discarded at runtime, not link time, to deal with
> > 	 * references from __bug_table
> > 	 */
> > 	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }
> > 
> > However, EXIT_TEXT is thrown away by
> > DISCARD(include/asm-generic/vmlinux.lds.h) because
> > sh does not define RUNTIME_DISCARD_EXIT.
> > 
> > GNU ld 2.40 does not have this issue and builds fine.
> > This corresponds with Masahiro's comments in a494398bde27:
> > "Nathan [Chancellor] also found that binutils
> > commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
> > issue, so we cannot reproduce it with binutils 2.36+, but it is better
> > to not rely on it."
> > 
> > Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
> > Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
> > Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
> > Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> > ---
> >  arch/sh/kernel/vmlinux.lds.S | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
> > index 3161b9ccd2a5..791c06b9a54a 100644
> > --- a/arch/sh/kernel/vmlinux.lds.S
> > +++ b/arch/sh/kernel/vmlinux.lds.S
> > @@ -4,6 +4,8 @@
> >   * Written by Niibe Yutaka and Paul Mundt
> >   */
> >  OUTPUT_ARCH(sh)
> > +#define RUNTIME_DISCARD_EXIT
> > +
> >  #include <asm/thread_info.h>
> >  #include <asm/cache.h>
> >  #include <asm/vmlinux.lds.h>
> > -- 
> > 2.39.1
> > 
> 
> As my bot said last time you sent this:
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
> 
> Sorry, we can not take ANY of this until it hits Linus's tree.  You know
> this!
Yep - sorry for the confusion, is it better to send as RFC in cases like
this where folks on list have asked for the series to test?

> 
> Please wait until then and then send the needed backports.  I'm dropping
> all of these from you from my review queue.
> 
> greg k-h

This patch is now in Linus's tree. 

c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT")

$ git describe --contains c1c551bebf92
v6.2-rc7~18^2~5

commit c1c551bebf928889e7a8fef7415b44f9a64975f4 upstream.

Do you prefer I resend series for 6.1, 5.19, 5.15, and 5.4?

My questions for 6.1 still remain,

  https://lore.kernel.org/all/cover.1674876902.git.tom.saeger@oracle.com/
  This 6.1 series is not strictly necessary, as the problem
  does not present itself in the current 6.1 stable kernels.

  However, 6.1 WOULD be broken with inclusion of either:
  994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
  2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
  Should we just include these as well?

My own preference is to included them, to track closer to upstream, and
hopefully avoid 'ld' subtlties going forward.

Thoughts?


--Tom
