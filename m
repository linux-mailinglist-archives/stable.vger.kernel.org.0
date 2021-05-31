Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE493956A4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 10:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhEaIES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 04:04:18 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:17018 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhEaIEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 04:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622448157; x=1653984157;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=XYl2065Ikqw5oJgWTBQJxNWQwXRlRipt0Mx6uOm2nUpYtp+TYmE3qj8V
   fnFUACqlhvaqACIfNSSzJpOiaHOOda4ibkeRPRoe8bZqz8E4CGVLNSX7z
   +jkqpOTyqyb/f/mSxH3aP8rPcBnHSkDaH3JEQFhl9ZK+uQpipf0F7MGG1
   /BXTEFm7KcMJ1T6npgvpPkZcDSnIrB7gZv1nLgGDtgk0/SX/9xH6QLOrU
   7n22u4ojxC6X/n2m7PbZ5UCMJyZRS25bcjltHM7Zob4jhsUhDBFrEMx8a
   taFDAkHSB1dQ1080Q5PYWn3zSFJOJHJmj7Y+wwxyuq9sZutyRgdB6Ij+5
   w==;
IronPort-SDR: A2GQ8S6XKKoTv+tAMXuhB9/lH0yAMTfuIhcDyn6+18611rHoEYgtlU26z4fOZ3oucKrm4s5Z5c
 GgzpjmxfoS3yEgatTC3MOvjZ96Xl1gIQFYiW3+QK1lysB5kDTK6WB/VjvCfqg2OjnOldeJKS+7
 qOnHJiTV6HbmVaNJr0wU5CdSVIKzfmqDLL9QzGq6gt6SHeNDesDYB/bwBXunNiZbkGKvgshUzk
 98Jdle4PwMdA9YuUWgc4MnEA7Bpf5UP5MeCWpUznN2AD/85UNS7tLrZJQXAn1knZY5xK/NfflJ
 BWI=
X-IronPort-AV: E=Sophos;i="5.83,236,1616428800"; 
   d="scan'208";a="170654008"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2021 16:02:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bP3fIaC2a/+1xUluo4MYW9rX+SAJY8NJznsQGvgvMH/48wInNM9GIDndCpWHn8oGTu6ojyKrsN+3/tqdX2Cg/LPHG2Ghxt4ArbDkpgAQoluQpn/0a++iIZZiD1wGiTgf/wpaxI4UyyCYBtjkXya68JjaqwxnsKnbOnYMSQofk3ZGYcAflAtKAMHH/9zc+7c+fmWlm/x1iK+7hTsSF2b6T9NwJZh1V658Xm1LajlffR/VSDAk3vS4XGGKt9n6Hc47e/IWnfP+6BIQkNs2ELJU3basbg//BzH/Vk59Y9AgPKrI1XVgH/hwJVoY4yJMrOiH5p/XPRxVrmwwcCEjbsdmoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ZDyXwBTEO9e/GuHFjewSPO5FbsAVLg/8yCoDHUmJbkZX4JygkiV0L7DCjjncCEX4FoOpCW24sl8taVfagto+dYxzMl7jhmjbJCYrwYduzcEqHvBZAK2C80BHuxkilpYXGLSgb7pdE5ybUd59GfaDdfIwAIOkFvrqKeIV0XTMpGZ9CInleAFpXxLDL38AxGS60coyAJ7NGdAQ0K982xssC7xsbyI0YripBhfienLEyj6O5BUZoNBqKTkEmc9ETlqAMlEIfJnXWrDk6gukWuYP7YrwFuMqThYfyy3zT6FhjxqLH5ofm7lyz61WF7aEB43adYZe4A2+gkQiyVzXVZMy2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=wfp8r/NotQtO9xqZMoq+7eWHblwFs07XDbha0yQRzfeLRRxCjAqXbYozD0XJp4uayp9c+o/+tjLBJlSpO0kww/2KLCWlj2fcFvz1mYK5RM5eIZxzhbtbe4lkOY1f4GLVBXjydDSimR37/GBdWKwLW0hqzx6OCuchiRrLYS7ZqyY=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7462.namprd04.prod.outlook.com (2603:10b6:510:15::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Mon, 31 May
 2021 08:02:35 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::99a5:9eaa:4863:3ef3]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4173.029; Mon, 31 May 2021
 08:02:34 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Naohiro Aota <Naohiro.Aota@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2] btrfs: zoned: fix zone number to sector/physical
 calculation
Thread-Topic: [PATCH v2] btrfs: zoned: fix zone number to sector/physical
 calculation
Thread-Index: AQHXUsGN2+h0kUOf+UmVkonBv/6Mvg==
Date:   Mon, 31 May 2021 08:02:34 +0000
Message-ID: <PH0PR04MB741642D607188DE488BF0DB89B3F9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210527062732.2683788-1-naohiro.aota@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [82.135.86.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35d9acdf-25de-4faf-86bb-08d9240a7324
x-ms-traffictypediagnostic: PH0PR04MB7462:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB74623F74816B7CE94E40D7569B3F9@PH0PR04MB7462.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HoZ88tr3nUEuiotd+pufWtCT4tw+C3ccGgFmd4dpqY0xia7zV8M1/EHdT40l2GgcQldVFjBODhoZAanHng2dxAyo3WrerX0MF4YA3xHZKli9RyyVabPK2O8cGCU9Lu02VhCH0JEo2etTMbQD6UDN9uf61i0vCcdxNJp6gzC7bUTKbby1x5AbZDmsmMGV9p/mosRgjXlQ87D9m0EOE/l335ydxKc1yBzQWKSi23EWShmn2ua/tMjl1vGMBE6UJ1vMwp8eLk+x9cX2LUHTC5ZM1s5cdwGIJ+pFMiX86pdPcBsrO/s9cJw6ILXhzpjN953SwZTOruU2uh7CgU1dCFqFosUidzdpErDTQgOPM/Wl+GIz/2pJeAKrBB0EMUYaNi4oYKaA89jX0+nLvCXUxxqWiIr2kUmqm7Ro3ETUE+SF+ex2TcJcxHmXfcTV2vBvwPh3ntxjWkvZEkD04T1uvmO1UnV3jF9EfoKRtEdK5bUUnKO1gLcOBp+B39FgLK659ojhmT6bG3m83YswcDEZ61yCkO9jsMPehm+8wIkvRTBpKoiM8iBpROxHF8JMuVu93J3koyJP2yk2O5U5QDfljxEX/Hlrwm6sPuVjSnQSSI8OgCg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(110136005)(54906003)(2906002)(4326008)(186003)(38100700002)(33656002)(122000001)(66556008)(7696005)(66476007)(64756008)(66446008)(66946007)(71200400001)(19618925003)(76116006)(91956017)(55016002)(316002)(86362001)(8936002)(52536014)(26005)(478600001)(6506007)(558084003)(4270600006)(5660300002)(9686003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4EepdWUCbaRvBtbiS1HXx3L0WwI5D8Jn+8ZdXt3O1Y9YP1LrE0ef1NPuTAaZ?=
 =?us-ascii?Q?IkDCOLvLxkvIuXkrltQuOFQT+W35W01sXrS3AlNIvM8sOtN/VJfGO98darhK?=
 =?us-ascii?Q?KbnUU5bvCgVDHHqViImOJg0ij65TXcwiDX264q4ym9T/xC8MIUMuS+sIiAVC?=
 =?us-ascii?Q?GCt6zl7OVoiorzsv1rm4oeb8qfGo/WpH/Z7q5QDoQqOjswX+3MIgMD2+2FJ2?=
 =?us-ascii?Q?c/ZLGQJHf1+dnQdWz+aXE4RxEPBzCw72jKuR+Th8EciWXQ8odT/ld/lpcQ9c?=
 =?us-ascii?Q?NiqcSZPoxOX4e72+ccUw35rwnC0XotjBl+k27dEQVLe20+js589MwAo/+FdP?=
 =?us-ascii?Q?mFPPX/nO7/c/ST8dKs4SL4igj3aFl2Bjktd4gnMeqWOLPCYtjX7BPW6v0Qto?=
 =?us-ascii?Q?EJ0Y92oxfB8lvhvpE/6v7VLjCYxg8zXXcXRemKZWJHB1msaLGz+CRNjEa2tL?=
 =?us-ascii?Q?y7d3HfVQNeyVPTyh9UTEwr4muEpBaizhrDiLxzvJxDoRNpNYjDSIL+34G0vj?=
 =?us-ascii?Q?W68vaGnnQGy1j0ChANBhd8p3iggbznOnltB0FuB+ScYPOAtH7x0vYtq26Ku+?=
 =?us-ascii?Q?mJe4qlPOGuJLxH85ibpak4t/rDK1K7N6pfBMtoZefv+y3sSgcOA6XFqINo6B?=
 =?us-ascii?Q?ty1eSw3x09hVoDsonKORzQbVyEX364IM4auXrRltL9kBS0XKnjKW5lvbSlc2?=
 =?us-ascii?Q?fjB0np/07hrzCNPxj8v0ZmujlmD/NTSegD0T1YpJnHvimCUKzoGYhWWR4iB9?=
 =?us-ascii?Q?Rf0CvhdbRSwwmnfdDzKxWskndLR62meuIT93fscJUje43DjtM9iTtiNZ8aHo?=
 =?us-ascii?Q?27znlIYVQvTLb8JbPprNrYwUdnsKCZLwr9IFATPco86m6mDOMUWe1U2CBdi3?=
 =?us-ascii?Q?CtwL3+yWnvuTmgtGMMrFdcorEDVkTO0OaoG/ExkcLbbgDWsq1kbGZrTPSR0F?=
 =?us-ascii?Q?BPwQAN6lljp/Wc5Nxr3IMh22iPMcCLS2qabfxXkncixnkH1oiansEy4SVXH9?=
 =?us-ascii?Q?NAprEMgFwZCpz1nN0TqS4yut+Xq8Em/Ilay1QuxIr3x8GjLAws06FkwqXuUh?=
 =?us-ascii?Q?Szi2kAwEffbQVxKq4QVOA5mlbjC1+3S+Z3mRDkaFbxPi5VIJOmGEPl63wDa2?=
 =?us-ascii?Q?/laDbfRVrxu0ycp+Y34EItLLXcr8X5s04LsnEPAoD61Wt4C+4xnfy5Q5GU4F?=
 =?us-ascii?Q?wQrWAyRA75tFfOSbnIJdJdofA1O+InVbBKzTKC7lM7D/pu9zqppfsdRjrY33?=
 =?us-ascii?Q?HxMVs+vkuszRIlB2fg47W6KRHMCoeOGebrJnuKM4DA1B4vucsGMiMg1V2Nuv?=
 =?us-ascii?Q?EHiybuRwxBi+VS03xeCfE0GS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d9acdf-25de-4faf-86bb-08d9240a7324
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 08:02:34.7701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QXzKae8Zt3z+Ace6tZjEd1Se3SEq0u0fezTDDlEyy2JJElKdxePVIVvzzjSaIqhFPsz9CJr6uNvlgQI2YlGquTf+FMyFewmNM92U6uF3FG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7462
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
