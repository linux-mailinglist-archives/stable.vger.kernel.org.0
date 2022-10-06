Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B0A5F5E89
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 04:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJFCBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 22:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJFCBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 22:01:51 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4614137184;
        Wed,  5 Oct 2022 19:01:50 -0700 (PDT)
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
        by mx0b-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295HDsEq024228;
        Wed, 5 Oct 2022 19:00:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=yVSTsvFOjAqa3KkxCeiMAASP2pbpOIgagNuWtvPpH/k=;
 b=ncrndMBYxFZmfdg15991CZWwFRMwwkNHNKTBpc7xnGSgvGkiXjDdBAbD/dBa7TxwHqaA
 Ug6Uc3BhXND49yGvg47i605KWrQOSNXAmCc0VNjq9bi8fmBDKC76c4gOfJ02bxO1lNIe
 CKI2BlRQs7hirwSDwXJzTDMuVh/si4wAcsl5YFIumczdAVnPNf/UuxXzn7dPFAUv3BAo
 wogP/WwUqbF3j6kHxqwZv9rajvAV+tNMzXJ2256HM9+0f7WOpAwifS35o/th27P9FZoh
 Rbx7qzPZuBliFT37avV6CUg9g0H8Yh3AoaZ0bdkCKBo4WkEbELjTAjctIhsNYfPpZMjQ Vg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 3jxm6fnw1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 19:00:35 -0700
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C4BEF40083;
        Thu,  6 Oct 2022 02:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1665021634; bh=yVSTsvFOjAqa3KkxCeiMAASP2pbpOIgagNuWtvPpH/k=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=OZvcMbbm8Btw2U1scWV5kCS52fMCVNT1Ll0khII7FPUTjgHKzXVa70zT2xdTsuVfN
         lbeXgqJhET7VWkhGabdYeNZEDue7itgtjCLer9xdyHaVtid+A/mGxYE8eDGOkFvWKp
         doGRV0Y5fA3Coq/IoebqYsiUwZn/GA2jKQAu8ucDF8WekDCmkUoiQ+tuOm5WlHt/oM
         AiLzFpSSJ4lZhzZq4coQ+1Cu/RgsT9xyTUjA3s8YAgLB6B5S0f5o3kFHy0kcQtdFdn
         /bP6E2usbIk9kkWqNUCQTBqxPfpRN8k3QkXPJTfSrQYMfLw2gFZmpS3MGUNkDmc8kM
         1FoOmeNN3T3Qg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id EFC9DA0084;
        Thu,  6 Oct 2022 02:00:32 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 311AE80083;
        Thu,  6 Oct 2022 02:00:32 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="nqwxwQEy";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aqkrz13LC2mTSlztP40LDj6H3TUfOn7dg0eC51uXla6rR+i5nm+9se7n/ZGrPyc0PcBx4p1HUYHJxrJZv//UAvazN1OocIt8SPxk3OyLfPUOfAIWjcd9wMU9Hqex+ebDa03dxDUCII9yT7wb135VdfuWEFLWMUJno3o/sh5zHuyGjSUJxgDMNq6KYPVXKheaYCJpnm9Ieit0bC2Vholx2mObmkhhEjH4lGsCNKNyvPGSoAobCHIonSEERfN0UyddtODDbogNObUxEgyRuYWTmKB4nGYHFdMtpBIlecjutfFp9Y0292VEqKTX4GvP0/6fQG2VKMs9LOxTe8IkUnaV+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVSTsvFOjAqa3KkxCeiMAASP2pbpOIgagNuWtvPpH/k=;
 b=PWAsuGFUOq3wiCUWqIxb4yv/XlJA7pC+/k29XE0l+kYE4EVnHwrt10BhDLJ/SWRT5lTaF0ezRn1Vpok5qEmoiiQintnMoZYdEbZ3LqB0ydTBWQfhgFeVDarRiwnTpJQD213PV+dTND0i7yiswYGHfyfUG7vOVA8mJMmbH8Suxbsv/8+GBbkFb+Jwy5m8qy56ghzMJgWwmlXY0RexmLV1MI0tejZO1SqoT2L9Smkx6oZdB9b97i4WoMAo9dbmgjNmNo3sdCvstml0SMXxX9YnnawUflFKz8WPpn7nvkmV8SHkJevh0E813+FpOotem7uLknfceJEEBooPn6oXLob/qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVSTsvFOjAqa3KkxCeiMAASP2pbpOIgagNuWtvPpH/k=;
 b=nqwxwQEyvehACSeOLguHgJmzm97vTvRyoEc3KYDk+omNiZ/OW145Er4afTheDg5gq7Dxm455k7iaMQ4u46CV6+LAGmiK1RuxlzwT6ktHmKfGKBwQlHf5n3uqd+sskJqQ3RYrL+Ar+t48nakGmjTEVkxg+h1OSdYbKxc9+XvRmuw=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by DS0PR12MB6558.namprd12.prod.outlook.com (2603:10b6:8:d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Thu, 6 Oct
 2022 02:00:29 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Thu, 6 Oct 2022
 02:00:29 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Topic: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Index: AQHY0omsjm4tTlL0CEmkY916+rpAAK39QTUAgACwSgCAALRxgIAAdL8AgAAHjQCAAYdwAA==
Date:   Thu, 6 Oct 2022 02:00:29 +0000
Message-ID: <20221006020014.66tl3ba22dkdsavp@synopsys.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <CAHQ1cqG9-SDM4_zUfCvxP7XD-U+PPOWqWDBFKU73ecomDpt9Jw@mail.gmail.com>
In-Reply-To: <CAHQ1cqG9-SDM4_zUfCvxP7XD-U+PPOWqWDBFKU73ecomDpt9Jw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|DS0PR12MB6558:EE_
x-ms-office365-filtering-correlation-id: 1925f275-c4d1-4807-4726-08daa73e8b76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MzhY8/5VI7AP4JMfluCwe9va5v/CiVawuymY1Z/AqSYdfIxK2rEMl4z/8qNK/zlTK8UoSs3YsWVp6uDQSnxSSU5f9Q3qlMWsnrM9Tcfscyw7t2PEPnZWxQ3+1A3hnmjkI5Iy8GEfs4cRy6L5PWKQK/F+v0N/cAax+0jN6J1QNpiRyhIgIulBy0z31fJbnC54an3yzAnaC22gpsWgSWJVDS7NAqCG3QPL7JonxciDWD4IhKSAldyNyigs6+GUp+GuDtGUEiLY+J+xG5MF1JJfgUjE9z9+Q21uRUwgDjsjOvLVQGKOp4FHYfbuV87bUNdXiFKvUACTepgpYEZlT4rpQsoauPHAMFZHXMAgMxu41rf7v35TsKsRwDj9y6Lj7HDwmOck2T1NWCOH7ZqCmtTnk8ef4WDx+9ZvALwGpFf0AYt6B+Ui9444TJ4l6auqJ/keKmOozyMHfYREa6UG6hXfYRMG7N1dUrV/9MsSfUko4f/x+Zr3RPA3jZHa4qFNlemr41Fay0B3+yDzQlpj8nUclbYUf7ErWMb8akThwXDT2xTZsvNksCm6qfKPRjs4G9bmaT3If5ikCivKbLEuykB471HlQSiBpPGXankeNTUzkt1Qq7v7H/2OixaZYlhHNvEI+G6HeDDN5bdBvGO1jqa6k9vhDNB8FEgoCUsJV23ze3Cpaad27Ay1vTvPN8oWOKYcfDNuD19G3N6/fzu1Si2sdMkKVD4O4/Qlvhuc5fAVov1tQRWILNF5lAaOh3SksgFiOMJoTtZDoYt/S7+drs63/Fn0oDBL9QHDGLSsQqBAa+0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(53546011)(6506007)(478600001)(966005)(26005)(2616005)(6512007)(186003)(1076003)(8936002)(41300700001)(5660300002)(83380400001)(86362001)(38070700005)(71200400001)(6916009)(6486002)(66446008)(64756008)(66556008)(66476007)(66946007)(4326008)(76116006)(8676002)(54906003)(122000001)(36756003)(2906002)(38100700002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2dXTzJkUEUyTjlocCtOdyt5K2ZDLzg5MFNOSHZFbHZJQ2xpM0lZRG5yRGFM?=
 =?utf-8?B?Sjkxb0lVNVFXQ0tHU3ZhQVhsRUx3ZTNTK2ZidkZvQVc1ajQ3bytkR1NrNml2?=
 =?utf-8?B?SWZqWXAwYk5jOXZqSFN1dFFWeUxBbWdKcUJ6NWpJWXhaZ2xCVWJnL3FpWnVT?=
 =?utf-8?B?YTduWVNVYlBPdHFVazArM3kvU2xEWEFDczY1ajBadHUydWpsb1JiN0xHQVhs?=
 =?utf-8?B?Tkt4d0hNZWRJUFFkb1IzVzZNMmhRRmFkTDN4MURsbmlJcVZGRk5wemM5clhM?=
 =?utf-8?B?bG1TSzJ2OWoyNm9ZcjVrM2NmektyTmxVSEFEU0IzczlkSklxRGN2eXpxNTJM?=
 =?utf-8?B?cFhHY3NYNHdFUG9xTkxQSG1uUVYyWW81bEpJdzRyS0Z6ZUlvL3I0UHhoNU42?=
 =?utf-8?B?ZE5zUnF2czlsZFNQL2hwU1FacitFZUZzcnV5cklwWFYwUzM1cG9sOUh0QU53?=
 =?utf-8?B?enFLMk5DemFpT3hRdXdIaGhyK096dXhMTWYxOUFXLzZnZ3hZVXN4VHlGUTV6?=
 =?utf-8?B?WnFjZEhMVkd2YkhOcXhPaXZ2dXFyQjhuRDZpeUZnS3BSQUlBVUcwSUhBdm9z?=
 =?utf-8?B?YXM4LzNSdUdkZDVzM1lqeDU3aUs4ZHhGWFY3Vk1iRTBWcHZVRFJXbmtaQU1W?=
 =?utf-8?B?SmhFRGJOZmVqQWYyekZkMmltbDRSY2hNS3g3OUIwTEJkOEdORHlUVlhQVjZ2?=
 =?utf-8?B?bFYxTzhLSVhodXRnV01oOVkvTG9GQUJaSlRHYkt3TWkvblhZazEwc0h4R0tV?=
 =?utf-8?B?RGJ5aDVpd3VJeWpKYXBhcm9aL0dPdXZKYmV6MHVIcTJlYWdJRGNyU1dGTmhM?=
 =?utf-8?B?cEM2Y1dQbVF2SDc0RjFpYmFCQzhsSDBRLzdPZFRIOWJjU3gzUnYrdVNnZ3ZV?=
 =?utf-8?B?UHdZRjRQdW5vQk4vLzNCR2RmUFFqRk9zWFQxbWFESTkxdG56dTVwdFBNRWtK?=
 =?utf-8?B?VHpCcUVtS0I1YlBMR01ZbTNoUU01UVFsT1NOK053MWl5WVJNQ0doUkE4dVR2?=
 =?utf-8?B?Y1hyOUhPSlpGbHFwWnEzNUlSU1cxRlRxdENZK2ZmT1VJYW1lQ29yc0FBR3ox?=
 =?utf-8?B?Tmd5U0J1L09pN1QvNitaa0JHQTBjcXRESG9iTW9sTDN6SGU5cmxTSnlMQU1s?=
 =?utf-8?B?QVhKQkNBcmJNTWdLUkR5SGJMa2xnTU5yK2NyVXZBYlRReHhFWG1ndEZtbFNV?=
 =?utf-8?B?Y1M0ckhhQ0ZHNTJEV3NXdFE5TXR0K0c5MER0SituTHRrYWhsYTFqOVgrODRO?=
 =?utf-8?B?R2IvMDgwZ0JlQVNFRmtzV2pPbktYazN2VjNubnp2N3pwN1lGRExDdXNqMjZQ?=
 =?utf-8?B?WWJ4YjlWN1FzbEhyciszQkVSdmU2eDkyRW5GZXFySGpJbDNJZ3hldFI3RFlJ?=
 =?utf-8?B?a1ZWRFZENDV2UVkrRVJGOS9zeWlVK0ZrS0dnTmJOQUdXUlZ3MnBieStucGdR?=
 =?utf-8?B?clRsS004Ui8vR2RHYnV5Y0IwQ3BJSG5EdTB0NzNzTVBDY3ZJenFJd3o4cUxu?=
 =?utf-8?B?STBNTWp6cldDVXdBM3JHWlNZVGRqN0l6ZE5JV2g5TVJZSWtpc1pWN1V6MGt0?=
 =?utf-8?B?ZXF2ZVpYOVAyVlBLejJqRWxSbFF5Yi9wc2N6K1h4STF2a2JWSWE3L1B0VHpJ?=
 =?utf-8?B?VWhFUVBabm9QTHo3emgvcFZNWTFaeHQvQlpvSXJpbXRyQjNCQWNvMi9GWER4?=
 =?utf-8?B?NEdwMjVsS3hLU3lJbVpGclB1ek1JS0Fac2h1K200KzNvQzlXazRNbE8rSW1P?=
 =?utf-8?B?Qi8zS0dldXhDZlNSc1d3aGFNZjlxMzBvblNwN3JkOXAyWUdkc3BMejNIT0pW?=
 =?utf-8?B?NVRjRXY2M1cxT1ZrU2trY1hmdUpTOGErZDZwTEhod2U3aHFJWUUvZjV4K3dN?=
 =?utf-8?B?c0xKL0ZjcE1HOGZGU3R5Zm1CdXlQblpEMnM5ZG5pUWd3bFh2V0pZcUVSKzJq?=
 =?utf-8?B?Y1dteHg4aUNVdURUaGg0WGNqVVhEb2hFR0d6ak5zTldoYkZTVzF2Vkw3SmdS?=
 =?utf-8?B?Z1o1d0VDTUhBWW40QzAzdzJBTDZGdHNZVjJuNHBtK01hV0owM3ZWZ24zM0lK?=
 =?utf-8?B?UlVOZGRiZzQ4cnVYWjZoaWpxUEVWYTF4SURSU3JxOXd0TENSRjVMbTA1N3A2?=
 =?utf-8?Q?BKZeo8PO9zHkBI2MBb3oXikWw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38569248CBD3E34B9389FCC4DBACB551@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?eWhUNFZkSzcyOUR6OVdmZUVLZi9CdHluNHpERE1tRUNoNTJQOGMvaHV1akwz?=
 =?utf-8?B?ZDNpLzdIQThmeHErUVZ3bWhSd00yS0c0UDZWendLUVhhcndyTXlpQWlGdFls?=
 =?utf-8?B?anB0SkFlYnhZV0VtM25sYk04bjJtTnlLaWt4WUtTMHAwQmg5MHhoRkNQZTk2?=
 =?utf-8?B?T0JHUVk5NjZKVnpVMkphTkgyQ0NhSEJVbEVhNThNLys5MVo5ZHZZUGxKdGhM?=
 =?utf-8?B?dUJKWHNqT0tGUTZTdXBGT0xmbjhxWC9ScHNUMmwyakhwd0xjV05PUzY5Um8x?=
 =?utf-8?B?TVdoZTVYTlpzWU5HUzMxRmpDNzcxZDJHVWllTmZHSHlpNGNRNUg5YStJQmJr?=
 =?utf-8?B?VE5oZkZhOGxwZzFLMkF1QlhXNkNma3p3SDJPVlV4Y2YvY0xGdFY3dmlRMEJE?=
 =?utf-8?B?WFd5NWh4Vi9Eb3RKWGRSTnBaYjlyRkRQMHVZS20zMUNXc0R2dzJNNXBkRW15?=
 =?utf-8?B?cVZtR1NvT0xoN1JnbW93My9SNXRodlRvZncxT3hhOFBYZFRRdWhBMWVTdE51?=
 =?utf-8?B?Y2pjbVY4eDlmbHh1b0FMRUtwbDV3VXE4N040cUMzNG1vMk51ei9QMVJxenRy?=
 =?utf-8?B?Z1RwK1oyK2hFWGduaEVwZ3dJYlRjTWNEa1ljakVIbHVTaTJwSStmYXhPRXhB?=
 =?utf-8?B?YzE1ejFUVkVCS0paWDhLR3gwR3RRMzFuKzRhWHdhQVRCU2xqMGVrcmMxMVRY?=
 =?utf-8?B?U2RucllHSzVNdDFWT0taaW5nWndyOE5pZTV3QlptTVRCbk8zYy9nMzJzT3RK?=
 =?utf-8?B?YTVPdHd0ZXpIRDhmSmZ1RnNMUWpPRUxvVkNQb2p0WGsvaTVyclU0eHF4VlBi?=
 =?utf-8?B?dXVZMjRYQjg0RVdjaWRKL3VxSzdTWmdoNGJhM2lOcjhZcmhsWTc0dlFNNkhE?=
 =?utf-8?B?UFplSEsxTE5zalM1cGFwWk12ZXRaTWkzWUhXdExidDZqc1grbkhTci9mREJx?=
 =?utf-8?B?TFRQZ1pFV01zOFVRTndva2ZyVWRnem1tTGVRVm9OU1ZkUkVUM3B5S3krRWUx?=
 =?utf-8?B?a1VYSThWNVkyVVN0aFdTZUlVejA4T3I3RGNoOE5BTGJpZnZBVDhNUkpRZG9a?=
 =?utf-8?B?MzlOdEhIMjFteS9zVXZicC9PZWtlcUFFL2h5VHdGd0VGSHYxTGpHaGMvTUhy?=
 =?utf-8?B?d25ycjRJdjdWUGdpbDlyYzJEM3c4S2lNdE04L0JFN1FEZGlpbytkSjJFUXRh?=
 =?utf-8?B?RUV0YnRvcWxMWXo5Z01tekF6eHpDY0RiTU9lSFJMd1AxNmgyQ3BSeStSa0E3?=
 =?utf-8?B?UDFUZHB5cFBROGQrb2VCSGt6YWd5dVpVSkZ3Y3FZbGVrWDVNYnI0MlQwZys3?=
 =?utf-8?B?cFhycWdkWGtsLzJZbTh5cExBampQeDZ0Uk9kL0s4U3VYMGJaRTNuTTJKY1Ew?=
 =?utf-8?B?Z2RtY1V5QTQ2aUFFa0lDeHdKNGpPSzRPZTJoRk9SLzFBdXJ5bnFGbWdnNGZB?=
 =?utf-8?Q?P3AXvEAk?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1925f275-c4d1-4807-4726-08daa73e8b76
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 02:00:29.5785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XHYGO4kbU8qHCReK8xUQ9p56jPDzlrpadUIlzE7MPuqHJpb9tQ6LUwEMGMQuiKVspMczdmsmYPVbSQBoyUH8iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6558
X-Proofpoint-ORIG-GUID: PUw0HJEcHrxKZE5NGat7n2RBmBvJK0Fl
X-Proofpoint-GUID: PUw0HJEcHrxKZE5NGat7n2RBmBvJK0Fl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 mlxscore=0 mlxlogscore=981 malwarescore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210060011
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBPY3QgMDQsIDIwMjIsIEFuZHJleSBTbWlybm92IHdyb3RlOg0KPiBPbiBUdWUsIE9j
dCA0LCAyMDIyIGF0IDc6MTIgUE0gVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMu
Y29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIFR1ZSwgT2N0IDA0LCAyMDIyLCBGZXJyeSBUb3RoIHdy
b3RlOg0KPiA+ID4gSGkNCj4gPiA+DQo+ID4gPiBPcCAwNC0xMC0yMDIyIG9tIDEwOjI4IHNjaHJl
ZWYgQW5keSBTaGV2Y2hlbmtvOg0KPiA+ID4gPiBPbiBNb24sIE9jdCAwMywgMjAyMiBhdCAwOTo1
NzozNVBNICswMDAwLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+ID4gPiA+ID4gT24gVHVlLCBTZXAg
MjcsIDIwMjIsIEFuZHkgU2hldmNoZW5rbyB3cm90ZToNCj4gPiA+ID4gPiA+IFRoaXMgcmV2ZXJ0
cyBjb21taXQgMGYwMTAxNzE5MTM4NGUzOTYyZmEzMTUyMGE5ZmQ5ODQ2YzNkMzUyZi4NCj4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4gPiBBcyBwb2ludGVkIG91dCBieSBGZXJyeSB0aGlzIGJyZWFrcyBE
dWFsIFJvbGUgc3VwcG9ydCBvbg0KPiA+ID4gPiA+ID4gSW50ZWwgTWVycmlmaWVsZCBwbGF0Zm9y
bXMuDQo+ID4gPiA+ID4gQ2FuIHlvdSBwcm92aWRlIG1vcmUgaW5mbyB0aGFuIHRoaXMgKGFueSBk
ZWJ1ZyBpbmZvL2Rlc2NyaXB0aW9uKT8gSXQNCj4gPiA+ID4gPiB3aWxsIGJlIGRpZmZpY3VsdCB0
byBjb21lIGJhY2sgdG8gZml4IHdpdGgganVzdCB0aGlzIHRvIGdvIG9uLiBUaGUNCj4gPiA+ID4g
PiByZXZlcnRlZCBwYXRjaCB3YXMgbmVlZGVkIHRvIGZpeCBhIGRpZmZlcmVudCBpc3N1ZS4NCj4g
PiA+DQo+ID4gPiBPbiBNZXJyaWZpZWxkIHdlIGhhdmUgYSBzd2l0Y2ggd2l0aCBleHRjb24gZHJp
dmVyIHRvIHN3aXRjaCBiZXR3ZWVuIGhvc3QgYW5kDQo+ID4gPiBkZXZpY2UgbW9kZS4gTm93IHdp
dGggY29tbWl0IDBmMDEwMTcsIGRldmljZSBtb2RlIHdvcmtzLiBJbiBob3N0IG1vZGUgdGhlDQo+
ID4gPiByb290IGh1YiBhcHBlYXJzLCBidXQgbm8gZGV2aWNlcyBhcHBlYXIuIEluIHRoZSBsb2dz
IHRoZXJlIGFyZSBubyBtZXNzYWdlcw0KPiA+ID4gZnJvbSB0dXNiMTIxMCwgYnV0IHRoZXJlIHNo
b3VsZCBiZSBiZWNhdXNlIGxhdGVseSB0aGVyZSBub3JtYWxseSBhcmUNCj4gPiA+IChoYXJtbGVz
cykgZXJyb3IgbWVzc2FnZXMuIE5vdGhpbmcgaW4gdGhlIGxvZ3MgcG9pbnQgaW4gdGhlIGRpcmVj
dGlvbiBvZg0KPiA+ID4gdHVzYjEyMTAgbm90IGJlaW5nIHByb2JlZC4NCj4gPiA+DQo+ID4gPiBU
aGUgZGlzY3Vzc2lvbiBpcyBoZXJlOiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6
Ly9sa21sLm9yZy9sa21sLzIwMjIvOS8yNC8yMzdfXzshIUE0RjJSOUdfcGchYXZmRGppR3dpOHh1
MGdySFlyUVFUWkVFVW5tYUt1ODJ4eGR0eTBabHR4eVU4QmtvRkQ2QU1xNGEtN1NUWWlLeE5RcGRZ
WGdQMVFHX0laYnJvRU0kDQo+ID4gPg0KPiA+ID4gSSB0cmllZCBtb3Zpbmcgc29tZSBjb2RlIGFz
IHN1Z2dlc3RlZCB3aXRob3V0IHJlc3VsdDogaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0
dHBzOi8vbGttbC5vcmcvbGttbC8yMDIyLzkvMjQvNDM0X187ISFBNEYyUjlHX3BnIWF2ZkRqaUd3
aTh4dTBnckhZclFRVFpFRVVubWFLdTgyeHhkdHkwWmx0eHlVOEJrb0ZENkFNcTRhLTdTVFlpS3hO
UXBkWVhnUDFRR19ib2FLOFF3JA0KPiA+ID4NCj4gPiA+IEFuZCB3aXRoIHN1Y2Nlc3M6IGh0dHBz
Oi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2xrbWwub3JnL2xrbWwvMjAyMi85LzI1LzI4
NV9fOyEhQTRGMlI5R19wZyFhdmZEamlHd2k4eHUwZ3JIWXJRUVRaRUVVbm1hS3U4Mnh4ZHR5MFps
dHh5VThCa29GRDZBTXE0YS03U1RZaUt4TlFwZFlYZ1AxUUdfTWJiYlpJSSQNCj4gPiA+DQo+ID4g
PiBTbywgYXMgQW5kcmV5IFNtaXJub3Ygd3JpdGVzICJJIHRoaW5rIHdlJ2Qgd2FudCB0byBmaWd1
cmUgb3V0IHdoeSB0aGUNCj4gPiA+IG9yZGVyaW5nIGlzIGltcG9ydGFudCBpZiB3ZSB3YW50IHRv
IGp1c3RpZnkgdGhlIGFib3ZlIGZpeC4iDQo+ID4gPg0KPiA+ID4gPiBJdCdzIGFscmVhZHkgYXBw
bGllZCwgYnV0IEZlcnJ5IHByb2JhYmx5IGNhbiBwcm92aWRlIG1vcmUgaW5mbyBpZiB5b3UgZGVz
Y3JpYmUNCj4gPiA+ID4gc3RlcC1ieS1zdGVwIGluc3RydWN0aW9ucy4gKEknbSBzdGlsbCB1bmFi
bGUgdG8gdGVzdCB0aGlzIHBhcnRpY3VsYXIgdHlwZSBvZg0KPiA+ID4gPiBmZWF0dXJlcyBzaW5j
ZSByZW1vdmUgYWNjZXNzIGlzIGFsd2F5cyBpbiBob3N0IG1vZGUuKQ0KPiA+ID4gPg0KPiA+ID4g
SSdkIGJlIGhhcHB5IHRvIHRlc3QuDQo+ID4NCj4gPiBUaGFua3MhDQo+ID4NCj4gPiBEb2VzIHRo
ZSBmYWlsdXJlIG9ubHkgaGFwcGVuIHRoZSBmaXJzdCB0aW1lIGhvc3QgaXMgaW5pdGlhbGl6ZWQ/
IE9yIGNhbg0KPiA+IGl0IHJlY292ZXIgYWZ0ZXIgc3dpdGNoaW5nIHRvIGRldmljZSB0aGVuIGJh
Y2sgdG8gaG9zdCBtb2RlPw0KPiA+DQo+ID4gUHJvYmFibHkgdGhlIGZhaWx1cmUgaGFwcGVucyBp
ZiBzb21lIHN0ZXAocykgaW4gZHdjM19jb3JlX2luaXQoKSBoYXNuJ3QNCj4gPiBjb21wbGV0ZWQu
DQo+ID4NCj4gPiB0dXNiMTIxMCBpcyBhIHBoeSBkcml2ZXIgcmlnaHQ/IFRoZSBpc3N1ZSBpcyBw
cm9iYWJseSBiZWNhdXNlIHdlIGRpZG4ndA0KPiA+IGluaXRpYWxpemUgdGhlIHBoeSB5ZXQuIFNv
LCBJIHN1c3BlY3QgcGxhY2luZyBkd2MzX2dldF9leHRjb24oKSBhZnRlcg0KPiA+IGluaXRpYWxp
emluZyB0aGUgcGh5IHdpbGwgcHJvYmFibHkgc29sdmUgdGhlIGRlcGVuZGVuY3kgcHJvYmxlbS4N
Cj4gPg0KPiA+IFlvdSBjYW4gdHJ5IHNvbWV0aGluZyBmb3IgeW91cnNlbGYgb3IgSSBjYW4gcHJv
dmlkZSBzb21ldGhpbmcgdG8gdGVzdA0KPiA+IGxhdGVyIGlmIHlvdSBkb24ndCBtaW5kIChtYXli
ZSBuZXh0IHdlZWsgaWYgaXQncyBvaykuDQo+IA0KPiBGV0lXLCBJIGp1c3QgZ290IHRoZSBzYW1l
IEhXIEZlcnJ5IGhhcyBsYXN0IHdlZWsgYW5kIGFtIHBsYW5uaW5nIHRvDQo+IHdvcmsgb24gdGhp
cyBvdmVyIHRoZSB3ZWVrZW5kLg0KDQpUaGF0J2QgYmUgZ3JlYXQuIFRoYW5rcyENCg0KVGhpbmg=
