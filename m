Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61B53A230F
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 06:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhFJEGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 00:06:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhFJEGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 00:06:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A44jHr073710;
        Thu, 10 Jun 2021 04:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=jSG3egDIVQ/4AdPkckH0kWGdkRwhebEy59gWsGNDTUQ=;
 b=TMHwCYX9Jq0eIMU4Zvy0cIIQh/i5w5lM8Es4LBnRqUiqLgh0j7tQLl+I/nNSkb0PjURT
 inPuUeGAPKh4i1kSOD8Ys5vWB0kpyvzo0iKiQvermb1VQqruX+38C4ZGFZJZ172ALJu5
 p1B3EchtSQx2pPdEqpfqHquVg6GdfO6sERqSCgWiiZLeDdW6fKk+3nDR8BBBofCrDB3Z
 hyLK4+Xd30DSUw5IXGq1tCvmKsvHBNuz+0C+j+GVHaw48BKWZqPh7ScMefLfovNHnogc
 xvn42Xrd/vMJxiOaFxqX+XNkdWKoLNzEfHLS2kXMJIabr8SnN7zPEIOuJyh+/MoZeV6E 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3914qus9ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 04:04:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A3ud5q178498;
        Thu, 10 Jun 2021 04:04:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by aserp3020.oracle.com with ESMTP id 3922wx0xh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 04:04:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg6pwMyiaNmHbUZCLja3XaEz5oQGnpuxjRg+/F/Dr+uJ/txJ9sHQ3XoRBCJ7TcpxEcZnndJtagJ4lXBKR8XnCd2G1Ub6T0V2EGeKofLj2Dbgwvah65wd0KnqYJ7DoK52MvVbysA4cLgCcMvXoM2yOEm5zKcsN+LjpStm5iSWoOHSkzD4r3X8deHwVdLqRpkYH65Ux7EQaIh+ov3xn33T1kjq+hQrIG6Y8GhCSOJjL7AeJCQIv8Lzs8tspnE1337AGk/JCfbW82JS27xe3OFugLmJT2gyrRZnMeX14UzxprDjpdNEBAuz8vgQamh3LgrwKKQjv2nN2BdTQmBc7moS5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSG3egDIVQ/4AdPkckH0kWGdkRwhebEy59gWsGNDTUQ=;
 b=N7Zrm4PMxa3L3N0LE0W8dg/4C+C9cBPS6JNNV5YpSNaNVlwUf9+T7g/GOPzTrwmL5s04ymxisbLUqOGpr9Fuzo+COXpQGnnF3x6Zq3X7VnUa165lesJynv6LNThPI3A373KLth6Vkf1F7rgXUapIjBNEKmArjTImOg4yQuif9SO1UtK6toQRSmzFnMkQgWeGMD5K+PHLcOJthdfC+sro0I6vR0kXiHgvoF+ZfsGXFVv0zKUOe975+mtuzMHzk1zaRJfC45h9sst49fsQP7sw+DK45OmEGVNrPiQb5b18tOOvD3xMIATKa1az2nAzfa27X1i25OZmmQ/u/B/k6cek2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSG3egDIVQ/4AdPkckH0kWGdkRwhebEy59gWsGNDTUQ=;
 b=BPM6vHumUDdUWF6nuQ+qxSb2tQnqT72O31ITxOdlE9gzvZrWKtLPbpUKQetC0uxPUnBLi1yPaChFD/cUhPS0agEsCaG9CD7f8dS+36SBrUDX+pRDz5VsNuvB+sh6AtH6BLnWd3MFdRBCNyk9rpz8VcyaAL3WeTBUiu7tMNT2vSw=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4405.namprd10.prod.outlook.com (2603:10b6:510:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Thu, 10 Jun
 2021 04:04:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 04:04:42 +0000
To:     Javed Hasan <jhasan@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH V2 0/2] scsi: FDMI Fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dj2fjqo.fsf@ca-mkp.ca.oracle.com>
References: <20210603101404.7841-1-jhasan@marvell.com>
Date:   Thu, 10 Jun 2021 00:04:39 -0400
In-Reply-To: <20210603101404.7841-1-jhasan@marvell.com> (Javed Hasan's message
        of "Thu, 3 Jun 2021 03:14:02 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:806:a7::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0003.namprd10.prod.outlook.com (2603:10b6:806:a7::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 04:04:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c02d0e3-3d8e-47b8-9036-08d92bc4e01a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44054B63657CC9EB626347708E359@PH0PR10MB4405.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pbGAxgRCWyD0Q2UKC+Xpp6CBEDTabExGWCeIf4luIXBK7HI9gFtPFTjezGim9LhDvBwvBxC1yq3Fl9LI1bYX+Y0f09o0JNKRFRWk5Eij3BQtjbgIkc+CwUVJJARS725GnuciiP66PDflYmnm8XPZPjhDXcmY0Cc58UboUBscDVSSG6vYDGxTSsFFANn4UY7Xhpd/cqisFII1NL6DnjHyDdOHEO4Yf/UpcO2ChH/dohBe09GjCTIaApr+6Vm5fPlG3DogSuaTngaf0CCFHwy8PN1Oi08M0Crl5pGD15RR9Ih9EX4eg4uIDDuVTOx+JJUKR10HfdbQ1iWBCzlLu9aSZbXchXocOFZhwUFF3pgcHXm1LlgyGlfrrnFogitYYFHma50t0d4Pou70DnGN0zfcvlcyTMqPu8hXW/yiksWlp70cq4X9Hc+HyuTrQ0z7cFu4QAnKGTDCAw93OQPaIgID9o1Mqg1c8i+AVd1kqpHgkiW18GQD67Ak1GAvMGkH/dzEnQSefCozp40lkG3S7vB+IqlNqrfyHJTT9u0YqvIYi7IDleygA4ScY3rWfD8pGb8o6OXjnEMrFGlBXG9wety3VwJAfEr5UO0/fYmKn998Cq0IPzS3saCZQRqpZp0EEHZ6zZFMnYYsvL5VndWqolaBXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(136003)(39860400002)(86362001)(66946007)(66556008)(558084003)(8676002)(54906003)(956004)(4326008)(38100700002)(66476007)(5660300002)(38350700002)(316002)(6916009)(8936002)(16526019)(52116002)(36916002)(7696005)(55016002)(26005)(2906002)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzthzDdWhCM1LFLpsphbJLcIJ/1AAl5pWbfLW0QyJbt/rDIuZ6EFmMvVJYQw?=
 =?us-ascii?Q?36TnhxdrlB6q6FlkCVVNR0t9Ik47+hXbTOxxJqQJekusqnXjmZbj3UcRujqI?=
 =?us-ascii?Q?W+13OS2Sa592oALcBqnNwhWxOGS23BGWGlxb4GNIpK7zxzH3NGCcnWClv8KG?=
 =?us-ascii?Q?Sl7I57nRghfQ9QXN83q5PfsJpjQaojHJtRPmMmZ1sGSiNq3f/6Zd3KQOBWm7?=
 =?us-ascii?Q?9D9EnlYh+iTcnBQUMbF9+6SNs3hnTLbeLMHoqvvKZtDCWI524L6Kn0daIQTD?=
 =?us-ascii?Q?rUjTeUOCJ/abB3aih6SVzXBf0jfm5k0WmpzIeJEWJYrmlnP+TtlPAPjwAWsx?=
 =?us-ascii?Q?cCabL/piE0LG9liI2DcMsSRCSsoY5K7tMBokHDvm/XBE5U9faetnBJ1HbPOZ?=
 =?us-ascii?Q?9npwJDcgFcLxtx7xUBQtou9q7D2yfB0KJ2qL86m03dW+9oPQt9uGQtaRhBT/?=
 =?us-ascii?Q?Es3KEAQ82QckEGaRG6KOjvKNJviKX11GK98J0EfxmVsQy73RbPX/1bucyDd7?=
 =?us-ascii?Q?APVb/eARq36g3QdyJEI5DqTcbWigiDzes79CRCV89qeXoHrEt6JESJ6zInU1?=
 =?us-ascii?Q?UrpoNFmYUjrywdqLeeaNzdcRgvVw5nJimpZVb7L/qX7Ti2BMA3yNUlEckZv1?=
 =?us-ascii?Q?oScQUzw5r4uVkPxfPao2UAywXhBvfgJQrOimqYb4UyAIshSG8CN+JQFnUn26?=
 =?us-ascii?Q?MRazFMJWN5697GHbYZT4fXUNoatnnjWqY+Aa6AFdpDDCT9JiTv0lnseCA7Ez?=
 =?us-ascii?Q?Ydlx7rjXNa9ByNpQEEpV4x+fuxnCFxytMRPIVEaWL97BiGHjNXGwR7ZdHpIq?=
 =?us-ascii?Q?t0ywHyhNpqY6yVSQwNqLmH5/BZHWx8rZEXhGNmQqE2WgFezBdC3kJy45my+g?=
 =?us-ascii?Q?+Pl/xpaxUaImlk9hpjU0J3iCmVtIPzuhQJhCLCndoce2PFVLNLydju11XVvL?=
 =?us-ascii?Q?Qa1FQAPGTxYhmHQepTOskVerU1IHwYYax5p3W4xIdzudCaM3UiVn4FhVIZ3s?=
 =?us-ascii?Q?lAzN6SvfrcVmrouk08DPQPegYmBUFdvBJIixmcxvrgUjOyIXTjT/aN1tNZmm?=
 =?us-ascii?Q?jMdqQmeb7RajqZtD7LafZK+uJtRFUbf7V4JxNopDJ6UqJOMjqOdXZ8c9B9GA?=
 =?us-ascii?Q?fYfiP6+XyyP7zzmElay7msT9TttBYd437JaMxUP8T6qiny3BvMZU6kPMg5V7?=
 =?us-ascii?Q?v59WaN4JFWugcnwWqod+YcAYvx9REzOEXesdtj6RI05fn2N/H4RAu59h51bW?=
 =?us-ascii?Q?10Q74/XYS+vArAcnB7nxBs5TRFAvdLthds4SCS105QMRoNvrSqzagZ7XKzNj?=
 =?us-ascii?Q?3E0CrgQCQy15Kon8c29XZyyv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c02d0e3-3d8e-47b8-9036-08d92bc4e01a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 04:04:42.4411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +4ocB9YylMP0aRhTU/pcD5PoIkYgGkyVt7L8mUDuHz1MWOwelUhjDRKcLRbS/OCGO6zT4491lHaEDTtxRTh7TGkYXNQmiVbu8HkUdDypbYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4405
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100024
X-Proofpoint-ORIG-GUID: ki6XKf5qebtNQ25nvJMixtf3yF9KrJ8r
X-Proofpoint-GUID: ki6XKf5qebtNQ25nvJMixtf3yF9KrJ8r
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100025
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Javed,

> This series has two fixes for FDMI.
> Attributes length corrected for RHBA.
> Fixed the wrong condition check in fc_ct_ms_fill_attr().

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
