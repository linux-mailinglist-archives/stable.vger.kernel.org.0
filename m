Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0516DC821
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 17:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjDJPBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 11:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjDJPBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 11:01:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704725279;
        Mon, 10 Apr 2023 08:01:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33ACp1hM000333;
        Mon, 10 Apr 2023 15:01:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=ashlxD+YhUWmE69SONMlPcJrwglZnKuNGRa2hCtqqas=;
 b=sCz0AzLo2/DvqmQVXZQY/DPj/PEQKsziopFLD4QjSR1Vc2WGS6rEWhJdkHdICiAkwCVU
 krZ/0apmTxhEAIJDxT+3O8C21Vt5m7/yHENL1VMNVI/NqJC3CIpmnrCFWq2fxuAV1zjB
 1p2nfApa3A+5hQS8kbLLJx0PkccFXChQQqdnD6Qah1ESlWhf12MAloyudtTRyHJMTuL/
 0XptHBhFrtGVXdC/hIzywfZ4YOAzrrqsdDKf/38srUelZEhkq9KCgYvN85Uwduc0xNfX
 qiDV10cWsdikt2FIwEIWgzB5V6lNflj9yFrwJKQ6Z+/uqP1p5WDeaQrdL4il2dSRTH3w YQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq30w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 15:01:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33AEUief021493;
        Mon, 10 Apr 2023 15:00:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdm21a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 15:00:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kw8o53DjzBoC4hx+58WXgVPpUQOc+dUXRwsnI3kVZhA/2PTmmZHL19lkPRCpuin6KoGwuu/N+YK09LbNylrZyoZve48zRXfH5CCDA2OIG+RbrwXC8+pWsoh2vuSqCJ3tWJuBX1N1NSc2wKsI5Xvk7FzvRwgH3WcMMOlF8F/Vzi8bzTuFRP+fkWu4Hr+5sMfDIE8ikGbAqOOMRVKpTXHVw/ggPG4K3m0m0Wae1lUrQ3jrLRSWqd4REiYy16qlGsZWmZ1U2Uq3OLpw4akXrpD0zY4VZjnAjv7iMueWHfIaNc6QHoYVAJyFSR+ln1uxWxFJACx6FEPU2LElZ1bT2HUJag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ashlxD+YhUWmE69SONMlPcJrwglZnKuNGRa2hCtqqas=;
 b=MwtwI96Mzb44Harxsl1dzvLt+IAvjXQi4pbYnPgLziwPvKygYkfYx2DOx0oUytQTlRPY0zGzthi8XMeuQZLQ2khCiTPGMlNOFJBwE4czYmOS0vgpPC0wONtFG3u5phq6+42Vay5AOxeQNlAegfJAZRVzS3N7/yBOykl8zLeQbr85/X6LLH/EYBUud3smFPKTGwKN6bjJPqvL5QpNH8ezzDVMnxLFXdySVcZvuarYiBPTK2xOSVCH3dcSykdO5UqXPdM4iOvVW46V12ME4Lxwp1Gf5q5RpHuxlBFzJ6dls3KYWiEA8pB2eAomaFi8X9ddgrQJTHMzeepzozRmMUK7Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ashlxD+YhUWmE69SONMlPcJrwglZnKuNGRa2hCtqqas=;
 b=ZbrhgcZmF0nGxcjH3MJbR8zZd9OLTs9UBeHhezM6DRfsEjAv883EUuIFCcCrOCF2XMLM2bpmXU/6fISOuxvf8/ZFV5kdCm5nurCcNrQPEVT13YMWnzQGLt0CM4qmwem3UjP6K8dXIKNPVKSy07aWHubaHVx469/uC/0HN3ne/6g=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA2PR10MB4586.namprd10.prod.outlook.com (2603:10b6:806:113::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 15:00:57 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Mon, 10 Apr 2023
 15:00:57 +0000
Date:   Mon, 10 Apr 2023 11:00:54 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Peng Zhang <perlyzhang@gmail.com>
Cc:     Peng Zhang <zhangpeng.00@bytedance.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] maple_tree: Fix a potential memory leak, OOB access,
 or other unpredictable bug
Message-ID: <20230410150054.nfmrlqfjdgqvehcn@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Peng Zhang <perlyzhang@gmail.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, stable@vger.kernel.org
References: <20230407040718.99064-1-zhangpeng.00@bytedance.com>
 <20230407040718.99064-2-zhangpeng.00@bytedance.com>
 <20230410124331.kijufkik2qlxoxjz@revolver>
 <84c50299-5b5b-867e-1e96-2d3a0c6ade2a@gmail.com>
 <20230410131258.txkiqa5eudgsrmht@revolver>
 <c9a5bcce-7e1b-81cd-b85f-0e9128024d6b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c9a5bcce-7e1b-81cd-b85f-0e9128024d6b@gmail.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT1PR01CA0080.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::19) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SA2PR10MB4586:EE_
X-MS-Office365-Filtering-Correlation-Id: abe5ca41-0781-4355-72bf-08db39d46392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ze/Ustft3o7lKuELsOf8QcIaSl2lPHOS1WK49VNGvefDK05cVUzi2p6/NzuhH8WAotvJIWnfidHdJ44yNT3PL5QN6odFEvGj8qknwTsgxTHIuSsM9grDlEEYgDbtinegK1HM1uOcdMpMgivmIOP44+FI7v3x+Gc+w2qw9zrFW0OTPSNRfZnvaQaN/IAkNTq7TYWHXIxhg0pWRG9Q03HMcVBJHfsvdk4fH6MFXkm5yeZrjVrbgAzoEpLsbiP3/8vyG1cM1bUy+x+IVRGLb7ysvlZn9nkCK6VaooEMIjbu+HL6kdCKF0arERPjF/CPDrIHH9SkfMyat4SBdw3k6ccbQBN9oeWBk0tXeTfnZHAkPiiPsph5p5ui0WWMhNQx5s5ICj3kzle5XNV0WxOqMqkQXgtR3ZXpIN4s+Um3i4rojxYVyAVJwYwDoT09pYtEcPL0flFQS48IeQUv4ylavBX95aI/vom3I7mwZjNMZC3pH1b2Dg6LY+mJFZgXh4QUP9VihJlOjs2UVWn1pip0JmspZTiEBJuBC9LK1X7bMoHebpcVMoWYUVosI7hBosousBpf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199021)(6512007)(3716004)(2906002)(26005)(6506007)(186003)(9686003)(1076003)(6916009)(83380400001)(8676002)(66946007)(66556008)(66476007)(41300700001)(478600001)(5660300002)(8936002)(6486002)(6666004)(316002)(4326008)(38100700002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkJweUNKekNHZlM4N0ZZaDNyQ0hzcGdYeXRJU0tMd1dITmV5SS92N2h4MXJC?=
 =?utf-8?B?eVBFMUxSMHZqTDZ0VjdPcWxtekRESXZwbnh0NTlQM1VRVU9BZGwxY3QxSlNs?=
 =?utf-8?B?RTEvLzk2QzFESkNQT3ZCUUF0NUhUWU93WDZ6R25PTlo1T2xzTW1BVEZNbnFC?=
 =?utf-8?B?U3JZWGhVUFBjeEo3aEloR0tENTREVzBOTHU4bHc1dXpMMlhIclVwY2FOd3NG?=
 =?utf-8?B?NjQwV081Nk9zaXhvLzBVcHZFSFdzaVUyd3dBRzhOTHkvdk5OT1IvODhaQ3Bm?=
 =?utf-8?B?a3pzTjAzcjhVZi81cHdST2RKR2tjUDFqYjQ4aFJIckRaZkxSSFpURm13RnVs?=
 =?utf-8?B?NHdwM1VFODc1N1ljUk9xMEQ0ZEtWZ3Y0VHlCQWJwOFVZSXFXb0xHeU8wNHJY?=
 =?utf-8?B?UEtpa0RzNEVTQmUyclBSeHZxNVF4aWZVTFVzNlkvdzl3MmczeWhtajV1Y2dX?=
 =?utf-8?B?c1A2NEsvQkdlY1VnME0vdm4vWGJPbFVPN3ZtNXZndXJZaDdhNTd0QkdKT1lN?=
 =?utf-8?B?eXZIQWRkTDI4QlZBcGpNQlc2blFwZHlHT0FmUjBCOUFSS2ZrZ2d6U1RwS1pK?=
 =?utf-8?B?bnRmRlcrN0F4QWZVcU1vcFZUUWNQNkNkN1pOTnBPRWZxMXlWemdBVFJVVlZX?=
 =?utf-8?B?Y3Zqbi8zYUU1NGlOdlhFS1pmb2dOV2hrWDBxeFNQTGRkTGhwdGFCL1ZqSnNs?=
 =?utf-8?B?alhJODdqalFOQ2pKb3FFM3dFYm5WYXR4c1ExeUFSVEJNc0t1QWc3UkZqMkx3?=
 =?utf-8?B?RC9TNzAzRWlrRGEyR0N6a0x1Z05pcXE3c3BHaFhhREpyL0tLMmVBbG12UU1S?=
 =?utf-8?B?SmQxdktMckYvcVVFM0x4cXZoNlQ3T081eWJjQkJQZnVmS0VQdjdlVFFnclN4?=
 =?utf-8?B?RStrR3htU0pxSjVoZnhod0NBL0NxQnVNRVlhVVJEUjdGeTJLcDlUQTBxbWx3?=
 =?utf-8?B?dFhmT2ZVMGRDQzgvQkRMZ0xnRkNwRWR4Z1RNZXhuTWJoU2haakg1R1RvU2Jo?=
 =?utf-8?B?aTIramZBR0tUT0h1TW5penZ2RUhXN2JHcXovbFRwandzemlERlZ4UzZmZTI3?=
 =?utf-8?B?MkRvTFZ3ZGVXWTZyQzZZbVZCNGUyM1BTUFRBcDVmUnhWcit4ZnEvWk1pQ2Vv?=
 =?utf-8?B?cm9oTS8xRVA1UGxtU2NyQytzK1Y0YnJWYmZ6ZXMwckpOanlBb0dNMjRPQkts?=
 =?utf-8?B?OTVqTmdSVTlNeXJSbWtDS1BPWU5tanU3RnBJWituSENRS3ZIMjZ1Y3BQVzJG?=
 =?utf-8?B?ekZBQU5tWmRtazlWc3ZaTHlqbmxSRE50WW9DbjNuQ255UncyVGorUTYrZzdJ?=
 =?utf-8?B?dyt3eWRVMG9lT1dHdUpCVFhlRDhDek5KYnpBWjNkSGVDNVY4QUVoLzcwQ3dr?=
 =?utf-8?B?MmtEN2FnVmlSYjd5d0xHNXFtOTdOMEFJMHVlS202MjYyRHZpZHNCZTJzczZ3?=
 =?utf-8?B?ZXpreTlhejJEaGZ5MWxNWEt1VVRSY1BybnU2MDk3aWlGRmRicmhqK2czK1lE?=
 =?utf-8?B?bkFMRForV0s5aG03dStrZXVFQ3FiNVhEa0dGY3BTb1E5NzM1SThaaDN3SUR4?=
 =?utf-8?B?RWk3eDJnOFBSRGUyM0ExTURNUkdiZ1B4MlRKa0xUcFkxNlhEdXF6QmZRR1V0?=
 =?utf-8?B?RExkaTRzL1RFbFU5VjI4L3YzQitDbU9IdFFza2xGeWxqeG9YT3hXWkhpUlBM?=
 =?utf-8?B?enpQaEJPTHhobi9vdXIyV1NKV1QzcW0vclJVbjBsYmJZeUdGdnREUEVSL2ls?=
 =?utf-8?B?ZElPTDJqVGFyNERQRSt6bTM2T2JFY3VKT3ZOMTNqUmRSaUcyQzViOFZKK1I1?=
 =?utf-8?B?NDNqTmg1a1kraGxldmF0OE84b0gyQnQ1Nm5rek1laDFsakZlRXJhU2Uvc3Ir?=
 =?utf-8?B?YlBjSjlBVlZFNGU4eE13TWlHZzI1NU5SVFkvN1kzbU9zRnBVaUtoR0dvc3M1?=
 =?utf-8?B?OGU4NldqVVh4dkY5eTFudEdIYkttMVJXVDdRZG9YN1FDcDNDUjZ3Z0NKMzBW?=
 =?utf-8?B?alk4TEpYbEVLcW5HaWFwZFRJQkNSVTd4THFxcVMxUklDT0VVUExvRUg2MFZJ?=
 =?utf-8?B?NHFLaDZoUVFyaWZPYksxMzRHWWI1Tlc3SW9VZEczZjk1Mm8vZUY0dFRmRDRG?=
 =?utf-8?B?VjZyUWtmdGZDcmVNSThiLzdLNXNSNlVhc29BeThUUmh6MHJOZitnUFh1a0J5?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UmRnOVhrZjBPRHRUOG5WRDQ1dXdiWklMc0QxcHRKZ2p2NFlJbFVmWndoT25x?=
 =?utf-8?B?MmZaRHZCN25ycy9jSHh0SDhsZWNtMHVRNnJIMURPL1hVWXZJQnRZN2l3cERr?=
 =?utf-8?B?NEtzaHU5UlZxOHJhYkZpRldoZ3oyN2ZqTjVkODllK3VpVTJSTldESlpuZnE1?=
 =?utf-8?B?aEg5RXFKRU9ZNk82bHhBbDJQNE5KeU5wV3VreitBNGdDYzNKYXp3SlR0T0Np?=
 =?utf-8?B?WWJ4Z085b3V3TzRqWWdwZzJycFEzU1Z5dVhJVXBWVXY2am1WeFJ5dDdTVS9h?=
 =?utf-8?B?TDhua3VzV0NFSjRKd29pclJoWk1sK2lrWWJMazhMd1ZXSzJoK29BRnBrQzVR?=
 =?utf-8?B?d3FjOVc0ZWJ4RWwyVEhZM2FHUWtFRWRwejIxbVRlWG1EbFhBYlphUTFseVh6?=
 =?utf-8?B?ZjlYRkgrTzNKNEg1amM0dmY0clpBRFlGemM1QWxicTByUXJkN0FaNkY3TExl?=
 =?utf-8?B?b2lYcU1EbU9zMHNVdXZuQWFmL0d6TGlEWHZwcHZMbXZ2WC9tS0hHZnRDZ1py?=
 =?utf-8?B?STVTNCs0S0w4cGNxNzVlM2xkV25Qdk8xa1FzcmROOWZVOVN0VkxHcmIyS2xy?=
 =?utf-8?B?VVAyTkpRUE5LaWpZNVVZSVAxMkNvdG1mMGVMMXNHV3V5YnZwZGt6Ry9MREhx?=
 =?utf-8?B?NWcwa2RtWnplajcyeFIwN0l2dWNBMExNRC9DNE9sRHcwVEhqRS9ibytpcWRG?=
 =?utf-8?B?UnlxZ0tJOG12SlFyL0R0eVpqeVJQRFU1aklReEJXa3FGL1IrV2tlWENNL1U0?=
 =?utf-8?B?QUFTWTBaZjd1cjIvd1RRNVdxb05WajRhQjY2bmlvYmt1c0ZnTFo4TU5MMng3?=
 =?utf-8?B?MVRYVEJ6anBBQndtMmRWb0l0WDl6N0NGTkU5ZkdNbzdta2xlTEJzQ2poYmxl?=
 =?utf-8?B?MGJYNmVzUnZ1RlIzZVVZL0orMGlFaWlzc1FLWGQ4RU96dzdFNExiN2wzd0NL?=
 =?utf-8?B?RTBXWmMvRlNBa2pQcW1pMjA2RzA5eWVlU0Q4L3ExdFJpdVJwUmdIbGgzTGJX?=
 =?utf-8?B?Rkh0VW9JUXo5SG52ZHdLZmtDQUNERjdwS09tcFlBZXVFSVdVOHgzMU1hbVhy?=
 =?utf-8?B?bC83cytsVFMrTVpUNVRQd040YTREN0lmYXYvWE9ZN3lwdys4L1I3YkE0Mk1R?=
 =?utf-8?B?TDdITEFSOXU5KysrczlFb0NudEVrdDFUS2J4WlJNaEpwOGJ0TlVDdS9uWm11?=
 =?utf-8?B?MXJEVnJjSjRUUlRCTHV0RXdSMllLR1d0NnNLUHBZbStzemZack5RL3FYd0Nm?=
 =?utf-8?B?c3A1Ni8xcmx3bFA3ZHVEZjUzRUptUUZDeGFia0REdzVZMUs3UT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe5ca41-0781-4355-72bf-08db39d46392
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 15:00:57.1481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtDZdeBxYDB7KrKyAvlgRiVL/1uUpA1NMWcGddy8Hvx2/NYg0vTDfwkqVgIhbE8v6RjV6rKkE2jvnpLbttjs1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_10,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304100127
X-Proofpoint-GUID: elhTBlmFNz1Fq07d__AZF759WPJiAMqF
X-Proofpoint-ORIG-GUID: elhTBlmFNz1Fq07d__AZF759WPJiAMqF
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Peng Zhang <perlyzhang@gmail.com> [230410 09:28]:
>=20
> =E5=9C=A8 2023/4/10 21:12, Liam R. Howlett =E5=86=99=E9=81=93:
> > * Peng Zhang <perlyzhang@gmail.com> [230410 08:58]:
> > > =E5=9C=A8 2023/4/10 20:43, Liam R. Howlett =E5=86=99=E9=81=93:
> > > > * Peng Zhang <zhangpeng.00@bytedance.com> [230407 00:10]:
> > > > > In mas_alloc_nodes(), there is such a piece of code:
> > > > > while (requested) {
> > > > > 	...
> > > > > 	node->node_count =3D 0;
> > > > > 	...
> > > > > }
> > > > You don't need to quote code in your commit message since it is
> > > > available in the change log or in the file itself.
> > > Ok, I will change it in the next version.
> > > > > "node->node_count =3D 0" means to initialize the node_count field=
 of the
> > > > > new node, but the node may not be a new node. It may be a node th=
at
> > > > > existed before and node_count has a value, setting it to 0 will c=
ause a
> > > > > memory leak. At this time, mas->alloc->total will be greater than=
 the
> > > > > actual number of nodes in the linked list, which may cause many o=
ther
> > > > > errors. For example, out-of-bounds access in mas_pop_node(), and
> > > > > mas_pop_node() may return addresses that should not be used.
> > > > > Fix it by initializing node_count only for new nodes.
> > > > >=20
> > > > > Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> > > > > Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> > > > > Cc: <stable@vger.kernel.org>
> > > > > ---
> > > > >    lib/maple_tree.c | 16 ++++------------
> > > > >    1 file changed, 4 insertions(+), 12 deletions(-)
> > > > >=20
> > > > > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > > > > index 65fd861b30e1..9e25b3215803 100644
> > > > > --- a/lib/maple_tree.c
> > > > > +++ b/lib/maple_tree.c
> > > > > @@ -1249,26 +1249,18 @@ static inline void mas_alloc_nodes(struct=
 ma_state *mas, gfp_t gfp)
> > > > >    	node =3D mas->alloc;
> > > > >    	node->request_count =3D 0;
> > > > >    	while (requested) {
> > > > > -		max_req =3D MAPLE_ALLOC_SLOTS;
> > > > > -		if (node->node_count) {
> > > > > -			unsigned int offset =3D node->node_count;
> > > > > -
> > > > > -			slots =3D (void **)&node->slot[offset];
> > > > > -			max_req -=3D offset;
> > > > > -		} else {
> > > > > -			slots =3D (void **)&node->slot;
> > > > > -		}
> > > > > -
> > > > > +		max_req =3D MAPLE_ALLOC_SLOTS - node->node_count;
> > > > > +		slots =3D (void **)&node->slot[node->node_count];
> > > > Thanks, this is much cleaner.
> > > >=20
> > > > >    		max_req =3D min(requested, max_req);
> > > > >    		count =3D mt_alloc_bulk(gfp, max_req, slots);
> > > > >    		if (!count)
> > > > >    			goto nomem_bulk;
> > > > > +		if (node->node_count =3D=3D 0)
> > > > > +			node->slot[0]->node_count =3D 0;
> > > > >    		node->node_count +=3D count;
> > > > >    		allocated +=3D count;
> > > > >    		node =3D node->slot[0];
> > > > > -		node->node_count =3D 0;
> > > > > -		node->request_count =3D 0;
> > > > Why are we not clearing request_count anymore?
> > > Because the node pointed to by the variable "node"
> > > must not be the head node of the linked list at
> > > this time, we only need to maintain the information
> > > of the head node.
> > Right, at this time it is not the head node, but could it become the
> > head node with invalid data?  I think it can, because we don't
> > explicitly set it in mas_pop_node()?
> 1. Actually in mas_pop_node(), when a node becomes the head node,
> =C2=A0=C2=A0 we initialize its total field and request_count field.

Only if there is a request_count to begin with, right?

>=20
> 2. The total field and request_count field of any non-head node,
> =C2=A0=C2=A0 even if we initialize it, cannot be considered a valid value=
.
> =C2=A0=C2=A0 Imagine if the request_count of the head node is changed, th=
en
> =C2=A0=C2=A0 we don't actually change the request_count of the non-head n=
odes,
> =C2=A0=C2=A0 so it is an invalid value anyway.

When we pop a node, we record the requested value and only initialize it
to the recorded value + 1 if it wasn't zero.  So if there are no
requests, we don't initialize it.

This works because of the zeroing of that request_count that you removed
here.  But it was, as you pointed out, not always using the right node.
I think this needs to be moved to your new 'if' statement.

>=20
> >=20
> > In any case, be sure to mention that you make a change like this in the
> > change log, like "Drop setting the resquest_count as it is unnecessary
> > because.." in a new paragraph, so that it is not missed.
> I thought it was a small change that wasn't written in the changelog.
> In the next version and any future patches, I will write down the
> details of any changes.
>=20
> Thanks.
>=20
> >=20
> >=20
> > > > >    		requested -=3D count;
> > > > >    	}
> > > > >    	mas->alloc->total =3D allocated;
> > > > > --=20
> > > > > 2.20.1
> > > > >=20
>=20
