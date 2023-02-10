Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1785D69280B
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbjBJUVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbjBJUVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:21:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F4981297;
        Fri, 10 Feb 2023 12:20:29 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0AIR020852;
        Fri, 10 Feb 2023 20:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Zztlk30BauT+Ce8jwOcRAGtBcHOOScbHyyvQMWkJ8tU=;
 b=PKXoKSZbSysxcr3sr3IeeU2lEi0OtPCCJmxbUlF+oyL7AGxQEr9MXk9FPY4IKtoApYjN
 hcOod+VG38XPJ0IspA2C0GtKqKH1BpO16VPzgWw3vPlRrBxntxFBbrGvlGPi/H4iUSuH
 4STBlYpYezyQNHelmO7jNraL20QWw1cqW5FxkjUAzu6PXxcq6v/477O4DQccslKhTfTP
 8csY7sXmKw9D/jZN61zmwzyBQISFNz8HZS69WXwA7aeSHeCUlrk/q7zZ6srX3rXfMqHU
 ufXoAoAEuiJPL0RjBXQ7KRs9leXzlqyW2yfy20l/jtThbob5cLwOvmjkQu3mW3pvsc6o nw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwue4fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJXSbm025785;
        Fri, 10 Feb 2023 20:19:52 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdthtf12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meP72UzqCefoEjbDrrywrZMiu/SHpyArUTVoXradSDWUZPCxy9Szwz5lZFqoQIsmMowWrFPgwW9zfuYr1fsndhWo8zDe3frrwP8dyAe1BI3f3vVYwCpzGEwtH0nGrXGC9uOyeYMOwVUuISQEzp7vFLt9IUPWeqs1oqc3deJZWV/xE3NzYYIhTnbsl4phGMd5vneqAcvU8rKaFCMnYQ/1cj2Jnfe5xQImzO1gqU1MPHbtSpVlaFJPUUcifrbR1DpIuDHLBXIOV2Xjso0N7l/xqaqt9zI1vfZbjZeSyX8m4/KpQQU/jgn6R3dms0+vzqmXeUxGocN68Sy5M88TpxP2oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zztlk30BauT+Ce8jwOcRAGtBcHOOScbHyyvQMWkJ8tU=;
 b=EjjsXt+9yC3ze0CMobn17yHJM0KBFYlGwSobZylcO1svvCp6Fj2NpJe4kRA3uGZ9H3yHfXThxuWqXcSFXKGvOcl7m5L/fPikvjnzU7ZltRSLHGDaMCeL53o2r6cORd7IpgK1Wi6yojc44KxRIPciwhYiWMvacDbUYCB7Yk68mEC5mUxpxPyAp04DqMDFBaCB5e6UfPfiNl1JWqtaW+u7LBa+1j4/iIQpYK6fI4pAvBirUjICMa4OVUoB/XSw+I5E+/ZKfJ6cHKJacgbF0C46qc1o2O5DuJk5UuebD9HS7QZovTV/oMWWpLP4dTaLK1Q3sY6EKGBz4XQPmO1MSMSpvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zztlk30BauT+Ce8jwOcRAGtBcHOOScbHyyvQMWkJ8tU=;
 b=uVwAszMIY4hUaZD8gJH7Rpxegj53+8aZUjiBBfn3ORHNjibF9WuPtru8m160y7EjWJx/1MuRLfo05XZRoCOzlKYiFnSzdjxDwDep9oqaqkE2ctv2TNjEWFSha6tAyTlE1+yKF6CmTqVvHDzoqv7ijrWMf0vu9SYoTeK7jNVlw/w=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:50 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:50 +0000
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
Subject: [PATCH 5.10 v2 2/5] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Fri, 10 Feb 2023 13:19:36 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v2-2-ada7b8d36096@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0171.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::26) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4d4272-d167-4629-e9bb-08db0ba4292b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S6UoErBKlDDwr+JgypvvWCeH04tvRgqKJND6VK0ljgpwU6s6QzQZHsfGHj18tk62WhsXzkeTPPSNWhXd0MfxLHsmi3wWulH6S+SlIZpbrsdvkgnw/P7wM7wiIdG/UmYphZcq3Q73PewMLvsr4Pbu3trpqj3BjWhppc7hbyHMaZuXlMojqaRCqCQ83ruqowmb8QQlkH6o16KyzzZGYIXlfjDK4E0zSD+9rIVwcxiTQ23ic0eHoYuYSEvVgFJhDNEFKeaZbdVgs71cD4x87hbA+Y0R/UV9iYWrZcP0FzjB4KdboauGjamaQyhMMp289u7hnv150Wmv0srarqBw1XuhyKkJEY1HYXCN7AB0YWpEBbCW7HuhbvfzgAud7sFuPcnDjblAVcbd23FLetPC89BBL1elJFXWrzfZICOZPKnqkwEpS8wDu8ejyHfOTN0ZBA1PUXhLnvDYUmYcv6IKmWzu8H6qd1EJdz+vodwZ9LPiJzdQ5ilHwOabBZ9U2ND1bDvfVmhJxIBgy1Q9s5j/Xk7Rl3cagjZcUYB0EkHB+Fbs8eOxGBXIviWkj1l1Ss76MTlWi/XQBVeTrSV7HhcKojdkmoZH5Zk+y6Yibwuj54BuFvCp7UuAuVUtd6MNilduwR6IGvlIKCFrVgVznyPn4lVxzUwHVlQtzwe9ut4SeBajsJX4u4bbqKU47UpnI0UzkIG8Pol+J6jjYdbuwmzhnWimGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWkySkIvTDF0MUZScEg2dXFSSGlzejhFUWR1M1JmRHJXcFpQYW84M1RtQVZY?=
 =?utf-8?B?WTMwYXh2NUJ4VUdHQ1lNR2pic2hJdUhRQ3ZRT0txcXNYRitWL3BveTJSU0k0?=
 =?utf-8?B?NlB4aFZnTDVpTDlWSTd6SnlHWDIvaEUwRUdWQlRrdkYyWHZpWnlMMzRySzAx?=
 =?utf-8?B?SG9VdjU3TW8zNFVLREdDbm9VWHo5Vlp5cVhRc0dXNWVmRlk1STBnWHBCTlha?=
 =?utf-8?B?dGNtUFZLUmU0ZXMrWDhiY1N2ZytSL3hhbFk0SkNSQXRmbU9jNmhGUkZ6amVX?=
 =?utf-8?B?SDJ5RmNObVFud2VtYWVzckFiQnJLOFh2RWloTXpacmU3RERqNUV6Q2N5TGVE?=
 =?utf-8?B?b3RyR1cvWVpKUE50UUtONW1WeXhCbUQ4ckpPbU5DM3BreXpGNUdWbkRlWXFT?=
 =?utf-8?B?MGMxcThsU3Jjak1qZ1YrUTRYanVxUzMySXVaczlDMnY1TTh4QWtsVVAwQlNB?=
 =?utf-8?B?TjZTTWYvZEg0OW5OdjBnK2VDVXlNN0dtaG9SS1ZLaXdsYnBvVEtmQllvQ3o3?=
 =?utf-8?B?NmdRZERSMkZYZTNtYWJMSU9QMWRIbndENjdWZXZCVG95RE8vWnY2bDg2OWlD?=
 =?utf-8?B?RmM2MkVnSDR2RVVVcktjZjJ3dllFNnkyUFY1WEZwNmtZRlVtZWRjTlEyZi80?=
 =?utf-8?B?dVprYTl4c1UydDhoQnR1RkJ2SkJhYnRFRi93VDRxQmp6T3FxUUJlb1M4S3hw?=
 =?utf-8?B?djFiaDZSc3hLRmxna3BpR0hmeHhiWDFNWXZkUlJ0Z3p1QnpKWE5ldTk1YWpJ?=
 =?utf-8?B?Qm5SejFHUDM0cExSSlBoYmxUdlpRKzluT2ovMWJ2azREODE2NDFyUC9td3VC?=
 =?utf-8?B?WjZhdUFvQUZQZjM1UFNUWHEyUkUrM1ErZ2VMVTZmN3UzVkNBbktLNzA1bGpr?=
 =?utf-8?B?VzdNMXU3WTdOQVNTK25PT1FMUzhia2NGWCtpZlArU1VMUExIZm41ekVaQ05V?=
 =?utf-8?B?ck5CUHVDOTJFcGNuazVRWE9CbjVQS1UyWTl2VHE2alpEL2lWUlVkamo3VGRQ?=
 =?utf-8?B?Zzc0RDIxZVd4SkFkbHJTSjRrVm9QVnE0MXI1clY2aEpXRFh5TnlFaFZrbmFZ?=
 =?utf-8?B?clBtRXNsMWwwWWpLNGJ2NHhkUklRK2Z2cjBaTUwwMzRSNmpJY1dKWk1WeTAw?=
 =?utf-8?B?VjZ0enRRUWVxbWV4WFp3THBWZE9FZE1iMVNBQVFuaWVkUWV2UjlNMi9tNmFa?=
 =?utf-8?B?TmNXVGlQQTd5V0FmYSszWmVLQ1BZL09UUHc5d1RqL2UzdmVKQ0lWYWQwUnJU?=
 =?utf-8?B?UjREU01RNjhjRURKeFpLZHFGT20zbnFGejdLN2hmcDBwaU4yeXl3eUtXMlRZ?=
 =?utf-8?B?NS9qNTJCUlBsd20vcjhBczczekxnSnBpSk9aK3BlQnh6b2V2RWV5alBKVUcy?=
 =?utf-8?B?U0EySW1WcXZxNmpEYnpzajN6aVhZWC9OZzRtakJFNWNYYkxCWVZ3T0FSUnB2?=
 =?utf-8?B?SUI3UHF1S1Z6aks4Sm41MDVyb01MUm9aTHlIaWdkNVp1dlRoRHhxMWY4enhJ?=
 =?utf-8?B?bUNPUFd6aE1OV1VTNDU0dkJzSENIRjBhcml0LzM2SThFTisxWjlHSGtCRVJi?=
 =?utf-8?B?c3JaTmhUZXRrNExEeFZyRTNvNTdkUDB2WlFuQ2NOamdENlBCMkxrbmtaai92?=
 =?utf-8?B?aXNSQ0NxbjhFanQ1aWlHKzhpZ3hhbmZSUmE4MzY0cW5Pc0o4bGR0dzJBaWpi?=
 =?utf-8?B?NGc0NlNzU0VBOU9VYkNWY1lSL2VQUFVQL1JoYmgxZGRCRnZ4dVp4WkhqOTl5?=
 =?utf-8?B?cDJVeWFnRmFBaERaNWhMaVJRdE9XSUkrdWtwcHJpdW5JeEt0NDF6dW9XdU14?=
 =?utf-8?B?UmVTTzZ3dm43c1dwczQ5eENVTkdVM3pKajBaWVRzc21vNXZYZkkxSnNmaThN?=
 =?utf-8?B?N1p1dUYvblljUHpveWY4OHM1ZWV0ZEtYOTdEYnpUdy9KZUtqL1VncGZMdXNH?=
 =?utf-8?B?TGYzakJiNDJSY05pd1h5UStGQkZjWGViQy95WXpjTjR1eHNrWEdjMlF4T0s0?=
 =?utf-8?B?NERXYXVSTWRHOGY2SEJFZjJUNGV6NXFFaGJzOFk0Yk1ZeE92cVBCdzF2NlJK?=
 =?utf-8?B?UkhJaWRtN2VyYTFZanhsYmVJVENBWWJoV3NMTis1TzZuK3gzUmh4U0VUU1Fo?=
 =?utf-8?B?Z1d3dzd5aS9XL2tBa0xYeGJTRTNORXRVZ0g2WkVMM3RiUk9XY0dWeDZVbHVp?=
 =?utf-8?Q?X5yzFkFADYvmStL++b2oKwQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TEV2TzB0R3FwWmZIM253bkl5N1lpM2hlKzZ0NjhGb0RMb2JSR0ZNQkQrQ0pt?=
 =?utf-8?B?WWxUd0k5Y1d3RlZMZWczamFaU3pKNGhtK2ZpMTdJY054NEFTMG9JdEtGVHVl?=
 =?utf-8?B?NGdSKzUwM1R2TnBBd0dTQlhLZkNYT2g5amU4OUhhUVhHenova3pmV1NPbFJ3?=
 =?utf-8?B?bm0rRkZjYUVZTE9ZaTcxSDIvOFltWDFpOWxDTGIzZ3ZvZHdWZTZPMmgyN0hY?=
 =?utf-8?B?c1RCWVg1ZGRteVpTMUQ3c3RUcmhrWGVzY0tSV3ltcE9hTkNneGFQY2NvWnpp?=
 =?utf-8?B?Q1hTdWRmSVE5dUFYakpOejZyYW9NQ01RUTlhN1ZiMUhXdXM4ditFSEhNV3Bx?=
 =?utf-8?B?Qm1yYlo1Q0ljRFlzNlZOaEZGaWpYbERXNXFVSjh1bSs3TWs0VXVHcERqRmpN?=
 =?utf-8?B?U2FHbklVKzNyRFd1UUJvcmZudmdMUENsdSsxbUk0aktuRjZpQXRtRnRXVllw?=
 =?utf-8?B?cGJLZlZYdkhFMnJ0czVvNm1HTHlYS3YrL2gzV3czekdWUkFNNzdVY3dvS1Nl?=
 =?utf-8?B?cnA4S3JWWmVsMFp3NzJXTU5xbVdzOWJjYnFkQnlleUlqUmIwcEpVc3N1dnhH?=
 =?utf-8?B?WnBZc0swR2N2cU5BZ0NyS1hwNHhKcGhpWTRqOXg2UkNZbzBkNFVoWHdFTXRx?=
 =?utf-8?B?ZUxrbGNUc0FHQ3dGSFE3VjlpRnJXc3JCU21xRVRWRzNIREsrbFk4b1JnMkxq?=
 =?utf-8?B?b1BtcEF0OEt4cmNUNnZnMC81WUFzNm1qSzhvSVRiR1QvQkpWTlVEeGZncXVp?=
 =?utf-8?B?N1pFdDUyQ2J2WXdKVkN3SGVTMGZRUXdtWnhsQmwvNndwS1Z0OFFkcCtJOUZS?=
 =?utf-8?B?Qmk0aEwxUFhyWEoxNjMra3NTM01aWk5FOW1nU3p6bCtRN0JUN3FqMXlFcHdR?=
 =?utf-8?B?c2kveGpTVFkzd2NrZU5mR01MK0tKQ25BWmVjenBqenMrY0JaeFlmVTM1djAy?=
 =?utf-8?B?UEN3YzZOTkYxUEJDazU5TXZic0hack1qTTN6SmpGRVFLMnpoQVFVelZUUnRI?=
 =?utf-8?B?eDBad2xyUDFhZ0dUN2VBV0l1YlFROENmUHB5M0ZkUE9ZR29yeDNNTTRFQ2lK?=
 =?utf-8?B?Q29qZ3NXVTdCd3ZITEM1OUdWVTJlOXFvbENDUVR5YXl0WFNLenVYdjdWNGVv?=
 =?utf-8?B?ejFra2dmR0sxTVNFMXFnbVNxN0VVb09IUldXcTdqZDV6RDNkaDVMdDd5am9C?=
 =?utf-8?B?M29TM0J5SFo3NFNlR3p5ZVIwWS9uY0IvSmdsUlVZVGdqRWxxSHVzL0JqRGtX?=
 =?utf-8?B?dEJFV1FSQm9NN1FsSy9JaTlPNWgrVjNtMlg1L2VwZlYrcWxDZ1VTb3BuNTlU?=
 =?utf-8?B?amxXN0crZW84S1ZIL3N4RzZmclVtVmJnTklDSGh1TDBSNXdMQzhteE0zbzha?=
 =?utf-8?B?Q0RIMHhQMXMvSG1wdW1PV1NUMVZDUWEyVHFIb1o3em9JV3V4bXZBdDBwOEJD?=
 =?utf-8?B?TG1JdnVnbTYvR2E4ZFQwWlcxRWd1ZWVtOTR3OFpPdkNiZWt3SmJidmVpK1ZV?=
 =?utf-8?B?WlJvL2h1VjZkdDFlaGVpZ1lDSTZOYlR5ZUlOR2lUZUo0NWRCd0VaY1pFVXds?=
 =?utf-8?B?SklEWmVid3BESVhndWVBQUdoTnE3Z1FYZnlTenFDZVRCWW9DVm1LTkdYL1lW?=
 =?utf-8?Q?boeVM0MICtukpDsOdNs8fiubYcTFZkgdo+4wUf7p7uw0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4d4272-d167-4629-e9bb-08db0ba4292b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:49.8842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XS/ZyJW4JSzknWRG/UBwLzyvKgaTz451R1CkRmQEcjrp3MAcrJIuGMYSorutjrDTOnDLAT0VHCE1IWQIZe0xaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: tEaPRlKyinHWM0fM63SamRKWUdYq8U8B
X-Proofpoint-ORIG-GUID: tEaPRlKyinHWM0fM63SamRKWUdYq8U8B
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
index 4a1f494ef03f..e3984389f8ef 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.1

