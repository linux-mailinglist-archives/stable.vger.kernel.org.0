Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1126F443E2
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392091AbfFMQdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:33:19 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:19040 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730834AbfFMIKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 04:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560413410; x=1591949410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VIjybpwTwwxGIpY0i4jZ5bVde77SyFvl/oTa+5JMkd4=;
  b=ceNhRF+x8LZ8sp+NGPGEiuWuBcVa8w1qkWNQvzFmAcyQn+qlKwKQVyLa
   i6YmHyaKizM+GjEOSKHHI5D9P3f/Wsips0mG5AWKNvsjVJn9BGGM/i13K
   IAi5Ibxi0Anx07QqMsJMBKcR7su8bZq8o4a0MagN5n/0+L8kKmVsUCFxW
   b4vMDFwiCeneFCEuLiLJbcu20JeHkkNaHymGX7VYZ3IJTMcLjN49P5iMF
   szrgrjPiFPrERLSqEaR5D6K09V6ackj46COXJR0UrK7xDdGCGw61n9iQC
   RtWslBK4SQz3rLXToUZp4HUzvVsfICf0fdFtoc+DTeE4/uTImpxyHlWAx
   A==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="110448294"
Received: from mail-dm3nam05lp2052.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.52])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 16:10:07 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIjybpwTwwxGIpY0i4jZ5bVde77SyFvl/oTa+5JMkd4=;
 b=AhLGu8jqjdu+CrR5US0h4RMXY96VM/QsaT3IQQgeOr3a+crDtQy8dpRcj5uXeUwqZv/8PKrtAm9A07+kAHP8pnPYKO0LxE55mAhvtY2PVNWquxIkNhMtWapD27FCWAyJhALmjnWiXjJwGispmWfBYsELdQ69VB/DQDMJ7rqn3Yk=
Received: from SN6PR04MB4925.namprd04.prod.outlook.com (52.135.114.82) by
 SN6PR04MB4320.namprd04.prod.outlook.com (52.135.72.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 13 Jun 2019 08:09:45 +0000
Received: from SN6PR04MB4925.namprd04.prod.outlook.com
 ([fe80::6d99:14d9:3fa:f530]) by SN6PR04MB4925.namprd04.prod.outlook.com
 ([fe80::6d99:14d9:3fa:f530%6]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 08:09:45 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>,
        "ygardi@codeaurora.org" <ygardi@codeaurora.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        "sthumma@codeaurora.org" <sthumma@codeaurora.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: Avoid runtime suspend possibly being
 blocked forever
Thread-Topic: [PATCH v2] scsi: ufs: Avoid runtime suspend possibly being
 blocked forever
Thread-Index: AQHVITI9+7JKUiS0g0SPWsgtdJ5ukKaZPAkQ
Date:   Thu, 13 Jun 2019 08:09:45 +0000
Message-ID: <SN6PR04MB49255AE8236AAA9E41A046BFFCEF0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1560352745-24681-1-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1560352745-24681-1-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c09de684-0f7c-4174-71a1-08d6efd67f22
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:SN6PR04MB4320;
x-ms-traffictypediagnostic: SN6PR04MB4320:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <SN6PR04MB4320D6A16E45D661959D22F2FCEF0@SN6PR04MB4320.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(39860400002)(136003)(396003)(189003)(199004)(66066001)(14454004)(55016002)(4326008)(72206003)(478600001)(9686003)(6436002)(5660300002)(71190400001)(71200400001)(76116006)(52536014)(25786009)(68736007)(74316002)(26005)(486006)(3846002)(305945005)(6116002)(6246003)(11346002)(186003)(7736002)(446003)(53936002)(476003)(15650500001)(99286004)(14444005)(316002)(8936002)(2501003)(102836004)(8676002)(73956011)(2906002)(229853002)(6506007)(81166006)(81156014)(76176011)(64756008)(66476007)(66556008)(66946007)(7696005)(256004)(110136005)(33656002)(86362001)(7416002)(54906003)(66446008)(2201001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4320;H:SN6PR04MB4925.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8khyZlb7HHirjOHU3H/WaA2lDtHHxAJ+L5bgQb4/6fhVP2wtCiYfXWKxjx0Fpge4hKA5ioJyY4f+sVotn8ZBQfqi8h+czPe+0hsgzpnWw06Bmzk9raQ2YfjuwvRddI/LkRnJ2E6beiZoNKUpAEB6t7OEwBJD0nHLFXTY2EV4agTrc/5Xc/7O3aufmitI8o5JZBF3lzc8ySfsqjBMUt7h0cCSuwtjNHtvHgcxuILPkVSGp3b5LSaa7CRIEm+wxaH52wGgGxtsdSlgHoa2Lh4xKTFNDWKOxVF/wWkClxfpXN0mSX0F9Xpzr7n14awuJdlNZDzFQPR6deFIaoCCISh8vYQJKvXkck80qNNVSb9hlaqoqkErSeuht0ByuwBbzn0xEE72A87hhbyyKGQoBraxrqoY5GGFHAun5c5g49+1sYI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09de684-0f7c-4174-71a1-08d6efd67f22
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 08:09:45.3577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Avri.Altman@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4320
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>=20
> UFS runtime suspend can be triggered after pm_runtime_enable()
> is invoked in ufshcd_pltfrm_init(). However if the first runtime
> suspend is triggered before binding ufs_hba structure to ufs
> device structure via platform_set_drvdata(), then UFS runtime
> suspend will be no longer triggered in the future because its
> dev->power.runtime_error was set in the first triggering and does
> not have any chance to be cleared.
>=20
> To be more clear, dev->power.runtime_error is set if hba is NULL
> in ufshcd_runtime_suspend() which returns -EINVAL to rpm_callback()
> where dev->power.runtime_error is set as -EINVAL. In this case, any
> future rpm_suspend() for UFS device fails because
> rpm_check_suspend_allowed() fails due to non-zero
> dev->power.runtime_error.
>=20
> To resolve this issue, make sure the first UFS runtime suspend
> get valid "hba" in ufshcd_runtime_suspend(): Enable UFS runtime PM
> only after hba is successfully bound to UFS device structure.
>=20
> Fixes: 62694735ca95 ([SCSI] ufs: Add runtime PM support for UFS host
> controller driver)
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

