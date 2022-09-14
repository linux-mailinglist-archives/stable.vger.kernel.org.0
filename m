Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC165B9008
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 23:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiINVTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 17:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiINVTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 17:19:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F75B64CF;
        Wed, 14 Sep 2022 14:19:40 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28EKcf8I022584;
        Wed, 14 Sep 2022 21:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=f9ZkdUGvmtNuyvqb+6wQdWMVrk2ppq8cin8OK8lPci8=;
 b=3EK5KtaX6Imi0QfLJv55i0ZD+TeDWXrcTGG4l1RD55944y5QU5N3EdVfRqd+Oua3DygS
 gyfbC8mnENvRzTpwYW6n9rl75vz0YPdjHS5BvU0a5GH5CiItdWjiuM5O5DN0hHwiEVdE
 gFNBaxGEv06pl4FRrfj92xy/EYrcfxW/jdP5Pb1YUhimqKBnS56SButAR21xxmynZNXx
 dIXQAtJcv953mQS4Qs8Hrb5THt6t6oCZsJXKw+S3r39szNqoFUEq94FZ8RNcrAIVXhnP
 TppOIJDFoKV3pAvJA0TH1dE6SPv9Lr8XJkSwujsD+Vc0iZ/VHAn8nsPu3/0t5W1pJAUZ Wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jjxycbjjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Sep 2022 21:19:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28EJ4UnM009756;
        Wed, 14 Sep 2022 21:19:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jjyed89ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Sep 2022 21:19:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WD4wAj7ecUERugAZncBUjDKmr1x0vE+hJsEu3aeeRSAYoNYMcLkK5X1q6wxfXM5O4tzo9f89lzypoeSZnUCcoePqJFMMHyKWugIj9EfkwdD0wQnUKWFLGoZ4c8HVXCwVewrctNgeL81bFcK2QiFO1hGzdarGVmOiFOWMyz8GNSf1xDdGd64HpmUaS3Df9yKk3gWCUmfCmtArhpyaiKIn6xDJHqGF9qsXW3qXs/5OBdkHXvn9HYT00XM/NFSwc7mH+gSygXeNCrcgnMxc37EOqqb556FsI4xswuzvoia4Wx70T3Da+PMN9TvjQVi21ppz1jQVGSP7Yv4rd01tMVfVzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9ZkdUGvmtNuyvqb+6wQdWMVrk2ppq8cin8OK8lPci8=;
 b=Wff3AAqq01xOKsC+0N9YuJgISKXpFhrXjysLTVWc3mq+C89/jtnStWPubEjrgTGeGei/lj4SZu/S6uYt0b9Zs4IIyRJeEWtpC+A+e6b00yqz88NQQUtWVksOL+xNkdhBW9O/2XVSkP54LOi1KPE1rqJw5PP3qTmzVrDjVK2LoWK5IT9NnB/mjSSNaksASkaN2h0Dw77PfJ6DrY2VU7ug6qGb6voAFZMUpgWkYQGLXsMUX3SQNO3kJ2ljDtehUAtkqcsdZiha3EMUn8fBMnBgwoJ8/g4kSdz3pA3WSMHyL0NhE0oYo+B272MG8lk5HAYNXQ96/QIxNTyQ1inqwnDRGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9ZkdUGvmtNuyvqb+6wQdWMVrk2ppq8cin8OK8lPci8=;
 b=weNc+DMtvrtXiV5LH69nJlZ0YbMgAjqj3HyKCbcLG0MIN+yoAz1Yi1c6hr1rSlJpn2FSCkUeHOnkM9xcMutbI3rW6Fl1nOQNxkPew53dNqUj4becD3pweErgRwQIF/k6aS3ECMwoQoKTwbN9xT1ve/jjrkWmh73GT9+aECLi3/0=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CY8PR10MB6731.namprd10.prod.outlook.com (2603:10b6:930:96::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 21:19:01 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e9d2:a804:e53a:779a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e9d2:a804:e53a:779a%6]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 21:19:01 +0000
Date:   Wed, 14 Sep 2022 14:18:57 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Doug Berger <opendmb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: correct demote page offset logic
Message-ID: <YyJFQaZtZr08fMhj@monkey>
References: <20220914190917.3517663-1-opendmb@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914190917.3517663-1-opendmb@gmail.com>
X-ClientProxiedBy: MW4PR03CA0162.namprd03.prod.outlook.com
 (2603:10b6:303:8d::17) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CY8PR10MB6731:EE_
X-MS-Office365-Filtering-Correlation-Id: 66e05612-3885-4ca1-a0a6-08da9696be57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkygHdShbadkclZXaX4rINX9Zc3B3UD96/jr6SST1Mvd2CtoYi0lWYTqwES8FlN5oRE14BGuvzGXyVM11MPpRzY6DR5lpAkhZ5kH5S6cd+CDlPvhBe22Xp0C7sEyzeGQ1eOPgHE5maAtJo4C4btkfgV2ZVGBAqk8HwLCSqWvJtF5MBucRaTmpsNaaxp0Rr8CBV0aqnBtxJd6+e4MnGctlPjmctT/ZIVIGVly7gQyWqINfjDYu6PqZGG/KkEVMSBkv/O4Faz3vimhx0VeFX+9WBo5bMoQK1Kdow/wbdWjgDy6S90PSRMmwMAaW/gMCCqrW2JmUegAeNZTTWLLaRarcXPZK5xiZMad6RPzEBdbhOo0r/kKH+E/aoBKTSsQHBtklz8ACfCKl4zzLGc0l6ULk8hkCXnQCqDYwNAVeiADn50pZfII36Y3QZ6ItPsofczPEvU7vWBGTuy5YpQzRtdQAAEDMIINhqrVQmenMDkNPjH66wm+ebEehPVN+eca5N/7Flq6rj0r1UrXvNuZsnG3YR+Evmco6RwlycaAGBGPlIeSQOWPSuDXgFEg/DPy7+IsJaBbSbq/cU3ap/dKkTsebFXKHVyNR305Z5Lkf5fUQn10FLIl9x3n4QR5PEi+7kQvgEARMmhHmMF1hfE5FWtx+O2TBxU9gU83kmC0n4oNd9FrvkQVC9/6OAes5T0N7p7uKmb+IzEUfFMjPiccGSfthA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199015)(8936002)(6486002)(26005)(6666004)(54906003)(6506007)(38100700002)(53546011)(9686003)(6512007)(2906002)(83380400001)(110136005)(41300700001)(44832011)(478600001)(8676002)(66476007)(33716001)(66946007)(186003)(4744005)(316002)(66556008)(86362001)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x3KnXRJ81r3FJIF0InanYxORrgCIAAn46N0LphT0AeAAoCz44ZWGn9A5ochx?=
 =?us-ascii?Q?iSIfRHhXP8jAs6CXO3w3/BG1jUJ2sexmT0q4X3NmWiN3XyMF8yHLMySA4suS?=
 =?us-ascii?Q?hleD7I5hQl7cOWKsd9S6vIwrl4gUVSPqeY6AiDCR41PXTqdhaIhVL+HhZknA?=
 =?us-ascii?Q?yhKbnRnzzURInHksekBp2qookbY/wJprBFnqil/lfDmr9ODdD06NXN/lkHtL?=
 =?us-ascii?Q?7hx3ExxjHfKHFFmjZ2v3c1oHhjTPE3OmtG/otE2Ha6Ko+b95a3ChgttD6fh/?=
 =?us-ascii?Q?I42KXTGVDz7xlYvn8tOha1ZP8BpwTW4wzwy3xEzaY+T8/rZRzpRbeS9m/5MB?=
 =?us-ascii?Q?9wnk70gxH7NekTAS4yRidgn7pbSf3IvS77frPR8AebnK3mz6YSJFLmSJ7Tqm?=
 =?us-ascii?Q?PuYbhyPgsOtZ5f7x4TNPCmdh0doBCGFAi+H7L6t8qQwqayLY7c3PBZr8rI5g?=
 =?us-ascii?Q?D4+wlotTgLjjTLThOx+sZRyo4/NP/BItaYwq9uGKou1rXt03Ptkn0jWoLIgJ?=
 =?us-ascii?Q?xGx0MuK6OWhtEZn5oStIXBXHXJCiCXJlxjITVN7sr2o+OSg0FqL4ZaIAT8on?=
 =?us-ascii?Q?fH7gxlChEbLOFB9tE5flttn5cQmJziT40BC4WjTJfdhVYQpNoHzr+BSpO8G7?=
 =?us-ascii?Q?tmJcjcPhs09rTXalWGpNr105wiHRogCpXvCioWY+eQGutrz4BNxnNfDXFs2J?=
 =?us-ascii?Q?cu7SPXPslL1WxHPwXujomcYKbfYl3OiyfWlpC69l0O3ZfWWgWbB9njWJb/ia?=
 =?us-ascii?Q?G19SjM1f86+FSyPlchS1IJMjsu1ukIMMosGMi+3QbAIL7xFz0sWaq+v/nBtl?=
 =?us-ascii?Q?lshUTOI+pERqDqjssHLHr8VXuF/q6kxpYao7ImZ6qw8MH6mENYIrbX2FKpEf?=
 =?us-ascii?Q?bvhtnpy/L1IH4vQcjEVIt2W99Gh3AYl50MjUqzWa6Ygkn3sPob09ntnsuaDn?=
 =?us-ascii?Q?WGg/mQ5ntN6wcwpVqJyAdXtpCrSyS84RyeYV+BvkOES+HX9pC3+Ex603HoVK?=
 =?us-ascii?Q?ZwvJmjCCjMTofIhdgDOT1q57om7XkMkntaiJ5kRh01Rj9KTlGhq0JPgVzZcQ?=
 =?us-ascii?Q?FAV4xXcRYB901zf32wasd+mNpnab2Ihdj+y7OvGXXaBw9Pa3SGxcA3vMTRW+?=
 =?us-ascii?Q?T4kfj6uNu/SjLw0dK6PLDKloSYvYlctlA3hiuNlBY5MD5z3f7xPKHV8ea8bB?=
 =?us-ascii?Q?QWocWuORG++2uYVxxZkBItCJUFK4d/AbbfSl67ltwL1ZBMqnfMvwg15yT+YK?=
 =?us-ascii?Q?kKkEZK9w9txoi5ZICBCaTQoDKtQlNO0ng2059y02//AOkRGYSAUkPItnEyzv?=
 =?us-ascii?Q?nd+ozNmLG/yWV9oqTvWhNWkZEZEYZ+ZDgOPlqlpFK6LLPF6+FqyMxBySD1zf?=
 =?us-ascii?Q?ctoA3diahma4J4rUTpjRj2zay56m++HO2tDcquD4CendDCQDvv4J9mpGt5/M?=
 =?us-ascii?Q?qcI53WhnW2JcDv6Tmi5QiN8DVzKlhfPMfq5OHrOlNieN9rEC2qzzTeW59g4e?=
 =?us-ascii?Q?gIsgL13oEamNiah1iZPCxzB5A9O+9JfiYmxUllbCDhhe/Ck/fSwrprfBgh+B?=
 =?us-ascii?Q?4gHaZOeXpdKVIls8Y8C0BTC5T8a/0CBpZzPLG5Cg25nEa1rlGijGWqTjlxOw?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e05612-3885-4ca1-a0a6-08da9696be57
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 21:19:01.0128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBmy0FFYjaTH9sdFRpcEnPaDFc8K8by+o4WG3v2l+LfN9HYCvIfV6sp7hDWKFcsv73WFHEcwD5meRdqU29VH6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6731
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_09,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2208220000
 definitions=main-2209140103
X-Proofpoint-ORIG-GUID: l15a-4Knl8Dc34juGv0i7R4jCikbsKf9
X-Proofpoint-GUID: l15a-4Knl8Dc34juGv0i7R4jCikbsKf9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/14/22 12:09, Doug Berger wrote:
> With gigantic pages it may not be true that struct page structures
> are contiguous across the entire gigantic page. The nth_page macro
> is used here in place of direct pointer arithmetic to correct for
> this.
> 
> Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/hugetlb.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

Thanks!

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

To answer Andrew's question about user-visible runtime effects.
We could get addressing exceptions.  However, this is only possible in
configurations where CONFIG_SPARSEMEM && !CONFIG_SPARSEMEM_VMEMMAP.
Such a configuration option is rare an unknown to be the default
anywhere.
-- 
Mike Kravetz
