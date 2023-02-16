Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07180698DD0
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBPHbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 02:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjBPHbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 02:31:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F4139284;
        Wed, 15 Feb 2023 23:31:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2J3AZ022205;
        Thu, 16 Feb 2023 05:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XfeshHwVPL5ovTh3R61aWoN9e5f4gOHL9kQOfavoTY0=;
 b=N+wDx/c672QAgKfQdtJxgS7zgLtdYHMM52zIkkXJMtMbgDeihFGMIk0NTd9mnAc42ulL
 oP5J8eT5V2zYzWppxu/HzOqlCDAiUQKNF1EUtAbBwvY0++VDquzHj1v1spsEc+ruIQy3
 511ujCCB5kTCSKM4YUL+/lEDnsCj5wg3SgZj2QfkD+IiNsw35w+idca2GOJ+SRwtW8bP
 GVYLnCnWpPVUj3CtlFn/86pPYwS84IpWtoh/55h6FxfvnQ0Qt/n4ENJH5dRHoK+DJsec
 SP+deKy0L9bebEO+eZ6eK0btuWUYsjJkLriPw9D9LGiJBHJIzUUEsYdnvUKaQS6y0nnk xA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m12anq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2jh0p015210;
        Thu, 16 Feb 2023 05:22:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84b4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HG85cdXLOjFW3jTK/EVG3XsIsteLiMEKNHPNmCukh3JH2f41QrGvuM8yEki/SgiqYopdF4C/Nu8/2G2khmCj1wAhz4Q1ow94Tfir0UowtOvUEaR0+c6ncdqQo675CcVAULOsbs+AANa4uyLbLVhkLlsswpQsve4YUEzlPpiWw2S27/FaL/FjuE0JEz+mC8uQP2fSVbG4kPDmKFgFyQOGWaMKLQwEuvg+D+OIlOzsdWNqjFl/WBeOM4fY1GOEcn/juDOOW9ssy165ntmQ4u1ylQJJNPTtX4rzk2yX1rMYnaPmWHV0R4pZaxiA7cqC1pM4i9Cn97VMOqChcq8Mr+GyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XfeshHwVPL5ovTh3R61aWoN9e5f4gOHL9kQOfavoTY0=;
 b=kv43oV7wRe5IDsfa0HFty0DXKjtKdNUS7PU3UpOO4LMlz8m6TaZk8+DNG3gIW7rzruvV71H9DjoFsJOJFGeDCGsheFo8uWW5HJLndFh6UpkKp61Qy8+0sdhTHSI6iuK57w7OvPkaZ8X2h0F2Bbu3F9Ygtc4LwtjTDt7+iimRex0Kde4BqUYy7WLqYWCeU4uKMkrYhRFkbQK8NFkr9azMTj5lu1+LSa0sgDecPZCOkhZI3K+L9JIgjyoZHSnrRgEECtTiPS394NO0qCsEMrcPo+PE4nOVMhLhecYyFhLjfP4TKjYvSsoeRay4uY0KROHtb6RpOJGYOUWGuTlBQYEJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfeshHwVPL5ovTh3R61aWoN9e5f4gOHL9kQOfavoTY0=;
 b=SHbUXdrGKZyhMUkq/O+u1qQolSOYx8V1BDSMRZQgGxv/k1FrVZpu0VR2yNq8eM9IH+Bo36pGxsEQyD6OdoMHElsKZ6O0gllvz3f+4f/Jrx36mrfXxhQi8m3vEL5SraAGrDnaTOkeCHZFP0fEZQimw8ucmR4R4u3WgnpB11vSPA0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:22:09 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:22:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 14/25] xfs: clean up bmap intent item recovery checking
Date:   Thu, 16 Feb 2023 10:50:08 +0530
Message-Id: <20230216052019.368896-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:3:18::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: e3c4be19-f75e-4ef5-4130-08db0fddc038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bgh2wSHo3Mqxwatkudz8tZ4fN5UBl5NzBucUyNslTljYtzvQKMI2hK5lIPQKcKOvlRFYic28cVc4TXbXXJYnXcdDWeH+wFry6z2L9RKOKQt3hoBnd2J4QiW28+POlUcodWU43xnzuHaw2ObKpiRHZGbwgdCNiWYfSH2Qdky2oiZyZjD9ZaPXO9leWnxQsvMi5H5NV2NQgbPm4vbe8/b5B0oxiFghPUptIf2suBkbBBTo5+txnE/DybKx0maUNWAqBaanwu9YbKWRb9WujSowEZFAmjaRGDEUXmanA4lbaLQO/KKWp+e5HJfeHD2zOaB14FEuZ8O6v0yfPl562YwZ95+9vCQljAbSFTnAkJkylne902g+CN6ybUTGWyvzeKDalJiNp5kaO8g8uebDub0CgSMgKXU8qhWpwhQtthH0gryg7MZftmoRJe3sINvu7gizjsza3Ei6JPa+q2db6cS3v1lwJAlhh7/PesBKyxVp+N5piSxe7aQQfGjLsSV4ukkIzHKCrgx6z305LE6Rq4xvAgiqnDleT7clFV1gV3lPBFH7JR4c2YN2Pm/SnWiCBlxY49jbuxUP4I0X1G75mH0ocZjq7tI1NOwC+UhaFDAddkoHYMB0vUdt9TEgoUxhC5LwRq80ZhkKspG9albcTsndTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SeXGKsFyCF7nGHLR5TJd/pmsLDEFv/jH43F3Q+/KwqLS47tfF2M21Zdd23kk?=
 =?us-ascii?Q?IlO7y+cdAzoec6/oTMszZG0Y4l8CUcLk17gl4nYtVdKAyis/Ch/pQ0P6ZJP3?=
 =?us-ascii?Q?niV5LMZ8oW2Q0GONpkA8PvPM6QkGH1ZPbKjY28VvECIXgnaTiuWcfdiJ/h8s?=
 =?us-ascii?Q?faCoX/Wes4bwAP/IERstVoL7p91EXrZbnM92EVM/ZOMF2h/Lr8R8e74XD59V?=
 =?us-ascii?Q?1MSLzIAYIg7Kaus1mpbMp5YBd/IEgsCPmLl95+UHLp666Hrm387xxmZ0rJVD?=
 =?us-ascii?Q?22UIBQuQVjTv1fRexF7mEfEE4KoAD+NJj06+ttacUlTB+tTyncu/WD1kJdu3?=
 =?us-ascii?Q?cEPnW4olMJCuOjgS6xlmv1zncMq2PwB21siTFN8u7Km+0aENa84hAI9PMR/E?=
 =?us-ascii?Q?NvxQEomty1+Qd4M6DNNx+uvMhyUpQwsTeEOFzYNh4H8MGXETbM4I7Vbsxuxw?=
 =?us-ascii?Q?+u6I7P248ivHBtFGPMthC9wf60lEPm3jdvOZmvOmkCDgSZ4bjeiLk5G3RO7E?=
 =?us-ascii?Q?XBEWSA4g8xvRmTWxjOZhMVjryPE54Y/l6vEYYhewrdEXHwrratv8irDAbPYs?=
 =?us-ascii?Q?RF41hdACPVgRjzVOdw/nj9gRCz0CeW90g3AO+1c4/bDrJmNpY59muH8cAjs4?=
 =?us-ascii?Q?x967ZhUF9hcuYWyy4W2u3kZhXcS6g32P9Wf5BYN95nYQKw8z/prVTvjdmca6?=
 =?us-ascii?Q?342kt8Kt/R+vf+feQVqB+SLbVE+m4wGTaDp3vExZ8PjSO0dzcsZGsHcx06mJ?=
 =?us-ascii?Q?V6wQpZDt7NYyCS6/Big0FZt7wzd0X0lNDEAu1YdYI4qR5YLBnB1YmUndVGSu?=
 =?us-ascii?Q?QvuFT98D660kZvjprXwRtgR7pZaSl2CJwuwG1bLpj4ZITE2IySltUaWoNmck?=
 =?us-ascii?Q?3FLdseAjfW+LfAY1Iu5Gd3VlX/lYNjb5dfJehsqMaZWVZ54ecYCPPM+KCbSz?=
 =?us-ascii?Q?AWsBWSxJBgEVS7611wSSyhbWdf9X0BI9pgEzDRn+oyReidjYxWgSPKZgHW+w?=
 =?us-ascii?Q?YhOklCS2eHePAevAIO4tyOjdBawpHQRGIz0vcbHRCXv/KtH4hVoTvhS5dDkm?=
 =?us-ascii?Q?PeAdNrmCcuk3tNg7uPBUTfTJg2P5F4VxtWtoUsTvYM3KQHE2gLJ6cuVWQe4y?=
 =?us-ascii?Q?pwF09CHYgTtViX9xRybLAm1pB0MPyz9Viu7FTx6xNgwduVOb+nACSSJMoSI0?=
 =?us-ascii?Q?5egDsid+UZHWkjxDAJGFs/VssjEJhy6tgFdx2kOy4NGpaYUMtaxyHtNAq0eR?=
 =?us-ascii?Q?JYYeOE4r5jPmlZPnS3pTbpES0k2Es0NDWf4m7dL1qG7dfsbxeRqQ9HRDAc0g?=
 =?us-ascii?Q?9w1gBPeLO8j0WFsxtbdVKHOa+g9LN+W61oqdIHsj0NXi6l6vTcrZnM8UNI59?=
 =?us-ascii?Q?OSlM0pjQ4XM/l5auI/X/NHNc7/WWaIFCn82YAueUTfEoBYHIZOwKr3J5HqHd?=
 =?us-ascii?Q?Cv0QG1HAoFWVedlqt2E9wVBQIush23MDyDAZ1eo4QK5c7HUbQ/3yKgPEYsrG?=
 =?us-ascii?Q?IkqT52PbE0q8Ul7ts2rVVcsRPjz88uJnP4csiHd9btfQsVnUvqMV07wUyMHU?=
 =?us-ascii?Q?qOzW0QW3nYe+SYWPIl8h8dV3wkdIxylM/J1VFONmGNE7H06/Q0mV4OQXcVz9?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PU50g896aw+hJEWn4frwYlqwgrjnU0XJw4ODi4KkKW4rHFBXeUcNr2MX4nF0FuROuqj2BMBroINEIHRYX6crUL7RhaAorpQ9oazKf9SQYHu+Y96ok4VydeboIw7gQTYnRWrTRn03soE9dJ5tz0P9vpAc+O4aAn93SART2Qr6YUhXW7TG5DYyEn0nAV03+0DLt+jON++rnWhpliY0nUOVmkeGBKLbtDPTgZ0XV+H9yWQ7eGbmmyh+9DwRUPL6DbZrn+s2VgCTPVADKyAdid847VCzn9lPcI6s8K7yCQHKm7UxVUbNx5belArdPC389mPQLVjCdr9UFlfUNWshKgINezIXTBzD85XFzwyPr4o6GfhGJ1faOON/YrWK/76UOgVG4vdn6mQmNa60AEvpvHqWh0cb3LjKX+rxFUbAKtIE4/bOqHcWiUg8zS1ChYlnzmXji2ryXJKpDc/+6RNVWL6wMOh1h09+ToFaPIdZNZUeeYUaNWsUTZ7fOR9wQK3vl0ddP41C+263ru+uopmArhJduiFaubOmZ3fO4ql0EuiyKl5XY17HVrBgqFPHqY4fxDfDUrPRC2yJHapIL08L20v8JxoyaKmbBPfzngy59hCod2/0qujKc36EjlyTvUoP2v0B+rJrBMZcpWaYBcv/0lVFDrJH35Lf1dDFa1g1Z+5AcDQf620WgUv8pIS5fb2YZCAOCD65tXhbCcAGlRLWehmQCnT0TGIorpJ8m+kE7Juw814VzUdSquMPAaUhgRi1s/6E8eORVwgKiclDhQJrSHwB8I4HOIcIXExhqDuHWA5/fjH1y5g2sx/jrDvS9700LjfpgmF9PhAzMw9OtqlsKEJUcW1dAPIbEYZd1YdBpWeid5jHTrlgZ7bShFhLg1AMKH9g
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c4be19-f75e-4ef5-4130-08db0fddc038
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:22:09.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2OZrx//5qGBH8TqcF3P5uvAZA0WCv7hjRpTaqMHyMPCu3SIFHFx2Gn39coh8J/SDLJRAF9XpFF6WOOkfZ0Ksfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: toY1yZ5XMqvxG6iu7fdanJQwKGUcl5U1
X-Proofpoint-ORIG-GUID: toY1yZ5XMqvxG6iu7fdanJQwKGUcl5U1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 919522e89f8e71fc6a8f8abe17be4011573c6ea0 upstream.

The bmap intent item checking code in xfs_bui_item_recover is spread all
over the function.  We should check the recovered log item at the top
before we allocate any resources or do anything else, so do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e83729bf4997..381dd4f078b0 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -434,9 +434,7 @@ xfs_bui_recover(
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
-	bool				op_ok;
 	struct xfs_bud_log_item		*budp;
-	enum xfs_bmap_intent_type	type;
 	int				whichfork;
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
@@ -462,16 +460,19 @@ xfs_bui_recover(
 			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
 	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
 			XFS_INO_TO_FSB(mp, bmap->me_owner)));
-	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+			XFS_ATTR_FORK : XFS_DATA_FORK;
+	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
+	switch (bui_type) {
 	case XFS_BMAP_MAP:
 	case XFS_BMAP_UNMAP:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return -EFSCORRUPTED;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
+	if (startblock_fsb == 0 ||
 	    bmap->me_len == 0 ||
 	    inode_fsb == 0 ||
 	    startblock_fsb >= mp->m_sb.sb_dblocks ||
@@ -502,32 +503,17 @@ xfs_bui_recover(
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
-	/* Process deferred bmap item. */
-	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
-			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
-			XFS_ATTR_FORK : XFS_DATA_FORK;
-	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
-	switch (bui_type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		type = bui_type;
-		break;
-	default:
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		error = -EFSCORRUPTED;
-		goto err_inode;
-	}
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
-	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
-			bmap->me_startoff, bmap->me_startblock, &count, state);
+	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
+			whichfork, bmap->me_startoff, bmap->me_startblock,
+			&count, state);
 	if (error)
 		goto err_inode;
 
 	if (count > 0) {
-		ASSERT(type == XFS_BMAP_UNMAP);
+		ASSERT(bui_type == XFS_BMAP_UNMAP);
 		irec.br_startblock = bmap->me_startblock;
 		irec.br_blockcount = count;
 		irec.br_startoff = bmap->me_startoff;
-- 
2.35.1

