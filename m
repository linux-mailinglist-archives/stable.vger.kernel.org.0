Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BFF6EE385
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbjDYN7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 09:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbjDYN7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 09:59:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A761702;
        Tue, 25 Apr 2023 06:59:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PDi9IS010218;
        Tue, 25 Apr 2023 13:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=FqH3RgN4ACXIV4cluJ9xJdS/mUz0Nnehmosd3e4dlx0=;
 b=DIF8e2Eq6vI0i7DtOQ67LiVo9lSYn0UENiOEkmZChZAqV2LX3LNofgpP3jh3CxIGX/MQ
 u02g7OCGvnjNaOMitHP7tZH3xLqg0Yxtoa3nj3fKRtyVsx1rG0Ab0UGT3hTcmjLcg87p
 5LBGTh1bL0kPcsD4yuJjzwUyF6iKoLmJ3Jg3iM35cqzq4LNpEA/5hnuThJ/8A1JCkiV5
 ivtXGqxurEhab7CJVJqtYwx18TgCymUg69v6M8pAEzl9JlPdYrJBLZHT62B8GmLFbjWi
 oStY+7/zgHAuSXDN2SDJZdY1xtHJJNyeOKbjEzD5aPKRfsvZLuzbBHIflO9kK3NV/URh cQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q476twce6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 13:59:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33PDAPx6006669;
        Tue, 25 Apr 2023 13:59:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q4616g2wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 13:59:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xha1jdqSeX6snL6IXdJBtF1rDvc6neHoSdYXJZP78klRWHcJWmJfm8e53378Z+kC6sTJvV5kSYMMnwqeQqftsAJhSgpoSoMSSc6YOag+IOgZXUR4EyM3IUnPPBPwxQEns6+7Nd1FuTsfwgvut2kmgevjn9Dc35EZ86Jhz5WESbWMWTWEN0BrjvB6tSlDNtpI8fsMmPNxiL2ZKNfrtATZJUPBsmfLpnGfZJdPGJ5d/6NMCuKDQE5kNCwp8wVMTDxWpkfIaOR2Brpc3XczM5r8RcU7ce/CCpndjqnTIpqcgafthI/Wk0PwP1OoITbS4jYclhGj27lb3i6AYO+6P7gNQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqH3RgN4ACXIV4cluJ9xJdS/mUz0Nnehmosd3e4dlx0=;
 b=AWZd/mkyjnLS1ZGyw4s3lL9s2EVdMgiL9VhHmZp4iv6CBdAMbCEy7CMvmUvPXRALwuGA31ljbE0YMeLB35Ajqn/s1N3CHZYt3v6c6u1vllntLjvh2Z8Eoz8OB66TMaY58nBHE21Ooo0f5RPa6OAXEypIOh7MU48cuJIzpdW/mMIgXu+m8fsv0FHHN/PyxxIlJS7cacjdWZfbq/x3QUopT8BA77/Pq6PrZEWDXrGqBA6YQuDhChYT/Ikg/DebwxtTov8DUgt9q/ysTGZKswMkoCosfzkgSJSAUs3TvsE1MBD8w/Swxv5si1TTwhRNQ/KVg7LmXruf0TiIboXyBL/2QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqH3RgN4ACXIV4cluJ9xJdS/mUz0Nnehmosd3e4dlx0=;
 b=ORma3zxQUm+BUimU9x+ppqjPpzyoMhbf7SV6KAZGM8UYZRui5wSsWSn0JPdIe5U1D2xRrUuMkoXlky6Vdm6p6Xbh5D6F+8qlzQ9X2LEHQydknHoqRwxCvpkJXFKbiTayEQE1gyL+uNxoPMqGrDOrdQxjofV3pAZuo3iUt5p4Yhc=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH0PR10MB5846.namprd10.prod.outlook.com (2603:10b6:510:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.31; Tue, 25 Apr
 2023 13:59:00 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834%6]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 13:59:00 +0000
Message-ID: <39fc6a40-26bc-6180-f8f8-c389cf6d1f28@oracle.com>
Date:   Tue, 25 Apr 2023 19:28:48 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 4.14 00/28] 4.14.314-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20230424131121.331252806@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0025.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::12) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH0PR10MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f14f00-df9c-459a-70e0-08db45953875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VH/iZZA098LnxWj4tsU/mycgCXe4sRiU/ivFgx2raMBj7uQ3UI8MFKbttfCeaoUsgICqyrcUyfmLiInsaU/BG96xoLtZkpfsUlprgZRsqBCppKr2k9CZXDGQ2xMUogdE7NoLLFGa8SogBsuniVfvdIEWaKVERTHTcCiQs3RUY089MczBYxFMp4fhaU3/xcMRNMG6eeoSDweQv3XjQUzaugnGFsrdXvPIxx2JWtFdj9QkqiqzQaV8Yj3KUcBQUQaRTE5+Ali1IwGL8W0hNO+3+B8uXZ5EQG9im65FEt/wei6OKA6QJr0JCpb6JklEv04MNZ9heo5jwEWV9L8l0pw6Ov1XNH5RFRK93sol8zKhq1/447/+iOnMBz9wuq14uWJCHuPNqSN7ENywEZCUhBUZtH0uMQ3KAJBN39PjjsDu08H0ODveSl5n6WUowqDBYGu8gzVmVXdL+/rMyJvss8FXWQVqG5WdMnbo0ITTX8nT6IRClCYk0614BV+VzpTzkqYgR+qOQdCD7nRttWMrF0eBWz/3GWMng/7fDtGw5K4uVrOrMdC7GeVGuKHiKlMrz6hLFMx7IyZaAk0Gduen4FHgsUvL0zeH+eKH0P46jgh9ymcBRKOaN4iVReF6MoxovybX9OENusUWdX5SNYCCHDSIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199021)(66946007)(66556008)(4326008)(66476007)(5660300002)(31686004)(107886003)(966005)(53546011)(6512007)(2616005)(6506007)(26005)(186003)(6666004)(6486002)(54906003)(478600001)(36756003)(2906002)(4744005)(7416002)(38100700002)(31696002)(86362001)(316002)(8936002)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVFlaHEvVStHSE5GZ3FmRDE1alFrTjBMWWdSd2syNTFVRVQxWnZKeHdUblJi?=
 =?utf-8?B?aHVzaU1PaGpSUkVGVW5zdUladnBMMDAxd0VRazBOcmNwbEtaR2FPRzlrWWlD?=
 =?utf-8?B?aitPMW9jTWpWZ2ZMaElhdi90bkllUmFrdjRoQWJyUm4zb2NWRDVDZWx1L0xS?=
 =?utf-8?B?b0tFazJMMHVwTC80WHl1WW5YcEZyYjFhTVBwUDQ5QTJMZWN4ZG5YYzBGaHo2?=
 =?utf-8?B?VTJ6cjdPckQyMGU2Z0ZUcU1hZXlHMjFnU0VYQVZIUXNuNkl1TC93eGlNZ0hy?=
 =?utf-8?B?N0hwMTlPdlVKVXFjMHJzSkR2SEhJWk44Qld2enJoRHUzSHBqM082NllZN3hP?=
 =?utf-8?B?YmVuNnZ5L2gxdTJCTUFsQmhkcVNmNlJCeW9JSWxWQWw0WVFYdlFpd0RaV3FW?=
 =?utf-8?B?anREZUs4eFY4WWtXbS9UTHBXV3FMOXZOWEFiVlpjTEVCcjBQSTlleG5yNlRu?=
 =?utf-8?B?bEc0R3ZIMEkxbW1seXFvcHp2eXdSTWY0MUpXMzlkM1FmWSs2dkh5YUxNTUxN?=
 =?utf-8?B?OStrQW9NSFk3eGNTbE93RXJpNkxpVnNEUjJCY1BZa1IxRmdJZ1hzVG9nbWJa?=
 =?utf-8?B?V21qQ0VWLzlnTXVYVk1ubFVpRnIxM0FuVE5mb1YxYzVhZ2UwVElPakdjRXN5?=
 =?utf-8?B?U1FxS2NzSnlXdUl3UkxCdGZSSkJCOTZveTc2dnFMZXdlWWd0Tlc2am9YRVZ0?=
 =?utf-8?B?cjVrSk5BMXpaY0dYQThEQnJzVVZLdlBzRXh5dkxYMlVsWExveGJIdHlNaU1p?=
 =?utf-8?B?OHcwc3RIaTc5SEdOZkIzb1haWUZWczR3Q3VSVGdqL3lDN01lbEpoSWlENnl4?=
 =?utf-8?B?T3VQZCt2N2xZR2g3ZGUyUlBpMkhUT3VsZmIwQUZkeUx0WmRBOG5Da3FMUjh0?=
 =?utf-8?B?c2xWd3I4UFNIMDFrVVl5WlYzSW42Yk1tRHh0c2wzbFdadmNuaGxnUlpnWEZ0?=
 =?utf-8?B?M1V4VW1KVjZaMzhCUHk2a2hQdUsrd295MnJKL2ZocCtqcW83T25zV2RkcU4y?=
 =?utf-8?B?R1piRTFuRFlMVzgwNlJLb2M0YnZlL2VzdE5pQXpvSHpSakZJT0Irc3FrRnNl?=
 =?utf-8?B?NjVOSXNQcUw2c2pGUDB3UzFha1o0YWg4bWJCS3BYMDlscmdkcllRRzNOVHNJ?=
 =?utf-8?B?elhMNSt5KzFKR3k2U3ZOSkRpbGxEemZMejBYMnQvdG5HRHRBZi9TRXFna1BU?=
 =?utf-8?B?NktocVBibDh2UFdmRzlsUkF4alQ4bjNzRzltNVNNVnpYSkEzanAvR3kwblA5?=
 =?utf-8?B?ajRaZysvaC9CcXpYa3c1ell5QWdMTTZNbUtiWW9VMVZDNGlHVElkY05EZ1ZE?=
 =?utf-8?B?bllNYk11aHFxSUlFTENjelBUODRzdm43LzVUbVhranpERWY3WG5aRVJ4Szdh?=
 =?utf-8?B?cXh2QXFRSXNNbkVnRjByTHNpQ3hDMU5vN1pTZ2cveWpudyszazk3NkU2cHE5?=
 =?utf-8?B?eEpLdUU0TE9uRGxwMmF6aG11Wlh2bDlMbEtRQy9HLzJhTUhIUXJTUysxMVoy?=
 =?utf-8?B?MVprczZOOTRWRFZGcmRDNTBFTkZlZXdhS1NBc3B4OEVUOTEzY3dzUHV3MER1?=
 =?utf-8?B?WHExSUhsbmpybk1JSTBicHloYzFqVzlQME1JVzN3SERZQnpUbEdjajkxN1pP?=
 =?utf-8?B?Uitibm1pY2xLVUxwYldPZUlkSGkyTUFuZUVaRXl4OGh2SGRYdHNYc2Qzc1hC?=
 =?utf-8?B?T0xBWE10TUFLODMrTUpJSVFJZ1RqM3luSW95NU9aZ2V5VGxlY2k1Z0M3dWMw?=
 =?utf-8?B?eEZsQkt3eDkvVDd6S1BaLzM0bnhSZXFRNDgwU2txNUhDdnQ1ZDlrUUtEOVh0?=
 =?utf-8?B?SEU4VFFuRnZDa0V2bUkraE1Rb0tIOWlhbm81MHlWaUlhd3duMEc4ZEtmcXF6?=
 =?utf-8?B?QUlqb0tqNWJrWTErRi9EZEUxazhvL0JXY2FRVWkwcWg0aHQxYmhZaGlVeVNO?=
 =?utf-8?B?eDFZSTljcG1GVnlUQmtpU0w3VFNpcm9GUHJUcGNWN3FpK3ArSkowN2QxOXc5?=
 =?utf-8?B?Z3hHNXM0SnlOOTNrdVcxVzI5KzFoTXVrYW1NRm1kRklRWW1KR2Q4OWhhSjFw?=
 =?utf-8?B?bXdpRnpGTW41a3FmQ2JieEpEVXRFS0h0QTIzbEpjYjVKcXFqTVFFbWkybnN3?=
 =?utf-8?B?NDNDUGRoVWJtdmIrVEJrN1ZNRDkwK1phdGdiK0M1WGt3WndCRlFqSHJKb1RH?=
 =?utf-8?Q?hp969/NJhXWR4dAsH1Y0lSM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cysxUUFjVHEycllEbTJaVXl3V1Y5b0JYeVZNMlY4bTlOOHNkUlNjOXRLckl0?=
 =?utf-8?B?elAwei9LL0prNm1nV1RqdlJhb3ZYZUhmZG82c3ZmVUhsS1R3bWlTekVzWE5k?=
 =?utf-8?B?cEV2U2VaR1lqbk9uYkpPZ0MxVVJ0VytDWlRFSHBGbW9Xa0xTRC9DeENBRUly?=
 =?utf-8?B?L2J3WlRoNEpsa0xFYW5sWlpuOHB2UW43SnZlOFE3cVFRQk15eFM5NU1sVDds?=
 =?utf-8?B?K25JdU5UWXhvOHpuMkNRWlRabnlRUkwzR3pvbGhOMUpGaDNQeDJhK09XSTRx?=
 =?utf-8?B?cmJKZmNoRExMRWFKSGpPb1FCUGFrVSs4d25YTG1uZ1p1UXJBaHVnbFB4SDZn?=
 =?utf-8?B?WlFvejZBUDRYQ09OVWZuZ2h0MWo0T0wyQWpIdGpLeEE1Ky9qMTA0NFBKcys0?=
 =?utf-8?B?eElOdG93RmZPQnVqZmIyOGYwTTZ0L3orOGpNUFJBbmNjWjYrQVhSYkk2Uk00?=
 =?utf-8?B?NFlqVllNc2x4VWtlTkRnVVlGWGhsNEdoUzZTbDdRTmdudllmcFpTUDloRk1V?=
 =?utf-8?B?K0pYUFNiWDhkb3BiOFdDZlFXSjFsdVVYSWtQZWhSMWFTMUdERzFJbE82OVlK?=
 =?utf-8?B?WmplanZDcW5rdGp0VnpwZjdxU3lCOHp5M215QmJiZEh2cUJsQ0pwd25PZkQr?=
 =?utf-8?B?aDh4Y1QyV1oxZEpvVE5DMFdVbEgzZTA0bGtTVkhIUzBuNUdWNjR5dzV5aUIz?=
 =?utf-8?B?OUd6WHZaSkRMZFFlRFRWSEhvdndROWI5U2ZiTkMwZGt2QWZtWG54WkVWbkI2?=
 =?utf-8?B?U01IbFdJbFE1MG1QTmFsbisreEhSanlBR0RaUEhwMG84SDRjb2hudUE0L3Ry?=
 =?utf-8?B?L29hOWtkdDRLdUNaM1ZIaTIrRXp0UEZyQTNuaTNQOWVjN0lkb3IySmdGQlRv?=
 =?utf-8?B?L0p1NVY4Q2szTExxMUJqTFZwQjM4QXh2TkdzTmd5cXE5OG8yQzJSVG9GOUdN?=
 =?utf-8?B?aDZjN2hiOWVNTnVFOXpsZENKa3BoZHV1Qi9mTkg5OGVKWUJlUiswWXlDTjdH?=
 =?utf-8?B?eThqYk1GRzBVbC90WDhva0xYaTVaRkgxZXk2TjJ3RWJaMy9XLzB4RXRqNkxM?=
 =?utf-8?B?VytxR0ZTUlNzMkJGN1dPSzhtSzB5bjZDbmZMVWkwbVRvb2pmSUcxVi9uZ1JI?=
 =?utf-8?B?bnlrNmdxYVVkN2I1MWZLVkdJWlFpREVqNTQxelNrcGtCMnI5MUczaGVqMUNp?=
 =?utf-8?B?cW9HRmpXNXlVZ01GUmJVTjB5VWtSRUhBd2ttOXJ5ODlvdVFvTitBU2k3eld1?=
 =?utf-8?B?MklTYUthM2xzSUFCZ3BKdVQ4U2xydXlHNUJaZjFNc1dPYW1INkQ3K0ROczl4?=
 =?utf-8?B?d0Fuc3FuN3VJVTVMZW1sQ3paZmVORFhWUzljbVdaR2NYa3pKVFJIR1JLZ0NO?=
 =?utf-8?B?OTJLTkxkYTJSOFdDd1RiVFN2Vzl1MUYzZTR6NkpFajh6K2xSTlJXU2gyY2hX?=
 =?utf-8?B?RjltR0pwUC9NbUtWWFA5aEZXZlM3QnE2MXZIVkF2VGh4V3gvVlRXeG8xZHc2?=
 =?utf-8?B?TUoxaitudU80LzUrZDFXR0o1WEdLaHB4RkIwRFlTTW0rTUk3UklOYXFqNDJI?=
 =?utf-8?Q?bp43Nu+jzB4rKnRE+i3VJYLpDmj8r82LK/2JRqYllx2N88?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f14f00-df9c-459a-70e0-08db45953875
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 13:59:00.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: te/VHCJHQVxdj+7XpnH6fIAOb6pUK4tWD/7e9kNy0kV/HHNwaYi+PucYExaRJCNUU89YrqMFFduSFl5MhLW4p0xDGuBe2oxXLufjqQ/3UM4YcbVFBmyNNmwfNRFuevYI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5846
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_06,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=975
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250126
X-Proofpoint-GUID: Aa8QEeCL8n7_wanTxby5YodZRlsgHC-J
X-Proofpoint-ORIG-GUID: Aa8QEeCL8n7_wanTxby5YodZRlsgHC-J
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 24/04/23 6:48 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.314 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
No problems seen on aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.314-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
