Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7259546DD0
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346954AbiFJT6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 15:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350660AbiFJT55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 15:57:57 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn20800.outbound.protection.outlook.com [IPv6:2a01:111:f400:feab::800])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048F2DF62
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 12:57:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TitjFVCL2ET7w0S1yCmuY+i/LpVH7VaddcKnxhGlkbuzQe+s8uZQe/C8/CNZFz0q6nrZ5VPN6puphFMYdwEsTf1ebNTU/yJGr+byr3jifqv6hgs+ZxdpmSgChOIOUxolZVfAP+BOy2lyqV0Xyj0848nMu+MSGwyf/MgiSX1ekpuiiiuwW6McjY6hKWzVL/29uEuf2P/kiT0nmRlRV8MIjOV5307tAXPSh26iRCk6IB9JgUdtpcXfjg60YK5b6pk85d5dgX4klHHQ9B1cK/CZf6KUn/ieLn/bVFDyt2XGnQD/qbM1Mta8W5srWGaZstwMQH9FJ0MJFz0B61XvJa1KvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4vreyWaKrbXFpzyK5FwVioWcnRYYuiv3mzR54AOeDA=;
 b=HPvqE9ajH83u/sFwb3hFGjtMVo3el7OUrfg66dTDiZLPIM62M/7pq3XRjUED1gXULJWM1GhFYa7wlldtpUAznTjON7DGlj4E/+ZgCD55Zv6X5lSGiMVZyLNw4+MZHJ6YeaaxVl+28YZ8A1pSz4L+XoxhRJaO+noQllKDXiOjAn6U650xBvpWqd7aB0TH4rR/PZYgWw1x+isf91u9YRbmqE5sOe1wL0RJR5Kp/XIYiMT9jEuFwbKW4IpBH5pNrBYrS5pFByJyvrRPBx6fpJHyM98kFSIfacCrjCMlPkaBkIBnBuq+bGGPRVHsQB7Ef+GUTSqd5oOP4OTzorypfGV6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4vreyWaKrbXFpzyK5FwVioWcnRYYuiv3mzR54AOeDA=;
 b=AObxL4z0+s4ohLx9K0XIBoaerhMORQWThsX7ai3GsvH/D4N9gAjQ75HvQ0wVp/hqJnekYSBWt4TwyZHYBecljXBcsR40rVOx+QUzVlBgBOAoP+X3YMnpjFsRRN31YuOBEx2VsyvnyIR4EUvY8zEA8vqQOJ6MwjJP9Ap5ZFOlEHr0/Ovw3PkqEwRwae/9Z0cjnm5ONQ0FL6XA08zBRKV94XvIn71NjAo6vKLNolk+CV/ig3ng2JonjWk4lkWkJ9y40JQjTXe5JvOyaScnbIkhdaqw59stMQmNDqGHUdouN2NXYVA4b8DwX4+y2JLmdcyrdtsjd/r/FKED58umnMMc+A==
Received: from SG2PR03MB4152.apcprd03.prod.outlook.com (2603:1096:4:3d::10) by
 SG2PR03MB3706.apcprd03.prod.outlook.com (2603:1096:4:48::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.8; Fri, 10 Jun 2022 19:57:44 +0000
Received: from SG2PR03MB4152.apcprd03.prod.outlook.com
 ([fe80::cdbc:70a:7467:63f8]) by SG2PR03MB4152.apcprd03.prod.outlook.com
 ([fe80::cdbc:70a:7467:63f8%7]) with mapi id 15.20.5332.012; Fri, 10 Jun 2022
 19:57:44 +0000
Message-ID: <SG2PR03MB41529020102E6D613A0E651CFFA69@SG2PR03MB4152.apcprd03.prod.outlook.com>
Date:   Fri, 10 Jun 2022 14:57:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Yerong Li <yerong.li@outlook.com>
Subject: external monitor no signal with HDMI port apple-gmux.c
Cc:     yerong.li@outlook.com, regressions@lists.linux.dev
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [2vIy1spFYthbIyFXqpgmhrJkvEL+Uryi]
X-ClientProxiedBy: CH2PR14CA0031.namprd14.prod.outlook.com
 (2603:10b6:610:56::11) To SG2PR03MB4152.apcprd03.prod.outlook.com
 (2603:1096:4:3d::10)
X-Microsoft-Original-Message-ID: <ad5ca94b-164d-bbf5-ef73-0efbb1122643@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f0f78f1-e343-44ee-60ce-08da4b1b7b89
X-MS-Exchange-SLBlob-MailProps: V5pmAly6juj5pXJYx5yH2BI0QAUxlBQYblM8nxARLv4Z9CF0JcuUJZW4zp8u0WVr7OzKDJKEQTqQnK1hwFH1u/dd5ez/u1w893L3m5lLG1jDFx7J9KbZFT8DpUhdKhifnnWlCDCZt2Ulq5JFrsWp+Jx364BknfWLv6ra21Ef9Pp7GmrP87JDtna8gTtr6cZnZbROh0fpppI95sjtm/k0uEHUAgSFZybORBrIx0dxb6pI0xvtsyu5Adr4urOA0JMN+irBKzU8vW38dNbXYw86jo+52xufeRcJIDzhhuqHcpkC6JoRs/gbGvyh1fW17F7NJVgqVSERD2QvkkbR6RRNJTv8bJELebHd0wwpZovEn5LSmvyDmNClNySl2VjT6hgeXuGI7TCVHw2CJStguYpAIq57Vg6j5eGHp0LzSQB9fwxG1t8yEOAhZ//VvMpkvTal7Irg6n4kNOvjyRtTzFWft68DN9CEevKijbIwCwxLpU3AaLhkktvPKAB4U+qRIBAqIbDuEq2QTrzRJFSKn1eXSMWVMgHLUv5eETHsoVFK/Ut9gw2VN9ANVDw3NQf8RqQO9i96bNNCzdFXX68ERdJ6fGFiri1gp6uC34XgP8r8TC+xZxZeiR1WCISYFwsfhlRZIw10wahn98dgimdUIS1OhqpyO0bGmRhaRSpLxDDqpLztZys082UCLp+N1EXBsXKz1qispeGVlPDlpzNNoAE3qXGooW4ntFJ47PYn1J/vzz5PTsxR5xRa4aZUGhgl4bRgVLqpue6V22nS+waOM0GqdrVGXbFTX8Wpe0kgdLVJ/BE=
X-MS-TrafficTypeDiagnostic: SG2PR03MB3706:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8EWyDLJbJiosOx0q3BEYLgIk4MkCbnUSiKhWqQrdsrBCpANkJWZUrHLp5BEfKHIUyGvBPmgCZZYAQ2D6Kom3cCQGcrXfzFbuJese6p+Cp+JPXncHuEGYaqbTTDfR+fwPZKtuy9lL49UDrtR+4vOANKbG2Ft5wSBAJ23l/x51uaN92zRPgOUJl0Xh5WrvUBd5FWl4vWztz2WNaaQACe/JMoENafGjnrB5w24L2OtWNXlgBtJQdRjHAkuj10qhuXtVZRZEYx/K9bus1SASPbAZf+DAMGJrw3FUtDLFQghz3bM4Qh/OINUrmnzIOrgXNae29t4zSfMQSzUOiIID+3OnU77NvQqxhTNOzptuMMBKAxt29V3N3YS/apx9fZf7ouwd29Gj2jiMMomBQJpkeOWVY8C3oITDU+AGGHp+/WQcR5PT59VLI8t8SEusJl44nIJXLeHUnVGVqYnvE9TVGMEzTgV8oJD/5eGVwojY18pwaDpr2uF9lzpcnrvA+XGXof6Mllzg+3QbBjU89b+K4/bOhrNUm4voybIq7bbmDhDJci7QqWgZoas2qG/FSfOWL072fNochXewvLeEGXSfPYXLMLJrGVxr6tAL5xDrq1I6GCkI5tjb5txA7LEpaFKzuqWg
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGp4d2ZEeE4wbzBVV3RzTllKOTJVclorQ2Q1Vkh2V1VSdEZnTjM5R3NFTTVU?=
 =?utf-8?B?dW9nbWJWeTlqcU9ldWJvbG5sSWJLY0x5MWdmL1FTK2ZuWVBHd1RwWVdIdVZ0?=
 =?utf-8?B?d2N3aE9KMERuWjJDOThLdXVrRm5hZDdUL3REQmlRZnl3U2FUekVwQzIzRFFD?=
 =?utf-8?B?eHp4MC9QRkNlcEpGQUVFcFliRi9LREFFK0ZoaEtIUU05ZnhlaTVpUDZIR2Nx?=
 =?utf-8?B?VWhmQS90VDMvZEwzeFRhVXkvdk9CNTRrbEdwSnI5a1JJdnRUQmFpTmJHT3lG?=
 =?utf-8?B?VlBQVzFNM1pXTVFPd0VRK0F1SDc5MWx2T0xzalpFaVM5dXJyU0hLUHQvU1Yv?=
 =?utf-8?B?bEdmRGR1UDZ4dkcvVXByMk9Gd2NEQ3dZaGduV0ZaR2ZrNjAvZWlvM1VaWXhY?=
 =?utf-8?B?V1h0MjdMb1RoNTlmSjA1NHBReFp1MnhnUXM5L2RINnJrcjdVcE00Lzlpak5a?=
 =?utf-8?B?cXlHZTEvRGgxd1RlLzBRRUhUK0U3b1FISytqRC8yendwd0NxZENPbXRSSWp5?=
 =?utf-8?B?dlZTMWFPL1J5aHpOMkprUThxLzlLZjljWWJxMUdKWUJsdTMwZEt6c3NGVWhl?=
 =?utf-8?B?T0QydEFqTTZrVVNEZFRJMzZtLzU2UjVGS1lsZEFqN2wyQ2hhK1VvRy9qZTBR?=
 =?utf-8?B?QUwwQ2NXRTVzSStCVGxwZ1k3aXJYRFYxZzZCcXMvN09VRXdaSHpJNlF2YWVC?=
 =?utf-8?B?eVpYQzFCUW5WMndDVkxpMkNKdEJZdlhTamRLRDdyNEZUK1hVVlNqd0QvK3U2?=
 =?utf-8?B?d0lQcGZDRDFRcWg4dW41QzdjdkRGbHlDWllSMHdjUWs5V3p4eEpPMUZud1JH?=
 =?utf-8?B?OU9KT1BCTlhNblVHWU1oSkJGSjIxcFdvTS84Zi9xUFlmM3pYNUJQQy9hdldD?=
 =?utf-8?B?WmE5Mi9jclVidnJ0TzdqVXhnM0dlNDQ1cEJNaXRkTEJuaEtrTFpuWnpuK1hz?=
 =?utf-8?B?T0pPbzJGWFpPUnlxUnBWR2FySkd0YVN3MFdDaWhpUHhBSlFBWlVubjN2VVdx?=
 =?utf-8?B?bUNLVVE5TDZNSElTWEFTYjFRTUtZWllTOThNWlVJYnNjNFRnNzkraDNZRVlo?=
 =?utf-8?B?b2x0T3FudUVram5pK1RtNmJoQXVOTDRiSE1Ld1BKV25sVTNwRzgxUEJ3UjRF?=
 =?utf-8?B?azVqam1NM3dsWkVxWk1kVDgyZFlvTFhqRlhkb1ZsdEY0ZjlETmlxaXVsSlhw?=
 =?utf-8?B?amJqOEVPL2o5dk0zR0tQVUUvME9HU1B6S2J6Wlp2Z2h4a0pGLzU1TWs5TzZJ?=
 =?utf-8?B?RHUrMkhUZDlVMTlmUTQyWUV4d0hHSDV2WVhabDUwelJEUXNaWTQxRW5Jd2Q4?=
 =?utf-8?B?bmpXTDhGWXIyYXc1MzBNbEJEdUZkYXdFWnJSKzVTaFpCdEFsN2xQMlVNODJu?=
 =?utf-8?B?WXl2NDd6ZUEyaUhRWVAwRjZ1bG10MzQ1dnJkSHhEa1RZZ2RLTXJNRDFMS1Ny?=
 =?utf-8?B?Y2RRQXdXSVpEMCtEbE5va2o3NWpaOW9rc0dwU3pFS1p1dGVkWjlROTBWanRl?=
 =?utf-8?B?TFhrMEIvWitTMjFYZWRZWU9kVTFGY0xWbk5FSzJUL3cwUUw4WTlCUnVreml3?=
 =?utf-8?B?TzkwZ0tPektmNTBZTGYrRFVtQnV5UDNOVWpRbXhseUxWVkNIK2MyMWs3TlJn?=
 =?utf-8?B?eGxTaUZSaHp4VStCMWdFdmVKWGZuSjVEVFo3TC9sK2lRcDRnQTBIVm1rNkNS?=
 =?utf-8?B?NmE5VUtYSDE0Ym1tT3pGdmRHTnZuK0Jybk1ieWRJMjFRTjJFdVdJdzlJN2Zh?=
 =?utf-8?B?NnV3MldrM1ZQN204ZDJHVFVDZWprUk1nU0x5WGd6NTladk50K2R5NXBvYTJw?=
 =?utf-8?B?Q0xkZndNZ2hETHdld1hiSGhtdnRMeVhWRTRvZXVqL29vRGliSTNrZ2VSUUpm?=
 =?utf-8?B?MGtwQjB2bWxSaDBwYmJ0dHNSV1cvaGhIWG1XOVpqWkJhN3ZYd3JxVTFpSElu?=
 =?utf-8?Q?wh43keG12xY=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f0f78f1-e343-44ee-60ce-08da4b1b7b89
X-MS-Exchange-CrossTenant-AuthSource: SG2PR03MB4152.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 19:57:44.3896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB3706
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi there:

I am using debian 11 linux with a macbook pro 2013 15-inch. i7-3740QM 
CPU (NIVIDIA-GPU switch)

I think on my macbook pro the HDMI port with external monitor is not 
working while the DP port /thunderbolt 2 is working. (Actually one of my 
2 DP port is working the other is not) These three ports work under 
MacOS system:

https://forums.developer.nvidia.com/t/external-monitor-not-working-nvidia-optimus/216573/2

Many users met similar issues: HDMI got detected by xrandr while the 
external monitor got no signals. Could you help us?

https://forums.developer.nvidia.com/t/no-signal-with-hdmi-or-dp-0-ports-on-macbookpro10-1-gt-650m-only-dp-1-works/49777/5
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/platform/x86/apple-gmux.c#n311

Yerong

