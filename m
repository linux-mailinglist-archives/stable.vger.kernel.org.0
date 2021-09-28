Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641E641B2C5
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241399AbhI1PSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:18:36 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:23994 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241455AbhI1PSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:18:34 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SEbVuC013175;
        Tue, 28 Sep 2021 15:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=i3AyBzlxIGI4R9Gqy6TT1dJNTgNovHGeqZDbMNKRQDs=;
 b=Yu2JryTEKSp9fs2Yg+uAL2QKi7Jh4WCLXCZEvCwWomXLjBiXzQ71Ej2OqFW+urytYzd4
 LR61ZjqA9yxTlzYdteSlsI80tvQmAOY44TEaQUPgih5G8FMQUIXam+Ca3snCjWXBNoWA
 EV6SLDsURDy6htohegA7u7R+sA4/QomHM48p/XXChAE2qNXlo9hoV2DdQm3qiF/oU6xd
 m9VpZx1WUJ766GezO+lUiUdzNhqdMmY7YPXpnGQlR7dUATD4kxKSpYWKM51dKP3B+r3v
 8/b2d+6MUQQYWv/vNHSdf0ecJ7Ah+JBP7KhK760oOmW8I1XUREbLDiYrWw7fwLE6j28U /A== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc0qfr9a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 15:16:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzRElT1Mpc28KDIgmeGVz+mY0pUh8zN3FiAQO+gtCaQlJGAK2RzDoHrqfzWwodUccsTfxEuEahvSvXK1hTPv/+DVFoqLOxGgH64KjMIJFc3MC+Nlpe9wowH7UIEdKVJXl30URXLZPSN3h+rzDibOwQ1lKEP899BOZRihJVIZ17p5dvE37nsS9tVkdd99ruCKDuPHHb98/jut34DN/29/BPfdMVEjggzhDWfO9KB41jAepiANxX43CUQ/OiiOh6i7zFxIIIR2tJZEkMnRY9v8ifqqJX74KEeD9ANROsWXkOFR3QBqOxZtVzXCe0c258vPdhLwj5NZOAIbeBzo1s8gsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=i3AyBzlxIGI4R9Gqy6TT1dJNTgNovHGeqZDbMNKRQDs=;
 b=k+Kn2/Wsvyh1N/XjkOJaxhf6rcVcp4pVKsLLlou2BRwcfbZuX1AV1tHNokpzkCnCf2L9A75tYZ6mMrYbBHpCVGIZPq72LSGRC511kJBd5Xb60CuxeHTmDaJgMHY8jkFlg1p9kB/6TNABPLTepY/xAdjxYeGpKE7sXbqv7ODQNpMluqIcHOClkgkTkQMc/s8IE9K+5PBpRELH3muTnLxqLZxXxGL1sOiyL/PeJefuXMVn7CLDdKg08Wyt4JBtNQVXDiTQead0Z3TFuU/fh4jhOijqJ9G1eD+GIpfZ9Wu014BeRkX2yCKfAEYLPcVSFUGDHKwl25U3E71yAT3Rv1cgHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3609.namprd11.prod.outlook.com (2603:10b6:5:140::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 15:16:44 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 15:16:44 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 4.14 0/3] usb: hso: backport CVE-2021-37159 fix
Date:   Tue, 28 Sep 2021 18:15:41 +0300
Message-Id: <20210928151544.270412-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0019.eurprd05.prod.outlook.com
 (2603:10a6:800:92::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0019.eurprd05.prod.outlook.com (2603:10a6:800:92::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 15:16:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afaa61bc-e9c9-41fa-1dae-08d98292fb63
X-MS-TrafficTypeDiagnostic: DM6PR11MB3609:
X-Microsoft-Antispam-PRVS: <DM6PR11MB360904B6B504187019A13767FEA89@DM6PR11MB3609.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:466;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3HsQMiOzi/8F2Ex3qxjeDABqxdHkgl4X1QokwtLl0ClSssQ10/69miaPcZKVcMy03vk+Tr7QMvWxnbeH50RP39slqpJNh6fOm6KuTYoKqrUtNK6gFZO3yu0O+pryrPB7aLwtAgxnzAGaKEMGF2bXGF2aS3OHyS2wQslO7/TrJHB4cIbzf9byII7GhP/TQFzrS2+ahocH4HdTOv91EtnhNaY48Xltt2lxxIDhgOdkqt2eYGeQa+FylEEbjM0qrJt859lbbnre36jYjvx7coFPDBvs5kKqlH86hgNtyR8rZ3vFc1cCYfoOv8idzZH5GIw9qag0aTbmiin0K7BfIFEV084b2y4RlAyBDNnw2OQiH5wZrZPWqs+N8MFmXJKJsMSm9+r/IKg/5NURTfjF3nLqdAYL96CTx+7b+QMx3EL97noFeHtPe9avIYX6xoNUCH0/xTVj4+BfEbW4JFry+jQnR9ee34a/ctAdOkiTvrzgIqS0wmPY8CNsJvufd8eGJ8xqpawTOo60+SNQ0DEaUIbggPkskH5pewd4f30lo/juumArSISRsiI7/yztakoqSjDSx2MeAsHCOky2akMz3pV7jzgPeiCAWQeDCSN5iCxKj5CE9gb5+JIrqyNoxp6loe/isu/m+LGctEANi2WRbO1P8BR23ILYB0WWdNdMLCm5FMgVBXy/bLLU38Qnt2iRidsc6upWdrD5yO4mWdJPpYbKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(5660300002)(508600001)(4326008)(6486002)(2616005)(8676002)(956004)(38100700002)(66946007)(2906002)(38350700002)(86362001)(316002)(66556008)(66476007)(44832011)(26005)(6512007)(52116002)(186003)(4744005)(83380400001)(36756003)(6916009)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Hn2bs3PmQP8y3zyod37odRtXYVuouA0uA++BLSYA3271OIt29TiqlofLVTz?=
 =?us-ascii?Q?vewv84Yzl6G2yvLWUXkXR9DueMgSIOCXKviPsMY+ZjWdCJjyzpkM0RB7QbTw?=
 =?us-ascii?Q?pJ7lfD3zOgRweKA922M7XyMidGBkShumECH+nes2SEhmLp39lKmGi2VbUIr9?=
 =?us-ascii?Q?N8mp9EHVzxFcc1PbhO4m3LtsZVJkyaw+zTUgVxYjT1ZPhWgDxo4Fd0jfTw5/?=
 =?us-ascii?Q?wQjh7k1uJhviXa/r4xwgz45FjQOoCrUcJ4n5++55Y6sWrZ9Jz0pPluenLzVO?=
 =?us-ascii?Q?/CZtPXa0WQlqLnwjgiJ9bHYMvm4z8EZUXrA3Xq082EXKU0xI0tcAHDCJvZ2w?=
 =?us-ascii?Q?WNWC5SN/sMRS5ebJl7g2N66AK5+EmkU+b9cGqnT40Ozj36kJ8bk+ykagDmbn?=
 =?us-ascii?Q?rMWKV+jxkufWhdbu6VYAdoKJi5GUKw0XXWFxM4dHM/UhGTEnSb9310R3ooQX?=
 =?us-ascii?Q?kJxfilFwYtoqQkW32cLka0OriNNrEPvw6zSKl/92ROtbOhhmdCkIWzG2IkM2?=
 =?us-ascii?Q?hQwgbcDRheNVHSK4l2MO436t06QpOD3RVAqjscr/cc96U14r+T9GPaH0iKXU?=
 =?us-ascii?Q?Dixs74iHZh+UHAJ3BgYs00et2ygyeOSXODfkFmG8qxIM+3AsrHfQPwSONVbZ?=
 =?us-ascii?Q?Qz38crHMPCYPRxXdgRInR8bphT4jfDtiUJcwmCiwI1P0l0cR54OTjBrfQkl9?=
 =?us-ascii?Q?g6iLCcydFFkGPupql5gA3Bg7P5PiEbSgGRlNEEGuKoAPPVU1Znhz0meOqS8s?=
 =?us-ascii?Q?Vp7RXwmeooyIdXxhQG0fmYwf+oUMwt0AsL2B9XOrciw+Kr92gGjpTpll088i?=
 =?us-ascii?Q?B1l46eFFnEozJmdjizIACPqvYLiE9FENtZrxnG2JwYj4n/4+X52U3lwXPkC8?=
 =?us-ascii?Q?aH2a1Yr73QGHxEqMc3jYGtT2iXbqWrs18EWF4hFGLTBoll8Pyc5zQ65l4ATR?=
 =?us-ascii?Q?VEg6vpCDUDBqt/p7FO5P8QxEkr6HDdekP1pw+aeMSpn5XwvBC3jIsRYxOgnU?=
 =?us-ascii?Q?ogpCu4tJZigf77apLpxr+sD+Ov7ODPvYNOCrY40gOoefDavfK5Nzs00DjlAa?=
 =?us-ascii?Q?KxWu0JJhJYEP2372Sl8pR91Kw8ZgndBBexJ+sAoDVMI4qwu6Vq0BONZorxYV?=
 =?us-ascii?Q?zIjYuj4LD/r/1KobXwC+KA0N5l08bicYm0YWBbmAc2UhC9/jHY3WmjAxjSM0?=
 =?us-ascii?Q?xYso9+0raoKrdIoa2QZKJ4plzKKcovnYn6XSDi+0PjoqXiJuekXjBuCYzYyb?=
 =?us-ascii?Q?t1QvQqdwg1bTblKt2Ovt98E7ROUq9m/f5uMqipy6oGa3oKU/f2xhdKYRvedI?=
 =?us-ascii?Q?wVRARwhytIKnnua73ILsUZ7J?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afaa61bc-e9c9-41fa-1dae-08d98292fb63
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 15:16:44.6657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvM1iEEXkCnvpsm4/B45sM4oZ5VM3DEJ3AsXGAw7bs3wMEzJJT+BGocTkZjdOxlyzj3jHK0ap5g1YfeAath02Yi42it6XwWoeKS8wc/MBE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3609
X-Proofpoint-GUID: 5V-6Rortgt7yDVeicSGx52X0MvFj7Eiw
X-Proofpoint-ORIG-GUID: 5V-6Rortgt7yDVeicSGx52X0MvFj7Eiw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=411 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280088
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

