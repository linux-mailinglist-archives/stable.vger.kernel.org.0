Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEA2692971
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 22:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjBJVme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 16:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjBJVmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 16:42:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B1A3A09D;
        Fri, 10 Feb 2023 13:42:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0AuY029674;
        Fri, 10 Feb 2023 20:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VhfbtTG/NUQ7wu7lNb9jypTCgn4r0UxTOdaBvnltlAo=;
 b=pTm1Iit9zmzxv71Bd7U3vXObz98mtWNyRqbYnxhBDtKWgVPLd0Vz84m+574mHGB3ckrA
 n+M7gnDP334bwWsuAFMt0m4D3bKvdLj3rQnD/1kjEastqY3wxjy2iHYsE3sQHOtOcQBU
 E/1OlQpFf543W/5Meip04IvlzLql+PypMTa4MU6F5yGhmRDnknMoDdl3FkSuusBqFIBh
 HAq1X0AiJDUDVBE+07hR98MO0zFpbmMqvPRrhbrZ0we/JoJSXVDjjmo37zglVeYZh1aK
 EoNnnlm5MLWnAZCOsvKz26LuUy7gZoFYWKxsKetRB6WXem/KcPnVGTwyObEm1fwtliBD LA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1ea5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJlaR9003038;
        Fri, 10 Feb 2023 20:20:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtb7jn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFrxWels0pCeU26fJ7ZC2Bp/abtgdJtx9KNgk6cDwdDPc7MklL1r+aXdgaqz24+rlPky3LNXVZ6Cqimt2vPc5iq8QbGEXOLheBFszgKwcz/z4VKVfSwXPZlvmzLOn5Yi9RU5PS3gKKsHOHMPDFo/o3nNDVq3D1y3ekXT8547mZlKBHDNZpiYT2Q5NkHG/I7oP4y0sbZhnetmBlC+fu5nGovVvbPJ/V9PYDxdoxK1baLRDlJIqd/0uqnhWdZfSK1JWQ4MET1IVREdqL5JwkA7ypxcpmEa0PeQHmcKcW89OmkaDtd2UoEWj3foD+aCGHebotAMNJZiqu4JJDL0eti69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhfbtTG/NUQ7wu7lNb9jypTCgn4r0UxTOdaBvnltlAo=;
 b=ljwBpP+KvEUaf80t3C/O1vORhIlDnGh1lN17yGnkgiD5GswlrWW6gBflFEtdBEho6jEsSEJRf9vmk1Rq2JfJzhWjJhYO6O4AWh8Ff2ukcxaqAK4AU1AJ0JHxQRyrlvxq0c/9COOMicaWow6qN+GgoSRVOdByNqWsoNrcMRd7iAt38Nq04kkkZwd9p/lKxolXpk0q6DdTaX/6b8zXWPor/bmRgM8ZsYimfjpwUA4MzytAuUwL6gndTDZIv6mQbH6n1MybQJ2xQED81grhHeoR9KWiLbw38apdjJNOm3gCqX1TTS+KTkd4CjeM6FSyWgVQHMfm3eG1tHHcXI6SNF0iIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhfbtTG/NUQ7wu7lNb9jypTCgn4r0UxTOdaBvnltlAo=;
 b=di4p5x9uKsvliWuBIj8Eht+qR56LMiv52xsSyurMg57B+IbtZONzs7V62rDtAUkpGKUQWXXi2l4FBQwyKah/8WDh5lJddj75QfF5ZSSS0LEh/YDCB6oQduwvogXUWTLHLmiDQQuMn0OcSDgeI6pHgyTtUiHKqBVEUzIWsoGI2ts=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:20:48 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:20:48 +0000
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
Subject: [PATCH 5.4 v2 4/6] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Fri, 10 Feb 2023 13:20:25 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-4-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR22CA0006.namprd22.prod.outlook.com
 (2603:10b6:208:238::11) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 802d9a39-fe1a-4e7d-3393-08db0ba44c13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X/gtWJr4gov0yTWARw8puQ3uwHNyOSbAvdPmJfumB+Lx9B8sWoSBX9Qs4m0r1airdf2lgJDB+NfaIUItB1IFh1ZXFvJW1GYxcDM37y+jq+I3xGuMsS35N0kSMY+F8aLWZWmwYcRwnNNfqwkL+btmeWd7sOGaQcGB+8wteZIXWuflCrjX0POb4byRku//+/CeMaf6q2/TPAjcUj6wl7urYZqCJFdcbkCbopsoXmw8SWWfBPgretL/ObA4dKW4kmKZ2Fa33stUfwhkjWq4CcTUp1pQoX9LM+y0zfDLiMfwrRvbTJs5yr44tOVWfp2vflv/0m32GioeKHOhKMbuSLnDeeOIK3fQHZs6Dj1ElAyPLkeZXJXRnz4ZXOT+kGVQezG/msm16GhuTjF4CYd33pEiBM5q56gJqluNBP3keIOTSs3y+HM7r+aiNdWa5XZUlNAKSzIVGbfNL9rGiq81krcmwY0cE1Il9zNpPgNfgJLJlxF6J92fez6MLAQzODLID52qAd3hbyV74DNn8/3rxzv57I1o4SIRFGbnWnOAZR4w2clfMO9hhyszaXZdwhlGh/foInxl0JhPslPXDzT5FWlB2x0uXP9OtiAJsGSzIZfRey7LsORfV7Lio5UJQPIwBV0UdPirHeRkOoe2sOkDQGdnOpbxdjrotrhvTGU6kyB/lnqFrK04biu0UTsC9QbrUCf3mVCAf6vg8mdLkOok4iPelHlS6OMZ+ugr2n0MPdlnGwQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(83380400001)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2pPdDFrOFR6K09lbnUyOW5TWkR1WWJzYnd4b0E4SDcwUisrMUxGRkdsU29C?=
 =?utf-8?B?RnBFbDZxMC9UVnE4eS9uTW1ad2lUZXlZNU5qY3h2VzBzcW5Ud1plR2NsS0RP?=
 =?utf-8?B?ZlRhcHM5emlqejZZLzAvSjVsYmg2Z3dldUF6TGtPampodFNMYnU0T21ucldS?=
 =?utf-8?B?N2dRL2JGM2l3d1YrL0NZdS9LQ0ZxRVJrL3JsVkVnbGRDTjk2TnNyaWVZcFZT?=
 =?utf-8?B?U0FDbVh0dHh1Q1BPK2NOWnVxd0lpVlgxM2NsSytmMzFveTN6SW5UV1Roek9Z?=
 =?utf-8?B?MFRwZGNlZzFzS0ppQjg5Y08zb2VEVk1Hd1dvY2RCdTBHZm5XRHI4TitTRXl2?=
 =?utf-8?B?dUR3azFsUE9iU0VMMTZ2elE1WnMzTjd4QUlQeGVVTWMzRFZ2RlRaSGtmZlFM?=
 =?utf-8?B?dmJWakhvdUN4WVRJZW1lK2h0YzRCRVlsYUFCMU4rVS9wS2orV2JWT0RMRFMz?=
 =?utf-8?B?MDVDR1RmaWNrRFd3RmkyNXZZQVAvMFBuTWFjakpLczRNZ1duNFR0aUhpdzY4?=
 =?utf-8?B?WWVHQUlkOFAzMTBmK1NMR1N2VGx6SkQ3T2R4aE5LVEYremZwdlIyMlRidHNl?=
 =?utf-8?B?NTBjWTBXU1NxcmIzc21oa1l0SFRDdG5QcDhrNUtkUUFrWjdMZko3dXlUd05R?=
 =?utf-8?B?aHNwejdzTS9tb0ZEVkloMVFJMkh3dG9MbXNDQmJaVnNrdGZpampQMm5RYjZo?=
 =?utf-8?B?ZlhUbnVSZW00OUkxWG1BZkJraVB3bmNsQ0Nrb1E5eGF3OEUzaUJ4czdIZW5a?=
 =?utf-8?B?d0lSOVRoT3YrTGpQeVlzNTl5dDVkdFBWanExb09hdExjd2g3bmFkUnZZSVpC?=
 =?utf-8?B?YlBWcHpFQms5ZGluQlpPYlVRdWFqdHBaSmltMG5hUGpzRlg2UlVjRXZBVzR3?=
 =?utf-8?B?OThCWTNSVjhSMzZUVnJIOUdXR05tOGs2SG1FWmFQZU1jUWlUaVhiL3kyMHBI?=
 =?utf-8?B?RUxraUpHZWU0S1VQMGtYenUybDFsWHZtcU9oQWlDNE1TZHdJZ1FhZkI0aHNP?=
 =?utf-8?B?L0I2MGp4QTBLNW4zWWxYa2thN2ZzaHpRZWRMOVBkZFNCRkZwbGVMMFVtUlJi?=
 =?utf-8?B?UFdvd3RMT05relhud1FnUW5qQytjWkFSTkhudzR6SXlXQTg0TE5uN0l2c0FK?=
 =?utf-8?B?N0E2WGpvM1pxR2xMOWdWRkVSVXQ3MW04OCtZNWxpb1UwUHlXa2hyakJtYmtw?=
 =?utf-8?B?NElqa00rcURqTDNsMGlKNWh2RXo2aUpqMGdsRVR0TldYY0pQVlFlWHB0aDZR?=
 =?utf-8?B?NXFMUXZ0dTVhQW5EWXNlSlBwdUVoUzd0QUJzSmx1Z2F3U2J5TzJBUXNLNjdI?=
 =?utf-8?B?eTQveThyRk1tc0REQVpOWGdCQ1lkMDhRRi83bnJGdEZXSzg3cDJCd3doL2k0?=
 =?utf-8?B?cW1kdERnV3hOb0pML0tYN2R0NDdOWnk1TVRyUlBiZnJQUjlZdkc3dnZ2N1E0?=
 =?utf-8?B?M0ZOVHFmSUkxZWV0WnNLSkxvYUkzZnpMVUJsR2NoRndZOE5IUmpDUEM1aHZ0?=
 =?utf-8?B?NEtDNG8zcFVGZmJ1QzZ1cFh2Y1RxeENjT2NkRzN4UmN3Mnd1am9uQ0VpWk15?=
 =?utf-8?B?K1hZOWF4WVN3ZHpzL2ZXZkxaWjg1OG1EQ2Q0SjVTZFhHRmlyaHBxYmt1QzVT?=
 =?utf-8?B?R0NJT2l5aDZGM083VlFObkhJVWdITEp1QS9CVjBGVkk3emliSSt1MkNOaCtV?=
 =?utf-8?B?MjJKRmNXQWFlTjRwclo2dUd6bS9OMFRUUDFtb3RqM25HZy9CajR3TmVRYU1R?=
 =?utf-8?B?UmlnZk95c0VVTnJjZGx1VUxRMGZvSFFoeGI5bE9FQXlhTUxLMEliOGhYYUlj?=
 =?utf-8?B?WFBISnBUS0NobUtkY25LN2d4cVBXZXdUMjdCeWErSW9hcmdCcENhT1JFcExR?=
 =?utf-8?B?Yk9iNmZKTHIySUg4S05peTFwcWtNRVJGM1EwRjY3NlcyQUhrbzBzL3hXWlRE?=
 =?utf-8?B?UUl2QnlWWVZBU1BLbGpHVDQ3NDE1YlN4TUF6a0hoeGh6Si92M3JHVjhRYlZT?=
 =?utf-8?B?cStPRE54a3ZyeGZkeVcyMUNRTmtnMkRJeFduWHJvU21oSWdzMWRBWTh4VHph?=
 =?utf-8?B?VG81cU5ZZmxzRlk2L3RFMkNWZm9zd3N6bzlEYzhFQ1pjMG01TTUwYk1zNEdj?=
 =?utf-8?B?TUZDb3h3cFBlRTFjMHFiTm9ZNCtZVjFCRFFuWWpEUWFSbFA5a2xSdVJ4QTNI?=
 =?utf-8?Q?V35ZFrDnBRPF92b7bPB2cpU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?emJwZXVLZ0VRaTdRRFEzMUkvRnkrSDZkVWNKUEJsWW1Sbitva3Z0MDJmeElU?=
 =?utf-8?B?ckk1VDd0dzBhQjhWcjFiS2tEUnpnM3dnZTJqQitRMGlWMi9LSWRvdzBsVnpS?=
 =?utf-8?B?V0YyeHRuaUJCNlZ2aXFkdXhUNHhmRTVLeEZOUHBybkhNOWtIcDRuSkF6aHFJ?=
 =?utf-8?B?WjE3cncyUUY2eVp6ZURYeWVIUXJvbDI2eVRtZm00eFlLUTdwV2pCMTliWFZV?=
 =?utf-8?B?dEM5UWdzdFd4TFliN2F6ODNQZUQxam05SWJnL1kyalBxQitBYnZQTWtCdHEx?=
 =?utf-8?B?U3EyZHBNV0FrZUs5dHhkTURWOFdpWnl0amJUd3Q2dHFjdS9sTWlQNnNHU3VB?=
 =?utf-8?B?Vm5FY3M0Sm9LMk1ub1BjakFkeTRxVnVaYXlIeW42UmVEOUNYY2FkaElVMXRK?=
 =?utf-8?B?YXZiSWpnWjZ0ZDU4K1BVQU5aaDRoQzlCZlg3T2Q1RGZtdGFaTlZCdmdLT3pD?=
 =?utf-8?B?aVRsMGJHbkc1cnF6NlNOZUhoOE9VbU9zclRRWm05QTF2REFIckVNSEJ0UHps?=
 =?utf-8?B?cXFycHhXcUNoWm1ZdzZGQ1R1cmI5d1BLNWhERTdUcnJTayszMkZ2ZXRBZVBT?=
 =?utf-8?B?bkk4UjVDdGU3UHVqUllYQ2ordU56aFNmUzl0bUtrUXVBOHltRlFoSHNZSjhs?=
 =?utf-8?B?YnhrckM2bGJDNmZTZk9ieFJRM0hVcXd3UDJJZyt2emFKTW9KR0c0OW5zc29p?=
 =?utf-8?B?RDJicHUwL3NJR1BxRDZUS2dEMEttcGdjb0FDcUpSeEJSL01XRnhYVWRLTmoz?=
 =?utf-8?B?dFZhYVduczdDMEp4UFhnUi9vQ3VlR0h4Q2tmdldNTFBDZmhIbFFwOGNWMlBu?=
 =?utf-8?B?TVNjQjFjVlFUbFFkRlBRdTIxTG81bXQzdjhRb3BHOXdyaUZpa2pZeS9velAx?=
 =?utf-8?B?aTh6SDQyVlVlQ3FucVlYR3phK0E2K253SkpJR0RNWkxtSXNwR2FCeWdvdmtI?=
 =?utf-8?B?T0s1dUZrNkc5eHRyMmVaL3VCOEpFbUszd0NYN1R5MUtzV1VLM05NQ0ZXUTJ5?=
 =?utf-8?B?OUpkTnozU01YaVc2c3hieSt0MTAyVkZkdm9MRXBlaGh6QUpFM1dkMDF0QURO?=
 =?utf-8?B?Q0MrQ05YaU15V3ViNSs1TWdrekRoZ0x1ZnowNUp0SWRzcThsRnFnN0FUbklj?=
 =?utf-8?B?VUFLT2xhalhUdHpCRGVvbTc2QWY2TVplMEZINU5JNDMxTGkxMVRPMWxtSFBU?=
 =?utf-8?B?czlDa04zYitCSGpRN2Fwb293alhDNDlCUmxuRkZLOGJ0V01VSTZicEVFRWZS?=
 =?utf-8?B?d2dtbGpzOTBKVjNORjkvcnFqNlZlVFR2bzUxeUlYc1gvRDF0VFppa054K1k4?=
 =?utf-8?B?Z25kc3lvMFEveTFtN25aTlJwOFhNVjAyc1locFJLVlZBakZMY3V5QllXTmto?=
 =?utf-8?B?c0FtbGZxNWZQcHc3VjMrd0xxTEVxUUpYdjBzRmxaUmtmNkZJSmdkVEY1cHc4?=
 =?utf-8?B?YUZJZDRmai96emtTbU0relhsZVZ4bjB6bUdLRE1jQ0FDMUYvc1k1cUd5eXEv?=
 =?utf-8?B?dENQTHdnSjllY3dLM3ZGUDlES3RXbTlUOTVheXdjR1BNdFdQenRxcHlSREJo?=
 =?utf-8?B?V25IWENIQ2p6TG8yRW0zRnQvMmFLeE1sOGxpUXVHY21CV2JlSG9FOUdYUXll?=
 =?utf-8?Q?MuLlUIj81YNlwuCWyh3EtJBggRW0pO3vV6KfMdpv8G/c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802d9a39-fe1a-4e7d-3393-08db0ba44c13
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:20:48.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmIBfBt26LNRG84GNw18ElTtk2b6Ajyc6w6+ar5oljiss6sVoQEDhSXPe9vCdj5T55KdDo+Z+RvHWw9OVJyv+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: _9SfZzz_hyNWvtKAa_H7JPZveok2GwwL
X-Proofpoint-ORIG-GUID: _9SfZzz_hyNWvtKAa_H7JPZveok2GwwL
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

commit 07b050f9290ee012a407a0f64151db902a1520f5 upstream.

Relocatable kernels must not discard relocations, they need to be
processed at runtime. As such they are included for CONFIG_RELOCATABLE
builds in the powerpc linker script (line 340).

However they are also unconditionally discarded later in the
script (line 414). Previously that worked because the earlier inclusion
superseded the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 137). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier, causing .rela* to
actually be discarded at link time, leading to build warnings and a
kernel that doesn't boot:

  ld: warning: discarding dynamic section .rela.init.rodata

Fix it by conditionally discarding .rela* only when CONFIG_RELOCATABLE
is disabled.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Link: https://lore.kernel.org/r/20230105132349.384666-2-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4d5e1662a0ba..46dfb3701c6e 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -395,9 +395,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }

-- 
2.39.1

