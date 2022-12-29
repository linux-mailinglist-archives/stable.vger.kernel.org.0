Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86968658805
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 01:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiL2AJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 19:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiL2AJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 19:09:21 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2123.outbound.protection.outlook.com [40.107.20.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3490614D0E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:09:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wh98rOjGNF0XVAahQkHsXAomBziYvOdShWy8D7ZPmORBtr3s9qE8jkUdpIrHlrQY3Wg/U5q5p4R/NjAHh3UNuTclhc40CqxHSYpFSNOdKfH4+5f7znaoYqLQEuqjHweyw+83rhyldwM6ucvvE0kInZCiKihA+6wSX1Re8Z37u4vzd9WVVuhRnFuotsOmL30oETFTVAxljGx0T/iCVGZKcqK0GA5NgFvpulL6awaIjWJ2Gz7UgwDX7ccNnQ+plcFrM3HT65BY4SwadgcFTg0Gb0AErMY47tFD5P0ZPUU8xWJ8b2lRgJrHgybgOebPW4JdJPTCyREY+pctbJxHmD2SfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALH08JXKRbVt7dkZHMHlgOiW5henC5dHcizpe3Gqdqo=;
 b=IsC0+/c9M8x0bARk59jPr37UT0I+fq75GUm0dud12YjXk/hdceti+d4lRSxrfQCHSwTmXFgNwLUHfCJtW2l5mRLzdJ7Lq/He4MQfbspKJOdZ7lIhY2mHH3zb/GQ7/jcuZhmk2iXRZ9TwtrDISmTzm++u46z45cI7ZGcCXDGEOsDHtuBKQAMrilEpDXcOoz3Rq5sO9jhWbxRI+4uFCi0uuqr/XCmgk6OomGbCWrsXfvPSak7J+jV90ZlmjCN4T+AnmDoFn6WHO+lHxE5x01kpb/j8K/M2QJeWe+jYFheEskFnPU+BFXIx6Lmz7tSfCZidPpGgCPEOhUlNw/X6RDjwHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALH08JXKRbVt7dkZHMHlgOiW5henC5dHcizpe3Gqdqo=;
 b=k/EwE/1q6ect7tpHCyCzcntCNn3IPlHiB8A1wnD53RwoKHV7gNFa7WCFSsUjS7O7JAkIPfRkVJaHT38z9gxojtbHZl8ZFAyCjgJSI2spLKUTUCgIservKFHB7O2xkhBhwHGTATZ4CK+At9+dIFxP78agyceXA6hPzxAopbKpTBw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axentia.se;
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com (2603:10a6:208:ed::15)
 by DBAPR02MB6200.eurprd02.prod.outlook.com (2603:10a6:10:182::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 00:09:15 +0000
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::a30:dce8:eaa4:7687]) by AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::a30:dce8:eaa4:7687%4]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 00:09:15 +0000
Message-ID: <44c25160-0cab-1a41-0551-57c8efc5f058@axentia.se>
Date:   Thu, 29 Dec 2022 01:09:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 5.15 456/731] extcon: usbc-tusb320: Update state on probe
 even if no IRQ pending
Content-Language: en-US
From:   Peter Rosin <peda@axentia.se>
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
 <a3b6d80d-cc1a-be21-9842-d9362bc372e6@axentia.se>
In-Reply-To: <a3b6d80d-cc1a-be21-9842-d9362bc372e6@axentia.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0087.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::33) To AM0PR02MB4436.eurprd02.prod.outlook.com
 (2603:10a6:208:ed::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR02MB4436:EE_|DBAPR02MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 123316c6-d7e4-45cd-87fe-08dae930ec03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOmOI5nKLOpxUMb7GANTtuWbwrIJY76fmhYJs5WWuKLnmb5zglLxyfOSEx6VxNVkcz+MTI+q/k8u9zok9yIpQrwBLvsRj5kqMtHigFY6AxLiMFPOxKRgOiNrMUWVrvRtP/r6x6g3fAbOAvLbqlwPMOC+lS7Y4q+zxS0aS0+Uh0tBtdkJ/vN/pq8dfd7Bd+vkCtvCjzYSnj02BH+YiriefUG+QfwQJ8hw5ByLHIwLewvNKgHQx/Oa2cfhyDnMoTMKAND912RzNJ7K1CVLn07bDa7Kx/7RZ1MAvyek9hQnxJYGXSpVGkMnqZNuuGCYye46RQQtAsHuKnlE93XxBwGjkO35Lp8ojf22XqAlbZACVT2AQ1TdgXeC51J72OvsOy1Yd3K8VqkDYJFO9Vf6Zbr57aaAoRvEA6O+cBLiuT7O73/DhyLP7A/Nb+PvY6Tmn8EbGQZ/v3qo1EoFYL9lhfc4BaOucRI/VcFbkVdeNSwt6FDnKBDLWSkE2zAak0xWT57us/q7lqQeKYPRy4PwqNn2v+LqK6ItkLJLEsYZhXctnyxbla82R72t50BU5VIuT3l4+yZEQrfQDRUT6HbbCZqbi4+Gq/hR+T5HW0voECeUeHcw3BQoqnBDtKZa5njUExV05E8XrCh8myer4qmuBBfARqG9hkfbWn2bTClOLH2c0IyPDTySx5ohmQvwflsqIOyhDA4PFx9NeHb9fNw1gQa1iIsH+t7uVteQg+r//mg2iaH9Sda4FOaJAWD5AnJYdI2dlWctOvf2+8nHUIFzto1aKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB4436.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(39830400003)(366004)(136003)(451199015)(86362001)(31696002)(26005)(66574015)(36756003)(6486002)(6512007)(478600001)(186003)(966005)(8676002)(6506007)(66556008)(66476007)(5660300002)(66946007)(4001150100001)(2906002)(54906003)(15650500001)(316002)(8936002)(110136005)(4326008)(41300700001)(38100700002)(2616005)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dm1wOGNTeXM3MVdRUFpMbTh5K0xaRHptRWwyM2RFN3JIVDlWVlU0YzhuNXFu?=
 =?utf-8?B?TCszV1hXZTVpZTJxbWYyb0tYTXhQbVIvUGNwYzlpSzUzNzd1T0h1S2JaVFNM?=
 =?utf-8?B?VEU0Yi84RHQ2THh3ckpSdzRCTjZaZW9GUVNXUXg4WUd0d0ZYLytQS3JPV3dV?=
 =?utf-8?B?ZCtKckJReDFBellMQThveUtPcVlwZFUzbnBVS0N6a0lYVEVNSGRPTmhvSkY4?=
 =?utf-8?B?bXlmaGltblpxUS91aU91N1dnZWNLcmQ0OGtTWXdLbFBEYzNEU2R5OE9iODYy?=
 =?utf-8?B?bkpkVXdrVDlqb3hXdFNDRHdhRFFkUXk4UkxVcFZyQVdlQXpOUnpRL1dLVTha?=
 =?utf-8?B?dGkxdGE4TFg2VXJsSmtFTDFabzZUS2k2UFNEdFFacGxkTzFxL3FPMGJZaWQ0?=
 =?utf-8?B?WnV0MVdqQlJTc0NXNjJkZ3dxZjJnc1k4TXBvYS9nQ0JmWkl5YXUwVzR0SFhC?=
 =?utf-8?B?ekdpaEN3T005ZHg1bnNXcUFTRkV2YU9wZ1orcWJyMjJSVSt3YzhTM2tUaEpu?=
 =?utf-8?B?bzlSYTNzQWJFeUc1NU1XSENiN3ZUSTF4ZnRSRW85MVk2S1UwT2JiNlhSVUxx?=
 =?utf-8?B?QjdwREIyY3Bmcy93RzlLRTVqdHFPTEprTXBSRkdBbGZVN2ZCQjM5WDNOYnpU?=
 =?utf-8?B?bU1QbkxaZFN2ZnVmN0ljWWtqR2crZGlyL0hrS3pxamtydklUR094M3hhRGt5?=
 =?utf-8?B?OFQyWFFqL09pMUpjbmkzejBkQklBOHhNM0hSMlAvREdON3dQUzZKWEtPcmcx?=
 =?utf-8?B?cUxDQTQ5TmxialBIYVFjRmJ4SC84b0R0K1h3Q01FTksycjBqaG5KQ2p0bTl3?=
 =?utf-8?B?N0RRT1hwNWowOEIrM0ZuaGpGYWNDYlRRQ2pTeGxHUnQzOHJhakxBLzF4aFFE?=
 =?utf-8?B?R0JOL2pNYXBPYnd6YzQzdjI4TnJKeU1wcGVMWTk5TG1icVpld09CeDVIY2ZC?=
 =?utf-8?B?WXFOdWFMSHVYaE5RTmEwSHhXV3MrWk1QcklaeVVkQ0dPREJxN3R1TFMrdDVy?=
 =?utf-8?B?Vjd2cS9wOEFseUlSU2JHOEY0QzhBWnFoSStzRWRHS3B5dUF2NmgrcEJ4M2xX?=
 =?utf-8?B?and2UmE0aUwwb1B1M0dnT1U0Qll1TkgreFJteXFKOVRncmNRbGtJR1BMdzJx?=
 =?utf-8?B?dkFHQzN0em5jdnFBOFk4ZVV1a2Jld296U1FSYlZBNyt2V3dXM3VqdllyRjR4?=
 =?utf-8?B?S0MxNm13U2VWNmdIQWhraXVGTXVMb2FEY01OQ1dQQzExSDlzczV3NHgrU2ls?=
 =?utf-8?B?OTFwdnBSbnFodnRzVS84OEJnMGdjV3BvWXdDejFrOEJwL0JjNE1zTjgyVGtv?=
 =?utf-8?B?NUg4a0gvRHNjNFFwUGFibUI3QXFldmlVZ2NHRHB5QUVkcFN1UENXZmV1TzBQ?=
 =?utf-8?B?VitnZytmNG1scXQ0cVV1bStDSkRaR3BNYThsck8xcTEwcDZMUE12MnpGaXJY?=
 =?utf-8?B?L3Z1MzlkVzUwZVJQZ0wwd0hKTXJmb1BOaGltRnFlOGJabFYydjVqbHpqcnBB?=
 =?utf-8?B?Wkt2R1lYMW5BNms2YWtQajJNdktjeUtrUVY0TVpJODd1R0hsbm5ZTkNSNmR3?=
 =?utf-8?B?SkNGMHNCMFR6N3hLelM5N1JVU2JXdUEvTitGNkRJNmdwNmtFeE9tdldqNC9H?=
 =?utf-8?B?dGVCcDBJdG1IZ2ZwcmxVUjNxbFY4dWhQQSt2bHJrc2FzQ29WOGtWNDRTTy85?=
 =?utf-8?B?Q2pYMkxIU0NHWmdaRDcxWDQ3SkpCVndRczRTdlEzRWRBZHo1VCtIR09GQmVk?=
 =?utf-8?B?eDUxV1cyL01QaHZVZnBpZHZSeUNCd1FlQnkrN3JqVEhyaS9EcXJRdVNtVDlx?=
 =?utf-8?B?WTdCKzdraWlUMTRpTmFvTTdVcjZKQ2JBekNsOEsyZWJTdjdXaHRpeTNEWHkr?=
 =?utf-8?B?cExGK3hjb01MQTR6RXFFaFFUdVpVR2NwSXV1Wm83TkhEMjJaYlNZSElYYi82?=
 =?utf-8?B?SGhKRkd4Q2hacWxJSnN0VUdSU3h5dmJtdUZMZUxYMTdNVXJQalNENGhkb0Jx?=
 =?utf-8?B?QWxaQ051TldvZUxyVXNWcE9NRDFBTGQvRmJrZmZUanBXZTNwVkUyY1lBcnZu?=
 =?utf-8?B?ZXIxb3RGSGZ4dTNQODBvSTRUeFRVa3hsR2VsQ2JuaTlhZFJsSlhRRkhJOWt5?=
 =?utf-8?Q?jZboN+pbSCkruGrOlpPD/Kmib?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: 123316c6-d7e4-45cd-87fe-08dae930ec03
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB4436.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 00:09:15.4952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jik1em40VJfmklCmMuT2Ye1EZdqS5rmqePQsVIdG2d/qA++y1rDMVLcQhlIMc9Hg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR02MB6200
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-12-28 at 22:04, Peter Rosin wrote:
> Hi!
> 
> 2022-12-28 at 16:45, Alvin Šipraga wrote:
>> On Wed, Dec 28, 2022 at 03:39:23PM +0100, Greg Kroah-Hartman wrote:
>>> From: Marek Vasut <marex@denx.de>
>>>
>>> [ Upstream commit 581c848b610dbf3fe1ed4d85fd53d0743c61faba ]
>>>
>>> Currently this driver triggers extcon and typec state update in its
>>> probe function, to read out current state reported by the chip and
>>> report the correct state to upper layers. This synchronization is
>>> performed correctly, but only in case the chip indicates a pending
>>> interrupt in reg09 register.
>>>
>>> This fails to cover the situation where all interrupts reported by
>>> the chip were already handled by Linux before reboot, then the system
>>> rebooted, and then Linux starts again. In this case, the TUSB320 no
>>> longer reports any interrupts in reg09, and the state update does not
>>> perform any update as it depends on that interrupt indication.
>>>
>>> Fix this by turning tusb320_irq_handler() into a thin wrapper around
>>> tusb320_state_update_handler(), where the later now contains the bulk
>>> of the code of tusb320_irq_handler(), but adds new function parameter
>>> "force_update". The "force_update" parameter can be used by the probe
>>> function to assure that the state synchronization is always performed,
>>> independent of the interrupt indicated in reg09. The interrupt handler
>>> tusb320_irq_handler() callback uses force_update=false to avoid state
>>> updates on potential spurious interrupts and retain current behavior.
>>>
>>> Fixes: 06bc4ca115cdd ("extcon: Add driver for TI TUSB320")
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
>>> Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>> Link: https://lore.kernel.org/r/20221120141509.81012-1-marex@denx.de
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>
>> Is the Fixes: tag here actually wrong? There was a regression report here:
>>
>> https://lore.kernel.org/all/fd0f2d56-495e-6fdd-d1e8-ff40b558101e@axentia.se/
>>
>> which this patch fixed. But according to the report, it was a regression
>> introduced by Marek's recent addition of typec support. Since that new
> 
> The fixes tag is correct here. What is wrong is that this patch does not fix
> the above reported regression which was instead fixed by
> 341fd15e2e18 ("extcon: usbc-tusb320: Call the Type-C IRQ handler only if a port is registered")
> 
> However, this patch still fixes a problem so it should be considered for stable.
> 
> From only looking at this patch, it looks easy to backport to kernels that do
> not have
> bf7571c00dca ("extcon: usbc-tusb320: Add USB TYPE-C support")
> and its followup fix.
> 
> But I have of course not tried, so maybe I'm wrong...

Sorry for the reply to self, but here's a backport for v5.15

Signed-off-by: Peter Rosin <peda@axentia.se>

Cheers,
Peter

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index 805af73b4152..1840614631bd 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -62,9 +62,9 @@ static int tusb320_check_signature(struct tusb320_priv *priv)
        return 0;
 }

-static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
+static irqreturn_t tusb320_state_update_handler(struct tusb320_priv *priv,
+                                               bool force_update)
 {
-       struct tusb320_priv *priv = dev_id;
        int state, polarity;
        unsigned reg;

@@ -73,7 +73,7 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
                return IRQ_NONE;
        }

-       if (!(reg & TUSB320_REG9_INTERRUPT_STATUS))
+       if (!force_update && !(reg & TUSB320_REG9_INTERRUPT_STATUS))
                return IRQ_NONE;

        state = (reg >> TUSB320_REG9_ATTACHED_STATE_SHIFT) &
@@ -101,6 +101,13 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
        return IRQ_HANDLED;
 }

+static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
+{
+       struct tusb320_priv *priv = dev_id;
+
+       return tusb320_state_update_handler(priv, false);
+}
+
 static const struct regmap_config tusb320_regmap_config = {
        .reg_bits = 8,
        .val_bits = 8,
@@ -143,7 +150,7 @@ static int tusb320_extcon_probe(struct i2c_client *client,
                                       EXTCON_PROP_USB_TYPEC_POLARITY);

        /* update initial state */
-       tusb320_irq_handler(client->irq, priv);
+       tusb320_state_update_handler(priv, true);

        ret = devm_request_threaded_irq(priv->dev, client->irq, NULL,
                                        tusb320_irq_handler,
