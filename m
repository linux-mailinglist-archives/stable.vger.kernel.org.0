Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7E41B21B
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 16:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241266AbhI1OcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 10:32:06 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:4676 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241265AbhI1OcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 10:32:04 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SBlrCj009420;
        Tue, 28 Sep 2021 14:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=i3AyBzlxIGI4R9Gqy6TT1dJNTgNovHGeqZDbMNKRQDs=;
 b=QKimlUFJoazp4kuCaoszN4d634KSzNGo9go3vqa+DFJdrtjIxEbkirLGEPWQSXMTKDXf
 JHBN4eS/WyxjmTIvU9CqfHsZWVtm1KmFwtaK1AYlJtRqkaLFDk+7QZ1GlQ4SMYpWkBa2
 8sUcGBkgEdCp4GoshOWwuxkSWEqWXom6YLxDya8U7K18DbUf2ylsbITAA6OO4vV2wpwR
 9DYfJrnc6c5M8KO1VzA6ylqhxlcjoUeUhgtRgaRCnX+6abuk2Wzv8Iz1K6wbPygXaNIJ
 HT1t8WSZc/7AW0+DMuoStUXLnwq4gmbN9I0eKxA4Fh33f6P0JbUYOXBFey910HuNZXwb Ig== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc0qfr7sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 14:30:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tmu04HTAGrGj5SksCTAjQQ0JkOvAT1gTxIl7gb+3Vi6+Kbxhcxp2jVanTPHeE1unFXH7IEjRtzYhiCkzb7lqiCkhwEMNIaqoVn+6JaN5QycKssiQf6pLAa3z2ugQLJcU2MbJub2kD3T4MdZ5tCZqkZFSToTC4REgXkwAgoIcvTT/Qx++Xmi3CDRF0bxK1T+3hy7Ynl18SdOteaG8st0DmJsPZzm+lew0uknh3kblfpM4XpYFx+k1gGHNU3M+qKBQdSJv28V/NFEkgMxwfY8jf2G95Ma+xFgYQwiKY2hCxC28MJq6vIyBBpPUuiLXPa8EpYZUAJYkjhzXE8STSooQQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=i3AyBzlxIGI4R9Gqy6TT1dJNTgNovHGeqZDbMNKRQDs=;
 b=FqMAWk8IgpkJfr2oaUlXvOQA+Klr5uEmiZJErLN++pDncBEcQxFZ3FGSP9mtn801NmKrrIjlzcg5YbvRkc3NwRzio/tl46fmM3hEzaUMqSUHoQ16QTbwd6pjWebBsJ2LhADTZIZrKKNcO8sUtUDZKEXLWD+seu5diRJlEp7QfEcZSXXIEgsto8xmU8r3xZcvkl/14TUFk/cQDmaLt+hYsg/2kRy9GhW3k4BC49mTqUZzJIiefDJgxlCBLphFm/ge1FD1QZ3lX1aNAHo6QAEdhTL/wYILv8vmGfUxmgLR72F4VvDVyqItzW53ZcHoInOrT50Z5gl+LnnkBBpH8H/y/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2681.namprd11.prod.outlook.com (2603:10b6:5:bd::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Tue, 28 Sep
 2021 14:30:17 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 14:30:17 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 4.19 0/3] usb: hso: backport CVE-2021-37159 fix
Date:   Tue, 28 Sep 2021 17:29:58 +0300
Message-Id: <20210928143001.202223-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0028.eurprd07.prod.outlook.com
 (2603:10a6:800:90::14) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0701CA0028.eurprd07.prod.outlook.com (2603:10a6:800:90::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Tue, 28 Sep 2021 14:30:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7df4a5b7-118f-41ed-78bc-08d9828c7e35
X-MS-TrafficTypeDiagnostic: DM6PR11MB2681:
X-Microsoft-Antispam-PRVS: <DM6PR11MB26816D5878D54046C1C1133AFEA89@DM6PR11MB2681.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:466;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUjizdsL2BAmxCtuwqEJY5usckT3G8IRLrd5Zu0snsM8EBtzzTGi1uTCiIpErd7WWZblbD/NlfrpS5IOznkrUQ3KjZ7TkyyI/i2u42Caz1/LQYlbwcIfPseSz+qFDISRExgf9y0fLAUOES2aUl4ZE9UtnaI+tAWlozVMTKaV/uEiAF3xU65sxHdkZQLhuL4qV1EvWmc0lMgKrHJy9LwGvl3dd9dPLvi748J1lR9pi4YZfq+jQHL0zWxhJ/BQFqeyCtDTu7eRf8aVar9jwDsJpgPopbTnNbWiN+o9ZO9wfkBG3A/vk41p3WIYXJ+9j57z4A5eKpssM/GjrjzJm+QS4P8wQsrqUOKaRt67OM/H3CNknQBqA3Jd8oDyY6vzsiVZZuIKNAKtyGZbixl3q7zNB+wI/u72nflCkNdPwVUouX0OVEHzITfr78BOd1DiorrBVqced4NGS3ihz9O18X3ZxcPyLuBVpJm11g4+6MVKwEKNJe2N3upVeI4l3WkqwjW+bg7uCUS1QWq+Ot2dt68KtOXPMWJIPyqlJ5IaHTheWpHi7JnvFqSglQ7g4zVNDvrRf2BD7Rbe5hBH2HhMuzoR9qbVfA25t9TL4OPpauTcTzg6xu12J1u1V6GGt15YqkIOmz3kFWUiMkJCfEKF+nMsL3y+eGE2begkuz2ymtb02DErrzwPu5T69ew98Dy8i0c2EKb4icm+0ifN+BYaykYgSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(5660300002)(4744005)(38100700002)(38350700002)(6512007)(6666004)(8676002)(8936002)(6916009)(44832011)(2906002)(1076003)(86362001)(36756003)(956004)(83380400001)(186003)(52116002)(4326008)(66946007)(316002)(66556008)(508600001)(2616005)(26005)(6506007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pS4ZmUX1crqgfpygYOuKIEK9PIzd+HZXEH91T0jxGeStegtP2UilyahTfpSY?=
 =?us-ascii?Q?gJwoPTPNP6WvwE7Nz+8GvKEQgE448oI+SQO6zMCNbQfHEvQz+97mfpgR5ka0?=
 =?us-ascii?Q?ml9kdZ8nzQtIDbr+4kLBffuB+f3RCrL1zexOpAY6DlEVYdnhqofmo2kUTvyF?=
 =?us-ascii?Q?Za1SuxlniuKwsXr6hzemB+Cx2jkVmcbKs548r+2sNaV6yPHyFMZmksofrTjA?=
 =?us-ascii?Q?rG70dYLCHYd2yiBuY17tyhv7Txv8JC+Iwc13Jtqtb3OmgC73kc9kO3RBHKOD?=
 =?us-ascii?Q?ZJZ28GSGrhDBGUKMoMNl2e1OhHRfd2+/OUwTch2SSe782gAnvNUBk7shkiLi?=
 =?us-ascii?Q?vQFnkxi0NtVaHW4q2D/jQC68G1MPBqI/T87cxr+NKbp6iq/w/mm69hx9582n?=
 =?us-ascii?Q?PkSxViTXaI4J4v/asvMHrktejCbebEP2ttV81xHAuk0wDjnLB7662tHnsev3?=
 =?us-ascii?Q?5UOCXnrZ8Rw/0hAeg6ahRjeKAF7BKauzULQsCcCjA60Ca8tSCn7irsn4lGuO?=
 =?us-ascii?Q?NmZ0JlA0U3M9urr/cxCqiRLoBOQQwpLx5rMrtmqwfAOjTA4/F1EuAVru7B8n?=
 =?us-ascii?Q?c/Yp02kxQ94qmcFcV4gvACoFy1IN9kuXyKxiBNR/gV+YkB/FHzX8dzImAoXm?=
 =?us-ascii?Q?xyURVlKDu1VfSVACJJIyOYt2q8J4oNqUtmnbDOfmAPUJ3GMPbBROBZKsvUg/?=
 =?us-ascii?Q?+/CHpviGdeReJeS0K9E4DNKm1YtNGcMjbCvsJLNVIqy9dKPugbQKD7k88hJo?=
 =?us-ascii?Q?zBMeE7SvjomixsfQs1+sBz1L5X/aBUGOGE1Gx3gdkQAuwG8N3PYJvT+A2VIB?=
 =?us-ascii?Q?tnOr0i0WrHpzf767xVTMDlLIpJdr8MYkkkvZxz6M2OoLHzdc7nXfO/JnX9xD?=
 =?us-ascii?Q?9XW6ieJv4OKRRguOJQ9tLOEUo/+b2muD3dnRm1sjQZbWR4eimvpfUNTdXDua?=
 =?us-ascii?Q?RRA11X2Cot/62JL6ZKOrxqb1X16pXFWKWnRRF8trqTyWwW6ZOaY8Yk4KKnGQ?=
 =?us-ascii?Q?dyxNr7P/5bP3R8BSicu/5d1yFwhibAWd7tBUdq1I+VJqUQZVcq3O5LeTHUV/?=
 =?us-ascii?Q?czUpCd672px9J1Syak2vbo8tAjSXZ+5BMAPMDlhCXXsjVwMMQXY/BtgZFYV/?=
 =?us-ascii?Q?/fGjNX8LEpu6IdsRMCkvLoTVJnP1jsEzcXq9OibX4t5KSwawPTO6PEmzUc69?=
 =?us-ascii?Q?vKvD25S27D4JtBLExJhta5KKaaGBp8Y050UdnOg3/k9YkqrBey2ldN3R8CDi?=
 =?us-ascii?Q?yuRpTQT+SzQikP7b2VWQdta0GoBKVJNcAAfu3uGHPDIJBMxtH5YsRzej+BMe?=
 =?us-ascii?Q?Qy9zF9F9Y4isoL7PC8zAoWw0?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df4a5b7-118f-41ed-78bc-08d9828c7e35
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 14:30:17.7188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xC1GrUNctLNBmuJ4CZBdTSGFdhzg+d+pIjo2C44c4OUtQAjyFMe7WpDtYWyjHDS0SGRsZ27skUyEaIQGx+3CHL07RerKAewu9odzQIC2Hoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2681
X-Proofpoint-GUID: 6rJ_Yx9hchfhdQNPhhaZ1m40Nrd6Ff5a
X-Proofpoint-ORIG-GUID: 6rJ_Yx9hchfhdQNPhhaZ1m40Nrd6Ff5a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=411 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280083
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

