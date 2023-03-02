Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1766A7946
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCBCE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCBCEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:04:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A2348E2A
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:04:54 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NJkUN012653;
        Thu, 2 Mar 2023 02:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=bioRfOZWsQCqguFevPL5MZBTZvVe8vO2+NnHIf/OmiQ=;
 b=hFgI1c9kHo4D+vSGcTrYptUT63tiYLqreNAcwYMO7zY3my148HgI6mxcGJGqcJ9ze7GO
 C99rxMdIaxuIr3Si2iKEDEbCFBhOMpjxecrH005IGFKiYKwww5gXCRTfHTuAz5pj/tIw
 HNiCiZqxkut0TcsM1wfsZ5yyZSVZN8uSLHqtTM/lLfJsCPThQK2hoWj5LSMpsIhuRJn/
 Ez+1d2jGMa2GzyEtgTqE0gWhKQkJcCOS6pOsjrr4+VC2NyQNt5YmU/dTHsvU3XOtsey5
 41Bw5bpwBeKIM2Y709ElSbJeyHZexY0dvSuK3wqRqAFmChcjiG+eM/61a8LHvf5K/xuY VQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7jd84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3220Dma3001117;
        Thu, 2 Mar 2023 02:04:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s94f19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLJa89V1c7TVbCcnAqsXlFrsZiwFksO4P+JHngrTAB+oea0ZvzyuEJQjhb0XCZ/Q4mk6pIDTniwDGhc11z0nOlzSprzneoEASqJ1Qu3oMZiX+OfSFLsc1O70AAJi/eUt9RdMYnWhw+3mLPn+9pvocPtqxLB+cgRnI4grqs0kxeeDCQffsNiwQBKui68hgTx0cTIGuYwjhGezUB40+G96yMwUGgNliljFqilXTWz9AC3Qmwke0imQw+pemoSdWBtEIk3Iao56S0Iec2VMkfECf603L5j5aoNj/VJfmTHXXQ4NvzuRJUGgkLOP5qFU8jGWxMvyZ+edD3DlwgcIy0Fong==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bioRfOZWsQCqguFevPL5MZBTZvVe8vO2+NnHIf/OmiQ=;
 b=oedhmgZg3qj92NaFpiHcRxAZL5Ueif0POOaOcNRxy1sgii+5rlXFYGJu4eR2PjxGoaREc7QimG7/dNHkYGY544PlC+LT43cRx/FlKmxzlgKAkeSJnHwoZ9+Cqp7+1Nx0mAdyhVdXfIh48X83jW4j5ZE/QFI0T53fq9VkFSu6/WTkgMhWc8hhf5mDnz2j3HCO5Aq3A4blWjL8w1eobZFdpc5OE50N2o/+jBVhNDt9mvm11INNEUfcDTOdSWK+oQoIw1S4MCx5tiT3ijR6Db6QVULOnQpZymjtBWPxulQ4PAckmtrtZ+JZPZIffEcP7FxAFTQMmyaSrF1dNT/tMuYNeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bioRfOZWsQCqguFevPL5MZBTZvVe8vO2+NnHIf/OmiQ=;
 b=IzsyD4mxz/a6Kb1vEfAZxfMwBaoHfU2CUwuiYrhrE129oTgbJGmIAVEXT6+ofcZi/nnW92j9MQTXt1w2s+4J6ZVgnm7F8uBY6fVgzP3E6HaREag9tHu56JtEi9ZZNk+Lg3YQnzbHtRJ/LTPt1G8qUeFsS+8omWISG7vz+wXRRg0=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:04:06 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:04:05 +0000
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
Subject: [PATCH 5.15 v3 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Date:   Wed,  1 Mar 2023 19:03:47 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::14) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: b4bfb00e-7114-4857-a9b4-08db1ac266aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ONC2kOCnyWP8OESTcpEW2NK6+nqunhJm1m1k2X8Oj+f44gJAlfuPFRzkexeq6gh+EQe+Q0N5BMnvID8DA4RBP+KlYJgT3H5BBRKryy358m1R2T4INu2pFTyPw1tVQM6cfcp4bOF9B2KjXWFURAWNW6mqB7XeI06YbSzYSZi863IsCMymGXdhgSCnoJt8utcOtPhZG5d0+NFVGYfJw4tqTMG6PCNtgi5M1DBFxFfQz0ENKIciHtBQsWpWr8vZx6hu793Tf7HaQCFEdeemUFvo7XfZUQ3Iu9ECD4A6KHqU+gNJH61b9wHDsT/tVDS3GwIICw53vDX3LWWqIwW1yvrnc1CxLA/urOnAjVUruDmtc0XJcGH5jpKmDIaOckXBJhR6vwVzzaE1LgWFtWr6yWXPngL69Lcb+Se0OTO2LvBraSziIFiyIJcehZRaPBFqY9TsMbGfm/g7X7vK48E2sbZ0tYvx0VpPWE+R4ytdTOmTF73fSX6EOSGVPyu/Gfo6UKl4ASyUcSDHwtjSaCTj7IRWHewG4wbMqixp4I5hB2BjHaOCDMdPwc157d5n8gpjMXum8bXZ4HSUjVN+MVKdnHJsIeuizi6tM6nF/XPEnpXN/FSTlEd+jnNjsbWM4sHcGBMllQ05GtXTMOb1MLGxkwo0eXw8AGco0UBXq6AVPPVa8dA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(8676002)(8936002)(7416002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UG1leGdXODh4NGYvNmdKT3hXQ0ovN1prelJRWUN3SnNvVzk1WDl1S3JqSEoy?=
 =?utf-8?B?cUdKVUo4Y0daUkh1WHVDdm1KZTQydXM4KzQwNmkrSk1abGFiK2pxZnArK2d2?=
 =?utf-8?B?cS8vZXQybW80MWRhUXhmcCtaKzJEWlhOK2Y2ek0wdHUxZGdMYk91MlZualVK?=
 =?utf-8?B?ekdwMXR6NFltang0a3FsY21KMmQyV1kxa0NnK2Ntc08yVUxBdUNwTFlHMERT?=
 =?utf-8?B?azFWNmhvcG5aRW8yOUp0ZXl6NmVyTDI2M2ZPQmFJc0dmb0pOSTFtYm5Rd3ov?=
 =?utf-8?B?SFkxMXRGdTFNVktmMTZ6bmJGZ3BnZnltSWQwMHEwbUF6R2FBNjBHbkVQMHJ5?=
 =?utf-8?B?NDZTcjZEdk84OFJyK3FxRTRJOFdvUGUwTnlBWHV1NkVET2hSaDRMUjd0ejlp?=
 =?utf-8?B?TmVId0YvUGZDRHRzL1hhTVI0Nmt3MGFjaWJnb2xvTTJkVmZEN1R4a1lGRHNq?=
 =?utf-8?B?VkdueS80MjhaZzYrMENmMEwrVHVWYTQ4bGJMWVhYMkZhK2lGanhEUTZHOUVM?=
 =?utf-8?B?cVVIRW9BRGFzTkEwcDlaNnhPZWxNOWx1Zmg4cUxZOWI3T2p2cUd1Y0kwb1o2?=
 =?utf-8?B?bGRkd3IybEVyQzJKczY1Nm8wZkRiTW9zbG1xT0tKQlcxYjFueEY3RHFPdElp?=
 =?utf-8?B?Tm5QZWpocjBDd09uUE1IYTFaYmJCaDBsbVBBa3pZUE10SDM4WjZpQnNUeWxD?=
 =?utf-8?B?VE5jcGpRblJyenQ1c09ISmlkQmx4YjVPM3NZRmgrYjhKZGpoREFONXl1VC82?=
 =?utf-8?B?aVRrNWJIUVQxNlpvM0NkSis2aWg5eHlHaG9taENSbGk2NlBEMWh0cE1CMm95?=
 =?utf-8?B?MWV4NzRIOVVSU3VFSjJheCthWURpa0hhcFo2ZHhjVTdpSm41K2dUVmc2aXRO?=
 =?utf-8?B?V0crMms3OVNXNmlRTmVqbGZxZXNqcy9jZHJFdHhvUm5HM2o0QTZHNXNhQzQy?=
 =?utf-8?B?VHlaNWIraXZUZURjSHJZL2ZtNWJldFVSaEFpaklzeDNTZmRLb2FEeHhNSnVu?=
 =?utf-8?B?d24rUDE0WlBtcmt0bUQzU2lBMTA5VktCa2g5MU9Yaks5Zk9wTUExcUwrUGtL?=
 =?utf-8?B?WnhrVDdEbWhQZkFmYUV4M3RQVnNhc1lMUzlpbTdTa0kxNXR3dCtCb2NiV2hC?=
 =?utf-8?B?Q0pFZG9Sa21HSmtsdHBySUV6VTk0RkJ5aUZERHdobmxlckRDQXVnTk9rMU9N?=
 =?utf-8?B?cWxKZUx0R211QkxJUDF5cnVqZzlHZlh1NWxvcnR6V3oxcVFtUE44NURiMGZF?=
 =?utf-8?B?aThUOUsvNXBRLy93dDd5MXBobU1mekthbVJtTFJmWXZ2NVc0UW5LNFZFbisx?=
 =?utf-8?B?MlI4VmFNVEdmR1JqeGtNbGlCaGM5T0RrbEM3VXdnMFhtQ1BHWHlQZ2gwUElz?=
 =?utf-8?B?VUxkT0lrQkNmb1N6aCtKUlJMNzIweFZTSjQ2UWtGMXp0RTJOSUNGUExBRHUw?=
 =?utf-8?B?L3BlMDhsV2tPREtTQ2RjOHpQYS9Gakp0aWRYRXZDVGIvckV1YURFV3NtTklS?=
 =?utf-8?B?MHU1RXRZdGE2U1BqcVFYNkJwUGFyd05UenFoVDJldTk2R2R1ZmRucExFNnMz?=
 =?utf-8?B?S0txUG5yUmo3cTVSYXdVYng1WWI3TWY0NnRHeTVqY3ZuMERYTmNkQ3hJZHZz?=
 =?utf-8?B?UVBPazlzbGhHL3dock53VmE1Y0xKS01Vd1RFNVM4RVNMaVlQRjVDSmdSWnEz?=
 =?utf-8?B?SkJ2dWdMRWVVUHllMkdrQ3psRFVaK0F0a1hmWHdJWEx5QnBnWElzNFZnUGUw?=
 =?utf-8?B?MzdoWndqTXMwMDJtT09vMHhCdysrYTJkU29xUXN4eThkeVloMHREdDcyRlNI?=
 =?utf-8?B?S3FuS0d2czIrZE5DK2JXalpHSkdkNHVCaXY0Tkl5WW1qQkxLYUhxTTVFTk5a?=
 =?utf-8?B?eFVhRWN4eGlUZXkvQlJqNTFrSVF2UG16TjAydzVRUkxxVkFjaStFTy9BZGVJ?=
 =?utf-8?B?ODJvdjlNdDJvajQ5SHNPeTdRc3hwenZ5S1ZMN3dUdk13NWovdHVSRnB1bDVQ?=
 =?utf-8?B?TDFIcWFYVSt2NGpURE5RYXRyZE1GM3JGTFpzV01tUWtNZnh4NnkyOGVSbXdk?=
 =?utf-8?B?VVhxR29OK3dLWmRGMDJWVDRxZ2NiRUF6blZBeVErQksrdWNDZWt3NFVDSXE0?=
 =?utf-8?B?NnJsdUdLNmVTMlF2UTF1ZmVRRUxxSSs2cThZYTVMREJyWStTelg0VjE1S242?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Rm9jK1pSWGYrQW45UUt2UmdJbFYzMldmZml2QzcwQXRvdG5zaU5qanBOT3Vw?=
 =?utf-8?B?NHVzM2k3UW5XSnJoNkZ6eUQ5aWo1b3NwQUJkOWh6QzZ6dGQ4QjVQc3d6MDlD?=
 =?utf-8?B?TU5NTWJwb0JpR3VHR2JNQTQ3aHpzb1I4cDlBUFMvZERTN00xNTlQamR4UTBN?=
 =?utf-8?B?dGJDdGFtM1FqeWtIODkveTJnOS9rRWVINzNlZ0ZWYTB0TVgzNEZvbi9jbWZ2?=
 =?utf-8?B?bGVqRTZ4UFpZQlF1eGMwYXlhWkdUSkFnRSt5bkhhVHgxUkpiOW5GOHBzMW1P?=
 =?utf-8?B?RFN6UC9kckMzNmcxWUMvcW1JYVJoeDhJai9iaEcrN1F6UXVQVWJQd2ZLUVNW?=
 =?utf-8?B?L3J1S2xXVy9xbDBNWmtJdDRZWXhUVzlKelpGZGFnckk1c2Q2NTBZMUhLTVVZ?=
 =?utf-8?B?bU9QQ0gyY2k1bVpKNGpUVEE2a0pQdlZTeTlJTXF1R251NnhSSXl6SStGSWJR?=
 =?utf-8?B?cEpPN05KZU5DODNRWTlneXhMbDlUMGdhZ05PVkQ2a2s2eVFyT3NsTlZtb243?=
 =?utf-8?B?c0h4d01wZ3kzNGFDVUJkWE5FM2k0MSthc25JUXFqa1d4WUFSQjFKeVpNUnFG?=
 =?utf-8?B?aURxb0tLaThGNTZwUS9YeWRvUW9kaEpxNk1BMjJ1WHNPb3FRSm82ZCtKRXBt?=
 =?utf-8?B?Rkl2WVQ2anFUV3dsa2dtOW05QTJJTGhmL2xwajlTaEZSMGFGbHllTVo2QnZN?=
 =?utf-8?B?cUM5S0Z3bnlOWTlYbUNlVTJtTzFDOU5lWDh1cDZ1WHlZRWJ3bTdodVBEditR?=
 =?utf-8?B?VVhsaEE2U0ZiZm9icmJhWnVUY2lyaW1FeUNvTGtjamtQV0ZQakhJTUZDQUtE?=
 =?utf-8?B?SGRHSDZrREdnNm5iTnI3T0RZbTJCVkJTS0tZMUYrcmhkMXpYaDdKUnl6NmZV?=
 =?utf-8?B?eENueTI2V3RPeG5mdXk0S1Q4MFdGNzNMUVAwZHgyZ25ZVTBQRWdGYUhWemhK?=
 =?utf-8?B?T1YzQWh5VDRFTXpoa3hvZXpRdFNRSzUxZTg1YUJFMjAzTjg1QkFhRWNSRERw?=
 =?utf-8?B?cytrNFdubmlrZ1ZmSXF2MkV6b28wY3JDdFR5akpzMzNpanB2N3ExRUFOOEVB?=
 =?utf-8?B?cEtmeHVqMFpUQzByQ2hWc0dsbW14bmVST3VOZHE1Uk5HMlZNWm9rQWhCTXhB?=
 =?utf-8?B?MU53bmdhVXlJb2taU3NrWFl4ZWJaYVdxeG91K21DQjVBVFdFMkZ6QnljMHhG?=
 =?utf-8?B?VW4wZG9MRkJ3RjBoK1ZNNmpGQUZzdVMrV1hrL0hIRXFmbUV2d0xXVTB5Q1dJ?=
 =?utf-8?B?b25rOFhYNUhSbkNQOFN3WU53emg1Vkp3emVPYm80RXdhOUtZWUVRa2lJbDY3?=
 =?utf-8?B?NUxpNVJnT0ErV1c4dzZKbk9ZbWdCQyt4Ui9OdGtwUDVFK0pwNHJWR1B1SEhY?=
 =?utf-8?B?UGhzVVpiRUFocGI0REs1OWoxMWsySlJKQlhkYVlVUVV6RVYzT0JOUW9yR3VN?=
 =?utf-8?B?MWJXUGxoNE1kaW5HSlY0K1pycDlFZG14dTVzdEpHc2xUNFJSWmZtN2xlS2hT?=
 =?utf-8?B?d2M2R0VLais5UE42ekhydm0yeU0ra1pFWi9taXIrSkNUcjZHNk9NdjRUTWJL?=
 =?utf-8?B?OHVGckpLSFdMRzdpN0d1eFdvY2JXYk1TZ0dpaVpqOGdiZTd1d3VwWnlNYmI0?=
 =?utf-8?Q?j5qeP1RdE1yneV6qUl2I258nKTgx67mNgkexkcqYqaS4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bfb00e-7114-4857-a9b4-08db1ac266aa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:04:05.6651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNyzf9Id7UgaloVt7E80NnLkF7Y9SYVjJVAwH5ntMe8HRCd55hsiBFXzOVzR7OlPY6E7c5zQBLgy5FfDZK8q/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: IYAV1TdJ1MntkXqAGvUW4eLeqnHwxBSk
X-Proofpoint-GUID: IYAV1TdJ1MntkXqAGvUW4eLeqnHwxBSk
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
[1] v2 https://lore.kernel.org/all/20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com/
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
base-commit: d383d0f28ecac0f3375bdfb9a0c4bfac979f6f8f
change-id: 20230210-tsaeger-upstream-linux-stable-5-15-f7bf45952c23

Best regards,
-- 
Tom Saeger <tom.saeger@oracle.com>

