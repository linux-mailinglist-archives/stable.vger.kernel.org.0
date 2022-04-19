Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035A0507B14
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 22:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344890AbiDSUlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 16:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357694AbiDSUlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 16:41:00 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40056.outbound.protection.outlook.com [40.107.4.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62AA40E78;
        Tue, 19 Apr 2022 13:38:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkwYr2HhjACOcz3ML+H9WmquX8BJB8m4D4cYbDBmkcCa8/rG69ixtMyVARmLOKfEWfC5gvrhiLAHj0++rGzhw7AB0M1VWY4Zphe8tcwfDSYdQPNXG1/WPeADuiqATTTFu4ajIdLyTPaY38DYcIa7II6g7T74TpgRmenwWH7fSy+mZboh0fx95ZUW+nx/np6hZyuAUCmeSXghYjHPzW0fg7O86EN9VAMrDmfCyLZ1OaDq2NYz8b2nwfUKAQnUr/oshwh/TLSvV7tbDiYhpZJjJPNKy6nAEdgIm/1vx8wux04alBFcfmXBW489Pkwtz1xAXojTfoAcU62yHuFmH6Wvuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y04nVEnutMhCNdCP+ejVBOqZhI4eVQFeqlc/hv84l4M=;
 b=PHuWrzQfMvAF+QcT5OkgMtfHySwVuqi8fLNO31v1IaK5/dh7serKzKzYCoeFS0VeG5FKA8GZ76TOAlnNdvJq+YkTl6JV1KUGp6PaERlFBLAgQje0oT1SmAmKsLVupB01L8SLebhqVCfv8u9pEPfKUckkCww3ZnFegHqhdSiH9HPkGyRDorbj3Y7JDbKjxITQAMPeysTXT+UDkRArIxExkNuD0yrqG4yE5svCV30hVgrO/4w3EuvaNzQmHF6cW1PYq8AHLZeKl3sVixmP3jZGkulus6RIlSwQqDQIdAVBQzlIpjsi0cMeAU5I+/cqyWyJoCTfKcvfPDieYXHxiey1Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y04nVEnutMhCNdCP+ejVBOqZhI4eVQFeqlc/hv84l4M=;
 b=HEp9Nq7bq2LdirMLaKeSdGQlRl/F7xUpWqdUTRrZ8qsvSEc4V6d8UX0UyeUvZQDIuBVLUI8IXQKA2qvyns7mLPXFhmlWl0V5CK+bsP7epZs5FstpHESXpQSNPJFEZDKTwz0SJp1/RBTu1a/UfJsSXv8MKpgLrMGZwlwykElym+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9517.eurprd04.prod.outlook.com (2603:10a6:102:229::20)
 by AM5PR0401MB2609.eurprd04.prod.outlook.com (2603:10a6:203:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 20:38:12 +0000
Received: from PAXPR04MB9517.eurprd04.prod.outlook.com
 ([fe80::ecbc:8286:8006:fb5f]) by PAXPR04MB9517.eurprd04.prod.outlook.com
 ([fe80::ecbc:8286:8006:fb5f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 20:38:12 +0000
Message-ID: <3680a3e6-6cce-c322-fe02-2c3b05901974@nxp.com>
Date:   Tue, 19 Apr 2022 23:38:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4] crypto: caam - fix i.MX6SX entropy delay value
Content-Language: en-US
To:     Fabio Estevam <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Cc:     Gaurav Jain <gaurav.jain@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220419114444.586113-1-festevam@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <20220419114444.586113-1-festevam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::18) To PAXPR04MB9517.eurprd04.prod.outlook.com
 (2603:10a6:102:229::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c385ade9-2b81-4453-0e40-08da224485d9
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2609:EE_
X-Microsoft-Antispam-PRVS: <AM5PR0401MB260986C389D488ADF612470C98F29@AM5PR0401MB2609.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uV3z5y/+2YTGkNFG1kTINwgGy/4ogNKx7PM466d6cjqXfz/iAbMP1z2DayFP7mu4kowWxK/FjgcBSeU6jYT8TIxPiYSFz+5i8Gw7OMhAxa+Yn+KNli9KOLiWVuufoC4Gje1CF5VFaV1P54Le+kW5GtrLkAryFXwQLmRD49QD7IQybFnRxbuARm7W4KDVg+/ZiUzd3ri5+J/6m0xNCkWnM+hBW6gFLKf+69B9iw+U1T/QV0vAvKw7TIRpqgwNtwjX9/+YQfbPbsAVNQ5sPF9YBtLFt27qEvVSDk2nvBtLuz8RDVeUhJBYR1x3idrphtG6wHunffKEGJSc+WQmAFdVnB7rIj7YoomHoIwKJnxuF2ldT26hR08nQBYrkTH0yJAAF7fyBtiDsozc82vJF9k/0maIkzHn6NJJDFAbDFdmSwQ1xMzKHMgJn/fgtyeJ3Se+5HUZBb/bag149jmC68QcUiNm0WUonQ9hqEuVDRk7YADSPDAvXO5rqfcwK17A6WjdRy+7Tm/lzJtMU8kxBLPNjJJ1D/nxO/DtIiS4Xmi62KWesvFP/Iu0L6qkiNEb1R5Ol6J+FLPtYjXO8hS+v9j1BZtJm4Y8VB5eVTsMo9Bj+xKqfq8Z7lMpadUKzpRtG94b5cnN0lGJSldzB9pNzBrMhJZK9b7cJh1Q5mGn55NBpfipi1/HNXdw0XAOxWo8vgf+519yXrhp1+RUexYMqQ+7usH7HIXOn3aWvodDcZPdog/svOy8I73s6VXkRz3rf0uReB0/2/Vo2otUfGNFvsCsQQVe63DDc3+GeLzf6kJKagIRou/VS7zrNGL2uj7+PZV329+Qmjwan7WPZAj+MZRd9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(38350700002)(38100700002)(6486002)(966005)(8936002)(66946007)(66556008)(66476007)(8676002)(4326008)(508600001)(5660300002)(110136005)(54906003)(36756003)(316002)(26005)(6512007)(2616005)(31696002)(186003)(53546011)(6506007)(2906002)(52116002)(55236004)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alNwdHAvVVZhOHQ1LytxVEZnNDlDZDNuRFZKa0swSllSTjh3YXEzRTVYSHZy?=
 =?utf-8?B?T21hMnE4VDI1VUxIcTgrTU9nTUhuZFA4QStBYzM1dHlybkJOYVJtdVVOOThL?=
 =?utf-8?B?eEVuN0h4MFE0bHVZWjgzOTA1bHF1TllPNEtSQjk0eHZYL2xxRG5KbUljZzhW?=
 =?utf-8?B?QVhNenhPQ0RZd0RPNDl2M2RIaWNFQVB4ajBFUmY2b0NRMXFxWXdVV1NZWVh4?=
 =?utf-8?B?WmhrZVJXSDVEYVNwZloxQ0Nnb3V1T0J6YTNWNzZKdDRKdm5RbDFhQ0U1RCtr?=
 =?utf-8?B?YktlV0s4MHg3aDNLMUtRUlBpM1IzcGdyTGN6UGFpdG9BdU5uSHU5TTNTNjRT?=
 =?utf-8?B?a0M4bkIxek52K21oakVDeUNaaE94cnU3dWlIQ0JWSWYwYy93RDgralh6ajRG?=
 =?utf-8?B?YUlTZ3NEM25PR21veTVLM0xMVWhYNHRqUWp2eGN0eXZMQnpqUmRCTEVaZWpF?=
 =?utf-8?B?bXdtdUp0N0ZzWUEzSXpVbWdjc3pSSThCNUtnL1ZaZCtvYUQwZG43c3hwN0Vp?=
 =?utf-8?B?Ymw4K0RxcXEzNXpYc3NRckp1R3F0SjF1V2ZnOFhxZDAvaW1lMDNIKzBqcWpH?=
 =?utf-8?B?N1JGTnJhbEJEZHhTdkZqOE94cWkzS21qcEl3Q0Y1TTFZZ3FQbloxSkU4MEx2?=
 =?utf-8?B?Mk1SY05BMENNeXhjSXZlVm9Bekd4L2xyenVMNVNBWm5aR0Y2NzlzYVNXOE5z?=
 =?utf-8?B?TU5vcm51Tkk0NnA3UFdrcWhxQWJFSnpCdS9LWWovbHpwQXZIa1owbEUrcTlk?=
 =?utf-8?B?NlVxSHRIT0pCRk5iREJBbUhndWhtbjV3Y0xmZEhBVVhETGtuT0RtNFVBM3hM?=
 =?utf-8?B?SE04VEw3cjA3Qi9yanVNREk3SE1xbk8yWHRDMG1qQ2lWbHo2VVBhQmhiRjQx?=
 =?utf-8?B?S0plYkpjUks2ZXdGV2ZETldVblJVTnlDN25MaU9kVFlTWStWY0V2WDdranBm?=
 =?utf-8?B?R0twUHUxKzdHRHBHMyt0ZFdzWlkrYnRIdEdPekdlY3BCM2ovMW01aWgraUNH?=
 =?utf-8?B?ZmdjdlBXWVpmMjZnNW15WTgwcXFrV3VEbStjSjNDNGZiTlNwckt1MWRuWVNa?=
 =?utf-8?B?V0hPbWQ1THR6aTJKMkdHaTJ2NllRTGZkR3dNOTVLVjdrbllEcWxXZ1IwMWNH?=
 =?utf-8?B?MVFsTVFVeWRxckNjR3ozY2pOZmhidGRmM3VWMHpFdUo3SXJNRDJxd3dZMjZD?=
 =?utf-8?B?ZEcrL2lPYmt5eStUUDJhcVVtUUUrNUcxNnJsQ2gwNDBKd2l0alJDUE9kMW1a?=
 =?utf-8?B?UWI3YzB1REhySWMwaENIYklLcWljeDByL3pvNXF5VC84R0h2TnZzdkF5MDEw?=
 =?utf-8?B?MDhRYS9TKzFoemxwb2EzczAvNTVrY3lCbTkvcktOc3RQZjduaGdETzBtVENH?=
 =?utf-8?B?c3FaRERsTm9GU0tZdXJMdE5WRHY3Mi9uYlEvN1BtTHYrR3dUOEl6Tkh4QURk?=
 =?utf-8?B?N2FsRlNLM1A5V1l2cUJiNTRDUVdrV0Rlbkx4SWpZSDhlRXdQcFhUL1pQWW5T?=
 =?utf-8?B?bHJ6eUxrcDIyQ045T1lPTi81NEEwbTJ0QWJud1RQNDY0ZXlPWXNLWndhSWpS?=
 =?utf-8?B?aVpBdk1sbzRrbldadU5LZmh4ZEREdkk5cGtZbUZES2lRR2Mxd2NqZHlaWXR1?=
 =?utf-8?B?WjJETm1lb1paaGVSNUhwbDFzWm9MWWZ1WEhXZ3l3SDAwNDB6a0NpaUtEUmM2?=
 =?utf-8?B?dU1pYVZGNjNnVjdrUjRxRFFZTlBiaWM3VmdMWjQ5UTFaeUtsaXNCUUhoOURK?=
 =?utf-8?B?NUcvcFk5SVRta05yNXhhZEcvNVV0MEZxNVZYZnExR1EzV0J3c3FGZi9nVlhn?=
 =?utf-8?B?cEVxdzg1YldwT01aaDhPUUIxWi9EOElqL0tSZU0xN1ZoR3ZiMFZ6L0hVV3hR?=
 =?utf-8?B?d0Zkd2ltZHJZK3IzUzRJUS90UXk3cHVBNmpsc1BVT3dlb1B4UGFZOUZJUGpS?=
 =?utf-8?B?cjV1T0JHcE0rME9pWG9MVHgrSkx4UkNXMjlFREs4NHVxZCtLZVhhOGlzN2lG?=
 =?utf-8?B?cEQ2M1l5ZC8vOWZUSmVEakFhbmczWVVHdXBHT2FOZkROREt5V1h1VDl4Tlcw?=
 =?utf-8?B?UWQ2ZWlmNVgxVmZwU2txS1JaVU1SaW1QRy85WThlTlRFL0hETWJEQ1dQNEhy?=
 =?utf-8?B?T2RZV3VwdmloMXhxYnBYQ09QTmJRYWh5SHZhTzJ6eXRON29nbVhUWE5panls?=
 =?utf-8?B?ZU5qSklMeDNuV0JEWEZFZFlVNlY1VTF2YlBRaHQ3ZUxsRUh1WHp0TEpYb3Vo?=
 =?utf-8?B?SGF0KzBwSFk1YzNuc0g4eWJzMCszamVDRm43cEEvelROTy82VlkyZkMrRnpm?=
 =?utf-8?B?alhyOHIyM3ZucE5BeUFXei9ETGRTTGlMWW4xS2RUQTNwSDVoTi9PZHRGcWtn?=
 =?utf-8?Q?YKsE+NOlHBa9QWc0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c385ade9-2b81-4453-0e40-08da224485d9
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 20:38:12.8356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9cjEc9doBcbU7ypgkMDub0ewm9BHZpMS1o3WZBtnv0NOinBEGNDVExCgL1oE8qK+242AYIsxQ78SwcDljGZd8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2609
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/2022 2:45 PM, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
> in HRWNG") the following CAAM errors can be seen on i.MX6SX:
> 
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> 
> This error is due to an incorrect entropy delay for i.MX6SX.
> 
> Fix it by increasing the minimum entropy delay for i.MX6SX
> as done in U-Boot:
> https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG") 
> Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
