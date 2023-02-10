Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0456928E3
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 22:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjBJVBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 16:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbjBJVBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 16:01:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B36918B26;
        Fri, 10 Feb 2023 13:01:23 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwepV007741;
        Fri, 10 Feb 2023 20:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=PYDN8SoG5y7Xsuz/xXeD50LzGPZBWZEQK/CZBZ7kdWo=;
 b=SLmgHs+MjQxxeFhjNbImFvK1oazMRZifRdXVUNqvd3KVuiUnjQny3PU4JvIECQ1WwRO1
 GVVkwkTKXiiTwkksq5DmYEG3IbSvOB5UbW0LgjVmLLqLS1Ps/6zqBBAOW+zweNWTwv0f
 zyiKxaepoXR70Jurlr9Wpife2fI8rT44PG6arKuX6YwjTgL4MHPeAbEJBzlxK2GAr0Oc
 1ocIyap0+zYiTDwS/zBs40QiLxk1HJsvcixIqMxg3nOauTh9R8ZG8vMxJ/EF9uapWsDb
 PUEOhDgJ+BT9nfbdUPK/JQkXciQ/I8hEFNNMvwk9PW5OuLfK8MHLvMVbA546dVgoZ+zZ FA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdx4q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJKduP025749;
        Fri, 10 Feb 2023 20:20:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdthtg6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGqvfYxDSpjIqn5jKmggxqNgupRzJ3WjL0BqvIX9lHihXraMT0hz8I11r92WTqiZOXPbs3XPgH7m1OdRv9ZHPqr1kzV83kYLu73pooTtT+hs3IrjeZOLciuzILyQJibucETMMdoFIbO0oantcI9MbeiVEaBMUDv5br4Kq5LQOi7mDo0Q8uV5cany91sBeQ7Eb6Z4MxAF1Ilh8bim8qHFHcv20/mnfMfLP5uxQyo1M40Z6VL3JMd3PqrpdmJyjEoN/jivOx/4UxObWV9KrWV5gsVHnZDcsbzi67szxLNrt2idxOkMFIadoypCHsGlm3ZyzyMS86SqwXxYZVS/NtwKiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYDN8SoG5y7Xsuz/xXeD50LzGPZBWZEQK/CZBZ7kdWo=;
 b=QMIMH3fT9AQ1Bt4CmFA+cjrkArcfS1XnxF2A3vDkBo2VukHRJDvq2lDfJFju6k4foX+0yfwrMPllwM9qE6dfls5lDH4AX/aRtkN/jt7nDa+xmSGaYiZe6D58cdXHaJXwUX8/T0v/K+1FxdGAaCE6qjW+8Y3zkVeCjycbYfolhDoguK+uyYPrmei7KYO9U39pxT9z1YDHxpnoOD22qH47H8K9F5387Cbru9GPAbjLVUPmqqC1Xx2VmvVVgiknPElPe3HXHoIZJfl9emazGY55qauIEcT5gmiYRg7iMfbP6CTYy4GfTXFleRqD68GZeJVkPK0RD/oheoYda6thrfRtyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYDN8SoG5y7Xsuz/xXeD50LzGPZBWZEQK/CZBZ7kdWo=;
 b=IsPDzBy9p95Ypk3RVzyPAD24NBBx71iuM6L2MO1Gm21GO8NsrlZxEafqdtnUH9SCkhWko5g9/qMaMimqX0zuhvz62sHh/eng1ODfamBfKKyHO2Dn0TWnKTVIcRtvSWBwA3oeqiQjqFXYwj56s7HMe0P8CnR4nvHDSN1JjHMSdEI=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB5567.namprd10.prod.outlook.com (2603:10b6:a03:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:20:56 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:20:56 +0000
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
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 5.4 v2 6/6] sh: define RUNTIME_DISCARD_EXIT
Date:   Fri, 10 Feb 2023 13:20:27 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-6-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::6) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: 25add614-f2d1-4afc-fa36-08db0ba450bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHvzdR0/H/bKojGJcg75eFcAC8gX8Glhp5pbdOMtLSyQ9jiSaP1/2uG24poQZ3Wd+N6tp9msZic/Rz7G2mZaSK8GadfRJlqv8CbdKPBqPfKTxOBpENPXqFrHKc0HuQofjVWIEgw/fzmPOsRHmd/jeMBff2tBgc+VjgsLgcm70LRFo1cP3jF56E6Ls27GPS8uSs0W79ZKzDWpkZ0yurKxDGVQQTcSvBzQ9MmqZCqZiRAOcm+034OZUrgneeTQcXvL7H14aueuzUF+wairjyydPm9Ka+rmZvyTm3RmtlvMTtsltlDvZPq2u9V/pcXtn7HqqlgBuZ1v/M0si1YE2JXWDviaClh09yBywGe9O10zmSH/MtJ703UrBnziwVHf1Fe2te6nXRqWdqxGiLHZAcoOAwmLUv9/sb1UG8S22osdwuT+sY/DqTQNit6tQNiQxArSV4kloxF1Z5fr011uSPHOijAuEW3AOkCO7xpDH0IdvxfEaXLSvRJhac8MCzoGRjUSwJWhF3vOiKH6h7IffxbQqSzwFsex1s7CxewbkCUdSSkl7AAyL/qV3v/YqU4AoDPeK4/L4It66a8AMtIPEEcwf9uRrxrQi03R/j48i6CihzsRXZBKF8W/F4gVDYZWDuz2xdgsGLKwBVweRFxQL9p112v4VzoD+FWCdEJg1VcxGSpmesCORhLQiwzN/9V9pbteBPh9+UCH90l0ypwRKWXB9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199018)(86362001)(36756003)(38100700002)(6666004)(41300700001)(66946007)(8676002)(6916009)(66556008)(66476007)(6506007)(4326008)(478600001)(54906003)(6486002)(316002)(966005)(66899018)(2616005)(2906002)(6512007)(186003)(7416002)(8936002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFF6UXBtMm5UdWZrdVp2TVdCc2VJMXZOd01aZnVnSDZtZ0FmUHY5My9RZ2Ez?=
 =?utf-8?B?Uk1teFVhSHc2ZmVUQXNydXpxcTN4MCtTbTlpNE96SldRdXNDdGxvOWdxZFR1?=
 =?utf-8?B?WlN2UmJYdGF6N0hkMFdFdWdrZlVIeGdPSTNqWkZLY0NXZ3Vtc3JqSk5ITW9t?=
 =?utf-8?B?WFd6V1pGalZxWVhIcmdmSUYxZVRLNk5pazNVQXBlTUNNS1JyWXYzRzd0SG9x?=
 =?utf-8?B?MHhhZjdnbFNKR0krUmlOVkpYRkdrWFBkTlpMdVR2RDVUclFzanN1bHdLMkZ6?=
 =?utf-8?B?QUtsaDNkQitPeFFCcDlOYXJvK21pam5IOFkzOUgrTUtIcWVxNjdqMDZ4aEpK?=
 =?utf-8?B?dU02Q2lpU2FTV2J2emxPQmJrTVZucDhrMmFpekhzS2FaR0g3dWd6U3RTOHBu?=
 =?utf-8?B?N2Jac2dZWjY5SDlvWlJtS3JOUDJMU1EzVGo1S2dGS2ZvQkREVTlxRDlUbCs2?=
 =?utf-8?B?U2QrVVk1aEhPbERwc1VIUURYUkVNVEYwcCtEN2l4QnNEN3NkNFZmakY4OFFt?=
 =?utf-8?B?UGdhWTk2TVIyVnI1NFd5NUVBQWdVd1ZrbDNuNlhWaXNLZVBoMTNjTHhJM01j?=
 =?utf-8?B?Y2JJWnRyRlREaVRBSzRSKzZVMTFoWTN3dy8rWW0zQlFvcjc2eXA5VFR3ZkJW?=
 =?utf-8?B?NjBvWlVibU0xcStXN2VHOFd5S29tRHM1c3ZOWEl1a1JtK0s5aXdTSDZBajRT?=
 =?utf-8?B?Mm9iSXlabHVzTlVxWG9SV3ZQT3lnTGNnMXZiMVB1d0p3L2dKYWpxUUFNVWM1?=
 =?utf-8?B?a0p2MWlXT1ZWRktpa2V2M0Y4MGNrcHg1bWFZNmV4WTVLWmNWRmhnRUhENUpV?=
 =?utf-8?B?WkExYVp6RTdPUUk0N1Z4RVI2Y1ZrNForaS85TFR0ZUllZFdQTHBvWnBBKzEz?=
 =?utf-8?B?Vlo4NlFrampXUis5Q29Hc2NLZkJlOXNqR1RQcjh0MVFRb0JNN1NoaTNhZCt2?=
 =?utf-8?B?dzBYdnN0UEVOMGxpQ01iTW56czhWWFd2RlFoVEpUVUJ4WCtqRVJlK1NPN1k3?=
 =?utf-8?B?WlkwRnlkMklFbU5iNUtGWWdkd0Fvak15MW50UUIrNDVrbUtLeVB1UUdwNkxr?=
 =?utf-8?B?U3FObjVUZzgzNXdMN2QwYjIrMlFlZG1qTzN5eFZDa2F4bXJzV1pxQ0loOWZN?=
 =?utf-8?B?cnZCWm5BNFFQUEs2SkFtcWFaV1hxVkdKeDcrdzFER1hyTkpITk4zYkJ3dlBp?=
 =?utf-8?B?eVEwVlVVNEZSUDl4T3NlbHBnWVE1Tys5M211cEFEbjdubW9Hdy8rSWpCSjNw?=
 =?utf-8?B?Ky8rQVErcThISzhrN1F3R0JudEhtRnd5elBld0dtNXY5ZUg5Q1Bmc0p6SEZq?=
 =?utf-8?B?a3dYa3hiUjJvRk95eHROVW5oZ3RLVXRMNzMvV21MNTBTVyt0ZUhzRFF2NU9B?=
 =?utf-8?B?bWJzRENKSkF0TEZlSmFXRHNURzBaaFM5c0x5b3E3MGU2MHlVMWhsbWxHU3c4?=
 =?utf-8?B?bzNnd1JGNjRsQjg1WWhmNjRiSVBzVkNyQTdoZ0lYc1FqMnpQekErSzZ1ZHJ6?=
 =?utf-8?B?UktFQVBiOElqcWROUjZKZmxkcDc2aXpkdk5zL2pmYXJKc0ZENHpVZVZXYWkz?=
 =?utf-8?B?MklFa0NCZHJLOUl3dmp1cXg1NzZ3bkoybTRaSDd0WnRMU1dmcUdXR1loWWJM?=
 =?utf-8?B?UktBNEZzTUt6TkljMUZsYWhKSHUrK0s2S2V0bUc2VVNZTU5Xc2F6d0U1VnN4?=
 =?utf-8?B?SHhnMTl3L1hyRldHU3d2NG5adnpNazcvY1FRUVJvZnFaY3BFMUhFanM5NDdP?=
 =?utf-8?B?MjBCV3FqM3RGMFBMaWh3aGxqNWhBTnN2Q1ovbTk3TEI0Smh4NGZ6OVA0ZTYw?=
 =?utf-8?B?RmsySUJwc1JMS0VYMzVCdGR3QzkwQ1ZlS0lIbEdqWFlkOVVsbFlWajgxeFdp?=
 =?utf-8?B?U3krQUlud1lVZzM0dmpCQVEvUG5RTUtyZHhvSmJBUitCZFVvUVNsbTE5Sno0?=
 =?utf-8?B?REtiUkxVMm1qdjdYODNQQUpWdzE2TERYd3FCY0VLYWtYNGNzK3M5cTYxdnh0?=
 =?utf-8?B?V1RDTmRTaXpES2FmL0tWNHdoallkb2FLNWpOdCtoYXlWRXMxOEg2M2Uzekxa?=
 =?utf-8?B?WlNRRGhURlhpTXZRci9WK0pUZG1LNVZKSUd0cjVzWG83SVJMb0hoamhQYlpU?=
 =?utf-8?B?VEMvKzdiWW8rODBZOUlRdlNwZS9rcWsydGVMb0w2b3NtcnFJWStyOGZKblVh?=
 =?utf-8?Q?cvAXSti22wzQggv2tFsnZas=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OGZKQUk2R0dKV0lkR2lsSEpVRUduTlB6bms1cVY5MnJnZ3ZySmpVb3dBU1h4?=
 =?utf-8?B?TFdtbC9hMGduQnBQU2tGMC80NW1CYVEwdFdST3JvVE1mWHFGSkF5TCt1eGEx?=
 =?utf-8?B?VkhNNTFXUEM4YW5xNHdtVGUzaGxZa0NnbFllV2tCdXBPOWl2NnBmd0xGTjFx?=
 =?utf-8?B?OWxkNFMxczJTYUpMNFZmUVN2WFp4NnFhM3BkTEdpQngwYjdqclRCNjREMVM3?=
 =?utf-8?B?QUNJaThOU0d3N2R4UFZja0d5YXBlUzBHVUZvbEFidnN3bVU1blp3T3ZyNzRX?=
 =?utf-8?B?bElmY1g0UHB1UmVyaUpyNGZsR2plYWxHWjV1dGNsQWVuSmkrNW5pYnV5eUg0?=
 =?utf-8?B?N21KbVFIRFYvcTF4V2h6ckQ2cGF5ZnEvVWh3NzNySjFic2F5Z3drRjhoeUJM?=
 =?utf-8?B?Qi94eFNRekx3bHQyMG5FYzltVHlNeGNqbm1wVFVyRGpXOWM3c2tnUC9pSFAy?=
 =?utf-8?B?cnJGY3BjSnhUL0RUYVpKeWJnR0g1dGpnQXUySWk4eENLZjF2ZzRRNUtFQmlN?=
 =?utf-8?B?aW5YRTBkVXlnSEh6Wm9vRkx5d2lkc3YySjlDMU5YVXF5MlpFWE1hbGo1MFBY?=
 =?utf-8?B?aDk1dzVaLzFzVU9DSW5RZURLNW9TOFJBdGtaT0M1Z2xudUV0dURZZjB2VWtE?=
 =?utf-8?B?ZlZNaUpNOEkvRXlybjlqSS9vYm5jVW1KNkdIMFdYSFh3VUluK1hmcEhSSFRm?=
 =?utf-8?B?aEJUUzF5SHBtSDdacTVHUVE4aGM1VFk3cHNpV3ZIVWpqbC9SWFdzOXU5L0Y4?=
 =?utf-8?B?cVZWNmpubmduTHhmdXQ0Mk93K2RVTTJsNWtkdWVMb1JrVU44SDhRa3JmeE8v?=
 =?utf-8?B?NHZCRjk1N1AyTmF4ODZROEtQSndjaW1iQ01hcEdDYUpObEFRcWpDNzV5NWk3?=
 =?utf-8?B?WmgrcjBOcHZkK2R1SVRvdlBlSkZRZkRDYTg0M2RqQ2lhSTRlNE1CcHdVTGNN?=
 =?utf-8?B?c1VydjJrSHJnTTI3ZWlXNm5mckJkbzNJOHpkck1JNFlLK2k5ZHplZXNnN21v?=
 =?utf-8?B?RGhabE1ROHAwdWlDS2FQRXYwcWh6dXpjajZLdlRCbWppL2tEQTRSSVhpTTcw?=
 =?utf-8?B?UzY1dlFJejBBekJURFZmL3RkMjRMeHg4SmVqbFloVSs3dWpacGtER0ZicTF3?=
 =?utf-8?B?ZEI5czlWRDFQbnVocXVuYVg3OVpXN21uTmp5aklrVlhwUWZ6dVFXM2hSZGZu?=
 =?utf-8?B?RjRHN0gxbUtJeTFCWGMxMGkwUTFmTjFEa3FlRjRIRk1BdVN3UTBuYU44Ynpa?=
 =?utf-8?B?YjgxQ0wwbFp0TXVNQkdYRzZrN3EzU1RyN0pWMm15d3ZmdWRsZXY1RW9oUkdY?=
 =?utf-8?B?OHhVcUFLS3JjbUt3ZDBXend0RUZ5dkRjcHNVME1yV2JEQklISisydFQ5U2dY?=
 =?utf-8?B?NGwxMEJOTXpGUEFGVllNYkZPZ21EZGJJa29nYkUyMjBKb0ZpazIrK3BBeGpR?=
 =?utf-8?B?Y0pVNTRtM2FVT0wxUnY2TWE3cXFmWjVkWTc4REF1b1hyV1M3TUVxOVlkTVJa?=
 =?utf-8?B?bG9lcHNwekVzZGFUT012eVA0S0UyMnY4WVcvS2dxZ3EyL0tiMW5MMFRBY3E4?=
 =?utf-8?B?Zzg1anBBS0RZcnBEOWRGL0M3Z3h5VGlGTHBFVU9yWHlDQ0RBeEJIV254RFV5?=
 =?utf-8?B?ckxGSzVWRW1YR1dkdjh1ZU9OdTFXVkhkbERrSUJlSTRsbHpJUkc4VlVkN2ZR?=
 =?utf-8?Q?2uBE/RrJ00nSaqOkckGn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25add614-f2d1-4afc-fa36-08db0ba450bf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:20:56.2857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMfq7I8N7SitNfGEvFRf0NsD/iMe7mV62UMgPSv8hMZpuKSYRkWcm2IMOYH5lzFN9L/ld+Ky1DyAtV2bsL/7zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-ORIG-GUID: cfemz4eN_O_5kqvim0wAkUmoFuQQLVEd
X-Proofpoint-GUID: cfemz4eN_O_5kqvim0wAkUmoFuQQLVEd
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
index 77a59d8c6b4d..ec3bae172b20 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -10,6 +10,7 @@ OUTPUT_ARCH(sh:sh5)
 #define LOAD_OFFSET	0
 OUTPUT_ARCH(sh)
 #endif
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/thread_info.h>
 #include <asm/cache.h>

-- 
2.39.1

