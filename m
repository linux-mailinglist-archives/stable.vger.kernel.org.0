Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A2C6927CF
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbjBJUSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbjBJUSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:18:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D562D69;
        Fri, 10 Feb 2023 12:18:21 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwjCg019453;
        Fri, 10 Feb 2023 20:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=es59UkpmuI/8/d1o/lDijzXihGqAIAm05nKXFVk5h+4=;
 b=i/3uciqBgy6RdoIxlBz8uLzfGj2kAc41dUxm0UWTYDjxotZV3fFZkZUAHQ3sndh6iHkA
 UR6i78f830pNegIFPOz4jzWS7bSjFCP39dstbrGu4viMmWRvbuh+xizWXWwsklboQ4Hp
 YwBXcE3KCZSbwdcao/UmLeBAQSa1QFDFjaoi3CDblCm9qUimTBlJ9LCz94MD1D/JuIlI
 db98PcK2Csu8lIq6izP1hSaeIgrl3FAh6q+iaI5Vhoh/ru6GDuISLkjb43eIJ8xJWCMU
 n7rvhkaSaYfhGpdy4Rid7WeY+59Nr2t1QUy/PKPno93wROrHJMyh7opy1wci6bjSUp9R gw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu68g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AK7LJ2015207;
        Fri, 10 Feb 2023 20:17:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3njrbf8nb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAfP2XT7efaHkAUCRfCcKBZtxUIyI773SVEqnaLYLMcODVOI6J/nbVFNU245peoP6EpmB2tNo9Dqp9p82/ScsBpZR175X3W+2Rs0IaNn5czIeLHtZ/DmbXQ7a72NUFU/7R2ihbryA60oqy8BgPKQtY7dBSCwFBBudkBa54Em8GZhcQC2DbYbsAoW0QnMcJr0Gguc1JxmdK6IcUvVfT3psp9cRLTzMgBpTom7yAdAUZVR+KMyyRl9maZU1jadPm+weLKdLXVqNcRk/Xb98RjpGIULsMo1TT3+fAcE+zToUNV4glo6deEzdX2n4mOOkRzdpGmT10l8MktPZqB1EFr0wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=es59UkpmuI/8/d1o/lDijzXihGqAIAm05nKXFVk5h+4=;
 b=AZYwDhVL+EXW3AKjNLFMKDAHmcPLvovtCcKu8ukrlSWBpUVNWMI0UZsRRjuMOIn6JWboUjkfF93dfsX9ulRktjgUYuTLF68IqzTLgZbby14A3dSJVi+j6JOmvJUAysCOqNh5m2ileMteJZ5hC/roehKstz6X02pKYFKI5vRX89DD/Y784EfWojuHxLmEkAkSGZiOc6dnSN/OfTQ5Le/jJs3qfdiMTV6IPXzAoZmEr7gcLnByG4NIX4m5J4efPm/Tcu5Hi2T8UKU5XDjtFmuKZHZ1RRMw5ed7FdPEXdtHQbRagXWF5ZklighgFIYyPMnN7zcY3YeOzsl5v0ihcRinyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=es59UkpmuI/8/d1o/lDijzXihGqAIAm05nKXFVk5h+4=;
 b=a6pdZXdsKs2I/j8rHEggjC72v4QgwSFx1s0X/7JTWNvnYVGvSx9vPSRsFNp0zMcBCUdYywl7Wl0ZFRz+zz+LVlISRIzb8D1PKLqzHXMxDEqY/RT3OMqfUi/7U/jRbiBQ43m6bhyNocjgyj2vjm9zhxxfCcG5LuMWUPvZUxFCV/E=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SA3PR10MB7093.namprd10.prod.outlook.com (2603:10b6:806:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:17:42 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:17:42 +0000
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
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 v2 4/7] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Fri, 10 Feb 2023 13:17:19 -0700
Message-Id: <20230210-tsaeger-upstream-linux-6-1-y-v2-4-3689d04e29fc@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
References: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0044.namprd11.prod.outlook.com
 (2603:10b6:806:d0::19) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SA3PR10MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: 4953db4f-ad2d-4c3c-bbb9-08db0ba3dd4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UIz/tEG/x6geHuuQLW0Lm4ByHMi2ASKOrjiqwrbITNTUjQnxT+TY0xOFuJEJrpSkVAPpspuyhNnEezbq6oGAbQnDYah/tpGUOOnA1TqzJwHlsRkHq3nDEgEFLzrIYekdvQoKXmzmzPuElmOG88wtYm/oUCkG71sFtlr+5O+SYhpViX65iVpJUvFN+axzLdUt2FDtQO5iD34SDysd/1wkG0a+4l5JfjUVnwOvEjy/QTy8qDZNzPKQQibAqjVBAbe9CkSWjVlAuzkYxZxWx6P7KdLZ940zwLG/rL/brWdAF5EPysEleVFucnIDkKmOqvrJWFsOiDB1T7Kfif4O561VS7OgDdut/dTD9H3hHMqad661HefP+HYOxjcW1zQ3kKniBax2nHyemesEChmpszsCdQzm6o6UGxOsEsNzyS7MDvvkTZ6tL8uhPXV+gIFfrLQDt8oLHK37YZSywzqZlr+1Z2tZIjBMR1SC3rOEEtJuEj5xBoYm76EhM5RdEoNdanYuav8OMGiEylaXuGsrskmvoaPLw6b3d1p1HV+JooyNNMAFGLgwy8srBTijMpPoCE5Rj72kWdSDOxYmJL/wQEab8TPwLfH7doZUjR/h71dKCWe+SQRNh24XH/saJcWSJNIc3U4aUv10ECPZWexUfcKBCa363QlmkG2AbX/J8LjmvsH3HP2YOOyyNKXnuU8kX5fVx07TvacXbf1sMyv8T8X7YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199018)(44832011)(6506007)(5660300002)(7416002)(186003)(6512007)(8936002)(36756003)(86362001)(38100700002)(2616005)(2906002)(316002)(54906003)(6486002)(966005)(478600001)(41300700001)(6666004)(66476007)(4326008)(66946007)(8676002)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2JGdkNEY3dUVkxDazkxRXlYaWV4K1k4bXAycy83R3h6VDVzbk1XMzRLdVhv?=
 =?utf-8?B?OTdFc0pLaHFoUEF0TXV5Zjd5UDRXMUU4YlY5Q01CWTAreXpFSW16cmV1ZHlW?=
 =?utf-8?B?dkltNmRCMEtQdzV3YmpWOFduMFpUWHp1dzROZlNwZ1Y5czlzUkN5anhoc1Jm?=
 =?utf-8?B?T2ZuWDg3TVdJbXRGenIvb05xUnZ1Tk5USmFVUWdNb3l2U214Zmt3Wmh6bk9I?=
 =?utf-8?B?LzI3VzMxSVAwK0VjczRSRkpwRWR6QlNXRFMybU8vUG1qNlRiQ3ZFT1owb2hv?=
 =?utf-8?B?bWRTSnI5bndtYnVpS2lKVVhIWHAxNVQxQmJnRjdBUkx4V1puT2pIYVpDMnlX?=
 =?utf-8?B?U085bzhKMG9PMjJVTDE5WDdnRHF0b1lNbyt1d0xGbWhxYmYyRDM0Vit5WUVS?=
 =?utf-8?B?UWlCaGxJb2JObm45emFHRGovSlE2U1QxSTNoQzFpbkZKM3ZZVDRmeTYyVTEy?=
 =?utf-8?B?Mk90WFZrNXpjVmZkeHJic2NHSXM2VTluMms0ekFITXg3b1dwZTBiWUhCaTVS?=
 =?utf-8?B?ZjY3eUdpb01MNmFvcXBqMHZaS3hMcU83dlZ2WE95R2dJRHYwdDkyc3lJZVhn?=
 =?utf-8?B?alc2elhrVXBOUzloV05MRFdrTm5lR09TUEJRMDh2dHNtaVc3eGtYK2ZyUFpa?=
 =?utf-8?B?M1hnd1JEaDRkMERoQ0s4VlhPb01ZR2pVT1FHR2FJSTkxb1E0b21YdHJaM2hV?=
 =?utf-8?B?bUx6UWZGNmpEcldMMDF4TkFyNlhSNU1Bc29LamRSRVlHQ01Ea3I3dHA3Q3NL?=
 =?utf-8?B?bkozc3BDeUdXMTh6MlkvRHZUclpMK05pSGQ2YkJ6UkVhMEprUklsMHhycVNz?=
 =?utf-8?B?bS9jNlA1MnR1enZ1dGZiUFNlSWZHc3dZVko3NHA1bjJQOXZGa3BBeXhmOTA2?=
 =?utf-8?B?RnlYeXVpNW5HZXlodlBMMWFaNDZZMFpaTG40VWltNnBieVFSczl3S056Mkxw?=
 =?utf-8?B?aXRVY0cwRVQvYkR0Z2xZRjUvZGFXamZTZmNCYTBicXZYK0hvKzZJbUV2LzdZ?=
 =?utf-8?B?Qk94WGo2UGN0M25Od0NBenRraUE2V0hLRWpIN09VVm1oVDJVMXdZaWdYMHdZ?=
 =?utf-8?B?RG0zUmpXaXBpV1hDUU1KRGpRTGtaSGJLMFVFd0I1YVZMZFkreEQ2ODRqd0R4?=
 =?utf-8?B?TEpIcGs1RjA3UzlvUXMwUzN3TG1UN0c4eE9sWjNZc3hPV25GZWdWTTNXbkpw?=
 =?utf-8?B?UHR4VkI4QkFVZ3FMcDIyblBJWWh2dm1oZzJlTnR3SVpMZlZKMDZjRS9ER1Zw?=
 =?utf-8?B?UEdLempTNm1IWFdSQXBHcEwyOFlPdGpaenRaeE9Mc1d0bU1ITUFxd3J6ZnVY?=
 =?utf-8?B?QTBvd205YlZEWjY2S0VUV2tLYU1ZeHEzY1VKVHdxU3lXYVJ3R3F2NEJ1OE9t?=
 =?utf-8?B?Q0wyZVJjNU41ZkdLblZVbTRaSlFZVFdZTTRKRkJET1YrTnYrNlVaUi9BSW5k?=
 =?utf-8?B?WXZTcmNqR3FNMjVmYlpKZkw3SkMramFvUXhjZTBzQVNsUjVYSzhKN1o2UGwx?=
 =?utf-8?B?ZmZldVEzSTFENjdrdG9iWmRnMytzckFRVEVZTlpaVVFYZ1AyU2VabitzSE11?=
 =?utf-8?B?anFBTWNTUkJ3RzgwdUZyenVtbHVrUWxoV2YvcSsrTVFMUGw4TFp0bzFvRVpx?=
 =?utf-8?B?M2FwZEdiUHFPYWR2QUxHSEQveTh1cXhJVkVxZ25hYjlvRE1kQytnUzhJZkcz?=
 =?utf-8?B?Q1NLNWlzM3NCYitndmVpb0xZV0JmR1BzbmJPRHl2TWFGako5VGY4K3BHWVdl?=
 =?utf-8?B?ZVFCWDl6aUk3R1hua0F0eWYvdEdhMnB4dk0vaGNnU2o5T3Zrd09paUJmZUxM?=
 =?utf-8?B?akZlTGR2c0MzcmtYWkFwTlJIdEVpN0dXR1ZqdjFxK2xRM2VMWldVczUwY3hX?=
 =?utf-8?B?cnhpVWk5cHNWYlJXOHgvMWtBSU9vVm4wT0VQVWVZTlpzaDM2OUo3amNvclh4?=
 =?utf-8?B?Y3ZsSFcvUlZqQ0NWaFNXeW5GUEtHd3Y2Vmd6NTBCdjZWUWZTZHRlaWxJUGM2?=
 =?utf-8?B?aFREVllhWm9tZmtpalRKWEh3aHdKRlJrdWkwZkFTZUtsNWpPYTNRQ3pGdnZO?=
 =?utf-8?B?M3V6Vms3TW4zaTdrRTR6NzhRdmxSMGZxTUZwNXMwdzB1QVQyT1JRUlI0SlA5?=
 =?utf-8?B?QlZOUmNGL1VQU0xkMVhEZnNHalBIeGxRTWxldTB0UWViVjRvVWdpVWlnK29t?=
 =?utf-8?Q?efL+lhc2Mq9KwJCnN+NaZVk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WHE3d245dFduNUJIMWVHM29Xb2czTEFPa2pxM0E3cmw4YnAvL1o5MVNhR3Y0?=
 =?utf-8?B?cXV5WjhsWjhNaDk4Sm1qSzZjU1lMaXVOVWRhUWZUUnVLNEsxb3A3aXA0ZVJC?=
 =?utf-8?B?VlRwYkJaZnJNWGlHQzNMVXNnN1Z4TlRsb1lpY0RMbTdtWmpCUVdCNEhwT09p?=
 =?utf-8?B?ZjRtTUNmdE9pQkdENWFoRjk0TmlIVHRra0JtTll6TUZvNVh2dEpaRXJtMTVS?=
 =?utf-8?B?dDlFTUFnMTdMOGNFZXhiU2R6dWJCNnBIVTlCK0lnUkZ0M25DYkF3TlhMREVR?=
 =?utf-8?B?UGIxUVlzN25pQ0kwNGZKb3JEYkRLdlVDQ0FMbW1hWHUwYlZhTEJTa1lwZGZZ?=
 =?utf-8?B?SlNmMTV5Tm1GdWhCbFlXWmdMdGN3WTZIWVhqM3U4QzhSVEs4ViswTlNzallz?=
 =?utf-8?B?bE1ITEN2bTExVGNUZ2UxTmQ2dHF1ZnBzczY5d1crNlZIRFhOWExOWHd1OVlK?=
 =?utf-8?B?Sm9jRENIaWcxTUFsQm5GQ3FrRGx2dlIxdFk5cDhBL0FCbmVyOTcvTm1uRlBC?=
 =?utf-8?B?MlRzeVVCYVhFdTkwUzNpVzliblFsa05zakdFcnpKT3JhM1VWa3N3NHlrRXlE?=
 =?utf-8?B?NjB3NEZaS2xRNDcyZ2QvRXRZSU1SZ2g4YVhmMndnRGtuSHRBRCszNWd0UVZo?=
 =?utf-8?B?Vy9GSXRIK2xzMTZKeEVaUVEvcnQ3MjhaRGxpM0pGMXBBUTVwWUNsZ1o1RWFw?=
 =?utf-8?B?b09hSlZJWHlrVUdtbzVpSUJvbTN4LzlPOUNSNmVMQnhOK2VOVUZZanpDandr?=
 =?utf-8?B?a1VCVDZCZmZ4NnJtSUF6bmxUWXBXajc5Q1AyU1gzRmN1SzZTOXlCblI5KzRJ?=
 =?utf-8?B?WE0zcjhkbzI2cEpCVjZLTytKL2dMcEo0WncwMGM3NDV4aTJwaHJUaW1vUSti?=
 =?utf-8?B?eEJxbktkaFpqMEUvMXdmTnMxNUlmT1lhVzFrTVhOL3FTenVUNTBaMWN6b1E3?=
 =?utf-8?B?b0s0cWgrbkhsenFEQWlkOG1JTkpUei9kY1psR1l3TG5MRDdDWlZCS0xGbGVI?=
 =?utf-8?B?SVBNUXF3VlpQUzQzUExNUjNFWFE0QUdDU292ZjB4aEdVeFhVS01Qb09XbzZx?=
 =?utf-8?B?bW5aUmNpcjlXWWprREFFUStLTUJqaElqVlFFdDkvZkVXZjZGMk9USmRyQURD?=
 =?utf-8?B?Vjh5d1M5aVlEQ1JxbUxMR25EYUdjNWMzYWlLNGhUYldMbzdhQ2QzSHlQaWNa?=
 =?utf-8?B?My9tL1RoRUhHeWJnQ1dZcHdLQXBkd1hibXZCTk1tV0xUWk9Bd09NUmw5aUxS?=
 =?utf-8?B?TlloQjZpMzAxQjRCS05pS2lNMmJUUkNmM3dicWNWeHl4ckgwLzlFZExxNGJm?=
 =?utf-8?B?WWhuNHJtbjhGS0VzOUM2a0U4aE51ZEJsTjBCRVdVSkw0Y3J3QUQ3WjFaenNE?=
 =?utf-8?B?c0tMSEF2WWpiMytZUTZ4a2xvTkpDT3Y0VWtDUm5yTldNOWU4eDVSVXhkTmZ4?=
 =?utf-8?B?dG5kQVZvbHhUZjFJQnptOXlDa3BRcUFiVVhZNVErMXRaV3YrYXUwcVN0SnV2?=
 =?utf-8?B?QkVkWVJHVnNIV1d6d1FxTzRla2ttaGhsSmRtQVU3b012TU52UE56Y1R0UGhD?=
 =?utf-8?B?aU5DS2krWlhEaW9CSlN0VXpCL21lOVNHQjBBbmF5ZHZweisvdm1uUHhDNkV6?=
 =?utf-8?Q?ydmvbjKWgIF7fKcQTJdO4lNE+AWRW1zkx5Rq0FrkmCHk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4953db4f-ad2d-4c3c-bbb9-08db0ba3dd4f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:17:42.6278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: py6r9x255QxbX/ZnlG+O6bnp+U8JmVux9v7qA9jNwMF0NgHtN3OM1ElRI90mbFuONCQwgt8G/yqSw2q8X8UUFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100172
X-Proofpoint-GUID: 2p0aWzaMFdSk4rOiEdhSD7fWktyiKJYj
X-Proofpoint-ORIG-GUID: 2p0aWzaMFdSk4rOiEdhSD7fWktyiKJYj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 4b9880dbf3bdba3a7c56445137c3d0e30aaa0a40 upstream.

The powerpc linker script explicitly includes .exit.text, because
otherwise the link fails due to references from __bug_table and
__ex_table. The code is freed (discarded) at runtime along with
.init.text and data.

That has worked in the past despite powerpc not defining
RUNTIME_DISCARD_EXIT because DISCARDS appears late in the powerpc linker
script (line 410), and the explicit inclusion of .exit.text
earlier (line 280) supersedes the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 136). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier [1], causing
.exit.text to actually be discarded at link time, leading to build
errors:

  '.exit.text' referenced in section '__bug_table' of crypto/algboss.o: defined in
  discarded section '.exit.text' of crypto/algboss.o
  '.exit.text' referenced in section '__ex_table' of drivers/nvdimm/core.o: defined in
  discarded section '.exit.text' of drivers/nvdimm/core.o

Fix it by defining RUNTIME_DISCARD_EXIT, which causes the generic
DISCARDS macro to not include .exit.text at all.

1: https://lore.kernel.org/lkml/87fscp2v7k.fsf@igel.home/

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-1-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 8c3862b4c259..c5ea7d03d539 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #define SOFT_MASK_TABLE(align)						\
 	. = ALIGN(align);						\

-- 
2.39.1

