Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA2F6586E3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 22:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiL1VEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 16:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiL1VEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 16:04:21 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2131.outbound.protection.outlook.com [40.107.20.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2078A120AA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:04:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPo2Neq6UsmpRV1wTmR/FU98BxxQP7D7J48ZTEObCBLkBLLyBoDoHgmVYEbs5L/xnGITjg7b76ty6ybSDblXdqxdM79tDOH6U3fsZPR4evMxa9EqrM+ZJKhvsAT2Wf4Omsi55wslyTrQbu2tA2MLfpiv0rni0xfQNgYUumwa3JcdbVBDVdUd9/sUYVPwCN9Td/29/FDOoWHt2FQAxoXInUkLAbr8YEAX0Y29eQeQOe+dA4Y8CDXqIwTUe7e1ACva+o0sgJKCuXXquwWQQHUJh0ALxKyZ9ua3Ps/ZSkUsggw4MsQSxWvWGmcDFF8almhgbXKxbE/VpgY9aAU4obwKMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJKle0XWrwjP4SVniqnBTUblUW1PqO2KxHM9wkmQSkc=;
 b=ERpQGFDtI3AZOd9V6G5QEdwEgKrVTyz6DVKmetzf0likJ/leRAR4NKaH8NdPLZbyQoXQXinfyy9nw1c5YULM7r+KJv/OxchhAIXaAhXExkPp/ia7nphyflv9ZACrMSbvqeCkBtDsR5k4KvxWporpHMlcQYyaUwKiwAc4Dl9l2+SkYf2Rn5ggSiNENyxEmqH3G33EYY62ULGL8o5zVeSLbhNrIWm+8N8cQpVGwcwP/Hhivo0TpGc7w/zgW57bimUvLPDgWuELrxaRj/ZqV/V0RHrT6aCtok4iHdG/H7A2NNBH5986okiFl9CS2n7lzLIJvksmAda64WsYxfU9Y3+Shg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJKle0XWrwjP4SVniqnBTUblUW1PqO2KxHM9wkmQSkc=;
 b=mX2RCuD7UTEAJTGS2/pG0w4Sc2IEP6SCznSdM7Z6baSlRYDZTNIbd2fBs0FdrZvQkPrja/bq3NiAd+UnEHYGYvCEevr1chc1keKmhfcPBBQNUv+Wb0tumTlFYXe8LKbWODcFE/wVpCm3K+TcNFuX57ENe2tdHnvzMrs1pQ5A+i0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axentia.se;
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com (2603:10a6:208:ed::15)
 by AS8PR02MB9981.eurprd02.prod.outlook.com (2603:10a6:20b:617::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Wed, 28 Dec
 2022 21:04:17 +0000
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::a30:dce8:eaa4:7687]) by AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::a30:dce8:eaa4:7687%4]) with mapi id 15.20.5944.016; Wed, 28 Dec 2022
 21:04:16 +0000
Message-ID: <a3b6d80d-cc1a-be21-9842-d9362bc372e6@axentia.se>
Date:   Wed, 28 Dec 2022 22:04:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 5.15 456/731] extcon: usbc-tusb320: Update state on probe
 even if no IRQ pending
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Vasut <marex@denx.de>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144309.770876879@linuxfoundation.org>
 <20221228154501.tinymudo2j3kzyii@bang-olufsen.dk>
From:   Peter Rosin <peda@axentia.se>
In-Reply-To: <20221228154501.tinymudo2j3kzyii@bang-olufsen.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0098.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::30) To AM0PR02MB4436.eurprd02.prod.outlook.com
 (2603:10a6:208:ed::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR02MB4436:EE_|AS8PR02MB9981:EE_
X-MS-Office365-Filtering-Correlation-Id: df76b479-8831-48fe-5ece-08dae91714ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U/ey83scOP8ye3X2dk1ylkC4hHx5gN2X4hm+rRJCYvCYjJq5joZfu1LZWZIA5Cg0VeZaolVNx4Rc+al04Lsg5reU5JmNYRm+ZkHOqtqoY8yYuiyzit50HQenExpd9unw+NLowuRDWqjXWtABM0mHQq5Mwkw1FK97F54GGiDs1wk02FIATknQZXCULzr19hLOy8kgGXyRbJbrcn6WR8VxrcMKv+bqWgspBW9C7NqpYLHmHDHrFriAlHi/6rMm1eFeQxLvn/wupOyLDTIzn8OA9iVySJThJpAincIc3GbBA8tGqbnO1jlxm6/w34wx+vwo++0ke6b4Nq/3oidqbkU4LSjX8l+Sbent3o519K+7cNtMjlHb+QX9+C5GnYcMgw8GK02FyieYCW/ao/uq2dfzqpO0FdFlrBH5Zv1ZXdZGlt7jsyFuirxKsOR1h3m07mNla5wbr89iNWDy8M5aKWD5p30+L10JIZRwvbId04vJ2X8iHEhYjyzJlp+LhRknE62esSlAkACazj28+r3Ozpaa9L368jDpDWzjXvPCSDEk1A/5LnXSpj7YzPvMpCgxB/El+E2RfO1qAh3QHGGAkTLnopXeebd6lnTS6mwkYNRqVH7FNoVCEgYU69guHdhT3Tho6ROFSB0z3Ep21qIGuU5i4mqPURVvLWNji1hJXfjRMKEpFcGVbvWn1m/SrfWEc8UozQS+3YHAjes6i1otZEeQCAu0bq8ee2/1lYa9WOFE4ZQXXr5KBoqFkarCDZxn+l/Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB4436.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(396003)(376002)(39830400003)(451199015)(31686004)(8936002)(66574015)(41300700001)(83380400001)(2616005)(66946007)(8676002)(66556008)(4326008)(66476007)(38100700002)(26005)(6512007)(186003)(316002)(15650500001)(2906002)(6506007)(5660300002)(31696002)(4001150100001)(36756003)(6486002)(966005)(110136005)(86362001)(54906003)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW96VGlaVGduNmtoUHFKRGVuMGw4ZlpSUkJhbXpFQnJGa0ZJbjYrWFhTc1Nl?=
 =?utf-8?B?ZThmQWVLbVdhMHdNa0Ztb0JSMEF0KzJVRmw1Z1RVVERud2puVWlpZytnUDlB?=
 =?utf-8?B?UXhEeTZVdUtrL3FGeHBzbTR4ZE9UWHZXVitBbWo0ak85akhrR2w4YjRycVFD?=
 =?utf-8?B?Mld6Nkw5c1BCVGxVWnpmU0lCU0Zlb21uL1pEa2hmS1dOOEhYNVBGc0w3ZEd3?=
 =?utf-8?B?QjRuaEhWRHNTNjNVdnVEQWErejVOOG1tME9SdXBNSklIeUdvakZHczhVcmkv?=
 =?utf-8?B?UUQyU0xPdjV1OThkbWJGZXpLeEI2Wmw0MEhNY1BwcG5mMUQySS90YXlHVWlp?=
 =?utf-8?B?QTRqU0ZsbjN1bG05WC8ya3JNWUlNOGtzZEdCMGRNL1pGN0Z3eUx0cHBMbTNE?=
 =?utf-8?B?Rzdhb1V4ajcvdk9sSDVpdnlKeEIyU3Vjb0dORDF2V2xsODY0N0lnaGdzT2Nn?=
 =?utf-8?B?azJJV01hWUhZbnVxU1QreHNoQjl1WUFNeG96K1pzanNiYmdXUkw0Mjc3QzJt?=
 =?utf-8?B?UE13K2h2TXZSRitQdjcxRmlwQ1puUGR0WWw5emlaTFlpSDVIa2xmNGZNbGUy?=
 =?utf-8?B?T1NETERWRGs5aTJZRVlhd2VoRnNXa2IxNEpudUx0VzY3T2lpWTBjQzhKQzU5?=
 =?utf-8?B?WU4xT3JWTUNvdktQdGF3dE9JZGZXUFZndVlUemJ1NVVxVzZDODhsN0pvT0VG?=
 =?utf-8?B?enlsZ0p4dVVWQVFhaHdIU0tCYk5RanVjcHRrQklMb08vRTkybVJmbEM5SHNv?=
 =?utf-8?B?MGk3Z1NxenEyU2FSTEhKM1lMK0FaSUEwUC83TDlYaVVLY2ozSnp4V2NZTnVX?=
 =?utf-8?B?NWhvSno0WGd0d0Ftczg3V0xkZDFveVZyZk5lU2tlQVFEeXBXYzFvY0NabHkv?=
 =?utf-8?B?V04waEJVdkV3U1puSWNzRWJvSGR0RkNaWWRRa1pwaGE0cWJ6US9zcnBoNElQ?=
 =?utf-8?B?VU52YzBBM1I2UzVSb0VYeHBQMlMxVDlPSmdoL2pMeU9OY3Y2eGRhRStQaWdG?=
 =?utf-8?B?VVo4TEx2TlgzM0EweXZ4WUkvbk5aVDQ1SWdWWXBrQ21CaWRXNTFQdXFydDlI?=
 =?utf-8?B?U2pnTDJLTklveDBmOXB0Ny80NnFJRUZTeUtHKzlkbi9Cd1B3cE50Y3FGVTJh?=
 =?utf-8?B?cStSbENzRkV0Nm1mTGN5aUQ0dFZvcTdjRG0zYmdsVzhwZllIOFp1VlBHd1Z0?=
 =?utf-8?B?RzBzNmNMRTkxY0U1aE5hWmUrTFNlRXpFZlpZb09SdHI2b092ZUNFeUdQSVht?=
 =?utf-8?B?dzFOZERYb1BZM09hY09IRzFPU0NaMzRZajE4aXJmWXhiVmFmeTlYNWQ4ZW55?=
 =?utf-8?B?UXE2VkZNU2x1V1ZtdmxsR1ZlaHhSREFqSW51MTVOUzFpeHN4a3hMRXVvQ29t?=
 =?utf-8?B?V2IrVmlILzJURXVTL3pkSGJIdDlJYjVwd0RhdVljQmprT0JpdnZlV2FyM3JJ?=
 =?utf-8?B?SGswZkZmZ0RFcTBKTnBtZmxkTTBXZVI5eU84bTQ2cExSTlFQRVpjTVMrK1Vq?=
 =?utf-8?B?aXdTSTBTNTExSS85UEhvMjIrWm5pdHpvR0dBVTdXUjd0NWpBQUxITmNYcFhx?=
 =?utf-8?B?MEc3RlJ5QnJLUkNsY2hyWTd4Zkc4OEJuOW9MUFNRMmhPZGN5UWYwNTloSUx0?=
 =?utf-8?B?MTVWd281RHdIZ1NEaFNrZTVHQ3orZzAvcjRKVDNVZHBiV3AvUG83QVZsdHZl?=
 =?utf-8?B?azhTSFZpcjcxMTdKUUo3M1JhVHl6RS9qbUcrSmpad3V2TExXcS9ObWVaSlF1?=
 =?utf-8?B?V0dTa09HQmRGYlFLcTBCNEhEOWI4bTVZUGswdlFNWU93NGV4NERkMjgzSm5w?=
 =?utf-8?B?dGsvQVlhQlFudlEwemhlVzMrak5CREdoTkZvdDgrR2FDWHNFaG5VZjhhUStZ?=
 =?utf-8?B?c2oxbldFRmJwMXYwb0w3SEVZT2p1dkUrVHNndGh3U2Z3S0kyMTBlYkptVzZ5?=
 =?utf-8?B?VWhMam01d2ExOG1CY1JTT1dGQmRmWG5vUE9EN0NrR2dpa2pPZkI1Qmxwazlm?=
 =?utf-8?B?K2tpZ3puZnlWZkNPekh2MlhGQWtJd0preW5jYzhGRVBqV2pNTjk5cGloWndr?=
 =?utf-8?B?cjd4bFNLVXlaSjRidXRscStBV0pxTkJZSEl2clQ5TS93ZmpIZWM2TlBiTkZH?=
 =?utf-8?Q?MU1fnQoTZQrzgneD8mtl8yQVZ?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: df76b479-8831-48fe-5ece-08dae91714ab
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB4436.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2022 21:04:16.7891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7vmD7K8HDqL1Yq4yqXnIzpvkV/mqEtlrkH6Z+iNSXbRtMv2B1Wdm2BFKjKhe3Oq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR02MB9981
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

2022-12-28 at 16:45, Alvin Šipraga wrote:
> On Wed, Dec 28, 2022 at 03:39:23PM +0100, Greg Kroah-Hartman wrote:
>> From: Marek Vasut <marex@denx.de>
>>
>> [ Upstream commit 581c848b610dbf3fe1ed4d85fd53d0743c61faba ]
>>
>> Currently this driver triggers extcon and typec state update in its
>> probe function, to read out current state reported by the chip and
>> report the correct state to upper layers. This synchronization is
>> performed correctly, but only in case the chip indicates a pending
>> interrupt in reg09 register.
>>
>> This fails to cover the situation where all interrupts reported by
>> the chip were already handled by Linux before reboot, then the system
>> rebooted, and then Linux starts again. In this case, the TUSB320 no
>> longer reports any interrupts in reg09, and the state update does not
>> perform any update as it depends on that interrupt indication.
>>
>> Fix this by turning tusb320_irq_handler() into a thin wrapper around
>> tusb320_state_update_handler(), where the later now contains the bulk
>> of the code of tusb320_irq_handler(), but adds new function parameter
>> "force_update". The "force_update" parameter can be used by the probe
>> function to assure that the state synchronization is always performed,
>> independent of the interrupt indicated in reg09. The interrupt handler
>> tusb320_irq_handler() callback uses force_update=false to avoid state
>> updates on potential spurious interrupts and retain current behavior.
>>
>> Fixes: 06bc4ca115cdd ("extcon: Add driver for TI TUSB320")
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
>> Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Link: https://lore.kernel.org/r/20221120141509.81012-1-marex@denx.de
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
> 
> Is the Fixes: tag here actually wrong? There was a regression report here:
> 
> https://lore.kernel.org/all/fd0f2d56-495e-6fdd-d1e8-ff40b558101e@axentia.se/
> 
> which this patch fixed. But according to the report, it was a regression
> introduced by Marek's recent addition of typec support. Since that new

The fixes tag is correct here. What is wrong is that this patch does not fix
the above reported regression which was instead fixed by
341fd15e2e18 ("extcon: usbc-tusb320: Call the Type-C IRQ handler only if a port is registered")

However, this patch still fixes a problem so it should be considered for stable.

From only looking at this patch, it looks easy to backport to kernels that do
not have
bf7571c00dca ("extcon: usbc-tusb320: Add USB TYPE-C support")
and its followup fix.

But I have of course not tried, so maybe I'm wrong...

Cheers,
Peter

> functionality is not normally wanted in stable, can these three tusb320
> patches simply be dropped?
> 
> Marek, Peter, any thoughts?
> 
> Kind regards,
> Alvin
> 
>>  drivers/extcon/extcon-usbc-tusb320.c | 17 ++++++++++++-----
>>  1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
>> index edb8c3f997c9..b0f6e16ab0a9 100644
>> --- a/drivers/extcon/extcon-usbc-tusb320.c
>> +++ b/drivers/extcon/extcon-usbc-tusb320.c
>> @@ -313,9 +313,9 @@ static void tusb320_typec_irq_handler(struct tusb320_priv *priv, u8 reg9)
>>  		typec_set_pwr_opmode(port, TYPEC_PWR_MODE_USB);
>>  }
>>  
>> -static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
>> +static irqreturn_t tusb320_state_update_handler(struct tusb320_priv *priv,
>> +						bool force_update)
>>  {
>> -	struct tusb320_priv *priv = dev_id;
>>  	unsigned int reg;
>>  
>>  	if (regmap_read(priv->regmap, TUSB320_REG9, &reg)) {
>> @@ -323,7 +323,7 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
>>  		return IRQ_NONE;
>>  	}
>>  
>> -	if (!(reg & TUSB320_REG9_INTERRUPT_STATUS))
>> +	if (!force_update && !(reg & TUSB320_REG9_INTERRUPT_STATUS))
>>  		return IRQ_NONE;
>>  
>>  	tusb320_extcon_irq_handler(priv, reg);
>> @@ -334,6 +334,13 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
>>  	return IRQ_HANDLED;
>>  }
>>  
>> +static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
>> +{
>> +	struct tusb320_priv *priv = dev_id;
>> +
>> +	return tusb320_state_update_handler(priv, false);
>> +}
>> +
>>  static const struct regmap_config tusb320_regmap_config = {
>>  	.reg_bits = 8,
>>  	.val_bits = 8,
>> @@ -460,7 +467,7 @@ static int tusb320_probe(struct i2c_client *client,
>>  		return ret;
>>  
>>  	/* update initial state */
>> -	tusb320_irq_handler(client->irq, priv);
>> +	tusb320_state_update_handler(priv, true);
>>  
>>  	/* Reset chip to its default state */
>>  	ret = tusb320_reset(priv);
>> @@ -471,7 +478,7 @@ static int tusb320_probe(struct i2c_client *client,
>>  		 * State and polarity might change after a reset, so update
>>  		 * them again and make sure the interrupt status bit is cleared.
>>  		 */
>> -		tusb320_irq_handler(client->irq, priv);
>> +		tusb320_state_update_handler(priv, true);
>>  
>>  	ret = devm_request_threaded_irq(priv->dev, client->irq, NULL,
>>  					tusb320_irq_handler,
>> -- 
>> 2.35.1
>>
>>
>>
