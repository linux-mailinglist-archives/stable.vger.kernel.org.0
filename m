Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551296436AB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 22:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiLEVUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 16:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiLEVUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 16:20:10 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9CD24F0A;
        Mon,  5 Dec 2022 13:20:09 -0800 (PST)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5KY4sR031202;
        Mon, 5 Dec 2022 13:19:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=dzTp6aVBpxYAlKsBXnM4LzeTOLqJqfs478VORjedWyI=;
 b=S3cNC/IXo1ZkJje0sRAMBmiqnOp8HSjuczIY/mbjEs4soxdjIguNj0vadIwuRjVQQLAF
 rUD9ZkfrKlF6IaV8Od/iwSmELwQmQEmaHfEZua8PHbmixSRyIDac/TFn3QYKEqIpqinF
 sEJRgreUorxKHO2lOs0qNXBkfZNQQLXdjO4ZYjM9gT8j9u7nHNWzrqURqqRh2g2rwDVn
 Z0t6iZwU/iCc8414ZK1m484v78DIzieGTBRm2hT2YFEiZrhJt11y8bFUUHceAi8p8JU/
 cC9rhuPspbnkc9geaD4yUTluFhwQv545sEv+TyOo7I36LyDSDJNEcFEgyyjSMq0tqdxE TQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3m86ka0xuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 13:19:49 -0800
Received: from mailhost.synopsys.com (us03-mailhost1.synopsys.com [10.4.17.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7697A400F0;
        Mon,  5 Dec 2022 21:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1670275189; bh=dzTp6aVBpxYAlKsBXnM4LzeTOLqJqfs478VORjedWyI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=bNqu/xle2B5hFMY5Bg/S8J9TND73WzPidZlTrHcQvvOYPdJelwsQerlIcBtNL7dbF
         577W5qjpUxNkeiOjzrE3y3pBBGQbXPjdPQCB0iM6yG90rkz1XZK6HiC0BJbbhGVO7y
         AiB4iiGq8aRgRCHaKfeDoQA1izja5OoBo9DLmtTlePmaxHkRiOFbClOTrPsaWCKnyr
         Frf7ajU/ERB8FfqpzevI2iOsvM7MMdzwOJFl/mgZSuFiATJGZCrVpfe0zA9bpyqEpt
         trOZ5DJidgjEV1roCuZALttHyguOdTMG08ePLgI4pYtbYE0SEl2JNki5PnAfk2UI9I
         OGk2dPyufPnaA==
Received: from o365relay-in.synopsys.com (unknown [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id ECF34A005C;
        Mon,  5 Dec 2022 21:19:45 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id C3FB54009B;
        Mon,  5 Dec 2022 21:19:43 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="b7J4OGhe";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dnrvo2aLguyW1vOmr/E1qedSvxff/kLe/zO4GNtZ5zTevxMiSetaDijczTGl2Hud8OQ2gZ966TixHaxAqhor67loD+tMwTx8hZmW9kaw0BUvEPE0Uh/X+FwGvsNhTlf3xjsBSsOBf3S6ltAtf83QiVrNH4jmtKlTPakIS2KXnYuubPuSv70lUKQ1Z/oTP1dbjNjTzx6vtHZmUO0A8hHultSe4iobVJnSP6CL1bu3f8DY+EthgNdmJDMfXJjgsjXUO0R6tJvK+b7rA8aGfgcZY8CHWWXB8r+sHhmisnTYfxrXVvIwI0XS7Rw1jfdSks+MtcRbUg1nVnEYPiZ3bI4cXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzTp6aVBpxYAlKsBXnM4LzeTOLqJqfs478VORjedWyI=;
 b=LZNGKQaisqMOI68EZiHhpKK+PRoPddlfg2ZnUi/GbyREcusXZrGESGUxza4EIMHo4mLWKoudSWKiqfJBm4xD6WvIvdilERt0ZtuUVdBPIrSozDiym6CCb9xj5Pe5cXbtlCMtbZoWQ2mn6SE4r/xP5/ntgweEirLYFafzyeNwzPgepDP+ed4y9zF//xLMcd8VMfWLQ883ll1HZyorrdsH/309YzcXwHumDsCc/18MpBZFDwiNUwcwgF/xQ0gjFc1Lp0vwNjGci4usLML60/m4dS96UqJKAYwB8+Cur1rdd5Mu49hR4A2S1NZArypwwJ3lQKH0WbNAapERL4swEGwsRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzTp6aVBpxYAlKsBXnM4LzeTOLqJqfs478VORjedWyI=;
 b=b7J4OGhe/YNQV22BV5LaMOHtOIq3OFQg4uB7eqGpEjq288U8e5iDwkKqI9Zbib2I4ljXWYA52vNyS+MCDf2mNTWSk4r9hKS6nqJi6xChJrPbPXKEgq6dSdmj6JsJaAe7ggcO3/vTpJrS7VQISsF3Tx+Jmde6YexLUeNjPeUsJuQ=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by SJ0PR12MB6709.namprd12.prod.outlook.com (2603:10b6:a03:44a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 21:19:40 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::e395:902b:2e90:b7ee]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::e395:902b:2e90:b7ee%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 21:19:40 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Ferry Toth <ftoth@exalondelft.nl>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Thread-Topic: [PATCH v5 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Thread-Index: AQHZCOZrMdrz8rDju0i/AlWNK/AmzK5fzMIA
Date:   Mon, 5 Dec 2022 21:19:40 +0000
Message-ID: <20221205211938.kx5kaxzpwk4nsc56@synopsys.com>
References: <20221205201527.13525-1-ftoth@exalondelft.nl>
 <20221205201527.13525-3-ftoth@exalondelft.nl>
In-Reply-To: <20221205201527.13525-3-ftoth@exalondelft.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|SJ0PR12MB6709:EE_
x-ms-office365-filtering-correlation-id: 554f956b-ccba-4ac4-c5ad-08dad7066beb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xlqQp54hv5gcKpEb0IVrr0ZIEjjt9zB8bev1elu+pK92/KFuDUspxcILrje8xRpM8W0CBJi+cH25nf7CwhewEPoW4qe77wZVuzQuL8SJ7yM2qibbM5dtPFjHzGzy1j3RgX5hB9a1SxZdGLZpzywn7Qz8fzrfwdx61Ab8WIKBLKkHGqaiCWqMV7ik01IfN2mMBoO+GYS+T1VkHnxcFR+N6JxJ1KmeP3AqmUyE2LRNOfnGR7SOxWDIRgYuQ6rm91fqNID3A+Gd0qsUuHivzRJE3DW6tMwgpT4268MoqDsY/x9R4RNALob0zBOFUiO735Moo7GAkp84ArOvfMjAwlYQm4bQCxr+81OQ/z7iYaw6NfOdI2nBtrgQw0v0WGf3opb3H6HlzO5UYd99lgWWcIGCmjTxgscLXADfnbFWzY/aHAhRZEDJ9MCX6ABuevVc4cSaQcfKSEaq7HvqfA+njD+/12g461+FJeO33Yz+U6LD7e0U+g0Sv8K25dBn2ssSaSL8FUBTBNkCePgl8ArF7MhAZMx+/DUgahVRtrubioL45P4oYWcnbYa62hXsRLPKRVlD9fAfh7DcIBhBpearlSSXgsZyi2jpIceX/FFOhT74zdbJvwyTHZQSemh5sn/SW4WNu8OA6n/tj1iLF8vE9aJywLq+jC03BaWicSq5QEHVhWk6o+BzhaFg8NSUsRcuQ4DF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199015)(2906002)(86362001)(6506007)(316002)(83380400001)(1076003)(6486002)(54906003)(26005)(6512007)(6916009)(186003)(478600001)(122000001)(2616005)(7416002)(5660300002)(8936002)(41300700001)(4326008)(38100700002)(64756008)(66446008)(66556008)(76116006)(71200400001)(66946007)(8676002)(38070700005)(66476007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVVyWEp0OGx6ZmZueXVwcEFFM3VtOWQvcTBabEZIWUp3eFMzc3BxRHkzU1ZF?=
 =?utf-8?B?TEcvRDhsTGFBbE1VLytRRWNFSVUyOGdQSkdGUHpwc0NkUjQwQnVQcHRIMjF5?=
 =?utf-8?B?N1pPZEtjVWJ2bmx6TGxKYjZQZHF5UnNRcTRDNDQ1OGJkWGNRdysxV0N2UElQ?=
 =?utf-8?B?cVQvU1JuMlNBcHhHcEg2cEZXelFXYUJhcmVLVHlUQWhXNktLY0dTNEN3enNa?=
 =?utf-8?B?QlpsYUc0REZYU0hCS3pFMnhvQ2ZnQ1FnbjBRZTBldm5Hd1Y3cWV5KzA5SlZH?=
 =?utf-8?B?SlA0R2pNYWRjL0NLaTdjMjMySTVuTVRML05Gc0Z0U3NuS0NTMXMwOC83U3ZW?=
 =?utf-8?B?byt4U1UzTU9QS0VWbjM3WnpCeHd5d3VCWUZuUXFIa09NQitIeEFUeTVIMjZo?=
 =?utf-8?B?WTIrMnlsOWJCRXRtdU04UnA4NDhhR2ZNeVluSWtYbFMxa0NwZHFSQTZoSm53?=
 =?utf-8?B?bDRvTWtYSklWMTE3dk9SRjd2REVkaVQzaHFYWGxkWitRRFZXZ1hmTmxaSnRp?=
 =?utf-8?B?aEtJY3Vyd0VRLzYyT1B1RTdlWkEzTEh0TElUd3MzTGNzcSs3NVNQS1dTcFlP?=
 =?utf-8?B?V2phK0t1REJQbEZPbWx1NUNEaENzR2VVQU5xaXhiSFJLWVRkbTIrYlllbTUv?=
 =?utf-8?B?SEJSdUx5T1JMZ0VlSGlTazI1NG1zZzR4OUNoYVJ2K1ZrS1RnV0xTMkpRTkJm?=
 =?utf-8?B?bEw1YUs3MUcxWUJjcDh1a0x0UStoL2pVUHJvc2Y1SFZqbVVyeFJRZE4vR3Rh?=
 =?utf-8?B?eS9VL1ZVd3kxQnZqSUNVV1oxSk5lVTdtM0Zpb25ZelYvZmdKZlpNYXV2MG1J?=
 =?utf-8?B?NWVWRnBTOEJEZHk5eXZPQjl3WHlVSnhLVEVNU1YrT2F0TXB0VWE2M28rTkcr?=
 =?utf-8?B?dUFpeXpDY0ZxZlpvNjhwUCtrbm1BYjl1dERYNjNKMXA1ejJwNThsSlMxZTMw?=
 =?utf-8?B?d3Arb3dRdGNqMEFZZDRQQi9GVkJ5NFpmUkF0MHRTSS92TThERlFIZjdwUmNq?=
 =?utf-8?B?cFA2VTBHbW5hM2tIcHNjUVRUenRkNzdsZXRGWU4wd0RRM0JsVThwRk4zdWRK?=
 =?utf-8?B?MmlMZ294dFg0UzZxOVlYYXZlazdacnA5eGtPVllEZmdUL29McEZjOEQxOFI3?=
 =?utf-8?B?engvL0I4TzZQUDBhcDN2VUE1V2dzYWpSdlpyNi92ZTlEb3UxM25DZmQ3N3Ru?=
 =?utf-8?B?WUVRYjFHQ0ZuaGtsUFV1SE5ZaURqUlNKWk5PckZ4dWN6UnJPbUVyVzY0OVBi?=
 =?utf-8?B?Y212M0VqMVFBTllZbGhES0pnSTE5N1dPS3dmV0MySmhkb1ZZT1ZmeXg4eGpk?=
 =?utf-8?B?TGlIalBOcUpJaVAvYjg4cW5WbkF1dmtXSVJMek50ZWQ1YkNjem5DTENSODJQ?=
 =?utf-8?B?YjRRdVZyMUFPbG5pb0EybS80OEE1YklBYjRDK3MwT096M1creVI0MEhRM0RL?=
 =?utf-8?B?VnZ6dURUNnp0VUVOUFZLQzRlam42NS8ydXFtTVlacG9lbEFldFhWOWxTM0Z1?=
 =?utf-8?B?RWo1TCt6ZnFnTXYrNGV1MTUrQnJGVzZLN2VZcXBFa0Q5WE10NWNISk1uWDhl?=
 =?utf-8?B?cHNBYW9DU2tzUWJHNTJnRis2YWlUbnc2Z0ExdXVOY3NZWXNJZVhUajd2Tlhs?=
 =?utf-8?B?clVjVjdJK3BwbzF3NkJhQlNwdnM0bzJiOVRZY3pJdStSUVJ6VVk1dmdiTGRE?=
 =?utf-8?B?NzUxaml0Y0NJRUMyY3NVOHVQYUg0djYzWGovYktqdDVubHpjanNiQnZMSkZo?=
 =?utf-8?B?a1ZRYkhSdFFPdEREK1hPVXdJNi9tZnJKcGhLQjRYbXBWdTdCdUEwaUhOTEps?=
 =?utf-8?B?b2hHQlNBdWdhMnduR1Z0WHdqYXVhVzRJa3ptbEpyTTM0WnphVEJXK25vbWMy?=
 =?utf-8?B?UExTczlYMnU5SzIxaVpxemMyQXU5L25KekFXM3BWamR0K0F4KytnWW80Y2VQ?=
 =?utf-8?B?SGI1aGRzVGxhT1JNSzZ3cUZJVWorNnU0dGZ1K2Q5Qkw1a2ZhQUZ2bFovdWw4?=
 =?utf-8?B?WTRDeUVqQ1NxZG5wUzhSYWozOVlGYlNpU2dCMmFMUkJPZ0VRTDZTcEI3aHZ0?=
 =?utf-8?B?NWlVVU91VnRwQW9DOW83a2hHYkhweEtuMDVBeEx4T3dRVTc2emlKWnFUaisy?=
 =?utf-8?Q?S/j6eRIFvXBsBJQJiYFiFjQmr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD850BB452B29C408DAB7A4C3CAAA18C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?b3NDQ1dVcjZhUDZQM1dkZUZFckk5S3hjd1ZRVUxqVjRNbXM5bmZwdmdydVdq?=
 =?utf-8?B?UDhRU2EwRHVqaTlVcThMd0FDaEZ0M3FaZ3NEWi9FaldWNU1YbUsxckxnblpM?=
 =?utf-8?B?VU1hQUFvRElPdGF1ZHY4Rm8rbnJiWkc2cFZtRDFRZjF0aEJvejdRdG82bGZ2?=
 =?utf-8?B?ZXZOWmdaczRJUXNOMFZiNFdZa0VqVUJ6OW0xN0FMbzYvZFllNDFQeDFJUy8y?=
 =?utf-8?B?KzlkYkc1NUtRbElxcmRaYkYzS3lGenFSSWVsNHJDTmVGNXBqVjN4bW9ycFA4?=
 =?utf-8?B?SlZWM2JWc1FMWEtBLzhwWnVvMUpYQ254dVNnckI4RFRCVi92NEhHZGxXWWpC?=
 =?utf-8?B?a0tDdlo5ekZqOHJJWEYvVUNVMkdDTnl1WGlTNStSRkIvUnpHSjNocUUxT2pm?=
 =?utf-8?B?SFNUeE8rL2tHRjJLYk5JZ2NRTEZPVzYrOWJpVnJKQWpJQmJWTklRK2p5eFZk?=
 =?utf-8?B?QVgvZi9ZRzdPT2VjNnlta05sMlZZS3pINkx6eHVmeTJpZk9qVTJuUlJXN1Ux?=
 =?utf-8?B?KzJ4R0V5dkVINk8zVktEcEFSNTVmN040alphTmZWYysxcVJWR0UwQ2dXS0dB?=
 =?utf-8?B?czdZdEtac1ZJd1Z5NWxyZWlFc3hMSlhneCs3cm5OMDRhdkxSbHJWdGl2ME9K?=
 =?utf-8?B?UmxBbHdFYTNtc0pRaE5wTzdsQi8yMGtyWE5kamhMU3FQRzE3SXdWZlMzOGNQ?=
 =?utf-8?B?aUNpWDMwN1hxclRyZldxQ3FRNDluSEs2MTRTYWhmSW5yK3FJNzJDZUpoVGhy?=
 =?utf-8?B?REd2ZFlPZ2QyNldHM1B1S3M3ellac2h1bVM2eng5Rng4a2R2WEZmRXVZSlZN?=
 =?utf-8?B?YUpCV0ZmRzBLY3ptUngwWnpqNmVRYWczWUtPN2NQTjVIWnphSHpSMUFCMURP?=
 =?utf-8?B?QXNRN3BLYUtJL0QwNnBKazl6N1QzSVBVc2tOSHZIODFLYU81ZUd3a1AwaExt?=
 =?utf-8?B?WGdDcUxnL3pxbC9vWFFGWm96Ylk0clJuYklGbEZxMWxUZ2Qrbzhld2VGc0Vj?=
 =?utf-8?B?aEdqVnRlMHEveEliYkNxbVlGWVpQNFQzNWtRY0d3cHQ1OGowdklMSGxsaHZi?=
 =?utf-8?B?enRld3U5WXIrTTQxNlN5cWR5ZXdYZzBPbTFyMllrdjIxN3hGa2xmQnZycWIw?=
 =?utf-8?B?UzUvUkFybld5eDZ3VTdXQ01vMFdrNVY2UmFBM2c5TUo3clVYeFlDSVB6QzBq?=
 =?utf-8?B?SVdmdjZBM29lWnZpZnkvVWFyQnJDMStHdTNSMzVLZkRodWhqaHBLellVdXNC?=
 =?utf-8?B?V1dmVjVaQVY4RGY1N2trNGZ3QzgrMEoxZlNRMnhVQzltVGlsbGVoVjU5dDJ0?=
 =?utf-8?B?OVdFWS9pWjZBY1dSQWdlWjBMOEplQTJnWUNBMmYxVjBpWUNUS0RiL05zSklL?=
 =?utf-8?B?dDk1Yk52b0Yxa3F2WGdXMGVSRHZwZHpXeUlQRTQ0d2xkSyt5aHAyT1VpdGpV?=
 =?utf-8?B?VU1uK2E0dXM3cGZBZk9DVTdvRk5zY2JHeldBMFR1RzRTVVhyYlRNMTZpN2Ji?=
 =?utf-8?B?SmhaUnhjd2ovS2pJaWY1Mi9kQWRkVzVlejlxSWZ1cmxmaGJKeUJwWmk5Uk4x?=
 =?utf-8?Q?YQx+bCvm6AJ+nXu+qNmrmbZ64=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 554f956b-ccba-4ac4-c5ad-08dad7066beb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 21:19:40.6110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yC1yKGavXyrPzMehE5cqmb9tRI4eP0M5leRYM4Ucf2kvANLbK8Ka2yEGG6yS0Pvcv7J+hHb8RrTK8TIZW4MNjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6709
X-Proofpoint-ORIG-GUID: O7gU1kafC-RoRFvKqNAHVKLtCLtGG2Kc
X-Proofpoint-GUID: O7gU1kafC-RoRFvKqNAHVKLtCLtGG2Kc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212050179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCBEZWMgMDUsIDIwMjIsIEZlcnJ5IFRvdGggd3JvdGU6DQo+IFNpbmNlIGNvbW1pdCAw
ZjAxMDE3MTkxMzggKCJ1c2I6IGR3YzM6IERvbid0IHN3aXRjaCBPVEcgLT4gcGVyaXBoZXJhbA0K
PiBpZiBleHRjb24gaXMgcHJlc2VudCIpLCBEdWFsIFJvbGUgc3VwcG9ydCBvbiBJbnRlbCBNZXJy
aWZpZWxkIHBsYXRmb3JtDQo+IGJyb2tlIGR1ZSB0byByZWFycmFuZ2luZyB0aGUgY2FsbCB0byBk
d2MzX2dldF9leHRjb24oKS4NCj4gDQo+IEl0IGFwcGVhcnMgdG8gYmUgY2F1c2VkIGJ5IHVscGlf
cmVhZF9pZCgpIG1hc2tpbmcgdGhlIHRpbWVvdXQgb24gdGhlIGZpcnN0DQo+IHRlc3Qgd3JpdGUu
IEluIHRoZSBwYXN0IGR3YzMgcHJvYmUgY29udGludWVkIGJ5IGNhbGxpbmcgZHdjM19jb3JlX3Nv
ZnRfcmVzZXQoKQ0KPiBmb2xsb3dlZCBieSBkd2MzX2dldF9leHRjb24oKSB3aGljaCBoYXBwZW5k
IHRvIHJldHVybiAtRVBST0JFX0RFRkVSLg0KPiBPbiBkZWZlcnJlZCBwcm9iZSB1bHBpX3JlYWRf
aWQoKSBmaW5hbGx5IHN1Y2NlZWRlZC4gRHVlIHRvIGFib3ZlIG1lbnRpb25lZA0KPiByZWFycmFu
Z2luZyAtRVBST0JFX0RFRkVSIGlzIG5vdCByZXR1cm5lZCBhbmQgcHJvYmUgY29tcGxldGVzIHdp
dGhvdXQgcGh5Lg0KPiANCj4gT24gSW50ZWwgTWVycmlmaWVsZCB0aGUgdGltZW91dCBvbiB0aGUg
Zmlyc3QgdGVzdCB3cml0ZSBpc3N1ZSBpcyByZXByb2R1Y2libGUNCj4gYnV0IGl0IGlzIGRpZmZp
Y3VsdCB0byBmaW5kIHRoZSByb290IGNhdXNlLiBVc2luZyBhIG1haW5saW5lIGtlcm5lbCBhbmQN
Cj4gcm9vdGZzIHdpdGggYnVpbGRyb290IHVscGlfcmVhZF9pZCgpIHN1Y2NlZWRzLiBBcyBzb29u
IGFzIGFkZGluZw0KPiBmdHJhY2UgLyBib290Y29uZmlnIHRvIGZpbmQgb3V0IHdoeSwgdWxwaV9y
ZWFkX2lkKCkgZmFpbHMgYW5kIHdlIGNhbid0DQo+IGFuYWx5emUgdGhlIGZsb3cuIFVzaW5nIGFu
b3RoZXIgcm9vdGZzIHVscGlfcmVhZF9pZCgpIGZhaWxzIGV2ZW4gd2l0aG91dA0KPiBhZGRpbmcg
ZnRyYWNlLiBXZSBzdXNwZWN0IHRoZSBpc3N1ZSBpcyBzb21lIGtpbmQgb2YgdGltaW5nIC8gcmFj
ZSwgYnV0DQo+IG1lcmVseSByZXRyeWluZyB1bHBpX3JlYWRfaWQoKSBkb2VzIG5vdCByZXNvbHZl
IHRoZSBpc3N1ZS4NCj4gDQo+IEFzIHdlIG5vdyBjaGFuZ2VkIHVscGlfcmVhZF9pZCgpIHRvIHJl
dHVybiAtRVRJTUVET1VUIGluIHRoaXMgY2FzZSwgd2UNCj4gbmVlZCB0byBoYW5kbGUgdGhlIGVy
cm9yIGJ5IGNhbGxpbmcgZHdjM19jb3JlX3NvZnRfcmVzZXQoKSBhbmQgcmVxdWVzdA0KPiAtRVBS
T0JFX0RFRkVSLiBPbiBkZWZlcnJlZCBwcm9iZSB1bHBpX3JlYWRfaWQoKSBpcyByZXRyaWVkIGFu
ZCBzdWNjZWVkcy4NCj4gDQo+IEZpeGVzOiBlZjZhN2JjZmIwMWMgKCJ1c2I6IHVscGk6IFN1cHBv
cnQgZGV2aWNlIGRpc2NvdmVyeSB2aWEgRFQiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
Zw0KPiBTaWduZWQtb2ZmLWJ5OiBGZXJyeSBUb3RoIDxmdG90aEBleGFsb25kZWxmdC5ubD4NCj4g
LS0tDQo+ICBkcml2ZXJzL3VzYi9kd2MzL2NvcmUuYyB8IDcgKysrKysrLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdXNiL2R3YzMvY29yZS5jIGIvZHJpdmVycy91c2IvZHdjMy9jb3JlLmMNCj4gaW5k
ZXggNjQ4ZjFjNTcwMDIxLi4yNzc5ZjE3YmZmYWYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdXNi
L2R3YzMvY29yZS5jDQo+ICsrKyBiL2RyaXZlcnMvdXNiL2R3YzMvY29yZS5jDQo+IEBAIC0xMTA2
LDggKzExMDYsMTMgQEAgc3RhdGljIGludCBkd2MzX2NvcmVfaW5pdChzdHJ1Y3QgZHdjMyAqZHdj
KQ0KPiAgDQo+ICAJaWYgKCFkd2MtPnVscGlfcmVhZHkpIHsNCj4gIAkJcmV0ID0gZHdjM19jb3Jl
X3VscGlfaW5pdChkd2MpOw0KPiAtCQlpZiAocmV0KQ0KPiArCQlpZiAocmV0KSB7DQo+ICsJCQlp
ZiAocmV0ID09IC1FVElNRURPVVQpIHsNCj4gKwkJCQlkd2MzX2NvcmVfc29mdF9yZXNldChkd2Mp
Ow0KPiArCQkJCXJldCA9IC1FUFJPQkVfREVGRVI7DQo+ICsJCQl9DQo+ICAJCQlnb3RvIGVycjA7
DQo+ICsJCX0NCj4gIAkJZHdjLT51bHBpX3JlYWR5ID0gdHJ1ZTsNCj4gIAl9DQo+ICANCj4gLS0g
DQo+IDIuMzcuMg0KPiANCg0KQWNrZWQtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5
bm9wc3lzLmNvbT4NCg0KVGhhbmtzLA0KVGhpbmg=
