Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D7D6C1E63
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjCTRox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCTRob (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:44:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C254F49D9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:40:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KHEP8F017816;
        Mon, 20 Mar 2023 17:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=LSsMlRnu2P27FBGlfb0RNUZx5KbrzPnKrPpCHwFsHpg=;
 b=JNGoAGWquPmBb995IRh3It2WzCLxwj/spqOXwU5qMSDQiDaM+BVhTtdSiOV0AInpG4Gx
 I3cLrMQovV4Ce5SDD5MzS+zqwYAnVmO3D1DH7HaN3nyv7zX+NA4Y6V5ivW45n73XtBrP
 jSN11dOaupR4ccCd54sqhK2zPAjzT3/J4TQQEyTMX3BDFyf8oGisJaoDZfPo4JfwyfLX
 Qe/KOwlbHt+o1QlpJUpArb9T2Kc/Sa72QqY4qyjgoUV+8IDL3+ujWn01nfrcvOx58o8u
 LAgeO+n0VPXMEPKL9uTtlayUmUGizF4Y//W3ReSqEvd1XmGlF1vOympbjRXl0B7OKGhc Hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3wgc5u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 17:40:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KGnY01026619;
        Mon, 20 Mar 2023 17:40:18 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3r4m4y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 17:40:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcvIX+kuIs+FUZXL7x+mzBJ9+wZqJl2jDr9+DG8TGs+j3GYcwL0Pg8zUk83+FhqTYjGCYeecvlvBe2BaqYfFEjRuD1cWPvUXL3jdrQDrzVnFqmfo+fKqMzQxOmff5jeT/wiaTAXkoN4LR/44kaSg+rEQQLxJT6+m43ytaSNj4JEFsuPn1eIcOiYsow1Xtn8L7sJoHr2EKA8q26gDpKSz7YXInxPI6Q1bvmaG7EQAic+TjrjGZq86OVOVM2JzY6MPM81ZDYf807gmspGrXu9XcYOrMxASsv3iHcuIiiFoIwfi1xfK7k0R7qUx0AVizPSpCkHWgPcm6lXfrSttEFimcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSsMlRnu2P27FBGlfb0RNUZx5KbrzPnKrPpCHwFsHpg=;
 b=Dw/au08YlGwloX4Tt90P5eYPKn6NP+f9siaG1aMhmJe/cfGsyBH5bTVKZwHK6oNjtdr3AL59pLZWPcLjp/V1ogQzrC8AKlHTrwnLM9W4lzIgWl8cRUmm9swfOjyfYLedB2aGX3CBd1KqmLyTUU9jHWTAdbwU0nxjlEoMHKTAcPQaGayZllWYkJoOETMk5+Jh7qY1eMgn6pmC2nGqe46QU8+1lLJk4YfygDhtgeiIeYI6S4JyLpLatCjFqJQhrZoRt2nVptkVv7r3IkLJ5udJgnJYPzn6kcgknbdx7bh3nQWBABQTaA0RTnHW6qH96sFmCcUA9sP92wZSmF1c0aRP0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSsMlRnu2P27FBGlfb0RNUZx5KbrzPnKrPpCHwFsHpg=;
 b=RBJyr1BArgPkSSbHAugkZAAbX9QJBehaxDv5DQcSXcmd02/ZQ9a+zqMDdStoqyPkpjCy4JkCOlxUTbCYK4jTQwWJjAHT42I/x1dGL+3F4srP5oO/6+ZzexF17R+aGtIWgipCOjdtsqh8o2IfQbujj9CKjKYCXi5r4TrjbUHrm1c=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS7PR10MB4925.namprd10.prod.outlook.com (2603:10b6:5:297::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:40:15 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:40:15 +0000
Date:   Mon, 20 Mar 2023 11:40:12 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        "kernelci.org bot" <bot@kernelci.org>
Subject: Re: [PATCH 5.4 54/60] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Message-ID: <20230320174012.mrp4epdwadltdplb@oracle.com>
References: <20230320145430.861072439@linuxfoundation.org>
 <20230320145433.168808844@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230320145433.168808844@linuxfoundation.org>
X-ClientProxiedBy: SJ0PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::19) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS7PR10MB4925:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b9640c5-ebd2-4618-b806-08db296a2a08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFWyLW9G2GWSblWKvcIeQuYPFBQLo3ehUIOKs1v0X6rGYB+OG3Va0H9JogwjtYoWCS44290tSrWY927WZdhQwoyZnfvjh1SvfLvSEh4UceLHAY55+uemRkgPjXY1aQMZQVH+kVKuTM1kVmDICi8ZvUvuQIKIk1RSrVey8AKuZFH/5LaSuhPZNpweCyT8kKsjyPeFp56k3CnXCWuoY48CpLtvY2bxkntS0V3OsbjY5nOJDjUFFHiNnf30cbneuj0WJPDAgyXJgff+8Jbww5YHpwEPvBFYse6htBxkk50zokr8fCSOEGkMYfKjeIWh/OUaanxxUXuknr47/1Y7vOya1m8oL6a5dyhQViY5EBM0RegqO+xS7Uc4/wLB1gaXEO8Lr1sbizkn887q2/BEn0CzsVwKtWCAi1MlImRj3QjhD+sYXMRAgH+y5M7YZS9iAa6UyAV+hMe92kxrPpgHetwVvDbX3m472WLwAqEac0VWKBT8M2xHdjYV5PDYtn8AL2QQgtHom5FSHy/NnhawW00A6oLNWvO4PBnLiRIFO0gsTxqsnOkBxOcEILZumAWuL9F5icAIWLslAdN22ejAEXyFCx0cZPEEs7mGKDNw4IvJcOjs2aurzCg5QeB2gyQ09u/BPeZrtk56v6JB9wyHqhv3aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199018)(2616005)(41300700001)(186003)(6486002)(4326008)(6666004)(83380400001)(478600001)(316002)(8676002)(66476007)(66556008)(6916009)(66946007)(6506007)(1076003)(6512007)(26005)(54906003)(44832011)(8936002)(5660300002)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWhET2NZSVREU1JEUWpwVFN0UmRuYmZBajVsR0RjWWhFY0lPOEg2RGVWUkFC?=
 =?utf-8?B?NlowSTRSVWxpdnF3YVJRQUdvaGJqY0d2VGlvS1lyMGRWQ2RCQ2p4MlVXbFBQ?=
 =?utf-8?B?N0pOTjdvckhhb2R3WENIV2R3QlVXQng5WWRIa0JVK2l1RVBFdmF3LzdnQllC?=
 =?utf-8?B?c3gxWjAwWkhDams4RktBaUxpTmZUdkV5Z3pUV0RDdDJaMWdLMDh6WEt2azBE?=
 =?utf-8?B?Y3BHMS9SZ2h3MzBuYWZsVVdQa2dOQ25XM2lrWmR0TkVqYXZydmJRaHF4Y3R6?=
 =?utf-8?B?Uzl5TkdrWUZNVk5lN1kzOEZHYlM3Zi9TYXlEYXFUdjdFUjlmQlc3UTBHcEps?=
 =?utf-8?B?RTZ4azlZNENOQzJ4elBXVFAwWWRreVprU2YwbW05UkV6MUc4cUtITXAxb3Ra?=
 =?utf-8?B?d2MzNE9Oc0VDVmRNV3V5RnlMd0hSeDE5bzBRQmpMZkV0VDdiVXJoY2NpZ2Rq?=
 =?utf-8?B?U2tLd1p2cytOUUpOT3JNeFRpMTBNUkk0QWNYTzN0S3ZnWFNhM1VhT2NNTjF4?=
 =?utf-8?B?dVBlbHA2YjQwa0U1VUJESjZmWWY2amYyTmJSMmYvTGk2VzBNU0tUTnYvNWhD?=
 =?utf-8?B?WDExeitmczVpRGNRUW43VjdEek9FQkZiTlpGcCtCT1dacDhUd3FQOEwvZjlL?=
 =?utf-8?B?MlpucEFJZHpxd1k4UExpNnFBdTF2M2VVV2ZzZ09KK2JrS1NINE1QY1doUEJ5?=
 =?utf-8?B?S2FRZ21JZkdWQXVLdzZEOTZTL1NmUkM5L1NDNnhVTm9kL0FIVjJRV0pZWWJC?=
 =?utf-8?B?NEt5ekFyT05aSGF0a0hyaG8yQ0dkSHcvWC9zUkVtOHZOcDBUSlRtSFZEREpN?=
 =?utf-8?B?V2haYnpwMGJDQ3BPSUMxUVpZa2oyeHFHZFFtMVMxdHg4Y3hmb09Pem5XemND?=
 =?utf-8?B?UXB1OVh6Z285M3V5MXJuVllmeUQ2R3RxQ2h1ejNsR3lmbTNzS2FYT2x3OThv?=
 =?utf-8?B?SE1nNXNhalN1ZlhQT0lVYXVWdWZyTTR5VjhHMC9xbkx2T29LU3MzNENyT1l2?=
 =?utf-8?B?YS9qdG9xY29VcjhwRnBQYjlhQVNGMmdsK1k2MTJtaXh2WlozYWgrc1FKRkYx?=
 =?utf-8?B?U0RjVW05NHNEb05PRVpYZldTUC9YOFExK29BK3p6cU1JOTVEMlBHdTlyUWNt?=
 =?utf-8?B?L015SXBlV3d6cEhlOWh3SDVla2Y1dUpSVmY1ZWp0T3FNaGpxdWpKMlNTcTd0?=
 =?utf-8?B?YWRCeEF4SW8vK1RoWG9Gc1FwZjNYT0MyTzQxU3R3eGVRYkE2Y0tsYVJPc1k0?=
 =?utf-8?B?Z0VnQ0hOalM0MG01c3p1V0l4eGp0K3BtSkw4MUdCZXduVUJETWlnRTlGU1hF?=
 =?utf-8?B?UW9Mc1lVUW1lc2djNHNnOUNVNEtzaDNGK1JFKzBZVnJ2c0hnZ0lRSkdXWHhn?=
 =?utf-8?B?MTNoUW9tS0xkZ2w3cWNiMVZHN3FCNVNUOFRsVFJYM2s5Q1NBblZjWXdzTnBS?=
 =?utf-8?B?cFFzbTdLQlZSdmhmRkNJbWZqSnFqdkgzWkdsanVvNHA4ZStUbzJIMDE0Y2g2?=
 =?utf-8?B?RFl2cll2VHVyRnc1Z0xaMVdiQ0V6cDJxQnlVV2dCbTFkVUdFTTk5anpxeDIy?=
 =?utf-8?B?VUxxVnhObk1JYW5VK2tvQm1IQ1F2Vm42aFFDaWNwM29DNVFNUkVjNkNKM09r?=
 =?utf-8?B?QThQa1B2ZU11bE5JbitiY0VYVENLSmdCNXN0UitrMGt1ejltbXd4bHpuV3A1?=
 =?utf-8?B?WXdTKzFlYytGR0IydUhDcGpUdmMwNmQ0a2FqMDl5d0F4UUdadEUwRklacVpL?=
 =?utf-8?B?RThHWXRncW1JaWx2OFVENkJhWXQyTkprQng0SjlacE5uYmkwbS83ZEIyK1ls?=
 =?utf-8?B?a2ZaNzRXdzV3TjNYM01PQnFLQUZmSmduWGhKVGhPK2VFTDJtRnZpZlRobjly?=
 =?utf-8?B?QzJnTjM5VXlYOCtPOEwzWVhicDhoT09WS1pSN3F5aHVTTnBvaVRDRHNiSlZh?=
 =?utf-8?B?aUxvakJBOHN6MVNoRHRPZ21tYzJPeTlJaXBFV2ZWMUllWFlVTlpGcVRsL3ZJ?=
 =?utf-8?B?eldvNlBHQlFianFWTFFKY3RqSE5rZlNXOTU2VndLejVFSnM5NllSQ1o2bkxF?=
 =?utf-8?B?QW8vWXM1TlpQeGVPK3BnTE02ekg0cFVUbG15UXVUTXlYaC82WDZhbm15czBU?=
 =?utf-8?Q?cEsQMS8xQNX/Bs00lLeQEk+lm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K0pjZ0phS1FmYldIaWlCQVdKcnpGSW5ob3h0MXpWQnFUTnJtbkVTdis2OFdx?=
 =?utf-8?B?QXZjbG9QL1lMOHpzMEsxWlVoRVhqVjNzaVJYSjFwUzFnMVpiNC8rUTBhZkw2?=
 =?utf-8?B?dyt6bjN0WmdNVjBtdTJla0hRLzVRU1RiRy9zMlZWOHFRMkJPaEplMzFWVDNY?=
 =?utf-8?B?Mk8zbG1hRms0U0JHaktwMitFQVlUZmNmU25qRjJqOWNPeVc0Q2E0bXorUE5y?=
 =?utf-8?B?Ly9xN2J6bEI4Z05xZjU3M3orNkRPV1dXMnlZS21kQWVXSnpEbHFWTis5Rm94?=
 =?utf-8?B?OVd1ZW9mNHhjaW1rUE02UnBwbElRakpDTkwyQVRiRXBsc3BvcjdKalNON2Jz?=
 =?utf-8?B?NWxwTlV5VGRWWS9yWnJCVjJCOVlJNFVpdVNNNFNOMkxLb1ltd2ZSOEZwckRh?=
 =?utf-8?B?dWhOamFIMzhiaDUvTWtrak4zK005d0JXMEJ0VEsxR1JYMkg4SllpblZVUk5E?=
 =?utf-8?B?bE9hRzgyeGJ1QmtxOGEvV2hqcHh6TXl0TWdTYVVNMGFpQTZWY1dlUGdzMFRD?=
 =?utf-8?B?dVdFM1ZpVWtycGk5NysxclVpVi9odllXSkgxaU05RTkraU01RDVIUHJORzlD?=
 =?utf-8?B?ZVczT08xa1BNeXBKOC9ObllFL0g0S1R3OU9BNVBOd3UwN0JRNnJvQnNGYmg5?=
 =?utf-8?B?amVmMXJPS1BYY2xGc3JNaG44ZHlzSytlTkkxUnVvWFVML0ZpdjRSMHpmRnE3?=
 =?utf-8?B?dHVNN3IwTm1KdTY4eUVmK29pV0R5NGd1bTlsQWRQVjJjV0hCQ1E0dWFkelNi?=
 =?utf-8?B?T1dyYWpUZmc5cHB4Z0l0REZReVNNL21kWUVES0F2eVdrOE50N1hIQ3dqZlJU?=
 =?utf-8?B?VW5IS1B2MENPU010NjRMR2Q3S1FrUXhTYU5kYVkwRkg2R2pzRmNMbHQvT0t6?=
 =?utf-8?B?VDNYTkl2TDVBRGtaRG9XMEtyZ3VHM0RlMWt1NWZ2VFhmcEFtc1hKSzhQZjUx?=
 =?utf-8?B?dStOQmk4aVdoNGcxUXdUVDJuMk15cVdjZUUwcUtvSUpKcU1BZmFoeWlwU1cy?=
 =?utf-8?B?ZG1waThmV3duVUhRZDN6NXdydWR0RkxSUlZXdU96VGlTek1LelU1YzB0L1pn?=
 =?utf-8?B?Nmx6OEdGSG5Ma2tkQ29sLzZWM24wSjdwTnYrK0w4UWEvRDh4VDlMcTdURFRU?=
 =?utf-8?B?c0lXc0xRc1F5UEtYOVMraFhTWXNFcjR3T1RLRlhiSWl3QVgxNVQ1ZEpFVkdN?=
 =?utf-8?B?Uld5TTBRbTgxbkdLa3lhOHlXTnR5Y3FSYUU4LzlQcWptUEFZVlpGN2d1TkN5?=
 =?utf-8?B?ZzRmcVJCbm1RWGltN1ZicXNlVE9IaXFZUmFNaXJDRXdkNEF5SjN3bTJ3NFZv?=
 =?utf-8?Q?VPLt4AfXA5Nps=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9640c5-ebd2-4618-b806-08db296a2a08
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 17:40:15.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vto0kbI/roOwryvEfbBE/8LaeGhqCdePHn8eAy8VStNE82MxDkxOoD6sRk/dlQKBjGeIebM5COxZVMoUrVTqgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4925
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_15,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303200150
X-Proofpoint-ORIG-GUID: yEvGEiaGv3cFZ-2GFiEjyKK1ZzNlOo4V
X-Proofpoint-GUID: yEvGEiaGv3cFZ-2GFiEjyKK1ZzNlOo4V
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 03:55:03PM +0100, Greg Kroah-Hartman wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> [ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]
> 
> This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
> macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
> tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
> data argument, it has been removed here as well.
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_singlethread_workqueue")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> [Tom: fix backport to 5.4.y]
> 
> AUTOSEL backport to 5.4.y of:
> b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,
> except one, in arch/mips/lasat/pcivue_proc.c.
> 
> This is due to:
> 10760dde9be3 ("MIPS: Remove support for LASAT") preceeding
> b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> upstream and the former not being present in 5.4.y.
> 
> Fix this by changing DECLARE_TASKLET to DECLARE_TASKLET_OLD in
> arch/mips/lasat/pcivue_proc.c.
> 
> Fixes: 5de7a4254eb2 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/mips/lasat/picvue_proc.c          |    2 +-
>  drivers/input/keyboard/omap-keypad.c   |    2 +-
>  drivers/input/serio/hil_mlc.c          |    2 +-
>  drivers/net/wan/farsync.c              |    4 ++--
>  drivers/s390/crypto/ap_bus.c           |    2 +-
>  drivers/staging/most/dim2/dim2.c       |    2 +-
>  drivers/staging/octeon/ethernet-tx.c   |    2 +-
>  drivers/tty/vt/keyboard.c              |    2 +-
>  drivers/usb/gadget/udc/snps_udc_core.c |    2 +-
>  drivers/usb/host/fhci-sched.c          |    2 +-
>  include/linux/interrupt.h              |   15 ++++++++++-----
>  kernel/backtracetest.c                 |    2 +-
>  kernel/debug/debug_core.c              |    2 +-
>  kernel/irq/resend.c                    |    2 +-
>  net/atm/pppoatm.c                      |    2 +-
>  net/iucv/iucv.c                        |    2 +-
>  sound/drivers/pcsp/pcsp_lib.c          |    2 +-
>  17 files changed, 27 insertions(+), 22 deletions(-)
> 
> --- a/arch/mips/lasat/picvue_proc.c
> +++ b/arch/mips/lasat/picvue_proc.c
> @@ -39,7 +39,7 @@ static void pvc_display(unsigned long da
>  		pvc_write_string(pvc_lines[i], 0, i);
>  }
>  
> -static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
> +static DECLARE_TASKLET_OLD(pvc_display_tasklet, &pvc_display, 0);
+static DECLARE_TASKLET_OLD(pvc_display_tasklet, &pvc_display);

Mea culpa.  The above needs drop last parameter.
I confirmed this locally with a gcc-10 mips build of lasat_defconfig.

>  
>  static int pvc_line_proc_show(struct seq_file *m, void *v)
>  {


--Tom
