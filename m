Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A2B692808
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjBJUVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbjBJUVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:21:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A0081296;
        Fri, 10 Feb 2023 12:20:27 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0A5q029778;
        Fri, 10 Feb 2023 20:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kfNfns9B5e8vAxdfNNVCTOrSp6ACTnHzEBkIAFG4xog=;
 b=0BKAw6XQuYZONwo+3sRLHEzuR21+F2iIv1RgPkS0gJIsNQUsMDQ4xtJ2SRrTFA8ITlS3
 C+5yybPlp2i6HdvkgHiu5ZZdkwYSPWVuJLQeITa9oi53D91myLxuuum8rDGY/b+o/wJE
 npfObdKfIjWMwAVJmr0dYZfTJWky9JeVNrY1Ejjm8H8KvIVYW2ZfeaKBglR+hgWdovxq
 MGbqaRf5XhVMQPtMGXgoUf50qSKH8JL2qLwFi2IDyNpkm2xUEJ9JeVJm3tt0qHuuzvJz
 DlpUhl26jfpaU1xRciNiu/TMyZA9FY16DjWiyYdnBiN5tE81kmZQq1wg2F9oZpUKeItR /w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1ea38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJoiBm003053;
        Fri, 10 Feb 2023 20:19:49 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtb7hev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDGZMTs9E+qmjI6zCdtTyv+eMRJdeFCtNXescD6a3nOUl/8nNFUKCTioB4Ad1SUHPxRW/DBjyZ7THUr5IJSDLZUnl96qHd2R5fLPFTCpdDKFdZ4YwI9FvLT1mjjYtYSecFYJlWWilONlGX393ixRyoNl4WKeLPeH6/kA+JnKvhL3dWhschm09A6KP+nh2RWOilHamqoO4lGog0gELn5u8SZGXIN2M9YSByXrIdZSVPIn1U5qJFWK7Op0Idg5ImJhduSLSqv/nsy7/uRKMYxbfVKpp/1LpDMejhjVL38mt9gdFhSV52SzBzlH8SvJH8Ya5/1EJ9kF3BSrjBCMyaKGHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfNfns9B5e8vAxdfNNVCTOrSp6ACTnHzEBkIAFG4xog=;
 b=GANVaZbErifQdQ2CyB81EsIiDcX3IWwYJPxnylI1pL4qOoMpPOgyeXsdLoEPJnkF+Z/KzBDL3fQfYICwCqaC+qzVwS1ICON68bvibqDuJqt6illrAn6WI7umylZJywTPDbxqMDxQsVwFJkzT0BuocsT7DHwqSlo4hpTPq9+zMN3qhSSvjOAv/cQaVBrfS7pyeMO3gxcnNFdOwZr/DKXl6YoozS5gDO7fqVYsa22YMMSyq8uUwoSmzUy7ARgEAnNO0dfLDxSDBNHlQe9yBaqyJBGwYKthSPj8ezCrULFHAUPRaRFW34aNk+kc7l5sx8ORDRhcQVZSDoOJkR5+FZRAjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfNfns9B5e8vAxdfNNVCTOrSp6ACTnHzEBkIAFG4xog=;
 b=NOKbzqKffdcaDEgprm6QLibvlSU0MqEbETos6aH0VOX6r0XiJXqMTxJLdClX8go550wxYCZHrMoijDQ3Ke3nKVEHX/IT7toAW5Wk01PXTeo2kEWjWOgMa4bXfPhJT3Obl1zt0dIXGOPLCOIxojM+SvO/pSTBLYdWhyfEftbpwFQ=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:47 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:47 +0000
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
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.10 v2 1/5] arch: fix broken BuildID for arm64 and riscv
Date:   Fri, 10 Feb 2023 13:19:35 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v2-1-ada7b8d36096@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: ec01a323-d73c-4663-2c9f-08db0ba42781
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4JMfRyig3JdLzCjsJk0zTNGxYQmpTBiWO/B7V2joEqPcAxTBA2pYmKjxjHP7+scANuyCRtBbwwYYzYR/KxfzqLLDxfc7v2+dvZsA08JzM27PeE4iu7fVJLgNjO2rDTPam/7/HAUdOsK9cS4jDt1nlKEMcttaD4ALCbP0eRZIuOU9p5qDyAscY5zSXopRDFclzTu0HyhejoZKXfsnHl7gJKO/zjRn5VG7tE9Z5oX7+WVguFg5YHmZ4NTHkphkexZ8J2G981r2WGyIA+o8Dwan3RUrc2vrwTgPuZ/mBeB6AKQk0IAmdxQgtfBp6ASwYcPy+E6WC0Z6NO5nfWKps6s2FpqV0p3ESzN+jBANbCT40IcxKn2gHIKvu2CSxWCDUjwWQZv3Nz4TKj7AYGqKnJtUICereAdJpl83gow9yfBmd2mcn4w/NGcEZ0MwyYw+l+GrgLLjhoCHkYXGJU+6fUkXFTbzcWce2L6UOvroUllLHaqrLgv0/+tO1wvdPxI8/tc/IVGrUQSEjX84CD5gPdxzFlOs+nKgSjEBa7uWZmqW+f4R7D0cIbL8FgtnSX3AIGGbfOFgPTP0t188wzdzEyNfvk9xzvm6HSseeDSfjzB614Daswa2/EtXgulrjaWfYM7hC7WaJPPowRWFqBX+b6s+Ojyh2V3wb1/pf4uhBPIjsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(83380400001)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WThMTGc4MlBUbzlVazlMMy90c3o4MUlmUW1jS2FvckJXeEhkUXp0Sk1RQkpl?=
 =?utf-8?B?T1JlWjJjbzg1czI2YnZZU0NxM2l3ZFUrZG5sMDI2bkdHRUhuL0hFRVNKQWxr?=
 =?utf-8?B?Y0h2WE50MWpUc0gyY2FXZHlvTHdJNEVMaFBEOUhZWklUSUJqdTNJUkZacWIy?=
 =?utf-8?B?MEw2Q2pOaEdDRGNOOVNZS1VkNkNsMWVkMUR6VVBnTmI3OWxvbStveWZNNUxQ?=
 =?utf-8?B?NzAyenlIWHAvS2FTeUxqUHVjRGJIOGw2cCtlRHVURlJQekxFcUNGZjgvRi9z?=
 =?utf-8?B?UmhGdFh4bnlmcU5McEE5aFYrNVN5TFlIY2FvOEZSSVFpUmJaRjh1WkRiVlZM?=
 =?utf-8?B?SXFhKzVHNDBvWFREWmlnM3hnb2NqYXhTWit0OTVMUEpUZTk2ME9OaWlaOFps?=
 =?utf-8?B?YU9qaFJrekQ3WGltTmVaYmhTbVluOGVuYzlpL3IxVnF1aEw4VkxhN3lsSUo5?=
 =?utf-8?B?T0dpVDJJRlhVY1RmRHhHazhaVjZxV1FLWTlISi9PV2J4eHJnbzNUbFdFdEhy?=
 =?utf-8?B?d0NLT0lGemc5MEdUd2dQc3VTMHgvWlpQT1pvK1JwcVFPUFR1OXVKSER6NTQ3?=
 =?utf-8?B?eXkrTnp1VVp3MzRNc2pUTWhlaFZvbjhFam1QK3BuL3VmQy9YM0tkdEZhTmVq?=
 =?utf-8?B?TTZ1aVdNRFpFSWtseDdGaEZDUjVyN3F6NFBDNEFRSkxiQlJrVmU0NWFIZllh?=
 =?utf-8?B?OTZuM2JaMU1WaUpOM29GNzJxUlBtaXlCZy93THQ1RURIT1NsZG9ybW9lT1Vp?=
 =?utf-8?B?L2cwTGFwZ2VlaUlBV1Q3Q016Qi85TXFrVnhuSlRVRkJTa3N4cWxXaGZCVHFE?=
 =?utf-8?B?R2pzVTBGSjZUZUF2ZGY2NEcrRmlyQUZBREJvR3NsbUJ3aVpVQlJTQ3prcFd5?=
 =?utf-8?B?NzkyeHdpWUdEa2VrYjBwWHJGaVFWdmd5TUhya2pldVgvRW1Tc09tTFc3dmFI?=
 =?utf-8?B?SEhwTEhHU3JDRllGTUM0dnBNZk02dVBxUGJOeXlrVXl3N3R6L1RwOWtHZ3Ux?=
 =?utf-8?B?ekdQbXd3RkRYSVFUREZMdWl1ZHpzUTArRUZ1OHhidklmSkxlbElBTDZlaXZx?=
 =?utf-8?B?M1VYZFV1ZFBrNTFtQVl0a0ZpRS93bHNRUFR2Y09XS2NGQ1JLdlh0MS9Tc2Fh?=
 =?utf-8?B?MEIzK3R4UWtaWVdrMXh4N3hpNnplTHJPeGpIaDQ2RzZXVlpuYTA3M3ZRK1hl?=
 =?utf-8?B?SUlCRVFqdHFyVnpSZGc3NVdnYU5NZ21aTTVpQUxWazkyM1M4bVNjcytXZ081?=
 =?utf-8?B?VC9DLzdPdmlLWDdmVVpjdXpCNWRxYmdpblMvYVU5TXk1NnJvRGNqUlN5OTVz?=
 =?utf-8?B?YTI3MDVuY1hscFJQL0J0bEwwdElEeWF2QnRLMnFQRDNpZ2pyUEgreEVoNnNT?=
 =?utf-8?B?dStOdWR0cGNZb0VranhiYzdlbXBpWk5pYlhXUlVQVUE3ZFFVMXJyeHRnOWNM?=
 =?utf-8?B?V1hZRUdsN3NBZlVvbEorWTVuUHM0NVQ3eXJKYkZwQWVudE94ZlZTb2drT1RM?=
 =?utf-8?B?TWZna2dkZ01aSXh1c3huN1FIUUlJZGRtcTh3c25MdHR6Q01YK3YyVUpJbDJi?=
 =?utf-8?B?c2llSkc0NUNrQlVRbStHYlRHSktXWEhuOFpaNEF1a2RJSlZFT2dMS1F4c3hm?=
 =?utf-8?B?V25LRTdRRWhTWVhCWGc3WjRlekFuZ3BKOGdUc1E0cW93NjVkMGx0VGR3WHYx?=
 =?utf-8?B?M0IzeDhWTkdqSnc3Q3N2dmE4NnJacnY3d0I2QUpsVDlGRTVWYUsyQm5VNy93?=
 =?utf-8?B?N1VtbCs2VFF2TlFQejdTaWpRWFFuNnBQQnZtQjc0ZWZVdFE4N3FZcGhZbFY3?=
 =?utf-8?B?UWE0RnduT3BGeXRQY2JvSDdPd0FzUmlIVTZNbEhjNUNaQjJzSEkxS3lGeS9F?=
 =?utf-8?B?SUhIL3BONjJ1VnpvS043Q25yd1NMdDNXWXBaWDlMQzFhTmZjTUNBUXhFWDZY?=
 =?utf-8?B?WVNUek5LNzR2SXRSUVcrb0FhY1I4UXpKQmJDVXZuQnhpNUZlZmZlVWJoZXla?=
 =?utf-8?B?ZlNLYWNWMUMyTVZ0ZkNONEdVREJUbnBZTlFrRzNKcFVzZE5kYVdHamhhT0dU?=
 =?utf-8?B?ZUxVKzhGNkxHa3JxNEdpeWQ2WkY1Vk5aK3BaVWI2RkY0WlA5K3ZvK1ZEQk03?=
 =?utf-8?B?dE9KQ0d0NXYvMWZMRnRZR0lkRStsOTRTL0N0Q2d1RDBzTG9ESVZ3S3VjdE9C?=
 =?utf-8?Q?QPpBO1SstgryiBdDcwpHV24=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RmNMY1hrK0tSOC9FeWpiQWlNRkF2VUdhZGZqa2Y0ZjJjakl2U3dINTg4TXRH?=
 =?utf-8?B?UmdjeE9kM0grQzhOa3VYb0d2a3ZQN2N5b09YY216MUk4YU1yY0FNdDlyUTBu?=
 =?utf-8?B?c0VpdzlzVHQ3aHVZSHVaYzYzWTRPdkt2MER5bmZ5bDRlOThoODQzQlViakR0?=
 =?utf-8?B?RmQya1NaWm9qaXZpeUw2MkJzekk2eksxQWp4VDdrRnNWdjRYakUvRFFmZWt2?=
 =?utf-8?B?NkF4QnpqVVNGRUsyc3JqN1dKa21CRHZyWndWN2xwRHBoam1uRVcxQzErUkxK?=
 =?utf-8?B?bzJ3dU4yU3VSMzdCMUlnVkRsc2diMnA0cm1NWUtLQmJ5T0M0K21iSlVZQjhG?=
 =?utf-8?B?THBoNktDOW5XQ0gxeXlkbU1OdWVLYzZuaFp4eDgwUXpMcXNJR3VjamhHdzAz?=
 =?utf-8?B?SjJvd1lJanU3RnJYd1p2RGhiZG1TNVlYdmxPWnhIV2QrNFU5M0d3ejlvNUwx?=
 =?utf-8?B?TjREZjk2Ylo5SkdaY1VrQ1JLS25hd1R6Wm9tMWtyMFZVa1pXQ1dwYkhrVzYv?=
 =?utf-8?B?WGJqS2VNU1VoWUFYWm1TRFQ1RDNPY0pTR3hTTHluVGE0bFZjR1lvekk1SmRI?=
 =?utf-8?B?Vmd3WHZCQ1E0aU1wMExna2liVUxveitSTnpZcEl2cmFWc2RvTTNoWXV1bitX?=
 =?utf-8?B?UU9ZTTFrNTNpaDZKbGlybUxPUzIxdlo2bmZTdHpObUVGNjdIb1NjME44enRq?=
 =?utf-8?B?eGdmbEJWRUYzbmV1V05xMFYwQ0hqeGhyYysxTFVXaWkvcGZ6aGVMeVlhNmkv?=
 =?utf-8?B?dko1dDJ4YlczVnRneG9RYkFoUDBwaVVURS9lNjRhRWsxWjVqTVRxMk5DMDl3?=
 =?utf-8?B?MnJQZkJzMlBKaVhYcGV5MXdibmhMa0JPaUpnc0lDd1lNV2N6TWhhN3B3Z3ZR?=
 =?utf-8?B?TnNWY3FmcEtRVGdmb21YYitQcVcrSzFNMnFKMk1Da1pLNHJBMWFmY2JRMnpl?=
 =?utf-8?B?blQwUFhVdW9zTWZuYVgzVy83SmoydWtjY3ozK2hPVTRjRHp4TWxUbjJVQ1Bv?=
 =?utf-8?B?MWdVdlpOTVQvZVhYNXBTZ1dZZjVXMm1oR2ZxNFN2S3dNdmU3NGR1RCtkcnFR?=
 =?utf-8?B?cHNhZDlWcEdKSFN4Wk44bUdKK082b1NqZWU2VElqWmFqQXE0bkxmaU5BYjZr?=
 =?utf-8?B?Rk5SdFlpb0ZzczVKcUN5Umhsb1cvb1E2ZHNYWUNOVHlUMXlqV2gvRU1hZVZQ?=
 =?utf-8?B?NTRTdjZDZXZoNDdrMDNxc2J2cmFoWG9tVkl1NUdyNjF1OThjV2V4UXBKOXVl?=
 =?utf-8?B?MEFPV2UxSEtJdnhGRVRpa1NUZU84Tmx2dzNEN2RiN0lCbnBxVWF1MXN2bHlh?=
 =?utf-8?B?MGNNNEU5dUY2ZkhQbDY4dGp6aW0yTzFlYkdyY2Q2RFpaYU9aV0JrRUd2MUxK?=
 =?utf-8?B?MzNlOGFXOHhRWmxKeFIxWDFybVRuZHZCNFIrWTYwUFNnUStqRW1HS2xvRnZn?=
 =?utf-8?B?Sm9jVGZSaXRmRUtVZDZOTjQ4bXZwM3lTdzRFaEo5eDRCTkIyeGFVVFN6T2F4?=
 =?utf-8?B?bm1iRDN3eWhDUVI4OEZJWHJna25sV05lSDd6S0hFd3pKSnVJV0NBdmsxdzhj?=
 =?utf-8?Q?0xVpamHfB6TFYlEZYOyDYYOOWuz4/F5iz7F0Mz9hwKiHLO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec01a323-d73c-4663-2c9f-08db0ba42781
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:47.0251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAZBPX+hPi8RcgBMEISru1DNLrxDbENKlLzGTRPynbxkDFZAfEQYFopNMcwX8JKVeZQ+4H05RFrbN56MnJTs+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: kUSf0n_RBSwb2mbVk3WNzB30xdZcuVkg
X-Proofpoint-ORIG-GUID: kUSf0n_RBSwb2mbVk3WNzB30xdZcuVkg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index d233f9e4b9c6..44103f9487c9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -906,7 +906,12 @@
 #define TRACEDATA
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\

-- 
2.39.1

