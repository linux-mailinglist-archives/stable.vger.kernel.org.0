Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C762EBB7
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 03:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiKRCLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 21:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiKRCLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 21:11:48 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C1585EC1;
        Thu, 17 Nov 2022 18:11:48 -0800 (PST)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI1jmtD016754;
        Thu, 17 Nov 2022 18:11:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=2TLyU7xmlNDLFt1iukYMaEX/oLq0hFMdYcccx183WdU=;
 b=uuOAgWuxxtCvj4/OiVIatuDTmfdGbM0ZfWg3HIQp4B/CteSepzbiK4Di7lG2LSmPF6/l
 7AXY6nBehLHCfETmkrj8DKylkD07EzPGDC0El9wnHWLbtqOBduZaHhjoLvPqXzRKNc30
 TRcAEyWXkN6Mka3syQWQlmGjWF+9ABCB1xz148aVKyqn5oDiU0SlOyJWtuHC/cta7iGB
 7e7xqdZQo+Kf+4xYKWibccDKSBsK40xtQnZhjKej3c8i/66EtdWRibLpmLbSM+lzw0Q9
 yx023dUaCDEdqckIy0YBywmL03FZkNkG2oqqLxc3+680BZEjU+IArqM7RhjsIfg5wOsU BA== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kx0p202ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 18:11:27 -0800
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EA114C07FD;
        Fri, 18 Nov 2022 02:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1668737486; bh=2TLyU7xmlNDLFt1iukYMaEX/oLq0hFMdYcccx183WdU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=JDcy5nRt8FUS/9P79i2JrdIaw8FhIuF8oE8BWFucvCXAAd2RRMQSiYrJc+aq1F+s2
         13QQ+i70TtyV5k3CPfzSMJuHsztskw3X+OHUY/WLGYQLYj3w875K8Nvws5yukzNyUY
         nF/iIasJWHH9NSk5vfy6/09lrldGy3wMS3rqwV7lowT8/UA+hoxBKI0lfDe+0s+vt/
         p32+hhh059atK2lcp42ywzP3Q46EtCmBDR+tc8d0KuS9a4Y7L1hOZs/uiYRVZYTymV
         b4cVxHJsD/kJf+6p+BaLIKeJs/9JkR6kjXSD9x61F/7UMayV6I4HLetxaW5r9+mGq0
         CE1RTeBboPbfw==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 67C75A0267;
        Fri, 18 Nov 2022 02:11:23 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 62C4A802B0;
        Fri, 18 Nov 2022 02:11:21 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="sNNiKaHX";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrgRIvEf2q4pMAhqVK9yEODwgvsjc8vwacE50Q8+APGzO/5b9TdGf77KvX9ILmQTtE9wEDohuqeA4ICBvzX/84aPw5IS3tIXNYAQqdKMXLqpN215GTY3vyFaAyQDeP+b2BJf9NbygtfMfofTzepc8iE6YMk9ALe1PQpgr4lQaOH/XGPWGs+OgKdTVbEBDFv4HmeK52Sw7EIE6PpdRNmWImbHXDZDbgixaCB+7ugFOZo4+KMolR2v+gxtPrTtVr0+fxeZ2Gs1UDDDqP9Mq4+lTtebZJoCC6+9ZRZpChRL212xFgG3KWqnJGEv1nxavs9G5P/hXue+/SK1MQunxY3x5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TLyU7xmlNDLFt1iukYMaEX/oLq0hFMdYcccx183WdU=;
 b=iuVQ2U6MSJ9oKa59LXLrO4fDa5kOfVD2P8TCp27S3aR770zmsGb6oS7x+QfeQD/b+oEHyezR24rXKF/C3RQlgjioQE2DPsC3UTdww5z0tGFX+a/NYZSGuqJMNNjE2lZAJdDCVBqnXosqXkBLxz4W7q/+hWX+ecgHELJODawulygo87twvFFbR6fkixMaK8+uAgd19dCVgReT/yYuMTCqea5d5JN4v8EHrjv90dxVmQd0qLCIDICYvEYJkjq7jbs+PRIS3Wc4cUai80Ev69IdSFnpxbLUOfbH4YE84rIYqgI1UVWmWC2/RC9jvHUff0Tmt+pzDBcbwilk+xsSH+2CrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TLyU7xmlNDLFt1iukYMaEX/oLq0hFMdYcccx183WdU=;
 b=sNNiKaHXzE2oQWg6LhbtHAMQ2WAostEiehv2deMsXz0JMtLgHswzGLXjxUxB0D+/cC/hS8qSqp1KT2GmguHqE6vn0zy3uim79J/oudeCuJH0TgJAHhajurt2Db2MZCEa44r1oe02z2TnUqPulNP1gHAaR72OkrQqxpRI4Hx51Nc=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH7PR12MB7257.namprd12.prod.outlook.com (2603:10b6:510:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Fri, 18 Nov
 2022 02:11:19 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::9f62:5df9:ad93:5a1f]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::9f62:5df9:ad93:5a1f%2]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 02:11:19 +0000
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
Subject: Re: [PATCH v3 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Thread-Topic: [PATCH v3 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Thread-Index: AQHY+sbTaif1syI3uUCmhS3xW6I+8K5D8HuA
Date:   Fri, 18 Nov 2022 02:11:19 +0000
Message-ID: <20221118021107.3uhixtck6sawluoy@synopsys.com>
References: <20221117205411.11489-1-ftoth@exalondelft.nl>
 <20221117205411.11489-3-ftoth@exalondelft.nl>
In-Reply-To: <20221117205411.11489-3-ftoth@exalondelft.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH7PR12MB7257:EE_
x-ms-office365-filtering-correlation-id: 84e971ca-461e-4e78-2f99-08dac90a2e68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZogrTXc+AnAuk7ykj34Pl9yPxxKkyjTrUfJRTLNOG5Myw0c5q1N6+/1d/+McEM5l8mgXYH4ocFEo4ndxhu/MQJSr1tHHrYfx6dXjip7X7OQw5g6o+O5usSMzynSL5mrOTyS3Vf1/QvG+PQHoyEkWZ8dPsyjnsQjiN+AtPwjq6SYP6E5zolqNfiQGhGFq7mAMcSCjMpG8SojHXvwuie6TUKOwJwvXC1IGQXa0Av/NsXRPmNaMzhQS9X5sucr1grUZdgPCbz6TdaPxJNx0CGzF2T1fRKMxYvcNKGFmsuWaqgcWT9E8zM/55FrRLCh7JbtIe5rVy0fle/VehA2rDQIG8EIx93gORDWbzL17R1bFueKeaiAlAD6l+r5Mrb/0tJPG3x8GeWirNsxs+Ho/gH1CPgYEI3xfGOIojR23pJn4Xsty6mrRdu9/w1yZpiwRVEkpROjTOv5U6PtSJVYc8NcPWR9VK9xlH/gpBIIyV6X6s39Dunizcso9tML8vrzRzYeywOb2bjjaSF+ZqcgqNTXR8JnlykYw6jgZe4a9OkKkfal154V+szrEj0iKPlZXPKLyhfRkTLLw4zSSSbUU2DJYxDykjLtPoQbtq0/EB7EWqtZmL2yytXaUik0zYwGxHRqH3CgtWfMDyPxKmmoqukN+a/jD5vcyppe5v++CyIlHfpJxC7yMbaMdgT0Pnu0hHTd8/ccAPQM2o/Nzc5OHaxYcZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199015)(8936002)(7416002)(2906002)(5660300002)(41300700001)(8676002)(6916009)(76116006)(4326008)(186003)(66556008)(66946007)(478600001)(36756003)(66476007)(66446008)(6486002)(71200400001)(316002)(86362001)(26005)(6506007)(2616005)(6512007)(54906003)(1076003)(38070700005)(83380400001)(122000001)(38100700002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3JkNHVXSzJkcmdsZmJLWjlSRDNSaHZHY2t4bkN4Vll3cklldE1nTDNaWkFY?=
 =?utf-8?B?MWJnV3VVYkRZaG5Ya0ZMT0Z2MFJhUDVvMTRLWm5xKzNPK05KSnE0L1FZMWla?=
 =?utf-8?B?OWpOakJlN0d2UEVxbXh4eXRZN1NBTXBJT2toL1Z5YlI4UTdwazd3ZnNObC9T?=
 =?utf-8?B?d1Y2cDgxdFRlRVNkMUQrMlVmTysyb1Z3ZWxPNWcwNWdCZ05Ma3hLNkhUM2hh?=
 =?utf-8?B?UktDQ0pDUzliMmpyOXlPWVBDVHk2SnpVMmg2TUIzSFV1WjY1ZURyU1QxTFZ0?=
 =?utf-8?B?SkVMUDZTQ3BYdmVWN2F5eTlyWVdmdzRFTTlzVVVBak5MN3E3am9uUUxuUjd4?=
 =?utf-8?B?OHhKN21kc0pTUDJob2QzWXJZREVmT0grTi9vWUhTbVBjVlpZbWRpZ1p5SWEv?=
 =?utf-8?B?S2FXYUQ4NjNBMGJPMTBZWWl0ZEU0eDRFOEYvSTQyZzVaUjBNVlZsdG93ZFda?=
 =?utf-8?B?aEdHUk5DNG4wMDdrRnBNUDJCMTZuMVZ5b0gwK3FvR21kK1hoSFpIclUvR3Rk?=
 =?utf-8?B?VS8zSjYvQUN0Mk9uN1l5ZmY0UXFrWFgzcktabW4vTHJ6TWV5QTl4cTIrZ0xV?=
 =?utf-8?B?UmE2UDVBVW5sZDdTbFhweXlxRDdIVmMxcEc2RHJtSVZuMzdJRENxWDc4S3B3?=
 =?utf-8?B?TjY4aGVNMWRDRmJGQ1JSb1NyV0VoZUJxNTVCRVJZL1lIdVBkNHA2K3JMcVpq?=
 =?utf-8?B?L1ZlSTF6RU8veXptVTNMcTJaZkFzRzZZM2RtN1ZIRXlFVHA0UnNjRmRwNGUr?=
 =?utf-8?B?M002bHlOcGZmcHhqVTNUQUJXMGdzeXB1QUFxRDdVVkg0anpsS0pTb2lXbEs4?=
 =?utf-8?B?Z2QwNXhJRFc5c0x0NkdtbUpmRm9xQXBUM01ZeXJ1QUpxQldMcW1EdFhFaEp4?=
 =?utf-8?B?ekdBMzNreE9lQ3lVTE15b3lxMmxndkljM2FGTzZvN3Q4QnI1VE1CMGUzdHdk?=
 =?utf-8?B?YXhZMnFmYnZ3b2g0cUdNOGV4NFFHb0VLaDluVm5oOHB6aDZJc01MalFQL2No?=
 =?utf-8?B?Q1FKRkx6cEh3Y05iamVibTRvdzVLQU11cm1DMFBkU1NSM3ZKSlR1c1Y3QXBS?=
 =?utf-8?B?ZDVZVDArSVF1aENSVFUzeFR4QXpTZ0RXb3pZQXJtNmYvN25xT0NXcGdxY0ll?=
 =?utf-8?B?dmExNi9uaTV0ZWFCZzlxekNNR2FOYis2dWJHck5CWFBWMzBkRWU5U01XVXpF?=
 =?utf-8?B?MktrWTdSd21ZMGwrN1IveGpMSHVCeHBva2FLUExaM1h3ZWRNRTRTb1J6eG0v?=
 =?utf-8?B?Y2RaNThjNHRtSGZFbnVuSWZSOXZQV3oxSk5sK0dOWEFxcHdVeXJZcXpCMDlF?=
 =?utf-8?B?VEtFdVN1Z3dRaEhSUERJL0YzQjc2OHd0RHhEb0NwVS9uTWw1Z0NEOEdkRlcv?=
 =?utf-8?B?MXY2QitFK054NTFiUE92RWlaRlkrTGdvMHRYenFKSGU4SGxnbW13RjBLbVRH?=
 =?utf-8?B?dzFoNGhOMG9VSzEwcFFzNVU1a0tITGNSMVFKbnhIY29VYUI4cERGOEs2dTQ1?=
 =?utf-8?B?RzNJSDdaWTYwRG5oa2dJaGIzTjVGYXhrUVlFZ0xJcDhHcnovejNoeC9vODlI?=
 =?utf-8?B?K3FpbEV4amJYaHhRbHgvckdybzVzUHErc0JreEJQT2dUVWNYdmlCdStoUno0?=
 =?utf-8?B?b2JOVHdWUWcxVDV6Y25XdURHZzZsQWltbjdqRUlmaGE3dUdVVkNOQ3BiNUJ4?=
 =?utf-8?B?cXMwVVRoYW1DYUhwUElzdEhEYUdjRytOSGF3ZkdtT1hXOVllNll0cFZ6aUJK?=
 =?utf-8?B?TXNUdGZsTkcveWZpS2p4dy9Ra0tRb290cGtSMUtoeW9ZU3loQ1JSOHdRaWZB?=
 =?utf-8?B?QkVBQ1RDbkRRcm5ERVdEaEhUQkNTNGNIUUN1T1l3bllCSmpZK3djc0hYQmVz?=
 =?utf-8?B?Snh5TEN0NHVQMFI4RFYxYUd2eGVyUDFRTGdGeC9qT1hHY000RkhvUHBNaWxq?=
 =?utf-8?B?eFNEMkowd0pLNVNpd2VDeklieVN6NXZUVFZVTE83d3A3cGk4OEI3SVNsdm5Q?=
 =?utf-8?B?aE05K0NaSktpamQ0YzVDN1BVSG5ORFc3QmRqN1V1REdNODBkRmpXRlp6cDRm?=
 =?utf-8?B?MnBNdW14cCt5UWREOElFNW01NWppVTM3VkpkYmw1K1VhZ2FYVWpSWTRxWGxl?=
 =?utf-8?Q?sBMWU8YPqM5KWXG6H9YTPa05e?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90D42B817AC9BE46AF6C3241B4635CEB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SjJ4aUVhYVU1U21MamZqM1A5cWNnRDVScWVZa2E2VXBjMzJMRHZGYXlLd3JO?=
 =?utf-8?B?MUFMc0x4OUtoOEV2Rno2Q0VFREEzR3NxTmhVQTlOb1R1QW8rMk4wd3lLSGpk?=
 =?utf-8?B?V0NDeDNpODNmUEdIWVNiODQyZGNaNll4bDhtZ2dRWmdDTms0S3FHQk9LTFVE?=
 =?utf-8?B?U0RkTThKc3ZLcU95ODNyZXBGZjByTjltbE9ld3E4Ykk3ZE5WRHNaeUh6VzZH?=
 =?utf-8?B?SjRtTzhVd2FDaUdETkFRa1ZYZDNIblhsbGtRMFhObkZMV1MzdnFXdzNFa0dN?=
 =?utf-8?B?MU1CM0gvd2RraHJ2VXJsNzJlV0JnTmo1TytCOFFqUVNEWDBiNWY0cmIraUNW?=
 =?utf-8?B?Nkx4d0NYbGlIc052MEdmbDY1YnMvcGhSdGhMSXJuV1VqYlJ1UWtuYUV0dGx5?=
 =?utf-8?B?RGRNL05GKzNFVm91Vjg0WUJqZHpHdjhTcy94eTl0WFR3SXZuSFpkTEpJSzdi?=
 =?utf-8?B?U2llZ0lVNEN6NWNvcnQ1Tjc1L2J6U25pamM2a0NacnlOUkl1TC9Wd1UvTElJ?=
 =?utf-8?B?dGtZWmRxckVtNWUveldyT09IUklrc3NaVEUwU3IvbjY4bVhTWWVsdHhQTTQz?=
 =?utf-8?B?bnAvNXk4dFFidG1nYURuQlUzTDRMNVM1N1oyL0tDWlJqempyZVI1SGlxSjlQ?=
 =?utf-8?B?TG1zdGdKcXlNa3hibm90RklxNUhjOGtmU0ZQWGJCVU94K3VIL3AxZTZUbU9q?=
 =?utf-8?B?M0JRdFE5OXRJcTJVRlNxd1kxdWVoWWVJS2tsOWoyMHVoZHdLaDg4RkNFUHNt?=
 =?utf-8?B?cWFxUHZuYjlxZGMxaUk3YjBIRmlOOS9yU2JCd2pOSHdZMFg3VGo1alhzSVM1?=
 =?utf-8?B?R25YUzRXelVJZWNaZUVOM0VyVkJJcTYwM2RwOXZkZWVZa1ZZVWFqZ05WZDJt?=
 =?utf-8?B?OVFXT2U4bzdMT3hXSDRiR3d4LzFjV1FWRWtKQ1hyTUEwMkd3cERsbUVsWmRQ?=
 =?utf-8?B?bXdhKzM5dFlSNHQ3M3cyWnNkWkgxTldwN3dUVllOR2pqR3E0OHVqelNUNkFy?=
 =?utf-8?B?S2V3MTNJNHROaU82OGxyRVFQNStHS3BTWmh2RGJhbDk0ZUx3Y1FyNXczc0Vx?=
 =?utf-8?B?Mzh1VGZhcUFiaGUxRXVmeHNkVklkWDFFbVpQM3ZCQUpIelJSdzNOSnRvVFQz?=
 =?utf-8?B?clh3NnBHNE5jWEJwMUpvWkp1NW0zbWdyZkNVYkM5Q1lpNVFQMnJzbmhLTVlV?=
 =?utf-8?B?OVF6U1k0R2hDVTJXQzZhSUkxdGszQ2FYdkpGa2dvRmprOUJaL2pzZ1JXem5s?=
 =?utf-8?B?UmZTNjVrMmpSYUtPK0RuZUZ0UWhETFdsTURybThNRzIxeXplOG1MVjYrN1BQ?=
 =?utf-8?B?ZFREc3FrOXlVNlhmb092NjJOU2sxZ0YyZEFZNWRBdWJyZG1jT3BEdXhha2kv?=
 =?utf-8?B?bDhSUVN3SisrWjhwWThVM0MzYXBSdTYyKzFUK1Vtbm1jWVRuNzMrNTNMV2x2?=
 =?utf-8?B?cG92VUpBVHZUbkt0ZDFGTHB1U0FlWkdLek95aEo5bUREb0Z5MzdZQjJJRG8x?=
 =?utf-8?B?TGU4UHAzUnJUWjVBTkdySmRrcllDZzdOeWp1NkZyYmdSSzNOdEd2UTN1Q3hE?=
 =?utf-8?Q?Q9mP8/EwZnIpKPJ5Tq1q4c1to=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e971ca-461e-4e78-2f99-08dac90a2e68
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 02:11:19.1626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F+YOiPe/rKAope3o/4Bpu8ApG12v3xRUpkSnda/Imr0vhbvy6uG7NxxnhptAqVWQXqLcA4aQv0ChdJZ8vsmEcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7257
X-Proofpoint-ORIG-GUID: zcBT4A8i-8zehCUxosR7UckiBAl3Ylbv
X-Proofpoint-GUID: zcBT4A8i-8zehCUxosR7UckiBAl3Ylbv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211180011
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBOb3YgMTcsIDIwMjIsIEZlcnJ5IFRvdGggd3JvdGU6DQo+IFNpbmNlIGNvbW1pdCAw
ZjAxMDE3MQ0KDQpJIGRvbid0IHlvdXIgdXBkYXRlIGFzIG5vdGVkIGluIHRoZSB2MyBjaGFuZ2Ug
KGllLiBHcmVnJ3Mgc3VnZ2VzdGlvbnMpLg0KDQo+IER1YWwgUm9sZSBzdXBwb3J0IG9uIEludGVs
IE1lcnJpZmllbGQgcGxhdGZvcm0gYnJva2UgZHVlIHRvIHJlYXJyYW5naW5nDQo+IHRoZSBjYWxs
IHRvIGR3YzNfZ2V0X2V4dGNvbigpLg0KPiANCj4gSXQgYXBwZWFycyB0byBiZSBjYXVzZWQgYnkg
dWxwaV9yZWFkX2lkKCkgbWFza2luZyB0aGUgdGltZW91dCBvbiB0aGUgZmlyc3QNCj4gdGVzdCB3
cml0ZS4gSW4gdGhlIHBhc3QgZHdjMyBwcm9iZSBjb250aW51ZWQgYnkgY2FsbGluZyBkd2MzX2Nv
cmVfc29mdF9yZXNldCgpDQo+IGZvbGxvd2VkIGJ5IGR3YzNfZ2V0X2V4dGNvbigpIHdoaWNoIGhh
cHBlbmQgdG8gcmV0dXJuIC1FUFJPQkVfREVGRVIuDQo+IE9uIGRlZmVycmVkIHByb2JlIHVscGlf
cmVhZF9pZCgpIGZpbmFsbHkgc3VjY2VlZGVkLg0KPiANCj4gQXMgd2Ugbm93IGNoYW5nZWQgdWxw
aV9yZWFkX2lkKCkgdG8gcmV0dXJuIC1FVElNRURPVVQgaW4gdGhpcyBjYXNlLCB3ZQ0KPiBuZWVk
IHRvIGhhbmRsZSB0aGUgZXJyb3IgYnkgY2FsbGluZyBkd2MzX2NvcmVfc29mdF9yZXNldCgpIGFu
ZCByZXF1ZXN0DQo+IC1FUFJPQkVfREVGRVIuIE9uIGRlZmVycmVkIHByb2JlIHVscGlfcmVhZF9p
ZCgpIGlzIHJldHJpZWQgYW5kIHN1Y2NlZWRzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRmVycnkg
VG90aCA8ZnRvdGhAZXhhbG9uZGVsZnQubmw+DQo+IC0tLQ0KPiAgZHJpdmVycy91c2IvZHdjMy9j
b3JlLmMgfCA3ICsrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYyBi
L2RyaXZlcnMvdXNiL2R3YzMvY29yZS5jDQo+IGluZGV4IDY0OGYxYzU3MDAyMS4uMjc3OWYxN2Jm
ZmFmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYw0KPiArKysgYi9kcml2
ZXJzL3VzYi9kd2MzL2NvcmUuYw0KPiBAQCAtMTEwNiw4ICsxMTA2LDEzIEBAIHN0YXRpYyBpbnQg
ZHdjM19jb3JlX2luaXQoc3RydWN0IGR3YzMgKmR3YykNCj4gIA0KPiAgCWlmICghZHdjLT51bHBp
X3JlYWR5KSB7DQo+ICAJCXJldCA9IGR3YzNfY29yZV91bHBpX2luaXQoZHdjKTsNCj4gLQkJaWYg
KHJldCkNCj4gKwkJaWYgKHJldCkgew0KPiArCQkJaWYgKHJldCA9PSAtRVRJTUVET1VUKSB7DQo+
ICsJCQkJZHdjM19jb3JlX3NvZnRfcmVzZXQoZHdjKTsNCg0KSSdtIG5vdCBzdXJlIGlmIHlvdSBz
YXcgbXkgcHJldmlvdXMgcmVzcG9uc2UuIEkgd2FudGVkIHRvIGNoZWNrIHRvIHNlZQ0KaWYgd2Ug
bmVlZCB0byBkbyBzb2Z0LXJlc2V0IG9uY2UgYmVmb3JlIHVscGkgaW5pdCBhcyBwYXJ0IG9mIGl0
cw0KaW5pdGlhbGl6YXRpb24uDQoNCkknbSBqdXN0IGN1cmlvdXMgd2h5IEFuZHJleSBTbWlybm92
IHRlc3QgZG9lc24ndCByZXF1aXJlIHRoaXMgY2hhbmdlLiBJZg0KaXQncyBhIHF1aXJrIGZvciB0
aGlzIHNwZWNpZmljIGNvbmZpZ3VyYXRpb24sIHRoZW4gdGhlIGNoYW5nZSBoZXJlIGlzDQpmaW5l
LiBJZiBpdCdzIHJlcXVpcmVkIGZvciBhbGwgVUxQSSBzZXR1cCwgdGhlbiB3ZSBjYW4gdW5jb25k
aXRpb25hbGx5DQpkbyB0aGF0IGZvciBhbGwgVUxQSSBzZXR1cCBkdXJpbmcgaW5pdGlhbGl6YXRp
b24uDQoNCj4gKwkJCQlyZXQgPSAtRVBST0JFX0RFRkVSOw0KPiArCQkJfQ0KPiAgCQkJZ290byBl
cnIwOw0KPiArCQl9DQo+ICAJCWR3Yy0+dWxwaV9yZWFkeSA9IHRydWU7DQo+ICAJfQ0KPiAgDQo+
IC0tIA0KPiAyLjM3LjINCj4gDQoNClRoYW5rcywNClRoaW5o
