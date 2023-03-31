Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6322B6D1913
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 09:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjCaHxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 03:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjCaHxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 03:53:22 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01olkn2060.outbound.protection.outlook.com [40.92.65.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E999A1A44E
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 00:52:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/e1469ogLGnEm7SyoDwv4hSKpqOgOQFTR0ZvNkRiHP4z7A2+vNccMDjmQZLbD2Duw+LsTUjrod8rmSXNqRbVfGsZpmQsbEG4mYKOBD7cSOusQp3+hg4IBMy/BRkWkM7EJSXFLPbWmJmV4iRd3qvpuLBan4VbLRHh6KxXCG6h8RXT2au83pdVS96lGYx3SKirXcgdcINLlxQRiP1Wb37gp5TNk9UrPi851u1lydeaIPn7jhheNzg+I7Rr7Z7iLDaewI7A6f+gQqWjcO+E4IOnknGVKHdcxndft8ihxwYcm0A9iy6Kr9KzdBJtjRISbzJBlfzphYgAX2yfZXSpA9O/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XV/XLh+hJWzRULBGceihQGH5oZkdL5zu+ai/tPoiX60=;
 b=Zvl4RKxMG6P5V4HgOtXC1F8etqIfkS1MR5oPJdJ3ghgWP7rd9k+3CTEsLMSuUSMAKAf1yFm3E2Sx9d1VQSfNGkm/Nb44RdBkff874eIeTme+rJf/etvVZ7toEKJkDEDddTvKsIDFcTYUBbvGe3MgnVPjPaiR6RT1Qb/GQLt4rP2MCpHb6FPEi6IsV+wvNi4dN7f4+S9br4R9oFd/hAo0WLYiONKTBxdtphDOsejsyvMygsjGlXPhAwOuQRHdYYV6RSe9D+WmV69LqvrkRdnqBNdYGwK8w/Q0xODqAmXM/L0aCRDjJVkKLTwVPv3F5OyX9LfKGUIQCOzjKL0ti9xmrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XV/XLh+hJWzRULBGceihQGH5oZkdL5zu+ai/tPoiX60=;
 b=bKYbMNuVLnkIY9UuEBIvFZk32Dvjl7X4nDGEb2u4j0iMjBG8x4Dd7XIMZFeBnhybymtxw9VmNiXhY7OB6qYyP5WQhV+Mfmczxb/nk5NBkul9P8ahBtIpQ2A08pvnV5Ix9xKc2ceIOjh/KEnI4NGODSDN5dh+cGD5VO4FBwHCfX8U1aX65XbqKaSZ7Q1uI/Y8iVWwq+ltC+CCgd23kOkRkn1HxmxDyQpoBWkMoPavTXCJkomWjv3ZC2rNYjlScp5JkLX0zLI+5TjqbB6ruPXTp/IL0fVnh98lXGRbfBqD+EgEqRI9g0dRm6iDD1EIy/S0eQI8Kom/cVg+REht6zEaTg==
Received: from GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:93::14)
 by PAXPR10MB5520.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:23e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.14; Fri, 31 Mar
 2023 07:52:57 +0000
Received: from GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::185f:8a4b:7994:c250]) by GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::185f:8a4b:7994:c250%6]) with mapi id 15.20.6277.014; Fri, 31 Mar 2023
 07:52:57 +0000
Message-ID: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
Subject: linux-5.15.105 broke /dev/sd* naming (probing)
From:   Ilari =?ISO-8859-1?Q?J=E4=E4skel=E4inen?= 
        <ijaaskelainen@outlook.com>
To:     "linux-stable.git mailing-list" <stable@vger.kernel.org>
Date:   Fri, 31 Mar 2023 10:52:55 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-9.el9) 
Content-Transfer-Encoding: 8bit
X-TMN:  [xsXlElShghL6ZFVSgkbt+mwPJx0ArPD8]
X-ClientProxiedBy: SV0P279CA0033.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:f10:12::20) To GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:150:93::14)
X-Microsoft-Original-Message-ID: <a046e0ce1ca85e0d691f5010b04961b04aaf0c08.camel@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR10MB6241:EE_|PAXPR10MB5520:EE_
X-MS-Office365-Filtering-Correlation-Id: 52e79bef-8cac-4951-5800-08db31bcf159
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PW4Z7AfJ9QqbosB/PQjAhcSNi+F49XE1kLTLnyU8X2b/gLkAHpxR0MreZ+2x9i2Va2+95g6RHZGSHfXayaHDsEpw0tl3VYmdmmp1VAZPilgKtM5k68calMQ1h1fZ4iE14yuUATr7kJvV3lxcdjFSmsx5z++F6cNom0ANbdFkMFl580rLVGkAPp2yi80Ibrvz7h5nmKdtj8AJdIcqPvNUgJO1tXZm/w+OJrz/1xQPk4740aMy0PJ16rjf2lSrwQ0qW33XPr+ew2j/u7PDr7jA1bnuMepkMEt+xsV5aPCxPxRAxU27e9EXZHMHtkt/R7bqcXc83HpZGQfbdEYauA8OFWCvp+X+MQFgW5fN2ipnzVh1LG7QVHNdR3N12ojL9K07Rj8I5a5izk+wUXXWLmgA0fCsdE4Gf6Zayx925kIryVbya/CAM1/1V7kdxQzrwZYZ0StZDBcimvy9/zC98MSuLZ8vGmsyeadHmWKRuhQkb5ybsEQzEhG3I5hfY51U2orehU2Tea6mwlc6HFn1bdmuOs0yTgrkj93ktFSTGectKpmyWD23YGOyljBXkQHVtVna
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEp4QjM1a1BzdFF2QU1pRC9uQmhoMFZ4cFpjNVRPbWNKUHd0dXZjeVBDR0cz?=
 =?utf-8?B?cnZWNnJ2aEFoY0lMdVpveDZIeGtaTVlwL21xcFhaemcwMHNjZ0d5b3lsSDlJ?=
 =?utf-8?B?NkJqOVpuT0dEZ2VxaStNZHZHNm1nYm9zYlVNNEM2WHZTWStCUjQvSFp2N0N5?=
 =?utf-8?B?VEZYaVo0b2kvbm5uSUQ3YStJTlU5WnR3MlNpZXRoQzhFZ2V1K0V3SUhXRnYv?=
 =?utf-8?B?U1F6dER3aTN2ZWZBekIzQUc1Uy82QjU4UUhiSkRJSUpMVjRjTFlpZ1BaMEpu?=
 =?utf-8?B?bVBVUitwVVZxVHBNRnJGL2VKNU5sS09lOXJRUlZVb2ZaQk9pWE94VUhZUEE4?=
 =?utf-8?B?QmEydE9oNk9mRk50Vi80RGdNK2Nrdno4YUVUUzhGWVhHZnZ6RmxCV3ZFejFK?=
 =?utf-8?B?eW5lc0FlUHlOK2pkYzYvYXVURWpDbVBESXpQZjJzSDE1T3VVOFJCbnk4R2Fh?=
 =?utf-8?B?UHFmZGp4YmsyT1pWNUlnL1g3bmJWdUIwSzJFUnpLL2IyVnF6TStTU1k1M0dt?=
 =?utf-8?B?cG5oVXRoS0w0ZTJ4d1BKTDd1MjlCVEZOei9QNGR4Y1VZSHVwSERINkxnRW5H?=
 =?utf-8?B?Vks5SWFJSEZOTDlrMForSlF4TUl6cWh2bDhzcEp0V0FaWmk3b1NRcnljcEoz?=
 =?utf-8?B?RlFZWlVGcDUwdDNPWkYvWncxMTNweW42Z2d6MVh2NFF1cUtCeHh1OW1YOFFN?=
 =?utf-8?B?cWtOYTliZnV0bTJSSFhkci9janZ5SnN3MkxCQUp0UHg3VUVZbzU4dFZuSHov?=
 =?utf-8?B?QndxNkoyeW5ZR2o1YkRuMEpPTFV2ZkxvaHppUktBQlFiaVZXa2dFZ3RqZkdT?=
 =?utf-8?B?R09idEFqdi9sTnhSRElnTEdDSTZUeW5JVWJJWFhuZU4yQlU2TFQ3V3Q3Nnhn?=
 =?utf-8?B?QlNTb1JrRzJHZnF2U0dVRkxDK1NpVkwrdk5DeVpCWWNaNmhsR2xSdzRtdmlY?=
 =?utf-8?B?R21kRTdlVXN1QmpiMjVlSmxVV3BBMnN0TXl5bUpVOXVaV3dYelQvNWM5ZTIy?=
 =?utf-8?B?WDYrTi9lbjRtWGRHNS92R1FDTkZobWQyQ25MdUJaZk5DQTVBV25lcldyelNz?=
 =?utf-8?B?RDdIbkxYbVRoUCsvME1QVlE2Q3NGVlVDQ2V2VnNiZUNIWnpkMjVic3FxNXFl?=
 =?utf-8?B?ZzRMVDRqOU8rMXYxN1BHakZyNHp6NWRwYVNZb3ViSlQrc2tEaHh5TFZjOXlt?=
 =?utf-8?B?TlZ4SEFMWnVBY294RHJNTHF3UVN0YWEwWDNGSkJPdVJnQ1BjMGNmUU1pelZ6?=
 =?utf-8?B?VSswS2xnNUZpeitORVFpTk9IcDVTN085dHZscFM3eWE5NzQ0TFhqQUpTeWVK?=
 =?utf-8?B?WGI3TlZuOGdGZ0FSTXhuNXJmWG1lUzg1bmtUbWcxSGFKSksrb0h1Vk5WZFFM?=
 =?utf-8?B?UzhFTXNwQ0c1cHAzTjk3VDZ2RUhpVG9laStYNHZwc0RCZUhZV2hOUXdDeXU2?=
 =?utf-8?B?U05GNGl0bkIxdFZRMlRQdGtWUHVLVGNXTWJnZTRlN1d1bUF2N0xRMjJjOUQ1?=
 =?utf-8?B?bE96WVlrYW1vdTY5Q1lEckFhOUhZWDZ2d1l5T3p4dGlHVjkrdkp1dncwd0RQ?=
 =?utf-8?B?VUx3UzVaOHJQNE5CNnVMaXBtd3dIZkNNNm5SZ0k3M256eVY4TnVlR29PWVV0?=
 =?utf-8?Q?Fkmh7VMQ2JJY4hcXE4h4pVPK+UpHAiYEjrSMYAr5UJ20=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e79bef-8cac-4951-5800-08db31bcf159
X-MS-Exchange-CrossTenant-AuthSource: GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 07:52:57.7731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR10MB5520
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As I attached a USB SSD into CentOS 9 Stream computer, after a short
while it swaps /dev/sdb into /dev/sdc and the I/O gets ruined.
Kind regards, Ilari Jääskeläinen.

