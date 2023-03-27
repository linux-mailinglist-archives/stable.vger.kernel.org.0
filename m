Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1056CAF1D
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjC0Ts2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjC0Ts1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 15:48:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFC22D55;
        Mon, 27 Mar 2023 12:48:26 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RJiqhV027327;
        Mon, 27 Mar 2023 19:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=fcAbSq7bGS8cdL4zozsAXYr/HE5wf3sDTXJj5rg1MzA=;
 b=1rXFOdSyMnP1moRi8PviiCz1xM0frHlJFxpWNEz6124dxYAHhodC4vY906+ZeHW20YBN
 gI9yL61+S4Z+5BEiRQq6M7knW7PL/psvryByWH70Utgfxo7vSj1LHJYkoHTuSw7Cyagc
 3o6ENb5YY4k7HvwzwAXfhiLaDiVDImcXQs5IIa8gSjZrPSRIYD45sKMXspNEN/h+OhUq
 9ynsXE1tvcI16fcXSei2iZZR672+ZlU8K1ZvMX/rIooOxmz4Cm2m89xyo0eLykBy/LRd
 hqlQfsdHFNTY5vwFmnf0A+YtXkJ3k7C8pUllR4JqOUelRM+rK9lofEO6p0JooInMHmcg rw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkhjm805h-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:48:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RJEdvs005503;
        Mon, 27 Mar 2023 19:44:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd5edwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:44:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LeCARka9wxYhbvog1DkXJ2dg9P/q03SjXkwN11cMxWw87wUtyJixFdhzMVesW1ULdnoya4Bn+4sP3REonlNcD1z7NjxyyACKZCKj/tMFx4S1opJKUPG6sJzEXCYKiUWQMdSyFsD4PWnsKU3s+TPlXyKBQkDzERIuC2MRgpcFrMhPZfZuFvYcDsxtojdlfsx6LDVoZHifB9+NVQ/dQr5zpJIqwKc4g+Svrq0ylZ7UdpqsT0Q/ixv6G9VgQSv0zb9e1muewcD3an1nD5JHZYjIW977jrQC7LURI/gucL/4aG+L09V+dsqVO0uHWKw7mH31dTs45VJ+AS6Tav6u2WwBSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcAbSq7bGS8cdL4zozsAXYr/HE5wf3sDTXJj5rg1MzA=;
 b=PEeys/Zo//ZIV+PeNQDpwS88fVfWWMIfkQxE+5XE/SYCPRpnZypwM4BmNLkirov7Obz+KuxkIog677fCP2RfhsZEMo3OGibmZpLS+WqPUF8GW2nu4XdgGqf2tJ6KicGnjajm5TcuZYJfL4fII+1R9hTziO6GqdNQRhzXkWTJhx0EP9HAwXeUuGDFlh6Ji3ZZnI6bK9IUzfP1rhd1q3INNbmPwTHBsVmUQ0Sa+6khu2tQQRbYcCXyMH9i17Aqqmq0oqEd1iH7QG51+d7UqmkduIjBRzZWaJvHent69xdQC8kyFpryZG3Wf7cPDB9AJvd0jGx8mZ3S8Cu2rBxdH+1HDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcAbSq7bGS8cdL4zozsAXYr/HE5wf3sDTXJj5rg1MzA=;
 b=EvCwYwprd5YeGJWoid6QL1NDGIeD/E71Lqp+CpacEiiQ33iGDUsqQLKFM7DobtoBVjfBiZXDlbg/NbqEKvDnsNcoPJ3PmtHhlrzoL8oYpbkv81qat3j1fhtG8fpe6mhaHp6mGw5bgvMsLQJk4ugGPHp5kFLYi0yky1i1N6wYIIg=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by IA0PR10MB7370.namprd10.prod.outlook.com (2603:10b6:208:3dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.31; Mon, 27 Mar
 2023 19:44:01 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 19:44:01 +0000
Date:   Mon, 27 Mar 2023 15:43:58 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org,
        syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Subject: Re: [PATCH 8/8] mm: enable maple tree RCU mode by default.
Message-ID: <20230327194358.so2wrir277l5phlm@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org,
        syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
 <20230327185532.2354250-9-Liam.Howlett@oracle.com>
 <20230327123849.f2b9db25baf367e3c77fe072@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327123849.f2b9db25baf367e3c77fe072@linux-foundation.org>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT4PR01CA0265.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::29) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|IA0PR10MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c94488c-8607-4f35-90b7-08db2efb9d05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3cx6hCTAWPqKA+ZuhO+rWoYMIPI2TzlS7j8ZJrM1wPtfuYOeJ4ELq05oCr3hB2wFxcY7DWP1N5egs/iuX5t11viUurzojUUfbw7qZmGHuFj9ZFCi8KCYsA4fGWj+YbJ9i2Gvlot91BFsYTyWFjMh388w8dheG+am7ACtCYLxcgILWGaizi3Z7iSCeD12X5rIoanz921pyka9nMg8v6FudXnYpaGlU5dm/gdyGJINwY1rkGVNO0ImLbg3V5X5PsMFyGxKEahvQzrIBe9bxGfZ+Idfis0x0G23Hnx8b2IlCFvzjM6/Zh/e+kt9TvvEIkCx+9OjukEkpFBeIGSrDHbNLSs3ZZcDdfJh/U/bb4F0F0ReVWwhaP91zjbD//Qouth8hkuqc+qSPJIfdRCkv1bN7kxtwoIbKnh7dghah1rzj+S2CUME0BXcOSoAoBBc6tTQgZ8PNbf+koYphCk/LD+ODQr8M5OLCnPrL7cSG0EeIPGudQYcaxlG5faadBuMHAbyC13JNtJ12Ce+O6l+fxdSOBHEkvAehGnUD+H5qereM0Q6orU/FhUL2pngE4qb38GD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199021)(2906002)(86362001)(38100700002)(33716001)(478600001)(6486002)(6666004)(83380400001)(6506007)(9686003)(6512007)(54906003)(8676002)(6916009)(4326008)(316002)(66946007)(66476007)(66556008)(5660300002)(26005)(186003)(1076003)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hIDdvPIf6Wt7kMZ3TH+P5c8Gx6F0VYILNOlEnbNBBTB+ADLUAxqMi0ZG0Tnk?=
 =?us-ascii?Q?SBG1PLREtKbCgmtkjvLkX9aV+kQJBQyGN33pyguXcgA1z5ApDx68B48BaRRx?=
 =?us-ascii?Q?+eiM7OIh2M/+r4bQqYLQwnuODWTwIWe9nmlacK60kdwupcXx9nYJAYtXZm9N?=
 =?us-ascii?Q?flb5rg1ekG8Q2hZFhOmEHubXtuKDeByLw6JI4vbQa1o3xgEqPDX1hMhxoIi9?=
 =?us-ascii?Q?4F3G8ExeVhQ1HqH0LvAsI7MhmmwFCHVAhZseImmtExjtegtYfDqjVRaN4d43?=
 =?us-ascii?Q?BwjL8wr4zULnleh7DfEJIfcumKBTHSHivwN5/6Dps4uBUDKMT+XI9UzTAmP8?=
 =?us-ascii?Q?WppvoGxIexYiODiag0ph42A4ZbaxEJL5V4kr0hb2ltWr9rJ7pjvgiOdsUGNW?=
 =?us-ascii?Q?czRmjZ3T6LO8QKQ62ff7N0x4JxjdT6+HkR3is4suLWOk/37haPkxE9VWNPd/?=
 =?us-ascii?Q?opgYXfrKlIrXmdZzqpct6a2hcit1MWBOPqgxgMnGy7G3mVuLao1NI4jPL/IV?=
 =?us-ascii?Q?PzNWzhreEC4jnuW38rBwRM2NpT4YGyJIvXGQY3gQLUf4Vxgdr6vLfaopz3Rg?=
 =?us-ascii?Q?9XCXWROsGIb/V8bqnHnEe0llKxl/VI5tWWffvANlH6dAjGZyJjP7hXTmVsH1?=
 =?us-ascii?Q?ecoI03nSP/EtIgxXBQxXUVcIv7OPqzgDjbj6H9u0eYDFFn4M8a9fSjAdF940?=
 =?us-ascii?Q?2YRq1CF+3YSwqsHqEEIkeWG+KuYkQB7CmgeOszMZjlJQVcO0ejb55ZqubJNM?=
 =?us-ascii?Q?CHSd8O9iOPvE2xoWJwWVisR+Z/Nhu6hvc8dtvQt+6tKzOf5ZIDnbikBxXH/b?=
 =?us-ascii?Q?FPUygq8Jyp2sIQee81rG07Qt7et5bM5p+27Hzo1WmYhSxFCv+uQ4HwZrRrKh?=
 =?us-ascii?Q?jnmoryO+yo9gBy+vMrxGIBRMjNpWr/+ts+8CQoqnJDjrR+M8lP7r6xRTWtCR?=
 =?us-ascii?Q?o2bEi1ZmFVlHq9zgujjOI4Bmo6FVmd08cs/HCH3IOFngPoSMV2cgz/JYkQ5p?=
 =?us-ascii?Q?Q/3CTua1K152Dbeij5hbwYvPm5nsAXh5fIR8SpAK3HvF7nmEkAnfBXqdt/9i?=
 =?us-ascii?Q?b9FXC2Ej1pV4SmWNAM2X7vKGdFyWwJWJT237qBmdsP2+cpyYgT2MWOk9/zcq?=
 =?us-ascii?Q?4fjEKkrZ1GLxs5tGkfxPqyMX+/h/hHFhV8CWyE6C+XUc7c72I0EzR9bAxwb8?=
 =?us-ascii?Q?+MAvLMNz8nlKbFTHt+rxRO1wIs4hAhLxrW5e2ee5HP/oHyvn16ovj+2R4u07?=
 =?us-ascii?Q?wWmea3Rbs8+BNKxKjPZDovmawnRzZ49rYyH4BRcxlzzSoE06OrZuEPvj3kK0?=
 =?us-ascii?Q?KlbWKwZIr5RExxGUH2u1hxCUA1C/GOX1+kqZSdvmCxaR/eRuLcV8qm2q3Vti?=
 =?us-ascii?Q?ztOP4PjHSB33gAdhwQF/BfHQi8BtAjZBdZ1ctD33Bq32Mi/D4h+ZbKJc3r7L?=
 =?us-ascii?Q?MtUHS/+Vd0me0DMYmS0YhglAuLSgUmOrvVHErzQ97RcK7KI2q1R7LnE67MNg?=
 =?us-ascii?Q?zaDLzg7qfl51Ck6+mszh0pkARJzSJ43a4Pgg0h5YKYNSMPVYqVEvPs0fwfCM?=
 =?us-ascii?Q?PcTHLc081OMMQyPDlZd1C5Ocoxnt2iFNrgauOP9aVmOnpYUjW8HVliEx7XD2?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ntmb44/vSK9g0w5KLEAI94i91G7nLzgekkYPtIWS2rYbH1ISQYrjDdKa5Tgh?=
 =?us-ascii?Q?BzjwRlOThESRdKM844lEkL9nY0gPhZsJcv5D/aK3ddBNNEKNq+NiKvY3C9iL?=
 =?us-ascii?Q?t9KsVUCwNSsSW40Pw5qbxcLlyJCn6r+Ss22undXdwSSnxaMWdfQBY5v8Gx2O?=
 =?us-ascii?Q?skyGHd82CMmQX+PwY6nCY8qCaKy7Nfsxa5cnIo1sIvcUyiV5SUegmjSFYX3W?=
 =?us-ascii?Q?MqARoA4zoehiF48yBXR1xY/AgyLzD2P6MfKYQet/GGoxh7PJtD4zOHPRQ6SA?=
 =?us-ascii?Q?3WCZjz4HS2ytZfh9ixOttl8dfyvztteJCE+T7aXFFq9tmDM54zyL6pCyYQ0n?=
 =?us-ascii?Q?wOFEvG1hMU3OA87b4O8d9nBPDwG08pcNbtXGhIaomljWyi37S6tWfVZtVgzw?=
 =?us-ascii?Q?wnbR1r8gHf48ql86k48L/KD3QefqsKKyS4gfidcmp6l4SEy6e3eTMc+XmVpX?=
 =?us-ascii?Q?a94FTP0lcn3IAHD96HUtIvvDRZb8D09ZEDsDncwOyv1ZuCRsTwff450PnvBW?=
 =?us-ascii?Q?gLHepXtoYxosxYeHA1TWsVu2rzi5/hn8FH4UM6m34oeGW2NjsQq+IQcIlEYZ?=
 =?us-ascii?Q?QYt/kppCXgSL42BTute8ftA8olbN8Z3aGhLZ01SvPRlZa4eunDIMwMMBVoLb?=
 =?us-ascii?Q?4I0IrjP2FWenrsMrXZ0A4m2e834IHhIIEBv6MVq+J80nkZiazF8ELn4ttS0/?=
 =?us-ascii?Q?mulxLf19nxO0sIQV9516SwkaBz4w7TBUhpRYm59Y19KODL/iHCqzkjL3Jv3z?=
 =?us-ascii?Q?59VSy6DvN1Aj9di+k0z+WKhi5FvOgOhqTv5GG86WB5DLichT++lqujp+oBnb?=
 =?us-ascii?Q?Qj1pv0p3kCVjVW0NzPHbbJ+guiuauu038wo7h9Ec2hQiRJf+jvQ/hR7QTQOK?=
 =?us-ascii?Q?tNTM/Nl0E27Ip95zcmGT6laGyYWaNLL2Ez+fVGN2WhrTdVbgabaJ/y2W+wN6?=
 =?us-ascii?Q?8QfjXphRK71T3pu9zekGEjz7u9v8lZnM+5xr9UunXgpUHkhPoT5GZtpdo5bH?=
 =?us-ascii?Q?7M+X4Fxo8TR9dxunIVZYDYD88A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c94488c-8607-4f35-90b7-08db2efb9d05
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 19:44:00.9874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jU5wJXmPeh086yhZZxb8fZhio+vPCx6fVILK1Vwm5R23D4u0okX8ni1/z6edBJG3FJxM0K0pTjJXVZISB+uMLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7370
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=369 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270161
X-Proofpoint-GUID: YyI7CtTuPrC53UeHbdad_GC9DOTcBea4
X-Proofpoint-ORIG-GUID: YyI7CtTuPrC53UeHbdad_GC9DOTcBea4
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [230327 15:38]:
> On Mon, 27 Mar 2023 14:55:32 -0400 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > Use the maple tree in RCU mode for VMA tracking.
> > 
> > The maple tree tracks the stack and is able to update the pivot
> > (lower/upper boundary) in-place to allow the page fault handler to write
> > to the tree while holding just the mmap read lock.  This is safe as the
> > writes to the stack have a guard VMA which ensures there will always be
> > a NULL in the direction of the growth and thus will only update a pivot.
> > 
> > It is possible, but not recommended, to have VMAs that grow up/down
> > without guard VMAs.  syzbot has constructed a testcase which sets up a
> > VMA to grow and consume the empty space.  Overwriting the entire NULL
> > entry causes the tree to be altered in a way that is not safe for
> > concurrent readers; the readers may see a node being rewritten or one
> > that does not match the maple state they are using.
> > 
> > Enabling RCU mode allows the concurrent readers to see a stable node and
> 
> This differs from what had.  Intended?

Yes, this is not necessary.  The scope of this tree is limited to the
function do_vmi_align_munmap() and so we don't need to free the nodes
with RCU.

Thanks,
Liam

> 
> --- a/mm/mmap.c~mm-enable-maple-tree-rcu-mode-by-default-v8
> +++ a/mm/mmap.c
> @@ -2277,8 +2277,7 @@ do_vmi_align_munmap(struct vma_iterator
>  	int count = 0;
>  	int error = -ENOMEM;
>  	MA_STATE(mas_detach, &mt_detach, 0, 0);
> -	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags &
> -		      (MT_FLAGS_LOCK_MASK | MT_FLAGS_USE_RCU));
> +	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
>  	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
>  
>  	/*
> _
> 
