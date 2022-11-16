Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CAD62C5BA
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 18:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiKPRDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 12:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiKPRDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 12:03:36 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80105.outbound.protection.outlook.com [40.107.8.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDB0E02F;
        Wed, 16 Nov 2022 09:03:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUZWw8aQKNerIfIxpAO9n09gRx0qm7Tgtw/24MQ7ejJFeK5WbKYnWWHkbI8q/kg0zKLApK6VVFJwbDCSuGsxQinMqqMdvbB8eOCy3UDQFSPo9bH4W8hZFdEIxTMfmnVgV9r9FYfGXd5kwBP2A/lC/OO4S91ACBmYhId4Q8bXbmSj9rTYwOaS/K2X+fl4tx7JJeNW+ZfbB8XbksHVhQrjpg6NHyfzlnlaIuU5Ho7McN8Se/lU+meYI/0tqrswiego1kMTKHdPAmy+369cW5v4b2zYieVtXQPahp44lGDgI5yNeLfYAwsrNeHwklFkswQJVnSo4LTeylomfcJuR22IYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IP+SzRhntBnwrZV6C/365RGNu0bWaErjdNUoHCz82n0=;
 b=aJDBSmBQ07j0nNIA0A3e7FnEGKp03EFoT2X2Kxv89oh634jTTct5kcfYSFHXqp0cMy+apUO6Frefz+re5C49qbxg9Hvgne/tizbMN9xd8iql56Z6zJ8/3YfXwxhn/x3ItMTH7tAGbgOuG22SzSXrIr6tVI6hpH5PtIy+bjLA9RlQwKRgh389oHtO4wpZvGC84UEUKplKgKufhjdpBK6nA9aVXVloUsvv/HZfwSpD75T6VIbt6ZdctZUxoAD0Uttpcbz4z79amI2KPTZtgB2CK2dGZ3dmHQF2FVsLtWdxwuftEzSJYYgqerc6LwJUUSUY89R/nNB3wucEM4iqebTLWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IP+SzRhntBnwrZV6C/365RGNu0bWaErjdNUoHCz82n0=;
 b=BxEAIQ/uhwYCrB+lnuqQtEzt5QD8bZ+6NRhViF47C0vw2OP/w+Y35V/JDuXhX+z55QAI3gYkT+/Qxj3mmgto3z1AuzjdtTMkcpsYOaJ6MKm3d59imCFACRDoFLOlVQZKwkzWVmVe0Yz/3c354Qg/IEP5Vq5u4FroHBV3nvt+h7c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.de;
Received: from PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:263::10)
 by DB9PR10MB7241.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:456::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 17:03:32 +0000
Received: from PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::f209:bc86:3574:2ae6]) by PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::f209:bc86:3574:2ae6%5]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 17:03:32 +0000
Message-ID: <bfca8a49-a443-feb0-6fa8-0e7d17899a5b@kontron.de>
Date:   Wed, 16 Nov 2022 18:03:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] spi: spi-imx: spi_imx_transfer_one(): check for DMA
 transfer first
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Cc:     kernel@pengutronix.de, Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>, stable@vger.kernel.org
References: <20221116164930.855362-1-mkl@pengutronix.de>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <20221116164930.855362-1-mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0035.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::11) To PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:102:263::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR10MB5681:EE_|DB9PR10MB7241:EE_
X-MS-Office365-Filtering-Correlation-Id: b92b04b1-155f-4f78-97ef-08dac7f47dfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N5tlLETDDpB/AF6N1HWle8d9S9sBc0bq0B7smPI4OjLcpBTJhB3cr9zom3udkVaZFsQ1Tg2hU8BSEEWBtxVgpGSdohgu26JAaQNScdUzzOtWgGyx/c5FT4D57OsvnhCbeQecmMAdtNvSx65A9FW/VyWPBotRtOBD2QJ3cBZD1XM0ySCX3Ss7Em8XeKiD5BmvKy6f02QFvPlmBowqRFXJXuEoyXRzoJJGNcVYnD7v6VrXsuLKbWBJ9l5ytGsKDq1o975dSXd5quJUnGOdz6KUZEdi3m4v/02MZUqAxVUtNVOOKTN/FyS0W+SNpQM20ZAYzC5QVachpnCscaVjg++xg0C5WRlDPbrWgjzCnOESZrBXSW4Ccc0aw0hl8WENHqYV6d5+BqG+XatCP/sIXxl0/R42OFmQpdA0TZlAeMqZH5wMAAqjQJgr0AaQpbSEt2wwnoNtfT+aRd1vH8t5mLlPEQYoIYs12Mt7p6rDYhkReirQX+s/X/13Z93v9sP6mrJWIWpF+n18vj2MRCdJ5G4IoudxQNVOfokJMgzGEX2g3ovbR4A8gCZNjDV/eUPr4lTebmJX7tqfYw5n/8AKqMQwwZkSVM3WkH0RK8EsrWTbbE9eV2wsnBUdxfiYY88fq2AUCdG72f/nio0uc9NA8aX8FPKUZ8Kfswd6FYP+Heq9c+mbVwcmiPMmILdNNGsUZCRTWX/od/o2013Rs//UFCZFcKEXr0eOpVgeBz64N4bdFdtKSwsigs+CZ4puKpgxvfYrblkNeonXNS9Q1FecIlDmnrV6F413xOy8izB0tzpJLAQtII60FS84u+t0sEQu8rTa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(86362001)(31696002)(66476007)(36756003)(66946007)(66556008)(2616005)(41300700001)(8676002)(966005)(478600001)(186003)(44832011)(4326008)(8936002)(316002)(6486002)(6512007)(38100700002)(110136005)(6506007)(7416002)(53546011)(83380400001)(54906003)(5660300002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZktKY1l4UmtKWjUvdFI2K0ZObUhNL3JEcW1wSTdPZjkzQ21LLzdsYmhyQktv?=
 =?utf-8?B?WHdFd0xqbFFZamc2TS96VU1MVG9jTXAyT3daWFZrRGZhUi9mR0VrZ1ZNNk9z?=
 =?utf-8?B?TDI0TTN0TnYvQzVmdXd0RTRMSk1EMmlIdlV0eHM3MHIxUFkrVXoyODY4Sk84?=
 =?utf-8?B?VzdvVFpONXdTNGZnM0ZEd0Q2bEpzOWkreHdrR0h2MVJMVVpNdml5NmI5eHVn?=
 =?utf-8?B?N2ZBRjdLbkYzb2pMQ2tFckRsTmlGT0pXMGZlV1NIV2FuNmJGVGg5UTlNSlI3?=
 =?utf-8?B?c3Q0TjFxbW82WDJRZytrcFo4Y1dJVXdOVStNYzNDZi9vWDJBL1NTY20zaGhX?=
 =?utf-8?B?WjQra1U4SDN2dFlsTnhUa0lKNFFBbzBZUmYyTEovZkt6RlRDOWplOU5DdTFi?=
 =?utf-8?B?MnM1SHE5NGFRUHNBUjRUdnk5KzQwL0VJNWRFN0tBd1M4dVdVNHNFeXVGVWl1?=
 =?utf-8?B?MkcwOFIwVy96aU9yekZBZ0pkbEtPeDdKZW5hSGp4a0lpZzFQZC9RUnROYUxk?=
 =?utf-8?B?SFhDdlRNdlJlQ01saHMwSWVyck93OG9YMjJST1JkSTFyREUxMityMXJvTmN2?=
 =?utf-8?B?N2w3Ni9VajdlL0JoOTAyZnp6b1BzNjlhVWtJdVdLaFQrWTBVSHF3azlXdjRE?=
 =?utf-8?B?bm1sT3RXbVB1YWgwVjZYcnVCMjJidmF3N1QzcWc0d1pIandnZm0vT253cW1q?=
 =?utf-8?B?VHRHZTFaNU0zaVdzckU2dUZJUko3Q05yd3hyTWpUTUxJY0k3ZDM1N2x2endH?=
 =?utf-8?B?MHV5MUFoMzVadHBTcFNuUk5obTB6OU1XZzNHQ3NucFpVV0k1VGVGTzFoRk44?=
 =?utf-8?B?TVdHaS9Pd2dscGxzaHBVM29iWFAvMG1iTTBBYVk4WmxycVhvdklMU1BvNU1F?=
 =?utf-8?B?MDdQZU9Bd2JDdlhTMHlKQVRKV1IxSU05YjRLQWlOL0VJSGZxcnVKandmNXhN?=
 =?utf-8?B?T2VyM3pJMk5iN1dHRlZhbFNJNG1OUjF1Sk9McHgyMjVKZ3hhWGZ5MDR5L1pu?=
 =?utf-8?B?T0NJODAxRlE5UTd2QTdFTVE3Y1Izd1dZVDBORk9FSGJCUkM2NjF4NGNObENL?=
 =?utf-8?B?NmFFNXhyanJCdDdoVzdEZmJuVkMyTHlnUHJmNFRYWURjZUtZTUY3cER2aHRl?=
 =?utf-8?B?aHpXOUtBdGsyeFpIaHQ4TUVJVythNVUxa2NLanlMUzRkZmROWGRBdlRoSGJo?=
 =?utf-8?B?VlpsZ3E1MUlZTVJhenhxS2xqbTVPbmlMemJuR0hxeWlXRS9rakF0YVl0WkNE?=
 =?utf-8?B?RXgrY25LbUpGVXlDdzhndkVPQzcxSE5NN2p0U3E4eVpzbXdIWCtiaWQ0dDBj?=
 =?utf-8?B?NlBEVndKSWxHZTlqa1AzSG5VUTFzTnFJZjdSWm12RkRjdmkxdzI2RDdjSGJu?=
 =?utf-8?B?S3B4aHdieHh6U2R2UUxGUFJRVXYwNmRkTEVRVkh2UjNwL25VcDh3UndVd3g2?=
 =?utf-8?B?VHdGK2Z3eE53V3VtR0dXK2FOZ0pOZWk1OUs5Qmg4Vy9yQjRaTXhaSnQzRENj?=
 =?utf-8?B?QUZvMDV3NXhXaU5IV0tzTDdCdGh0N3dGR2ZHT1JzUkxEK3VlVjVsRkVSL0Vi?=
 =?utf-8?B?Zk84RkZBWTJHSStPemY1azRWN0xpYWw2R296T1lzUGlFaVA4QUp2SFAwWWNr?=
 =?utf-8?B?WEoxUFBkdTdWaHhpOGFvM2cyYkI5a0hiYkUvNDhIRCtQU1d2OXBFc3JkeDNO?=
 =?utf-8?B?Z1A3V2liK0F4UXFWNXJjZjF1bEJpVmpwY2p6aFJOTkgzdlkvTldramFxWktw?=
 =?utf-8?B?K29BK0pZcjBxOXVFL003U3lReVE4UjdndzgwR1FoRkhzVml1UHJUdHpPNlZO?=
 =?utf-8?B?QzVSclYrRytGWW1YTk5hR2UySS8xRnlRYUEvaS9JUkF2d2ppTHBQQUQ0TFF5?=
 =?utf-8?B?em0vaEs4K0V3cjU2T2hVNi94YTYxVWxMbVBqV1MvMkVNWHVUdWxQRk1BZFd0?=
 =?utf-8?B?ZW8rd2NRUkR1Ymt5RThLanFBZENWRUVvelRxcFFFTlJoMkNmb2huYWJ5WXN5?=
 =?utf-8?B?WHpsL0p2QW5JZFRTcUxRODdQcVUxc2JjNUF0NVBlK3BZckRFTStUUjVoeGV3?=
 =?utf-8?B?QnNnZmt6OXFGYWFURytENmZ5a2kwS0kvazBTN0V1bDRDMTJhVUlkT3VqY211?=
 =?utf-8?B?THFJdll3bEhXRDNwVGk2K1pjT0pKUUw2aDFudzJYOGNPaFd6YStjRWV6c0pX?=
 =?utf-8?Q?XgtN7a2GLv2dxt0c+EFbx3IQWdL4LAn5ObSip0Te/NCx?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: b92b04b1-155f-4f78-97ef-08dac7f47dfc
X-MS-Exchange-CrossTenant-AuthSource: PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 17:03:32.6936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVuRBUC/8LAkSigm9L1CRUgfzsJDMrzx3u/zL3z3nvwUry7Gr9yGhTU/RIuXMJDwFTpT+PVa7vRrhl9yXwk4sXNhGSvOYzXmOXWlrHEavyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB7241
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.11.22 17:49, Marc Kleine-Budde wrote:
> The SPI framework checks for each transfer (with the struct
> spi_controller::can_dma callback) whether the driver wants to use DMA
> for the transfer. If the driver returns true, the SPI framework will
> map the transfer's data to the device, start the actual transfer and
> map the data back.
> 
> In commit 07e759387788 ("spi: spi-imx: add PIO polling support") the
> spi-imx driver's spi_imx_transfer_one() function was extended. If the
> estimated duration of a transfer does not exceed a configurable
> duration, a polling transfer function is used. This check happens
> before checking if the driver decided earlier for a DMA transfer.
> 
> If spi_imx_can_dma() decided to use a DMA transfer, and the user
> configured a big maximum polling duration, a polling transfer will be
> used. The DMA unmap after the transfer destroys the transferred data.
> 
> To fix this problem check in spi_imx_transfer_one() if the driver
> decided for DMA transfer first, then check the limits for a polling
> transfer.
> 
> Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
> Link: https://lore.kernel.org/all/20221111003032.82371-1-festevam@gmail.com
> Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Reported-by: Fabio Estevam <festevam@gmail.com>
> Tested-by: Fabio Estevam <festevam@gmail.com>
> Cc: David Jander <david@protonic.nl>
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
