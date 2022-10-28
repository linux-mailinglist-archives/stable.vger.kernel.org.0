Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6900C61118D
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJ1MfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJ1MfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:35:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60F977EA5;
        Fri, 28 Oct 2022 05:35:05 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SBNnEZ018948;
        Fri, 28 Oct 2022 12:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=GpiOJTuw1POJdfV6mDOfZsRSs8OL1iY5SZJbV3YoZmk=;
 b=yduI3uZso0WGcChEitArBm8A90bboCZbYWC0MpEpptGbo4RZPqteh6EOKit2LsG3geQD
 yBrO7gjnOupv9GfYk05OMuuw9owNyOaJt1ZHkOsyW8L4sFdk/onuiivJwytnk6+TxH77
 rlUKD2rw2xKZMUzd7HP+6AOSeQhs/ZJkZFbpkUVoint0eABB/4F+DodNv69OZEpcXFR+
 f9TCgzAKzJtufbGJx2fRjkF8HqukXJd9uXq3Vjc4U4b8pFFh0z6dfCMRZPBaEQxT4cXM
 4J6KV8m7Q7cPlOpAw/+0ZR6MA/+abbodH180CdgJiTjwJYnt733Jp3gHPEJOGerMkU+I KA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7vngy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 12:34:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SAnNag026367;
        Fri, 28 Oct 2022 12:34:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagr2hgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 12:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEdsUCgxZebwAGf1f6MZLR6pSSa3otIWW3Y8tejLASqRbhvUzufMIv73/J5Z9kekYsyztm7Tdnx8ziNV/tYP587E42rEGD+9z6wla++YOUvhj/MHsVBEuhxtQQfshLngQysO5OMSUlVhX+Aw28ngWOTQ+ER3zNcUTNmtFc+9GOFKGZsfeNWGBNZs+RLGLaYpYShs0ZzFn9AmpjzPic7qK7V3DRnFRc0fNb5JaZG6M4oHO/8zj+4LzPhOk3zbF3ZBX/C3abOuRgMrHsDFwpYv0v3Oa0TnMpM2BT153lRCoQMLPV1oOnaGQPX32Ops/E1zYy/yWi0xtiauGSvChTjQzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpiOJTuw1POJdfV6mDOfZsRSs8OL1iY5SZJbV3YoZmk=;
 b=TlU7CrM7e2a1m50KhziVEo1c3f1uuGvVbIehaxY8z9KP9pV70SKSP2QPwCOT1j9N7vcFpl6hX328JvVuKVsj9BuJm1lntmtuSQYzuzyRJ2q8klpxFiY1lOm0CUEPzb9DznneM/Z6nabdMLYlEWu3uxlkgGjifCfqE2qmY/T+gO/k27xwB1L23DKNzW/TwJQgx/zKOi3NUR7uBR/PL6fDIA3VeBat6K6kLQRKeuZiqiobo7FDba7aS3xXRkTs07c/v2arLkUko/hRtWKQAZ3zgTVBXSshui4lKKQTqQk34d2OUFgc+gZLZ7GhZJaakVIIu6kObZVZEltIEDVIRGh52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpiOJTuw1POJdfV6mDOfZsRSs8OL1iY5SZJbV3YoZmk=;
 b=HJ0UTX/GXqdQ28Ak0f1N/vBNMU3txP/ynI7uAEFBnPkxD01CKwObvR1fvAyqGkKHh+9yx30vmvZFFTUrM4vG8qvWElycJsDu13E23Camjg7NPFSZtuxuPVbZRw1duZ3g5n/LkixQOtbYjVBt/gUma/6dBJY5ggALh/CofbiKT+M=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB4789.namprd10.prod.outlook.com
 (2603:10b6:510:3c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 12:34:51 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 12:34:51 +0000
Date:   Fri, 28 Oct 2022 15:34:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     luca.ceresoli@bootlin.com
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
Message-ID: <Y1vMX/Zciz/XQ+4p@kadam>
References: <20221028081926.2320663-1-luca.ceresoli@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028081926.2320663-1-luca.ceresoli@bootlin.com>
X-ClientProxiedBy: JNAP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|PH0PR10MB4789:EE_
X-MS-Office365-Filtering-Correlation-Id: 96c476a1-ab3a-4a89-6a13-08dab8e0cea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9TC2Fb97aYoZFZCxBBplZxMPOjQ3Eo1i9TIat21sQGjS0bpV5aXH8rlEt8yTIEtsxMUKTMJyHW4eo6BCzGhmSLDQb01Mjybnhd/RYindOKtwy8/72sOMOAx+MZ/cT/ucQZPJUwO8+9JqVQ4mMjyxw5YkuY+ykIUpWeBOdA7TL8n0AXlRY6lrX8fVlibegMYrcb1APA7sJskk5FZZvp6MK6w2XOX5VgyOmzno7lv8kJ2yIiRrkKcRUfgN9o2LRSWp7rho8iEYm6zkCGSmgzNipNlRoSqToT2vv6a4e82Nlr8d+M1Hw072ykYD+hqBA/N3BjiX3Oq7DpQQG8aYYzs76w+qrgmOZIXBd5VrHTVMDCsPalgwSNbXR/R5J8C9otU+2gGCkS3Eyu2PNTqlQ5avmEGRejr4X9H3B9rEyulqg9TF1cenlTElP0ZYohrykblZHtXvCZ6N8XahDnnZ6AViSKxoFAYSr5hRSEENQW9+b29gCSKHCndn9pWGP4JMp+llp/H9BqpAZz78MyKTBXIu/ZayoujaknHtnVDYiAeTIho7108tEdtlEmJD5yP3BlRjhosddE4q0PqhV3vbT6aQKbmhcgKJBxdkeMt+gM8pq/EfDX2ffdGOi3va/DSlEgh7SpOvtn635H68XtHfoTzRK27sN/dh+B9idysDvvdJ5CduVf0SpeH5343pVD5o+VQR/cnkJ1fQknsyFqZ+L6DavA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199015)(316002)(4326008)(6666004)(83380400001)(86362001)(6916009)(54906003)(38100700002)(8936002)(9686003)(26005)(2906002)(186003)(6512007)(44832011)(6506007)(5660300002)(8676002)(66556008)(66476007)(66946007)(7416002)(41300700001)(6486002)(478600001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K2uyrj/qTkcTQPtVpTZzmaTyzHUK5QecajfsmsCJqeeGogmiaEOxi8o4nrGV?=
 =?us-ascii?Q?WZ+FQRf/aIZWoyDnm0iK0AZ0w1IeUMGo+D8qWIi6fDIuaCuAiA9mJ2/HLtkV?=
 =?us-ascii?Q?nXGHhM+P0S5962m3/8XFCQhHiNRCcYjG2haOM5OQz0neSJt4DNfP/6hFuUNa?=
 =?us-ascii?Q?X9qquJQ8106QxcxzlL5rClJvndw/rmcIO2HTSGnkl8s2IJdVtD+LLTAVNEr/?=
 =?us-ascii?Q?uJoZn8hej32RqM4I/pocsmtk3jrKyIvqg3YiFrdFpi+4i0It5Fl8JCy+UFHx?=
 =?us-ascii?Q?QtqbQ7gV9DDbOmaO8LcKwFTdP3rCEl3g2yR2e87BytKNlXojGYt2sV3rrlZ/?=
 =?us-ascii?Q?9/O+ZSgg6Y2IHuh2Eo6G0TEgKrm7KAG0sJKVHDmydW0+Mj3y49VlIk+dpE3Z?=
 =?us-ascii?Q?imqTqpKU4Db6R1LhUBuaVAlOuzJ54MbMiqwPYYEu6PKdfp6CbMPKdoK5l1YQ?=
 =?us-ascii?Q?UKvikiLmPevuNNei2qTizEI1blX/0M2id55UB/Zt0RZzlzTh8ZqQh/bx1CUF?=
 =?us-ascii?Q?RBvDeO24tv3S+qzVW1qHKz6iWXRpz4bZ51KJewP+urRZk62whfWgBUDhyJk6?=
 =?us-ascii?Q?Wjc51SltGE53fPR78cKghv8m3kPChGtYsT1arrg/SxV3n5sspftpt/9Uwl+O?=
 =?us-ascii?Q?bUkc5QS8PrGpORL+1y9hAZVikf45pWQ1LGRJz+RpnAeCcjoi2Lz99zPdfHob?=
 =?us-ascii?Q?7NzUW3udhYh+Q7a/hDTjaY4En1Xhzh4YmddMQkvgExMG9hC9GP8Rj2K6h3gF?=
 =?us-ascii?Q?VU3SlN3wQvucHD/PeT+qBs2QjYMLcjLWwu5frljkXt3i/asz2Z1YT7yo6Is+?=
 =?us-ascii?Q?ctJctxDV9GXIHrYPl67704XN/jd5NL0r9hvEiBdPHgRVy06CfvXXCSruxlkA?=
 =?us-ascii?Q?dQ0QfXuGGBhjIP2jLMCjBVWp2aiKv3wgFQWy45jj8kYluL4Ss+B+dlSNZoh/?=
 =?us-ascii?Q?xQkgTQxA98zX40Zzq/YDAvksDymbBFY6z6ByDzSvJ2pofVzz9wxUH7b7WWV0?=
 =?us-ascii?Q?1VYuWdIZIlSgNbt/Nnd1M9r9jT9cQW6zxLEbr4QgEoNIZeSoUXHNp8AG2h4m?=
 =?us-ascii?Q?npabKJdh47ae4W3dNAqBGL0R4R0DCXOeKsBII2iflG2iSpd6XpP0JuQ4ywT/?=
 =?us-ascii?Q?LznOnqh/jp7gVuFULom9hnJay5LxmldbMb0Fey4HZDw2UhQlRP19L6F/0W9b?=
 =?us-ascii?Q?gF3uR1FKPHxixcB8+jMSwyxYJDVmIKNNy7yBZuppE85Y4iRHKAq/U9+lJ6Ko?=
 =?us-ascii?Q?JTARKNnBHtXoVMY4tJ0ypPPSsCrwwsmNrTMH32ud+vfsg6U196Ywdyfm28+0?=
 =?us-ascii?Q?LEoWtwpdLZFPMDorvBU5uY8eOS77ipqskCnwnj2wugDLfhkXO/SjBnDEHkE5?=
 =?us-ascii?Q?rfOgbalhWOPyVIsfvuzIQaoCJWTIRG5g0F/7k75JJyjU3zFIlelmbYZog+EN?=
 =?us-ascii?Q?WZ9+C7AOJAL3NyA6gaf/Zxxa+ukhnT+zDwwZm1QyRflqQcnyxGsxrH0pYtPP?=
 =?us-ascii?Q?uJvunymzvaIqWM1r1wFDb07LACoie8BtHDBfe7b1MQBFCRYIcsxMdhNZvGs7?=
 =?us-ascii?Q?1Oz1Zst0NDY4rDvfTNnqqtb9sbcJbWA0+auJBqvtoepOPKhVrwwmA8j/lYlU?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c476a1-ab3a-4a89-6a13-08dab8e0cea4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 12:34:50.9631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZXHc+Nph48B7AD/vsnrjvM+wtw7gl13f/0o/mR7yEefT+VgLZ23dtZHBPhdQwcQUZDtMHDTLWoxecqcjz1YknlZvENKcA65EHwoXE68b5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_06,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=610
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280077
X-Proofpoint-GUID: KpTXnX0yY0TAbmV5NadX9At5AhV7JfEa
X-Proofpoint-ORIG-GUID: KpTXnX0yY0TAbmV5NadX9At5AhV7JfEa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 10:19:26AM +0200, luca.ceresoli@bootlin.com wrote:
> From: Luca Ceresoli <luca.ceresoli@bootlin.com>
> 
> At probe time this code path is followed:
> 
>  * tegra_csi_init
>    * tegra_csi_channels_alloc
>      * for_each_child_of_node(node, channel) -- iterates over channels
>        * automatically gets 'channel'
>          * tegra_csi_channel_alloc()
>            * saves into chan->of_node a pointer to the channel OF node
>        * automatically gets and puts 'channel'
>        * now the node saved in chan->of_node has refcount 0, can disappear
>    * tegra_csi_channels_init
>      * iterates over channels
>        * tegra_csi_channel_init -- uses chan->of_node
> 
> After that, chan->of_node keeps storing the node until the device is
> removed.
> 
> of_node_get() the node and of_node_put() it during teardown to avoid any
> risk.
> 
> Fixes: 1ebaeb09830f ("media: tegra-video: Add support for external sensor capture")
> Cc: stable@vger.kernel.org
> Cc: Sowjanya Komatineni <skomatineni@nvidia.com>
> Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
> ---
>  drivers/staging/media/tegra-video/csi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
> index b26e44adb2be..1b05f620b476 100644
> --- a/drivers/staging/media/tegra-video/csi.c
> +++ b/drivers/staging/media/tegra-video/csi.c
> @@ -433,7 +433,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
>  	for (i = 0; i < chan->numgangports; i++)
>  		chan->csi_port_nums[i] = port_num + i * CSI_PORTS_PER_BRICK;
>  
> -	chan->of_node = node;
> +	chan->of_node = of_node_get(node);
>  	chan->numpads = num_pads;
>  	if (num_pads & 0x2) {
>  		chan->pads[0].flags = MEDIA_PAD_FL_SINK;
> @@ -640,6 +640,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
>  			media_entity_cleanup(&subdev->entity);
>  		}
>  
> +		of_node_put(chan->of_node);
>  		list_del(&chan->list);
>  		kfree(chan);

Not related to your patch, but this kind of "one function cleans up
everything" style is always buggy.  For example, here it should be:

-		if (chan->mipi)
+		if (!IS_ERR_OR_NULL(chan->mipi))
			tegra_mipi_free(chan->mipi);

regards,
dan carpenter

