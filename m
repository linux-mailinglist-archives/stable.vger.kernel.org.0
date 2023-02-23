Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4762D6A102A
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 20:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjBWTKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 14:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjBWTJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 14:09:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623BF4ECF5;
        Thu, 23 Feb 2023 11:09:36 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31NGwk56016284;
        Thu, 23 Feb 2023 19:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=lywkw/TbnXMuOROFmOeTQBHo4IjYomIoZbkv6dYaSPE=;
 b=O+PJMYLhHMl/sUeffslBluZSkVgYSxs47XGwga3rZU58aEYfydoTycM+aF5gCLzHPK0U
 DNpDJnHModD50hCeZVZnlQ0NHNePPCmqL0GOe2JgQv3zI5TyNLxC1Qn/ASgaP3lJgeM0
 zL9zLpnx8XJczZRGkBSFz3cOwsCV7xussQSWDj+mpYxG2pHdUA5L70oN8q3RT+Ji9Q/F
 0YDh+R943fMNM0d/V+bMAG500xjzTH9UYCO9ZSTIhgyxGO491xCaaBRHlitDoIo+uyqc
 brT1XMc3PQKTSj2AI4MmzKfnzbaTU6jJcOZqoari2KtQxacvXHtexDpOnSGAWJaXuWug gw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpqckg31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 19:08:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31NIGE5D025849;
        Thu, 23 Feb 2023 19:08:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn48fe5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 19:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBipNn7r0E1E3gOdOqT+Yv+Jonazi+tKxkFQyrTAs9I/jwBoZ4gl0avewoWaH0MrhSOIGkzmYEyuAwu/hcFPFwJL9joEG9qEMGqe9Lvhy3Xved/s6qP4D9MzSJoAPQjmW4olsGW8TSq0wlVDI7Es9yqWqJ5R/81jJilXaZGBimjgzds/KHhyNIklW1/a+ME7Khu5IYrbz2FbVW+hOtb4hXomJ3MAtw6EeKXiShnSG1xDMAYBIkW3F/QxV0tTMij15E2f4zGSoAfL5D+P/brF5A8JVAA2cx/wuL8KXwHxIItG9PXrN2XAG/wp6HL9XKzq4ARALR6i+pO3z371z8jblA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lywkw/TbnXMuOROFmOeTQBHo4IjYomIoZbkv6dYaSPE=;
 b=MZloz76ITHmJB4fQEjNzJ08nxFDf/wecPiMAS+sMN+4g+m70pjqjYtL65yBIOfqTBYCDM7G9cKKyDgQ4Oe0mVgjNvC58kRi8U7dQDridYgnIOPe33YPl2jeAwgLsLdWF5uZ2Oiu2bM1T8W8CRfpi1YYYIRiAt/CZUX2ewiKHvioaXAVKvXWWois1q8lZxuECnXUjmvpL/O6d6zPDdUtlnKgIcnXfQoECIRvV3wTgxDkGQQ0O9egVZpW9Gle+K/f0FFdqbAjYbnqpcS+Lb0TrM04lmu/YP2JDODXn8E8ymHKJjDZ/Jypn8y0xaUEX3G8AwiYyub8TAQROaTT0Q9ecyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lywkw/TbnXMuOROFmOeTQBHo4IjYomIoZbkv6dYaSPE=;
 b=GsBfV3+u4p1xrkAlqd2DhpKNeZkkoq1fETMDLX7n2Y5JwuuyCF1BwOP1gcPR+5tQ42lMBjG5iDZRk9Y5TdsoByNIJFu/ANQETq/85RUdfP0VvRgickuqdMrPZYwYC4ZOiZf40UdLRLilcyE7t92LXzISVr7QnEmmTPoFMR3bF+0=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB5786.namprd10.prod.outlook.com (2603:10b6:a03:3d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Thu, 23 Feb
 2023 19:08:50 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.007; Thu, 23 Feb 2023
 19:08:49 +0000
Date:   Thu, 23 Feb 2023 13:08:36 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 5.4 v2 1/6] x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to
 generic DISCARDS
Message-ID: <20230223190836.fagumtcd7rqqepbs@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
 <20230210-tsaeger-upstream-linux-stable-5-4-v2-1-a56d1e0f5e98@oracle.com>
 <Y/c23lnfn42s5uCC@kroah.com>
Content-Type: multipart/mixed; boundary="v4usfuzmqzk4jq7z"
Content-Disposition: inline
In-Reply-To: <Y/c23lnfn42s5uCC@kroah.com>
X-ClientProxiedBy: MN2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::27) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b53acf0-2fec-41a7-5a3b-08db15d16522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrIVCEcC+NCCqEgGBBkLVT6EAT+TuApX1XOmzMjRnF7PmzdzrSD88LZD00zZrac41DmhCQew5To9h3zAvaG+GpuDaauqrySKTiUh2pVvAmThhKnuEA2lC0OwXij6nXL4isxu47lg/glk1LrzBezlpUCt2yNTuVWw0d36fcQr17uINoVr5uk/uCu5HXx/M/lTsCI5/uR8zlZcrZLUOmc3lx/trSb5FnyM26An9CH4ijI1QXh5zbFcCvRHW+PsMKf69IE5MailK+ClKTQINq57MdIhmOOg9OSxfZslQ7xRRKIsEbbmEfKRunCTBUdG2jGJklc7/kWWa6e/nl5teAc/q61xuHAQjC021h4aYdrHucEz1xjkd1ofJg1kcsZkj8F0TNW6KTdUIIVSttG7DWZIIqPnb5JAkxMsrLmmlYoENhNOABAQwyzX1MF/OTpSNUiGhoMW9rmf8mz9QW2wMfCkPIzucKrqt+KhqQjeTzdFo3MGmAwvz7MxTzhCoMecEW7vmyiQVE9OUtzeO/3ffMSjgccb/94AXeM72gecPL95I743X5U5wOKw+NbzBBeMLLWJ5emESvjqQCmozuiikD5sEfBlFsyeaPe4uTJ4eeVHJjfA6DpFdSvUjR4aiaxfkhwJWAmBPyeObBw9D7o50tXHlYXlJA91GbfkNJnbSso/gCQ54zpiKrpTW6CtNj7qq/tlPTU+yCBBcqFsyYDGYNWAxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199018)(2906002)(33964004)(44144004)(6486002)(6512007)(6506007)(1076003)(186003)(26005)(38100700002)(966005)(6666004)(7416002)(235185007)(5660300002)(8936002)(44832011)(41300700001)(83380400001)(2616005)(66476007)(86362001)(4326008)(8676002)(66946007)(66556008)(6916009)(36756003)(316002)(478600001)(54906003)(41533002)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmpmREhKTEk5em5uU2hnelVjeTBBWGVyb2I1TEtMSU1xa1FReUNDWlAwYTBh?=
 =?utf-8?B?dmNtalJFRmlLZXdiNmE2YnFwL3dGNGNrT200OFF6b1NYSHNvNTA4ZWd3NDVC?=
 =?utf-8?B?ZS9ESTZmMmZaY1FIcGRIL2RSZ1ZZZ3c3eDE3VWJqbFdjc0w2U3B1SzI5djFm?=
 =?utf-8?B?R0wzWDBOWEN3SlhtaUxEcTFhK3NiYUc5QzJBaGt0YjlJSUdadDZNcXR4NDRz?=
 =?utf-8?B?KzNCYlNER1l4WkNjNS96cHBZekZMVWg3K3B4VkloYlg5ZWo1Z3BSbVk1bHJo?=
 =?utf-8?B?c2Y0aVprU1NRQkFhSm5BNHh3emRMcC9OQlc3dkd5Ynd4Y05QcmswdGtCOEFG?=
 =?utf-8?B?RUJJUzJZTHhBclRSb01vRDRGMUJkY2ZLeG0vQ09RRjFnTUo2L3Z3US9qY09m?=
 =?utf-8?B?WjJ5SVRFZ0dpY2oxNERNblpXaDhIYU5sdXNtdm5vOFhPRjAxSmJ3a01lSjBs?=
 =?utf-8?B?KzR3dk5iUUppQTBHeFBraTJhMktRL3R0bCtNMDcyTzNncWFjNUoyeGI2Nlh6?=
 =?utf-8?B?YXZuZzB3OWVuWjFaQTczNVA4YTQ1ZE11TU1EbndrOC9kcGVJRjRvVjZDQ0xR?=
 =?utf-8?B?Wk0wTjhHdE0ycmtZRWZtcytGWU1YTGVRZjVJMmhOMmFxVHNxZnFDdWpJa2N6?=
 =?utf-8?B?a0Z2cVVoM0l4b0taWS83UjRwbUUwdVNqY054bjBjc1lGbkhvaDZjR2NVczNs?=
 =?utf-8?B?VlVMUG0ydG81aHVsMnJtbWRMKzFjQVRTOEREVys4TCtHaUFIRDd2cHhjTUJz?=
 =?utf-8?B?RTlxZXh1ZzNLTEFHYnhEeVNvS05pU0VTcDRXR2cxUlZ1NzhIU0RWZkQ1MnVq?=
 =?utf-8?B?UU5xSy95d0ZEeVJrQjNEbTdPR2tJelNlVFFvRXlPK3dma0xZMGJqR2hWcWtP?=
 =?utf-8?B?MFAxK3Y3cGxjOG5lQmdEaERjYVVTNGtlaW00MWpvekdNcFozdU5wVXM3a1M5?=
 =?utf-8?B?VzNIYU9QMmxzM2RCU1RiTTcwdFVLdDl4b0lHaGRBSEVJcXliNmgxRDdGSk0r?=
 =?utf-8?B?T29CdHlralZXVVpZWDBTaFU5Z0FWREpWRXNZdkJsTFRObW9rS0xUUXNwYXA4?=
 =?utf-8?B?VDBuUmMwWisvMjFjQWdramYrWm1oQVdXQ2xrazZhTVFpRHFQWW1nODJrVUZC?=
 =?utf-8?B?bmNCa0wyMTU3NDZZcThqSGNXblBVVWVCNHpsTDJNYkFPaWM0ZE9ZV2lydyt5?=
 =?utf-8?B?QXBIUThoaktyNXJhSm00ZThjM3JCbWJMdnVINnltcFl4YXM3cVhwUm1xUDVh?=
 =?utf-8?B?b0lJU29DZTRQUmNhemVmeXMydGVaSkYrRXhZYlVHQ1VnakQ5SjJRQTZBKzNK?=
 =?utf-8?B?amNoaDJXc1luVjJkY3FvejNWTi8wWTQxa0dtL2dOS0M1UlNhWlVNdkkwWkcw?=
 =?utf-8?B?MnZlZzdPd2FYYWFKdDU1SCt5YW9wSHZNUFp3ZHBRRTJON3dRRW4rS0VEeTNq?=
 =?utf-8?B?R0ZsNVBvcjBXejF4bFV4SWJDK2JWMUlmUW8rVkpIdmFxbkxydVo5L0VtQytN?=
 =?utf-8?B?eXZFQVpNVnlGRk16V3lsZWt4b3FXWnFmbUNRdEFxaWVpblFJQytNdVlQMTJw?=
 =?utf-8?B?L2N6bEVNSjhlb3hVNHRVNFRnU3pSTUdTcE9rcC8zdEd6bkRlK2Y4NnphZnhs?=
 =?utf-8?B?cElFbzVXd1pOWFVWTUt2M0k1b04yNzVqYzNaUjBIQjRpVS85U01lRGZCV0hP?=
 =?utf-8?B?eGVJRzVkcTRhdGlYRk1DYlFrRkcwWVl2SHFXUnpMSE80U05oOGlJQTM2ZE5Q?=
 =?utf-8?B?bkpFM3EwTUZ0ZDIvck04cXRSZ0laQ01VajBPZ2RRSWk4N0RKcStFUU9ESFVZ?=
 =?utf-8?B?cnlYMFcza201NGVSR0F4QWFTOGlYSW42bERvd2R1cE03bTc0TExCSXpzYWhx?=
 =?utf-8?B?Rk8zQ21ZL1lIVlk0Zml6Nm95Smd0Ym92dFZkK2x3a3dFS1dyYk44bVI2QzQx?=
 =?utf-8?B?dVF1SXZsYy9McHpFVUF5VmdVMjZSeGllS29EQnRKTHJPcTBGR0Z1V2xUWjh5?=
 =?utf-8?B?ZGU3RVM2NGVuNmRsMzU2alNYeElnc0lSNVJYVFo5b1Z3NlVWQ00yeWxtZDM5?=
 =?utf-8?B?QUFZRHk4bWRqdDNLeDlvK2dkZFRLZXE0WU5KSzBBam4xbEhaK3RML2srMEpJ?=
 =?utf-8?Q?22Gz3idTS8aG17FwoNae/O2jI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZWNjbUhHM3RtN3Y3TFRUb2JHUERtdDQ5UkIvZmJTWW5oYjl3SG1vbExBaE9D?=
 =?utf-8?B?MkVsV0dsdXV1Q0R6bzZ1Nm14ajBSdE9rdjlITVpVOXppU0hXUnJrbDdrN1JO?=
 =?utf-8?B?T1VmOWY5T3l3WTg3Vkdna09TMU5rMjZuQlZlWUNVRFJodEwvNVVHdHlLaGM5?=
 =?utf-8?B?UUxwcWFOWmdtazNjMzJyZGtMeWV1OVA5QW1JKzQydlZCWlBHUE1pZWtJeWx5?=
 =?utf-8?B?bklrUUdSUlJUODNheUNlTUJGVDdCNlU5YXEzRlBmT0krVE5VRU9oblNyL3Za?=
 =?utf-8?B?K3I0L3VqNjR1cVJsc0hWUHg4N2JwK05oTmJjUU13S2cvSzZ6cy9HckFLaEFt?=
 =?utf-8?B?My9qRXlZWVFUUVVoeXQrZzdQbE9uMXlLWTlVVTJrVEVjNHkrd2ZFeGJWSWJk?=
 =?utf-8?B?MDlJcHA3d0tLNFR2cTEvbEZIZkE2emJXZnlIaVBLem1LQW5MK1k5N2UyMzJx?=
 =?utf-8?B?b0JRVjQ4U0Jyanlib25zOENORktGMVgxZlFDc3pPbzV0MVdtVzEzZkp1NGRI?=
 =?utf-8?B?Tm1YbWd0clNscjR5TTVXakJiNVNJUHpMRXBnQ2dGaE11R3pseUhvNURuTU9z?=
 =?utf-8?B?Tm5DcTBtY2lVekNFWXl1L3RKV2lGbWQ2TTh5VGdMa290YStoZmw3QXgyaXFz?=
 =?utf-8?B?UzRoQzZTU0N0a1dFUXovSUQ0U2U5YnNJcGRlaW9oV2I0QjEwamJacWJiYnRS?=
 =?utf-8?B?eXc4aDB6VFEyTDdmSWpUT0VoZTZMOFhYK0xKWHlNdVU3MlhqbUZWdDhzY2hP?=
 =?utf-8?B?dGYzNXBQWVBYWTYvWEV4bDVrYTMwSXdYOUI2VzRjSGNmVXVYYytIa3VFWk9Z?=
 =?utf-8?B?QmdIQzR3UTkrTnpqeVFJZmJsaUR2b0V1Rlh0NHQraWN0RXlYNUIvVWlObHkw?=
 =?utf-8?B?TGtjUFdxU3NybVZwUi83WmdxZURYOXA3bzhyRXdDZWp0cERyTFVhRTJFK3BM?=
 =?utf-8?B?UkdCTzhkajF6QjJqRExsUi9FbkFSaTQ2UzFRNUJiYUlDdkNsZ0dXUldkc1Nn?=
 =?utf-8?B?cFByWnVyQ200b3hiVDJkMG03N2R2SmoxcGkzeDRTWkJJd0ZPc2lFU01Zb29q?=
 =?utf-8?B?QnpRU05WVjF5Y01yeXgyZzRpZTdnWnAvOUN4YnRkL3lzSFpMcnJXbG8vL1Ay?=
 =?utf-8?B?c3p6Z1hNcDhhOVBsT2c0ZGtTY0RpNEtHeXNOQ1REb1R4UVVQMHljQUcvTU81?=
 =?utf-8?B?V2ZBUzVWRjliOVVBU3BsZTlBbWRUcG0rREhNRUFJY0QvQ2lkTytZVTJ1SHNm?=
 =?utf-8?B?L3B3VWdLQVZJWXBiOGJabjllbFNQTi9ZcGY4ZnVRNmxyR20vUmdBTkgra0o3?=
 =?utf-8?B?TlI3OE9aWDFvTUtsNmpib0JySCs5eUxZdExYYUZ3bmVpOWVoR2VIcUJrTnJ0?=
 =?utf-8?B?Y0R6L0k2WlRMRWtkTGFsMjc1SXlvaGx1SG5XZFp0MktMUFR3UXd6ZStVczN4?=
 =?utf-8?B?K0Rkcm5hSjVNOHQwMlQ3OWw4NzEwWEU3YXJqUHkvOGphVGdFS014YjQxdTRW?=
 =?utf-8?B?UWJtbm9aVTA3Tnd4dytaRVlsN2g2YTJhb3NvdnMrNEs0NERhUjhTQTNBWVA1?=
 =?utf-8?B?UjZMcGVDT0dHaWxJR28rZUNLWjVPdGpjV0lIeWUvVVRlUmZhNU4wbmtQaXZo?=
 =?utf-8?B?bitLZmFTMzNyejZUaHdIUjhMTXovOFo1Z0RQek53bWc5dmEwYUxSTHVsWktC?=
 =?utf-8?B?WDRLNG0vanNaZWhETFNtWkhuamkxWnp6YlovZkhFU0tXaldldW9ETnN3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b53acf0-2fec-41a7-5a3b-08db15d16522
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 19:08:49.7155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7o8BO906Tp5WEL+GDYSPb2A7jqdeJf/vh9KzJJbuprTiuYwa36occoHyyRwL3PDxoZ7J+I+Y2CkPSwNw3AsXAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_12,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230159
X-Proofpoint-GUID: QMa8qYSn5GhNtzmqNmiOFaSwCI1GKuaB
X-Proofpoint-ORIG-GUID: QMa8qYSn5GhNtzmqNmiOFaSwCI1GKuaB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--v4usfuzmqzk4jq7z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Feb 23, 2023 at 10:50:22AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 10, 2023 at 01:20:22PM -0700, Tom Saeger wrote:
> > From: "H.J. Lu" <hjl.tools@gmail.com>
> > 
> > commit 84d5f77fc2ee4e010c2c037750e32f06e55224b0 upstream.
> > 
> > In the x86 kernel, .exit.text and .exit.data sections are discarded at
> > runtime, not by the linker. Add RUNTIME_DISCARD_EXIT to generic DISCARDS
> > and define it in the x86 kernel linker script to keep them.
> > 
> > The sections are added before the DISCARD directive so document here
> > only the situation explicitly as this change doesn't have any effect on
> > the generated kernel. Also, other architectures like ARM64 will use it
> > too so generalize the approach with the RUNTIME_DISCARD_EXIT define.
> > 
> >  [ bp: Massage and extend commit message. ]
> > 
> > Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Link: https://lkml.kernel.org/r/20200326193021.255002-1-hjl.tools@gmail.com
> > Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> > ---
> >  arch/x86/kernel/vmlinux.lds.S     |  1 +
> >  include/asm-generic/vmlinux.lds.h | 11 +++++++++--
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> > index 1afe211d7a7c..0ae3cd9a25ea 100644
> > --- a/arch/x86/kernel/vmlinux.lds.S
> > +++ b/arch/x86/kernel/vmlinux.lds.S
> > @@ -21,6 +21,7 @@
> >  #define LOAD_OFFSET __START_KERNEL_map
> >  #endif
> >  
> > +#define RUNTIME_DISCARD_EXIT
> >  #include <asm-generic/vmlinux.lds.h>
> >  #include <asm/asm-offsets.h>
> >  #include <asm/thread_info.h>
> 
> Does this backport look correct from a style point-of-view?

I debated about this.

> 
> Hint, extra blank line needed after the define, like what is done in the
> original...

I did check, truly.  See attached git-cherry-vimdiff

I show the blank line introduced here (which isn't in 5.4.y):
441110a547f8 ("vmlinux.lds.h: Provide EMIT_PT_NOTE to indicate export of .notes")

And wasn't sure whether to stay with the original or add a blank.
I chose the former.
I chose wrong.
Now I know.

Cheers,

--Tom

> 
> thanks,
> 
> greg k-h

--v4usfuzmqzk4jq7z
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=git-cherry-vimdiff

#!/usr/bin/env bash
# Given a git hash ($1),
# use vimdiff to compare given commit to commit it was cherry-picked from.
#
# Author: Tom Saeger <tom.saeger@gmail.com>
# 6/21/2017

FIRST=${1:-$(tig-pick)}
SECOND=${2:-$(git show --format=email "${FIRST}" | sed -ne '/cherry picked/{s/.*commit \([0-9a-z]\+\).*/\1/;p;q;}')}

# if not "cherry picked" find first line with "commit"
if test -z "${SECOND}" ; then
SECOND=$(git show --format=email "${FIRST}" | sed -ne '/commit /{s/.*commit \([0-9a-z]\+\).*/\1/;p;q;}')
fi

if test -z "${SECOND}" ; then
    exit 0;
fi
vim -d <(git show --format=email "${FIRST}") <(git show --format=email "${SECOND}")

--v4usfuzmqzk4jq7z--
