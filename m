Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8313A692886
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjBJUk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbjBJUkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:40:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A947FEE7;
        Fri, 10 Feb 2023 12:40:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0ALJ029682;
        Fri, 10 Feb 2023 20:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=PYDN8SoG5y7Xsuz/xXeD50LzGPZBWZEQK/CZBZ7kdWo=;
 b=2SdBkIORU1sbYK/+mowzZhukglFXrd+OHkSsq5ZnpXkZfKZAfoawvkrjykJxNWicEYxg
 5IcWahwl2rfU+hzWJBTY037mBDi+K/4dvutWIBc6PV24yj9L6cTNGWSqBpqz8QnBauxl
 mYnFHa9jKC2BHACrF4lg6xCSAi/9T5LvTW/q5r9zVS271KUw9SKYVNprfkT6yX3C4rfa
 cT7E4XN9lkyvslXztvh22pqF6cUMvKvepkmbcI1mPNi6FOSE8zMvpI/zdbqEs2rNp7EA
 /BkdF/PpgyoVg4NGeImEKxZRU1FAFaFeQ/gxv84LPcGt66CJudKgpgy56bdF6gh80uUC /g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1eb8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:39:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AIuWHI003019;
        Fri, 10 Feb 2023 20:39:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtb84ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:39:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AO+Te4Zi60MIDUgk2GX4DmrEE8vPC31DChwt3R1gm5kcT8TdGCFKbWs8EBbFSNkLw+roovXqmctTPN/59XffqVmOIqUR7frs8X+efUFsuQ1oGcgBuq9ZrjaewmSL1DbH4naVMGCy23DeIPDqIN/tAUCb/lRkdcrYOswGolltbtEErVmMg5ddBGhb0vfvSjvZP5P5irvboBG5xzbpKEeDygeX3YtpthKOYbXPa36auNrcWeQzgT/nQFe59rhBBOsaTlZiTBtrbjK9yB1lKmElTfGqZWYg3TkZPjqv3GH28pZUq88brz8QAxYSeBpeLyMriaXieS7pUUZbFiHr3XhxJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYDN8SoG5y7Xsuz/xXeD50LzGPZBWZEQK/CZBZ7kdWo=;
 b=R7dRKwIhiUg3GawPXLbtbkBZ4NajXqqG9k0FlRzEsKwglhqz4BVs5grD+OIRfsCL1JKeM1Z42e53sxW9Zgc0cTwxkocolLiV+UZGA/BGsRV1S6z/MPhIiY9IquftauB65m/q4Dr1ph8saJxNTTh/G1ZXAzVpcU/XzWpwM5THM2N8nnk6k7SonF5oP3/HThs4ytoyyu4+HvF9QEPZHnBe5/yKrkl88+HXdh2x0rgZKPGZU9Fp2KvdHlbVdzwJhESCslF/k9x9kEXP/4IOWuJJzZRIFcIhW63bRJN7ixOEnoP9PMrVbfvx+f34XUdvLtbK2OWir7sfzlAOUTgLTTYsTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYDN8SoG5y7Xsuz/xXeD50LzGPZBWZEQK/CZBZ7kdWo=;
 b=zgqFCUkXyCicg5/c2tjHXREJP3oiAONameuHMrleBNz+Ezc1rzw5Dbq7OHt6iC7psL1OWhpaEKVirMfFPExNosxfdQp9xEXiLBFEU3XTLtpT8fHL2rHspjvwgR4hYKBrWN2RSbSKzWApz0nVcryQqghysqqwVNG8kcQ9ypW5PFs=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB7522.namprd10.prod.outlook.com (2603:10b6:8:15e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:39:22 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:39:22 +0000
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
Date:   Fri, 10 Feb 2023 13:39:18 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-6-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:806:a7::22) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: 722bef8e-d1f4-4ba5-3f30-08db0ba6e3e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0C4NLnU9MIljGzhVfQneNGsVzIGukZO2qZsGnonc61qIEYcHXZvEOe+hxcLOHIGmbQ8xnuf7xfDFsmvoANYFcZQBgQNnMmtwY27i20yZKrr7VUUkT7BoiuXB4EBEfdwUhnh+OhhUuRU3NBG79vs4j7dMEAmpgbliHEm4kbOrB6fSh/rlTLG/SAe5SACvryajhy37oshthXePsSOfGVZtpr8Qt+CNNiKsGfc7ejddozO87+bhf0boie8meKiEDRukIrVyg3ZpYmVUkbfGabyy8PfqQ+J9zFhPgBeGsuzSg49eacaxNrA1d3ZZEXLZixH3GagjP4UsdlxuCDg+3PZBpXoR350+pbNVqlPKLUswhmZf/t6nynA3OlfYnqTzyhl3tFtO3qRu+r4xD6UuoSodSUlgsw3mOM+SPnguWM8ZCyOc3DjjSw0e2lMiL6bHisug7v6xOVxGRoJQGOBK7DSa6hlP8KM6YoAEbyEZ5TwKbvofJExAcK/Z/hr9pydEpiNReE2qQGdU/0UNUK7NMA45GKrWWtvM2hZEXrsJJmh3GpzRqFMwWzzVWDCEzmqs3Ew/Jak8wPkjMS1sl04OecAcCBWSdnj5JNi39HCegmIgfA56eJHoYbN/adllBuOTq2thveCgmX+kQjwxA1Z9oz/iXhPqicYuWlzLgeolGlzU7O9snV8iD5bLP9sJTSw8J0VVOrsm7tQ09N/SYz8VwCrszw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199018)(478600001)(66899018)(6486002)(966005)(316002)(6512007)(186003)(5660300002)(8936002)(54906003)(6506007)(44832011)(2616005)(2906002)(7416002)(38100700002)(6666004)(36756003)(4326008)(8676002)(66946007)(66556008)(6916009)(66476007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmNyMElOQmErVEdKcmRMcGw2K2lqL1oybGp1VmxoUjhpaEI2UmhOS3h4MTIz?=
 =?utf-8?B?N1BFcnBsNi9Cbm91UWdkZU5od2NWcS9PRmgwbit1alJ3eDUyd0ZxVkxWSElP?=
 =?utf-8?B?ZFJEMnYwYmtZNlFobjNkSy9JeFpBellJUTcxaWIwTzdVUW9STTF2QThkZGwy?=
 =?utf-8?B?L3A4STVmTmJ2TW9xL3QxTjdybEY3c1lrVHhDL253bkNxaUZUaTU4VGV6R2tY?=
 =?utf-8?B?Ri9GdHRKNVh1MWQxRll4b1o2Q3JESVV5UTgwTzViTGZyM0lkeWxvdzV0SGtT?=
 =?utf-8?B?dldPMWJydTJrdTFzUkgxd1pEdGtnVk5ldithSEJtQnh5WlZKM0dXTGZkempE?=
 =?utf-8?B?cHVYOG9wOS9wOFdwQzBtWm1pUEliR0VXQmp4YVRhUGJzMmJHOXgzWFZEME9P?=
 =?utf-8?B?OEZDcndTTm1kUGZ1NlYxRkFWSDNWMUxsVFlReUQvNHUvcFhNa3h0ZXVSakdY?=
 =?utf-8?B?eDNHUi9FYnFSRXgzRDluNXVzYkZZNTlIeGJTb2ljeDVtUU9wdkRzNHhoMW1y?=
 =?utf-8?B?d3hNcnBhV1RPeUJ4L1lVdEUyU3hBV2dIL2Z1NHlUZTl2Y3h3QU9IT3lsY0hl?=
 =?utf-8?B?WmRxZUNjNXpYWjFQSVhLZlFwb1ZJRUJ6Z0lEd0RBSmtFSTJDQWpnNXprTE4w?=
 =?utf-8?B?TzlEbHNYanN4U0FUekhoVGhGdlVhd29vNldram5Pb1BFQUk3K25oKzRESUpE?=
 =?utf-8?B?WUNxbXZvL0N6NGc3eFcvZDh0R2drTDYxR05nRGQ1anZ5ZStoSmU0N2srWXp5?=
 =?utf-8?B?WWhFbTltQUN5Umtxc1FxYVZCdHYvWjg2OHZEL3lETjBaRnUreWhsOFFCTnUv?=
 =?utf-8?B?VjNnZDhMY0RLcXFBcTRRaUFqY25nRTJBN0pQdUtDWG1nbUNTeDZqT1RGcFVu?=
 =?utf-8?B?bFl0QmdBMmRtSm9zM3pjYXVIK01vell3RmoySU5UUFJVSzFpbGNjY1o1dGtv?=
 =?utf-8?B?cUZDQTV2V2o2MENvakVwTzd3WWxFZHZuN3BYOG5RTVBTZnZ6TVVGdHRJcVBv?=
 =?utf-8?B?SWRpQnBXZjQ3S1ZrOG5DdGp3aHA4Ym92WXAvdGVtVjJSVWo4cjRlQ2JxNjVl?=
 =?utf-8?B?Wis4YzBkeTY1bHNQWjgxcWl3WTRSSzlycDcrRTFMNE5BS3grRjNmQkpuV2hu?=
 =?utf-8?B?MEsvYlZjOG94ZzJLTE5SMTVrTmp5UWVONlVZUjhnKzV6TVZFSld4cnZEZkh1?=
 =?utf-8?B?WkdYQlV3N3NheHdoMVRoOHgyS29ZdTBkN2VGNlVyZ0xnQXEvZ2xlQmZLZHUy?=
 =?utf-8?B?c0RuMmpvMkgrSGJ5UXd6QW1YK3Y1MEZzNWI3UThKaFZBNVNpQXVlczNpOFlM?=
 =?utf-8?B?N0tnYkFzUVZmY3BDYnA2RDY4dFhFYkpFUHp0eXhneTVWWUFnQ2lLQ1N4a3Bj?=
 =?utf-8?B?ZC9qMTVoSkNjYjZhZHkwcUU1TXdnRXFtcVZJKzA1em5ScFBteDNiWi9XZU9t?=
 =?utf-8?B?bmhCdEN0cStoTkhGWUFOc3BVRVliN25ra1psOXRoL0RaYXZpL0FhRFp4azNC?=
 =?utf-8?B?WktORTVTN1hSNnF2ek9Fa3BKNUZnMjg0UEdsWC9PRFAweHNmZWRsRE9yR3Y1?=
 =?utf-8?B?aUpYdlMveUNGUlhQVGJuak5DZzhtTjhDMFZnN3lWMmZqNDJSTGNvdXNPeity?=
 =?utf-8?B?dXozSHBlNG5CbFZMZHFMcytFNnNjRG5wa1FER01YNmhXQkVkd1BlZjc3OFB0?=
 =?utf-8?B?YUorcWNaR0ltRTEyQnZ2U0tkd1VvMmhVQ3hSdGZySk43S21BeWJZMnVBa2p1?=
 =?utf-8?B?SVpqRXpRZ3Z3MTJBemxLVS9VVWVOYkRUbnl1emZ3QnJLYmI0bXVZcHBKK21X?=
 =?utf-8?B?akprVjNrUjN3VXlxY1ZOTGthTlpzWXlTT1NpeE5ZSmYwN29uZ01xSU1TS1lP?=
 =?utf-8?B?NCtlYWRDUDBXSnRQWlhjc0xraHpZRTB1eW0rL2tmRXZrNm5DSVcvd1F5U2RD?=
 =?utf-8?B?ajZKcGNzNllHWjRGUUl3UENSa1lxT2hYZWlyRC82eXY3ZmJvcVIzMlJubytw?=
 =?utf-8?B?aXNXMjY1dHFLcTdGZ1lFaWVmbVEzbzA3b0ZlUU04TG1jdExwdFVlY0lpM3RJ?=
 =?utf-8?B?ZjBwMzBsSFp5VG8zbGIvU2s2d01WYy9NL3g1UlVhVG1SSUxURjlGMENSRWdu?=
 =?utf-8?B?YjNEbG8zZlNhYnk0Wml1TG44eWcyRGQ0RitldWNTVlBxSTF2VUQrVkt0a2xM?=
 =?utf-8?Q?Tfz5u3xZ31feFzU92zhUjcU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dEZzR1J3ME1LWXZBMXRqdXcvRkhkZ3JBS1lKT3RuOGxaTmUzc1RXWGZiU1ZD?=
 =?utf-8?B?ai9QZlhERHIzQ2QwS2dEWXVzOFlwMXhDbE9DdmdRMDdxb2NJaGlCSXZndnBC?=
 =?utf-8?B?TzN1N2s4dW5DVjlzcmJrRGdnenBURmc4emxLU1BKNmlYR1lVenF1eUxRMC9t?=
 =?utf-8?B?ZklidzFSdkZZb0xNSStWb2J3Z1J3Nks3R3BkQ3ZvS0ZzMzFVME5sZHBzdUNm?=
 =?utf-8?B?ZGtGS2VRMm5iSVhpTkg2aWVzbFZzUjAwQTFCNDltLzIzSC94dFA5VG8zaHZN?=
 =?utf-8?B?V1E0OStDWDhJYjVFeVNpdGJ3WDVmRERxSy9zeTFteUsyYU05U1dVVFhqMHlK?=
 =?utf-8?B?SzZKNHd4K2lqNndyR1VNdW56bHo3L1MzSkdzZVdSSmpDYktsOUN6L2NnNHZM?=
 =?utf-8?B?emRiRXM0Q2FYS2xuZ2I3aEtIUGF1SlUyVGZUMEdQMDMwVklqTnVMdkJPMHNx?=
 =?utf-8?B?SUt6bEQ1bHUyb2J5bzNuWXgrVXZhS2lRbVV3Y2RBOGxtckRwQVpaWVhHV2lt?=
 =?utf-8?B?VWV4ZzhMeTU2QTJ2dENOM2l6eTRCbjJmd1FLeDdDUktIemV4dXZhc1FWNGpU?=
 =?utf-8?B?OVNoVEptUGFyK0haOTVOWFBXZnBVSnBPMENpOHQyVkdWZjRTTldDUHpDVE9S?=
 =?utf-8?B?SngzZjhqRUVHM2s2dzZhYSsxVlE5clRnZC9nZHI0V2V2TnBwUHU1Vk1IbTg1?=
 =?utf-8?B?dDY2NW5Lb0tGTjZRN04ybVZ5RStwL3R1VEdqWFBrY2NVZW00a0JkRzZiRDJC?=
 =?utf-8?B?Q3MyRjlOb2REVnlGdWZiOElZUVFYbHpvVGJBSUsvMTM4WFF4T0dBRFR1VVVq?=
 =?utf-8?B?dXF4OGtyRHphSHV0L3JUOHMyYTZKTGRqREtnZWlNbmVNRVdpRThNd2pHU3kz?=
 =?utf-8?B?OCtRUGlUeXNPaHZqYm11elhYeUxFYmdTQkRZUXlGU3FoWDA1aXM4NC9zR1pq?=
 =?utf-8?B?ZzhjNGVjTjdEQUY1bFJJa2RZYjRVdC9rUW9wMy9nSFl6TjlBeStpT1R2WlZP?=
 =?utf-8?B?Ym8zOWxWVWttWFVLTXRkZnVneFc1L1ozSW5LbFpnbWt3TzIvTVNoWXEwa0pm?=
 =?utf-8?B?aHlNY2JwNzY5T0Rkd0QyS1g5RHZ1K0pEVUk5bXZybFYybTNzR2JOdm9LZzc2?=
 =?utf-8?B?azNsM1BPcVQ5Q2c5TnJwVFowZHBvV3Y5ZldhNGhXelVGYzJSUnFiajN1Rm5h?=
 =?utf-8?B?L0ZldER4Sk5xTWNiTnBscENOd2hZSmMxSUdtVVRwazFrOHJRNEZYN3dJTHN0?=
 =?utf-8?B?aUtZYjF1c0Y5TUhIa0dhVHdwWnVVUm85UVQ1bVhhZlBIZkZIZUxMVFhoaGlV?=
 =?utf-8?B?WXZVTHFNV1ZmdzlqOGFyaDRXMUlqVHMwY0FUNzZNY2FSM0k2cXZmZW9MaStl?=
 =?utf-8?B?cHQrYmFTZ0RHS25hdDRiSWk5UHFDemd2ZEVDeERHcy9kU2E3TXdSQVNlSGZP?=
 =?utf-8?B?Y3A5MEplelphdEx3cGdkK2MzOFdyVzdUUGNUa0g5SFdiTmdOK01qcVpqeERO?=
 =?utf-8?B?RDlmUW9FTC9BMnJwQVZWQkVwaW1ROXF0T1U5RWowSDVjK3ZENXRHRU1iVFQ4?=
 =?utf-8?B?QmtxUk9scVRnRVB0djJhUG5rQitzTExJZDdGOVZmRTNaUWhoT3d3U1BsajV3?=
 =?utf-8?B?Nk1oUUt4YTFuSjFYZ05FbjVMTVl6Z1BZaXEwQVU2VDdaUmlvejZoRm5MYWky?=
 =?utf-8?Q?oQxQRpg+4X9/vHmGxHjm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722bef8e-d1f4-4ba5-3f30-08db0ba6e3e2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:39:22.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jvt1LgC0Uy3WedmmaU8i10sRnuHjvFe6GlqeBLi0uc4CVwmWcU0ToT6p23GbV4mJAWwl3YJzAMETveCYpdN2ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100176
X-Proofpoint-GUID: CkaNXL_ui_jJ16jn_qyaIML9DyqnvU-8
X-Proofpoint-ORIG-GUID: CkaNXL_ui_jJ16jn_qyaIML9DyqnvU-8
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

