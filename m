Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8B341AFC0
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 15:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbhI1NRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 09:17:39 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:1746 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240632AbhI1NRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 09:17:37 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SCUpva027768;
        Tue, 28 Sep 2021 13:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=i3AyBzlxIGI4R9Gqy6TT1dJNTgNovHGeqZDbMNKRQDs=;
 b=pnRAC7GxNScMUXVsGEDl66lGvksyei7hiIgsFftC8mYgyUyHRaUKR/niG1DINrzjt+uY
 M7GQ9lLiiwMUqS3XHOlQi8oMAG4Xwpq78kCwWeTVNFLU4gak/aMkkZeMlzDBy3qJeDZH
 kNDaQWl3W7BYZcHw7R09PWNCwC1XDPry9HWTmeIHHq2mgrGp6pMhmPy41iGStQaVqBll
 poz7I2Z39XRDvGtTbfjk0XDmBf7zn3PDeTlaE+rTQhpnOVKsi+wJLJlg2+/oIIfpL7jX
 RYq7980i24hsdeSD8HmK0kvTF4Mfu0br+8E8BvIDSTqY5fHSBkfTedNyVItTpIxgYDml Nw== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc0qfr5ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 13:15:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdFCinQ04vIKWDNM2hFSFJSjxiGe1mha+BJ2uv/00Av7M8flfzTm9tNg9wV1I3R/+V2FRVvYK577c5XPEFuccUfFZvOuMPW922IBHMZYho4N/GHJCdbeOlHa2/KU4JgKTVDVjxefqxLcSAWNllDRqtM11iSuuC/DTgzJdAPbeFjpvKzOa1IhrhmioHvZknDON6CKet53qddBidD2z+UlnZB7uSVf0pNndkHAIqy6vfqChOrSoNOurYFRrOIFVqUtgg9vdxXPeFz4iybOohIJ/sUvsausLQMsgnhSJu8IxPJRnAQLgm/jgxDY1I6xJN34yvx29GD6FxFy6Mh6wSnRuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=i3AyBzlxIGI4R9Gqy6TT1dJNTgNovHGeqZDbMNKRQDs=;
 b=e4yUZOnQSARF+BlPLyPQGA3bafTKx4AxgmrKt9Zb8vVb+KMtQ3m5HEcJo6bdg51/VWj7EBQpvbnZ3UFwWNaOsN0vlWplFkRzyqxNHyZoYCstCtsig10QKQGtpa0BeHzewOzBRC7miwhP919XQ3OUlOfxx7YX8QyNwwGWUL9DT3ZZbWtZpy5dnWS49kNqjZzP90Gd9irVYof5+1oM/x95wMI5BZXqGlkNvhtd9aKUbelWS30jNsPoWLdofthMUuCI3bIi2Fx3bcyPd6lsSDjzzUI7iV8HmbrFfBVtYiDkHTPin9ydTbAQerD8joDvsmp7QrqxNiUfG9QAs2/PHrlYCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 13:15:49 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 13:15:49 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 5.4 0/3] usb: hso: backport CVE-2021-37159 fix
Date:   Tue, 28 Sep 2021 16:15:20 +0300
Message-Id: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0073.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0801CA0073.eurprd08.prod.outlook.com (2603:10a6:800:7d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Tue, 28 Sep 2021 13:15:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c2d2fc5-305b-4346-e078-08d9828216a9
X-MS-TrafficTypeDiagnostic: DM6PR11MB2841:
X-Microsoft-Antispam-PRVS: <DM6PR11MB28410CBB78E0F393D4A4A025FEA89@DM6PR11MB2841.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:466;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ltmSe6wC2wFwIMRkHZvGpwOwoV7afytaFtaoW2tTCiDWLoudaytbn9x+/2G4JMlfPeofEqqwlQW1pBI1grJqY92N4knJok8w/PwPE7oLpmqtABEYyz2qRpibgQ2Ky8rbE14KSLC2XUt8x/JTAGJN0cwpAATVHAn2LuMZ8012Wh1SHuqF4fn9yxWPS3I1Mt5dDEV4X1pWF5FLdCOmt34KlUAL9j6ksaJZcPXezLK75T7zcVYh6OELZAuy4C5i1M+HOU0EQ/dlOLfc16u4F9eXaUM0BXgrwK+6wYmjz34AmuyZtUY12pbYvyT9WitXsKY7qsFwhr09JgbZtk85t7qtrVvBTepui5Qi4lbvaWIn9rnNqNd1veSv2jdWRq3gAyELXPcEZO3+VomzS/ZkFYHY0ntqQ32EgSpy+/EzO2N1waZtXSGCpwAs3iFLpeBCmYUy1uKU/AU5rdGO7d+WB00MBrLYeSEWFXy7l1QHdytcgPLQdqCDEF/aG49qH7kB8bPpFLuGwvAZG6OZ4PWdfiLftUXBRFHma3x4gVA/kHJ7n3N8sa7ekwaImXUFEHIrRnOSqChYZs6q98ka43XwzCeff6kTogUe433MY7mO6hkck34alKwL4l3PFpNBVogza1bKFPfUn2AAzx9cjkRNT6WqeGvJTN/QetiidHS8mtAXF/eXayFDbvu50PVwwK1S+BBgJtckwIBYREJHccvjVkvLLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(38350700002)(38100700002)(5660300002)(8936002)(6512007)(8676002)(316002)(83380400001)(6486002)(4744005)(186003)(6666004)(6506007)(36756003)(52116002)(26005)(44832011)(6916009)(508600001)(4326008)(66476007)(86362001)(66556008)(956004)(2906002)(66946007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I48gscwgzdfmARQy50tWSeJHHBOOBVQmZDioaXf3FIAyrhaWyR7yxnsW7KRF?=
 =?us-ascii?Q?+6lGvP5PkYcUvGUr/CW+Sa0N8HyCJkXxFxOe6Sg1FjlCMs47Ajudpj0bItmG?=
 =?us-ascii?Q?Mw8IyoxVg6TcxqbZYlFCKnqBKcaZeoxRdFV7GdoUHV3QSpwhX441lJDPSZbE?=
 =?us-ascii?Q?MOVCM/guoq88s5HFT7xP+qPp3qi1kloVJWs5f/M3ZHMYZ/B6ngdwQgnFXPWr?=
 =?us-ascii?Q?ay8zRQFu+4FTUH/EiHtomzB2NjXkrY73Lo4REh3GHD9SR4X2rw3rR9O+hFgH?=
 =?us-ascii?Q?bp1D9SWRIzS9hMcj01yCdS6t6ojSKXcPTDgaHJXzsiuBV5/luO2G3uVUFmOg?=
 =?us-ascii?Q?YLM/awfEip6ze0mBmQeRwS1dw7j7plrtZQY8BGgxG1Ce/xTvYDx6Ig5aD/De?=
 =?us-ascii?Q?nqTaJojYgiNxWEHa8yViWp3+PmH5Yd/nUTUkoVW3tRhU7j2cCQt+izO/EVzI?=
 =?us-ascii?Q?esN6v/1VWhecsWZTWUAVQf6aL999zpRaWEBdaCwcORto7m+Y4mAzMKmU9bXy?=
 =?us-ascii?Q?XX4de9CXijOqguaNbPn4n71aschDw0By6YMY/HZUbXuZV9U1W0E5hM2BwPvj?=
 =?us-ascii?Q?vC1PorN/aSZNgnwDJ44kjqx0Of2Zoh1Uw3HzrT5lcUqUz7BFAkk7Ti5jV5tj?=
 =?us-ascii?Q?SUxDrsM56X+qKgH20rLFJj8Itf2KkTeniiIJuM6/3jssMa3+OKYb2VdDfP9S?=
 =?us-ascii?Q?eVCZ5dJQ2ecyHEsE2jYgaq23J1axIKDRmRCoibDsMXHX3ILaaaE08SJeG2ZG?=
 =?us-ascii?Q?LG7UN0mGlMth261dRZb53ZF9Ckc0/TT2ozPL5nvxOlo81AhLl1qa6q9SX1pT?=
 =?us-ascii?Q?d5fDYMw9SFJDiggVzcE4KuM3/g5D4sDMnSLhEXhoWLuuF3Mc2X6VF152HQM/?=
 =?us-ascii?Q?FaEdHIvsG09XuZWbF+StNp7cp6GqrtOwlXhuUhcywL6itxZ5YTed7jcfapnQ?=
 =?us-ascii?Q?7Hp8KCWm6JarB/DQRBRHx1YX09MKNNUPx+n6BhK5+x1LLohRZMFwMfCjDxGa?=
 =?us-ascii?Q?eYSMyrE5eKAd1xl5dgvNCjFv1qMLHKp2LtHEo+nDB/eDOvcvgHULYq/JYo0y?=
 =?us-ascii?Q?VR3ELf96OzRwJeHB4LIJUNAlvMrji6lo6J9S20tCC7cdMOBHYhhTP2xFl20A?=
 =?us-ascii?Q?oinaxuzxHh7OIB4b5E7cZuEOTbxxbv1NpCDEGMmYTAhsc5TceyVUlHEOJSz2?=
 =?us-ascii?Q?22OtHqkrCC/8ltXb9N2gD+1W0IdSGAFYkM4VywBObO1oTxmn06zmls+LrzTw?=
 =?us-ascii?Q?ZC7VDXyrrERj03kmIHiVhekbOL7o3C4pmQoEyA4EgLK/HJ7MNWUaAM2fyfyI?=
 =?us-ascii?Q?pWlCUcOokzNiF/stQ4x06OqP?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2d2fc5-305b-4346-e078-08d9828216a9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 13:15:49.0950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IB3lVJyV64WuV8rYWEvRkGOWTDdJqQszhekNJJjF9FQQcsiTWOK4W/ikkzr/YIJCjnXa2ZD0TOqKTwoj9xcLAKnZzvHXfBJjs0p30rOHK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2841
X-Proofpoint-GUID: Y7z6bmu1w3CZcJqqIkCDpr_9AmgD9YkG
X-Proofpoint-ORIG-GUID: Y7z6bmu1w3CZcJqqIkCDpr_9AmgD9YkG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 mlxlogscore=411 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All 3 upstream commits apply cleanly:
   * 5fcfb6d0bfcd ("hso: fix bailout in error case of probe") is a support
     patch needed for context
   * a6ecfb39ba9d ("usb: hso: fix error handling code of hso_create_net_device")
     is the actual fix
   * dcb713d53e2e ("usb: hso: remove the bailout parameter") is a follow up
     cleanup commit

Dongliang Mu (2):
  usb: hso: fix error handling code of hso_create_net_device
  usb: hso: remove the bailout parameter

Oliver Neukum (1):
  hso: fix bailout in error case of probe

 drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

-- 
2.25.1

