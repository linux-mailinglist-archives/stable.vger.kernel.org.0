Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5FF48961D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 11:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbiAJKPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 05:15:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13390 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243745AbiAJKPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 05:15:11 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20A8pJEb017219;
        Mon, 10 Jan 2022 10:15:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=vJjWQIhmm517xyDzoew9C5kvjIqRMeiEmjBHtH6ockY=;
 b=M5QDvsbQrmy9fkqdp+1a9DeZLluvIuJAznG0ZshckNfu8XjHGgSZoCGRbFetJZkuL6Pb
 tg3I6JrS4nXxGoqN6bTOqFA5EaVjPGEBmQ0fPT8EQ9S5xL/YxHMeziU1SoHAB7VJIfuk
 Qu3AnVzj7q9GNwjQb0P9ztcLKV403Xq1ZgMwNXCIR+cw8kJeB2QcHHkN9zbU29+adJD0
 y00mYadT/0U2Rgpi3xTEhS2bl0v9s/70mePGj3Y1jkD36PV+fwnTJ54gx78nA+zJ1nsW
 qQ8gkp7xL72WPDQdD3qTYrftuUoBUyDBFnQSqwAOrUJZ/ryUcKwDA48BafKqvUWG4Tvt Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3df11djr47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 10:15:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AAANDw172186;
        Mon, 10 Jan 2022 10:15:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 3df0nccrk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 10:15:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atYzQEa3zkspDL0Bca4MevGis0f0ArbaW29V9Xdrr9oiFy/Zf4xfrRpSviWrgacEqEhel+QxRH/NqomSLrmqy19WlXl2fZjl88nDOzr0Sf7K7WgVyzteT1P7qNAmmbk1Mqj45dsZVYyI4R2SguF20Vz2CjGcVBLSX8UmaQ8Fwuq5SIBYCKDe/TxPNaD8rNS7pPeO/GNtTUdhwQ3dRsRCx93ytBfkLDEjUGHr1QDjGgi34wzOOlog9SX2srGstHqjCVoNnQTvZA63sogzaJWvPikBi1Iq/C61kMmeALwF7R+uxD93pyEP0QEhxMi20dZC9YLXIjxcNx5Hsw55FMx+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJjWQIhmm517xyDzoew9C5kvjIqRMeiEmjBHtH6ockY=;
 b=lfiMJfxxfKOCx8HoS4TmK5nyuzXuSmzyPUeWt5pvkxm9A0PRwBkX4y/2w2XL6CJsDz7iB6C/O5+vh/sXlEBCq/ThPpQUovTGRv3O/116QOXXOWiz/Ar5tyipILWMo4WvrSIx73KlirRm/L3MEVvOcBg1F5RMiBP54ugztPR+VtGjnwfomPdE2V61rMMrfMjayZ/Em7dRLiG5lHYjoPCJQIWV9pPeB9KdWDrPmpPa2SxDbdEGAshVdw7jSvQn1wz5+MhgeZnBJLBL1ni+RYCGC2cm8Rm6wdiqUFTc49bjUeY+LlaxDAL/u857ncaIJJX04LAXHUA/JYHV7+6AR1Khcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJjWQIhmm517xyDzoew9C5kvjIqRMeiEmjBHtH6ockY=;
 b=Ym5gBx742qTaq03KTaejjlDJbvFeZa80+4r0bKFgduQPfz8lmnZ1+NvS/53O9VyZFHA5RaGBVrU502Ij3aOO+nRJHtHF8blKW8qh8rMSTIIT/v293PSD5O6LictADYbnuypFH5GacEpiufXZ2osvsvlOogaQNScVGlvJgUY6q8w=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1360.namprd10.prod.outlook.com
 (2603:10b6:300:22::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 10:15:02 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 10:15:01 +0000
Date:   Mon, 10 Jan 2022 13:14:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 09/43] netrom: fix copying in user data in
 nr_setsockopt
Message-ID: <20220110101439.GB1978@kadam>
References: <20220110071817.337619922@linuxfoundation.org>
 <20220110071817.669190550@linuxfoundation.org>
 <20220110100708.GA5588@duo.ucw.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110100708.GA5588@duo.ucw.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0011.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::23)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af52872d-484c-4402-424d-08d9d422100c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1360:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1360B5D1BFFAB032B0264EA08E509@MWHPR10MB1360.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vu8V6o1Ru5ielHrx8NwFxSDlekNSDSxN1rE9pYLxYAjyHwStfxjjEpGADfvCPJVmV+C2S6m09a4mDM6YevSDBaxnQEKA+XRqF1IAihdklx3t0qAE6ODr69oKJZJ5K1ZY7jXCtdoCTmz6qcQRtr1H+D335gQ10SbXPQ5Zg/PvFkrvSPoHq4NOG57hU1LkiZP093iwX2Py+0ZbQw/fQT1Klm1dM5AMaSQYKjqA0TcobuAjCMCOtND0eFr6HiaWIoGhcPplnpl2Y1fMA3n+kk+7lUYVk8nWEBPE90ftfOsaTlZMu6h9RcOSJ6DewK8No9uYHDG4h7LH8I8Ut5EZgoNUIqXW58xvvZ8gYFBeIR9Md5wx5RqledrTxwHavt72Xzg96rvnwkaZh+YpQbwaz6K48Nw4KOb9pZUVvDwLjKQx4lrNJufUQQNyWjxYxW9tadgumRGEIdjVX3OpvFN7ojVv+Q/Mrw/Yy1IfkVaapRa9Dxy0+GF4c7yxVitn5ZVbxyy1Pc7ZNB9IuDm1RqFJB0vvwN2aWH+YFjw4IytejpDGOWiVmxBQ30/DUgkWsYlOCXc7QxHfZzR0DLzxDPQRJuwoo4hAz7k2/SZ6ZymU4nm700teW6yfsiH5VkbU/0VcQZP2Z0rkIgqfIc2+LgL3DnWxVKuQPrVZRxDc06zpYPVlzqztxp4+Vu0XELRey9DW8th5BVUHLvQ9p/oqIj2GnrqHlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(1076003)(4326008)(38350700002)(54906003)(186003)(38100700002)(44832011)(316002)(26005)(5660300002)(33656002)(66476007)(8936002)(33716001)(6506007)(6666004)(2906002)(66556008)(66946007)(8676002)(6916009)(86362001)(52116002)(83380400001)(9686003)(508600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tNVtKiYSLdJFO+b9S1MlkEjXRg3Kex3uPcGM1UfCDC76P488HQGWI0vHJQjX?=
 =?us-ascii?Q?PGDQP6bqWqtTMVb5moLhA5/aU6Fd7pmwNbhkCmueoArsECJaTwlTA/Qe6xrM?=
 =?us-ascii?Q?xVfTW6H28x5Cu7+WY2b9SxmORFUTVr6OUChXyYbC+PbCvj3QJDEwVSI06WyE?=
 =?us-ascii?Q?VVTsy6yzX5rkdcssUhx+HRy59UzAdHCWhaTM09j1zsVJ3QhlsJutMdkIPl1A?=
 =?us-ascii?Q?KsHeIfAkz6W0Q+edlGJwl5mPq3QgHt8qwoqfKZpdTfKccmq3BOg6exnUf7B+?=
 =?us-ascii?Q?wcNM8Qg72MdEAnfYzUnXJFNWT0vJw/ts6jYl4qy26P7fQ8kMrIJHaRr1j9V6?=
 =?us-ascii?Q?lW0JQTKGVR9fbBCZiLUcfek3i2NEWRVMCe+tRNrv5cuMw84KCYcvvs6Bir/v?=
 =?us-ascii?Q?dbpRq3qez4OHaMlJxVaPseH6X5K21EM5XCYOV3Y/c9dOT+7tW8I8SWc8zwAS?=
 =?us-ascii?Q?DLQRSsxaMKsNZtxobQolf0a5GGoyl0XG9JE6VS8fh0oHps6aWHbKmA7Vh7Xg?=
 =?us-ascii?Q?VUTE6vV3z9OR2GejNgH3B7XQdgCXr8Mx/KOz8SZY7KNDumWDMg7CaOgiv96m?=
 =?us-ascii?Q?RfB6E0D6FB3QaGBmQYr5wv/zZIyj3xWba9vDgurS+dIyx0WB/4E35OCZemHg?=
 =?us-ascii?Q?vPGJTuI3pP42JGXBl8Hy45nxBGaIsUZp9RS4Dz9dtdOk/p6BAv6DU98gMdUI?=
 =?us-ascii?Q?t3nLsKS1EU1MNc9yRH0V516LaPL6FYqSyO/6A7E0oZTMbtBY3w+DqSs65LNc?=
 =?us-ascii?Q?O4AoDMyo6XMeqF4U+rrsjJSETD0RTT+1JoYd0hZzQKV+nxcyNaUhNGoulAQy?=
 =?us-ascii?Q?V/d5HGfg0+5fQ6qjyWRsOzGorAen2IaBF+8FTF/N9y5I2gtvPLyUsp4oildu?=
 =?us-ascii?Q?IZOjTSE/NaoAjnAE9TXaSqj8k6+prJHjmTgig7G7MBbLM2OPuaCfPOIG7YXM?=
 =?us-ascii?Q?iC8Sjv1Q8UspzYHUIZx5dG6M0agSsEySaqEw+afYX/EpZT+HUmVVIntWIu6O?=
 =?us-ascii?Q?bC+CTpPToe0m+VBsCFSUS1kt0t2xUX7icQh52XroxUFI018xyFCV9rAZi/8s?=
 =?us-ascii?Q?dNQ4Kw8vYe3fXHxen7jJ04fP7xCZynqcBKm6LGb/L1T/QO1jD9kCLD2VJis/?=
 =?us-ascii?Q?c9v/QHUMBUZdMAiai5iKXuM6FoDAg9ypAxX3c1Owrd9L4J5CerH80Z4lIMX8?=
 =?us-ascii?Q?JXjSJ5LVXELZNUMM7NJ08tW51gEHdrVbMygpbJCzZWRQTxUJVVX2mXrs3MOs?=
 =?us-ascii?Q?YMdemC139IAKaINkk5ulJPmfUjRGADWUSF+aF26Thd44johdYLWIee9Z/tKc?=
 =?us-ascii?Q?ywsoJuh/e3/xynVWhejXbS9rJp1MBfw/skrYARt21h38ljQEGsUyp6TOlJaq?=
 =?us-ascii?Q?CW30EkdQPFdxrsM99+FkDDCc1IRuQsPv4iNbe3dx6AB8ZYvPPRtsYxoX7rXm?=
 =?us-ascii?Q?fyFa3fVJJnxpusvmt0aDnI/hu1eazwoCXt1KhC4zNe/A2VQosI7XfKT1uGJl?=
 =?us-ascii?Q?6czB1CAo5L0CuMghuRZNhFRCj+Qt9TceCt3ots7TUHJaiNf+G1xnUARbqFGd?=
 =?us-ascii?Q?2HWYeu6FvxHkiID/bM7eG+BOKHqw/X/kXAv/FdoDiCl3Px18WHBzoZygoKqd?=
 =?us-ascii?Q?g3iCcvPrCVWqqXPWN70JWZbKLYZUFLbIvEMyQswxzpeJqC+ypfSG6rXfBAZ4?=
 =?us-ascii?Q?NmYbALjDnbfLMD2X744t5euITj8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af52872d-484c-4402-424d-08d9d422100c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 10:15:01.8788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEQ2/KNMysBK1ZJtFxACMhQYfZl1R2U51JSeXj7mD+6sVKk5HFA+OFHUS64msYSQEk4koOw//HRg+jvIM/bfHEL3UE/xL1Ko1x1GqT2Wsxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1360
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10222 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100072
X-Proofpoint-ORIG-GUID: C4vP1d9dR4TiVN_kBO5lRz_arQ9Niu_R
X-Proofpoint-GUID: C4vP1d9dR4TiVN_kBO5lRz_arQ9Niu_R
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 11:07:08AM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > commit 3087a6f36ee028ec095c04a8531d7d33899b7fed upstream.
> > 
> > This code used to copy in an unsigned long worth of data before
> > the sockptr_t conversion, so restore that.
> 
> Maybe, but then	the size checks	need to	be updated, too.
> 
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/netrom/af_netrom.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/net/netrom/af_netrom.c
> > +++ b/net/netrom/af_netrom.c
> > @@ -306,7 +306,7 @@ static int nr_setsockopt(struct socket *
> >  	if (optlen < sizeof(unsigned int))
> 
> This should   be   < sizeof(unsigned long)) ... AFAICT.
> 
> >  		return -EINVAL;

Yeah.  This patch isn't right.  I sent a follow on that changes
everything to unsigned int.  Originally it was:

	if (get_user(opt, (unsigned int __user *)optval))

Which copies an unsigned int from the user into an unsigned long opt
variable.

My fix is required to fix an uninitialized data bug in a7b75c5a8c41
("net: pass a sockptr_t into ->setsockopt").  It would be sligthly more
complicated to just backport my fix without first backporting this one
and it would look sort of weird.  So I think it's better to backport
this and then mine.

regards,
dan carpenter
