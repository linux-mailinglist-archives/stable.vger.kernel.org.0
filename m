Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA7CDB04E
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406533AbfJQOn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 10:43:59 -0400
Received: from mx0a-00328301.pphosted.com ([148.163.145.46]:19480 "EHLO
        mx0a-00328301.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403882AbfJQOn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 10:43:59 -0400
Received: from pps.filterd (m0156134.ppops.net [127.0.0.1])
        by mx0a-00328301.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9HEgBQK016867;
        Thu, 17 Oct 2019 07:43:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=invensense.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt1;
 bh=gfB5VYvy+0a4f/1IH1t9v0G9TDT9uahScNJpQCD7QEU=;
 b=zQcyFtgbjRgLN8RupO++M3ToSu+Fgn9RNgvWuUy0zpRw/+N0Dhp+n/IJy213x3dMreb8
 ChsFVr+k/LOLwCXNOWuaQyXSOXnVIfS0uPNMtcScXuCjsyR7R0N12BC8qnOdpyBabyN1
 DIhYQy1kIWepmLCznHXysZFn9yyXQcZ2Efqey2d30fYVr2XAE4/U0i12ilB+Xdgfr5Hi
 VEedz0yYclgZKakdlbxV7Vzm26IwA5GxqHPLper62kFdWooF7IYrmsAvF09SEIOTDsUv
 Uz8m7DtqHBmmQjPw9OkA8VfZ6dqoBNzN8hgsyYqxN+S5FjDRSuq3W4w44s+46drfofgo Sw== 
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53])
        by mx0a-00328301.pphosted.com with ESMTP id 2vp2608npm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Oct 2019 07:43:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYmZs65RbvbCDVxDtRqwv+4iPfW0g7/IQE7TxdLJBLWo3rC3zpryc8yb+bjZ9/hvwUYyXAi4Nc8lYZsjLFW1jwQ3oCrUVmDRV6iSkE5ybNE3qnA2PCTZwFTHWJjFncNpDfQIBryHW99oTy12qkoLjXv07ysd2XHHvNueJMyazP11/iFuNMRNOA/YdmU6vJbG4JZVDx1ypKjFo8FXrbeLro8VrNPFzdHKJ9DDmSsYU4DdpO078aZXOJrIo5N3NQYPdbTEycF6CsQBoZ/WBo1DY3sOertk2agFqa7QrFcVFpl1yr+5DLD6b909okiX6l6v2z50XhbzbUZGUDYkZAvhBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfB5VYvy+0a4f/1IH1t9v0G9TDT9uahScNJpQCD7QEU=;
 b=NEYv4DY99LCkyn+S8P67m7DSNdZUO8Xx+lGo2Qj6wIK3vW0X+OoWJJROjG8nEvNvoLj0TAWYG5xI6UhCPVt+yM6hN1c+fXm7jIdkRecJq17g95qAU6tOAuThnkbZcXgjK0yxSp758/qJ0wPSxsKdpLt5FcFjyKgmLGdL0tZeqkiz1nbNV8qh+aBhUSJOLefch8PIo6R6vxnylY7fIsTz/ixPRestICWJFKUXsLw/k/gahh2JYrv7pz2FmBx5IfWXfY9CYYhAfjviPOxP3DT8uMrdyCjFIzoBJFP15IkgrD1T9P9U0wtjgxt/CA92ZEx9ZtidXJkBHZhX7UB4hjVRCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=invensense.com; dmarc=pass action=none
 header.from=invensense.com; dkim=pass header.d=invensense.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=invensense.onmicrosoft.com; s=selector2-invensense-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfB5VYvy+0a4f/1IH1t9v0G9TDT9uahScNJpQCD7QEU=;
 b=AQ/GpWzXwzfdH355UvKugHpj21MJ/piaoYhMF9Cz8Ubju8jusJgQTy1K5GNBM04nDG+3MxLYrnQPrNoPI0Z85SfQXAhBXKFSN1W4TSMCrWfKKJc1EwDgsTg4D4GItc6K2nNeeyNT0c79lbDD4sbVfnjQsLZxmuYBb8Mzb9k7GjA=
Received: from MN2PR12MB3373.namprd12.prod.outlook.com (20.178.242.33) by
 MN2PR12MB2942.namprd12.prod.outlook.com (20.179.84.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Thu, 17 Oct 2019 14:43:55 +0000
Received: from MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::6848:adab:f1a6:ed5c]) by MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::6848:adab:f1a6:ed5c%7]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 14:43:55 +0000
From:   Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
To:     Sasha Levin <sashal@kernel.org>,
        "jic23@kernel.org" <jic23@kernel.org>
CC:     "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050
Thread-Topic: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050
Thread-Index: AQHVhDASArllQyaXq0KVhUVGPYjiuade5s6AgAACviU=
Date:   Thu, 17 Oct 2019 14:43:55 +0000
Message-ID: <MN2PR12MB3373BC1DE5152A4546940EB3C46D0@MN2PR12MB3373.namprd12.prod.outlook.com>
References: <20191016144253.24554-1-jmaneyrol@invensense.com>,<20191017143142.489CF21848@mail.kernel.org>
In-Reply-To: <20191017143142.489CF21848@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [77.157.193.39]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07b69734-4b3c-4681-3726-08d753106f9c
x-ms-traffictypediagnostic: MN2PR12MB2942:
x-microsoft-antispam-prvs: <MN2PR12MB2942B01E291B08100F91BC06C46D0@MN2PR12MB2942.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(366004)(376002)(346002)(396003)(189003)(199004)(6506007)(52536014)(476003)(2906002)(11346002)(229853002)(5660300002)(26005)(2501003)(186003)(53546011)(66066001)(478600001)(486006)(446003)(316002)(54906003)(102836004)(110136005)(71190400001)(86362001)(7696005)(9686003)(3846002)(6116002)(256004)(66476007)(66556008)(71200400001)(7736002)(66946007)(76116006)(8936002)(33656002)(76176011)(6246003)(99286004)(66446008)(5024004)(64756008)(80792005)(6436002)(91956017)(305945005)(81156014)(8676002)(55016002)(81166006)(14454004)(4326008)(25786009)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB2942;H:MN2PR12MB3373.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: invensense.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LiMfXUt6+3gjovCjR2q1bhoTrvBgh942qGyQ3BQVAG317ojvOaH0m8DiU9Kd7MXmVQL/ukxlR9RbjGZrSg/mIiwYdZ+XtRh+Dqwy5FzsAA7Iz0N1s0e3i/+XKNZ5GVUoBenIHtPtNVG9jhR8e3ky/pbcLvMAIX1h3JSi42hIoc4dDZ6Bg7dd/XiVP32JVtEhhGZDaDSG0lOab+IrENpma3PvD7+5i1cRyKSRkk0N6T1pttW2mhcl8MzmbhedGM6ZSTeIYRHRGGZwkJlkxxi2JpAPCcjoq9CjuZ0h9Jw51P42HoA8SZBYzY2gzc/Ft0ak6GSElSV7rd3x0CqAt1ENUMooV1kbNAAhMw93m1Jp+T106OQndR+dKWcBeo4efLDXCwchSHREDqz5i39ONuXLkMSNrTemE7E6YvkJ8Kipddo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: invensense.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b69734-4b3c-4681-3726-08d753106f9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 14:43:55.1916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 462b3b3b-e42b-47ea-801a-f1581aac892d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Tj3zTzuNKWOAwN8c9mtC/LzP7N6FdUQUgYV5YwpDWVd0Ti9lGGVPTOIchcYrXg72Agnsf/VKWCI1963gihhaqyzaRJ8OakHr85UQZRFvDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2942
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_05:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 bulkscore=0 clxscore=1011 mlxlogscore=999 spamscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910170131
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sacha,=0A=
=0A=
I can do a specific patch for backporting to kernel 4.19 and older ones if =
needed.=0A=
This is really simple.=0A=
=0A=
Tell me if this is OK for you and how to proceed.=0A=
=0A=
Thanks.=0A=
=0A=
Best regards,=0A=
JB=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
From: Sasha Levin <sashal@kernel.org>=0A=
=0A=
Sent: Thursday, October 17, 2019 16:31=0A=
=0A=
To: Sasha Levin <sashal@kernel.org>; Jean-Baptiste Maneyrol <JManeyrol@inve=
nsense.com>; jic23@kernel.org <jic23@kernel.org>=0A=
=0A=
Cc: linux-iio@vger.kernel.org <linux-iio@vger.kernel.org>; stable@vger.kern=
el.org <stable@vger.kernel.org>; stable@vger.kernel.org <stable@vger.kernel=
.org>=0A=
=0A=
Subject: Re: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050=0A=
=0A=
=A0=0A=
=0A=
=0A=
=A0CAUTION: This email originated from outside of the organization. Please =
make sure the sender is who they say they are and do not click links or ope=
n attachments unless you recognize the sender and know the content is safe.=
=0A=
=0A=
=0A=
=0A=
Hi,=0A=
=0A=
=0A=
=0A=
[This is an automated email]=0A=
=0A=
=0A=
=0A=
This commit has been processed because it contains a "Fixes:" tag,=0A=
=0A=
fixing commit: f5057e7b2dba4 iio: imu: inv_mpu6050: better fifo overflow ha=
ndling.=0A=
=0A=
=0A=
=0A=
The bot has tested the following trees: v5.3.6, v4.19.79.=0A=
=0A=
=0A=
=0A=
v5.3.6: Build OK!=0A=
=0A=
v4.19.79: Failed to apply! Possible dependencies:=0A=
=0A=
=A0=A0=A0 22904bdff9783 ("iio: imu: mpu6050: Add support for the ICM 20602 =
IMU")=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
NOTE: The patch will not be queued to stable trees until it is upstream.=0A=
=0A=
=0A=
=0A=
How should we proceed with this patch?=0A=
=0A=
=0A=
=0A=
-- =0A=
=0A=
Thanks,=0A=
=0A=
Sasha=0A=
=0A=
