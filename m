Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1741E5F4D9B
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 04:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJECM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 22:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJECM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 22:12:56 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9CF3AE64;
        Tue,  4 Oct 2022 19:12:54 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2951c59M006464;
        Tue, 4 Oct 2022 19:12:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=6yPXRmNUa8FT8dP70ZjABuWvBBiVbvTh128TVwQTvd4=;
 b=AnB3IRZbo6fqRjEjGcSx/t2Nxer3oXdZ8I+mTS6CfV5VGNhh/LkbRg6hSuOnT1xuurtc
 OxlXybRPvGkkN1/xoPWJbNnA1EwqhYtMWKZiXmqq3H9DNRozC2L5MBfPz+XqxoP1JCcs
 PQI40yvcQrzQ1H2RIK9vEYTyA5vXOPFRWSEiru8+Lyev+9h8TaDvAzFTUPKLzQLPCtJd
 EdufEe1ogLDGWzpUuj13MCwSKgfChRu/7gtQIwTb8S+VxspLweoUpSp2rkmsf3RWkvaN
 Zxcpoxtr6EmkQBe3CmmynXaKW0C/1vZzGKfgxsEQ0nH7uvr22pRwUuqCrn7uudez1r4j BQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k04h77f0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 19:12:41 -0700
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 33C1340020;
        Wed,  5 Oct 2022 02:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1664935954; bh=6yPXRmNUa8FT8dP70ZjABuWvBBiVbvTh128TVwQTvd4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Tw6xhGyN2PW3yFHoGAz9ZY00GgnidittT8TEYomJMJ1ysqxDPiM+trjGzYU9eOvds
         MQ2GNmQy4tOcn4NEAQ/AUMThm2ME9W5kC0oW5ALKj3k0TJgIFr7Ryh0EZjT88XoEnb
         sAWGia3UB+otPZRG9/cbn6DXSpUWWM9rv4AFC2OxBmc64SQNVfrAkMw4HCmjJ/z+wL
         4wMhKug9Z7AwFtzEvrGOsEVPMJYhWbkedgE7Y8FSi60aqeu71NDKIwPtGTQ5ZhByqA
         EMdRlpyJlukeSl2qQ3FGVblQrNuZKndifPyPhAQkiQvo8ckhX4oOr2GFADrAS3ZiDi
         uzqbXtWZbr8Rg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3DA85A006B;
        Wed,  5 Oct 2022 02:12:33 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 4B61E800C7;
        Wed,  5 Oct 2022 02:12:32 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Oc2GeH5R";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANZNhGKyUGi4C3L99tnigY7odJFrcqj+Ol6d3vXJs8cOaf9XGGIehMhHa9YtH1+GkKKi+Sfjx9rVK3L5vm3XSkN5X4rWJr3UBg4FEBOtDm91QxRhlVEekJo/QP5Hy4WkTjLW5Qoq+0Oi5OWbjekhNJ39eSf8Y0zBmHpXEEYeN2D04oqjT5Ic/F/kTL49mhwWSGaYlk3A7QIyytOFkc6sWuBew7/y1lruyDdtr+tQgANtcoGQR/OKM02PuZXsDPPAHdziV5FTwutzxXy098lAaVe8K2xcZaVLWxXdK3O4IhVzP9uM/dHVD8mt699yvxFjdZi24LGkZ/pckqMhXk/9UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yPXRmNUa8FT8dP70ZjABuWvBBiVbvTh128TVwQTvd4=;
 b=gis3ydq+HiDYL1fWY0HqjJ/+SIAsXSsdhs4VEu5WmVV8BBumKl6v/aJS0QGuGmt9rt7PTk8p2P/YeJmwBseqjGXoDubmyTM2QLpzSqptliPD79G40UP+E88s8zpHIScstCR2m7cyIym8nQ6DdW8xgo79b1nyfhfNvxggYnz3pwpaQuanIH8GXKG1EMnbjOwsv/HholBxmuUAAub5HyBpKqbRsIP9fBdnie+xubjXZ4zxzCSaUlyLEjxrYtQJB97a6Ek3haufQFPCE+ZTKczvj8Tb3jcmiOfjGewytPgCRuEjqsKH9gjylEl4vNBfsKwVSPkOaJZbivunjwICrfR9pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yPXRmNUa8FT8dP70ZjABuWvBBiVbvTh128TVwQTvd4=;
 b=Oc2GeH5RptOWuYLo8l4WZSzXgWX4afNRoS6X/+hV3qgU5Jn89KGRFzXvjoDq1MKN3MDOf46RNX30O7nTvyMpz5HSXLmktrT7dJpSurWlNKbMmV6XFDPN4i2hmAt6ri35g2ah3trhlggjcT4pNdyDDfrV0OAVLjqqSQ26p2koq+k=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BL0PR12MB4916.namprd12.prod.outlook.com (2603:10b6:208:1ce::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 02:12:29 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 02:12:29 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Ferry Toth <fntoth@gmail.com>
CC:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Topic: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Index: AQHY0omsjm4tTlL0CEmkY916+rpAAK39QTUAgACwSgCAALRxgIAAdL8A
Date:   Wed, 5 Oct 2022 02:12:29 +0000
Message-ID: <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
In-Reply-To: <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|BL0PR12MB4916:EE_
x-ms-office365-filtering-correlation-id: dbc5008f-a91c-40eb-1722-08daa6770def
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hCfhR00qRTwbJy8m7BEOb5ZW1BVtY/cUBzjrnxbHSb9YKhmzg55rMliK4HkY0VqCnTmpK/99UNc0LqmcS2r13s/7wtA55rpiR7h7jp3g2CASi7DPcl62i+otDaYYFtAKlOT5bY3xfOlU4hEfAQWL0azkySVr9/Zq70GQQhqG06ganDmBPp4OKmC1doZzuKl8kyqcB69/3FlHefAiY9CnR9CpkZXbXAjg8T6LiI2xYwO7voD1PqCoGo8nERMbWUJjMQmI6PAak7YvH+LAmrE6PCRukBrBpsCAQimA58kjdsCw5VUdOPjV4QuMBBi6On6h80G7XFiTlLdP5HX6CkW4+35t0ccYihe64t+QDQWop0//UuK+NUZs47lRr51fOvoeHzONGcA5MmfRrgfOij4MmHh73bSI2QIrnwTgE+rN9D1h4CrHo8c8/ud2Ohc/trq9AGY9eZ2dz5CcXCoyaFuH0ahQ/C82480lm3XjpAKr944cqkjRz/ypRWnQZGHh9a2I5rDO9fGOCO9OTqzzyo4dz/HGqPT4iXm7rurQ/uwxdRYmpH3O/MQHAxpumw0ZrHCOAVYbqZ0ylfTCT01icAxx3GOBud06wR6yo3rIWzERepj2nm8w8x7YypPjEqWGC2Kdx1x9ujlgysHZltPLhQaJGyB9pyaw6Zi7Au2YBZK7XSSFZgj8au0uaJjldrl/ZAqcQpZomSxA6x38GZQM1+lpstVF25kZbRXAaNLIqF3lGact2Su2hvxGfhJiWRjGvL4tkxO+pnhBLVDPMod5KpdE58dTJ++M7KoYKdKujZH9sUM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(136003)(39850400004)(376002)(451199015)(966005)(478600001)(6916009)(54906003)(316002)(4326008)(64756008)(76116006)(66476007)(66446008)(8676002)(71200400001)(6486002)(66556008)(66946007)(2906002)(6512007)(26005)(5660300002)(2616005)(186003)(6506007)(1076003)(41300700001)(83380400001)(36756003)(38100700002)(8936002)(122000001)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1JYdnZLZnovS2VJK0lxYTVubVQ4TEJjV1ZJVXJDSHNsbTN1cnVmMkY0bTQ5?=
 =?utf-8?B?dllMU0QxdjROTzZvWlY0ejVCWFltR05IT1NFZCs2dVJEQ3p2UjhHN3BFOWkx?=
 =?utf-8?B?VDNUZUo4M0VsVUYwMGRiMDRRb2hYRXBXNVFFT3lNUmFOZ1hzN3pRNkdOd3ly?=
 =?utf-8?B?NWxrd0hRRE1USDRtM1F1ZWtEVWtCM2R0ZzZNaVRjbjcyc0tJcTFuR2RibytZ?=
 =?utf-8?B?OXdnalE5RmVabTNyWmdhbGlKblRHRGhCUlI5MVF6alJadU9sR24ydlJxbGUr?=
 =?utf-8?B?ZVhsb0JGVzd5UDhxWitsY1M5TUZDZGV6UkNhNitKM3J4S2tlVE1ZaDRPT1Ew?=
 =?utf-8?B?ck9YZzNEYjROYUUvNmtPNUttdjlvVS9EU2RZc0ZUUytZNGRmbEhiYmlLbVh6?=
 =?utf-8?B?QXg1cjdsWkI2dTB4cS95ZlQyWlczb2crN2paN1BaTHNlRzhDMFE0cVp5bVJN?=
 =?utf-8?B?S2ZOUWtZQ0JhZFlHS1VPTEdWSW1OMU5xMjRKajJLWDdFZ2ErMzl5TWpoQXQ1?=
 =?utf-8?B?U2gzWjJTTk02dnlzd2NsUjVTNTlxS1A4VXYvRlFCSzF0bWUrRWJPbU5VVSt2?=
 =?utf-8?B?Y0JSbFU3UllnY3RPeWNOWnMwWUVXeU1VL1BxUFlwMmVsRlNCSEFBMlkvTlBV?=
 =?utf-8?B?UjVvYm93UXhJN3kwSUtRQkphY2toY3ZHTkRDLzRxWmIzWFMxeHNneHlGOGJB?=
 =?utf-8?B?TXRPVCtCODY1SitOOTRDRGtqdG9XeGkyUzlXRURURGozK2pLNmhSL0pFVExw?=
 =?utf-8?B?T2tuN2F6aDZJZGk0R0JDQUduT2ZXem10L0FlUW1oRk5sSm1RdTBabUZxR3N6?=
 =?utf-8?B?ZktLVjMwUmNCZTJUWFpwSXVvNEV5UHB6d3lzYmFmS2NnVitUeXZGRDhla0Rn?=
 =?utf-8?B?ZE5OY1dGVFVoMXVialkvM25PL29iVkpUNUNnb0N3NzZuN2RWKzJDd3hKSG5X?=
 =?utf-8?B?ZFZjaFFjUEFnL2RvcGtpVndUeXNPUm1JOS9HVXlhaTViNVB5WFg1bks4Zm9o?=
 =?utf-8?B?b1Y1ZDlWMDVBSnRRNlVHenhBbExuTlQvVVd3WFRSaXZ0Uzh5VFJ1b0RWYXVp?=
 =?utf-8?B?NGxiRzBsdU83akU4aFNWK25KMytxWGlMSG9XOVdES01Nb29YWE1xME1aT25X?=
 =?utf-8?B?dHBvNUNKTEx2WnRycVhlczc1S3VCb3VhQzVtZE9LNW9RRVNpbkFSaWh1NitL?=
 =?utf-8?B?eDhFVVBQWXpkRzIxcVFVWkhXancvbFduQTh6MUZ5Nzljei9zMDdEK0lEZmty?=
 =?utf-8?B?a29JSENmQnd0R1dLYnVUZXlmUE53NnFjbS91ZElUMmVxaHZ2YmhZM0RGUFQ4?=
 =?utf-8?B?S3RXMjlYOXY0VG0vQ2JuT2xRbmJLcFNBN2s5UmJIS0dQczJTWjlENVAvcURV?=
 =?utf-8?B?SjNGcW9rSS96cFREbWl1ZTl3ditnRHkzbWVwR3ZETlVRWlA3TjN0Uzd4Qm00?=
 =?utf-8?B?RHpKWi9YY0NnVlJXR2RQcTE3RzZUQTIyeDFIdi96Z0kzOVV4NE92ZUE3eFdL?=
 =?utf-8?B?bGdiS2s2ZDl2cU16VHdocmcxbGpDUlpOU3J3VU5SWjlWVUJwbzFVSkllSVRl?=
 =?utf-8?B?TjJaVVhrb0N2TGNER3I2V2JiSEJJaUI0d09Ua1g1RmZxRjRSY3R5N0d2TklG?=
 =?utf-8?B?T05mT2RBQ0twd0p3TDNnRmRzMkdRcjNaa1pHajJ4K0lVdHFwMWFuSUl4VmRZ?=
 =?utf-8?B?SnhZRmhwYjc2aTBoRnR1QjY0cU9nL3pYazBueE1Oa0NIZGk5ZlBPdXFrd3dk?=
 =?utf-8?B?dHZwckUyZ2dkcG8yUjhyQldrQWQwRXlKTDYwZW1pSWJlQ2c3czZOMS9nUm5h?=
 =?utf-8?B?TE9hcXBvTlZaNE80Sm1iTEYyQkRwL3dWUUpMWmVtdXZ2Y1VFblpKZ2t6OXAx?=
 =?utf-8?B?eXB0VUY1UHpZWGZ6VHROcFg1RDUvZGZ1dlNycGdkSVNyMWQ0SHIwcHEyb2FN?=
 =?utf-8?B?RkY4TmFTakdIeGlWS3hEWTA1TXdJSVlnRU85d0tQMmV5R1NVTGtUdE50Sjhx?=
 =?utf-8?B?dXVyMCsxYzlkaEQ0OHpBNTkyc0tnUFpNallvWHBKalp2cno1dUNXRERyNGhx?=
 =?utf-8?B?ZlNxdWd3bWs5Nk5tbzlxTnBNZ2xVaHEraEE4OFlhZStjeEZEZEI0a0Q0dHNC?=
 =?utf-8?Q?osWYO2FKtiaqZgH8H4QlhuVNc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71C5C77EF4B0B941BD813E8D187DA23C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RVFKbjh2TTZMNzB6WmVqNGVDdXo5L1VjSm1xdUJVcURLWk02anQ5aHZpWFpp?=
 =?utf-8?B?WjJtWGxZQVEyWXVTdEVZSnNUUDE0ZmN0YjYwYjl2dWYzWERyaFhMZkVlL0Fz?=
 =?utf-8?B?UTk4eks1cTlwUi93Szg1a1hRYjkyVVY5RDhUVk5pS3h2WFNlcXFFL3NHTTg2?=
 =?utf-8?B?c2NkTXFDQlJyUjMzVWFpKzZINHdBSlM3RUVEVTJOSXFEdlFBNm5VZ2phakpE?=
 =?utf-8?B?d1pPRXFzczhBMVdadGVMQXBHTDdLQ1MyYk50V01rMldMYW1XS0JNWEJ2MWVY?=
 =?utf-8?B?TkdzVStIdU9vSU96UHF6QmVhWUVnbWxOUlErVUZESVhtS3ZuTXZMUWJEZlNW?=
 =?utf-8?B?bTBWNFFHcXJCamx5eFllNzlONmJNVFhKMTU0WTVGYStzSENCell3SDNqN2pD?=
 =?utf-8?B?Q1p4RDhmRlFtU1JsQktNaFVvbHpRdWk3bUwxUGVFWW15SXU0NzNLT0o1M2U2?=
 =?utf-8?B?bzRMMHRWdDFHNjU0NlBHMFFGNGdhL3dwYy95UUsvbTUyc1Z3SkVuaHd4dS9M?=
 =?utf-8?B?eDlLcnJtY0JQMFFON0x6a2c1cW12MWVwYVhncncvTE5vSGV5S0Z1MFJ5VFF1?=
 =?utf-8?B?Unl5b2Vsc1piV0JWQUdKQ3B4RmtaeGwwNHdoditncE5Dc3ZURUE1YmhQeHFv?=
 =?utf-8?B?dTdqbkpMQ2hHSTZLTUJjUU1HanFJN3Z0RUZ3RlcyVmIyN3QvekRlb1lXTVVO?=
 =?utf-8?B?eDYzZ3ZmZFFqM0V2UklHRFg1Z20yTlBUMEExVWZJUjRhSUZ3em82ZkR1MlVP?=
 =?utf-8?B?YTExaG9JQUhGNCt1MUtFVDQzN2ErMUh0VGdYSVB4Vno0ZUZ6aEJ3U0ZHUFBN?=
 =?utf-8?B?cVlMdnpldDhqbXh1cVB0RXllQUt3c2pRV2paU08zbWRydEhpNmJmcWRocnBX?=
 =?utf-8?B?L0hBM2VFOHp0SGNlQ0lmbVNBWmhEK085V3pUd2kraDR5c2RGbG10THNpN1Ra?=
 =?utf-8?B?RjkyN0hta0U4TkdDb29VL1VMQ1d6NkY4VDhjaFRiSW1CVGVWV1QyWFNndXgy?=
 =?utf-8?B?cEZ4L0d0QjJnaUlmWmd0ZnE1T2tmU0lrZ3lQN0NRbCtENXByZHNyOXJvbjBR?=
 =?utf-8?B?QUhuWUFHTTNxVk16SG0ybllhU0FTQmNMbEdJeUU4REFzWmYzNUtTcG1KSFZC?=
 =?utf-8?B?UzdBd2JXOGRGMXZ6NW9KRGRUalVYSnpkekI3T3JBS3E3VWNsU0x5dS9IeUhl?=
 =?utf-8?B?bFd0K3MwK1hxUlF2QWR2eTZjdXNrSVpOWWN2MXRNMnhBNFEvdHUzVDNKUTQ1?=
 =?utf-8?B?QlMxUC84NnQveFpISkowdlRpOFV1ZU91eS9sbG9hRE0xNTRqSG5vTWFZM3Zo?=
 =?utf-8?B?dmFSaGF6K2RReFlQVzRGdjhHTmdZalZrRFpQZ24wN01mTEZvVkwxdjFQdE9O?=
 =?utf-8?B?VnVMdTI3cmh0eTFPSTFzblV2ZXloakZvY1QxbDRmK1hqczZKVUJhUW9EUzZk?=
 =?utf-8?Q?qtBXcRvN?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc5008f-a91c-40eb-1722-08daa6770def
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2022 02:12:29.0969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaW/aR7RrzkelqUA6BXLF00VQ67v+JUbGvdKxbDAf81h0Hl4psr0a7um3BBJLvU/Unef5KaMRFFPeUicdmDKKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4916
X-Proofpoint-ORIG-GUID: euiCrjb6Udx6jZH75xRKxID6IHY0QNP5
X-Proofpoint-GUID: euiCrjb6Udx6jZH75xRKxID6IHY0QNP5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBPY3QgMDQsIDIwMjIsIEZlcnJ5IFRvdGggd3JvdGU6DQo+IEhpDQo+IA0KPiBPcCAw
NC0xMC0yMDIyIG9tIDEwOjI4IHNjaHJlZWYgQW5keSBTaGV2Y2hlbmtvOg0KPiA+IE9uIE1vbiwg
T2N0IDAzLCAyMDIyIGF0IDA5OjU3OjM1UE0gKzAwMDAsIFRoaW5oIE5ndXllbiB3cm90ZToNCj4g
PiA+IE9uIFR1ZSwgU2VwIDI3LCAyMDIyLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+ID4gPiA+
IFRoaXMgcmV2ZXJ0cyBjb21taXQgMGYwMTAxNzE5MTM4NGUzOTYyZmEzMTUyMGE5ZmQ5ODQ2YzNk
MzUyZi4NCj4gPiA+ID4gDQo+ID4gPiA+IEFzIHBvaW50ZWQgb3V0IGJ5IEZlcnJ5IHRoaXMgYnJl
YWtzIER1YWwgUm9sZSBzdXBwb3J0IG9uDQo+ID4gPiA+IEludGVsIE1lcnJpZmllbGQgcGxhdGZv
cm1zLg0KPiA+ID4gQ2FuIHlvdSBwcm92aWRlIG1vcmUgaW5mbyB0aGFuIHRoaXMgKGFueSBkZWJ1
ZyBpbmZvL2Rlc2NyaXB0aW9uKT8gSXQNCj4gPiA+IHdpbGwgYmUgZGlmZmljdWx0IHRvIGNvbWUg
YmFjayB0byBmaXggd2l0aCBqdXN0IHRoaXMgdG8gZ28gb24uIFRoZQ0KPiA+ID4gcmV2ZXJ0ZWQg
cGF0Y2ggd2FzIG5lZWRlZCB0byBmaXggYSBkaWZmZXJlbnQgaXNzdWUuDQo+IA0KPiBPbiBNZXJy
aWZpZWxkIHdlIGhhdmUgYSBzd2l0Y2ggd2l0aCBleHRjb24gZHJpdmVyIHRvIHN3aXRjaCBiZXR3
ZWVuIGhvc3QgYW5kDQo+IGRldmljZSBtb2RlLiBOb3cgd2l0aCBjb21taXQgMGYwMTAxNywgZGV2
aWNlIG1vZGUgd29ya3MuIEluIGhvc3QgbW9kZSB0aGUNCj4gcm9vdCBodWIgYXBwZWFycywgYnV0
IG5vIGRldmljZXMgYXBwZWFyLiBJbiB0aGUgbG9ncyB0aGVyZSBhcmUgbm8gbWVzc2FnZXMNCj4g
ZnJvbSB0dXNiMTIxMCwgYnV0IHRoZXJlIHNob3VsZCBiZSBiZWNhdXNlIGxhdGVseSB0aGVyZSBu
b3JtYWxseSBhcmUNCj4gKGhhcm1sZXNzKSBlcnJvciBtZXNzYWdlcy4gTm90aGluZyBpbiB0aGUg
bG9ncyBwb2ludCBpbiB0aGUgZGlyZWN0aW9uIG9mDQo+IHR1c2IxMjEwIG5vdCBiZWluZyBwcm9i
ZWQuDQo+IA0KPiBUaGUgZGlzY3Vzc2lvbiBpcyBoZXJlOiBodHRwczovL3VybGRlZmVuc2UuY29t
L3YzL19faHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjIvOS8yNC8yMzdfXzshIUE0RjJSOUdfcGch
YXZmRGppR3dpOHh1MGdySFlyUVFUWkVFVW5tYUt1ODJ4eGR0eTBabHR4eVU4QmtvRkQ2QU1xNGEt
N1NUWWlLeE5RcGRZWGdQMVFHX0laYnJvRU0kDQo+IA0KPiBJIHRyaWVkIG1vdmluZyBzb21lIGNv
ZGUgYXMgc3VnZ2VzdGVkIHdpdGhvdXQgcmVzdWx0OiBodHRwczovL3VybGRlZmVuc2UuY29tL3Yz
L19faHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjIvOS8yNC80MzRfXzshIUE0RjJSOUdfcGchYXZm
RGppR3dpOHh1MGdySFlyUVFUWkVFVW5tYUt1ODJ4eGR0eTBabHR4eVU4QmtvRkQ2QU1xNGEtN1NU
WWlLeE5RcGRZWGdQMVFHX2JvYUs4UXckDQo+IA0KPiBBbmQgd2l0aCBzdWNjZXNzOiBodHRwczov
L3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjIvOS8yNS8yODVf
XzshIUE0RjJSOUdfcGchYXZmRGppR3dpOHh1MGdySFlyUVFUWkVFVW5tYUt1ODJ4eGR0eTBabHR4
eVU4QmtvRkQ2QU1xNGEtN1NUWWlLeE5RcGRZWGdQMVFHX01iYmJaSUkkDQo+IA0KPiBTbywgYXMg
QW5kcmV5IFNtaXJub3Ygd3JpdGVzICJJIHRoaW5rIHdlJ2Qgd2FudCB0byBmaWd1cmUgb3V0IHdo
eSB0aGUNCj4gb3JkZXJpbmcgaXMgaW1wb3J0YW50IGlmIHdlIHdhbnQgdG8ganVzdGlmeSB0aGUg
YWJvdmUgZml4LiINCj4gDQo+ID4gSXQncyBhbHJlYWR5IGFwcGxpZWQsIGJ1dCBGZXJyeSBwcm9i
YWJseSBjYW4gcHJvdmlkZSBtb3JlIGluZm8gaWYgeW91IGRlc2NyaWJlDQo+ID4gc3RlcC1ieS1z
dGVwIGluc3RydWN0aW9ucy4gKEknbSBzdGlsbCB1bmFibGUgdG8gdGVzdCB0aGlzIHBhcnRpY3Vs
YXIgdHlwZSBvZg0KPiA+IGZlYXR1cmVzIHNpbmNlIHJlbW92ZSBhY2Nlc3MgaXMgYWx3YXlzIGlu
IGhvc3QgbW9kZS4pDQo+ID4gDQo+IEknZCBiZSBoYXBweSB0byB0ZXN0Lg0KDQpUaGFua3MhDQoN
CkRvZXMgdGhlIGZhaWx1cmUgb25seSBoYXBwZW4gdGhlIGZpcnN0IHRpbWUgaG9zdCBpcyBpbml0
aWFsaXplZD8gT3IgY2FuDQppdCByZWNvdmVyIGFmdGVyIHN3aXRjaGluZyB0byBkZXZpY2UgdGhl
biBiYWNrIHRvIGhvc3QgbW9kZT8NCg0KUHJvYmFibHkgdGhlIGZhaWx1cmUgaGFwcGVucyBpZiBz
b21lIHN0ZXAocykgaW4gZHdjM19jb3JlX2luaXQoKSBoYXNuJ3QNCmNvbXBsZXRlZC4NCg0KdHVz
YjEyMTAgaXMgYSBwaHkgZHJpdmVyIHJpZ2h0PyBUaGUgaXNzdWUgaXMgcHJvYmFibHkgYmVjYXVz
ZSB3ZSBkaWRuJ3QNCmluaXRpYWxpemUgdGhlIHBoeSB5ZXQuIFNvLCBJIHN1c3BlY3QgcGxhY2lu
ZyBkd2MzX2dldF9leHRjb24oKSBhZnRlcg0KaW5pdGlhbGl6aW5nIHRoZSBwaHkgd2lsbCBwcm9i
YWJseSBzb2x2ZSB0aGUgZGVwZW5kZW5jeSBwcm9ibGVtLg0KDQpZb3UgY2FuIHRyeSBzb21ldGhp
bmcgZm9yIHlvdXJzZWxmIG9yIEkgY2FuIHByb3ZpZGUgc29tZXRoaW5nIHRvIHRlc3QNCmxhdGVy
IGlmIHlvdSBkb24ndCBtaW5kIChtYXliZSBuZXh0IHdlZWsgaWYgaXQncyBvaykuDQoNClRoYW5r
cywNClRoaW5o
