Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C8D1B96BA
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 07:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgD0Fmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 01:42:43 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43796 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgD0Fmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 01:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587966162; x=1619502162;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DmyE3VJX8J1f1fPbv0Zoald7UdXblYc6d5KQAmDdh5g=;
  b=RBJSVgvLKAV8R/i/JsvPfEVzRarZySfT6VhBqXcoHn0k3PGlK49wnP3F
   odfB2at0MKn6bepPaIb7JyzVcLdZTr2jzYo1BtUkHgHkx07zAKlX8rx7n
   2q+QIR0A7pHWvM9UAvC0mY/A8HPNOixh1EP5BqOYYHXDxJMG7tLDJ8GQ4
   N0Cw/TZ+eHh9BaxbkTZd91nXaZeQqUa5eEt9658pdS7KmJSucLbcIyA1f
   7XSCAOh++H3pDLv8I/7JgZtyr4g0ttKyW4PnhJdQYGRIJponY5T5Acjzg
   /sm83GykD225Xk4OXSmxfAR0nbCuObW7SDoJsP7kFbfgYRJ7pOSO1QvIL
   Q==;
IronPort-SDR: V+PHRGUPMcfjsNxF/3osFqCqnbnvkUunGgll5pQHh5H4oeU4RnXPEaYhqGBShVcVUQN/CsSMAw
 ZfN6tPGY2tH45niNcIv1dNonXaYEkHPmjzJko+8jpnfsuMvFeGF6wiGSL69TmtC+2cXVEemJvX
 MEr/zRGbfJXB9N3QUlE2f4++vWjzLNcSE7o9YNsIe4ZvVFTph0Yw/ZmqUsujMGffZtrtUnEGYd
 YmuBUQWni7SI3ze6oSPvnnDQp8LnvNbxLqHR4n2aMUTfEAjW/esRPOjcmpAjl7GMzP5gM83HSz
 Vu0=
X-IronPort-AV: E=Sophos;i="5.73,322,1583218800"; 
   d="scan'208";a="10463105"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2020 22:42:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Apr 2020 22:42:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 26 Apr 2020 22:42:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReE/hKOMcUW0hfMy9qE++xo4YShbbG7/mI1UoGDBD4XFHX1mn2Y9mXdyz/Y8noJoFop85C3SFcBSmT7F0G/5AwDGB55hHnYb6GgQCZBc0Z3UgLZT3Gw1rhRYAgTYuLqg8CQLMA9oBTYx2NpvBoz8yI9f0EfHn7lAqk5QvB9Ov2OaCY1mQGmbaig1C+IVmVXhm+USuaoOwmIW76pQYtHlUdWS54kmFvHsicK48rqkp7dHQXLzf3awGq9h9dqWgMl4imdPmkkTD5Qn1dS+kCCtSbax+jz9aIHOaNPZn+n6RoEcXqKCfdpPcx9gYATeIjdJ4E0ILJpHOKk9EY1rEdFTAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXPztwT6MQ0cOPc8R6TJT6htz7X3j+tZBCEA0K7HN5k=;
 b=Hvu3ujYlklD2G7bLSLU3bYqqWEQfgLlo1AiGNBJuhCgJvEN3Irfbv/sJomyxAua2f0hYFB98gjINfG+CmrmumJNStNtzWvHWfit7m1l/5sTI5sRh4MsyegDSEIkwOtegfq43G+ZchD/VkZBRKYrzWynF316G0qT+mkSAfFfvPZ/zJgCOjW0dYawP5aF2jCHtNljxTX1+n3RGOcb303PzrFVChpO0LotBKZN7VsI2IR45sUaQi1+1TZQ8zvCoz09jK6EbqpFAa1YU0dlFTgnUEl/0CUffuFFZfALfI0ZaapAZSdgRyZ95nvxQgki/z0ZTWE/bNkdMVhlQvmxUYjKkwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXPztwT6MQ0cOPc8R6TJT6htz7X3j+tZBCEA0K7HN5k=;
 b=PC367Fdq+PRJenudaBbEvoUaxDLu/Ic+v9xfFMyYFv30vQ1GFLX7sd+kUrlkeZOICAC1sl7XZOF+TdspWTTCyH+LqcN9AtHKXoz7ihgOhiBAFQuz+kqxdFLA1GOp2bJ4lrsS2+TPHXjJQfDSioNUcOuobvqMrquGPpvVW2a+mk0=
Received: from BY5PR11MB4419.namprd11.prod.outlook.com (52.132.254.205) by
 BY5PR11MB4183.namprd11.prod.outlook.com (10.255.162.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Mon, 27 Apr 2020 05:42:37 +0000
Received: from BY5PR11MB4419.namprd11.prod.outlook.com
 ([fe80::d847:5d58:5325:c536]) by BY5PR11MB4419.namprd11.prod.outlook.com
 ([fe80::d847:5d58:5325:c536%7]) with mapi id 15.20.2937.023; Mon, 27 Apr 2020
 05:42:36 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <linux-mtd@lists.infradead.org>
CC:     <john.garry@huawei.com>, <chenxiang66@hisilicon.com>,
        <richard@nod.at>, <bbrezillon@kernel.org>,
        <stable@vger.kernel.org>, <marek.vasut@gmail.com>,
        <alexander.sverdlin@nokia.com>, <computersforpeace@gmail.com>,
        <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
Thread-Topic: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
Thread-Index: AQHWG92CIWpaopvk8EurQ9gTxEc0wKiMdZOA
Date:   Mon, 27 Apr 2020 05:42:36 +0000
Message-ID: <5187697.c9qZ1SIUim@192.168.0.120>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
 <43ae2554-06c8-59f9-153e-094a326166c2@huawei.com>
 <2955278.kW1ZWP0GTs@192.168.0.120>
In-Reply-To: <2955278.kW1ZWP0GTs@192.168.0.120>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tudor.Ambarus@microchip.com; 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bda7c15e-8d6d-44af-0fdb-08d7ea6dcab6
x-ms-traffictypediagnostic: BY5PR11MB4183:
x-microsoft-antispam-prvs: <BY5PR11MB41839EF814485AEE8F9D791BF0AF0@BY5PR11MB4183.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4419.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(81156014)(478600001)(8936002)(7416002)(6916009)(14286002)(4744005)(71200400001)(8676002)(186003)(6486002)(91956017)(316002)(4326008)(9686003)(6512007)(66946007)(66476007)(66556008)(64756008)(66446008)(966005)(26005)(76116006)(6506007)(5660300002)(86362001)(54906003)(53546011)(2906002)(39026012);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zIQwd9B43efTT+fVZaZ/8hm6zsKcg1wJlTJgEv8Ei27mGS1SadCuYWt4aMR/4tjTDNtzqoJZ3KRyY8xwVvAKz9jBcsfzPd+t5k7L45eRMnMruRk4KXE3BvkIy7JqJdvfcOUMLwNZBeHg0YyoZ4D4ry6yZTJjbbDNV8eSEUDiqKEqeVGHkExKkbA+7DoAtZaoPeScyrxnJiSBITdLBQPYPmUOa9agyiLlncu/4UkDlv9fh+u4WmBSGhDB/6vo2itOFy07iLIpc9sKOsU90UOgU0BdEG80+6kBYHYl9y+HxrsbhQigdHhD8iedv6obQb7bwOQ5+DuEk/LgSGsvmwyo0P5pUErGweYgfRRBLrI8rqZJOuwoUGrwZa8O8pFnpTHeVMSkGwOSGHKqPiD9qrg5LgV/Anj23CJUomY+d82PcFoGYWHKquFIRUcsz6MDw95tpVo5GCs/SmGGRZBp4xWAV7ggnHM6oov0NRBC/qxnuwQbmeZc5T4PAirU4nimlmIW
x-ms-exchange-antispam-messagedata: Kp1rN+JJUzDYETowqpFbYFuWOfzssGQFbSN33LB3JLYW7m8EKR8+yavUnpEd2cZPe0byhXVPTmf/Bdv3Q9e7nmzqfUi92A62JttZ8h9t76y+mkIqG/UISL8SFNoUpKmE7mzsa0WgRtYIMOSAzPtuokP2VW3EiOz7pfi8wGbWFQK6F/z1LMXF5N9vVLyzUQl4OoMHV7buwtxzUiJRH221GRYbYgGxte8EvRKI9o3kClixbLi06PW+Md3iRRn9k3konbLfQAVUJY4C9RShXZ/amjMGQbcs86t35N43HdnM+c+jeQkQrWybHLx3iYvLe1iCn+UF6vwxSTFDDamO/Tlo5+/WhcVPpLhO/VXscrPxxFFKbyFWqmE+xcpJYO6sGHb9Kcj5a7a40m6c6FcqN69UEnYmcMoD03Mh/sJxQ0/lOy+x799JRNPoZfvenRlMBTcN01jbj/VIeQvxZXH33OTEDYZClsAur/6YbJ6Ez5DSQ/DofYBqNQMfDsJOW7h3EzeG9KBUdng/Rk1d9IMjH3xljwGQZqfbcmrsaP+zZiakJJ1C8BctBlgh2lk1wGpsJXQ9xk8pN/53glNCJIxVN8vaDz88MRmBdJC6PDxQkwABbpzrWozTNXpicWMfPEEZkwNlat89Im8M6sX65KT/2D06AmTWAPDxULIGV5R0lKROkTQgP/V5RLdU5zbp93PMIXVva0LzwgswHADp5h3OfgdPUN8BZPk+lnmIV1ZCtl7omyqovyI/YZh7zuyQXUMItuolKmQ7Sg+hkhtRNIevhdhEA7NXvJ8ryV316KQft8e6HKE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E8A764769DC14947938F107C04F282E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bda7c15e-8d6d-44af-0fdb-08d7ea6dcab6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 05:42:36.8599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pa/tL6Xw3sz6qjDcwqDsvybrS7qq1QDjKQxE4OPUeBtTstOReeOSeG5U0JpqbYFu+1SlEjbG0xTMz81zZpe9JMAlS2JxpXLaAiSZ6JA1hWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4183
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, John,

On Sunday, April 26, 2020 6:15:24 PM EEST Tudor.Ambarus@microchip.com wrote=
:
> > 0x50444653). I printed the family id, and it is 81h, which seems to
> > align with S25FS (which should support SFDP). Confused.
>=20
> We can differentiate between flashes by the family id:  80h for FL-S and =
81h
> for FS-S. If I understood correctly your flash id is 0x01, 0x20, 0x18,
> 0x4d, 0x01, 0x81. According to the spansion datasheets, this should
> identify with a s25fs128s1 entry. Please check the patch from below, let =
me
> know if it's ok.

I see that Yicong already did such a patch, check https://
patchwork.ozlabs.org/project/linux-mtd/patch/1587546809-3797-1-git-send-ema=
il-
yangyicong@hisilicon.com/

> > What's more, the spi-nor probe is failing for this part since I enabled
> > quad spi. So I am interested to know if there is some differences
> > between these part families for that.

Might fail because of the page_size problem. We're trying to fix it soon.

Cheers,
ta



