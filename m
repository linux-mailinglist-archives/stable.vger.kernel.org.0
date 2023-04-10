Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E766DC6D3
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 14:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDJMoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 08:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDJMoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 08:44:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85313527E;
        Mon, 10 Apr 2023 05:44:01 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AC7Q8I013747;
        Mon, 10 Apr 2023 12:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=zX49DxcAmY9/T3ke6MiP/PYQflGbDxvqnZImByEFHMU=;
 b=jSIkLJ6ZqO+BintQaR7fkN90oU79LHUt0aWL6Gx2o8/qQODkgcjnlN96qNYEkVay3njB
 /TPGVw9OipNrdFp7lh7ZgGG0+gwt3OcsWsa4GjoSkr+Br6yPV82CySLIa7JglToVhtm9
 M87aE7Fk0jIk+xrNtHSH64aN8DlizBQRb5Ui6zxw7262ileSeIobdQNgtadLxZM95i76
 cULxdsk0jT4HaY8OL5a+g6/sXJ+BC4WqIUov0jKLYpRsM9EVwXXSOtHJ2ygOkKc8olIx
 T8O/iU6Fot8Rk1HAAqIs/QhXGi2Iw125W1Rp6oCHKJnQ1+obxL3o1tFeSQd3yJn3c9WW pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2tq6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 12:43:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33ABPY7O038779;
        Mon, 10 Apr 2023 12:43:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw84vc8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 12:43:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTCKCYj7mWpAKGKfuMDeJA8ME7NIBt/wwaByhvs8la1oSrn27/Vt+GMEBmZR0cPDMTIthFtIC3gJAY2fyt9BCjFwd0CrSugWpuJ5v6EDG1aTiaUFAHGpq3oeZPITIgyJ5HaaS8ZbFhIvPy/FdlfVh2iEFvPpK1wBI5rHmLjzyDF3RPGJ9GPywuWQXdP5KTXn9aiIavyB/EGYXg/zd/dGBjvMu/zjUQkDtiQVCGu/jMB2XjhOUBF5Oig7zrJm7OvvDIlSDBBCEAOjUGgHHVm7u490HkZr4Orq3Ojxi7IcbnoGvz1d8PqttZU26o4ci6vY7wVegQsJMarAcMimCWxY/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zX49DxcAmY9/T3ke6MiP/PYQflGbDxvqnZImByEFHMU=;
 b=DDTjG18URf/KEwJXWrM8NOA7Ab1KfEb3ZDKanKby+M+D7i9biIpXJyTEPdmNRr5h01zvCu9tOARxnVTYXzaG35cYS+pGmNh5C5TE4LfJEHM0t9Puohudsmph6/q0UuIN63WrhVydK4zPIOYZpw97BkPyd23bUQ1/nbzksSbs0OeLgqrT40Y7KLNIv8XolpDZNEkkYg8oCR2C7nfpSV96sy4PK9caw225DYHQCbjJ9B2BSFalzQuBq7X89pZ/n1c5LFJ5zY4V6os1aI+GbRZYAo+nm5mOidGGY3+9PbWmK2jV/ofGRr8vp9jvjbNJhSHSQAHTXjyA6SSdS9yg9mPTLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zX49DxcAmY9/T3ke6MiP/PYQflGbDxvqnZImByEFHMU=;
 b=XKx6v+eYV+YOHN2ZMRUnbVdTgku6pdt5qOu1A7yOW8yPBrkGzUkJG1xzettxyrEVJcRoVWEJeUL1VZCc4tzZ75d5Hp5UlJgz99MuB666oIEEz7K46KbnO1NOnnnVijHtqvIopmGK2zx8MihQ2GTh1cOhWO38Tq/Ezi3BYdyCqIQ=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CH2PR10MB4165.namprd10.prod.outlook.com (2603:10b6:610:a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 12:43:35 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Mon, 10 Apr 2023
 12:43:35 +0000
Date:   Mon, 10 Apr 2023 08:43:31 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Peng Zhang <zhangpeng.00@bytedance.com>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] maple_tree: Fix a potential memory leak, OOB access,
 or other unpredictable bug
Message-ID: <20230410124331.kijufkik2qlxoxjz@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, stable@vger.kernel.org
References: <20230407040718.99064-1-zhangpeng.00@bytedance.com>
 <20230407040718.99064-2-zhangpeng.00@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407040718.99064-2-zhangpeng.00@bytedance.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT4PR01CA0190.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::15) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CH2PR10MB4165:EE_
X-MS-Office365-Filtering-Correlation-Id: e03c0253-48a9-4687-65a8-08db39c13307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QeGiUPG/1WXJuHWbCdGFn9oZr4+JjH3rKsFyHF/RgyWKDiuMOGthfd66O2n2dRnoSK4NDJlTdf4HRJD81111k4WTf4nw8AmrxaP3xdCRTvkAV1WD0OHeQfWDEh5B+ErVynm8SsHCD/pLVi09rG9gGBio1nxtvN7Cn+pejrH4u2+1eG+QLwOz4DywpbrPS+azPTyP6qu+lihuDlwBIF2QTaxlHWorMb4QbFOGjHEmJm86CnlnXzIHwg+5TWUJ+HKGxNkJ5ykBgk3fSVP1bh2Uq3IxytQjvcp4BxKbytwTx0XYo2b/8XA81hRTSBmjF69/Xuj9jM5tJ3fmpRegiOXQ3dY+ZaSqKGZ2Z2aG7xYnWZnaDwsALOuWffEVg6VBY0KMrOEXUE7ac+AauwwyM3ssFB3dUWzbeXkUQydmLxQtdAZswsLgMoJh4csmD2KRyIUb2BU3qUIwIxhLuk7H45tZo+OSy085oWAfWEE+E/R5oYyNDamJaeY7d2dzmzrnTycUw7Q04C0P8+2tpinAl+qOOm03q1Ipo9vc9TISM7vQDkW+xMnZYiQyZSC2KeveqTGw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199021)(66946007)(4326008)(86362001)(26005)(1076003)(316002)(6512007)(6506007)(66476007)(66556008)(6916009)(9686003)(186003)(6666004)(6486002)(33716001)(478600001)(8676002)(8936002)(38100700002)(5660300002)(41300700001)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?02zIzbTVroYP2ujCJRcuQIs5r1FaQ64S7vEVmfHP2SbKzBWTVDA0JDrfHzVD?=
 =?us-ascii?Q?5GTjYftbMRuLrX4a9ukn+yKn79FeGg8jhbozeTULacGfVHiEGFUH4QA6A2od?=
 =?us-ascii?Q?OffceZDonZKm1DIYLlq2nCUm+SnbwBz6fHGap3i2ahTU3YXE+d9e+pix807v?=
 =?us-ascii?Q?8DNiVWXYXtpEbkwJOCt+kW+tgKiGnbrbJZ3YasGIYNmG9pQbi0fm23zDYQvH?=
 =?us-ascii?Q?J8q7JaejpxJa4/r+dzB3EtE3QlVeF+ayzE+CAJF8hJqpFg2wbAIp2SuIMz92?=
 =?us-ascii?Q?FNlixN39a1Gh8M7lHqZPM4K2asKw9gq4wcQhGH4UEkNuviVJFRt0pUs40fSd?=
 =?us-ascii?Q?uPlPZbL17XOYiYYPqynHUIMHKFIv/yG2zlyV5LVO2pcAZKRc7u2bWLiU2TcA?=
 =?us-ascii?Q?cmVEYmpvs0RhrIpsvXIZaG67caafIWqO/d+RF/gFCR2TRc9sqwDSYgEoI46c?=
 =?us-ascii?Q?I97lgdLdCviJrBMZRG/A0ApAyldVhf8bB0KsezLLsieKTGkNahykiAoFmeW1?=
 =?us-ascii?Q?rio9TsqaupHT7XNPTyLUiQrG6/EF+XkEm49W83zZ53g5V14YQfpu8M/8aAHi?=
 =?us-ascii?Q?w0f5AfByZObSYjn2tOypGOYZgxuASq+gS10JTLS2A/7E9Hk16C/X9qon3/YW?=
 =?us-ascii?Q?l+dow7qEaNmW30P6FeowjPu6jwlpbP2tXlXvrUdEVzOCvlJBdfhA/1zDDYUe?=
 =?us-ascii?Q?a8+KEg+G3Z0XYSP0+d7fRGVaKtLC/rYkuVFcRzQUSZ5p1GD9vH9qMphPw0qA?=
 =?us-ascii?Q?oeB1RGF5GLu7JqwVTZOXjAcgvv+IVniRcPebcnDpSZ4hrP5djjPvEVnkzHch?=
 =?us-ascii?Q?hA9BcTYH+ReCox0gpw+0f8BR/P7ZARWmmUmdSSWcPtnMyvSa1QDRT9ihMU/S?=
 =?us-ascii?Q?iJO23WP3k6kIyLbh+UCuOyy9NLH5j9xU4VTXqSVERc77FYQQWoBpRsgNTZUP?=
 =?us-ascii?Q?4vvst58Elyo30EFP+ex7QBk3fhL3YxSpcc4k8a00kp7Tuj9WPtQWCrPnoxfW?=
 =?us-ascii?Q?/2ZwySdOjQtUdnGWYNf+m4v8cRt1Qo/IA38eLLMl00XbeEtOnBRvTf6gOfYU?=
 =?us-ascii?Q?FFyV3EO6X9mmu910e/9nJz3UkszIaMRl63cK+3rRcDvLfvuNnTe+9o2cqbBt?=
 =?us-ascii?Q?LoJ7BvOxPDZGce8iEYRFD5Ywa1kvNatDhsw1CJ7/GyZhxBcE+E/Lb9eeVGc6?=
 =?us-ascii?Q?dItr3LmbmPxXgTqJf+lMZ30rRrVcO+AkXBOl2oKRvvxdcC1KcBAkzvxvMECf?=
 =?us-ascii?Q?hIcCFzfkKGADgeu/nvaEF/ZKJVSOJRyQNhoInc0JDsMbSsG6pJMGBUYN4rI+?=
 =?us-ascii?Q?DKk7h99KbkK3qMzewKh/BxsEHfHC0UfkPolhd2CfwyAQB9zt3xwxkpanbEqm?=
 =?us-ascii?Q?7hCAIj8EUEUSLb3G0FFswZZDvEwVNrQdWCtlF7mzacvkMHozzueGcGYKu4cf?=
 =?us-ascii?Q?yabb8O3UX8fJqxucst1lycDoTh+1P898kxQKfUD6XqTuEG9PYq0fGFNAmo74?=
 =?us-ascii?Q?WgHz5JWGrYlXYwmhZWoJQZh9MO24un6AFjoydOU1iavNVKnnxdV39nphL7Dz?=
 =?us-ascii?Q?TIJDawO3CIiNoaR+1Wi3xkDpmbIbMFg4y9hiDTG1gkNkIevPafkl8YkDojrg?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?cbhzsK0xaad0AA3P3higq97VyVR4/85kRxE6pPRnxdWZk5KZeZAEhTtmiRcy?=
 =?us-ascii?Q?WUrCCDPVerjU8jybN8NPum3oPkJtoLaBI/dNrii4DNCKttoslI2lkywFgB/C?=
 =?us-ascii?Q?+OHvBcpwjI8p8kzhuF5e8o5vm1yPjcP1e73UaqdB2MvGiQtyf0ApCewEi51Y?=
 =?us-ascii?Q?lGLwOY98/TEHO8ywuTwWnkepzHwbzzR34XCOUilI7/Ia3bOqEF95oeBF4wOY?=
 =?us-ascii?Q?9vNOjd8n6IuXF9EBii8Kwrl8zJheU65m6Z1ydbB6LV4Z1aG4aAjgZdRvHkTK?=
 =?us-ascii?Q?McFYcke11K3V2gihsBqXauE+WrKmN31EgprRinf6OUkdydH9fjVuU5pH80BD?=
 =?us-ascii?Q?RWwBJnaL+T8fmymcgf6tWY+X6S52daEl1S1rOmjW2boRlS/Infy2BEiTjQ/K?=
 =?us-ascii?Q?VcMgGGr835VQABG4WsMup2Uw0mCITdtVhX7DmJznJU1EtbQNNNoL6MS1i8ZD?=
 =?us-ascii?Q?H2yaQGlZdjm1bIOWOeA7RrNuCXLO1c+zB8Gk2XOhGseW0g1GLVpJnLGQ6NIU?=
 =?us-ascii?Q?cMi7HnU67mI15ONn5JemNa7qNZXh6jKD9MmKkatpJhOb4ju0HQ+Y2TrY+bFQ?=
 =?us-ascii?Q?LmC/9tPj8W9/SkcRt6pyrB9/MUEkMSMUQFT3JPuFL8XURurPb3o4p0jW3ylJ?=
 =?us-ascii?Q?rCXq4J0rT8zXOgJlwT6jRdCD+YZIMG7sVTWYG4/S6WwAG3Rrg5Worn8MDYFN?=
 =?us-ascii?Q?YKWqIA+IXtfQGJQji72nrVPUWlFci2x9HN2+eOVkuHc4pz80ZUMTCDq/mB4+?=
 =?us-ascii?Q?oz0R+T6NPPh0/iSLuHkJj0VwexKV7eEbrSK67i6JbsB96vpICWiIneMhaWPs?=
 =?us-ascii?Q?/xwV9qhcH9beODQ1z9ufOqHgHVIUB9jyg9NFr4hOkMqq0iAKPIPhA3K4gVoX?=
 =?us-ascii?Q?d+AY4gt2SQzFdTQ1ok0VAsLZ5S7N8FNqwXrZX85K1Tn+pPYvQtjxqE2I5exY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e03c0253-48a9-4687-65a8-08db39c13307
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 12:43:35.1710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHIyaalHqXXj5/4NSouvZFDDMJNmRcWXseOs5bSgoqgSmm/10G5ADKgnr+Lo3zPMoRSVaa+LTXD/VjH2nzqLeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4165
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_08,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304100106
X-Proofpoint-GUID: zs-WJl6qfq4VxfWgLJVIgUppOYY7aBDj
X-Proofpoint-ORIG-GUID: zs-WJl6qfq4VxfWgLJVIgUppOYY7aBDj
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Peng Zhang <zhangpeng.00@bytedance.com> [230407 00:10]:
> In mas_alloc_nodes(), there is such a piece of code:
> while (requested) {
> 	...
> 	node->node_count = 0;
> 	...
> }

You don't need to quote code in your commit message since it is
available in the change log or in the file itself.

> "node->node_count = 0" means to initialize the node_count field of the
> new node, but the node may not be a new node. It may be a node that
> existed before and node_count has a value, setting it to 0 will cause a
> memory leak. At this time, mas->alloc->total will be greater than the
> actual number of nodes in the linked list, which may cause many other
> errors. For example, out-of-bounds access in mas_pop_node(), and
> mas_pop_node() may return addresses that should not be used.
> Fix it by initializing node_count only for new nodes.
> 
> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> Cc: <stable@vger.kernel.org>
> ---
>  lib/maple_tree.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 65fd861b30e1..9e25b3215803 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1249,26 +1249,18 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
>  	node = mas->alloc;
>  	node->request_count = 0;
>  	while (requested) {
> -		max_req = MAPLE_ALLOC_SLOTS;
> -		if (node->node_count) {
> -			unsigned int offset = node->node_count;
> -
> -			slots = (void **)&node->slot[offset];
> -			max_req -= offset;
> -		} else {
> -			slots = (void **)&node->slot;
> -		}
> -
> +		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
> +		slots = (void **)&node->slot[node->node_count];

Thanks, this is much cleaner.

>  		max_req = min(requested, max_req);
>  		count = mt_alloc_bulk(gfp, max_req, slots);
>  		if (!count)
>  			goto nomem_bulk;
>  
> +		if (node->node_count == 0)
> +			node->slot[0]->node_count = 0;
>  		node->node_count += count;
>  		allocated += count;
>  		node = node->slot[0];
> -		node->node_count = 0;
> -		node->request_count = 0;

Why are we not clearing request_count anymore?

>  		requested -= count;
>  	}
>  	mas->alloc->total = allocated;
> -- 
> 2.20.1
> 
