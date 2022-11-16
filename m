Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4062B1EC
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 04:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiKPDtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 22:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKPDtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 22:49:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8C7CD4
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 19:49:12 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AG3VCu6032618;
        Wed, 16 Nov 2022 03:48:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=DOiulEm+1i0IzBIf64CYL0QWq1x7X1UwSyNM6soeE+4=;
 b=TC379VOLQ3OJBSVq1mhJVFfrI+zimUW17vScqMS20rnzMTh3l0/pP8DZ5YMXg2bVK1DD
 Drad/FR/vJmN0xBQdgf1DDp2FnLlApx4nIdXn4Bt9gv48+SXz08B/jJm7q26w+jlLq6A
 BwVCzM2PjzFut2FUUfAhmBPiLR5md+kAS+nJmcE1b/o+qqGgNW+UvsGWSUNaxCNctGwp
 ok2vVY5EZ+4dRiGAXD1Zd9drd3p/jaRvC4v2j21tngAX54CbGk52mQl3RXpA2T+12M0B
 3DfDq2ZqM5yzSUwk2UXdF4++7SyBkIBzRzwhNgIFx0gsEfBZ+tf+WWnI9IC+4Xr8nAEk 5w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3jskkb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 03:48:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AG2VXTx031840;
        Wed, 16 Nov 2022 03:48:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xcu18b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 03:48:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4KzJnJQNEiu+ZvqjwQNN6wOJNhK7ACqSlDlosd64wQuujDRU1oEu9e8KeaFIWJKA+Nq1ehOC7Eb6W1lnbxkCftnKmE/bsUYFRLUs0E4eQrbNLZKnGzcxwcq9CzAwjdOlT8hB6iGRUNYfmjqZp53lH4T2V17o9mv0q2a+lgNH8ncChMWDWto7WiNpaQhH8KcmXWYi3nFxFlM9U1dA65/txsR6ffN4t2cfAw3nR3WNAat7eUblfz++TJMDgUduCYYzTr+ih3lZa7VgWtcwQTY6cTKJpD1dLknHa2dReaTqwIDwH2bhFurWqADv5K7ghxI83hUiNRziAT8vNS9IbYTVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOiulEm+1i0IzBIf64CYL0QWq1x7X1UwSyNM6soeE+4=;
 b=DxaMFCozKFy4NMF8QDF43Uxi6R3ULOWTE9M7qEeMHWqnMq/uN2zRkxOJeKTnkBPjp/e7s3tDZ/Oh6B3Aj4pV8yb1GZbWU2rD5yFkVd97EBQxUb/NiUY3nEq+nDtlB/yLR6Yyae3La8mH74SE/lldvm+OyAcHcjsHIKo2zNq4viju71A65Jye/NaANXtiPTQLepRE18UwrAvohl2vkwWj4VNkQZ4vOpT1FeyPX4vFFifttgtvP2sRQRZxR8SngvaaryXXUuXMLqI7bdWNY8Iqg1/uupiqwD0Cn8JkSei+bQ7CraapSix+2vk8oGr9VkjLyUCDfjXzfRhMcP3csR3v/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOiulEm+1i0IzBIf64CYL0QWq1x7X1UwSyNM6soeE+4=;
 b=wpylvuVMf0WkGb6yw4geq2qi317bKWn742DWtUpcmb+gW21ZHwsHF0KWRibQaCP3gfN/xtYJFwo/Dwm2l51CyskVKek7aKgVwin4s06POi5z6j7ygGJHkhNf+8uI6t/+Hkl9yBYacMrDK3/+SlrEfSnsIzDDItjitlm5vib1J8E=
Received: from DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10)
 by BY5PR10MB4323.namprd10.prod.outlook.com (2603:10b6:a03:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 03:48:47 +0000
Received: from DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::4786:1191:c631:99da]) by DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::4786:1191:c631:99da%5]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 03:48:47 +0000
Date:   Tue, 15 Nov 2022 19:48:42 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc:     HORIGUCHI =?utf-8?B?TkFPWUEo5aCA5Y+j44CA55u05LmfKQ==?= 
        <naoya.horiguchi@nec.com>, Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <Y3RdmvpUq3XzYqq+@monkey>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004>
 <Y3LG/+wWSSj6ZYzl@monkey>
 <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
 <Y3LrtTmLdBU7atso@monkey>
 <20221115063912.GA3928893@u2004>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221115063912.GA3928893@u2004>
X-ClientProxiedBy: MW4PR04CA0221.namprd04.prod.outlook.com
 (2603:10b6:303:87::16) To DM6PR10MB4201.namprd10.prod.outlook.com
 (2603:10b6:5:216::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4201:EE_|BY5PR10MB4323:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cdc78c1-dfc4-49db-ce5e-08dac7857680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xpOyf59j+S8PqZ3+3cFyQqBYYZTNSwa7jRYaveBCCjA+cDGFHSAAdSqf+JP9310N5EvzdnaxdEu8uQy2+NQYWFgQzIAKlHdvCgqun952yL/0/cKhkMSZgSBPcpsNF4Gpdi2TbR/06cmhnYyib2VGudIgtzVlqPegU4KiUSrmqNvT7PpQRywdHCW+uu/MpwEep6oYSGDliV5ph2VSSZOO9bPZwhaWDwx/pYrvfvI2RWXrTOQwT517vzr+PfjSuX/wwbD6Fgqh6ny6/6TXb6o/xwmE/kmADOZWYH96rl4UPbrn1UTGkU8IcTYcCSLspEZ13GaETUB7w04S+O2OXPZTrRNEwkJr+P1GJa7UU8I2TQbBHHk9gU5zBK0nk+SmMNJlakriTj1GnQm7UsIGv+FWJp6D+XkWzYQ56mgnc+uC6+8tBZwm1nnS9efJw+3yW6APrYBNMAP6RBlcN8UHS8oEaypuqwE/SZFwWjodTmBPhGmSmdLLFb6ENEqqalUN2Tl3MvWi/ORl3SPpRMi21jum4JGCAIsuEHmsTVQa9m1zq1G/7AjPO67st3uvAWbdfJm1G8mkDdElyGkoacUaPpwdiksiEjY4LM+87+QDqefCGL5Vxgo9Quap1YYP9oT3pmfDmKa60YOHPJL45GxSLwfB6vox/ZGBAG1UnWLLIFBD1FHBr+Nq4SdmA0HuhM6aLeOUBVJccLcBwOaHr87sn/3ayg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4201.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(478600001)(6506007)(53546011)(6486002)(54906003)(33716001)(6666004)(6916009)(316002)(86362001)(9686003)(6512007)(26005)(8936002)(41300700001)(4326008)(38100700002)(8676002)(66476007)(66556008)(66946007)(5660300002)(186003)(83380400001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVhsdXhFWUtxUUtJSGEyWk92OW4ydVB6VmFsM2xOM3BzMXF2a1lhOW0vbEo1?=
 =?utf-8?B?cVAxcjhCUGtWcDFZdk85bjZ4NTFqcnZ3ZDJZZE10UlJJZWJDTXE2ZEpzaWk0?=
 =?utf-8?B?WGZQTUtvVXp2OXdyUjVrWllkWks4d2pqcDZMQmRJMS8wWWYrb2cycXhqZm1F?=
 =?utf-8?B?bGdiNnJSNDRFbkl3Ym9WWnA0ZWQ0ZXliOHVlVXJGb1dRNi85b05oSlg4THAw?=
 =?utf-8?B?V1dveEpSdHA5U2ovV0E4Vk5XdGx2T3JidzlwdWk3MFJqSFBkSTZYSHhGOUhW?=
 =?utf-8?B?S2dmMG9YWEh4SkhzNHArNExNWEdWVGg1TGhIY2NxekJlZkNOMkhuQmtKODNN?=
 =?utf-8?B?WEJuUUgrQ3JLYk9NeWRZM1lsZC9lS1JHWEpGT0JXTTJPSEhzV2Z4ZjJRV0Q1?=
 =?utf-8?B?M2h2eUh4R3FVdlZBb1orZnJZalRvNlFrb05RT21YazVoUWxVSUtEeEJNZmFD?=
 =?utf-8?B?cXF5Qlhvb1p5S3VGM05sZkFub3VPZVVOTG1vajZuZHZYYzZKNHpaUURuOVIw?=
 =?utf-8?B?K1FPcStQMHF4UkFYSVBHdlNVMEZJdmFOaWdzS1NlNjMrSFl2M1dSRGtyclAr?=
 =?utf-8?B?OUNQQ1ozaGdEc25PUWltc0xCR0tEaEVtOERUbndrVldYQzhHMGRhQm04NHZ3?=
 =?utf-8?B?dlpTQVEyekJlV3lBeE5HQWpvdWNKNnVxZDJhUEtHdkVhaVcreDJxYnNTWmJH?=
 =?utf-8?B?R1kxc0xqM1FzTVdzYlRXUDNER0dicG1Ua09QVzlwTFlSbDcvUFZBb1JrN2Nk?=
 =?utf-8?B?L0hKWU9JQm41VTJFdXFtaEUwNGlITVJYcUJJVFNOdmVPVmY3dTFva1pPVWRm?=
 =?utf-8?B?S1h4dUlEelZ1OCtDMytYMGkzN2o4bEJ0N1RZZkxROXUyRy84eVBwc05sQWd6?=
 =?utf-8?B?a09pQ0x6K3hENzUzYW05eGpCTlVOSlExTzVIbVJUTjY3SUlIcWExMW1DMHFC?=
 =?utf-8?B?Ym5RWnMva1RVU1dNSDNSZGN6OWdIVXh1N3RuRDVNRkdWeGhhREc2Q3ZqQnZ4?=
 =?utf-8?B?R2ZRWjc5My9hU090eG5GY3RuTTNuSlp1Kzd5YWlsQ3ltVTBwdmlSdnVYN2w5?=
 =?utf-8?B?dzJnTHhTRW5HRlpXTi84V09kN3dtak1pNXQvZU9ZQTFIak4yak1QdElyVHpr?=
 =?utf-8?B?TTRxZGV3Lzg5b1NndFM3WXR0R1h1dzl2MTBDY2dkeE9VYk43MEVJL1VNWkZP?=
 =?utf-8?B?V2h6WXlyT1B4Vy9rdnV4VXZBY04yc1BQTy9FNld5cU1WcWtITndLZTdPYzRJ?=
 =?utf-8?B?cUdlZjNsbUsxS3NzQ0RjVFd1U2FpMG1JMS9iNkVoTEh2dHQ5dzR3N1BMaExj?=
 =?utf-8?B?SHltVTQxQjhVSE9sR2JjVnVrSi9OZmFWQkMrZGlzTk12UTdwcGRKQ0Z1Z3NI?=
 =?utf-8?B?a25BemM3enFtVENLU1IvRStmVGgwdFQvUnlMNmltUnpVVitEVVZuVWlUTDRT?=
 =?utf-8?B?OFh0a2NGTlh0VVJKejFyN1VFMzBtV2RMZ09ZcUFQM3dZeE1xWGd6aGtuWW16?=
 =?utf-8?B?M1N0TGhwNmg0QzhTb3Bteml1ZExaQlNDZ0VGZ21Scit4ejVuVjVHOHFmVHov?=
 =?utf-8?B?aVd6MGRSVXdhUkg2S3lVd3U5Y0xqeWx0bGZ1N2JoUWU1QW02bjMrTWtNL1Rn?=
 =?utf-8?B?RUJZMHlFT212UDNzSlR2WTdia0dTRDgybCtRcllkMEZCZGhDWjhqc1FvNzcz?=
 =?utf-8?B?TzZPQUF4Y0Fia2lxRmk0STJDWUFlZXpuV1NjZk11bXN2MW9qVlJTa1lobEFV?=
 =?utf-8?B?dEd6Z0ZxQmxSY3FuSS9sQXJYMzk0dk51K0lrUm9zeGJqcndTbFdlSTdvV3hS?=
 =?utf-8?B?eFk4TlZ6R0Vzc3J6QmxXVTg3a1MrVzJKWnJCWnFNdUdKemtLYmdlZUtHS25u?=
 =?utf-8?B?UjIrRTlxR3AwS0dCZFB4RUpnMEZ2ZllRVXpMcnJsdnBGbjZIaStURUhuWGkv?=
 =?utf-8?B?OXB4ZlNqS3p0aWZvbU0yeWhITGpwY3pRNjJjU09DOXFqRTlWQVhMdFlUN2ZO?=
 =?utf-8?B?LzhkU2tKdnJhckh5TzlUVUVIMU9mZXNPWXVpZVQ1OXIvbVBKRmRWZ2dGSmRt?=
 =?utf-8?B?ZDJYem1qMDFPOFdZaFVmVUNBNVR2QnlUYnZmOGVYbUpPTGpNMFZBNmR6Z0lC?=
 =?utf-8?B?UUFiNmN3dVB5L3UwZHR3d2EyMFVMUmdoUDdCbXFRc0xzeW53N20zaEpOclg1?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bmNQMGJIeG5hZGR1bitjSWMxQXkwWDYzVHRpL1Eybm1yWDQyWGVtZ2lmcStF?=
 =?utf-8?B?RDB4aUE1MzdCbkZXYUVVaGtlU21zdWF2WWZXT2tqTmM1RkJOa2E2a2JuR3VP?=
 =?utf-8?B?dVJRMG04dG5nWnZWSGdxWXE1Y1A4K1dFUURZR2ZEdEZVVDJJb0tURGtjdHI2?=
 =?utf-8?B?dnpXNUVTam5Xa29zKzFRdFRyVENMZkM4VVJjY3d1NnZLT09qMndWeGVUbS9y?=
 =?utf-8?B?eDQ1dlFST1o2Y1hHNWIwc1VsWlJXQXY3MUtJRTMrdHZlUFU1ZTZGbCtwTkN1?=
 =?utf-8?B?M1MwbzFnV0R4SDcweFVNVHFPUENtSnVZbGVTSGJqSnI3dTBUbjdRNTNmTTh2?=
 =?utf-8?B?TWZRTzBodTlzRWlnOEljOHJXTjAwcDB1cTFUSDA3UXo2UThzdjZQU3F3Y2lQ?=
 =?utf-8?B?aWo4UlZKUDJFbDJJYmd5bUtnUExiVE9uSFhIYzNHVHd0MHo3TmUxQnV2TDhL?=
 =?utf-8?B?K1VLOWx2cmdqaTV4eDdjRVBFOVVXQmQvSnlYV2NmMjRuSzloOHlNeHVEcjRQ?=
 =?utf-8?B?a0NJRmFnVGI1N3pDK3hKaTRVUTQ4d014S2NDZ21WREZCMmF2S1ZGM0pBUG9Z?=
 =?utf-8?B?Z1EzWEtKaW9weVhHWFFNcnJ6OFdnSWxRUy9DZ1piUTNTSkJYRFF3YitjOGVo?=
 =?utf-8?B?NjFhSEJnK3pMT2dNU3hYMzUvMUoza01MTU02MStuZ2JwellVZmgrRFdtVU11?=
 =?utf-8?B?KzFSWVRITFFQV2FMdWU1eGdSNzlxOGtkWXRsd2xaT1pTN3B5T3dJNjk1SlNY?=
 =?utf-8?B?cE9kWjdPdEtWZ3ovN3RVeTlXY0VjME1RZXhXK1Z1em4weHFnc3lwQzFsTGZ4?=
 =?utf-8?B?QTc1S2JsOFRnRUlpam5DaDZUSkpVUURCK0FmeGxSWGJLbTIycWhoejlDRmxK?=
 =?utf-8?B?UndYaEJuSHR4K3Z4aGQvUFliUHdsUWRwSW5CNFNocEZhTFZibkdZQzI1YXpI?=
 =?utf-8?B?STZJNVNKRTJ5dUk2RUEzMkFmYWNoM3lHY1NiZ3BBaGljOGlRa29TZFNCSm8y?=
 =?utf-8?B?M3M5ek9UT1RhYmZjcmVnWEs0a3pHb2xkM05uQ0pXTStQT0NxMzNSNDdDc2ZI?=
 =?utf-8?B?VUswUUV5K3FsNFVybVdnVTg2dENyNkpESnExQ09aL3NtYWtGZkY3Tjd2QVBS?=
 =?utf-8?B?M1NsTyt2V1k5dzdXVi93SzZnQkpzNzNDYnhTRFllR2FBYkdIYWNxR3pHWisv?=
 =?utf-8?B?am5GMGgwcVpoL0NoeWdUN0tBbEtHYitDb0VUNlRQQjVNY0ZQSHpwdFVwU0cw?=
 =?utf-8?B?NStRR3dMbFhyTUd2M2RiQldyT2JnQXl3amtBOGJrTVRNY1lXTjNGYlVneG5P?=
 =?utf-8?B?YXVxcWVRMlFBR1dmLzNTaldUUzhDOFVZdnFCZ2hid28zb05aejlZNEJnNFY0?=
 =?utf-8?Q?BuLeikDHq6z9CluR3H8WTd/aYLqMLvQ0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cdc78c1-dfc4-49db-ce5e-08dac7857680
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4201.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 03:48:47.7095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kx+Rz7oLTCwknVM6owX0K8BqJ6pnJhYnnwXYQj4W3Ul+T/11Jfp0zo7ztzzwyY/zvR8A6GjoHV6vxjvbmNIbJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160026
X-Proofpoint-ORIG-GUID: ZhyodWVKvh-ppqt_H5WJP_VYvIV_qDSn
X-Proofpoint-GUID: ZhyodWVKvh-ppqt_H5WJP_VYvIV_qDSn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/22 15:39, Naoya Horiguchi wrote:
> On Mon, Nov 14, 2022 at 05:30:29PM -0800, Mike Kravetz wrote:
> > On 11/15/22 01:16, HORIGUCHI NAOYA(堀口 直也) wrote:
> > > On Mon, Nov 14, 2022 at 02:53:51PM -0800, Mike Kravetz wrote:
> > > > On 11/15/22 07:39, Naoya Horiguchi wrote:
> > > > > On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > > > > > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > I'd like to request the follow commits to be backported to 5.15.y.
> > > > > > > 
> > > > > > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > > > > > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > > > > > > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > > > > > > 
> > > > > > > These patches fixed a data lost issue by preventing shmem pagecache from
> > > > > > > being removed by memory error.  These were not tagged for stable originally,
> > > > > > > but that's revisited recently.
> > > > > > 
> > > > > > And have you tested that these all apply properly (and in which order?)
> > > > > 
> > > > > Yes, I've checked that these cleanly apply (without any change) on
> > > > > 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
> > > > > then a76054).
> > > > > 
> > > > > > and work correctly?
> > > > > 
> > > > > Yes, I ran related testcases in my test suite, and their status changed
> > > > > FAIL to PASS with these patches.
> > > > 
> > > > Hi Naoya,
> > > > 
> > > > Just curious if you have plans to do backports for earlier releases?
> > > 
> > > I didn't have a clear plan.  I just thought that we should backport to
> > > earlier kernels if someone want and the patches are applicable easily
> > > enough and well-tested.
> > > 
> > > > 
> > > > If not, I can start that effort.  We have seen data loss/corruption because of
> > > > this on a 4.14 based release.   So, I would go at least that far back.
> > > 
> > > Thank you for raising hand, that's really helpful.
> > > 
> > > Maybe dd0f230a0a80 ("[PATCH] hugetlbfs: don't delete error page from
> 
> # I meant 8625147cafaa, sorry if the wrong commit ID confused you.
> 
> I tested with 8625147cafaa too, and it made hugetlb-related testcases
> passed.
<snip>
> We need to slightly modify 8625147cafaa to apply to 5.15.y.  So in summary,
> my updated suggestion for 5.15.y is like below:
> 
> - [1/4] cherry-pick dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> - [2/4] cherry-pick 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> - [3/4] cherry-pick a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> - [4/4] apply the following patch (as a modified version of 8625147cafaa)

Hi Naoya,

Just curious, do you have automated tests for this?  I wanted test backports
to each stable release.  I could manually test, but that would be a bit
involved and was hoping you had something automated.
-- 
Mike Kravetz
