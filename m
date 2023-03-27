Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C46E6CAE26
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbjC0TGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjC0TGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 15:06:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17DC2726;
        Mon, 27 Mar 2023 12:06:02 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RJ5DFv014406;
        Mon, 27 Mar 2023 19:05:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=/OszR0X0+D42Q1KsqAQ09ze3IJdvo5mrHANuqJ/81t4=;
 b=rFpGs0cfXd+GcGj82Q3ce5uSmHyOW6p6fXeaVc0DOrTsjYFxEIQK8SsgXxSVCePbD1hT
 tGmlPuN1vIMyL9R6GOnhQ/twneZeLRdKREQ8DQ+w+Kqrn7pEE3Q79ql2rNMmCgS1P9Ex
 o2Z7zUTr5/4Kka5Zh3D3g/KA3F8maP/42yfs/dgOdmUqx7k0kuytbD7x8L7W1n3IUFh5
 93RTjvGEBTJTC1O/78T4dSrh9n9woU+c2XyWvTznFMILCmnmyiXOrfp8HwUJ9mw4xgfN
 fPhmiB7iaVi/m4DuAcu07IUzOXtEqU4wtErdFeXSDG6lXqcudM9E03k6nB8HmD4KD96X KQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkgysg02k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:05:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RI4H95027415;
        Mon, 27 Mar 2023 19:05:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdbwc9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:05:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6P24EI8c92ilLeiRil8Y04zKeDXwbdVsp6tjd4FXMDHtP4SIIPr+XspwE1iYji6GFNKHM6/4CPoDs8jPhflEmPQgPO0NQ+oXxoZbKUOVed00WAu+6MAzNIFZCUOxBkA8leIqxVg3xWad4qmfX7Kchr0JGvZnWdBVzvTn5nDTrzskoa+PabH8mN1QIHvFBbRD1qkkcnqdwj6OIUbX7rgt5u0PRG8ioNlubG4Y42BkiCIKL8stfgDR2j7m5EZg2WCh4xg/ubhv6P8LStHsAVckXjcjpgDS1hjEcaZyA5drQO5T0w4tDtxMEeGSC+a+lPwYG1ClphYFfhrR+4i+/YN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/OszR0X0+D42Q1KsqAQ09ze3IJdvo5mrHANuqJ/81t4=;
 b=Ho8wQ4uk/RIVMuAER+kDf/31WzLhZ0SwLWAZ9Xd6G8/j56sN1uOYu/EPRg/1143BekxrnGdJ6u+w8O/NLMO+QNbMGl5GZvVgKG+iXtPuawGAANTaEDb33aF7PNhVkEiNP/JFtg+WwXLHYxUVTS7Wq+k75TwIdgFhne1abLlBj+gs+z6V6EWfNCU3Pdn1iojtaoTLF30wTWYlK8ljtpuEh2UulJbtpACpG5fD7GvzyW4KTc8PYxhHGA9XJuF938MAGDEQLa9Ydc0qNpgin5Qc8D9GmzOdYStX5p+grso0PwDj2cPfmYA/6FxSYDHAVQQFCqgxpfggW7Jn9BH3GW4Igw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OszR0X0+D42Q1KsqAQ09ze3IJdvo5mrHANuqJ/81t4=;
 b=GQ2pkFUhAfgGed0AdLrIAcBhKx2L37IHqEibrneaXe2hzQ1eaFZTUvah57zpe67ev14ocL4ieUOtpUN1sfNhIl+pzM1oQYdkjX+GSHK6yFuFAKP0eB0fDOFG3ugoQhAy9Jz0XoKPg22YmczYL29yO7KeTyHgDO+0IDwMll+Cf/8=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB6554.namprd10.prod.outlook.com (2603:10b6:510:205::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Mon, 27 Mar
 2023 19:05:44 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 19:05:43 +0000
Date:   Mon, 27 Mar 2023 15:05:40 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5/8] maple_tree: fix write memory barrier of nodes once
 dead for RCU mode
Message-ID: <20230327190540.73lyataw7am5pvou@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
 <20230327185532.2354250-6-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230327185532.2354250-6-Liam.Howlett@oracle.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT4PR01CA0373.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::15) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB6554:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ada7e20-03d2-407f-6dce-08db2ef643b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpjc9VwNohfdth4ifGiAAHJDSp1vnj1hUjWwe6goB7YpYJjomF2qj80MoPHjnPeoBlNJhJzyjjQzX5rnqC1q/T8Fzdk62K2KZIFABGv3lmhDYsfEhDHqnsriSg6VzrWdcJkgSUlxmsOyL832w92mSb3Kr+axBjAT3zFGCKj7AVvsVW1+0WL/SeWR/WfSeJsYDKcBDQcb0Gf7FnICEHm72rvyWvnYU2WSavf4fAgjeHYgL76/PN7UvvVbdq9A5pZcNAxH30uBooh2PLacMokZl+0CfIACdL6ZyErO5PJpA4xRYcxKMQ+wIYRhMjD8yVZrwT9Fwml01gPIFIeaUYvL53DIo/ompI774Zo7HfWBamFi8abI15g2D/o16Xijy8jouA33wWMVOHCvSz3R/6ue8axc+xy1bcJv6/re2FSaSTQJjBhWtetSbO2+FFsRQuD69yhzawuLbYlEzz1m0zHuWM0g8rhJsmlzLwBgNGE4ypWE8TdcgP4hhAxt/syoYaXPrCaL1bZajJCg5CabgbCFmvlDITEZ1hXDAKIXFP4N5B8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(966005)(110136005)(316002)(478600001)(9686003)(26005)(1076003)(6506007)(6512007)(53546011)(6486002)(8676002)(66946007)(4326008)(66556008)(66476007)(41300700001)(8936002)(186003)(5660300002)(2906002)(83380400001)(33716001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XaCAroi5k1QkmznwMLlRovzro0FlZ9u7LyNEqvkTUNaYCo2EnX2yH6qCl7xl?=
 =?us-ascii?Q?8YapxYz3uoiU7NaFRKDYS8S1fwLh2A3oanwtMEvJfrXUcp5O4tuyQ6MbRg1S?=
 =?us-ascii?Q?oA9z74v01qvfURJO0IsWmxNWSOWzX65aM4D2W7EQlRRKQNMjiJ3/tthmgxXH?=
 =?us-ascii?Q?wvF5WPl2k/qDl9RWErfqYIXaDVviJ700bBS5irk1Cl/IionpoVfMluQiMAhd?=
 =?us-ascii?Q?q+qoV0aMtqEtzV2whVXjkwBX0oKFqJCSTcf+KpOzg50lNAmPe2BlpMGIvgpM?=
 =?us-ascii?Q?25cwBu4CInMudyOQWzQIV9pr/G/KpDN/vn+yfjHLY+OGGyQ2EGl117Q2mCzZ?=
 =?us-ascii?Q?fgPNi8l9wz0OhSntVi9subKOxg0kIZ1oydxx8AKU10Ch1UrGDbqJpNQtdExx?=
 =?us-ascii?Q?yFEaopWZOCmZZPlb8vRoPonz2SfwApAVZoAZbHaasXABofc0foQThQkWotLc?=
 =?us-ascii?Q?38VMtSYOeFufzlf0SUlLkuChZZggPUsScABiQSuyo1TmwNjl1FvMXrP/wp5Y?=
 =?us-ascii?Q?1dDj2z1TH/KbN21err5t3fIOpCH9fNqhatBZQ6MO1W66CS7hVOOc6Z8sPnfW?=
 =?us-ascii?Q?FxRUa6b8EnEW9QM308s1pN1W2LYO3KrBRxBQg5TbHXyvdtOZoNStCFK0mClT?=
 =?us-ascii?Q?A588f4/DK1sN9B5Y9A3bLSzTrbZOuW6mgXGfsFP+Nyj7uxbhZgbU1aOqqvAU?=
 =?us-ascii?Q?YPp/BKbnYCu7ZQKiho7ObgEoO1nbItkz8g56sl5f/1HWwiH+P120ni1GQeBo?=
 =?us-ascii?Q?9IFnQNchjyDAu9dL5lZ20OfYkTE+iwmKcKUaQlUhRitcRxWdEKpl2XYh73Td?=
 =?us-ascii?Q?UnbmSYPoYP12B6SdmccGKvc4yeAo1v02qBB1QB/bTdFhyTSwqeRc54GLR8oY?=
 =?us-ascii?Q?1tIxoQuO7iSGAzNEMgEm7jLj0Q0ZbKPzT3EKDodrntU3jsqDs1BJIt3Uj/Qb?=
 =?us-ascii?Q?SmRZcZMk/bfT1891rDWddCOSVbujPN9gmKiExwkgSmHADdEogsCVlNRS15wL?=
 =?us-ascii?Q?c4S5yFqYdBvrkQ8prSbfYVjSi9VSb8Y7xlcx2fZm3N8h2bqfnjC+z+ywgTsA?=
 =?us-ascii?Q?j5hy4zM3BTj4efoM2p0q+/QWmI4ecWWPcomFxKs5rQ7rcxVSAAokLe79B26E?=
 =?us-ascii?Q?yYNUMk+/u7iC3843wybjTVppS+yY99dy86RMpuLVRJkoT/rlfrboyFwpdiDU?=
 =?us-ascii?Q?QMKoxvcmZvQdg5bxbS7j9qWnybcWjadc822qJ6mcPvqHNnqriipYSzO2Zr4w?=
 =?us-ascii?Q?EMmWYYm8tY/ojj1ipIqIHW+R7FNgPfpaBlCMUYZwQxWc7aRYdyTiWxzkWPq5?=
 =?us-ascii?Q?8EPw4GeR5x/7EuIAHshKZb2dd5wr++MTmX+pzTjML4U8aWXCpgOr4xM+rpBC?=
 =?us-ascii?Q?L3Uwhpoi4N1jynmQR9xSdHFYSaDz3OJ3QwqNntCIuF3ICnpznbxz+vy1uV8Q?=
 =?us-ascii?Q?HFbSyNvFTBDYaY5gsg0gadcGb41q8m0EbJq2edihQUzOV7l4ngVTVnIyzRWI?=
 =?us-ascii?Q?A6+KXMY9yTTa57HV5W5u1T3kwZ8uXOW9dLZQwWOrHipvwe3zItqbZLCYxXe0?=
 =?us-ascii?Q?auPUsqcN+6g8/WXFATHt7CNC4V/iTw3bD/Y5TwQOACikxOUPUxfofSgtswet?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?pa9S5IYq0kOC9tC0p1X2lzAS7zXEgEkWx/SXKK/aDuhYpZ+kOtOogiulQO5d?=
 =?us-ascii?Q?fLODq5AggAekelSeAw9uJJyTwSRL7Bp2TPzD0D01hvkzWpBSsKCPdsMe5Eqw?=
 =?us-ascii?Q?bt2LLAuOrf7G6IW/RuiebsqifT4RJPwtXEymxC6N3hhjYjQwOYCcX/JHoQ3Q?=
 =?us-ascii?Q?TNgu8s3glrgYBhtnYA2g2eLzHk44UgRhDuL1Vq213hoBZSUGI+S5BGSzQwiR?=
 =?us-ascii?Q?bITrDxw0bNi3GAA7t41bw3f91HWnoh/Sk1nDJIeeVjuVeKEf828YzXEzTA5m?=
 =?us-ascii?Q?p+6jr1GuqoFgwSWQzcduL2l9pWuuW59cE/TX9VRguk7LbeySZES8Ec9knt/M?=
 =?us-ascii?Q?5MWjwLfpbWw0MVNr/2N/dpxhlsJCeEQ0Z8YxEmFK6y9JSCXKsjyVH4OhN3eO?=
 =?us-ascii?Q?0HDLqdY+YQSOEDVobAuGz+PtrsjmSeqRuQ8g0Ei8T11TKegGI1oICmpaBzF3?=
 =?us-ascii?Q?tK9FtCWQHaRXZBMh2D0/9QiEDylY8xtDS2brMZbGYcoSimVRGj28Cwv7lFKr?=
 =?us-ascii?Q?c71TpT+ZiPk1qtTHYRm1Lv2S/hwEa6gg8rKVnuvay46AQ58m4+9dfKFIFoGc?=
 =?us-ascii?Q?rItsTqhBuhNJNXlruPpXQqjuP81KJ2cNS1r1hTVqHKsCo6+ACOYPlqnX8C7i?=
 =?us-ascii?Q?tADAwFBPPNWFGjGYWzYLZ0BmubFf270/wG1BsmpbGyASiijEekWYBd/exhVx?=
 =?us-ascii?Q?BD9WFsrzLAtPWX4hA9zk9ME1UTs4ougZRK9CfW4IjOH7luclmWtOZOWBeicd?=
 =?us-ascii?Q?//7FgLE14ASo5ZJ4oJIDyDu/cWcy5HjdpnpK3FEQHbkvPddquKb02WlejnN7?=
 =?us-ascii?Q?0IuH642AIiUrYV75uFpJz42ZgTKj9XruKJMknMBcsUld3dwAZ+UZWlTACxqB?=
 =?us-ascii?Q?VBKT7KkHh7EDtYdWli5crUjrRBNvaOySnPBvpO+NHJV2eViL5+i0D3lr9wG+?=
 =?us-ascii?Q?q3xk7S4nZJTOMYOH/39e5Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ada7e20-03d2-407f-6dce-08db2ef643b7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 19:05:43.7334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: or7eEOCNe9bo+GvdkWWrjZt9vYHy+hRewDUhwupzO4R1cUibSPk41JZRSX62pkpeP2qGryzvz6CxNCbM/SU9wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270156
X-Proofpoint-ORIG-GUID: puerNw279ugmuYM2q-Huf6NzzGQfLnzf
X-Proofpoint-GUID: puerNw279ugmuYM2q-Huf6NzzGQfLnzf
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


I forgot to drop the S-O-B and add cc stable to this one.

Please use this version.

Thanks,
Liam

From 19dcf05adcdd983af6c9618bdd9a49a2c40260f1 Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Date: Mon, 27 Feb 2023 09:36:04 -0800
Subject: [PATCH v2 5/8] maple_tree: fix write memory barrier of nodes once
 dead for RCU mode

During the development of the maple tree, the strategy of freeing multiple
nodes changed and, in the process, the pivots were reused to store
pointers to dead nodes.  To ensure the readers see accurate pivots, the
writers need to mark the nodes as dead and call smp_wmb() to ensure any
readers can identify the node as dead before using the pivot values.

There were two places where the old method of marking the node as dead
without smp_wmb() were being used, which resulted in RCU readers seeing
the wrong pivot value before seeing the node was dead.  Fix this race
condition by using mte_set_node_dead() which has the smp_wmb() call to
ensure the race is closed.

Add a WARN_ON() to the ma_free_rcu() call to ensure all nodes being freed
are marked as dead to ensure there are no other call paths besides the two
updated paths.

This is necessary for the RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-6-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c                 |  7 +++++--
 tools/testing/radix-tree/maple.c | 16 ++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 3d5ab02f981a..6b6eddadd9d2 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -185,7 +185,7 @@ static void mt_free_rcu(struct rcu_head *head)
  */
 static void ma_free_rcu(struct maple_node *node)
 {
-	node->parent =3D ma_parent_ptr(node);
+	WARN_ON(node->parent !=3D ma_parent_ptr(node));
 	call_rcu(&node->rcu, mt_free_rcu);
 }
=20
@@ -1778,8 +1778,10 @@ static inline void mas_replace(struct ma_state *mas,=
 bool advanced)
 		rcu_assign_pointer(slots[offset], mas->node);
 	}
=20
-	if (!advanced)
+	if (!advanced) {
+		mte_set_node_dead(old_enode);
 		mas_free(mas, old_enode);
+	}
 }
=20
 /*
@@ -4218,6 +4220,7 @@ static inline bool mas_wr_node_store(struct ma_wr_sta=
te *wr_mas)
 done:
 	mas_leaf_set_meta(mas, newnode, dst_pivots, maple_leaf_64, new_end);
 	if (in_rcu) {
+		mte_set_node_dead(mas->node);
 		mas->node =3D mt_mk_node(newnode, wr_mas->type);
 		mas_replace(mas, false);
 	} else {
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/ma=
ple.c
index 958ee9bdb316..4c89ff333f6f 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -108,6 +108,7 @@ static noinline void check_new_node(struct maple_tree *=
mt)
 	MT_BUG_ON(mt, mn->slot[1] !=3D NULL);
 	MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
=20
+	mn->parent =3D ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 	mas.node =3D MAS_START;
 	mas_nomem(&mas, GFP_KERNEL);
@@ -160,6 +161,7 @@ static noinline void check_new_node(struct maple_tree *=
mt)
 		MT_BUG_ON(mt, mas_allocated(&mas) !=3D i);
 		MT_BUG_ON(mt, !mn);
 		MT_BUG_ON(mt, not_empty(mn));
+		mn->parent =3D ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 	}
=20
@@ -192,6 +194,7 @@ static noinline void check_new_node(struct maple_tree *=
mt)
 		MT_BUG_ON(mt, not_empty(mn));
 		MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - 1);
 		MT_BUG_ON(mt, !mn);
+		mn->parent =3D ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 	}
=20
@@ -210,6 +213,7 @@ static noinline void check_new_node(struct maple_tree *=
mt)
 			mn =3D mas_pop_node(&mas);
 			MT_BUG_ON(mt, not_empty(mn));
 			MT_BUG_ON(mt, mas_allocated(&mas) !=3D j - 1);
+			mn->parent =3D ma_parent_ptr(mn);
 			ma_free_rcu(mn);
 		}
 		MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
@@ -233,6 +237,7 @@ static noinline void check_new_node(struct maple_tree *=
mt)
 			MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - j);
 			mn =3D mas_pop_node(&mas);
 			MT_BUG_ON(mt, not_empty(mn));
+			mn->parent =3D ma_parent_ptr(mn);
 			ma_free_rcu(mn);
 			MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - j - 1);
 		}
@@ -269,6 +274,7 @@ static noinline void check_new_node(struct maple_tree *=
mt)
 			mn =3D mas_pop_node(&mas); /* get the next node. */
 			MT_BUG_ON(mt, mn =3D=3D NULL);
 			MT_BUG_ON(mt, not_empty(mn));
+			mn->parent =3D ma_parent_ptr(mn);
 			ma_free_rcu(mn);
 		}
 		MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
@@ -294,6 +300,7 @@ static noinline void check_new_node(struct maple_tree *=
mt)
 			mn =3D mas_pop_node(&mas2); /* get the next node. */
 			MT_BUG_ON(mt, mn =3D=3D NULL);
 			MT_BUG_ON(mt, not_empty(mn));
+			mn->parent =3D ma_parent_ptr(mn);
 			ma_free_rcu(mn);
 		}
 		MT_BUG_ON(mt, mas_allocated(&mas2) !=3D 0);
@@ -334,10 +341,12 @@ static noinline void check_new_node(struct maple_tree=
 *mt)
 	MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS + 2);
 	mn =3D mas_pop_node(&mas);
 	MT_BUG_ON(mt, not_empty(mn));
+	mn->parent =3D ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 	for (i =3D 1; i <=3D MAPLE_ALLOC_SLOTS + 1; i++) {
 		mn =3D mas_pop_node(&mas);
 		MT_BUG_ON(mt, not_empty(mn));
+		mn->parent =3D ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 	}
 	MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
@@ -375,6 +384,7 @@ static noinline void check_new_node(struct maple_tree *=
mt)
 		mas_node_count(&mas, i); /* Request */
 		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
 		mn =3D mas_pop_node(&mas); /* get the next node. */
+		mn->parent =3D ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 		mas_destroy(&mas);
=20
@@ -382,10 +392,13 @@ static noinline void check_new_node(struct maple_tree=
 *mt)
 		mas_node_count(&mas, i); /* Request */
 		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
 		mn =3D mas_pop_node(&mas); /* get the next node. */
+		mn->parent =3D ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 		mn =3D mas_pop_node(&mas); /* get the next node. */
+		mn->parent =3D ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 		mn =3D mas_pop_node(&mas); /* get the next node. */
+		mn->parent =3D ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 		mas_destroy(&mas);
 	}
@@ -35369,6 +35382,7 @@ static noinline void check_prealloc(struct maple_tr=
ee *mt)
 	MT_BUG_ON(mt, allocated !=3D 1 + height * 3);
 	mn =3D mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) !=3D allocated - 1);
+	mn->parent =3D ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) !=3D 0);
 	mas_destroy(&mas);
@@ -35386,6 +35400,7 @@ static noinline void check_prealloc(struct maple_tr=
ee *mt)
 	mas_destroy(&mas);
 	allocated =3D mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated !=3D 0);
+	mn->parent =3D ma_parent_ptr(mn);
 	ma_free_rcu(mn);
=20
 	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) !=3D 0);
@@ -35756,6 +35771,7 @@ void farmer_tests(void)
 	tree.ma_root =3D mt_mk_node(node, maple_leaf_64);
 	mt_dump(&tree);
=20
+	node->parent =3D ma_parent_ptr(node);
 	ma_free_rcu(node);
=20
 	/* Check things that will make lockdep angry */
--=20
2.39.2

