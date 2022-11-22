Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A53063325B
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 02:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiKVBsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 20:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiKVBsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 20:48:24 -0500
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22CC252A1;
        Mon, 21 Nov 2022 17:48:22 -0800 (PST)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM0oLq9008200;
        Mon, 21 Nov 2022 17:48:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=Vqt3VlOcKW/GihAjkjPsrAmQjJQgYJBV9/AjgNLbm/A=;
 b=pexictmrnlo+N4ZDvz186Nd3A/GyTHqHYpfreo7ACTc/QjvRGfmSRNOAJETmohdoui37
 yBLNs0qaqczd9jqGRg3ihNq8+UzsagP5tjLXMx/KPmVnhxLzdFfUHRziEYQ2YQP70g5W
 5I27rIyP02530PpEH4JzUAqoWMdGzbVIFwqXkODQqgqVndbEFg2W7Q7PGn7vs29y2m8K
 XRzqrTJy9R2WAk7yV7Z0pEZXaRZ5/LR3uyxh5Yj0K9+ojoqm9zkhWmvg+XAlnVQQGoMV
 1PMW59XZmNlKS8Jxt2ESnpgrgP0+ZWiIHbRlaS3LP6rKWo8MbrB9zp82YONMYjmQ+NEE QA== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kxxxxj2uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 17:48:02 -0800
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6563E4008A;
        Tue, 22 Nov 2022 01:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1669081680; bh=Vqt3VlOcKW/GihAjkjPsrAmQjJQgYJBV9/AjgNLbm/A=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NRJKx4V+vHDZ3ePrslNrZL30/gUbDzJ4PzkzqDXG4emPopbjGvzk7WOi5qXR9S0vg
         ulsUc21FBwyNe3PQTU3trVHxgphPJByZ9VE43ZxF9GxEweaHeQ9JdV1pSwfCXZjLTX
         8dzakqmiCQRafRBBbAXw7oXPwUWkaIGk6pyzi1dOwz7W4Ad8lhtW2fKRZRBwzDWOrM
         Cdp+XsESKt6XJtSJsEmKad3zBbEuuu+zQi36wE63psKfON2/+n7qN7FNde5zd9WKsi
         T+Z8TU+P8jc1aSAmGJK8EzuwangrJxIJpOjhrOvMprrubLk2pQwDfwjk+LwMAC5dtf
         FENIA0dLGU9gQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 84A9BA0082;
        Tue, 22 Nov 2022 01:47:58 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id E4322400DF;
        Tue, 22 Nov 2022 01:47:56 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="hhwzUHqg";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZfzrquHeC7WYoi1wpG/kjOIpii4rAeuTMd/R2MGp0Mw4b6tVK3ws/DLEGAo1F7OwBs3PtgKKs23usM/Qqxab4EyOAF4pI3Dgzmw1bNK3+3DyATiwuBvvO7bMtCBLrv8I2kQPLGQR9i47zZusrER253lczF2i0sM+1cs5KwZK3HRhIJTtVOLNAIxG6wvS+AoXQ1xo4KSl8AwiL9O/9qvDukgWOjx6AF2pn/XYg1dEAgRwCpYWfZSGZFnSUQ4tnlJTrx4uD0kn3OmutUlrndn4Kv9USs134CG3nK26tpR6aefVJJHDI2nfTgjZNUKYIkAYYaVfMqhbzk3gucZjjjYUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vqt3VlOcKW/GihAjkjPsrAmQjJQgYJBV9/AjgNLbm/A=;
 b=lvUWa0E2hyargQuFV8oaB2HGLX+XN3PHBRB7n4J1af/p0naI9I/bNvHivdJFfAVf6crIz3bSxH5jf5a30vag2r8OxcV+kcSpZ3VOVREjGyAiU42m5HSCjzBDY0dGnPcYATnfz7+DD+CwaNE3/uaP3y/8ei5xpvpZ1X2ERiG0BlmBtcfbXYG2hs7Qy7fOfRrXB/wM4xKG0uTPNBLhoodbvnwQvoZm7nxCunq0QYtzCS2JaVRJWt+CswjJQznQFpskXLdJ+gakJ6YIs+kgsvc7B6mlEWuPBYeiMMmfB+lmk2X/HkoblXeabi7IXanhF7J6cy16an4/XloW7tN0KOGpHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vqt3VlOcKW/GihAjkjPsrAmQjJQgYJBV9/AjgNLbm/A=;
 b=hhwzUHqgaUakAmTekbQuZbCk7aKINNJ06Mhqm6EbigAGKnp4HLKxzOJYAsPbcv/XvrSgfo2aAsypNftPuJ3wcxhn06hk07BOSKdwDRI2x2V9A1gOT1yK0J+bJjxYmESPq5HDc5OT3/p+gms6jbj+HujPTdINaXk/HMJ81UBXTvI=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 01:47:52 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::e395:902b:2e90:b7ee]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::e395:902b:2e90:b7ee%4]) with mapi id 15.20.5834.011; Tue, 22 Nov 2022
 01:47:52 +0000
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
Subject: Re: [PATCH v4 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout
Thread-Topic: [PATCH v4 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout
Thread-Index: AQHY/PYCH51sf/GfY0+C/I0+O2doVa5KLuoA
Date:   Tue, 22 Nov 2022 01:47:51 +0000
Message-ID: <20221122014746.ejxwie5g7yjrtlbm@synopsys.com>
References: <20221120153704.9090-1-ftoth@exalondelft.nl>
 <20221120153704.9090-2-ftoth@exalondelft.nl>
In-Reply-To: <20221120153704.9090-2-ftoth@exalondelft.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|MW6PR12MB7086:EE_
x-ms-office365-filtering-correlation-id: 098df85a-1955-4f26-a7e1-08dacc2b914f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WQZ4ylvgVPHoK9+16x7JA+W0MwNzZ9h+M1Dph+RaQmiFRObx4nR9F1Dl1faYKspGsbBry3pqvcTskrMTFzSh1dUeiwLBdZpgP2g6zw0TCSTTh9hJ5bz9SfLnq6J6EbzJWLPWtAJwphIbkN9tVu2k3HGdDIPG9hFUXleB1KyW5VWXdw6Js+JIroNiIBzx6wKjBFzKNELEs2hvYa/RDAvZBzUqp5DWy1FkcU7fqvTamgprwt2yaAPzbK9p3jhdCgq6s3zzKn/70qP6PKk+uj3WEmiwI3yim0rweJhC9l1tSohB2jeAho4YjDLZc9FmgJQSEzyAOsXAQZy1DKaZ+7vtNGn8gj5IlVF34vioCq7ihh+q3AvEdUdlf3tj+VCTkgiTqksa0ToAwJLdc7QzQaLkG4+puTRoONlnc99Tm+sAPoMnEw0dEKlzxgXvsr3D6XH12KApC3we+GDKyw4tlT/7C8hEXDR9IayAjTuSn7y+gOdmOrPcN2S2/j4QT8k0wD8NqR0YnDLql85DLFqDqQclpeTfz0POPbQNKugLdJ8Te9TQWW4PRh4KuhyRcLF0CHWWA3dNRC9dBBl73g16yV8SWtrDYe4G+tx9BB8qGK2LOAc/vPRJn4auviyxVrO3wHuEm4lYhg40VR8gs8Xe1ql8BbXTsoeMGJPz8baL6FlJusF/yIypKFPNzABNXIzTQvHTf9AySsFcAd6penULiwDKFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199015)(86362001)(36756003)(66446008)(4326008)(1076003)(41300700001)(76116006)(66946007)(2616005)(66556008)(38070700005)(64756008)(66476007)(186003)(8676002)(5660300002)(8936002)(6486002)(7416002)(71200400001)(26005)(6512007)(478600001)(316002)(6916009)(38100700002)(54906003)(122000001)(6506007)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2c2cUl6QzJkTzRCUGtPQlB2S2tmOGR6cFd0VDdHTDhTZ3lHNC9MVHlmLzF4?=
 =?utf-8?B?UnFsMlB0VVlSTUxQdWNxZWhUMUZuTkh1clQyNi82MHZxU1JvY2RuaFRTS09B?=
 =?utf-8?B?SkQ5ZkU0MzMzQndCR1c3TEtwNWdEVEhNdmI5NFRQQi9Db0JjckI0NldnOS9S?=
 =?utf-8?B?NkRoaTQvZUF3K29aTlpDczEyN3NwbytkRCtoa2F0OEpDeUVFdk9jbmZiYWlC?=
 =?utf-8?B?ZEt0K0k5eDBoc2FpTEtZQnJCNmVxN004WmtwaDdaNGc2QTNzZ0FnUmRSRUIv?=
 =?utf-8?B?ZE1EazhPcmxnV2Z4Q0xkdE8rMThNQUdoNHdla0I3VFZlVDBJTXZDSlFQOVdD?=
 =?utf-8?B?MHI0QTB0YzlIMVZjNE1HdTRSK2JDZEZTNWtUdHlvcGJ6aEZJM0V1S3p6U3ZC?=
 =?utf-8?B?VXIwcTQvVGc0eCtQM1RtMngyOXp1Sjdvd2QxMDgyWkZURGxyMFFRWDNBMkRu?=
 =?utf-8?B?eElZMXZQeXpIR3JNWExVR2tQRzJJT0RMWGRGb2FUU202M2JtYXFlb2RMZXFG?=
 =?utf-8?B?WmJ5bnovK24wKzdJdU5EZGxJUWRtQTdGYSs2VFZKdnNTQ05uWVoxU3RnVXor?=
 =?utf-8?B?L2lVV0lnSDV4blBONisxNi9lK3F0UW0xUHlQRXNwRmxiOVU1R2cxTUdpWG1k?=
 =?utf-8?B?bndEYldrK1BMYjVSajFNODQrdHVkRTNzZUtRZnRFREl0bHlabkE2WFRla0J5?=
 =?utf-8?B?Ulpwdm1ZOFpsZGN6dXRhbFR2ZExhbzEyK082RE1QZEg3UlNvZWNBQXUxeENN?=
 =?utf-8?B?cE5RNGhBNFVhVjVndEhTYVk5MllVa3l6cisrMjhvYUNRUFFqdnIybFExUHJI?=
 =?utf-8?B?U1VVRk1KUjR5U0RldkE1RFprb294cVRHOXdQbE54SzFxRmdzU3VIRkdyQWNS?=
 =?utf-8?B?NXZiaXA5a0JYL0pXZ1JQVW9GVExSb0htRW5uTGExWnlDOWZoK3ErR2g4bHRM?=
 =?utf-8?B?cVVjWVdaVStmQXFNckdINnU3cmZWV3NqL2RHdXlGbDFrZXlYTjlObVNvU1lG?=
 =?utf-8?B?eEkzTndSeUQzcWJOMWFYYTZkYVpuWHBtOWpPQ3JhUE52K3pPb0tmaW5zZ0pY?=
 =?utf-8?B?ekVrdkNHRml4aG5iL0RJS0pCTUdPQVBLWW5BU0lCcXZWY0lwS04zNlM0bWNQ?=
 =?utf-8?B?WUpvQnIwaTI0KzM3UVg2YUZKRXpobVUzYWovMXlSWlJWMnlpN2FMOHZualEx?=
 =?utf-8?B?d3RSKzQwYjJ3a20rUnpWTW90WE9FWUI3NHFCSGxQNHhoeG1mdGVKZ2xkdVdw?=
 =?utf-8?B?OFNvSDNQTy93amJnRXlyQUJsSXJJTU8xVGkyZUNVNGcvMndtMEhycTFxODVH?=
 =?utf-8?B?dVVvV01qVVJOeldSUXZ6Q2UvcjE1bXBONGYzWWx6a3E4MTJNMzgzaFBjODBu?=
 =?utf-8?B?SnpYYTRoSzJZRnZTU0V5Y3E0M2V5Rlh6VitJSXFIdkp6UHZUempORFExUisy?=
 =?utf-8?B?cWE2RTZ1Sk9WUW01ZGFRcjlaKzJOZytBVnVMcTBqYXdDZzBmekZxOGgrSWdO?=
 =?utf-8?B?ZzY5NUpSWmFhOFhvQ20vcnVVQm81OGVhVjBOK1plMkE5M0hUNzFmcDltaVpF?=
 =?utf-8?B?SHZCTU5JbFcrT0MvdnJXQjM2RDQrRG52NjBoY253Z005MjFlNmM1Nlk0dC90?=
 =?utf-8?B?cWtQdjNQT1hBYVRlTG55WVYzdDBNR0o3MVFTZkFyZ2ZnTU9jcElEVytLazln?=
 =?utf-8?B?RGNNTW1uQzJ0dnNIbU11QkJlZDdYZS9DZGlTbmFmOGlBc2dGcldUcS95QVor?=
 =?utf-8?B?UUtybkpOQnVYaVFobUppRGw0b0M2TjMxeU9WMXNYbE81M0NGSzZTYjVtdDlo?=
 =?utf-8?B?d0FQOVZsMS8zVXFORUJMbkcvTGEzK2dnbElJMTdIR09YNTdSRWZDVkE3ZDRr?=
 =?utf-8?B?VzUvWDNuMmd6dDVYd1gxSnFSZWRJeDRZeTgycUd5ZVdSVXJVUmxkYitHY1Yz?=
 =?utf-8?B?MWJRWmxLWUNORzcrTlhIU1lhR29SV3NqclBNQnl1ZW9Ja0krc1ZvUHF4ZGR5?=
 =?utf-8?B?WE9BS0VJUG90ZnRUNWpqK2ZCS2NWSFNJWEJ1T25tR2hDY0xEVVJSUWJQR3Ru?=
 =?utf-8?B?L2JzZ09aMnV3UVpZejdyVmV6OE9FS0JTSFFYeTZCbE9JdnE2Y2N2NkY4YkFH?=
 =?utf-8?Q?yYPxtqNs3VO3edpt0SojCeer6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <713DAC9027D35D428373221BF71D0FFD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UE5LbzM0cDV5SFdlUW0yVzY2WU5MUkduUlczTDI2WnFsU0E2ZytaQmY1TUlX?=
 =?utf-8?B?S3ViYVRwMHdlNXpISlNObko2clhVczRlWkxoeXpNbU81ZzlWcjR4dVdFZElZ?=
 =?utf-8?B?eVJOWFJKTzllejVHejFaclZHcW5vMnk5YW9oTjZFZ0ZhQzFzcFIyTjllSjlt?=
 =?utf-8?B?YWU1M1JSZURZa2dxY3BHLy9tY2xSdDU2dGJseVlkUnRlY21WOXRrRGhDcTJ0?=
 =?utf-8?B?UkQ2S0hJa3R3S21XTTNrdm1sOWU4dnM2NHNzb2VhUUdMTEZyRENvL2R2MHh5?=
 =?utf-8?B?WVpwTnh2Vy84cFBvU08xcVd6a1YwYm1kOGxYUTYxL0M5YkZhOG54dlVBelJX?=
 =?utf-8?B?WmNyTG53QzBxQnZaczBkZWxJUHRoaC9WVmpsYTNwRzh5bVBqTENnR3dhRU8z?=
 =?utf-8?B?ZThZZWpWdlY3b2RRUitTdVVyY3lRb01uNCsvNFdBZ1FjcG8yOWVQTXlORS9R?=
 =?utf-8?B?b216dnBPM3ZFbW9yZ3ZMVndsU2kyS3VVMXNzOWJPUmRWcnVJWEFBUkI2SXQz?=
 =?utf-8?B?ZHNjZkljYjdldTFOVmFWaVRGL2RxZ0JPeWZ4c0drYlgzSUJINU8wczY2MFM2?=
 =?utf-8?B?c29oU2MzY1lORXpIYjZvd2hsbkR1c2lJRWNqM0k3bngwb0RBZlVXM2xvSktM?=
 =?utf-8?B?OTJhamZYNnhIUmNSWjFRQUgvNVMvek9WVWtVYisybS9DQWdJaG1hekhkQkdF?=
 =?utf-8?B?VThpTW4xUkNmbCtZT3hMazBndlU4ZXpsemw2SUFJN3lONXlVYmE3RlZMTXZa?=
 =?utf-8?B?NERJeFB3QTVKa2FpU0txcWZwUEF4Y2xMZkU2WmVpZzNxRUFZaGJKNjhvWXYy?=
 =?utf-8?B?ZmxiN2kyTU1MZSszSi9WOWhWYW14T3BoQUFrSWFnTFVweEFjMFpLS2V3eFJN?=
 =?utf-8?B?RzRycXo2WmpHRjdMTk5YM3JpZWk4emRha0t5VGJNT3lwOHJmNjBLQUd5TUtQ?=
 =?utf-8?B?clByMXpBVWZ6WGsxNUhHK0tZWGpFMnE4VldobzBLbTlJQ1JIajY4V2tNNlRF?=
 =?utf-8?B?YzFsSUphbHpleEtjbzhWQ3FZQ3gzRkFMRVhyNGEyWHplRkVjd2ExRHdTOTJM?=
 =?utf-8?B?Q1l3VUlzalRiMWp1d29idVE0ajQvcnNKY3h0Q0JLVXlwMnNWSkt0cEJHRzNW?=
 =?utf-8?B?ZDAvdXI4dWF1NXRadHdiekl2MkVPdjcydlJnYmJFSlF6S3FsVnhLNEw2RUt4?=
 =?utf-8?B?eU96Vmd0Slp5RFdNYTltaTZmU0VhNGZOdjJWOTdRT1dsMmRkcmsxM3E1SlA3?=
 =?utf-8?B?WWxKNjlHWVFQQzhvb09NQk9vMUFLTUlUeWc1MGJzcThndkVhamdKTlpjektj?=
 =?utf-8?B?YnYzdkNCdGgyQ3NZTlQzeVFUbkVISmZJMFQ5TkVFL0dUd0dnVWlSTW15eDEw?=
 =?utf-8?B?RWVuOXJUU0toL29vYVlMMHFadUNwOHFQdVNNOU1ZcXhZa3ppa3VJUDBHTmlD?=
 =?utf-8?B?YnlyVGJyUmtTdXBhdHZZc25peXZQcEpPSGRrVm5iTWd5WUF4SGY4VE80R1Zu?=
 =?utf-8?B?MXltRmUyWWsrdUZNTHRXZHhLenhINFdWU2Jkclhpb1NtdW9sSjhvSUZoZDI2?=
 =?utf-8?Q?pnhg11LrP21zdTlrCa3CYVGC4=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 098df85a-1955-4f26-a7e1-08dacc2b914f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 01:47:51.9454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OnXSGABJaXEiv/gMAyBEZh7CbJULFHi6fktWd8z1RDxOloiVhf3TDFKUPpyMqF6vfGVavE6t2W1x7IL0AIa4Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086
X-Proofpoint-ORIG-GUID: irlBAiWpojZ75mxPDgmEoLl9ds8Ci-1u
X-Proofpoint-GUID: irlBAiWpojZ75mxPDgmEoLl9ds8Ci-1u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=939 clxscore=1015 adultscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 malwarescore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220010
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCBOb3YgMjAsIDIwMjIsIEZlcnJ5IFRvdGggd3JvdGU6DQo+IFNpbmNlIGNvbW1pdCAw
ZjAxMDE3MTkxMzggKCJ1c2I6IGR3YzM6IERvbid0IHN3aXRjaCBPVEcgLT4gcGVyaXBoZXJhbCBp
ZiBleHRjb24gaXMgcHJlc2VudCIpDQo+IER1YWwgUm9sZSBzdXBwb3J0IG9uIEludGVsIE1lcnJp
ZmllbGQgcGxhdGZvcm0gYnJva2UgZHVlIHRvIHJlYXJyYW5naW5nDQo+IHRoZSBjYWxsIHRvIGR3
YzNfZ2V0X2V4dGNvbigpLg0KPiANCj4gSXQgYXBwZWFycyB0byBiZSBjYXVzZWQgYnkgdWxwaV9y
ZWFkX2lkKCkgb24gdGhlIGZpcnN0IHRlc3Qgd3JpdGUgZmFpbGluZw0KPiB3aXRoIC1FVElNRURP
VVQuIEN1cnJlbnRseSB1bHBpX3JlYWRfaWQoKSBleHBlY3RzIHRvIGRpc2NvdmVyIHRoZSBwaHkg
dmlhDQo+IERUIHdoZW4gdGhlIHRlc3Qgd3JpdGUgZmFpbHMgYW5kIHJldHVybnMgMCBpbiB0aGF0
IGNhc2UsIGV2ZW4gaWYgRFQgZG9lcyBub3QNCj4gcHJvdmlkZSB0aGUgcGh5LiBBcyBhIHJlc3Vs
dCB1c2IgcHJvYmUgY29tcGxldGVzIHdpdGhvdXQgcGh5Lg0KPiANCj4gT24gSW50ZWwgTWVycmlm
aWVsZCB0aGUgaXNzdWUgaXMgcmVwcm9kdWNpYmxlIGJ1dCBkaWZmaWN1bHQgdG8gZmluZCB0aGUN
Cj4gcm9vdCBjYXVzZS4gVXNpbmcgYW4gb3JkaW5hcnkga2VybmVsIGFuZCByb290ZnMgd2l0aCBi
dWlsZHJvb3QgdWxwaV9yZWFkX2lkKCkNCg0Kb3JkaW5hcnkgPSBtYWlubGluZT8NCg0KPiBzdWNj
ZWVkcy4gQXMgc29vbiBhcyBhZGRpbmcgZnRyYWNlIC8gYm9vdGNvbmZpZyB0byBmaW5kIG91dCB3
aHksDQo+IHVscGlfcmVhZF9pZCgpIGZhaWxzIGFuZCB3ZSBjYW4ndCBhbmFseXplIHRoZSBmbG93
LiBVc2luZyBhbm90aGVyIHJvb3Rmcw0KPiB1bHBpX3JlYWRfaWQoKSBmYWlscyBldmVuIHdpdGhv
dXQgYWRkaW5nIGZ0cmFjZS4gQXBwZWFyYW50bHkgdGhlIGlzc3VlIGlzDQoNClRoaXMgaW5mbyBm
aXRzIG1vcmUgZm9yIHRoZSBkd2MzIHBhdGNoLCBhbmQgY2FuIHdlIHVzZSBhbm90aGVyIHdvcmQg
Zm9yDQoiYXBwYXJlbnRseSIgd2hlbiB3ZSBzdGlsbCBkb24ndCBrbm93IHRoZSByZWFsIGNhdXNl
PyBNYXliZSAid2UNCnN1c3BlY3Q/Ig0KDQpUaGFua3MsDQpUaGluaA0KDQo+IHNvbWUga2luZCBv
ZiB0aW1pbmcgLyByYWNlLCBidXQgbWVyZWx5IHJldHJ5aW5nIHVscGlfcmVhZF9pZCgpIGRvZXMg
bm90DQo+IHJlc29sdmUgdGhlIGlzc3VlLg0KPiANCj4gVGhpcyBwYXRjaCBtYWtlcyB1bHBpX3Jl
YWRfaWQoKSByZXR1cm4gLUVUSU1FRE9VVCB0byBpdHMgdXNlciBpZiB0aGUgZmlyc3QNCj4gdGVz
dCB3cml0ZSBmYWlscy4gVGhlIHVzZXIgc2hvdWxkIHRoZW4gaGFuZGxlIGl0IGFwcHJvcHJpYXRl
bHkuIEEgZm9sbG93IHVwDQo+IHBhdGNoIHdpbGwgbWFrZSBkd2MzX2NvcmVfaW5pdCgpIHNldCAt
RVBST0JFX0RFRkVSIGluIHRoaXMgY2FzZSBhbmQgYmFpbCBvdXQuDQo+IA0KPiBGaXhlczogZWY2
YTdiY2ZiMDFjICgidXNiOiB1bHBpOiBTdXBwb3J0IGRldmljZSBkaXNjb3ZlcnkgdmlhIERUIikN
Cj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEZlcnJ5
IFRvdGggPGZ0b3RoQGV4YWxvbmRlbGZ0Lm5sPg0KPiAtLS0NCj4gIGRyaXZlcnMvdXNiL2NvbW1v
bi91bHBpLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVs
ZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jb21tb24vdWxwaS5jIGIv
ZHJpdmVycy91c2IvY29tbW9uL3VscGkuYw0KPiBpbmRleCBkN2M4NDYxOTc2Y2UuLjYwZTgxNzQ2
ODZhMSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91c2IvY29tbW9uL3VscGkuYw0KPiArKysgYi9k
cml2ZXJzL3VzYi9jb21tb24vdWxwaS5jDQo+IEBAIC0yMDcsNyArMjA3LDcgQEAgc3RhdGljIGlu
dCB1bHBpX3JlYWRfaWQoc3RydWN0IHVscGkgKnVscGkpDQo+ICAJLyogVGVzdCB0aGUgaW50ZXJm
YWNlICovDQo+ICAJcmV0ID0gdWxwaV93cml0ZSh1bHBpLCBVTFBJX1NDUkFUQ0gsIDB4YWEpOw0K
PiAgCWlmIChyZXQgPCAwKQ0KPiAtCQlnb3RvIGVycjsNCj4gKwkJcmV0dXJuIHJldDsNCj4gIA0K
PiAgCXJldCA9IHVscGlfcmVhZCh1bHBpLCBVTFBJX1NDUkFUQ0gpOw0KPiAgCWlmIChyZXQgPCAw
KQ0KPiAtLSANCj4gMi4zNy4yDQo+IA==
