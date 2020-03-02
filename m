Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB351765CD
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 22:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgCBVTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 16:19:36 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20663 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgCBVTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 16:19:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583184002; x=1614720002;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=+keoM0aucfXAhdqZMCoRFoUtwx2od19MT0pioyUfWbo=;
  b=Us7HsuwgdGnml2gRr7NkdqICZzBIBEh+MHNWCPfzDu3H9HOUBAJnqMCN
   qz6Xbwx6D81vOUlk4B74IJj6Ig6qw79sdhaJrTRxg12ht7xgmySv6fPoG
   5lfRwkV5LU6Og1PAiONcjaHOc0GpvoBDFfRafLU0AYPSDUHFqmaQfRA9V
   fN7VDOkYtqRZRryCrB4mkzhI5OlN7+k5PWjBD/ficSyY/LWO5HMGOPiHl
   EKDk/qQPqDr3Mzx5rRRfSCAp2nLKIOilGfybUbQrFjeY+i09E47XkgDoi
   GLfp8Ib2Ul4ZaGzfIVfHXuRrlB+SQB/PBcB+sdYZoGL8AMix39a2YU4sU
   g==;
IronPort-SDR: k+0o/AERc28hYkeHjsG/vvcwDn2iTH6vsoMM/D4jn0/qIuDwITE0Jn7KeTAleA4Kr6ou2a7neW
 6Nnw1y/3OU7o0NRiXCRkbgz9R6DN1DYj/KXtV75YjdB3YNfxjv+9UiJzgCaVReBtD0VeTZQFyt
 l+vuRiR+z7WfKFQ/fvznefusMd5TinhMrhnyPU/5paN0E3HkuCQI9w8slnED5nEPTl3BKVONwW
 PltfROL0SzHvfzY6fhg0fVguX7ORyMM2n68kYaAr67z7P0VMuw0hocYAnGithaQOd5gQE4b11K
 Aoo=
X-IronPort-AV: E=Sophos;i="5.70,508,1574092800"; 
   d="scan'208";a="233141355"
Received: from mail-sn1nam04lp2054.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.54])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2020 05:20:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RM+Vwy0N902sCxOk7Zub5n08l2OJw0tz4W7wipMsnL6hgH/j7QxKenWtqwrEZ18WUhXsfAvDqkAnTaAR0inHny3w5FKYPoggA3A26mSYk0k4yvc/nuDqV2s2xrPgNByvI38QzDnucHJOrHD6NfAXUzURcamwAUIzt/rwqUzGSoFlamaFqL65SvFYz9gzdG0Bk2FKgp8Sny+shM8WuFhnUvpO9zIG2PvErCWzyQPOB3WFsbAkkIGMZhzl6qFjhPETkXS5TqaOpzI35F2hvUMI/eT+HiyUjevrxdC2esdNKjVkWCt+xJP+mDFVDHDUcDkXXDPKWWliQExEnGTUP1klzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkqrHfYwr9bxxcQVJTB1S0t0Gsgs9ph9Y1ETkmYbUbg=;
 b=MZ5vDjMJyOFmt6ijIY4InS6+C3oDYEQxftK93SHPVtibQtD75wyaRY+at5cLn/mueezjUovPy/uVdq5uaasf88zgAnsrqwtwcHwoU5JQ1Osig5zUHxVpuHON3v53+9eiL2UpYvWNKbBGkwGKfWGqrwurersDvKQ9SiUB3m5O8togtcRc2MrtQQMm5sRXyZR9Mpnk5tj6PNwfilyt4WnqTJtRq2YKiWKUtA5+QpwiPVw7XmXF0k834i79ZRUPj5gksBSc2qNZDY0BHU/mZft+3giYFwxJVGcFtM9KCszmoRh/PHpliwNx2qB/GjXqlO0NuVc+M3JKZ4vQq07EOA+8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkqrHfYwr9bxxcQVJTB1S0t0Gsgs9ph9Y1ETkmYbUbg=;
 b=OkskO2dNq6UJRYf1xS+k4Yg9l3L96zX2lUwL8FIV/sfcWvuu9LcQndn97cRmqFt3Gm16kItjohwEUa3HqyzZz0suWR5ob/CdpOImwRTJmcNYmluAVmCBbvu8m2kyYnSs1dcJ0RzCVzVezNGcSlUC6R9jh+E3QVo0Vgh/TH0yxzI=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (2603:10b6:a03:106::21)
 by BYAPR04MB4760.namprd04.prod.outlook.com (2603:10b6:a03:5e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 21:19:33 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fdf8:bd6f:b33d:c2df]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fdf8:bd6f:b33d:c2df%3]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 21:19:33 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Bjorn Helgaas <helgaas@kernel.org>, Jan Kara <jack@suse.cz>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "tristmd@gmail.com" <tristmd@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
Thread-Topic: [PATCH] blktrace: Protect q->blk_trace with RCU
Thread-Index: AQHV3Pm1sBn7cXCscUyQVcxbWOqGBg==
Date:   Mon, 2 Mar 2020 21:19:33 +0000
Message-ID: <BYAPR04MB574957E5116240523362B1DC86E70@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20200302204057.GA128531@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0e177c55-8d57-437c-9e34-08d7beef671d
x-ms-traffictypediagnostic: BYAPR04MB4760:
x-microsoft-antispam-prvs: <BYAPR04MB476017658C82CB2A30F38AA686E70@BYAPR04MB4760.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(189003)(199004)(53546011)(81156014)(81166006)(8676002)(6506007)(26005)(66476007)(7696005)(71200400001)(76116006)(64756008)(316002)(54906003)(110136005)(5660300002)(4326008)(66446008)(66946007)(52536014)(55016002)(9686003)(186003)(66556008)(2906002)(478600001)(86362001)(33656002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4760;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9coBXy7k5pagnHh+kWyK6Wwu12dl9ROtREGw6XX6qp8+RRvgKHbAweJO42giU/7MESuXGorTjp5fihnt7pwxCYnXqiKr9xDvNtUJs/bdiLQ+Hic9y0xSRlIcBBDL5jmitDa9DbCSPBzh/VxoIActcHS7AFJmyKkH2E4OVUzlQjTG4ioazNYM4ADYOQyibUVjVw0mGRVjOF5lwk5GgSMpscln1MhxNWCHfcOjpRmEwTrgTAlrNUK9L0BrkEHP9nA5e10ihmvq55Rwz2SyBsdLU5HGhrcVcOuT/V3ReoqoNeZG2b9mIlt9j2JYAyVry9Z2ShJuYDOd1USa95nxlWyMwITNqAkJ9t/z0RppLUJJTFls3T1dDX0LmZcZQ3jQbH+1AnHwXhmHVsa8ZLzF9Sb9UntDrwN5pi9ceHT5VYWjQydm6DqMMHGw7QGWoiPw0drf
x-ms-exchange-antispam-messagedata: n+RYywHe+63y+J+6VISjXKf5TK0vkDi3/KFRornLfoJdPU3l+HdyR1npmrvlS7zlAjXuWgiEDSUK/eDosKpsc1FO4GVg3QoDSdJ+oVY59I8Bllzqmn4JKP7hqmBrmPKKh4tp+c6apD3TTsXg0bMsyA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e177c55-8d57-437c-9e34-08d7beef671d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 21:19:33.1290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b5kNtw2nWz719uR7l0/tyxH4iRpF4R37U1SZk3ka5dYmaQaqazp8KtaQWiFe/NBWnsMrKTkna9xypjtxL+FQ+rrtEynjl2R5OM0CZmDlhIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4760
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By any chance will the following patch be able to get rid of=0A=
the warning ?=0A=
=0A=
index 4560878f0bac..889555910555 100644=0A=
--- a/kernel/trace/blktrace.c=0A=
+++ b/kernel/trace/blktrace.c=0A=
@@ -1895,9 +1895,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct =0A=
device *dev,=0A=
                 goto out_unlock_bdev;=0A=
         }=0A=
=0A=
-       ret =3D 0;=0A=
-       if (bt =3D=3D NULL)=0A=
-               ret =3D blk_trace_setup_queue(q, bdev);=0A=
+       ret =3D bt =3D=3D NULL ? blk_trace_setup_queue(q, bdev) : 0;=0A=
=0A=
         if (ret =3D=3D 0) {=0A=
                 if (attr =3D=3D &dev_attr_act_mask)=0A=
=0A=
On 03/02/2020 12:41 PM, Bjorn Helgaas wrote:=0A=
> On Thu, Feb 06, 2020 at 03:28:12PM +0100, Jan Kara wrote:=0A=
>=0A=
>> @@ -1844,18 +1896,18 @@ static ssize_t sysfs_blk_trace_attr_store(struct=
 device *dev,=0A=
>>   	}=0A=
>>=0A=
>>   	ret =3D 0;=0A=
>> -	if (q->blk_trace =3D=3D NULL)=0A=
>> +	if (bt =3D=3D NULL)=0A=
>>   		ret =3D blk_trace_setup_queue(q, bdev);=0A=
>>=0A=
>>   	if (ret =3D=3D 0) {=0A=
>>   		if (attr =3D=3D &dev_attr_act_mask)=0A=
>> -			q->blk_trace->act_mask =3D value;=0A=
>> +			bt->act_mask =3D value;=0A=
>=0A=
> You've likely seen this already, but Coverity complains that "bt" may=0A=
> be a NULL pointer here, since we checked it for NULL above.=0A=
>=0A=
>    CID 1460458:  Null pointer dereferences  (FORWARD_NULL)=0A=
>=0A=
>>   		else if (attr =3D=3D &dev_attr_pid)=0A=
>> -			q->blk_trace->pid =3D value;=0A=
>> +			bt->pid =3D value;=0A=
>>   		else if (attr =3D=3D &dev_attr_start_lba)=0A=
>> -			q->blk_trace->start_lba =3D value;=0A=
>> +			bt->start_lba =3D value;=0A=
>>   		else if (attr =3D=3D &dev_attr_end_lba)=0A=
>> -			q->blk_trace->end_lba =3D value;=0A=
>> +			bt->end_lba =3D value;=0A=
>>   	}=0A=
>>=0A=
>>   out_unlock_bdev:=0A=
>>=0A=
>=0A=
=0A=
