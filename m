Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D257157249
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 11:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBJKAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 05:00:12 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:62728 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgBJKAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 05:00:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581328813; x=1612864813;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=TkgXSNGDZU0Vo7yx9EINxn3/Sl4r1eaZf/70kynhoHFTIKSQe/zI6pn8
   RXkb0OQq7PLkm3Avea/OUOdAhD3yEQdbj/+7v+0eVhQ32vv/kUwqlcFyT
   GkdEBdEudDLBlCqoF9DHRxnuszC97a+NjyxrEDSI7igYqH8tDWgNGfe5s
   bBmzNi+DSQSYWFBhHvfP33WrV0ZC+rZ4qFGTc8IKoxmRjlL+1PDSxP0TQ
   lwxYgIyYonk8NLXHdRwJdSsA0Ly9CIwefiXXN25Nw8hcEfYt2pJ6dtg0+
   kw8ags1i2CVeFDERTNCAolcBvA5Ogpyz0FDMI9VvmQzzwgB4frmodf70A
   A==;
IronPort-SDR: oVAFj2xvdhqOnaPJl9o4eSj1LYinPNsVF+JgBirPQ77ibVZkiikARNsZMimd//fayMjQWZDb+r
 c/o6NfNkQ+31RC6TSX6DgmNWTIlAUB/BumadnIyyWMZuco/CKjN/JcZqlZAf66zmaxvaCWrx0C
 5oohj/yMBDAbXHNntql8f04iG4Ay+U/5ExpBoGT2z88F654bCtyRwIllcW3uF5UmYN2CsrUkIR
 ZpDY7CyhQ7Kocmbr5xCGFMQS9SYWHkhaQn0f+0Br1Ri6czp86+qg00PMKicwntjP5uPJQ2i3/D
 RIg=
X-IronPort-AV: E=Sophos;i="5.70,424,1574092800"; 
   d="scan'208";a="231282466"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2020 18:00:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNoSK7Di8t17Xf9R0rHF5QQl/rs0FloPl7QFtovVJoezsOq4MreKzijk3sURA9loES92bNfPEQUQLHTBGQ4DByWco4kLOagFPwYk66wCsl/O/UP2j0ztWpYVE4ggqrJvHXDqNwM1UhnuIPz14O/2WkF3puE/R+GHgC+J73D8QZN0eLMRrcyL0XjOGOqMMpntFbAJl9Zahdl9gTp3NU/S9YbvPK6CmIdt7uI2ZwEYfnrJ7EJXlHjCEAndLQZoC4ILSthxDKEFUzDq+pe1AUkkBvQh7f2VkEWzECEsDXxmCGej80IR9lm2PA6Vswi9IVCKhevjVtWQXie36tfZ7ddMvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=IPjWoGDKq+yC2XDb0HKnHuBWZstfg2pN4eVOB7F10/bVwfBa9bsn3+LHrsYNHGLYh9sLGdFfrSRFlLm6Zmin/ahZjInL3psZU3s/9zEswzZfT7WW/JmVMhvI21tb3dEm+RABsY/dsZSCX09ibocoQXQZTRIvUuF6+DbSX2UKRfNp/FB4ufxC+Fk2N1VXIE4/LKn8VvOa9UnANvskKHFrEKS69FRAV3ywHL9raHCRRQ0BUUpp952JwGVF3HiwG/ucMnlS5e9C2eZot8Y+/0IDuqWs+FyYRSbuqBDll/xeETG7zz5SYsnrqsxdGSPxi58JDmNNrI69frU1OqA3jP8VjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Sp8/82MLqr//kjgDaJil26BbtWwyt00I0LwbxOYALpbFYoquJBc+v18j6RMVGkZUBrFPaMTUbaIDkkFoF7zUHNzbsHWcttsHl/W6t7T+e2p9oynCC/WZNhKx0syUDWmqI9gYXG9bi1r2VuAhfuxHGf1gJ8DfBESrR26xNFGfq78=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com (10.167.139.149) by
 SN4PR0401MB3695.namprd04.prod.outlook.com (10.167.141.160) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Mon, 10 Feb 2020 10:00:09 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32%5]) with mapi id 15.20.2707.028; Mon, 10 Feb 2020
 10:00:09 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     "anand.jain@oracle.com" <anand.jain@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: log message when rw remount is attempted with
 unclean tree-log
Thread-Topic: [PATCH v2] btrfs: log message when rw remount is attempted with
 unclean tree-log
Thread-Index: AQHV3coaHiMJK0ZV1k6NOzl/qXT7jA==
Date:   Mon, 10 Feb 2020 10:00:09 +0000
Message-ID: <SN4PR0401MB35981843C5C5BBD1F0A7E6A79B190@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200207151955.6647-1-dsterba@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b1f16f0a-d7ec-40c3-59ee-08d7ae10037a
x-ms-traffictypediagnostic: SN4PR0401MB3695:
x-microsoft-antispam-prvs: <SN4PR0401MB3695E582D9820CDBA72D4F349B190@SN4PR0401MB3695.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(558084003)(81156014)(81166006)(71200400001)(66556008)(91956017)(66946007)(52536014)(4270600006)(66446008)(66476007)(64756008)(5660300002)(86362001)(4326008)(76116006)(2906002)(19618925003)(8936002)(33656002)(8676002)(7696005)(186003)(54906003)(26005)(9686003)(478600001)(55016002)(110136005)(316002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR0401MB3695;H:SN4PR0401MB3598.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MkExdGUQ6yQeURjgzX1OAeLt8z0mVrNSD1+55uuZ+QxlRE8hD1j0H3ruwa4qMp8oTCe2ajBG19d9CPKjXgfHsVAgYo/mNfdYL8spw+H+I2c75lYzmBtAnJtP9odctagEtYd0lzjAIT09aVorV/VANxnJPFRRBvgHwnlATxfbL4Zfqza90NE4+vHGCzMzw1/YueSd9rKSszuhw/bN2AJMk8kAhz1/6j/pT+C4coyoOg6nnyj0xYklYtpOGKIJMg+NuqLwD2EUFr2nYXpasmxI85PO+6AHFgOYnZzBOu5aB0PPcY//EhYCXmoCROG94ks1ejvUs480gFR9Rt2A6Zvzkntwl3vXllIbgzGni16k2YoCwJSxEuCOBJTE4jZlAjiCKnlg69GjVAxkTOO65eOOqmxWHXdFpOQhXY+MluZjItrnZb17s+WvquCFPaB3ACoI
x-ms-exchange-antispam-messagedata: 7I6k2vQdp32T4C+0nWaQ71L/a+c4RMhav4EvW6hQKNmFBJCGTtE2iK5vBNtzeCKBF82saRKELf0lYiNlSUpYwID3OTzLNHaXAttZG9rIf8RUyPGXIDN2sN7tCXQfuYV9f0xpReXsGobFtqbJYKlfXQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f16f0a-d7ec-40c3-59ee-08d7ae10037a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2020 10:00:09.6194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIIOFfxGwJyDuG0rFFctPcnAjqRHVDvjlMqZgBomu8MRfieV6gsoChoyZpgGAawH2oKOkROMP1rxXzrq1keVuTS6iyi+ltqDU/NI3O30OLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3695
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
