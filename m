Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F5F6A150A
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjBXCsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 21:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBXCsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 21:48:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712BE93F1;
        Thu, 23 Feb 2023 18:48:17 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31O1nIpA005085;
        Fri, 24 Feb 2023 02:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=nOj9l0th+lLytp2n+D3LicigJVlS0aOhK2WQsxUUoow=;
 b=1xHjAdc7Dlo6yCoBP+KfA/PccwyBrYniSQYuoElj81RJOcEBXkRSOOKn/T9fYX4zVg6z
 GU8MwkS+i9++DLK8KbhmTZkBNGMcGY1+MaulTX5HseeXWykWhpQzoBycqWdExNh9dYNY
 5SeqxDDKtjfVAMREvD+FkRmrsdsqc4ZoGFhXOa02Ao5S9YOIqkkengOebj43WKS6aUWp
 JuNJCkbj+lzSTGy9ijNMCqOQ83x6NLnaYa4IvrhqJLrzfZ1cyD9faKyOQWlhLW+MDYtW
 kPJc5Z05WQ2c52jg+RMkGn3RPBgOEaLe6cvMAW/SvtPLXcSdp6VOVZzPkBIKMEels4J0 eg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntq7um037-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 02:47:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31O0LRxF033994;
        Fri, 24 Feb 2023 02:47:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4g9ddt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 02:47:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7izVHCXtFjaGz9y3ZrhlEExP/WzedBSUKTc3t/DIjfxGfEDdIKLU/FU0ZzvuQ3q8YJe0if8rySwpDjut+csRjbh6XzFCvw/SlsEoMiogSdyUOHtdD6wKpD9iRUkFktOZHWGCkTXql3ZG8MbowyGV8oVJHKkld+lFwtQxeMY4kXBRkFWZHc3DcSq8kcOl9S3EnclXNnqZSoX/ByyyNkW+ACAxwcxsZu0O1xt44OJL10/4Vlfunv3Wpf4ReHlv1Y9BZ60zat9QjSgvaF5EdKNVRoK2+1Ka2Yo/bt1rugUIVG1xjFWHIuA3rHDFTj8XvoJGt7N9vJ3qL2JGEAhSo1DiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOj9l0th+lLytp2n+D3LicigJVlS0aOhK2WQsxUUoow=;
 b=GP3Srb+pdpWWKnulXyYsUDVJE6am7xCauEXAh7yFbBhE5P1tXyKkwPXH6WuqJDcexWwV5GBppIfvbraliGmMF5he7cM7W3p6RecO21xSUBKM3y9TjxxXPEv9pE7b6KO8aorLava+akGS3bguBZGUDRhXefAzsSpE1qsEtPfI9PivddtXeGBnGEjT2U+JNuh24I2PwgMQ4oGrxPD1Y4z75/A35mu8GvCiCKKN6D81bZLvcDdDVYI5TnDz8GzEnctDuJ506Jh4tQxG9ElcAa389SZWL0qerubhn0+GG2KlVaPCJC4aSlpKiSHypuI253zFImqZ6DZK828dscC5QSztKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOj9l0th+lLytp2n+D3LicigJVlS0aOhK2WQsxUUoow=;
 b=NuzJGcvUScdmIwojNj5rGkeP5ncNXanF80b8RWd+SEnJNVDq5kustfzALLU0Rk8Cm6tzX429ArDXxpN7zAoAzeHtd9kipTF1/mDv8QVMmybPiRMqV3CMnh+8BgPYPcVGyBL/dyClT5+wlHpfD3RoKnYynItxZAyS0O7hKmHtyMY=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by MW4PR10MB6485.namprd10.prod.outlook.com (2603:10b6:303:221::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.11; Fri, 24 Feb
 2023 02:47:32 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 02:47:32 +0000
Date:   Thu, 23 Feb 2023 20:47:24 -0600
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
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5.15 v2 1/5] arch: fix broken BuildID for arm64 and riscv
Message-ID: <20230224024724.whvtsrljz5k3jpln@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
 <20230210-tsaeger-upstream-linux-stable-5-15-v2-1-6c68622745e9@oracle.com>
 <Y/c3MSvnN4DcvzSx@kroah.com>
 <20230223175331.7tsgvkvcur6wl7h7@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230223175331.7tsgvkvcur6wl7h7@oracle.com>
X-ClientProxiedBy: SA9P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::14) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|MW4PR10MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: 830ff185-991a-4a5a-3a3c-08db161179e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVcbhMWXtGC/WDavb9Cxm77Wimj3E93b4PwT0hGcnIDsQ7PY7Vs5D2Ex6SbDBdgOgEvWkqDM0+MJB3VlHjkFHaLEQ1qjCUVqRrPoxlHGQf7/iIGHQs9NMNcOf3M++nKvyzQiSGoj/N5P6Aj3A9+0TSCrwNKEz0JR1Am5jdmoeAj7nGhL9wtyZ3cvZosz1lA3592Ox5GeZhC3MZ6gmdn3qYypyzjQKJxpZIaIQi+NrZbinf9I3pJfYsTYa0AQS12SaMSsr0wsWizZs4AYCvDZVK2b/NgBTx/oH292YRb+bOb9Tmd2pcpf9kTL3l2DnNc8wLJd+gD94MlXz03kZWONk5QcYvtXNIpCjBOqI12khD9u1uWlAT+KVWIb+jBCsZTG9akT0uTuyDVSStvwCTCwbbaWOXLUWcvHxQBSxTJu8k4XR1mGQGVqb4cVUfEb/DIRUFVN8dC7swLBViagIKhCgNOXYLpVr3LvA2w9t7k69rfsAooOxZcVQWWDE/cZGRmsJXQ6sQ9qrcnDc1E9MXR7+66gZ6OQ+sTlUtjTdKE0R68MNU4al1VXUjcFgublHjJsQVCdcB41SVtQijcapQ0gVNb/ZXskyQW63hD/crbm9BjUfq2Luin5sbWVUZKOSES4fxivk27AKugAIyhvvap+BrvGBE6LQnt6P8yzMUhTX9s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199018)(8936002)(7416002)(54906003)(5660300002)(478600001)(44832011)(2906002)(6916009)(66946007)(41300700001)(8676002)(316002)(4326008)(66556008)(66476007)(6486002)(966005)(6666004)(1076003)(6506007)(6512007)(186003)(26005)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk1jQXk0SUZrTHBhVkR5T09MRGdlNUU4d21qUWx1c1ExcTVmN3FraGRURDlr?=
 =?utf-8?B?aTMzZVdkLzNsQXVHMENqVzlVMnZXaFhGNFp4UEdmZFh0K3dMNExBNXZlMHlo?=
 =?utf-8?B?Uldyakwzd2taa2pEYThYVXBhcVpGaTRCYnlvS0N2Y0Y1MHdxM1EzQjl1K0Y2?=
 =?utf-8?B?QzFkcy84UHJwY09JWXd6UTBuTkdwTEhrT05tQUI1RkpWNWZZNEtjSHhIbUZo?=
 =?utf-8?B?MWFVUHQzcG5zbUkvdzl0YWRxamN4UHBUeHgwVVBWZTFqQkxjU3ZueUdxR0lV?=
 =?utf-8?B?Q1BwblpCMGlUTjUwbDRkdVIveEJ5YXp1VXBxc3I1c0RPQUFmUExNd1RxNVpL?=
 =?utf-8?B?S1hCaDQ0VkxVZnB5OGM5bmpCTTFHRVcwZk4zMEFUUk1mQWtQd0tuMXR6R1RQ?=
 =?utf-8?B?M082dDIzZTNwY0pUYVFYOGpnOTlvVUFONk1wUTkxZm91T01lRFE5ak5JTWh0?=
 =?utf-8?B?WEszUFZDQzNFVVdobXd0SG1kdHdhZmtTZUp4UnBpOElISEZqVlo2UkxCa2Mw?=
 =?utf-8?B?Sm9ScVd0clY1WHgwQU90L3BsencrLzBMTG8rYmNZR1Zka09rVCtCM3F4bk9H?=
 =?utf-8?B?UjNZNDl6L2J1VjdIaWk1UWlSc3VsYW9SWUlRZE1hbDROQzZlaWYyQlJaeUpN?=
 =?utf-8?B?T1YzZEk3K0orbXhCSHR2K0VmQ3l6Y2QyM2JsRTQ4MVpDWHpFWGFSU25iaWV1?=
 =?utf-8?B?TVhKbjJjNWs3R0VabFRqSVRmMlNQMkJqdkZqUFdDY1NNemxrT2ZrbFZpTys4?=
 =?utf-8?B?M2dVckVtS2FoWXNSY0d0dTFDKzBCRGxGSXZnc00wbnhPbWNhZThGN1BRVG9L?=
 =?utf-8?B?TitydnV3anhkMGp5RldRdFA3UDM2R2VZMm8vR1doRWkzdzhjWTllTnFycFJM?=
 =?utf-8?B?NE56YklsOEQ0L1FkWWtYcm8yMnh3WncxOURGNEZZbkI3NTJMcHo5S09ETzdt?=
 =?utf-8?B?bnM3ZVdsbVhsMzRHSzVoT2I3amJ0aWhVN0crcVNrOFljLzQ5SDk2cXlaRVZJ?=
 =?utf-8?B?dWpOdzYybkNWNlhPa0lnaitrcDZMbzRtN3dPVlBvY2haUzJrZHF2VUdhbGQv?=
 =?utf-8?B?cnBNRnZZRG5mSW5YcmwyUHZFZUhLUHRablBiZ24zTXE3RG5aZGF6b25NMFBX?=
 =?utf-8?B?Zk0zNTBHb1JXbEhuM2ZyV09FTEdGRDNIYS9DdWJxS2F6TFJjcUN6RmE1eGxM?=
 =?utf-8?B?Yzc0Z1UxQlpkR2J2OE1CbTR2NWU1NURsVmR5TWdDUVRyaENIS3l4WG9qM3VM?=
 =?utf-8?B?UThuWnMxa1pFSW5paWN6OUN3Si80N2VOY2NaQnAyWHBIYVd0cWNzMzNvc2tW?=
 =?utf-8?B?TEZpWHRPMDR0aFV1T3NxNW1OcFAxb0VJQzFPeE5yRjU1eFJnQmtZRjk2eFRU?=
 =?utf-8?B?dkFkM0EzbnVqdk5oNW12Q1hhcHlNS2htb2Z0UjZhclAwSkpITWRydG01U1hl?=
 =?utf-8?B?RmJEMkZIZXAxZkhsc0xpL1ZQU0V0WTVuLzlGVXVGaGFieEo5TVhrdmdsYnlu?=
 =?utf-8?B?R2o2TGJzL2hEdFFHUnltd1MwZU5GRzJpa1p5SUpEc1JhUENvM3c0V3N1ZWhq?=
 =?utf-8?B?QU9zTDhhSFpQYW1TQ2FFQW9UQlN4cUJFSUVlYVp4SUlJcnVnL2J4d0IxOTkz?=
 =?utf-8?B?WkZXbWpWTFJUdzJVN3MxZUkwcEFFejlXUkFib2JHaHNyWHBtWkNicGxZTUdB?=
 =?utf-8?B?MGJ5eTBnQkV4a1JDeEdKVDJYM0JKaDRJem1EVnp0ZmRUOTFFRi80VlNmS25D?=
 =?utf-8?B?SW12RDB0elgva2JCTVNWS1hvd3U3SkJqV2MwVjBSTWNYancvNkNPdFJUYzM3?=
 =?utf-8?B?ekovVlp0TE92V2tzc2pwY2E1OTZCSmJic0tHbEpvUlZnUWwxUURubERkOEVr?=
 =?utf-8?B?RjY5dDA4bExHNW5udW40TnBzeXBwMWk3QnJDUy91RVk5NEdTVTBROC9UKzlH?=
 =?utf-8?B?bFp4VmliSVZZNXZ4UnZQUi9LalhxbVN0ZENWMTlCQkVqR0JOaXBQUGdUck9w?=
 =?utf-8?B?ZTRwbEphQUVGZVFtM3B4UEJrYmQ5MHhxRjVCS2Q1dERnZkt3QmphU1paTGNN?=
 =?utf-8?B?ZzRIS3ltSEJJNU5ZT1pDR2pvYm90UXhNMmdmOXBjRmd4K1FHTlgrcVZYbTR3?=
 =?utf-8?Q?7wCCr/u77RtrP49C1tAa88ZM5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YlZnLzZqN2t5bmZRS2M1Rmk0UitLUTFUSVRBVmlsYzh5OXpDV2ZLdlZobFFJ?=
 =?utf-8?B?dnd2ZTA5djFBUEpTU1kzZGNhRlQ0Z3ZrL3d4YTNSVXdDZFQ1SXJKTkdhYjNz?=
 =?utf-8?B?TVRzcTUwazNnR1poOGhQNjdRaDY4Zlpsbmx0enBObG1FVmNseXlGU3BkZm40?=
 =?utf-8?B?dnl5SFoyQUNUbEVUYnExLzVOZTFJbXNVejRMT3dvRlNxRmZHaHlxSUtWRGtY?=
 =?utf-8?B?Y0NHRlkrQzJ0NS9Sb01oR3JHL09YRG5LR0dRRktGOFZyN3ljWWFQTTljYk9m?=
 =?utf-8?B?TmU0RWNqS25mVUUvQ05ZeGxkNGNrVGZ6L3pORVdoRXRuRUdPcjZySGU5MThz?=
 =?utf-8?B?VVdqN2tIODVSUGUvNHcwbnR6SU5UemthTGNqb05kQ1MwTGZLaDJ1NzQzWW81?=
 =?utf-8?B?RVNQN2JQdlVJM0RSOFhCdE5XZVRsR0ZqaEVEU1NzOUY0UndoNmw1S3crNDdz?=
 =?utf-8?B?MFEyR250Lzg2c2xKWFAvUGgxV3ZQcVVHZkgyNnhXS0o5VngvRVlnQ2JLdkVX?=
 =?utf-8?B?MzMwY0U5emo1cFYxRDAwYXh0WjFHRzI5cHcxMHl1Qis3MjRra1VlZVR2L2kv?=
 =?utf-8?B?aHoyNDVPa3JMZDFGdzBoblVTMVU1RUt1MGdyRWZqWjRSZmxlOTR1cWRoWUtI?=
 =?utf-8?B?NGNBYkIyTlZjMG9XTHYrY3ZzMzM3c1h6cUJzcU9nNzZITzdzYTJuQkxDaUhn?=
 =?utf-8?B?Wnc3REtxeWhpSjJYRGtRREJTTXA0UzNNYTE2akVhRU1aRnd1N3FiWnVDSllr?=
 =?utf-8?B?UFk1SEFOc0NXMGNmQlhFVlpFa0Fud202N0JSbEZTR1pvN0twK1RnSVpOMjV0?=
 =?utf-8?B?OTJZcCtseEh1SnF3dGtnM2RFZ0o0dDZkQ3ZIS1dpbG91Ynl5QTBFME5uUzNV?=
 =?utf-8?B?ZnZuMk1sZ1VNa3UwcGZ6Zmo5WVF5Zkl6K3RwMmZ5TTg3Y1NCUHEwYXBIUEtZ?=
 =?utf-8?B?UEt3TllieS9JUlNvTHNYWVY2NkhWdjdEYmNPZVpTUlFHdytLMmNBajZCeXA2?=
 =?utf-8?B?SHVXaFA5ZmhWWUpMSEpIOWF0L3BUUDZ4dE9CMUpUQWoxVmhSTkhWR0JPa3pZ?=
 =?utf-8?B?TlEzU0t0VEQrVDFOblI2QnJSa1FmUjloMElPVCtvU3BXS0hqYXdOMU9IUkI2?=
 =?utf-8?B?aXJlYlFHc3VoMHdyTjFvWEVWSjM0Q3pjUkpJMEMxZVVleHhBcWlxbWNWRVQ0?=
 =?utf-8?B?MHVJTDB3MnF1R3loODhmczJUT3l4UHpJOW1VeFhjOW9salU4S09NMllnSUNS?=
 =?utf-8?B?Z1hDMEp5K25iaElIUEhucVhnMDNhSDVHcERMMWU2NGI1VGZnaEYvL2ZuYlVG?=
 =?utf-8?B?Q3NhUUxET08zOGpkalhMNlYxaVFONmRtcXVhM2V1Zzd5aHkveUtIOVd2WUp5?=
 =?utf-8?B?N1BCWWovWk4zRWF2SWxVNTZ4Vm94TlpSNUhkL3ZNclhaSDBlemI2Rjk0cFZm?=
 =?utf-8?B?Zk1MMTQxazBKbkNDVXVPdGx1QkRLd0lXWmIrSUdyM2hrcUdpT2FET3VVOWFu?=
 =?utf-8?B?b3Yxb0FXRm41MDhIQ2E5S2pFOHhjYTh4MHBNR2dVclZHczE2ZVA2Y1NEMDNq?=
 =?utf-8?Q?ipBHbdCffIddaLrRelT1oGXlqTExO2b7NKcSkmUunHMErj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830ff185-991a-4a5a-3a3c-08db161179e6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 02:47:32.1880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lnSS7CHOsN6j20EPv0wHOCy0qLZijgwztSkiUETJ0fF0lNk4SN/jnf3bzc+BtFxBZL4GKaK+Dud23ExejqpwYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6485
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_15,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240018
X-Proofpoint-GUID: t3rVOMCTbiIo9MlzzPjXcRrQXyMpdnNv
X-Proofpoint-ORIG-GUID: t3rVOMCTbiIo9MlzzPjXcRrQXyMpdnNv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 11:53:42AM -0600, Tom Saeger wrote:
> On Thu, Feb 23, 2023 at 10:51:45AM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Feb 10, 2023 at 01:18:40PM -0700, Tom Saeger wrote:
> > > From: Masahiro Yamada <masahiroy@kernel.org>
> > > 
> > > commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.
> > > 
> > > Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
> > > since commit 994b7ac1697b ("arm64: remove special treatment for the
> > > link order of head.o").
> > > 
> > > The issue is that the type of .notes section, which contains the BuildID,
> > > changed from NOTES to PROGBITS.
> > > 
> > > Ard Biesheuvel figured out that whichever object gets linked first gets
> > > to decide the type of a section. The PROGBITS type is the result of the
> > > compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.
> > > 
> > > While Ard provided a fix for arm64, I want to fix this globally because
> > > the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
> > > remove special treatment for the link order of head.o"). This problem
> > > will happen in general for other architectures if they start to drop
> > > unneeded entries from scripts/head-object-list.txt.
> > > 
> > > Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.
> > > 
> > > Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
> > > Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
> > > Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")

Greg, how about something like this tacked onto backport of this commit?

[Tom: stable backport 5.15.y, 5.10.y, 5.4.y]

Though the above "Fixes:" commits are not in this kernel, the conditions
which lead to a missing Build ID in arm64 vmlinux are similar.

Evidence points to these conditions:
1. ld version > 2.36 (exact binutils commit documented in a494398bde27)
2. first object which gets linked (head.o) has a PROGBITS .note.GNU-stack segment

These conditions can be observed when:
- 5.15.60+ OR 5.10.136+ OR 5.4.210+
- AND ld version > 2.36
- AND arch=arm64
- AND CONFIG_MODVERSIONS=y

This was previously bisected to the stable backport of 0d362be5b142.
Follow-up experiments were discussed here: https://lore.kernel.org/all/20221221235413.xaisboqmr7dkqwn6@oracle.com/ 
which strongly hints at condition 2.


> > 
> > Why are we adding a commit to 5.15.y that fixes an issue that only
> > showed up in 6.1.y?

If you approve - I'll send v3 for 5.15, 5.10, and 5.4 (with style fixes).

Cheers,

--Tom
