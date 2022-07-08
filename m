Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E60456B691
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 12:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbiGHKGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 06:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbiGHKGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 06:06:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3993A83F35;
        Fri,  8 Jul 2022 03:06:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2689T56S031590;
        Fri, 8 Jul 2022 10:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=KubSSVLES0wjaQQ/LVQsIJAXZK44hhb1RhZHx2p1HE8=;
 b=hAP/xTTkJqRYMeYS7cYgJ9GS7jQpeTo9rXFfrgaLUYOvzHKZOSLKsjM8gRMAGGygqA/7
 msPvWDb0PP1E2iVYXTT53hVAe9cq7U/QPP/XY2E8p+aQXb43MIH63MVh+s9I/fXTomNc
 0Er2Z6zVsv7/QvlXSyyXcj7kneSj8RTBSR6OIVjlcW4V7zbKgGEV1XTtoioy+amtIxZQ
 KRy/2sz+zqHBURXA50ymYimrkJazOFGIV7oKx3M/PUhdS3ngZ1c4np6zHAFXdOTIEwBB
 PbgVk7IHG4ElZps3L8sAcDLteTC2gfDALOjnZRB0jsk59XKmiPFsQC3P4HiUPISSNXWz 7A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4uby7q19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 10:05:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 268A1wjB028432;
        Fri, 8 Jul 2022 10:05:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4udg8khp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 10:05:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PogRfUabbVGTe1ZOiEh52SOYz7Qt6WyvnG1xOZQWzGVtiAlSegJ7H5fOz1014UbMvNcDfDHK1UMwWamN400qFylAOtBVQ4bLkD92YBwGYbDGGMhyzugxUv7bUtatM+CmKqzPMw1donxv0+SmyREFunjdsfL1GRx5q6RElliBQZ8DCbvxencUc/RdT2bX3kkRngmLJ/SYc9hobUh9PulaKgA7H88WA9XdMfQO3bqSNcrvHjpLfZQta5l3gUbUAr5fNPgs85BCE2ziBaqx3L7JWdrNZYn/QcC6O/DmQo3OOBCsAxFCgVRrWVOlBHCy6/BV9vjzDIoLU4KaiwzW2LisyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KubSSVLES0wjaQQ/LVQsIJAXZK44hhb1RhZHx2p1HE8=;
 b=Nw7PtXL4Tp4wh+wzjq16mcbaF58dHM6i+04GGaJGJMcKwmnjaVvmEJjbMCv7hYLawgQl5kopavdxlmn/ejTPwA5pwDIEN2bXiBQv8p8bxBsfdteIJbxjZOsnXwN8anPAG/UpS2MTANOUO+kKRRFEnNtDKamysU7WY5T2zhrdsEOVHUzZP/ftuAZvtknPwj+9dhfp+02wWfqohCOPnxRLnvizmuNSq9wKxHal0Qywpr+NbslgpIbgKbON43i4+oaPPw7icxNEkHk9Vi95uj3QkTzyzUU8nsPhe/5i4GGa+tIa7cL4D7oZWseaHI6ga3c5KYOdS/PzJVl+glXbzSa3+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KubSSVLES0wjaQQ/LVQsIJAXZK44hhb1RhZHx2p1HE8=;
 b=OKKZa87e2hOqJDkRBJwRbNtkgQUA+y1Hujh5YD3Be8ait3jOJtFEzOHczlclUMrKG6F1Jx2LcJB0LvsIuwx5cDEK5FUfuivdWuXL0JZaj0M9ZVisEAX0ENf3Y1S//jIvAeQQCJMoyAs2oyQIoMojD4PIAHZhTAmBY5yFVOwOt6U=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB4924.namprd10.prod.outlook.com
 (2603:10b6:610:ca::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 10:05:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 10:05:15 +0000
Date:   Fri, 8 Jul 2022 13:04:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     vkoul@kernel.org, yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] soundwire: qcom: fix max auto-enumeration devices
Message-ID: <20220708100453.GM2316@kadam>
References: <20220708091947.5610-1-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708091947.5610-1-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::28)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a359b730-5965-4a39-7df0-08da60c95a53
X-MS-TrafficTypeDiagnostic: CH0PR10MB4924:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fNLfTE4D4gn4TY+kokuZrMVBkOdD2g6xzumd3JTZBdDpfo9iTTIzHBPTdadOXFyA61AjXuc5+K8cN14wJ9E8Wv753AytZR7izvbeGZq8CDLJg2uW4vx4ekBZ+WlnIxgJosaGkaJpzBv+xPIcNVAoDDEAeyeJuxEukC0i7zeiN9xLvuXc+YtMg+HMJ814Jsgzmhv/B9LTGobmZ5fLMn7LBhpGRKwscDx7zkJeHQ5jkZ74UKpLlDpq6IIfJpuLBmLs3SV3eD014P8hyFRmEyxghwEsb1KWyVdZgb92P6YYScvVlaQdVB52slgBVl6JkzG648egX8iTzGJEKNWgoQDQUCgVVy4HLwxkg1tQvS9yriUscKRKPGF+0fYv1YQPpRreZPY7mgmDgaHLaAvJRWxFMC/SYxtdhdfOuQ7XReWDjkhMWgSyyaZrISQ6iRp3VRbTS1jk59agEJWPxt8OYC483Br/VM2I0TsBQEvOkaAvHTw0rRL9fmF2h90+t76VYVMB9vcTx+CPa06HoPx8kwL/TNWPTGpXm7NZwBm7o2mcOIMoqPPdhnKN4Z96nMriF/uDO7xpvvtJUBZ/PFkGN8WJR2btv8Sgxtm66YhugbdV8TsfpUMvUaJWzpMtEWakJjgTW0cTW9G+Gm5wacbjkQtWyR3z66CSOvD5dGmjRpx/xu20LJBt1RUvJOyGzqFz8paCVDXsldFrMkDzm1z5fIrS32/Oxay09B1O2QamW1bJdp0dajL38f6TEOcDSQ6nGEmPBBi+42cOkHv1TMrZ3oHktXpke9y2ptGomiA+sJlFfU3nRvF1tCK8a9dxC4H3uPqM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(136003)(39860400002)(396003)(366004)(33716001)(33656002)(478600001)(41300700001)(44832011)(52116002)(6486002)(38100700002)(6506007)(316002)(6666004)(38350700002)(6916009)(2906002)(86362001)(66556008)(6512007)(66946007)(8676002)(26005)(9686003)(5660300002)(66476007)(186003)(4326008)(1076003)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f3CzF1drGeYbIbxEPbRQM9vBX+TpE4M5Vr/YW6upOxG5zZkNAQFwi5JYW+SK?=
 =?us-ascii?Q?/QOqq4eJBY+PHKXaltuX/IhCnm1EWAs+FKr8Q7nLcTfqsZYMk+XfDvVkSgh4?=
 =?us-ascii?Q?oJf6IlxkOrwkABpKQoVMCLnUffMf7vr1FVItpyj1h/I5LALrFSfPlsq9Ajsx?=
 =?us-ascii?Q?4PkfTJr2+5kL0r6YMNTm6BQlyIUW3vmz6bdm2ohUhESxT0no6Ia2KELaGn5H?=
 =?us-ascii?Q?QN0pdrswbc4h6TKQZpq4jEetIWJV+Mmwtp+IZ/wW9kaAyQr0MsKEEc1GoT4q?=
 =?us-ascii?Q?vu4aRS2XONNlvux37APnz8KrX1tdTJX1maCWnCS2eO1ZddMZeojhz9ScuJTN?=
 =?us-ascii?Q?zPCoU/kZWpzgmn+eb28DVV/SMTSaD/wDityQSkYKvnsqAQD/Huajg5o+uS9e?=
 =?us-ascii?Q?39SLEMK3+RhBWnMUYwelOU0BJoOHZxrMRgAiH2jEaf5grhE+EpYoorxAox6Z?=
 =?us-ascii?Q?+0HAY727InupMcbIciv22cK+3Ea/d3uaq+g9fXfXgoZwYSyZZ5gMpeJD6JM9?=
 =?us-ascii?Q?HMQy2LXuJCrj+CLXCdS79H469MuPjleG5KR6NBLahDEYPAWKIFv7IEkWoOle?=
 =?us-ascii?Q?YIXq3RzFE6+bCCjHAb8YuNpGkHH9KHoEgyG6c8p11NQvZQmTlh1V3WGilCyV?=
 =?us-ascii?Q?gqWzWD99OLBIvdRKi5zp7Z5TgCDwB0AfBup2Y6VSXf6T2ywGrukUT8mfteSC?=
 =?us-ascii?Q?r8t1q77Z6HCOZDzTPl7iynMo0oPZQGc7UnMa9Kg4SuJSZ+xdJP8rC1eCV1Wx?=
 =?us-ascii?Q?9rPB8UXcygnoJsNnShkLlP5B0KO2R+uMBZIqQaxOm6R3BcaEqPRy7WkvpwAV?=
 =?us-ascii?Q?i8vZP1lOJpqL6rpnliM2IZY7oo8sdMsE0vPHOYHBXGPLH0AjTmQWkoOqHPvI?=
 =?us-ascii?Q?7qIPQ27MwM3vY5hFIj5IT0PtY+WjTzZkk1AemaRJLhAM+PiwAoDWeRgqjp05?=
 =?us-ascii?Q?z0vG5tOJAd64Hr8HbC7Itl3YgmvUbOy/WI+cmD7McUnxEwTmoZ5G2yaha9gv?=
 =?us-ascii?Q?YsRFIYtxyubZIBY/kL/AQhYsuVqKSj0Tj7fxgRMewPiGousmIwLsQbSAVRzS?=
 =?us-ascii?Q?lO+9Y+NZHUIp8UcXCLgViTLtWkYlGiEabAHq1yrse6WeGFCddOxWRCoX2kGQ?=
 =?us-ascii?Q?l9BTcdJ6mcSD2Qac+1faJjOlCLM4qSAyJZXZxaRd45D5wE5fgxL1cZJwkHlT?=
 =?us-ascii?Q?MaSIvlelM5AsrijP6sB41Xc9808hB0BZ2pbaochhdxJwAQgs9evqa009IJwG?=
 =?us-ascii?Q?S+yGGvbm9qoAVaQVlUyUiijzaUFS6GgRSOAo7hoFzaFfCTgEJeVlz6OTyvR2?=
 =?us-ascii?Q?LORa6ZAwow+ncZ3EGn4Izs60JVlDoz8oUeoMT7TXg47buIfECVriTfx2usav?=
 =?us-ascii?Q?WU/4VgbfIbV8fizmpfo6jLpTgF8tkH00stc3ytmrt8wp3v3kD34VJ1OcbaUp?=
 =?us-ascii?Q?nBlhLAcuOmdi8Z7yRmbVJOSRaFgVczkNKbjQOruyYBBmDaH8oAlasELCCyXc?=
 =?us-ascii?Q?iCJJFNkzU7/grihrykzuTKx1+FvslGWmSuROHNPFW1uD8u8gK4G8Vsu5ARun?=
 =?us-ascii?Q?WkjJbP/mZxtwu6hNwQtkoLEQ4DTJVTmX0Hh8SfYSdCM70HUx8tgPM8cVlGsP?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a359b730-5965-4a39-7df0-08da60c95a53
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 10:05:15.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U37JLgBnpYfYMqO4UL+t+JBoXnwJHiq9aQGc9i8GP8v1nT1OSr4ClLGs2h5UdpOaPlSXrJgVet14fO49NiO267JQqsjRD8+2yrnA1RGlh8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4924
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-08_08:2022-06-28,2022-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207080036
X-Proofpoint-ORIG-GUID: hvejPhz8HpmVYNVIbrCSUK9GLFRk0cPc
X-Proofpoint-GUID: hvejPhz8HpmVYNVIbrCSUK9GLFRk0cPc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 10:19:47AM +0100, Srinivas Kandagatla wrote:
> Controller only supports up to max of 1-11 device ids via auto-enumeration,
> and it has only those many registers.
> 
> In the existing code, we can protentially cross this boundary and read incorrect
> registers.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: a6e6581942ca ("soundwire: qcom: add auto enumeration support")
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Thanks to Dan for reporting an overflow issue, which turned out to be
> another issue, where we could read registers that do not belong to
> auto-enumeration devid.
> Either way this fixes both issues, one reported by Dan and other
> incorrect register access.
> 
> Thanks,
> Srini
> 
>  drivers/soundwire/qcom.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
> index 9df970eeca45..dd1365a44458 100644
> --- a/drivers/soundwire/qcom.c
> +++ b/drivers/soundwire/qcom.c
> @@ -119,6 +119,8 @@
>  #define MAX_FIFO_RD_RETRY 3
>  #define SWR_OVERFLOW_RETRY_COUNT 30
>  #define SWRM_LINK_STATUS_RETRY_CNT 100
> +/* devid 1 - 11 */
> +#define SWRM_MAX_AUTO_ENUM_DEVICES	11
>  
>  enum {
>  	MASTER_ID_WSA = 1,
> @@ -479,7 +481,7 @@ static int qcom_swrm_enumerate(struct sdw_bus *bus)
>  	int i;
>  	char *buf1 = (char *)&val1, *buf2 = (char *)&val2;
>  
> -	for (i = 1; i <= SDW_MAX_DEVICES; i++) {
> +	for (i = 1; i <= SWRM_MAX_AUTO_ENUM_DEVICES; i++) {

I'm sorry, I don't understand.  Both of these defines are 11 so this
doesn't change anything?

regards,
dan carpenter

>  		/* do not continue if the status is Not Present  */
>  		if (!ctrl->status[i])
>  			continue;
> -- 
> 2.25.1
