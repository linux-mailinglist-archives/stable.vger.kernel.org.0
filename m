Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDA4648954
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 20:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiLIT6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 14:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiLIT60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 14:58:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFBC2181D;
        Fri,  9 Dec 2022 11:58:02 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9Iwui2010062;
        Fri, 9 Dec 2022 19:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=haAeACtdLOLIExdgj0+L29wi/vVjw1MGJnTHSrPN8M0=;
 b=kaoh31w+kqTT+sQw+OdkISCsCP5354ajf01AaO4cp4puvRR4sSnjHm/k8FayMT+dTrYm
 rZQVJIkViN6WiCPu61jP92YaOmFQHBxGUD5b6gCIT74p418KiDgsiC8T3Fkyr65GXiR5
 hyEvh0XDzHOVEKJzaDZyQuVtgkFBEUrjludCIYPzCBqJvK83jrGZEhkaf3GgU4UZDf+V
 x2ZDeFLY0gL63Iile/yeEdDIPthUgE9J6LVEaAN3EVzW1kia+IejpRQr6A0ik6x/3qQb
 TkYqDgcvstfurW6mkwhccs0vaQlRRR2ev3RFzQ/IbiBOkfWkHE59CYBxygA34HnujF5e xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mawj6w1ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 19:57:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9JOuJr031941;
        Fri, 9 Dec 2022 19:57:49 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7ghupv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 19:57:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwppeomNCr1KBpnbGUUz2UNU3G9LyMedE8J5WFRvrv/SZWX7GkQyH9TAkU7VSXgdnQ/aVvRXsgcT28zCd/YwJJ1ctT+WkJLPsmj98uO7EmNxlWcllQZunLp3pMSJZHrSTeIFV7UnppKJqVI4URAl9GpbB5l7SWyqEk2WdvfpRui+K6MV1ZRipYpegCM4a4+UutiNXJW/dKkG/TFxJRa6LmkOR3oXQn2cbVJQwz3+HluUt/jBtUYWQwLfwk/prQUwpAR52hfjGqJKXr1AaRmv760SJ/yIRU/I/A8RWDpIP5pBBvugwNPAn3t8+WQ5P4HO6PlDMihcaeey0wIeN07zlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haAeACtdLOLIExdgj0+L29wi/vVjw1MGJnTHSrPN8M0=;
 b=jqO3syFzs9ELQHVUhxNNl8UOiQ6KXeax9r8vaxckKasKXsPgl4f4OeNlqlui8ht1l3NeWmiF+OfCIJJoE/wG9wR3oWKCHYSR9oV7BgJodQsWIg68otwR3euMWWQUuZBvPJNvXkhmQxGUmWAC3JqxCNTsQiYY+j0JZai+HMDxUIpBptrxCyfk3Jty/Lxm9wW5UkGeKOAZTYOUfU/GK+bnpgvFjUlDW24JXcI+Jzk4VdYHcxrofxOz9iignep+f4UB9yEHtp+q1CrXd0ZJvEycYp3jb5OgzP+I23A7Tsz+HW5aLBmummJymR6mq/rcmchvUHAfosuwDjVpVKNyzC6Xjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haAeACtdLOLIExdgj0+L29wi/vVjw1MGJnTHSrPN8M0=;
 b=lnX0CgxyK0P/agIRZeMbNFlpasWQDYNDzO74Liya5V9JQ0rUGAdBgmQoqVACmh3yAoaO0o+g7yaL/ZYfoi/7x8ADgeQHgTFiECQCqRCmVqK5eT9X8YDIWRNPrghSvB3ge/ne8l9aPpEBE5A49u5nIyYyFth6YbiDft+tN8xCesI=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH0PR10MB5129.namprd10.prod.outlook.com (2603:10b6:610:d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 19:57:47 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 19:57:47 +0000
Date:   Fri, 9 Dec 2022 13:57:43 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Jose Marchesi <jose.marchesi@oracle.com>,
        stable@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 5.15 5.10 5.4 1/1] arm64: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20221209195743.dkk4b52gvm2hej3h@oracle.com>
References: <cover.1670358255.git.tom.saeger@oracle.com>
 <9e387b71ce45d8b7fe9f2b9c52694e3df33f0c7a.1670358255.git.tom.saeger@oracle.com>
 <Y5JKYA53GnPrsr+f@kroah.com>
 <20221208233106.jvss2x4unqvijhgg@oracle.com>
 <CAKwvOdkRrNZk_kWp-WvHduPzfqqDj=FyGbeJpNr-26QbCcyqoA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkRrNZk_kWp-WvHduPzfqqDj=FyGbeJpNr-26QbCcyqoA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::33) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH0PR10MB5129:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c96f302-3343-466e-c014-08dada1fa4aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aofH1+YUWAh5HiVEPePIFyQzPHNQ6n3/PV6bpndooZ3uk5z0mX8zZ2FZmNMuVRiPStatwAZ7P/f0283wgDUJdAL9ktMQdbO2PzZK3FslGOoRkCqopVXt+xdWYisrI414VtKE+8wuOwPn/vohu0h/rOL0KfzlrybKaC2NInRWZ//PUxP+bHckk33X12iXF9NV+r4bopi9AQqn7mC/7HhalIeciZHE3DPdNKz6dSijqjGFIw0tMU/AsjpxkG1a4QHAOXlrHlgcQMTbE9sc/exnhrSAM3prkcgFsKIjDXjXzdwlxo52uz7RR0Y6lP79SXMZhWPMennYpNTKOGek/6njUuyxAnWZA3tcnJ4V4709caB9NPkwkyf/bbIJfMFLyEBgVAD8oxed7YibTzcn7RPkaJhWETWkwhnw2RfGiZ1jo95iLUJqRmq5R8mhILFh5gQeI1c1P8mAUkLGbWh65guJafl92cjRHSF3nEFhEJwB5UdNmUpF9l3Bu2t7rOaoE0E9UXTqsY6Px3sjTwoZ6v1JHWb9JMZf3CveoP23nmZYCxrNyF/AHjxRtym3Pi/q10vZGqqdtXRbvmmymPU72Md68YO5xhb6ppvMRfWn7XANG33NlYq19WfiwIrFsaK8hxyPxkRQMudLMM8YRRgOUHCPVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199015)(38100700002)(83380400001)(66946007)(66556008)(4326008)(8676002)(66476007)(4744005)(41300700001)(44832011)(2906002)(8936002)(6666004)(6512007)(5660300002)(6506007)(53546011)(26005)(186003)(1076003)(6486002)(478600001)(316002)(54906003)(2616005)(6916009)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4gTe/iK3+C6/Jv+H4HKn13jUmreRMjkj4D9mLFA1hj9tMQz9vKi7wyRTGiuk?=
 =?us-ascii?Q?x70L0EU6fjxvrZTCZmkGKKw93xaLxq4LFealnzhiP53fzw4ue0xHE82mSZVt?=
 =?us-ascii?Q?OyHGSJE3hvqcNiN8bzB8xwQ1V47q2WsGo9xHGvoFV8kFB8D8lfcyEsiOwSG/?=
 =?us-ascii?Q?Fi2M6xn1vOKpIo8AWp2JhMcIbGn7PFSCIux+QYl6cUB+8hZXO1MP7bwoANyC?=
 =?us-ascii?Q?bZ3HZtyHfqDHY7Zn3aQMVAOKRvSYX2RJyhnF2wgSP4aqLe8h8wLEiO2tJi+b?=
 =?us-ascii?Q?E1Nvp2SjuAfZe0gjcnvWob8le3YOGeIXrbKJiObTqcwqxh0ehB7+C03Hhkoj?=
 =?us-ascii?Q?AlM868hQs95lTyS1NN1+UduZOMHpVf6lktOtGz2b45hc8IY6XiCJS5CP8N+q?=
 =?us-ascii?Q?fU3zf3bnBtEgG0PRmPckssk4ywyGx5eQnHHgW8ubKYxCytnESlxGt7HZgYoZ?=
 =?us-ascii?Q?leWz3cDx+G1MH0CC6Zg938J+WHqCiBS+7lrrRkR67SbskqAq15ryWn3hpmxp?=
 =?us-ascii?Q?3R4oLk5MDoUnUaLv2DM0yWSX+J442MKAVQchkgvIdO2ESscv0AZ1ERwbKgHS?=
 =?us-ascii?Q?r5WtMhaWrL4yQ/C8mtDz1gdVbNI7fQQElCesuXj9p9AF8f3s1X6yDW82CScC?=
 =?us-ascii?Q?z7iC3iKLTJk32BiZxfbCux7o+XyKvCOvfbP2dyxBKlWRfU0tVzm8ukzy8f2+?=
 =?us-ascii?Q?OspRW8k3CkYUfA7jivR7giBKkh0v1G5FLY2O1v7Ocddifuj1E4fgaALHS1zb?=
 =?us-ascii?Q?hz6LRh+TxptARQg6ZiKWUrwhII8sibTh74hhE6D8vWJH3oMEz+72s7jknwM4?=
 =?us-ascii?Q?ur5OSfRl5pe9lVFYlER7wd+K9ifQXMtEno1V+/BnP93KtsruIopmilDG0G0U?=
 =?us-ascii?Q?gpPPO7P6zPsmmXLARihRdsbXf3Flgw0SR7sUo93YvSHN6Mdgzw/gB86rn2xn?=
 =?us-ascii?Q?vGRC9Yilwg3uqv9JPzU0ZIUPvozdD0ua4j+I6Y7TpiuYz5N7Ze7yCD/YNJ5F?=
 =?us-ascii?Q?Tc7U+db5YQWvULFqGljdyyLJ9KuRCun+oT8VyGAovzXOF4IkT/OjpgHkeE1L?=
 =?us-ascii?Q?y+bFf6eYHosThiIQ7vppVmsZ0rZpYsn0MffMaM5TtR4F+wviSHu4Eeg0xf+W?=
 =?us-ascii?Q?Rlf1mIBCZHs5SZFekDtLPY4eF7lCNzMK5jDJbaDQqpQNaCSo/KT633CjfILC?=
 =?us-ascii?Q?uqyGt9zsdC4KA0FPzxL3N0qF2z+DupLCTPLCcf8KblDg/PS54cCj+tlnl2QD?=
 =?us-ascii?Q?tQh9tts6ctWy8ySSfqTKW2kRtTlWb3QalAP8XV2tSJjAfmVXSgruTLQ1fvF9?=
 =?us-ascii?Q?MhM9I+M0RBSeUopLFb9R8IeBVjQ6pV5UZA8Il6SUX/UmVHn3HVegfPwN4H3J?=
 =?us-ascii?Q?jANeyuBkLBOeRIXT4spjAJv6RAhDrsENbGRw84CTQ6KQuzGSWiPKjUJEAa58?=
 =?us-ascii?Q?M6j5UH5VLkth2rZBZG8djlJdmpWk+JVsg/3l4WvMH3c9qyyAU9wC9Q7A+7ON?=
 =?us-ascii?Q?I0up8/9b6sh/a1CAcvnx9lNrHeYMMPHVocmoYpsozhhAEGg3fXSyo/A8KYW/?=
 =?us-ascii?Q?sg84bBORQ93/iVXp8d0zVyUJAfSBO/FN06rhwyKq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c96f302-3343-466e-c014-08dada1fa4aa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 19:57:47.2060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3MMYMkghZjeXKE36n4qAJBvNo807x9PlAfq0n2ANqqnx7SEGkYspjVURLjNKsFeJJsKLwx4WCTPQ+UJdx9woA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_11,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=981 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090163
X-Proofpoint-GUID: VKtIn68qY_by7smUEzfqNT6bTAD42Z9J
X-Proofpoint-ORIG-GUID: VKtIn68qY_by7smUEzfqNT6bTAD42Z9J
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 09, 2022 at 09:58:42AM -0800, Nick Desaulniers wrote:
> On Thu, Dec 8, 2022 at 3:31 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> >
> > Can folks confirm/deny ld behavior is expected (arm64)?
> > And whether the above patch would be an acceptable fix for these kernel
> > versions?
> 
> If you remove `-z noexecstack`, aren't you just going to trigger
> warnings from BFD again?

hmm, probably so, let me check

> 
> At the least consider adding a fixes tag for 0d362be5b142, and note
> that stable doesn't have
> 7b4537199a4a, in the commit message.
> -- 
> Thanks,
> ~Nick Desaulniers
