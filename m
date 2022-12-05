Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922E0642CFC
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 17:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiLEQgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 11:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiLEQft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 11:35:49 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2055.outbound.protection.outlook.com [40.107.103.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3C7205FF;
        Mon,  5 Dec 2022 08:34:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXcSq+DemS/JSRm3wqfRE3pUWSEKM7TQPbqYQmFOtgTBl3cbEyvxFCMTlbJyv2ClKyJvCBGjrGKYhP1JKFU1jCnJ+oNMEMiXODev4aITC5J4pK0sRZtL5b04tKp4aSqjCI/Hnh4jojkxTIdrCDvEjsdPQ423QMT0ea4TYcDcjzfOYs+Ykse9qYWW0UC0AgBEsRRmwd0rUEFD9pSDAtMaClZoaSL1XPW86VfPxEGrLSjXtdjNvwJzHHL2u0NlmRu538lp5hBP3p4tB9doCFdVaM4gCZ1lRcw5xD1/CxehbVieO6oH/nsgJoAYYoB0VJwrGDSt6Sh6iMipb89DS6378Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5devBtc1GotYHvt8Ngla3VQMLDwC+i4WZC5rn1dBq38=;
 b=ete9WQ+wXFCGyoToYxeuUzq4cfVtad0T6d4Z518+rHpTRZ3l4AKdCSE9Cs3o5o24X/5G2qPTYdDrH8G8Fc3ZNClLlbojx2hChQVkx0I4+20GxTL+GrvQ9F4CcDmeIvRE6yuX1FyRrFqbrI/avw/xAWLyGZAeg4BGDfTklM8/rPWyEhuDt/U/LKqn3rZlDYHiLJCeW4pdVWfVEJYnPOPr16wJAnzZz7TwtLajvzvubsErz/fKK/tGn9kLlMpQNsmSY11K76sFcqqw4HhqAIeVlANuLzImfvctosASdYLraq8EzlxrVuzgf4DGrI+UNj8KRWmWKe+sDfnVYHtP5VSDXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5devBtc1GotYHvt8Ngla3VQMLDwC+i4WZC5rn1dBq38=;
 b=vL+UQFP7XtecByQdz10o6210Io/DeAw1hEK1xcCE3jXe+r4x3VeKa/jnoO4xvvzdZlGsV2XsoS6BdZO9kR0aVxilluTFbahAn55mMmL+IJshP+btCO8TdSYYjXzSBj+LG3DImUdUlAUj2Jr/E0AWu8IYF9xYasYbhe6jrPTrX0I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3919.eurprd08.prod.outlook.com (2603:10a6:803:c4::31)
 by GVXPR08MB7846.eurprd08.prod.outlook.com (2603:10a6:150::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.11; Mon, 5 Dec 2022 16:34:35 +0000
Received: from VI1PR08MB3919.eurprd08.prod.outlook.com
 ([fe80::fe5c:b195:a2ad:b19c]) by VI1PR08MB3919.eurprd08.prod.outlook.com
 ([fe80::fe5c:b195:a2ad:b19c%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 16:34:35 +0000
Message-ID: <51758d92-43e1-806d-3fbd-603be69b40e0@arm.com>
Date:   Mon, 5 Dec 2022 16:34:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] [v2] ata: ahci: fix enum constants for gcc-13
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-ide@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
References: <20221203105425.180641-1-arnd@kernel.org>
 <caa0e7a8-f222-b190-12a6-a36996affee2@opensource.wdc.com>
From:   Luis Machado <luis.machado@arm.com>
In-Reply-To: <caa0e7a8-f222-b190-12a6-a36996affee2@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P265CA0460.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::16) To VI1PR08MB3919.eurprd08.prod.outlook.com
 (2603:10a6:803:c4::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR08MB3919:EE_|GVXPR08MB7846:EE_
X-MS-Office365-Filtering-Correlation-Id: cecef8a3-3c82-40cd-6e81-08dad6de9819
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WtuqGsmlfOObBUGgFqa1RuGCqhc+NIdXDDijZceeRRgXqnEqc/tVi70cAZY52G+2jCwWsARkHbnh/Lb87NZEDbgQAaQDOdp0c+kIH38f5xldPXgk92W8EbxClbBgPLUO+xxQYgI+TK47c+GS8dT9x4/I3/dTAWBpjAsPW/l61DNj+O4nbu1G9JvbXs/8NIMZPov4x6F4hd3T1AIFww5N42euW7hqMtaqgNuepn+WjISeDq0lVA4s6nfGuCxmAPQutxempu4cnR5rGEcIjCUhocAbh/nVEPYM/mr0SIHmmYQJdQwN7KRkd7VO/Ax2/ijjxunW7N6vPTqjdcidJwmbdtaZLeihhKSklSFqdayK+tCMO7vxbhFBni+JvmYZ9EBvUi7snNv5sNCX2Lk9llawXgHbYGGGRupbSmEc49ZV4hDXnXD+YNyS4uReNPzi/y5tyUTXqNPON6lx0tef7A3R0rlzd9pjsbdHCBNtHgAS25Eqip3L6IBCX699XYHr0USD1OTFoN7N3HYzcikx8lIEzpsY4LDOgSjwlMRCEOyujXmYnyaFuVJV7Z1uwAjt+2jAsqj/5D+vYTeuIrxQCB2k1nbmAGPWPz9IhkWCnZfJkyY+SipQ308HPYmB924B7CKNLhwG1rY/Tai+Y2kIrwZbS6UFRUL2T7YeAPmNLS5oTZqMvQ5gafxXfcVv2OGRFshu9U8IR4Xk6h0THOJ/ETkw3xwxQvl7wkqElhwV/r4l/4NXmFVAICfK6wjKnfOhVHIY/lrhHqz0Y5hCfhy8gT6HEQaK+s3tUEOXso/sEVwZferN1APUMdHQLCAhNIqKaAec
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3919.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(38100700002)(66899015)(8676002)(4326008)(31686004)(478600001)(41300700001)(5660300002)(54906003)(83380400001)(86362001)(31696002)(53546011)(6506007)(6512007)(2906002)(26005)(6486002)(186003)(66476007)(66556008)(66946007)(966005)(8936002)(316002)(30864003)(110136005)(44832011)(2616005)(36756003)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFhSMmV5QmdkZHlReVB2dE52UlVxU0tlK1JFemx1VndraU85eEVPcHJVaTJQ?=
 =?utf-8?B?VHluNEFyeXdoSnNEWVdkK2ptVWVLNXdUcllDYXRjRkxnZEJOeG9ZMDNhUVEz?=
 =?utf-8?B?RDVoRFJkRmlFcnVMeTBJZ20vTnQwNE1OY3B4azR2ejJTa0FkTDZuRlB4ODdl?=
 =?utf-8?B?Vm56REpxWVZjTHp1UHN2dklOdGdYaEl0M1lzSGgzTVA3emx1S3RaS0hyalF4?=
 =?utf-8?B?MzkwaVdkUzhUdHlVaWVBODM4MWttMkdZUG5IOWs2UHJDNDJDWVBDUCtiY1lF?=
 =?utf-8?B?OXlMTGwxeXFld3hFOFh2S3lnYklDMXZlZzN4QUt5MVJtVFRaL29ydHFWTjBV?=
 =?utf-8?B?aTA3bVpydC9ObHNueTlxOTF2NDU1aWN4WHArZVBOK3NrVytBWGwzRjIvQWRT?=
 =?utf-8?B?Z2JTUmpMNGxMdTI0TTVoN3Rqaks5UmNleERtazdYREhkcDg0b0RtYzJJV2da?=
 =?utf-8?B?bHNRTFV4d1IxQlBJdTVxT1VtWi91RGE0WHBFU3lXRzA1bXhDdnltYWlXRG4x?=
 =?utf-8?B?Z2NZUDlmQmNIcUtsN2dzdXJsY0R5R1ZsY01vOTlVWFJ1MXNLT083TURDR0pY?=
 =?utf-8?B?U2h4eHdtem9MT09WeDFraDU0ZHBKRTcvNzhtTjdFSGFuR3pZNEFmaWxlekpU?=
 =?utf-8?B?MTNaTWNkYjBzL0VkYVhKbWMxeGN1c3dUOXVJN1FRZTQrczRFTkxZaWpFNWl0?=
 =?utf-8?B?MEtQVnBwVURjZnhmUTgveE9TVlliYzkxZWdELyt3RVdUV093UHEyaFBtVWtQ?=
 =?utf-8?B?R3VjVjlydExOMXd1SXpueis4VzE3WHlnK1piTFdkdmw1R3lJc1YrYVBab2wv?=
 =?utf-8?B?R3gxazc0dVNzOTg3ckllSkxjejhCVmNmeXlocHpjakNhWWFKUkRHR0pRTDk3?=
 =?utf-8?B?Z0ZCS1dLeWVoOHVramxzUnR4cHNBZXpEd0gvWGExUm83b0l2Q0RVTHNnVnFY?=
 =?utf-8?B?azMzellMT2NUanNjZ1NMWmdLVktPYTZvTjEraWZkQnhhU29sVzhDV1FrQU14?=
 =?utf-8?B?M3p0V3hjdkEzMUR0aHhaeDRnN3I3VGtvYnhxcTJYMis2Z2tiVm5seEdBZFNW?=
 =?utf-8?B?VzEzYnZHd0dzZzJ2UE44N0hUUi9qclVGVzBERnBVbU0zbDJGbk9TUkZ2N3My?=
 =?utf-8?B?SUMramE0MkZmZVovVXR4d25uSSttVGhBTUdya2ZqOVZOczZVNS9VRzlZczBY?=
 =?utf-8?B?b1NCMnVzRWU5L09wQ1QrNzFtcGlMS3d2VERGM2U5OEdteGdpU1ZCbnVoU2dV?=
 =?utf-8?B?a0pJb1MwYXZUbmdJZjF1U0t3M2duWHNraUl5OEI0ZE5GdUMxVGhvUlRRU2pk?=
 =?utf-8?B?SEkwSC8vRHc0SStSSHhrZy9jWlhOcnZvR0U3U1lPblJpVkFpa3JHOXFNd0hS?=
 =?utf-8?B?R0d3TGdCYWJJK0sxNUNVZkE3bE42Z3VySWFROWM2aHpua3czMjRuQ3pYQlJV?=
 =?utf-8?B?a2U0ZkgyQXlqQ0doN1ZqOTh4Ukt2SnE5ZGhVR0lEdjM0L1NwNXJPSlpBaXZE?=
 =?utf-8?B?ZGlJci9ZYnlRdEtBcG5LVFpDZUNYdE8wclRqSFYwZHRpK01XNlYyMHg1MGJS?=
 =?utf-8?B?eWhVOFZGZlRmZnhUcGVZRFNpaHB6SHFzVTlBbjlkSXlyUjIxclZtazltWE56?=
 =?utf-8?B?UXBoLy8zQXlTOXQ0QWxKRDFjTTZiYXNOL3RFSUVFdGxEMTVaWG1IZDdnakVB?=
 =?utf-8?B?cE04cU4xNnVxTlYwaVhqYnpKOS9KYmVncUJGYUY2eFViNTZDMTZ2ck5qNlpJ?=
 =?utf-8?B?ZEZXMGd6L0IwRmNnanY3a2x2N3RqamJ2RG1EWXEyOWk3SkNzRWIwTjF0NkV4?=
 =?utf-8?B?QlJYck82TG4xYUVzT0NTT08weElhTUNSODhYUWYwRnh6bStvYVY3d0U1RG13?=
 =?utf-8?B?R2ZZOXQvZGN6Q2hXeHAwcWoya1FadHcvcTF0NVF6c2hIZ1NHRmM5U2t5RFJv?=
 =?utf-8?B?NE1sSnMxVUl6NlFGeERlcm5oR3lsbUdGdDVwcTJxbUtiK0RyTDRkT0k3ak01?=
 =?utf-8?B?V0hGNzNtWWRIcUhYUXUzZGVaNDk0dUNlVEdYdzRlbHdySU1MRTF1WEZaR1J2?=
 =?utf-8?B?REZ5SE0wNm5XMUk4bUlJbUxYVXJqTkwxSWdSVnpFSnJZbFV5azVXamdjNWdE?=
 =?utf-8?Q?6GkSBJSi1dGrQy/B31/HncD8F?=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cecef8a3-3c82-40cd-6e81-08dad6de9819
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3919.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 16:34:35.0952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NqQBimv4WEooIRLg6JOrR5wRuSuz4tuB5ZtMt113ss8/WSO/YgI+J9qRt0u2JyLC6Frg/CEJda4RVAhkqCdd5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7846
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 13:33, Damien Le Moal wrote:
> On 12/3/22 19:54, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> gcc-13 slightly changes the type of constant expressions that are define=
d
>> in an enum, which triggers a compile time sanity check in libata:
>>
>> linux/drivers/ata/libahci.c: In function 'ahci_led_store':
>> linux/include/linux/compiler_types.h:357:45: error: call to '__compileti=
me_assert_302' declared with attribute error: BUILD_BUG_ON failed: sizeof(_=
s) > sizeof(long)
>> 357 | _compiletime_assert(condition, msg, __compiletime_assert_, __COUNT=
ER__)
>>
>> The new behavior is that sizeof() returns the same value for the
>> constant as it does for the enum type, which is generally more sensible
>> and consistent.
>>
>> The problem in libata is that it contains a single enum definition for
>> lots of unrelated constants, some of which are large positive (unsigned)
>> integers like 0xffffffff, while others like (1<<31) are interpreted as
>> negative integers, and this forces the enum type to become 64 bit wide
>> even though most constants would still fit into a signed 32-bit 'int'.
>>
>> Fix this by changing the entire enum definition to use BIT(x) in place
>> of (1<<x), which results in all values being seen as 'unsigned' and
>> fitting into an unsigned 32-bit type.
>>
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D107917
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D107405
>> Reported-by: Luis Machado <luis.machado@arm.com>
>> Cc: linux-ide@vger.kernel.org
>> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Cc: stable@vger.kernel.org
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Looks all good to me. One nit: for the PORT_CMD_ICC_XXX definitions, we
> could use GENMASK() to be consistant with the use of BIT(), no ? Not a bi=
g
> deal though.
>
>> ---
>> Luis, I don't have gcc-13 installed on the machine I used for
>> creating this patch, can you give this a spin and see if it
>> addresses the build failure?
>
> Luis, if you test/review, please send Tested-by/Reviewed-by tags !
>
>>
>> v2 changes:
>>   - fix typos in changelog
>>   - change PORT_CMD_ICC_* constants as well
>>   - include linux/bits.h
>> ---
>>   drivers/ata/ahci.h | 245 +++++++++++++++++++++++----------------------
>>   1 file changed, 123 insertions(+), 122 deletions(-)
>>
>> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
>> index 7add8e79912b..ff8e6ae1c636 100644
>> --- a/drivers/ata/ahci.h
>> +++ b/drivers/ata/ahci.h
>> @@ -24,6 +24,7 @@
>>   #include <linux/libata.h>
>>   #include <linux/phy/phy.h>
>>   #include <linux/regulator/consumer.h>
>> +#include <linux/bits.h>
>>
>>   /* Enclosure Management Control */
>>   #define EM_CTRL_MSG_TYPE              0x000f0000
>> @@ -53,12 +54,12 @@ enum {
>>      AHCI_PORT_PRIV_FBS_DMA_SZ       =3D AHCI_CMD_SLOT_SZ +
>>                                        AHCI_CMD_TBL_AR_SZ +
>>                                        (AHCI_RX_FIS_SZ * 16),
>> -    AHCI_IRQ_ON_SG          =3D (1 << 31),
>> -    AHCI_CMD_ATAPI          =3D (1 << 5),
>> -    AHCI_CMD_WRITE          =3D (1 << 6),
>> -    AHCI_CMD_PREFETCH       =3D (1 << 7),
>> -    AHCI_CMD_RESET          =3D (1 << 8),
>> -    AHCI_CMD_CLR_BUSY       =3D (1 << 10),
>> +    AHCI_IRQ_ON_SG          =3D BIT(31),
>> +    AHCI_CMD_ATAPI          =3D BIT(5),
>> +    AHCI_CMD_WRITE          =3D BIT(6),
>> +    AHCI_CMD_PREFETCH       =3D BIT(7),
>> +    AHCI_CMD_RESET          =3D BIT(8),
>> +    AHCI_CMD_CLR_BUSY       =3D BIT(10),
>>
>>      RX_FIS_PIO_SETUP        =3D 0x20, /* offset of PIO Setup FIS data *=
/
>>      RX_FIS_D2H_REG          =3D 0x40, /* offset of D2H Register FIS dat=
a */
>> @@ -76,37 +77,37 @@ enum {
>>      HOST_CAP2               =3D 0x24, /* host capabilities, extended */
>>
>>      /* HOST_CTL bits */
>> -    HOST_RESET              =3D (1 << 0),  /* reset controller; self-cl=
ear */
>> -    HOST_IRQ_EN             =3D (1 << 1),  /* global IRQ enable */
>> -    HOST_MRSM               =3D (1 << 2),  /* MSI Revert to Single Mess=
age */
>> -    HOST_AHCI_EN            =3D (1 << 31), /* AHCI enabled */
>> +    HOST_RESET              =3D BIT(0),  /* reset controller; self-clea=
r */
>> +    HOST_IRQ_EN             =3D BIT(1),  /* global IRQ enable */
>> +    HOST_MRSM               =3D BIT(2),  /* MSI Revert to Single Messag=
e */
>> +    HOST_AHCI_EN            =3D BIT(31), /* AHCI enabled */
>>
>>      /* HOST_CAP bits */
>> -    HOST_CAP_SXS            =3D (1 << 5),  /* Supports External SATA */
>> -    HOST_CAP_EMS            =3D (1 << 6),  /* Enclosure Management supp=
ort */
>> -    HOST_CAP_CCC            =3D (1 << 7),  /* Command Completion Coales=
cing */
>> -    HOST_CAP_PART           =3D (1 << 13), /* Partial state capable */
>> -    HOST_CAP_SSC            =3D (1 << 14), /* Slumber state capable */
>> -    HOST_CAP_PIO_MULTI      =3D (1 << 15), /* PIO multiple DRQ support =
*/
>> -    HOST_CAP_FBS            =3D (1 << 16), /* FIS-based switching suppo=
rt */
>> -    HOST_CAP_PMP            =3D (1 << 17), /* Port Multiplier support *=
/
>> -    HOST_CAP_ONLY           =3D (1 << 18), /* Supports AHCI mode only *=
/
>> -    HOST_CAP_CLO            =3D (1 << 24), /* Command List Override sup=
port */
>> -    HOST_CAP_LED            =3D (1 << 25), /* Supports activity LED */
>> -    HOST_CAP_ALPM           =3D (1 << 26), /* Aggressive Link PM suppor=
t */
>> -    HOST_CAP_SSS            =3D (1 << 27), /* Staggered Spin-up */
>> -    HOST_CAP_MPS            =3D (1 << 28), /* Mechanical presence switc=
h */
>> -    HOST_CAP_SNTF           =3D (1 << 29), /* SNotification register */
>> -    HOST_CAP_NCQ            =3D (1 << 30), /* Native Command Queueing *=
/
>> -    HOST_CAP_64             =3D (1 << 31), /* PCI DAC (64-bit DMA) supp=
ort */
>> +    HOST_CAP_SXS            =3D BIT(5),  /* Supports External SATA */
>> +    HOST_CAP_EMS            =3D BIT(6),  /* Enclosure Management suppor=
t */
>> +    HOST_CAP_CCC            =3D BIT(7),  /* Command Completion Coalesci=
ng */
>> +    HOST_CAP_PART           =3D BIT(13), /* Partial state capable */
>> +    HOST_CAP_SSC            =3D BIT(14), /* Slumber state capable */
>> +    HOST_CAP_PIO_MULTI      =3D BIT(15), /* PIO multiple DRQ support */
>> +    HOST_CAP_FBS            =3D BIT(16), /* FIS-based switching support=
 */
>> +    HOST_CAP_PMP            =3D BIT(17), /* Port Multiplier support */
>> +    HOST_CAP_ONLY           =3D BIT(18), /* Supports AHCI mode only */
>> +    HOST_CAP_CLO            =3D BIT(24), /* Command List Override suppo=
rt */
>> +    HOST_CAP_LED            =3D BIT(25), /* Supports activity LED */
>> +    HOST_CAP_ALPM           =3D BIT(26), /* Aggressive Link PM support =
*/
>> +    HOST_CAP_SSS            =3D BIT(27), /* Staggered Spin-up */
>> +    HOST_CAP_MPS            =3D BIT(28), /* Mechanical presence switch =
*/
>> +    HOST_CAP_SNTF           =3D BIT(29), /* SNotification register */
>> +    HOST_CAP_NCQ            =3D BIT(30), /* Native Command Queueing */
>> +    HOST_CAP_64             =3D BIT(31), /* PCI DAC (64-bit DMA) suppor=
t */
>>
>>      /* HOST_CAP2 bits */
>> -    HOST_CAP2_BOH           =3D (1 << 0),  /* BIOS/OS handoff supported=
 */
>> -    HOST_CAP2_NVMHCI        =3D (1 << 1),  /* NVMHCI supported */
>> -    HOST_CAP2_APST          =3D (1 << 2),  /* Automatic partial to slum=
ber */
>> -    HOST_CAP2_SDS           =3D (1 << 3),  /* Support device sleep */
>> -    HOST_CAP2_SADM          =3D (1 << 4),  /* Support aggressive DevSlp=
 */
>> -    HOST_CAP2_DESO          =3D (1 << 5),  /* DevSlp from slumber only =
*/
>> +    HOST_CAP2_BOH           =3D BIT(0),  /* BIOS/OS handoff supported *=
/
>> +    HOST_CAP2_NVMHCI        =3D BIT(1),  /* NVMHCI supported */
>> +    HOST_CAP2_APST          =3D BIT(2),  /* Automatic partial to slumbe=
r */
>> +    HOST_CAP2_SDS           =3D BIT(3),  /* Support device sleep */
>> +    HOST_CAP2_SADM          =3D BIT(4),  /* Support aggressive DevSlp *=
/
>> +    HOST_CAP2_DESO          =3D BIT(5),  /* DevSlp from slumber only */
>>
>>      /* registers for each SATA port */
>>      PORT_LST_ADDR           =3D 0x00, /* command list DMA addr */
>> @@ -128,24 +129,24 @@ enum {
>>      PORT_DEVSLP             =3D 0x44, /* device sleep */
>>
>>      /* PORT_IRQ_{STAT,MASK} bits */
>> -    PORT_IRQ_COLD_PRES      =3D (1 << 31), /* cold presence detect */
>> -    PORT_IRQ_TF_ERR         =3D (1 << 30), /* task file error */
>> -    PORT_IRQ_HBUS_ERR       =3D (1 << 29), /* host bus fatal error */
>> -    PORT_IRQ_HBUS_DATA_ERR  =3D (1 << 28), /* host bus data error */
>> -    PORT_IRQ_IF_ERR         =3D (1 << 27), /* interface fatal error */
>> -    PORT_IRQ_IF_NONFATAL    =3D (1 << 26), /* interface non-fatal error=
 */
>> -    PORT_IRQ_OVERFLOW       =3D (1 << 24), /* xfer exhausted available =
S/G */
>> -    PORT_IRQ_BAD_PMP        =3D (1 << 23), /* incorrect port multiplier=
 */
>> -
>> -    PORT_IRQ_PHYRDY         =3D (1 << 22), /* PhyRdy changed */
>> -    PORT_IRQ_DMPS           =3D (1 << 7), /* mechanical presence status=
 */
>> -    PORT_IRQ_CONNECT        =3D (1 << 6), /* port connect change status=
 */
>> -    PORT_IRQ_SG_DONE        =3D (1 << 5), /* descriptor processed */
>> -    PORT_IRQ_UNK_FIS        =3D (1 << 4), /* unknown FIS rx'd */
>> -    PORT_IRQ_SDB_FIS        =3D (1 << 3), /* Set Device Bits FIS rx'd *=
/
>> -    PORT_IRQ_DMAS_FIS       =3D (1 << 2), /* DMA Setup FIS rx'd */
>> -    PORT_IRQ_PIOS_FIS       =3D (1 << 1), /* PIO Setup FIS rx'd */
>> -    PORT_IRQ_D2H_REG_FIS    =3D (1 << 0), /* D2H Register FIS rx'd */
>> +    PORT_IRQ_COLD_PRES      =3D BIT(31), /* cold presence detect */
>> +    PORT_IRQ_TF_ERR         =3D BIT(30), /* task file error */
>> +    PORT_IRQ_HBUS_ERR       =3D BIT(29), /* host bus fatal error */
>> +    PORT_IRQ_HBUS_DATA_ERR  =3D BIT(28), /* host bus data error */
>> +    PORT_IRQ_IF_ERR         =3D BIT(27), /* interface fatal error */
>> +    PORT_IRQ_IF_NONFATAL    =3D BIT(26), /* interface non-fatal error *=
/
>> +    PORT_IRQ_OVERFLOW       =3D BIT(24), /* xfer exhausted available S/=
G */
>> +    PORT_IRQ_BAD_PMP        =3D BIT(23), /* incorrect port multiplier *=
/
>> +
>> +    PORT_IRQ_PHYRDY         =3D BIT(22), /* PhyRdy changed */
>> +    PORT_IRQ_DMPS           =3D BIT(7),  /* mechanical presence status =
*/
>> +    PORT_IRQ_CONNECT        =3D BIT(6),  /* port connect change status =
*/
>> +    PORT_IRQ_SG_DONE        =3D BIT(5),  /* descriptor processed */
>> +    PORT_IRQ_UNK_FIS        =3D BIT(4),  /* unknown FIS rx'd */
>> +    PORT_IRQ_SDB_FIS        =3D BIT(3),  /* Set Device Bits FIS rx'd */
>> +    PORT_IRQ_DMAS_FIS       =3D BIT(2),  /* DMA Setup FIS rx'd */
>> +    PORT_IRQ_PIOS_FIS       =3D BIT(1),  /* PIO Setup FIS rx'd */
>> +    PORT_IRQ_D2H_REG_FIS    =3D BIT(0),  /* D2H Register FIS rx'd */
>>
>>      PORT_IRQ_FREEZE         =3D PORT_IRQ_HBUS_ERR |
>>                                PORT_IRQ_IF_ERR |
>> @@ -161,27 +162,27 @@ enum {
>>                                PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
>>
>>      /* PORT_CMD bits */
>> -    PORT_CMD_ASP            =3D (1 << 27), /* Aggressive Slumber/Partia=
l */
>> -    PORT_CMD_ALPE           =3D (1 << 26), /* Aggressive Link PM enable=
 */
>> -    PORT_CMD_ATAPI          =3D (1 << 24), /* Device is ATAPI */
>> -    PORT_CMD_FBSCP          =3D (1 << 22), /* FBS Capable Port */
>> -    PORT_CMD_ESP            =3D (1 << 21), /* External Sata Port */
>> -    PORT_CMD_CPD            =3D (1 << 20), /* Cold Presence Detection *=
/
>> -    PORT_CMD_MPSP           =3D (1 << 19), /* Mechanical Presence Switc=
h */
>> -    PORT_CMD_HPCP           =3D (1 << 18), /* HotPlug Capable Port */
>> -    PORT_CMD_PMP            =3D (1 << 17), /* PMP attached */
>> -    PORT_CMD_LIST_ON        =3D (1 << 15), /* cmd list DMA engine runni=
ng */
>> -    PORT_CMD_FIS_ON         =3D (1 << 14), /* FIS DMA engine running */
>> -    PORT_CMD_FIS_RX         =3D (1 << 4), /* Enable FIS receive DMA eng=
ine */
>> -    PORT_CMD_CLO            =3D (1 << 3), /* Command list override */
>> -    PORT_CMD_POWER_ON       =3D (1 << 2), /* Power up device */
>> -    PORT_CMD_SPIN_UP        =3D (1 << 1), /* Spin up device */
>> -    PORT_CMD_START          =3D (1 << 0), /* Enable port DMA engine */
>> -
>> -    PORT_CMD_ICC_MASK       =3D (0xf << 28), /* i/f ICC state mask */
>> -    PORT_CMD_ICC_ACTIVE     =3D (0x1 << 28), /* Put i/f in active state=
 */
>> -    PORT_CMD_ICC_PARTIAL    =3D (0x2 << 28), /* Put i/f in partial stat=
e */
>> -    PORT_CMD_ICC_SLUMBER    =3D (0x6 << 28), /* Put i/f in slumber stat=
e */
>> +    PORT_CMD_ASP            =3D BIT(27), /* Aggressive Slumber/Partial =
*/
>> +    PORT_CMD_ALPE           =3D BIT(26), /* Aggressive Link PM enable *=
/
>> +    PORT_CMD_ATAPI          =3D BIT(24), /* Device is ATAPI */
>> +    PORT_CMD_FBSCP          =3D BIT(22), /* FBS Capable Port */
>> +    PORT_CMD_ESP            =3D BIT(21), /* External Sata Port */
>> +    PORT_CMD_CPD            =3D BIT(20), /* Cold Presence Detection */
>> +    PORT_CMD_MPSP           =3D BIT(19), /* Mechanical Presence Switch =
*/
>> +    PORT_CMD_HPCP           =3D BIT(18), /* HotPlug Capable Port */
>> +    PORT_CMD_PMP            =3D BIT(17), /* PMP attached */
>> +    PORT_CMD_LIST_ON        =3D BIT(15), /* cmd list DMA engine running=
 */
>> +    PORT_CMD_FIS_ON         =3D BIT(14), /* FIS DMA engine running */
>> +    PORT_CMD_FIS_RX         =3D BIT(4),  /* Enable FIS receive DMA engi=
ne */
>> +    PORT_CMD_CLO            =3D BIT(3),  /* Command list override */
>> +    PORT_CMD_POWER_ON       =3D BIT(2),  /* Power up device */
>> +    PORT_CMD_SPIN_UP        =3D BIT(1),  /* Spin up device */
>> +    PORT_CMD_START          =3D BIT(0),  /* Enable port DMA engine */
>> +
>> +    PORT_CMD_ICC_MASK       =3D (0xfu << 28), /* i/f ICC state mask */
>> +    PORT_CMD_ICC_ACTIVE     =3D (0x1u << 28), /* Put i/f in active stat=
e */
>> +    PORT_CMD_ICC_PARTIAL    =3D (0x2u << 28), /* Put i/f in partial sta=
te */
>> +    PORT_CMD_ICC_SLUMBER    =3D (0x6u << 28), /* Put i/f in slumber sta=
te */
>>
>>      /* PORT_CMD capabilities mask */
>>      PORT_CMD_CAP            =3D PORT_CMD_HPCP | PORT_CMD_MPSP |
>> @@ -192,9 +193,9 @@ enum {
>>      PORT_FBS_ADO_OFFSET     =3D 12, /* FBS active dev optimization offs=
et */
>>      PORT_FBS_DEV_OFFSET     =3D 8,  /* FBS device to issue offset */
>>      PORT_FBS_DEV_MASK       =3D (0xf << PORT_FBS_DEV_OFFSET),  /* FBS.D=
EV */
>> -    PORT_FBS_SDE            =3D (1 << 2), /* FBS single device error */
>> -    PORT_FBS_DEC            =3D (1 << 1), /* FBS device error clear */
>> -    PORT_FBS_EN             =3D (1 << 0), /* Enable FBS */
>> +    PORT_FBS_SDE            =3D BIT(2), /* FBS single device error */
>> +    PORT_FBS_DEC            =3D BIT(1), /* FBS device error clear */
>> +    PORT_FBS_EN             =3D BIT(0), /* Enable FBS */
>>
>>      /* PORT_DEVSLP bits */
>>      PORT_DEVSLP_DM_OFFSET   =3D 25,             /* DITO multiplier offs=
et */
>> @@ -202,50 +203,50 @@ enum {
>>      PORT_DEVSLP_DITO_OFFSET =3D 15,             /* DITO offset */
>>      PORT_DEVSLP_MDAT_OFFSET =3D 10,             /* Minimum assertion ti=
me */
>>      PORT_DEVSLP_DETO_OFFSET =3D 2,              /* DevSlp exit timeout =
*/
>> -    PORT_DEVSLP_DSP         =3D (1 << 1),       /* DevSlp present */
>> -    PORT_DEVSLP_ADSE        =3D (1 << 0),       /* Aggressive DevSlp en=
able */
>> +    PORT_DEVSLP_DSP         =3D BIT(1),         /* DevSlp present */
>> +    PORT_DEVSLP_ADSE        =3D BIT(0),         /* Aggressive DevSlp en=
able */
>>
>>      /* hpriv->flags bits */
>>
>>   #define AHCI_HFLAGS(flags)         .private_data   =3D (void *)(flags)
>>
>> -    AHCI_HFLAG_NO_NCQ               =3D (1 << 0),
>> -    AHCI_HFLAG_IGN_IRQ_IF_ERR       =3D (1 << 1), /* ignore IRQ_IF_ERR =
*/
>> -    AHCI_HFLAG_IGN_SERR_INTERNAL    =3D (1 << 2), /* ignore SERR_INTERN=
AL */
>> -    AHCI_HFLAG_32BIT_ONLY           =3D (1 << 3), /* force 32bit */
>> -    AHCI_HFLAG_MV_PATA              =3D (1 << 4), /* PATA port */
>> -    AHCI_HFLAG_NO_MSI               =3D (1 << 5), /* no PCI MSI */
>> -    AHCI_HFLAG_NO_PMP               =3D (1 << 6), /* no PMP */
>> -    AHCI_HFLAG_SECT255              =3D (1 << 8), /* max 255 sectors */
>> -    AHCI_HFLAG_YES_NCQ              =3D (1 << 9), /* force NCQ cap on *=
/
>> -    AHCI_HFLAG_NO_SUSPEND           =3D (1 << 10), /* don't suspend */
>> -    AHCI_HFLAG_SRST_TOUT_IS_OFFLINE =3D (1 << 11), /* treat SRST timeou=
t as
>> -                                                    link offline */
>> -    AHCI_HFLAG_NO_SNTF              =3D (1 << 12), /* no sntf */
>> -    AHCI_HFLAG_NO_FPDMA_AA          =3D (1 << 13), /* no FPDMA AA */
>> -    AHCI_HFLAG_YES_FBS              =3D (1 << 14), /* force FBS cap on =
*/
>> -    AHCI_HFLAG_DELAY_ENGINE         =3D (1 << 15), /* do not start engi=
ne on
>> -                                                    port start (wait un=
til
>> -                                                    error-handling stag=
e) */
>> -    AHCI_HFLAG_NO_DEVSLP            =3D (1 << 17), /* no device sleep *=
/
>> -    AHCI_HFLAG_NO_FBS               =3D (1 << 18), /* no FBS */
>> +    AHCI_HFLAG_NO_NCQ               =3D BIT(0),
>> +    AHCI_HFLAG_IGN_IRQ_IF_ERR       =3D BIT(1), /* ignore IRQ_IF_ERR */
>> +    AHCI_HFLAG_IGN_SERR_INTERNAL    =3D BIT(2), /* ignore SERR_INTERNAL=
 */
>> +    AHCI_HFLAG_32BIT_ONLY           =3D BIT(3), /* force 32bit */
>> +    AHCI_HFLAG_MV_PATA              =3D BIT(4), /* PATA port */
>> +    AHCI_HFLAG_NO_MSI               =3D BIT(5), /* no PCI MSI */
>> +    AHCI_HFLAG_NO_PMP               =3D BIT(6), /* no PMP */
>> +    AHCI_HFLAG_SECT255              =3D BIT(8), /* max 255 sectors */
>> +    AHCI_HFLAG_YES_NCQ              =3D BIT(9), /* force NCQ cap on */
>> +    AHCI_HFLAG_NO_SUSPEND           =3D BIT(10), /* don't suspend */
>> +    AHCI_HFLAG_SRST_TOUT_IS_OFFLINE =3D BIT(11), /* treat SRST timeout =
as
>> +                                                  link offline */
>> +    AHCI_HFLAG_NO_SNTF              =3D BIT(12), /* no sntf */
>> +    AHCI_HFLAG_NO_FPDMA_AA          =3D BIT(13), /* no FPDMA AA */
>> +    AHCI_HFLAG_YES_FBS              =3D BIT(14), /* force FBS cap on */
>> +    AHCI_HFLAG_DELAY_ENGINE         =3D BIT(15), /* do not start engine=
 on
>> +                                                  port start (wait unti=
l
>> +                                                  error-handling stage)=
 */
>> +    AHCI_HFLAG_NO_DEVSLP            =3D BIT(17), /* no device sleep */
>> +    AHCI_HFLAG_NO_FBS               =3D BIT(18), /* no FBS */
>>
>>   #ifdef CONFIG_PCI_MSI
>> -    AHCI_HFLAG_MULTI_MSI            =3D (1 << 20), /* per-port MSI(-X) =
*/
>> +    AHCI_HFLAG_MULTI_MSI            =3D BIT(20), /* per-port MSI(-X) */
>>   #else
>>      /* compile out MSI infrastructure */
>>      AHCI_HFLAG_MULTI_MSI            =3D 0,
>>   #endif
>> -    AHCI_HFLAG_WAKE_BEFORE_STOP     =3D (1 << 22), /* wake before DMA s=
top */
>> -    AHCI_HFLAG_YES_ALPM             =3D (1 << 23), /* force ALPM cap on=
 */
>> -    AHCI_HFLAG_NO_WRITE_TO_RO       =3D (1 << 24), /* don't write to re=
ad
>> -                                                    only registers */
>> -    AHCI_HFLAG_USE_LPM_POLICY       =3D (1 << 25), /* chipset that shou=
ld use
>> -                                                    SATA_MOBILE_LPM_POL=
ICY
>> -                                                    as default lpm_poli=
cy */
>> -    AHCI_HFLAG_SUSPEND_PHYS         =3D (1 << 26), /* handle PHYs durin=
g
>> -                                                    suspend/resume */
>> -    AHCI_HFLAG_NO_SXS               =3D (1 << 28), /* SXS not supported=
 */
>> +    AHCI_HFLAG_WAKE_BEFORE_STOP     =3D BIT(22), /* wake before DMA sto=
p */
>> +    AHCI_HFLAG_YES_ALPM             =3D BIT(23), /* force ALPM cap on *=
/
>> +    AHCI_HFLAG_NO_WRITE_TO_RO       =3D BIT(24), /* don't write to read
>> +                                                  only registers */
>> +    AHCI_HFLAG_USE_LPM_POLICY       =3D BIT(25), /* chipset that should=
 use
>> +                                                  SATA_MOBILE_LPM_POLIC=
Y
>> +                                                  as default lpm_policy=
 */
>> +    AHCI_HFLAG_SUSPEND_PHYS         =3D BIT(26), /* handle PHYs during
>> +                                                  suspend/resume */
>> +    AHCI_HFLAG_NO_SXS               =3D BIT(28), /* SXS not supported *=
/
>>
>>      /* ap->flags bits */
>>
>> @@ -261,22 +262,22 @@ enum {
>>      EM_MAX_RETRY                    =3D 5,
>>
>>      /* em_ctl bits */
>> -    EM_CTL_RST              =3D (1 << 9), /* Reset */
>> -    EM_CTL_TM               =3D (1 << 8), /* Transmit Message */
>> -    EM_CTL_MR               =3D (1 << 0), /* Message Received */
>> -    EM_CTL_ALHD             =3D (1 << 26), /* Activity LED */
>> -    EM_CTL_XMT              =3D (1 << 25), /* Transmit Only */
>> -    EM_CTL_SMB              =3D (1 << 24), /* Single Message Buffer */
>> -    EM_CTL_SGPIO            =3D (1 << 19), /* SGPIO messages supported =
*/
>> -    EM_CTL_SES              =3D (1 << 18), /* SES-2 messages supported =
*/
>> -    EM_CTL_SAFTE            =3D (1 << 17), /* SAF-TE messages supported=
 */
>> -    EM_CTL_LED              =3D (1 << 16), /* LED messages supported */
>> +    EM_CTL_RST              =3D BIT(9), /* Reset */
>> +    EM_CTL_TM               =3D BIT(8), /* Transmit Message */
>> +    EM_CTL_MR               =3D BIT(0), /* Message Received */
>> +    EM_CTL_ALHD             =3D BIT(26), /* Activity LED */
>> +    EM_CTL_XMT              =3D BIT(25), /* Transmit Only */
>> +    EM_CTL_SMB              =3D BIT(24), /* Single Message Buffer */
>> +    EM_CTL_SGPIO            =3D BIT(19), /* SGPIO messages supported */
>> +    EM_CTL_SES              =3D BIT(18), /* SES-2 messages supported */
>> +    EM_CTL_SAFTE            =3D BIT(17), /* SAF-TE messages supported *=
/
>> +    EM_CTL_LED              =3D BIT(16), /* LED messages supported */
>>
>>      /* em message type */
>> -    EM_MSG_TYPE_LED         =3D (1 << 0), /* LED */
>> -    EM_MSG_TYPE_SAFTE       =3D (1 << 1), /* SAF-TE */
>> -    EM_MSG_TYPE_SES2        =3D (1 << 2), /* SES-2 */
>> -    EM_MSG_TYPE_SGPIO       =3D (1 << 3), /* SGPIO */
>> +    EM_MSG_TYPE_LED         =3D BIT(0), /* LED */
>> +    EM_MSG_TYPE_SAFTE       =3D BIT(1), /* SAF-TE */
>> +    EM_MSG_TYPE_SES2        =3D BIT(2), /* SES-2 */
>> +    EM_MSG_TYPE_SGPIO       =3D BIT(3), /* SGPIO */
>>   };
>>
>>   struct ahci_cmd_hdr {
>

Sorry for the delay.

Builds completed just fine.

Tested-by: Luis Machado <luis.machado@arm.com>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
