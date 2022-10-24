Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C129B60BF83
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 02:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiJYAZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 20:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiJYAZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 20:25:35 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4432CE629;
        Mon, 24 Oct 2022 15:48:30 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLNmQQ031832;
        Mon, 24 Oct 2022 15:48:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=cQA0GoSWQxc5/USxqdUKd/gLUIElo7zv9UX0q3cFQ8Y=;
 b=KmxzLrrilbvui3PpP+WZ9doZt+gdg2MXWlZBMbwxwfa640kWYy/Y0SlWitYoxAmKYgmU
 tbkHPiaczCi0YwVEYQxduf1ClmrISLRSocPHkTXc1zd7Tkyvna+dpibwzqeGo/rXTDdV
 dwA3M8B+knsdA5wVf8bHGG9D09MBo4MBNzCqewLii013jyhQ0qvzbH3kS8L9mII24qc4
 5VgqDlNkzQO7H6OwlKZV3RTh8daABMTDdqWx4iakvWbsd7xFWA3JCAyrNYU71Ox8ap7e
 HSnMBmbmYCPZRLliYI45LnjSSMXLadK/CnB2wAd8t64HJQD5Rgq4Y1U2k9bPYMQe3yl6 Jw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfevu1sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 15:48:02 -0700
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2560FC00F4;
        Mon, 24 Oct 2022 22:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666651682; bh=cQA0GoSWQxc5/USxqdUKd/gLUIElo7zv9UX0q3cFQ8Y=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=GDeAfA2gATqFEpptV8o8kGNtifCOwcfOrwwUfkvQKdiXbBMtICxwejCUx9xQzzkRb
         dVsIXZlIxHTEMQ2j6ehru8LVc2kHdZYkiUBssk1f5QQteN2plv8EcXU+kBhXaIpgI8
         tM2zPzDM0zL++bDz2vLkqhux1bS0+7jjDSuB2cyPurwUulYz0w5Q1IRbfaU3GL5jaU
         sPNK52Nuf6BFTG/NrhWTZBmjQNheaCbbAep4QeC0JdTC9uu4dIf6Rm0LHE41hKmSE9
         Hi1PYxvu4Imkz0+rr6NDcJp4/bcfmPAiAn8LC9LJVfPlEc9o1MYHJAPLleTvpGbLl6
         LMPrrnGZrzLjw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5DBEAA009A;
        Mon, 24 Oct 2022 22:47:58 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 9915D40053;
        Mon, 24 Oct 2022 22:47:56 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="wD0VF+ML";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJEWX5eS0TmlisrW42NBY2xyo8kv2uPW9sJ+cj5u/41envBSswwhG9p2Rqz2qQGTK64F3CVFhBivkSThgsS7Mn9CifBJsH6M2NscwS2ZMiWKbTgU2iStvSoA0ZHBszP6l2sxJjwqk0XEmlGrzFpzeguDAUomdGbEJHXnm84n6kcsC8/+W+WeAhS/0HsprnWqhRIhZfKOF7gAjJtMBdpHlOg5ESxtPNygdf7mRDKh8xckukfM0S9CHCcSa3Wr1iVKNy7n5V8I7gVLu3gg0bw5sxtTz5uw3JZ5u1PC58NjE9V15F8iVQFLw6FLq3VSOOV8i9rXUY+H7TyWqJOVbVNrpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQA0GoSWQxc5/USxqdUKd/gLUIElo7zv9UX0q3cFQ8Y=;
 b=Qrkbp1KLjiNyPKA2O47+NMOHCGOsalrrt+MNv2Ki9DgMcIWQKx8TLAhMPPLj1RKada52jpRUb2kSdgmvcbTozGAzkO8UoQRPAVAYalFdz+wbDlWepzTsWppUIHBfFpb7qh0tALIwytfJoMVwKjr+rG7034xxW2CaJwQwa6pD2m3c0ieIFe3lJDPuyvhjpmYu974ZhERvSVbP7y9Tv32yxG8J5YExDiWGixRDo7Xe7M24X8M9jAw8GnSLtY10YsnYDNQlPXSCbMdjB+LKKesvS6BVPiOgUxOFnc9pi14wYAxfCMtKXBButDi/uu1rOKw2cPAgn9/dLMa0ZZc4TQZnCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQA0GoSWQxc5/USxqdUKd/gLUIElo7zv9UX0q3cFQ8Y=;
 b=wD0VF+MLyN3OLb7tMe3Zknoxr6IZHUXf39Xa8OWIVfAoBIVSc5kaCdwQehcLYrNAh8hYy8CfL55kzLuNbImaZskGSLD5o3xezOL3fDviljj1nWcgFQB31D8BNASlY0Hl0q5bZFhS7JpsxTYWGQLdo5pMPNPsILNH8Z0Y2XVLrWA=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH7PR12MB6420.namprd12.prod.outlook.com (2603:10b6:510:1fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Mon, 24 Oct
 2022 22:47:54 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Mon, 24 Oct 2022
 22:47:53 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Jeff Vanhoof <jdv1029@gmail.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Vacura <w36195@motorola.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Topic: [PATCH v4 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Index: AQHY4zvIL5mjCxYsH0+sASc7Db2cYq4aTSoAgAAiu4CAA77qAA==
Date:   Mon, 24 Oct 2022 22:47:53 +0000
Message-ID: <20221024224748.3aao6cox5y4ptmob@synopsys.com>
References: <20221018215044.765044-1-w36195@motorola.com>
 <20221018215044.765044-3-w36195@motorola.com> <Y1PUjO99fcgaN0tc@kroah.com>
 <20221022133541.GA26431@qjv001-XeonWs>
In-Reply-To: <20221022133541.GA26431@qjv001-XeonWs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH7PR12MB6420:EE_
x-ms-office365-filtering-correlation-id: 2679cd1b-fccf-486e-4ff2-08dab611c989
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GqIRtCC1+eVWvVlCZHgFx/NZRgHcYp2LvQlzRl0kp712Ez+YB5O5bENbO7AzjyuxRowP0ikHe7xSwnmnHrf9gqNvl2iOnlmd8klA43xolq+5lV66zXAOU0dhvDmTEVBTBB1ePZOW43drFoCY+krdwAfutmfk9XkmP2oJidZdtL+iz/BJCSUOylnMUOH8/VDRjOd3lD/1n4aFi+x84FIbC29sR80Qzln79RZXA7l7qYX54+8Wo+ogSTPnzGWDUMNPVmmtO9MyM5Zq4x2o6dkSKRKHuFx84Dizyk9DUyQA41/StS0dQ68+c54CfUGjPJQV5Al+ZXX4B9ThPylhkrWMFxzC/wR19n2bvr7CfWM9px9D58w+Na4K2F6POmwGc2HOXS/XfTTPn/wR+GLc8iegXheNWsB9yGokUEeMxok2wOF8wKEfcdMR7R0Avux+YNRhL1lv2yOzKPsfWi1WiaWn2vSxRTOM0Qm7z5E5Opo4pwc5/8z3+iS20BzAE1WrVK+sJuyA2e2GtHlmf1KANLKiA68Cn1Fm5TG3AshkEMMDERprFjfVAWfMLb677FAsiD7Ls2q0QPP0P1Z8/ym2LCYXh8+t+9aAfZMY67IEURUcBxuxHP3khybd+cdbv1FxXG3xPKmFNbtllOYZzo7GaLD9TGl6JqKCyzUq/hTiLiVcMO0Rcj5eenI017nArM9FbVLjOjJebsSq2+NxHb/Qap/HYvkLT0MkZr/q09fXHVscDuTsBNqaRJxenTJKmMESC/xmVNXzHh9IHVjgAc8yUR0Spw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(6916009)(54906003)(76116006)(4326008)(71200400001)(8676002)(6486002)(64756008)(66446008)(66556008)(316002)(66476007)(66946007)(36756003)(38070700005)(7416002)(186003)(86362001)(6506007)(2616005)(478600001)(26005)(83380400001)(1076003)(8936002)(122000001)(38100700002)(5660300002)(6512007)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2M5RGplVlB5M2h3Wkd0bFNmdS9HZTNzR3VRNWRvci8zcE04SjJMbytsWDEw?=
 =?utf-8?B?aDZNYVVaLysycEV4SGRxRnluNlMvVlByd3E4RnlFYXdQdFRIT1M2RFFkSWtE?=
 =?utf-8?B?T2toUUVhVzNVejFUOEh6T3VlK1d0L3NJcHFmVDc4SEwyZm83R3pqUXhDNC9s?=
 =?utf-8?B?VjFKNVJMTUtid0w1TCtVdm1OL3VIVGNCR1ZvMFh1VFV2V1pSdVc1dEo0SDhO?=
 =?utf-8?B?bUwrQlhMNVd6ckljeHVQUEx4aTU4MzZTTCtWZzFBRGVJN2p3YTcxNnZ5ZDkx?=
 =?utf-8?B?bU90eUM3WGZGSTc2WHdEd3RBQmlBcHo4d1hRa2dWTGFreVZuYjR5b0xtS2tE?=
 =?utf-8?B?U2hxOVNMYlVrTVAyS044ZG85a3kzTEwvMDAzVlA1NlRES3lubGZaY1J5eFVq?=
 =?utf-8?B?MjRPaCtIWjNRY1IySklNa1c2dUYwK25Tb2p4RDRRTCttZU1vZis5N3hEWWZF?=
 =?utf-8?B?bzgzRUVVcHhFdEdaZG1VT2tIOGhLemtKYjNWQjdCOHN4czdOZWNjK2w3aVdU?=
 =?utf-8?B?QnluLy9sckl1dWZtTzhGUEpUWGo2Z09KZ2Z3bVVCOE8wTHIzTzB1b1l0K25t?=
 =?utf-8?B?cHNYbi9wZjVJNHV1a3cyS0kxNzlRQWs4YnVtcEljdFFOMSthUHdCSjdDWEFP?=
 =?utf-8?B?S0tvdDVROTNLK3JrNUNpZU5YRkxXbTlpelduaklTemJMaForN3BpcjdTY2VX?=
 =?utf-8?B?YzcrTDBVRk1kek00R0xoUjlMaU5FaElvZXdCVzFFUVZBTk5VbGYrekljUGtz?=
 =?utf-8?B?VHZIeHVOMXNmaGJDbDZ2dG5nbWhzVytzUEtTSVVuaFZyTXpmRnFEVForcTlK?=
 =?utf-8?B?M3NQSU05aFVlRU1zMXN2NTJNcWZyU2RaK3dydHZQNGlUaVEyOXRKRGhqSmJZ?=
 =?utf-8?B?NUhIU0pZbUtXenViaHpZVkF2OUJWQmhxelJ3dnY5TDQrbFBxV0tNR1lOTURy?=
 =?utf-8?B?c1J3K0owTlJtM1BVNzJCbU9nendIUzdyWVpEbHRJRTMyTUtqTXZxckE5ZWJr?=
 =?utf-8?B?QnBRTXBqUFF2c1hKb3k5c2J1MGt5SXd4OWtMU29ubHZYUjhrSnVTQ0d2RGhE?=
 =?utf-8?B?R21mSnVjMFB2Q0VINFNMVlYzMjEyRjFDcHVyUlY2M1ZnWVpiVVpwaEJIT1ox?=
 =?utf-8?B?T2NSbHFlKzh0Vy9mUVROanE2dVMzbHVuT3dMTjhyd1FYaExMeFZvZ25pWXgr?=
 =?utf-8?B?U1RYemZjZFB3QVM3bmZTM3BibkJudWtEU0lJUlhJU25kUDdRVkljcGZCRENH?=
 =?utf-8?B?YStJWnlJVWZNYTZZSzk5RGUrYUlJUnYyd01HVnpIQW1lc0NINkVvNE1xZUxM?=
 =?utf-8?B?Q1RyMHYrYWo5bXd6bWtVYytWUUo5SkpIcGdib2xtdDBIN0J2RkxzSmFSOGlu?=
 =?utf-8?B?M29HTUtkTXUrV1p4NXdrbHhRNG5KbDVhWkNETnVoMDhCRHdTN0NqSEV6aFNV?=
 =?utf-8?B?VzFqeEJaNkV5aFczd1VVTGU3dEwwUHJKQjhJSUNPc1F3MDNpUFQvU1Z4K2Zi?=
 =?utf-8?B?aHBwNVhDTjI0ZVB0djhhTGgyaytBMnRkRGJyaWhZZkw2Smt3MjdTYVVkYVlu?=
 =?utf-8?B?ZTRoZ1dvc0hZUFArRU5LQ0JrVTVIOVRHSUNVckNyZU9sQ1hvUG0xcHlxUHZQ?=
 =?utf-8?B?QkQxS3h1YUZMaXMzcUp5anpRVGNndi9haGlzR1dBVi9iNXNtYmVwOWhkdzl5?=
 =?utf-8?B?cHlBcTYvL2VJYTdDVEkrQ0JTcWI4QlBCSko0b2Z2SXdEcFFvQWFscHZBbWNM?=
 =?utf-8?B?Qys5UDJBeDA2dkJXdENnWUdpWmxTTmU3a1pUd21Ra3Y3NGNaaXk2Q3JXUk9B?=
 =?utf-8?B?QzBCUSt3NDhjbDFBeFdGZzRmVTNON3hnNGcrbXpjMTRzUjh4aVA1djUvb1dL?=
 =?utf-8?B?cnJjL09UY0tLMHRJL2t5VjJlWXk1QXgrVVRKVytSdm92ZTR3NXdLa2V6NWE5?=
 =?utf-8?B?bDhLSThXYkJ5MUJvcWhVZVZXOVBWc3hDcjdla0V1a29FTTBEakYxcUkwVHdY?=
 =?utf-8?B?RFQyb2twK2FWeElsbDZvMGM5SjR6WGVTaUlFdEVrV3RXMlRra1h2T3Y3OUQ1?=
 =?utf-8?B?cFUwVlMzTWFwZlY0NGJTaXV1czJybWxnbmNmTDBuMThEWDcxMVgyS1BxeGl3?=
 =?utf-8?B?Rm9oMENHMkw0Kzg5TFNacUlGWUNZeUNWRURlbEt0MExIL2NQbkJqRmhoY091?=
 =?utf-8?B?bWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <187540B0F5CCC944B6CB8F482A9028DB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2679cd1b-fccf-486e-4ff2-08dab611c989
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 22:47:53.7640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y53oDa0fcWrnrTWrCSu3DHrIl2qCe482YKN1AuAjyBr1Gwc0WjQPZPtYViBeSbKDnwXjUjjrnFOAoGjFDhO5Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6420
X-Proofpoint-ORIG-GUID: JTfnvV4l6Rz4qcZ0s_WvAkXt8y5IYmz-
X-Proofpoint-GUID: JTfnvV4l6Rz4qcZ0s_WvAkXt8y5IYmz-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_07,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxlogscore=907 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210240136
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU2F0LCBPY3QgMjIsIDIwMjIsIEplZmYgVmFuaG9vZiB3cm90ZToNCj4gSGkgR3JlZywNCj4g
DQo+IE9uIFNhdCwgT2N0IDIyLCAyMDIyIGF0IDAxOjMxOjI0UE0gKzAyMDAsIEdyZWcgS3JvYWgt
SGFydG1hbiB3cm90ZToNCj4gPiBPbiBUdWUsIE9jdCAxOCwgMjAyMiBhdCAwNDo1MDozOFBNIC0w
NTAwLCBEYW4gVmFjdXJhIHdyb3RlOg0KPiA+ID4gRnJvbTogSmVmZiBWYW5ob29mIDxxanYwMDFA
bW90b3JvbGEuY29tPg0KPiA+ID4gDQo+ID4gPiBhcm0tc21tdSByZWxhdGVkIGNyYXNoZXMgc2Vl
biBhZnRlciBhIE1pc3NlZCBJU09DIGludGVycnVwdCB3aGVuDQo+ID4gPiBub19pbnRlcnJ1cHQ9
MSBpcyB1c2VkLiBUaGlzIGNhbiBoYXBwZW4gaWYgdGhlIGhhcmR3YXJlIGlzIHN0aWxsIHVzaW5n
DQo+ID4gPiB0aGUgZGF0YSBhc3NvY2lhdGVkIHdpdGggYSBUUkIgYWZ0ZXIgdGhlIHVzYl9yZXF1
ZXN0J3MgLT5jb21wbGV0ZSBjYWxsDQo+ID4gPiBoYXMgYmVlbiBtYWRlLiAgSW5zdGVhZCBvZiBp
bW1lZGlhdGVseSByZWxlYXNpbmcgYSByZXF1ZXN0IHdoZW4gYSBNaXNzZWQNCj4gPiA+IElTT0Mg
aW50ZXJydXB0IGhhcyBvY2N1cnJlZCwgdGhpcyBjaGFuZ2Ugd2lsbCBhZGQgbG9naWMgdG8gY2Fu
Y2VsIHRoZQ0KPiA+ID4gcmVxdWVzdCBpbnN0ZWFkIHdoZXJlIGl0IHdpbGwgZXZlbnR1YWxseSBi
ZSByZWxlYXNlZCB3aGVuIHRoZQ0KPiA+ID4gRU5EX1RSQU5TRkVSIGNvbW1hbmQgaGFzIGNvbXBs
ZXRlZC4gVGhpcyBsb2dpYyBpcyBzaW1pbGFyIHRvIHNvbWUgb2YgdGhlDQo+ID4gPiBjbGVhbnVw
IGRvbmUgaW4gZHdjM19nYWRnZXRfZXBfZGVxdWV1ZS4NCj4gPiA+IA0KPiA+ID4gRml4ZXM6IDZk
OGEwMTk2MTRmMyAoInVzYjogZHdjMzogZ2FkZ2V0OiBjaGVjayBmb3IgTWlzc2VkIElzb2MgZnJv
bSBldmVudCBzdGF0dXMiKQ0KPiA+ID4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiA+
ID4gU2lnbmVkLW9mZi1ieTogSmVmZiBWYW5ob29mIDxxanYwMDFAbW90b3JvbGEuY29tPg0KPiA+
ID4gQ28tZGV2ZWxvcGVkLWJ5OiBEYW4gVmFjdXJhIDx3MzYxOTVAbW90b3JvbGEuY29tPg0KPiA+
ID4gU2lnbmVkLW9mZi1ieTogRGFuIFZhY3VyYSA8dzM2MTk1QG1vdG9yb2xhLmNvbT4NCj4gPiA+
IC0tLQ0KPiA+ID4gVjEgLT4gVjM6DQo+ID4gPiAtIG5vIGNoYW5nZSwgbmV3IHBhdGNoIGluIHNl
cmllcw0KPiA+ID4gVjMgLT4gVjQ6DQo+ID4gPiAtIG5vIGNoYW5nZQ0KPiA+IA0KPiA+IEkgbmVl
ZCBhbiBhY2sgZnJvbSB0aGUgZHdjMyBtYWludGFpbmVyIGJlZm9yZSBJIGNhbiB0YWtlIHRoaXMg
b25lLg0KPiA+IA0KPiA+IHRoYW5rcywNCj4gPiANCj4gPiBncmVnIGstaA0KPiANCj4gVGhpbmgg
aGFzIHJlamVjdGVkIHRoaXMgdmVyc2lvbiBvZiB0aGUgcGF0Y2guIEhlIGhhcyBwcm92aWRlZCBh
biBhbHRlcm5hdGl2ZQ0KPiBpbXBsZW1lbnRhdGlvbiB3aGljaCBoYXMgYmVlbiB0ZXN0aW5nIHdl
bGwgZm9yIHVzIHNvIGZhci4gRWl0aGVyIFRoaW5oIG9yIERhbg0KPiB3aWxsIGZvcm1hbGl6ZSB0
aGlzIHBhdGNoIHdpdGhpbiB0aGUgbmV4dCBmZXcgZGF5cy4NCj4gVGhlIGxhdGVzdCBwcm9wb3Nl
ZCBjaGFuZ2VzIGFyZToNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdl
dC5jIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPiBpbmRleCBkZmFmOWFjMjRjNGYuLjUw
Mjg3NDM3ZDZkZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPiAr
KysgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+IEBAIC0zMTk1LDYgKzMxOTUsOSBAQCBz
dGF0aWMgaW50IGR3YzNfZ2FkZ2V0X2VwX3JlY2xhaW1fY29tcGxldGVkX3RyYihzdHJ1Y3QgZHdj
M19lcCAqZGVwLA0KPiAgICAgICAgIGlmIChldmVudC0+c3RhdHVzICYgREVQRVZUX1NUQVRVU19T
SE9SVCAmJiAhY2hhaW4pDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4gIA0KPiArICAg
ICAgIGlmIChEV0MzX1RSQl9TSVpFX1RSQlNUUyh0cmItPnNpemUpID09IERXQzNfVFJCU1RTX01J
U1NFRF9JU09DICYmICFjaGFpbikNCj4gKyAgICAgICAgICAgICAgIHJldHVybiAxOw0KPiArDQo+
ICAgICAgICAgaWYgKCh0cmItPmN0cmwgJiBEV0MzX1RSQl9DVFJMX0lPQykgfHwNCj4gICAgICAg
ICAgICAgKHRyYi0+Y3RybCAmIERXQzNfVFJCX0NUUkxfTFNUKSkNCj4gICAgICAgICAgICAgICAg
IHJldHVybiAxOw0KPiBAQCAtMzIxMSw2ICszMjE0LDcgQEAgc3RhdGljIGludCBkd2MzX2dhZGdl
dF9lcF9yZWNsYWltX3RyYl9zZyhzdHJ1Y3QgZHdjM19lcCAqZGVwLA0KPiAgICAgICAgIHN0cnVj
dCBzY2F0dGVybGlzdCAqczsNCj4gICAgICAgICB1bnNpZ25lZCBpbnQgbnVtX3F1ZXVlZCA9IHJl
cS0+bnVtX3F1ZXVlZF9zZ3M7DQo+ICAgICAgICAgdW5zaWduZWQgaW50IGk7DQo+ICsgICAgICAg
Ym9vbCBtaXNzZWRfaXNvYyA9IGZhbHNlOw0KPiAgICAgICAgIGludCByZXQgPSAwOw0KPiAgDQo+
ICAgICAgICAgZm9yX2VhY2hfc2coc2csIHMsIG51bV9xdWV1ZWQsIGkpIHsNCj4gQEAgLTMyMTks
MTIgKzMyMjMsMTggQEAgc3RhdGljIGludCBkd2MzX2dhZGdldF9lcF9yZWNsYWltX3RyYl9zZyhz
dHJ1Y3QgZHdjM19lcCAqZGVwLA0KPiAgICAgICAgICAgICAgICAgcmVxLT5zZyA9IHNnX25leHQo
cyk7DQo+ICAgICAgICAgICAgICAgICByZXEtPm51bV9xdWV1ZWRfc2dzLS07DQo+ICANCj4gKyAg
ICAgICAgICAgICAgIGlmIChEV0MzX1RSQl9TSVpFX1RSQlNUUyh0cmItPnNpemUpID09IERXQzNf
VFJCU1RTX01JU1NFRF9JU09DKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICBtaXNzZWRfaXNv
YyA9IHRydWU7DQo+ICsNCj4gICAgICAgICAgICAgICAgIHJldCA9IGR3YzNfZ2FkZ2V0X2VwX3Jl
Y2xhaW1fY29tcGxldGVkX3RyYihkZXAsIHJlcSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB0cmIsIGV2ZW50LCBzdGF0dXMsIHRydWUpOw0KPiAgICAgICAgICAgICAgICAgaWYg
KHJldCkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ICAgICAgICAgfQ0KPiAg
DQo+ICsgICAgICAgaWYgKG1pc3NlZF9pc29jKQ0KPiArICAgICAgICAgICAgICAgcmV0ID0gMTsN
Cj4gKw0KPiAgICAgICAgIHJldHVybiByZXQ7DQo+ICB9DQo+IA0KPiANCg0KVGhhdCdzIGp1c3Qg
YSBkZWJ1ZyBwYXRjaC4gSSdsbCBzZW5kIG91dCBwcm9wZXIgZml4IHBhdGNoZXMuDQoNClRoYW5r
cywNClRoaW5o
