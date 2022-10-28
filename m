Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAD36118EE
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 19:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiJ1RKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiJ1RJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 13:09:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F080E3054F;
        Fri, 28 Oct 2022 10:07:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEo5pF003779;
        Fri, 28 Oct 2022 17:06:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=WsDxWYgju7tAe1H+7SY82OU2vFUaIKT9KB7WN4fU6tA=;
 b=wlJcg/F7oBOKRaPGRff5o4rSLn669yDv0omXphGSV0WnU3ybJ4mHgOLhJJD6WbwbQ60l
 tHRy9f1Sbx1TjKfrFK664/cIRZbetX19T78aMB12RMufDbXRqJMK+6NLRDtrntp9JZUz
 YG+PK65oZvx14PNDtl3cXlkI7gvlGzZXCopr7fd25cm0z3jjU9R4B52HavCGIStdIkcD
 MVCGhcT6ZiWq7sSXCKRfig5PfZNeyAgA/w6cXqhLnssJtLSdv/qHk9BFMFuHxhgnEpxo
 Cyy2UzLRz9k/oa7DhsEB5T0QUvmPhiwcyoLtrIW9evYbVL0ujaaQFi/j7qJJX9J2BbVR KQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0anjs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 17:06:48 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEQC7C009402;
        Fri, 28 Oct 2022 17:06:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagg8knr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 17:06:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSGqQ+WSh50kKQvowJZkOPQvucuDX6hoPcUDAb+oAA78WSy3Kbygd+dF/h5kF0qetu1LJ+63UIAGIO16zdSQP0eirzLZy3Z+tacUzPX8k7EOAVtDA8PbOQqLij4E8V35iRYHDtAMQzmzlxVp3Wx/+IeFDHHoEWUAbkh3hJnVRJ3nkYgDhWHGBhClABiPo4T96TMs3R4wKK8LdjYw4uhQn2L4EMhZQk0X63n/QNJP4tJCRzQk1VChKI427A2Hz+AFrKUlz/hWKhCp/PjdqdnbuNtx6aIfDBjEOyhgFMq3ynYEw/flOh1njqElgFpI4gpNvJbtSSV6HsYaf2Uh8ebKbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WsDxWYgju7tAe1H+7SY82OU2vFUaIKT9KB7WN4fU6tA=;
 b=hNBPJzlVckd5QXqhoBryfLU/eEHkcO5Ax+1YbO3ygiSVHPareJmrwYdgkXFeWa0B6zcNkKG7hj3IyWU6xQ5AdfyhtQ69GxGbts1M2xJOxAMsFFXEDYsXcGsJqhq34abA9T4+8dtEZ5tdeDq6WSCKBS/CqoAwnv2SFHajLMZdGy20mbQnRqo43mEXLqAvBzKZoEKrKPkBf7kAc+hhfVWnadePLMwFnhf9SDy1JWmwxkD9lZCkCcejvzF3d35yJ6HcTgrs8Ftk65KlU+42NqDMhVg5EVl3vqNIww8Lq4tpn6MLfBFqjmuuryZTtup1s1F8HNMcUNUpQbq+wUFOmSaFHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsDxWYgju7tAe1H+7SY82OU2vFUaIKT9KB7WN4fU6tA=;
 b=jryGYKHQA4B3B6dBckqrjqnS277BBpwKJjzLU/OkD2EYny0UZbIlOkbTGBc4Odxpx0lHkigMlo0ganFnrHaiytO8Vce9QGw4nTZsH2AEVW9wzVRpPDHmejb4FZI6JROH8dyoJ6huNSqCtwuYuQY+K7DHaH1ushSQ1sppDBRN1FM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SA1PR10MB6445.namprd10.prod.outlook.com
 (2603:10b6:806:29d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 17:06:45 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 17:06:45 +0000
Date:   Fri, 28 Oct 2022 20:06:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: tegra-video: fix device_node use after
 free
Message-ID: <Y1wMGpthKxr2egtY@kadam>
References: <20221028081926.2320663-1-luca.ceresoli@bootlin.com>
 <Y1vMX/Zciz/XQ+4p@kadam>
 <20221028185847.5454a98d@booty>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028185847.5454a98d@booty>
X-ClientProxiedBy: JNAP275CA0047.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|SA1PR10MB6445:EE_
X-MS-Office365-Filtering-Correlation-Id: 2152b606-b177-4aee-e377-08dab906caf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LrUEnsDXCcOlpiAgb48jVriA7t0B33rbSYzoKWJxI6BlYac2X6pJSbFwPacK6teskkkzEGxextdoahvNcujAsrSSBh272IjdbyX2iYIVqZU+NKzU7oeK15m5ZmoSsAAorGUoHtWlMGOnZETBdCUWUFQdgzTDrl4y2+oPXZc/Dd6MNnxRgsDo7j957Rnd2O2aq7jqg5spT/ffxkyP3kA2geBV210eOqr/Jl4HwH7Xc3iW6Rgt+hhK3BsOpZBkbUvtjNFRYkz40rBvagr4U13TA7+8VnQppCZ0tR4B9pYXgMf12Br8DcYW8WJL4OHC3FJkgDwVPPkl7kMPs0hvXxhBy9XtAENNmO8GmDNC2gI1Ln/sEU8s0nrXICI6ne/GemkqoSNYOIxOurRUfZqKLyQM5H3yjk8OIdU2mP37uZwL+n6yHueiFek7YLp+b6WYOwSyC2cWbIXpKfa/qTc/lMaISIULDuo2CdgTLMtkKqa1PzbxvzpCQK4dj9i7uFwJ84ykmbZCh764C3yWwR6Z9s6dx0XXxqbQyk/HZx0kJZfeZIt+r4mPBb0JyKaf9yN4RWulN1tNf1ZA7ORjht/sGXcHAkL2rXi+esQhDK0lWndWt7zyz7SsSskA3IrBu69nLEEVpoYPjlayJ0PknAc8GSsRvUFm5qRxkJ5rIX3sDz6JQLIMzhNChu1AS1SAfvY3Jdjy42rJEfUbvQ0kHDTfQfteXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(6666004)(316002)(54906003)(6916009)(8936002)(5660300002)(8676002)(4326008)(186003)(7416002)(44832011)(66476007)(6506007)(66946007)(66556008)(6512007)(9686003)(26005)(41300700001)(83380400001)(86362001)(2906002)(38100700002)(33716001)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OYE4NbqAzUzWhl/lp1iB44IE3ciT8VlfaK6ayuGNH49HKmZhUQlPqhIxUfjB?=
 =?us-ascii?Q?h3fkv3Per/NUR1p9dhOPN1Zm00RsTYjQd3MJeIqPRkfwmyufgRCmk/BkZv94?=
 =?us-ascii?Q?5dz91yETgXqYUbneHy5WYDPu3qdPC4kpTqdW407Cl3WN4Z2lZ13bGp4eqW6f?=
 =?us-ascii?Q?PXNbWlZOqg3/59yu4bOgbNVBuQZXv7ZUQov35SppSWLY1ZvcaIAhd1jI9M4y?=
 =?us-ascii?Q?+9/Sw+456C8HjWbo5Zk95jWdQEFwyCgfrMUdTEWnVJS9Rjed9+mQvMU0JvWe?=
 =?us-ascii?Q?y+5s2OaqBfUMxPOGL9BxBO/zCpwWeQ/zuXfXgAsHxik8GnbZodRAl0n5lEpq?=
 =?us-ascii?Q?gGRA5jmLnLVNVN8jOYw4fEL0fKWqpz8XBBor3Een9qFMkAOOkf62e5UvwTNa?=
 =?us-ascii?Q?cszewxTz98tBSrycOz6MpqbwSznZHfFZdNI/ymxzCQVNt8iUoqhTYfHnuZUZ?=
 =?us-ascii?Q?E/QGGAOV4CzZmEm0AR7QUdeme6YifXn8ReKIIRmAqn4VVSCj5jn2Savmwy79?=
 =?us-ascii?Q?GR44f80ivZ2XAaPbJhM9K3hrybymCQCfIu3EbkZLIf8yn19Qjw/vxOjSSsvv?=
 =?us-ascii?Q?jQzlfOxka3+L5lw/rfIuQ9dbXm1Hv+0VJlShjCeCWM77nD38erj83UX5Wu+5?=
 =?us-ascii?Q?88E616c0TNcIbZEuhdqg1SXn17N1fBALE2BKuDMxBODzdnLg6hXsw+JZHoql?=
 =?us-ascii?Q?0hQlO8Rzz2rc3eSst1gtU5TltLmpsM+jFZGWzdCVwQOyrA6XoDUP8jU0NZXZ?=
 =?us-ascii?Q?zP4uHhDY6vBa5XzHZtPDV0AkloEXVzPU+r/FXtCwdACMuskwDILuyFdZtSfZ?=
 =?us-ascii?Q?TyTvRUGE+dkJx/vybW3YQcoD3+SV0lASUUf5Fxq/u4BFyuREIEuuTFi42pRI?=
 =?us-ascii?Q?iUYNqtitovYLVAushYCi0eM/i25RYyeBVmO+cLBeFJD+9icVPcLe7z0o1XAn?=
 =?us-ascii?Q?eJzTb1u9DKd35RCv7HewW2O7rwicR+D3zPBH+zm5XGApXezRhidduESxdK8W?=
 =?us-ascii?Q?OI9FrO1ZshIa2vCFk63f15TLak0T+qb98wwnC1y4dEe/E01ZtTbSpwyEylnt?=
 =?us-ascii?Q?GpCkd6dVnTOVsQtQdFIA8UluE0ik/7HgEBQV+IcE70amEMLxdQZ/npcJuL9y?=
 =?us-ascii?Q?rddUStfK5m44GQnIXb6zRg1PsZ+WjH4uepLNEwGp2xyr9AQFzHuUgkOCM9R2?=
 =?us-ascii?Q?LT/746GcR+i5J/+JadhEwzzdkpqU4CjmrPHr65FGvBwj1x6GDgypj/IHevob?=
 =?us-ascii?Q?TgT1vcc7KjpXaohZQpa2MtZmxalrb6CcE85izw7h77H1CwL5+PX8ttU1p5J6?=
 =?us-ascii?Q?oyjD61xJILVnPfH5rlFW4lZ17swgqQvipy3IypSigZYA3ocIByv4Im5SW4nX?=
 =?us-ascii?Q?XWoKVUS8a00DXbKAvUIr/eO1bLR5vc8vr/jIAs5fuhDTnbXwc2Cr2WUAPPkS?=
 =?us-ascii?Q?JHe6b00WBHW0MJWmsnJt7CV05AT9TeCOcxdR0tfF//3I2gjb6aIg4z14gylm?=
 =?us-ascii?Q?O8J5kju0ll0htgzEk1mts3qWmhr+MiSssYWqO6o1Dt6tW9nmPJvYwdnuoozq?=
 =?us-ascii?Q?acStNJXH8zrFIgg7Ljyghf5i5UQw339vhO5wwYd81OFj/R1OtnYXQwVP2lj2?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2152b606-b177-4aee-e377-08dab906caf6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 17:06:45.4497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJCclLxBSCDSXAx6sxnAf0g5hWtGVwSFOdmG1PBwKKJy84pY4E0iuMS5roDtvjLQs0BIghu6FC+fkpy2oWp6D+/hmV68VZcDeew+NX6Jgb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6445
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=982
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280107
X-Proofpoint-GUID: uDr0FdCpIu5e2OsenvSGAze26p4Nv9vr
X-Proofpoint-ORIG-GUID: uDr0FdCpIu5e2OsenvSGAze26p4Nv9vr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 06:58:47PM +0200, Luca Ceresoli wrote:
> Hello Dan,
> 
> On Fri, 28 Oct 2022 15:34:39 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > On Fri, Oct 28, 2022 at 10:19:26AM +0200, luca.ceresoli@bootlin.com wrote:
> > > From: Luca Ceresoli <luca.ceresoli@bootlin.com>
> > > 
> > > At probe time this code path is followed:
> > > 
> > >  * tegra_csi_init
> > >    * tegra_csi_channels_alloc
> > >      * for_each_child_of_node(node, channel) -- iterates over channels
> > >        * automatically gets 'channel'
> > >          * tegra_csi_channel_alloc()
> > >            * saves into chan->of_node a pointer to the channel OF node
> > >        * automatically gets and puts 'channel'
> > >        * now the node saved in chan->of_node has refcount 0, can disappear
> > >    * tegra_csi_channels_init
> > >      * iterates over channels
> > >        * tegra_csi_channel_init -- uses chan->of_node
> > > 
> > > After that, chan->of_node keeps storing the node until the device is
> > > removed.
> > > 
> > > of_node_get() the node and of_node_put() it during teardown to avoid any
> > > risk.
> > > 
> > > Fixes: 1ebaeb09830f ("media: tegra-video: Add support for external sensor capture")
> > > Cc: stable@vger.kernel.org
> > > Cc: Sowjanya Komatineni <skomatineni@nvidia.com>
> > > Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
> > > ---
> > >  drivers/staging/media/tegra-video/csi.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
> > > index b26e44adb2be..1b05f620b476 100644
> > > --- a/drivers/staging/media/tegra-video/csi.c
> > > +++ b/drivers/staging/media/tegra-video/csi.c
> > > @@ -433,7 +433,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
> > >  	for (i = 0; i < chan->numgangports; i++)
> > >  		chan->csi_port_nums[i] = port_num + i * CSI_PORTS_PER_BRICK;
> > >  
> > > -	chan->of_node = node;
> > > +	chan->of_node = of_node_get(node);
> > >  	chan->numpads = num_pads;
> > >  	if (num_pads & 0x2) {
> > >  		chan->pads[0].flags = MEDIA_PAD_FL_SINK;
> > > @@ -640,6 +640,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
> > >  			media_entity_cleanup(&subdev->entity);
> > >  		}
> > >  
> > > +		of_node_put(chan->of_node);
> > >  		list_del(&chan->list);
> > >  		kfree(chan);  
> > 
> > Not related to your patch, but this kind of "one function cleans up
> > everything" style is always buggy.  For example, here it should be:
> > 
> > -		if (chan->mipi)
> > +		if (!IS_ERR_OR_NULL(chan->mipi))
> > 			tegra_mipi_free(chan->mipi);
> 
> I sort of agree the code could be clearer here, but looking at the code
> in detail, this cannot happen. chan->mipi is set in one place only, and
> if it is an error the whole probe fails. So it can be either NULL or a
> valid pointer here.

I assumed that tegra_csi_channels_cleanup() would clean up if
tegra_csi_channel_alloc() fails.  Otherwise then that's several
different even worse bugs.

HINT: Let's all hope my initial analysis was correct.

> 
> Regarding my patch, do you think it is valid?

It sort of depends on if the "chan->mipi" dereference can crash like I
explained above.  If there is no ->mipi crash then the error handling
needs to be fixed.

regards,
dan carpenter

