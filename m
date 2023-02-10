Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95506927CB
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbjBJUSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbjBJUSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:18:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3320C193F5;
        Fri, 10 Feb 2023 12:18:19 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0J3G023196;
        Fri, 10 Feb 2023 20:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=b6letfsLruTzwi+MnYGo0Y3/lDsJPwmPo9K97UrzyDI=;
 b=AQmLLVS6KeF+BRcxzSfZ9G7zEjYQaZnWJdkdhvJbPXDg0zjaywgb1ORaVHdOtkJHyEgT
 GW1znxD8rHkJAB9YYbaz/hKEmXja0lIC1iyrYUkOs2piTtUtubDW5iukLoLhNMQ5SWr1
 ZjAhEc94ixlvXEa+JuGyUEOFR3pcK80MWWuzlIS9AzpAtIGke+UWJ/90Qt8zTFoRBd1k
 bFYHAp+ONYmV+g1+EAezQ5QEPeCphNs/A8eLsntBvE8EqeJPNmS8HQYq+TYDuxq12fj8
 Pgjogzezr6C8WC30JyB2FsbfCuTCkKOg7hSltnpg4mVAsB9+AbaL5AK+vIfTmCFNXiA4 hg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8ae5tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AIHs44013665;
        Fri, 10 Feb 2023 20:17:38 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtaqhk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nSiK3V0ORNQc/RraQIHsDWc66dHJtp3vKvI8EOXuaqn7Km1SAZ+SvhMs7AQj1vEp+pMAGJ6H801UnO+t2Treby9xmNrPnRKcvFKhD9pMp+URQxip4IKCtV1LZoVMuogjMzf4bdm05Ebw76NT0GI/T4FkJTdEdv/73xGaImqXyZXYPOC8uyqNDqxLPSP05KPPv4BXXEfDyrvTaEd+ljkR7wxQXRguj3Ue2axAVDyvRitb1FMYj2Lm3xRdQF4N5N/RnYRID7WOZOJTWMeDHHB1eNXIcgYG2b56n2N6TIXo0jkNUpJ2T29Pf8Kawp50J6lnTIBZbIXLQ/oowWIuZYVw3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6letfsLruTzwi+MnYGo0Y3/lDsJPwmPo9K97UrzyDI=;
 b=W2ai7LklxUcsqoqHiGQSxAw2/BaQrRCV1dq6Tu4Ix0W05MkopzDRZC+jHCMgbjMq7nZBTT8zx+1rse0GSlcqSLBU78wNStY+kgWpXD58yH+Fc9CRVje1Nc6hoeo4/SlI4a8HGq5WOfQRSFsVW8pVsJ17yF8RhOIUM3uTeJW7UPv925HsINtuMo5449Q6M/QziW+xboPneb8uN9eRfdHXGt4WLIEQcjOjwEC2ilkrrdUfE3JmxJjajNIkVYoVPf6JAvvdN3eBtrk8e8DrULUscIEwAdFf9S+TBCI3WJQSY7FubaAu08lxMFV1UD+LWMAducihpvAp33tgKZZGHkzHlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6letfsLruTzwi+MnYGo0Y3/lDsJPwmPo9K97UrzyDI=;
 b=mn0fE2HH8itMKP7CxeyqPjUUaaoiLc6pZGyqnw+eWv8VkgN/5C8/6vc+TfhSudjocK4P47eB436yJ/JJTkQc8sUdmeiRCLdUoJYXJ3C46A9E/YFmvskDa7oeMfK46X9wSa/ZH98Dr/oMtoqo++FDbti0B3+PrW5HzBF2JLmSxqY=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SA3PR10MB7093.namprd10.prod.outlook.com (2603:10b6:806:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:17:36 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:17:35 +0000
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
        Nicolas Schier <nicolas@fjasle.eu>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 v2 2/7] arm64: remove special treatment for the link order of head.o
Date:   Fri, 10 Feb 2023 13:17:17 -0700
Message-Id: <20230210-tsaeger-upstream-linux-6-1-y-v2-2-3689d04e29fc@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
References: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:805:66::48) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SA3PR10MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f36399e-268a-4d09-eb5f-08db0ba3d93d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFqEfhajNAGlu3NukX6j/UnI7ZHDPlOxlUH0d2otiKmsxpbBNL1odlRbAxPpKp453TuwijyxuC56OK9qFpVW2pC/n02pCnejVFy1yhKaR+GVWKZgoF5ZaIgBo2g/V2Ogw+AMuSXM3o3jpo+cuAx/4YP8NboNSL86T7QbzH7wPZLDX8Z87cnYmIUKcfY60OkJTdroIQ4ET1WN5JlyzanxBgn3uFrPaeGa9SWDZCjSs0v574MZ2nJA0k8gWpDo+ZSDtHPuCqOAVBD9VEM/KRuvdzRu1cfMYkzWS9QjCuYJGjkDmdG1ziGpXrCu2F4MeOPeRwwl681xyghOsVawYKA/nHeZLYSEGj4qr8fKqV7kKdtAKzgcPizVdwF5+JV5Gtv8+DtWfV484DLGLPSZ6vT36n3t/yA8WmbyExY4t5MUnXEwUF50U/Vqer8KUeZNi2sC6grOr12hLrEdKnIQAABDgbDmerJjRJIbwOD0i3KVXoxspvJ3GzqX++LdQSv1YVoQ5L13TE0LEnD1Ljx71xo3uUZBpileMfdj7kaG4r1B4E5Lig9p+5EfpCj5f8q1vsvE4bMjEeKQeUuet9IhN3izt8faa6/JsnG6u5dzda1Q/KLK1JO2gH4yJGGmqnGNkNnx+N3doB1jelZ79FP/rVDuK8axFGSGJAXc6g7k8kCVBc9DJAph0Ow3bAig7TieSLJbKHYTcyzazfWVEVjiG4QzHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199018)(44832011)(6506007)(5660300002)(7416002)(186003)(6512007)(8936002)(36756003)(83380400001)(86362001)(38100700002)(2616005)(2906002)(316002)(54906003)(6486002)(966005)(478600001)(41300700001)(6666004)(66476007)(4326008)(66946007)(8676002)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1RsMmtMbkNkVis0MURJWVNRYTVMVWVhWk05UWw1cndZNENxUjd0WmxhdVFU?=
 =?utf-8?B?dG1TVW5JSlI0U1pKZW1neE5Ydk96dmswVHE2UW4rQ08ydklrVk84bUxnK2xk?=
 =?utf-8?B?ZUVNTTB5Y1FhTHp2anJCNjczTEpkZzZ2Skk2V3UzTXZXc1M4M3lOKzZMK0VB?=
 =?utf-8?B?NkswKzMyYmhZRjVta2ptSCtmSy9jZzBwUXZIREFOL21tNjJoeHNDTUI4bFU3?=
 =?utf-8?B?OWpqZ1NkTmZKV0w0RU1oRWNMMGp3RzN0K2U1cHBRRmtzRTVJb0VBdmVFeFFT?=
 =?utf-8?B?RU5wTGdBR1pXcFRSeWZDVldCQWxyVkhJelQ0SXc2dDN1NUEyWE5ZTEI3TEJK?=
 =?utf-8?B?UGM4RnRZNm83d254NFVCSDNRbExIbG15OFZ0Q0tyTDRZZTA1YXBMSmdYV2pC?=
 =?utf-8?B?V2owTHhIcGJXNkUvbDVpeDA5SGRGMmpMSEVTWDhHekpyWnVMOUFRS0R6eXBS?=
 =?utf-8?B?Vk03U3I5RmxDMWxDVSs4bVltMjdKK2owZG9YRzd0WVZ1VldKNnpGZUdQdDNN?=
 =?utf-8?B?K3JKL0hYOGRFcTBzN2VXcVdhL1BpSzVsWUVaNG5ZTmRadmo5SU9vWTBNb3Nn?=
 =?utf-8?B?Q0pYcnlTdHU4bGpxNjd0eXZGQm9UMnFOZGpNemVmSUYrOWVQaURuZkNDL3M4?=
 =?utf-8?B?WEZuSEl3YXZYa0xodmluNkFiTXQxKzZUQUZ1NkdXYjF2bEk3bnR4YTVUUE1H?=
 =?utf-8?B?bjFUallSeWozQ2xJL0hZdjZWMkFhYjdIbVQwcFNDM3g0Z0NUZUpSTzBidXYy?=
 =?utf-8?B?YVVjT2lMdHpteTJaK0JTSlVYUk5abEJsLzJZenFFOTUwOE0xeEJFaWVOejBE?=
 =?utf-8?B?djdZZ2dDcjhrdDloWTA0a3hzRmpFdVJDRnNMQXdsb2FyMHY0VnoxbVBWRnc4?=
 =?utf-8?B?NlNXOHF6RTNBZGhnZHYvYnJvRmwxNFJNM0p4ZXVVTGpsSUJ1YkI0eHhzbE9J?=
 =?utf-8?B?czJtQnhyaHd1Mnd6Q0Z2MDlvUVVVbXVDK21PWmhsVjR1WklvQ3ZzNG5sSlNU?=
 =?utf-8?B?NzBFcllVNjZQbE1td3NRZE5jV1ZlVHBlY2FTL3Uzd2tBWlIrMWtTQmc5TU9Q?=
 =?utf-8?B?ekdTVFF4ZWFSRnV0TmlRWEJaQ1Evb2tLZkQ1Q0RkUkRIZzUrZTZaQ0IwVEhm?=
 =?utf-8?B?b3B3NlBNWkNmUHpGaGUxbXljQmZteWpVUUJTSGdpbUZJVXp4VUpzWEJYUDVy?=
 =?utf-8?B?ZHJLMjhEN3BMWTVOT3pyTW54RmpTbjRCVkpvT3REZG5vRjBaNVRGNndtVU96?=
 =?utf-8?B?dFE5eVgzNkJjZi8xMElhV0YzakNWc0ViaG8rZXMyUVFqVDJkMHNwdTJGMVdJ?=
 =?utf-8?B?M1lSdEQ1NXBKbExOMHAvaTA5THRreUNCNE4rZnNWdytMM2ZMcmpZU3hDamNS?=
 =?utf-8?B?bE5QMWU2VUlBdmVQdWYxQy9ueTlaRjF0UTlZcTVTN1pXeXU0N3h3NWxsVDd5?=
 =?utf-8?B?UGw1aHBsQkhWeHpNYjJ4RGZ1QTdKa1c5QVBUT1hpaFlYZzIyQW5oV1FhclZD?=
 =?utf-8?B?R2lZRE9rdURUbE1iZDlPQ3ZBb0w5T3BoRk5wNDgwYmxvbENPbU82TTV5K1Jq?=
 =?utf-8?B?Vzl3eElUUmQ1UUxvdWJOVVB6QmN3UDFraFFzTURkRFRWK1JVbUNiWEVLWk9z?=
 =?utf-8?B?T3AwTjRuYjJYRkI4YlJZZUxxWTNNMWdlRnd4bkNnSXBud3B4cWFLSjFSMGhI?=
 =?utf-8?B?dDZjZVNtZmJ0akFhTWI4WUxqU09MQllTMFU5RXVDSHp2M1NoTHJHVjlleWJk?=
 =?utf-8?B?dk5wMHRFZUNYK1UyTjZBYjNMSEswR3pzcmxIbTdmY3o4a3lIb2VXWEdRSjg1?=
 =?utf-8?B?NTBEZjVHVUpJWjYzQXlCMTc4M3NBdSs5RTR3QW80YkdQbE5hT1AzUFpsaG0r?=
 =?utf-8?B?R0g3V2xNWlRKVmNFVU81RkRqdGQvNCttQWEwOGJ6SS81alUxVFBncitsVFM0?=
 =?utf-8?B?NTRLUS9EeWkvcEpDenNRZzVhUEFpamE5TG4xazlmbUFZMHdMeUNwbEtYMGxL?=
 =?utf-8?B?d0tEL0VSS21PeVpaSEhuY1JkbTV2dDVMMDFWcVlJQ0tITkNhSE9iOWEydWtQ?=
 =?utf-8?B?MjVYLzNqOGJoN0JHbnZFd21HVk1kdkdUYXVUYVNxdmNJdmV0KzFEb1RGL1BH?=
 =?utf-8?B?TytQaEZtOTA0VjVxYS9qOUJlRi9jR0NEL0UxclJnRHBPaDR4bTFqRGx6WVFL?=
 =?utf-8?Q?ZsNTnmcmUWsG7Yfi3FmhA70=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MkFoMDdyeS9rVkFwVkFKR0dnc202d0hnT295a3JESGEyL3Y5ZUswanZmSU51?=
 =?utf-8?B?NkdLOHNxMjY5WnAxcU51WGxzbUMrODEvanFPaXhrd3pPUU9GNm5CK3ZHUnVT?=
 =?utf-8?B?NWZZV2pTa2pVajhua0xqY1JycVVXQmFmSEJWMmJTSGkrTzlKdTRYakdpTEU3?=
 =?utf-8?B?dFRabUZPU1dETUc3bmo2Z3lSamlNckJoSktleURKRGZaQityNFFPT0toMmRs?=
 =?utf-8?B?c2tOaWtrZWlKOFdEQTl3MDdmUDdnVUpJcEQ1R1Yyc0N6c1FVaDU4Vk1RT050?=
 =?utf-8?B?U2NUUjJUSE9QR2pnRmt6aFl0RVk2V000RmZpM0FaYWt3eURGZ3NiY1NCRWdJ?=
 =?utf-8?B?T3NZL29MbHNLWTFtR0cwMTRtWngveWM0c3dwWkZtV1l2UjcwY0ZSbFdOWExH?=
 =?utf-8?B?aENlSFhYZ2g0SnhNOEwxaDIxY0dpTWpSM3dSK0Y5ckYvS1hYN0dJTFFZT0hG?=
 =?utf-8?B?WXpDQXNXdXlRTlA3d1c1YldxTW1pN20zaGpuWmVwRmhyeGdYL0hWL0RpWER4?=
 =?utf-8?B?Vmw2L1MxQWQvT3NBeDFvY0RsQXpaakhqLzloVTdpNERIdHJJQVhvSWQwNEhJ?=
 =?utf-8?B?dzBrcnZHYy9tQ3FzbXIwVnNKd2FhdXhVaDlGNlZyRXlTalhBbEEyVjVHWHFo?=
 =?utf-8?B?a2VYNUlaMUlzV3ZLZDU2TlJLZVBGRWIwNG1hU3Y5ZnZPNnVoVmhhN2ladzRs?=
 =?utf-8?B?QkhiNlZjQURKWVdhazBmc0JJTzhYQ1E5L3MvbkMzQStwa1NuM3JjMVZGUGpK?=
 =?utf-8?B?TDF3N0lhU3phbTRuaWdrZENVT0NkY3VqNkpSQjArUjVhcmcvb3JwSE1aSUJF?=
 =?utf-8?B?aDY4blNMVFkzUllzNFBuRFhCc3hBUnZCbEtzTkFGcnBVRDdpR0lqbzEyNEc4?=
 =?utf-8?B?MnJRWDNhWjVCa2pobTVxNUcycjd6eGovMXgrT1NlOG04NDgxeGJvMkcwbkVS?=
 =?utf-8?B?aHc3TUwwZWJFNlF1M2svLzZlRVFaZE85YnV1WWpoL3VPQTJUVDlxNDZQQ2k5?=
 =?utf-8?B?NVROZmZJQmhWZVY0bjNyenBzMDFET0VvYzR3UGxEcVdhdC92Wk0vSFBhYmx3?=
 =?utf-8?B?TnIzM0lrVkpRdUhOVFZSZmF4amVia0w0SHkrQzhOMUhpak9JdnBOdGhDUngw?=
 =?utf-8?B?eVhWTFVUSDZIZEN2RDNndXJLNEMyZnVYS1B1aC9tU0xDS3ZMSEVaN1dvQmlh?=
 =?utf-8?B?QUNPWForOEZZSndvWFBNZklIeEJ6eWNFK0xkektIL1J2cEVZZ2ZCUUZvNEpP?=
 =?utf-8?B?Y05rUHlZVjJWYjBSMWhZRDB4NmZNQ0hTaG9ZTjgvWFRnWmJiTVJYdDBKMXVB?=
 =?utf-8?B?cHZscGdRb2JnSUNKT0I3cm5VV3hDVjJ3UHBhMXZlaHp3RXBrbHY5OFgxVDRF?=
 =?utf-8?B?dlN3OGY4WlIwQ3lLNytMSDhKNXAwRTI4U2dNekdLWm1SQ0JtZ0tsbzhYeG5E?=
 =?utf-8?B?TVZIOTdzRVJ0LzdaS0kwU1piK3FsaDgwSUpFMStwUHR5c0g2R1E3U0FDUFJ2?=
 =?utf-8?B?dzhHdmhIbEdyQkpON3VsRkxqeGtzV3hlMHlOOEJ5UnZtSFZyaW5UdWdQTnVz?=
 =?utf-8?B?bVBMTmVBOHpYTm1jQ1prZzRsTFdJbUdOVnVQd1Ric3BLOGo3bFVZZWlBalRG?=
 =?utf-8?B?NS9FOGdIZVJBcTFwNTZSbVl4MUhKNEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f36399e-268a-4d09-eb5f-08db0ba3d93d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:17:35.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tmEPzDhRD4h1f/SIokX8bStOZbwaY+l3EOsxULGscyMyySAn4KIMV87uu1SOKCDsg+5awZ8EcKIEQyJ4h0W6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100172
X-Proofpoint-ORIG-GUID: AsPo8x9sWK20nbjTjNO_YdArV4RY9fDo
X-Proofpoint-GUID: AsPo8x9sWK20nbjTjNO_YdArV4RY9fDo
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

commit 994b7ac1697b4581b7726d2ac64321e3c840229b upstream.

In the previous discussion (see the Link tag), Ard pointed out that
arm/arm64/kernel/head.o does not need any special treatment - the only
piece that must appear right at the start of the binary image is the
image header which is emitted into .head.text.

The linker script does the right thing to do. The build system does
not need to manipulate the link order of head.o.

Link: https://lore.kernel.org/lkml/CAMj1kXH77Ja8bSsq2Qj8Ck9iSZKw=1F8Uy-uAWGVDm4-CG=EuA@mail.gmail.com/
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Link: https://lore.kernel.org/r/20221012233500.156764-1-masahiroy@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 scripts/head-object-list.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/head-object-list.txt b/scripts/head-object-list.txt
index 105ea7ac4751..b074134cfac2 100644
--- a/scripts/head-object-list.txt
+++ b/scripts/head-object-list.txt
@@ -15,7 +15,6 @@ arch/alpha/kernel/head.o
 arch/arc/kernel/head.o
 arch/arm/kernel/head-nommu.o
 arch/arm/kernel/head.o
-arch/arm64/kernel/head.o
 arch/csky/kernel/head.o
 arch/hexagon/kernel/head.o
 arch/ia64/kernel/head.o

-- 
2.39.1

