Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF0A6B8E76
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjCNJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCNJUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:20:10 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2093.outbound.protection.outlook.com [40.107.22.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624048DCCB
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 02:20:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmVfy2mavyIpDW6xXgcWM0iDF7w9fbqyzvQ72vi45eSkb22ofZZcRKKtPxYhbkuWNVlVdQPQoLsnMNw5k7yP1uHObiYebbQwAzuSy+G0sVkpY7cxEnj4zQfgr5C6hSrp/VTBgwYtaNTEUu1+Ht9jkBTeFMCkDgIf2X8yy7DkjG42PIlpz1OfXj7w0UX83gyXNyPfXWPvpS8sdYEQQqmqeDGYIDuAhJDyJq0A3djOpFz1OY5y/Vh0QBpx5wUbYdTXp69lFQVkX0xntrey4sVtcgpzXzbdpKZCRGgNl4137sOIdfCFePsmQbeBWHe2/J82tEF5mH6A4Y3DxnVeXgKRiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yEYm/sTLEadVQ7wO2UW2GN2K/KiGy8LC3pNIkLHwsA=;
 b=iwaE3wAOR/rJJCCTnsjh0W2MJ8zo6qVfnE8GKzN6zhT3E5FbdmsFz574NvbfxiD0RSFhYt5gmVVYBhzgtQeKdTEJbDw93kN0iYlylO6ktW8pnaAElwHgmgEC3xHWfOnpEboZ2WsJNMcP4FJf8WzddjgAv3bAyXEB12hyGi16bWfVF27gyLGW+k/1gEl955yvlySx/aNAYlCkOuKm0Y2AV5vyxZ0cKWCLdEe6qsu4x3DshtD3vmN9UnMKoWnGMqMqns5VAAl8MJb+R0TUEyAudXFq4WX8y283wM3vc/JMbsBKl3ZMC7+MKtwyIKbcCtyEa+R9ehPDVFAnMmq3XduGpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yEYm/sTLEadVQ7wO2UW2GN2K/KiGy8LC3pNIkLHwsA=;
 b=k/xyO0BTBMqDb3RDhx1c6DtdxmKhJncWnybymjGade2pLkvzcAr7B+d1kkwiOB/KNbaaYHmpk1ByHseGdKYfWIt+kbJNzpNdKTOrQLD4V+T+zL8IJpk5XOCIIpafMbwcWRm076qFjT1iVwqAu2NRyJo5W1kaESzHP/1B/G7F54AdB3UXMCMGICcbaTYJPTmVMrzId1RH7rFu/1PFMqJeVbwRUOula8Km8tmT3TcUZoluQ3Pt5hcANrVAuGRKMIA/oXBJmeQTMW4LiEy9jgiNqFrSwobQM+LPDKWmq8x5n0snpeBN38wqUha9y/isMZurF4nQV1aUW9aAxLMUAwFncg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PA4PR02MB6543.eurprd02.prod.outlook.com (2603:10a6:102:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 09:20:06 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 09:20:06 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.15.y 0/3] Stable backport for KVM-on-HyperV fix
Date:   Tue, 14 Mar 2023 11:19:50 +0200
Message-Id: <20230314091953.3041-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <16781188891829@kroah.com>
References: <16781188891829@kroah.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0029.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::18) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PA4PR02MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 562415b7-c291-4720-4024-08db246d4c9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m4NYHZpXHKTt9BMcBn5fXNVgDBTlh/ChYk5pG6Rvq9BQ2sQxCHQsmor3K5m6rwC75uvQQW3WHZTOee404NfYrjetnkuq03Lgy7IWhS96cZ4/UR5Dukd5vZrcsq62j0sBGBBa9KzbJBLzuxOAPkkIRHFMm+rcKfdpKuZJ1OncTlmIp/YUNDJo8Ly/2vkxo1vwjiEUzuej5t22UxEdrWK5rJ1faucjx5ASvEJU16AEE7yb+7gzDKBWK/rxjcZLlronrs2kK0byzvf9spBvc3cRX6uEWGP1ze0y0PsWhzWfTXK0NvFFFhSfel8rqz3Gk/TQsp8s9wxET0/Qts3vob6V8v9jyokUjEWvxYk4jPq/HuBm5fwLAIL6trFR6oaErjW2/hbfnIeTOEKSkLCbVjwDrF2UuNH0Zh8DczjffjatPJSsB7YFE8nxpBJlGqEHUVwQmuddcMXydACq6TqexRKz99Zv7PAMQrGdnfOZLDx9QYt67d2sy6rTByEeOnzfBaKUu5qyLApIJMgL/eEIe+6gj4943MinRnSlnip7QQYJZPED7+ofxyx3MX8GOGV8WZ6Up5TrvcnvZTPpaxNluentfIRlbELlioyBf4yPpbR9F/xCNW8VJACNTVXAfuinL5b/mnUOEZIgn2MuqUEsE8lGMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(4744005)(41300700001)(44832011)(2906002)(38100700002)(86362001)(36756003)(8936002)(478600001)(6486002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6916009)(4326008)(83380400001)(54906003)(316002)(186003)(1076003)(26005)(6512007)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y87vFdJYuECgnViRw7CXU/XzgS6eQB4Atbvz1kxcMtMdRfu9zwZkEpHUGNx8?=
 =?us-ascii?Q?FGcjBm+LTh7UJNM7KrQ/kQ4atK/bFtUgnIaJdbon1nHX9zE+UlVe9S8EWUPi?=
 =?us-ascii?Q?YjESX/pgt3Ek+O9tYPvz1G8QpV9YQlSCJUWZYhnzs8pfX3J1p3j++ZYbwFht?=
 =?us-ascii?Q?gtrd0fGX6joVh70Y5VBhnYVLApPBCeDMdfPO7V2GdTjLpksHF6930lur3XGQ?=
 =?us-ascii?Q?X1Iif8n2nK+y/xpTiIDdZLyIMiBrDAYOEw18KYMJItT5X20vcyuRCU+tkcxg?=
 =?us-ascii?Q?+tjvRFdVEtaY0bX3ZH7bf0r4Srls+HT86zMj6B8TvG/hppyv68h9L4kZw2Hw?=
 =?us-ascii?Q?LYkT1RlmLOwLvYWxzOuYLq0HXavgSxYpzP/Fgkirio04guRp28oEUZBl+sME?=
 =?us-ascii?Q?buqPNQ1Qk/znwgKYLemgrNdIM/K1dVzE156IhOQa/kpA+7e/beqg2xubI4Gl?=
 =?us-ascii?Q?5qM2F4Wqsz5lHurz1q1Wu+baPY1cc/MqYDK7WHnE7nh2CO53vvD8xL54nCME?=
 =?us-ascii?Q?44MjrUQ1iD+IiV4KQGws641vbAvCzjbgZdZgtUyO67pe59Nw3/gaFTGHI+L+?=
 =?us-ascii?Q?Ez28ZONyoUzjB66E+GvCY+xQNUt2Chhs/SHiAfFtWb9jMlQXUjiE+uqSlG/r?=
 =?us-ascii?Q?buY4SRx5jplx20NZ3Ri9wN2nr+xxHVYmEopXo/rfrcQ5iUD1an87s6D/dOuI?=
 =?us-ascii?Q?R5BX5eA265cOcbAWgshkvPUkGTM2Mmx6sU3EalSx8QscA+hxcsiWIZiGD4DO?=
 =?us-ascii?Q?s6HSA7fGawzIcfTqgIYcPl7cp3BSZEtoJYZMEDnTQ5BYMf1Pgj19Sh3/gj83?=
 =?us-ascii?Q?7ZSIqoS4V0gYbZB9w7CVYEuhn7Y0KB6SZjdLFcxwF6NuJg8OgsNdtMZWJAT9?=
 =?us-ascii?Q?mrCLkkyK5fHw/0QRPbIbjXMf44lQozwvhPh92QuUzhE8cEbVe/G6YHP7XaG6?=
 =?us-ascii?Q?YBVvXmz0RXU1a1xzfcCtecNi0fzLiiX+2Ug0227yy9FBLvff8nRKcyhzihfq?=
 =?us-ascii?Q?bMYblX2TZgwJQVHQRsQBoyIGNVkPM7XL2CpxfSMvOhY7MjcnSaD918wtsSpm?=
 =?us-ascii?Q?zZuIooAGghoqozqZYYB+LToK8YghT97IQP0Vm2jyTUDvWXQhIHivX1J3072s?=
 =?us-ascii?Q?e7BjVheStAmKv58hczkI2NTM0OvUO+mB79Xc8Gy9ICbfe8gs+hZRAAirjWdA?=
 =?us-ascii?Q?5ntaGWQmV2v4AtSMw7o6i3eVZsHMz+kO8uhROd36UWCUgTWppBlsLf5ax0TA?=
 =?us-ascii?Q?gX6x31mQz7f2TldzYzDCdtc3QATW4GJqxvGYoQSBbn8lqNEZJWH3t4QbdRac?=
 =?us-ascii?Q?Na0d1iCr698WmC3VDDKs61eb7R+lAYBVB9lu6b8Wm7TbSeHljkUDv33hIQGh?=
 =?us-ascii?Q?Aj1nJjj8lOiDGVmpPr6X9X87kas1Yw2MzQmVAQzBBGh6GmkK2n1VBH2f9uW0?=
 =?us-ascii?Q?FAXV6KeteR/P4TRd8f3ZnuzO6WY97tn2DzvMjos0zZ99V9YynqAMTrP6EcrN?=
 =?us-ascii?Q?9N0P+YYKZsJ0KUqY9SWxDZUezEe9fA4LjIaNgpA7InWOSuCQVwS0YKmAHjBq?=
 =?us-ascii?Q?eIAj9uKnXf0/RUyX7zPUHVvDyOpHtEiaXcYSr2QQvFVB0jv0rY3ulZdQeRzB?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562415b7-c291-4720-4024-08db246d4c9e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:20:06.1344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nftvrea6J+wkMBzKN+eIfI9CORu5yI6hUenClIRT8VpvnzLeg5Oy0mw1a0QBf+1bHhrYQoXE9Gbn3wzjBphIHV+VBgqTbKh58lRn1XApCes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR02MB6543
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

Here are the backports for enlightened MSR bitmap fix and two prerequisite
patches.

Thanks!

Alexandru Matei (1):
  KVM: VMX: Fix crash due to uninitialized current_vmcs

Vitaly Kuznetsov (2):
  KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
  KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper

 arch/x86/kvm/vmx/evmcs.h | 11 ----------
 arch/x86/kvm/vmx/vmx.c   | 44 ++++++++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 24 deletions(-)

-- 
2.25.1

