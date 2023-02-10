Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DF16927FD
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbjBJUUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbjBJUUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:20:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C380E81CD7;
        Fri, 10 Feb 2023 12:20:07 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwjcq007847;
        Fri, 10 Feb 2023 20:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=e3umdm81dahy+Zhbs9L57FHDiKgSN37UUlTTkTbgOiY=;
 b=aKXGzd+wvykP7Y8ZMRNx17x2IlAqIbEz2Xd2N1+Rpd6bd9JfnFQ7EZc+YStTMl9loWWl
 s6Xnrs55+nRL5nTJgQTMxKSGyCvx6hIXVDBdfk3V62WnAKmd+oE+1tQypYyh7M7Q2RcG
 XKfs0hoAPXihrqlFP6AwoGYRzkalA3bQr7acK3W7DScAWkLt/gSZRJj6pqalS6UOlBLk
 x5FbUQXCxfenq42HeYD0v1lqxInj0ziwsknj7grQwnPHwbaFFJHVpkCB2HlXePv0G4A8
 bteVI4H55ENUgAjDKBVfovGCmeisyAxBm/UtI+rfNmdmPAyN2CBAr0V6n/azXRkRNzwW Lg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdx4kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:18:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJ6w6i025750;
        Fri, 10 Feb 2023 20:18:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdthte9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:18:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGIp0ELLcz+tNCq5lnEzZXzJ/9o2Qc3Qmz8WUMmpkMuy7aXpsjz6I6hS5aV1hlkH61aUNXXK6iUhgm5PeHaXV72QOTcsx8Gen5RlAu0kDMGb++Vk6tqVQEQz0sGoP06DbiicaceDOw07SCs41Kv7Qy/RZ2wyOufSCwpVfIZZcJyN9rPqkDHljNE89C2NmV/FeYY1SVL0e1Ap32km2lEhWo9UQXdtk/i+aqVWareLAjMt20oSNwCsAnjdG3SDXxrPIaaZXEkHQYwPxCoXVd1TChDm20m2tcnx2iEN/+J3T5d0K4EuHXRhxqjrRpcclAGd7YNCSaj6o/EUMTJMyQsKSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3umdm81dahy+Zhbs9L57FHDiKgSN37UUlTTkTbgOiY=;
 b=bVXX0n5Wa4nmhefyDGYt/L0jDOEMwEUilE4J9Piitl3pXkjESliDRcN/g1iilGSXdMxQ0vqeHQaFlguHjc47qfskk1vehCFSFEi6tOQ8rihR54wT3XkzWqH7QtVnkD6bVjUUAfw+i6FQndBby1m9wMz6YM3TafASDL22W3186Q3m91qo8yjkT4PYLmmrNe1vufT615vvfVgbH7GswSPs+GAiBZiiFV/M448OBHwBK5c/g//X3EiXG/t3ZbjXOtGwEnbm067ecmUQTfKJDPZiAaGvtTP3bX6D/aQ1TwJQ2xoWru5VwgUBhzMsQDOIMNdZwe6HgQhGQ0bDQLUmIVDC/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3umdm81dahy+Zhbs9L57FHDiKgSN37UUlTTkTbgOiY=;
 b=hcF2W/4tPFVjapZGkUyb3FMQ764Zsb5yQ7CV/TffqmdI0vPmrBTqV+cTK3aLSvKc9xrKOQgd3gZ8Bnx6jk4m0K4KrheW7VAvEUg/pDbRSR0c/kP722Ec31hgGcZ2JwQ/abIY4pTFl0tS8P3K6KP938twTFtsMnyoa9AFpilia6Y=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by PH7PR10MB6083.namprd10.prod.outlook.com (2603:10b6:510:1f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.6; Fri, 10 Feb
 2023 20:18:51 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:18:51 +0000
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
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 5.15 v2 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Date:   Fri, 10 Feb 2023 13:18:39 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::27) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|PH7PR10MB6083:EE_
X-MS-Office365-Filtering-Correlation-Id: 29cffd04-6627-4f24-5672-08db0ba405f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kX4+i+xIkXibshrmS0Vz3v8bNJ1YhUT5PVqzv63JG2LDNX5Ej+LzAyymumUWBLSALnSlhr/jdHinT8TonfbaUA1dFHOLxhvsB+RRvY3CiBlAAp4aEgp7rK5Ttg6g9n7Wcl0Xt1qeUhVRdJFyxNBkUbY++uhWXlbDZTyddvwq5BAplXM5/1EiaUWlvZ5RQ+8v7EzfkHreIxndS2LDEoy+99nLqqKgEQeOocAXbWW6CLM/MMZgNlgspW9j50vTY7+j5vu+M3CLoH7l8xgdO/JaTQQIYdC2KTkpOuK3bJNfQ7sR/+XHMUS13f2TYRftQTcHE0PS2E1jbGHn1z3YwXtu3ieN20OyTPJ6Ldy93aBuxApgk2IDoO8vs93hu6kmMJVfWFkIR6RgIXpldNYY4wvMIE4KmDjUltsGJgkQpAsp2RUlt2SeN5POzER5HM+yBXCDuH4BiOTjo22ca8X+kF/4Jb2/ye/46I52/lRKsYpEPtxPwQUTMtH9oY077jEXYfw0raLpi9WoxqRej9KP4ZkBawhSNNTBm7vbdjihzN3OHJ2Yt+wPMSDbHKK4InfpNytM4GNYLoAjGAp4paOZOD6jX0j2p+4gGAZzLbWAB/KeERqrRllqn5W1tI+YDZblfv8c9aM8Q9H9NPu5ImHQbaSFXWu/1nzjWsQm/o8qKS02n2aZIUZ2FaUvM2cEhCRwaSSsVij3VsGDXQ7ftYXGnDcizw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199018)(86362001)(36756003)(38100700002)(6916009)(8936002)(66556008)(8676002)(7416002)(6512007)(6506007)(66946007)(4326008)(186003)(66476007)(41300700001)(44832011)(5660300002)(6666004)(478600001)(966005)(6486002)(316002)(54906003)(83380400001)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWxGSlRsdjZ6VEZRdmM5THlSbWtZQ3lyK1VJMlNnbDFySUlibElBeml2ZGdx?=
 =?utf-8?B?cGtBWlVhbGkwOHN3VEFHZVBVWmhHTHJSRmUwSFhXNXBydk5sV0xNR0o3WVMy?=
 =?utf-8?B?SHdnY083UHBNcnI2RTJaaHlkN2N0MXlxdFRpd2hIYlJpYkFiYURLdkFmTHVh?=
 =?utf-8?B?bVdrS0VCQ281WENhSTBUUnBWRnhuOGtPV2k5K3J6NjdFSVNGQ2xLUWREWVhl?=
 =?utf-8?B?VCtJOVhBYnJuVy9QZ2NCZkJUSmtSeE9CeE1idFRIdmRWei9BbFF4YmREL1NU?=
 =?utf-8?B?WHh6NGN1bSt6NjlORDFiU2l5OTQxd0kyUkszd0EzQWxSYllTVEhIWmtmMVRa?=
 =?utf-8?B?cnUzSC96RFZIc1J5ZGxIWklIbkllWDNUYlRjck9mZG5CZ1pFeXE0ZDhxZ1Mw?=
 =?utf-8?B?QnJwdFczY3FDMzdYM3pjMnJEVkxOVEZ6bFlpN3F3MUlNaW1oMnVrWFV4TXU2?=
 =?utf-8?B?Z0dxblN4UFlTOG5HNTdiMHhTM2lWbFlrby8rR29xWWtSaDVRQnBGRkovYnVv?=
 =?utf-8?B?WFZENEZzSThYSDJybUZ4MXpVZ3RWYlM5RDRTSituOElJUXJpZlVkaGJ1ZTQr?=
 =?utf-8?B?WC9aQVZOeFBudit1eXdUQ1A0NnRZY2l2c24yVERBalRXNVpkSGFZbWpMQXE4?=
 =?utf-8?B?dVA2bU1PbG8xK2MyTWNtSWRQZVlvRXNWZzlERFY1Wkg4ZEdHdWIwOXZsb2lX?=
 =?utf-8?B?NUdzdHlPUjI3WDRTcWU5UURyQUVKeE1BME9TVkloSUp5czUzeSswc3N4MG1w?=
 =?utf-8?B?WFdoekx6Y2REOUFLMmNiNlRyS1ZFMnFnSnl6a1AvRnY5UkVnTWk3ME1MVEVO?=
 =?utf-8?B?N2NwelN4TjhscEVvT0g2a3hsTC9XZlAyY3MrZDdIZVhaZFM3UkVCcVJZTGFE?=
 =?utf-8?B?Q3YvNUZkWGxlalRYMWRoTkNBVGRWcnd3VENvMUtxZ2dWTnowcEM1MDBXdlNY?=
 =?utf-8?B?b1FINmVNVXNubklSQ1dKajFCMjY4bHFBeENWQ2pjRDVkY2RWRU45MlhzQkVR?=
 =?utf-8?B?NUtFeXRYZWdWemNJTUx6VmxndWlaYk1tTkJzZUdSeCtxWHkrZzBRZWttRTA4?=
 =?utf-8?B?SGZiVWJTWmljcEYxbm1oRzJHODFEZXY5UGQ3UGQzbGhrNzRYcHdZUWdaU3Fr?=
 =?utf-8?B?Yys4TWhLVzdWWXc0MmFocHFDQ1ZyVStLNXZpQ0IwMWw0QlYvbjc5Vi9OMFdq?=
 =?utf-8?B?TDZMN0VDUkNXSjBjeXVjbVh5aTR1cVNXNkh6SE4vcG10UFJaMXdCNDVyTksx?=
 =?utf-8?B?Y1hQMTBveUlLT3dRWmF3YnNiUmhaRXVkcUp2ZC9vckMvZGZXcWsvVFBVN0N5?=
 =?utf-8?B?S095REJKMDkwL3k0YjNCQkRoUG1DaTUzbFVuVnVhVE92QjErWi9tQTB5dmJS?=
 =?utf-8?B?NDd0MzdCWGQ5ZVV1d0Y3aUFQeC9LQmJqbStPZFdHREJnVm1VdWdkSmNiOHVN?=
 =?utf-8?B?SzhNWi95OWpLNEVLelVOelZYYXRZN0hiSFA1eTBrOUtLa3c4K3lPbVVxSzdR?=
 =?utf-8?B?WFNsMlZ5SzFXN25YSWZFaTRwT2pod2VtRElWekMyc2VjMHBCc3kwUlpxeHcy?=
 =?utf-8?B?M2RsM3czN3RjanY5dDVZTCtFbHVlVVRpTDZ4SEFld0UvWFlxbE9nMnVKbjVW?=
 =?utf-8?B?aVJRVEluaGNjMXU0bGNsQVhtSkZvVWg1L1VTcEs0WWRzbjVrM2l4YjdZVlF2?=
 =?utf-8?B?WGlYSlZsNnpzM2RxWWxFMTAwRnlNcVUzMHFTVFRTRjI3ZUVyM0xWTjhEMTVE?=
 =?utf-8?B?MllUbWhsYk9STW1LY3NPeGF6eTFoK1pjdnNGTCt3UVMrLzZEZ3dBYWRXV3c3?=
 =?utf-8?B?aEMxRzlaaE1aTlFDQlovZlBvempsRmFVQ3l4dmNhdk83a3FCV3N6VUdMaGw4?=
 =?utf-8?B?b3dQaFY4Vjc0ZFN0WXNoQ3QyNjVZdmtldzVKTzVRODdDTGxXNDQ2T21vSEla?=
 =?utf-8?B?ZTV3SkdQbHlaL01ZK1dibm5CeXV3TzFmaHdaSTZ5NG9rT0RySVpwOTBEREdJ?=
 =?utf-8?B?T3hXRU9GLzgyRUpmN3I3NFFNR05IZGIyR1B3TGRNbUlKYmlmalBvcnZqRGE3?=
 =?utf-8?B?dXUyV01lOTE1NGdmRk9iT2U1cSs5cmRQaGo5ejk4eEFCRzk4SkN4Z2ZBVFJo?=
 =?utf-8?B?M2lkT0tqNGV5NUpQV3ZYVkRzUExIcThBSEFVSkRlaTd2OHMwMnVyTGJkS2xT?=
 =?utf-8?Q?iYLCnIJCuQHa9ks+qbTW+L4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZGRQZ0dxY1MycHpXN2dGNzdsU0VYeTMrbjdOUkgwdkpTRGJEeWdQZXZseVlk?=
 =?utf-8?B?SC9zOXVqUUJLQWIzVksveW1XMnBjRFoyZ1FnMDArZ2x1TlBqRldEeGNodjda?=
 =?utf-8?B?Y0I4ZFJFRDR5ZFpRUnhkUHdLWUFxSWdxTnMvcDBWMTVnSlUzV3JKMkpUeUVj?=
 =?utf-8?B?alBRVkhqdm54eFFTQTBDTkdZT2VoaTZRVm10THlTVEZwZFQvTU1MYjIva0VK?=
 =?utf-8?B?Rmg1dVlPZGxUTFZIWk9jcit6V3FCYXU5WWdYODNScjc3SU96b0k5bXBxTUdV?=
 =?utf-8?B?eTZKT3lhOXZXUXh0SnlidjRkTkNraDZVNDNNbEVVdlpHckxJRUtJYkp5dm1G?=
 =?utf-8?B?TzRzYktuZzZlcHJqS2VXMjNJU1BYbnI0dGFRU05FUmMySWlmTGg4YnNlSXFn?=
 =?utf-8?B?cFU1blNwYXVKN2NSTUVOT0lIdmhnTXd5c1VDRDZJUHdsd1JRMkJYZ1V0RGtF?=
 =?utf-8?B?cUxHTjdDVUZpb1N3dDFUb0ZXTmk5TG1HRzgwam85ckV4OGtXVyt5QkVaL3J5?=
 =?utf-8?B?R2IzbFdDb09GNWZWdS85ZlNrNDFod3pJUWpLNi85dk12b1JZTnk2Rm1BeDgz?=
 =?utf-8?B?R0RhcXlXdFUxZUxrNzRLUVI1NG5rRG95c0ZUZXJ5akk0NVdmRzg3NXVIRmhi?=
 =?utf-8?B?cm1rNzFvYzVaL0ZFVjJNUS9BVGlpNmJYNERXN3Z4d3FrVUJ0TkdqRFhVVzJT?=
 =?utf-8?B?TzBKQytCL2d2dHU4VjJLQXp2ckYwdW43cHN1V3Q0VVVIV0ZyTm0rOXpTL1Jy?=
 =?utf-8?B?TXVubk93VktIYk5qMlpjQ2hyZENxU0lVdUFWdzNBeExlYnFJWktuT0ErRVRy?=
 =?utf-8?B?eWdyanZ3aHZBVHhuUjlNL01HSGY1YzZuWTFSYWZZUTk3YlVCYVV6elFNWEpQ?=
 =?utf-8?B?NGIvVitHYjBpelRxWFB4Y3BUdjZEV3g1dUp5djl1SVh3UWNRekJjdGtCZzlW?=
 =?utf-8?B?L2tsd1VGVlQ3dEV4bGI3cWkzeDVEKzV6NE1YbWt4MHhVMGZib0lJZHU5NnhG?=
 =?utf-8?B?UEVVbnhqdEFycVBPckk2SndQL2Vnb3EyaFZsK095NFI0T05adTk4alZoT1dK?=
 =?utf-8?B?Zmo4eUNsVkcyQ1d4VWNRYXo0bnRPdUk1eVBBQWJYY3l3ZUdXYnRpV3FVQ20v?=
 =?utf-8?B?WUdCcDVvZGNseWZTQWVNRmR4QVZnODZyeXhJcjRlNWxpR3RaUFJSeU4yNVly?=
 =?utf-8?B?bEtUVDUxczFiVHZoOWlCV3V1d3o2T1VGbjA5TFh3ZC9NOEJHSUxMVHdOUXFp?=
 =?utf-8?B?NWZhaDN6MGRRaldKMzFXYTBxS1lMS1BDVGF3R0h2UHdHanVkMUxVTkJsdHBX?=
 =?utf-8?B?MjhyUGhNQnh2SzNZZkJRWnQ3bkk5aS85ZE9LNklaSnlDNHlGOWRrR3RUV1Fa?=
 =?utf-8?B?ZExaY3lXbXB5eWZwdzREeUNSdTV1YUVpVUMyMWkzbkZ3RnhkbkZpNU8xSFBq?=
 =?utf-8?B?TEhueGMxbm5CMlFJRzdXK3Q2MjJiZUtqOTBMdEszSWlrWFY5TlkwNkF3Wnhl?=
 =?utf-8?B?QnRrWHkyYnJTTTdWT1FJUEZjKzJlRnNmZWdoNjRLN2FtRUZONXFNUmYvTFBo?=
 =?utf-8?B?RTlELzMyVCthSWdaUWhLdkNFc2l2V2dKK2hpUG83djg1bDVtYzBGTUdHSndJ?=
 =?utf-8?B?ZHBSME83V3RPZ3FWdm1vb3VZTWxjeElYU3J1YmduYy9DaGVNVVIvZVhEREcy?=
 =?utf-8?B?NFBMUDlUVnczN0RnV2ZaVGFUcnFNVDZNS0pXZ1k3MDFaK09PcnBjRThLWGJx?=
 =?utf-8?B?SVZsY2lsU3B1Q1FneUNlUklJWnkwdHpQUHo0QWoyeXVjclU1em42anZmRU84?=
 =?utf-8?B?S0pvTVZEOWx6aE1RSGFEUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29cffd04-6627-4f24-5672-08db0ba405f8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:18:50.8572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a++gMSnlxElw1/2qZwBA5X60uqDWmSn2RQ3+luEEtkIJJMxlnMVlwhrSrPPgJZr/RoOW9j/G5EP+7ZygHOIvFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6083
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=983
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-ORIG-GUID: MZd5OmdPAGvsyIup3ERzD9R-Ow0Yg5Lk
X-Proofpoint-GUID: MZd5OmdPAGvsyIup3ERzD9R-Ow0Yg5Lk
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

Backport BuildID fixes.

I've build tested this on {x86_64, arm64, riscv, powerpc, s390, sh}.

  # view Build ID
  $ readelf -n vmlinux | grep "Build ID"

Changes for v2:
- rebase 5/5 c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT") from upstream

Previous threads:
[1] https://lore.kernel.org/all/cover.1674851705.git.tom.saeger@oracle.com/
[2] https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
[3] https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/

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
base-commit: 85d7786c66b69d3f07cc149ac2f78d8f330c7c11
change-id: 20230210-tsaeger-upstream-linux-stable-5-15-f7bf45952c23

Best regards,
-- 
Tom Saeger <tom.saeger@oracle.com>

