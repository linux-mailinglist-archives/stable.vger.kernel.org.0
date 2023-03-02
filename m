Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB83A6A7947
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCBCFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCBCFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:05:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0975248E2A
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:05:05 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MpXfC011760;
        Thu, 2 Mar 2023 02:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3jLTDVfT6HYQkiXuTu7dZ0AUyWdxQyRqD/EqYY4DWgs=;
 b=PTVQ6RXaNBye/WE3o4ZvPN8IsFCbwAXwVJrscI/qZB/0aHZEiM01Y/9OMmRL5vEdxB+i
 lbvz6pcSHFyKATVDcjkLddbzEj9V/3QiSyy8Pjzz+akxc80k9qNnZHBaLeXkd9XWXd45
 l8GS3NFjx7sIdvirt1ATENYKAiFWAnHiZWvyaDyP4CzoQgWPQOLmA0SZQ0t/0CIRXhUe
 eFw+ICDvc4aMF04QPn9cnZRtd8VqxlpQ/ccMHybH3zZlenGziJMju3yMRnP2yyfKQgpm
 OjmMw/KrxHOQ8kU36Ei2RUPZdb444IDq1w7IQ05np+9QtjizlyTX+UkNGuqjanwHV5ED YQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb7wth5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3220Jq9g013169;
        Thu, 2 Mar 2023 02:04:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9cmgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZaGXCARiZcQNackqtISVn2v339PP20FO+f4m9wpn8O3cqLa605cgw+4kvkCtV0R0oqcpdkTvoJN0jw6qAZcqKsktmLWYyx4hEEv8w4dDL8Gsgi3y+noMe/cky3YMYyKU/jukil+3kChzVgQgMH2hI8pEa8RYSxJL6yCvYofjgQI672H4POLUBqsOCB7akEcmOlhmijjAOHclfQDeUagptSDY/9oPC9UzF8hxTWj/mFJVPc2R4qElUf9F+hpXzDBN/TBF8YDTSwNKHNSYdzNz+l7og+YsGLx5wjqGWJQezLS/O5ymxnGzRMvfWgECnEUzyW5Aks3Zzdlkk0jEAaCxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jLTDVfT6HYQkiXuTu7dZ0AUyWdxQyRqD/EqYY4DWgs=;
 b=c1dF4lobCw2OKp4GtljUSHsUwUUZGlA03mmhGGpHvW0xeoFJasYApxK4VHhvCn127EXt+WjFZjIM9fCqMCjTfxJOYMu4wh0A6y5K2l4H64Rz44udlrIfUIB7Mn9Y6jy5SnqXNScfT5Ld1PdKJ0fg5Ag73D7RnNQR53qAmLnXs6onUVNcLEFJQ7xIDFk6FlN/M/Gsd8RnwU7DKyQicJ+ZgJcaFXFse7IwOxa7feq+fp2tV4UQBbRXM3Xsc7OGHxB5yx12y5nkjwANkY41yP2LtNqY+W6himRGyfolIw7FRdnvkT+Xk25Spo+BI9JSe0tWwrdOauiOJtxgkqpuO1dN5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jLTDVfT6HYQkiXuTu7dZ0AUyWdxQyRqD/EqYY4DWgs=;
 b=uKqr4ZEbJO5jH9FuHYXly23Ptr0+hMoTaJ8CNhnq4XJorV5PdyN+T48Kjan584Ax9uv6De2iDzPnNbIPlHwllzx8dRtwNBkIx07W2ee2VQ5eXSSEa7GqZjk/YEY+Ei2GrngXuqw48iBcNSAGAwR068mUcPxkyMQkUtoD9K8hiwg=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:04:22 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:04:22 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Dennis Gilmore <dennis@ausil.us>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 v3 5/5] sh: define RUNTIME_DISCARD_EXIT
Date:   Wed,  1 Mar 2023 19:03:52 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v3-5-3431a425f0c7@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::34) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f3aba5d-dae4-411c-7598-08db1ac270eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x1V0PfrmSHrBnl8rRfMIFad0gxvVQIoUsmjSmQ5zbD72NUocDHrtXezi6vGgu5lZ1XO1AUxN6+2wID4zOUUz8t2Lkkta2jtmZKUNyQrCl+6aXMIre65ELlFMXwvkbxt9csj/XADii+uWbJNPf8jyjz5vzoTDNPY+3GxjMNBK6r9vv/IzOJlDgTV50EcZ1GZKmnEqYKt1olftcS+Qh4Y7bmY2hXEkh8QYBbkV+EhkGW5qzb1vGEzz2E+18QSjxKZbIKQs8G0b5Ecn3BDbwmDnYwuzq45FBWL3g4paF9h4iErru6aIrcfkZCtAW+jjOu4JjZy72p3YDqOya5+q49iLoKbKnKXd0JaqHEjzXNpLv75sLmkv/LlI4fFzWro9szM4fY2bvRKzlCvKnpPy/Dx2l1xaARVbNkDzKwEXCaCAXWFOGv9g15FkyQF+ifNiwN1lFi1rZzeEvZaoOsNKZ4pY50c62DJJ2v5IR6pBHVpXI2CdCcZ8b8VaxvVht0l9wZlDQWHJFqOZQZBpU0BHMrCDPIEx2I07pfg4n3FlHAGXd262XDXCLEM+ggYFBnxQ7cS64bj33pVjd0QUAsVATKnOA3S1cKFkFiun1gRDWTX9wmSQkzwI/CdbODd37aJ4zbTZQqqyqprUjl4rhWGKrORTkaZKX6LfUolWpscNXVO3hME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(66899018)(41300700001)(4326008)(6916009)(8676002)(8936002)(7416002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTd4eG5mY3QvVGZHQzE3UFV3LzdtSWdXSnl2V3RMNVpiZ2N0aysyaVpWWDhw?=
 =?utf-8?B?L05LVTNnZ0ZXV21xNCtNbWIzUDJTOHpvdHB4WFZueDVMSjNsbmVGYU9XWUpr?=
 =?utf-8?B?NG0zNVByRXBKWW1mS0lUOU1yUzlpS1B6V2RlZTNkVXA5a3pMeXJBeDE2c3Bu?=
 =?utf-8?B?SXJqRUU5SitiaWs5bWFTZGw2VVhtdmRSZEFqUW1uNEFPTGs3S2hFeE1JT2lj?=
 =?utf-8?B?N2N4ZzdIUzU4ZVRvWjErKy9uYnRRa21nWDdqQkw3NXh2RllzL0Q2ZldYT0Fa?=
 =?utf-8?B?S0RrU2xuM1d2cjdHaDdEby8rWDhvd29yUXkxaUFSMlVSMkxKTjRTcDE0bEIw?=
 =?utf-8?B?cnV4cFFxUEdRZmRPdzdEMXpnRXZjMzhrQ1lXdElJVzFXQXQvcG5kaVdjRmZE?=
 =?utf-8?B?Vkpid2FBNGRjMDZpZUpyNThSbWhoZEo1N0FIejBSMy85STlSTnNVSzdBcXZH?=
 =?utf-8?B?Q3ZhV3NYSHZkdmFFdlFteVhjV2h1ZDZETzVFcy9VcXowajRWVVlnR3paWjVI?=
 =?utf-8?B?TFRaT21QZGF6UG1FUGlDN3lUVE1aQWxpZlIxZkllbUdtbXpMTC9laWNsbFkv?=
 =?utf-8?B?RE5ud1huTWpCaU5Qb3owb1V2QmQzbFAwenZianBEZXBGSDBvZHNhRDdZcUVs?=
 =?utf-8?B?WmM5N0o0aVRtWk5vaEF2T2t3N3VoM2YzS0Z2ODZuQnJXYkxZTitVTUxaY0Nh?=
 =?utf-8?B?WmtNT0FGMGljWi9HZnFEc3N0V1hTSUM4OVBoRHgwU09lUkd1c2RGY2ovaDRq?=
 =?utf-8?B?eDdFVWllUGdZeDVjZjdqRVdVQjFYeDFoUWpSeHZDNGxGM2p5RTFQYWlrK2pM?=
 =?utf-8?B?VGVnbk5FeGJDem9aOWU5UStzV05vNlVxbEI2OUdhUi9HQUdYb0Yvci9IMDFH?=
 =?utf-8?B?cVRxN2xkMUVnTjdDWlZyaDE5dEJOSlVFVjVUeWRkbGdpZHMzdTZzcXNzYmFk?=
 =?utf-8?B?NmZ3UGFBTXc1YXM1bEpQYk0yK0txVmlGUU9MQ0c0c253eElRWDdIRlB4TWJr?=
 =?utf-8?B?NURocHBpelNBaXRCTWZZdjhrbDNtcVRvSkVQQzJ4dnBZL3VFK25USVhLVytW?=
 =?utf-8?B?UEo1Z0NlZG04OHRmSG44akhGRmdqcWxtOXZqRzg0MmRZNkxtV2diaFRQZ3Y0?=
 =?utf-8?B?ZTI4eUhTbXNOSkdtWUdHaXoxMlFTaTZWdWZubUNSRTRORDFLcit2a0V2anlP?=
 =?utf-8?B?cWYzakp5bFY2T09MSTE5QWt3b1Nvb0k1UHM2TElUTGt5RjRpb3ExYmpqMzZj?=
 =?utf-8?B?R1hGeWQ0NE9rUkhqbHNLeGNuRlNZSlVVUGU5RVBWYi9adG4zTm5aaE1kWHN2?=
 =?utf-8?B?OXRqSWprUDQxWFNlaUlweVJjNjlQQllTb2ZRd3JXeDdWMEVPWENiZG55MjBC?=
 =?utf-8?B?cStodG15b0R0S0ZhQ29qUlpDbFBWcHRBUUUvRkhsdnlsN29EcW13ejVRTWh0?=
 =?utf-8?B?YTQ5MDVaMjlQVlR0YWpRNkN1V2FSc0VZK2k1aUF3OXpUcEJiTG4zSHQzQS9Z?=
 =?utf-8?B?bWR6U2Z4TFFLemlTYXF2b1BaaElSUUtlVVU3aVlpRXhYbENiK2tSL1ZkUkNL?=
 =?utf-8?B?Tnc5VUd0MGJaYUM4aSt4VXlRREdMY2tDWkxGekt4VS83T1VHczJmTkhCUits?=
 =?utf-8?B?WmIwRGtjT3JJTCthcGlXM2piQ1JURGF3L1NUMVlmZ2Yvc2xWNFZtZHl2VkU4?=
 =?utf-8?B?NjVVZWJMTlE0YnhYclhxU2J3Wmh0Y1AxUU95dzRnRkxYRUQrS2VHa3pDbVV2?=
 =?utf-8?B?VXluRURUdUVpODJISThrZ0lnMm0rY0t2RWg5WDdwTW1MVHhrWTVzSjdXc091?=
 =?utf-8?B?VGU2RFczRzViRXBWdTBYT1h5MkxVZU8rSG5ic0NPKzFGYmR0aTJwTi9rWlZZ?=
 =?utf-8?B?dENMcDNlSVliQjgxODIwdFJ5dkJhbTdEVWRXdW5DSTIrcVlTcWpSc3I5aU9F?=
 =?utf-8?B?L0xHczVwNnRmQ00wWGxZVUVDdnNhNDViOGdsRjV2Y2hCb3lqS1lob1RlY2Rr?=
 =?utf-8?B?aWQzYlNoTVFZaENRRUl1U2J6a0F1YWtFVVZ2SWZKRGV1NmNxNjRzQmtvdTlp?=
 =?utf-8?B?dWZjTE0xSDZibFd3eDVKTXh0T0h1WmdMKyt4S3A2VHN6Z1VCNExnYW1idWIz?=
 =?utf-8?B?QS9xaU5hZm9NbE1hREc5S3BUTnE0dFY2SkhhUDRxSERTc2x2TUl6NFlHNkt1?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZEgyazhyb25TVWoybnBzdGJPTGlEd0toN3JKeUNBK3dSRGNTNis0dDRjd21H?=
 =?utf-8?B?TjNuZTQ4dnBWVWY1N1JhWG9qbG8xOUUwbGhEWnhDcnc3RUgrYVZrY2ltclpQ?=
 =?utf-8?B?M0pTeGM1UEZncEtwZDRnL2llei9ubnkyeStEZXlzQTltSEZTMHFSbVlUY3Jz?=
 =?utf-8?B?SkhDaG1sQnNPeE1XRS81TDVjS0ZpSmxYT3FvSDhZNGVjT2RUTldWa1g4WE9R?=
 =?utf-8?B?ZkZtRVhlY2J1dWJ3NFkxaUZMUzNCMkN4UHpEdFdDdkhrNGRqenJ0V2VjZy9P?=
 =?utf-8?B?TUlwNG9tSGNpTXZzaWNJMVNYR3Z0a25KVkdNN2FYbmNEK0I5c3NhUVhUQU14?=
 =?utf-8?B?SEpzTlVNSnNzYlhjbWh1V25lZmNiVFhVcVhjaDdXUGlIOEpFOVF6MVRQTDl3?=
 =?utf-8?B?VmZmSitMZXRBZ1Z4VjJoY3plMkFlU2ZscUdSa1ZOMU5wbi9aQ2dUU2N2VFZz?=
 =?utf-8?B?R3BXMDgyYlFTYW5iMlpsRjVzbDhCNFJ3aDdGaUx3Wm1LVnpHSEFjUHkvSmRv?=
 =?utf-8?B?aWlTV0xpYWxVU01hSlRVcGYybVA0L3JkY2hTRmplUENtU3lvU09GS1FYdVFE?=
 =?utf-8?B?UnlLYkp5NGRkQnduclNmYXhEY1cya0hCNVE2TzZFeXI4SWgwYmpzdWJURWJQ?=
 =?utf-8?B?ZkxmM2FHWnA1dkxjTmhoZGhmNE1yMlhWUk50cFFHbGVwN1hrUmlXTlN2OEUy?=
 =?utf-8?B?aTR0Ni9SQk1IRW9qNFlKZnVGekhJOWZwN1YwSy9PU0RGV1dNVzBkd3RGZ2NJ?=
 =?utf-8?B?ejFWMkk4NkJCRmo2ZFVGRDBtSXhsZzFBeHBUem8vUDV1czIwL3AvUU1pUjAw?=
 =?utf-8?B?aG5pYlJHdy80WndLakF4RUQ4RXRidWFuUUhpVVp5cWthUS80V290NkNQdXpn?=
 =?utf-8?B?OGxjUm1KWVYrZ01RQUtTNkhjVHdDYVJoMHdHNWc5dUdxUU44UVF3NW1UWk8y?=
 =?utf-8?B?a25GanBiM3owRzdiaDJLci9LTEdCeDUvRmM0eEhnTHdjT3QzT3hna2NTYjk4?=
 =?utf-8?B?OC9wUHdmcjhCKzFwV3o2T1ltdXJNcExxNEloUXRQNXI2cjE4b1dyOFZ4Mzdo?=
 =?utf-8?B?TUh4dlZRT2hXL2hjVnJwSU5teTRqdjRxODJ6OHBNamFjTlNGVkVNU0pxUklW?=
 =?utf-8?B?UnIzNEMwb3hWcElCRWFpNjhxKzNXUmJncXdSQUtYanpkVlFEMTFaUmFDYmJi?=
 =?utf-8?B?Mk1Gbm5zK2JmV25aeHVoQU9zYmxVL3N6bkxxZVE3UjJhS2EvZGUwbFBUaU9a?=
 =?utf-8?B?djhrWWh0WkZHSkhUazRmY1A3SUF3c2FCYlc2NzZhdFRrbjVPbmI1Lys2cTda?=
 =?utf-8?B?NUgrbGlNeHdQUkFWRkhneDN0QjF2RFpHb0lXNTkrUXRhczhvZUdzSFI2ZGt1?=
 =?utf-8?B?SWRTMHZ6d1lndkI3ZnNLejRpTkpJV1VZNWpJaGhldUJEZGFDQnFnQS9TaFQ4?=
 =?utf-8?B?SHd6M0o2VEdZd0hGMlB5ME5HZFBwVjJZa29pSWkyaWJQQ2lobXFBWFp4QkFR?=
 =?utf-8?B?djdsNUVaNlVZMjRRYmZkTlpob2g2Z3pxeU9VeGVzWWNXVWJQaEpTY2pJMlFE?=
 =?utf-8?B?dGxiZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3aba5d-dae4-411c-7598-08db1ac270eb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:04:22.4920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 64DKsugYVXjEdd0AQYaajHe5yB/AO4aB5/PFGEkX/NMust0xjHqIFcBI2G3SImOeiux9Ba8W3lvwhEldvcR3Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-GUID: 0ahwZA5kzimxrDL052O9wwkHq-9TRfMl
X-Proofpoint-ORIG-GUID: 0ahwZA5kzimxrDL052O9wwkHq-9TRfMl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c1c551bebf928889e7a8fef7415b44f9a64975f4 upstream.

sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").

This is similar to fixes for powerpc and s390:
commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
with GNU ld < 2.36").

  $ sh4-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2

  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-

  `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
  defined in discarded section `.exit.text' of crypto/algboss.o
  `.exit.text' referenced in section `__bug_table' of
  drivers/char/hw_random/core.o: defined in discarded section
  `.exit.text' of drivers/char/hw_random/core.o
  make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make[1]: *** [Makefile:1252: vmlinux] Error 2

arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:

	/*
	 * .exit.text is discarded at runtime, not link time, to deal with
	 * references from __bug_table
	 */
	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }

However, EXIT_TEXT is thrown away by
DISCARD(include/asm-generic/vmlinux.lds.h) because
sh does not define RUNTIME_DISCARD_EXIT.

GNU ld 2.40 does not have this issue and builds fine.
This corresponds with Masahiro's comments in a494398bde27:
"Nathan [Chancellor] also found that binutils
commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
issue, so we cannot reproduce it with binutils 2.36+, but it is better
to not rely on it."

Link: https://lkml.kernel.org/r/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com
Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dennis Gilmore <dennis@ausil.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/sh/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..b6276a3521d7 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,7 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>

-- 
2.39.2

