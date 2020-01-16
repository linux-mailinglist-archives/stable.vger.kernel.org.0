Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83AC13F75A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437460AbgAPTLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:11:15 -0500
Received: from mail-bn8nam12on2130.outbound.protection.outlook.com ([40.107.237.130]:60129
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437452AbgAPTLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 14:11:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwGP2ltf0LyNIPn2dRMwENABsuTrtYFj8/9/8k7ZKecxFkWvuGjMz84UBFkpw030g3Bj3ClzDQzkjTIg27AvMDe0xOwifrV6Pm3h4oI9xJQ5V+S2ogd+DzIORiA9drbi6t9PZajhv9fHutYWg+aqjqRIKyyXu2WCPvGXwLP40OwFJkx1t4wy/WbA/ddCMysPlNcfhaNu4khfKC77IN8RFpDUH7wihqpw20Sg0nyn4qnmk52CeJKHD07uzQHU/31KL9sNs/FUdwPi+SbM3FQ9trdWDaO3fquZZQ0jHN4lZQ1GWCGHVqBPRHqUfb1/JO5JNA+ZZ+9RYaUCD403fTpDyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pk4CKnA7H3LVTZPb6vK96Ey59ZMKy7QnyltmO54jSk=;
 b=VaEr3vDA9KvC5ne16YEDqpyXmrbMAqRAVAVovErWpP41AlOWaO+ixDWuma1n8ewiyUCD6o+/lGllJ2kI+QR6ZyM6eGDErzoUzN2adLL0tYAGMPyi2AXN6RH82MiK1WE8Ol1W/oJPZaySENtPNKZD+0tNN5I/GsAGG1z14mixVOMu0C/XdjDrKfunmSuGhHLVWYH4CjRsAUf187qKMHDXds5Ux8cdYtJwuhI5eejk8PTwd+PVOLXi5ZQiNeNmlHSoIfcZPGEXaSsEw7Wap6CSmWiYodBJqWOWh+lEIOvMvVijpBLqwgrOtTTyS20M3gBdDf/tv+5q1WyAPEg5OeYVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pk4CKnA7H3LVTZPb6vK96Ey59ZMKy7QnyltmO54jSk=;
 b=DfIIKlQ/FKU66VId0ctlhPohvmKWPccP1kU4hSam3zpfdflpid8hZXbGTVCRZvfFnOU6yrsLKLdd7vgRDdGtaUw4qxUPs7vlhsyH743d9j+YlVeNyW6XVUQp5gHWjnlK0lWOzS3bR9WRFDCIxvnHFN37kR5Ruf6eg5krQieDoJI=
Received: from SN6PR2101MB1325.namprd21.prod.outlook.com (20.178.200.71) by
 SN6PR2101MB1136.namprd21.prod.outlook.com (52.132.114.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.2; Thu, 16 Jan 2020 19:11:11 +0000
Received: from SN6PR2101MB1325.namprd21.prod.outlook.com
 ([fe80::5061:51b6:2876:745f]) by SN6PR2101MB1325.namprd21.prod.outlook.com
 ([fe80::5061:51b6:2876:745f%9]) with mapi id 15.20.2665.006; Thu, 16 Jan 2020
 19:11:11 +0000
From:   Steven French <Steven.French@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Ronnie Sahlberg <lsahlber@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: RE: [EXTERNAL] [PATCH AUTOSEL 4.9 177/251] cifs: fix rmmod regression
 in cifs.ko caused by force_sig changes
Thread-Topic: [EXTERNAL] [PATCH AUTOSEL 4.9 177/251] cifs: fix rmmod
 regression in cifs.ko caused by force_sig changes
Thread-Index: AQHVzJP77eNTOODVQkO1VLoRqzt7d6ftqA2Q
Date:   Thu, 16 Jan 2020 19:11:11 +0000
Message-ID: <SN6PR2101MB1325121720B1E3645F2CF369E4360@SN6PR2101MB1325.namprd21.prod.outlook.com>
References: <20200116173641.22137-1-sashal@kernel.org>
 <20200116173641.22137-137-sashal@kernel.org>
In-Reply-To: <20200116173641.22137-137-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=stfrench@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-16T19:11:10.2876097Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=97e8512a-c205-4ccd-9d56-864f4d2fb040;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Steven.French@microsoft.com; 
x-originating-ip: [2001:4898:80e8:f:fd1b:143e:cf7:7c1a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 96ebd4bd-2b3c-44bd-efda-08d79ab7d999
x-ms-traffictypediagnostic: SN6PR2101MB1136:
x-microsoft-antispam-prvs: <SN6PR2101MB1136E9C2D33BDA611A8E0F61E4360@SN6PR2101MB1136.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(199004)(189003)(7696005)(8936002)(5660300002)(4326008)(6506007)(110136005)(71200400001)(2906002)(53546011)(54906003)(478600001)(8990500004)(86362001)(316002)(55016002)(9686003)(10290500003)(52536014)(66476007)(64756008)(66946007)(66556008)(81156014)(33656002)(81166006)(186003)(8676002)(66446008)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB1136;H:SN6PR2101MB1325.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y3g5rsRt0LmUX6I8rJqyl1OjN96s/IU+XBpjvuNtYTDDEWdysqJ/NkE+BoDQJiEYCGUqzxIbcRIHFMf5hV/15lQhGEuc7In+aXwLrXRvcML0adem48M+jkHQcV/XT3QvGvgDpAAb4BNKzG4u0pmmGC7f2Z7IwI1yqawykh/h3cnu4NejZ9RfHK3hS4QdlzWNQZ+YM4qLK4yFotu8OY+kwBHe7zCJAc/szPszZQXichvUnk7VlJBLlbeROp8m9cuKh2JTOfjIUl6KiFNveo6vdQ279CtcG/mRMuX+UV4nK2kkA6gh9AsIjnNC15i4tY0qzQ2Tpsr5A9MAMEjopH0l6YA6oXtQIkSg0GGIKnOLNEfF0q9Lc5V4lcrN+39X2BQaT7hgnS1b78XOXLDopMYd84OrimtJTGmO8lTaEtoPI8voNqTHv4HXGl1Lc5squAH6
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ebd4bd-2b3c-44bd-efda-08d79ab7d999
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 19:11:11.4710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lQmTT7rVf64KtUtV0ZIyXI9MnbDxt7LvMfg8jAW8dGZ/W5ME9EI01iWkdQb/wmIuv/Ep5sN1un8sl7/mbYAErg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1136
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I didn't think the patch that this fixes (72abe3bcf091) was in 4.9 (it was =
May 2019)?  Did Eric's patch to switch from force_sig to send_sig get backp=
orted as well?

-----Original Message-----
From: Sasha Levin <sashal@kernel.org>=20
Sent: Thursday, January 16, 2020 9:35 AM
To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
Cc: Steven French <Steven.French@microsoft.com>; Ronnie Sahlberg <lsahlber@=
redhat.com>; Eric W . Biederman <ebiederm@xmission.com>; Sasha Levin <sasha=
l@kernel.org>; linux-cifs@vger.kernel.org; samba-technical@lists.samba.org
Subject: [EXTERNAL] [PATCH AUTOSEL 4.9 177/251] cifs: fix rmmod regression =
in cifs.ko caused by force_sig changes

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 247bc9470b1eeefc7b58cdf2c39f2866ba651509 ]

Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_si=
g instead of force_sig")

The global change from force_sig caused module unloading of cifs.ko to fail=
 (since the cifsd process could not be killed, "rmmod cifs"
now would always fail)

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c index 110febd69737..7d46=
025d5e89 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -885,6 +885,7 @@ cifs_demultiplex_thread(void *p)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
=20
 	set_freezable();
+	allow_signal(SIGKILL);
 	while (server->tcpStatus !=3D CifsExiting) {
 		if (try_to_freeze())
 			continue;
--
2.20.1

