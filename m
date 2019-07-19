Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D3C6E092
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 07:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfGSF2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 01:28:03 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:37364 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725777AbfGSF2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 01:28:02 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B4C9AC0AB7;
        Fri, 19 Jul 2019 05:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563514082; bh=caOVTxSL43hf+UgK60bZjNEASGtjvx2Asf778kzm6XU=;
        h=From:To:CC:Subject:Date:References:From;
        b=bwFT/c9BYoAsZvqPR+LKqUnOcvvDEbVo4Jxj25SHotQgHcO56QxwOCraDuHLA0TpW
         shypCjfkb2+vEzFtt91e56bdcQYAm3qfePzau1ksk9DR5uu/d9jMbsi2YM7Jz/NMU7
         p35FAHFFYKhU4I70XK5AI0jUMw7HvdNYoi5HZqt7zEL2pesnmsYFHmJQ/PaZFwlOMp
         xAj4dC0AsOE+BnGMRgfOwWVcKDdJGXNxrQh8sAH2+v7Yd2HC7PAOxeHw2mXp5l0EoH
         czdJaDun8IblGo3xSfEsRX7IOwQDr8a+uaz829pFtKlJVgcKS3YxeKLJqHUmb7yHbl
         E8ZuxdTSUrY+Q==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 40CBCA023B;
        Fri, 19 Jul 2019 05:27:51 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 18 Jul 2019 22:27:33 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 18 Jul 2019 22:27:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1E3hYHvjK7QlnpDY2QWsYv3rWZG1zi6AmOpOorZnSn6XDy9l7ymoPhGqzwDgXfg39a1bifxBaFrEtSOLwoak6ER67bYf5OF0r3n+5WNnZE9KFIznY7BQ0iqZqtpODBQwcGw+ZHXaONpO7yhiqwDN1/BTjyqiVHul4OL4apytMzeNCoJ0YeW0xgsxXHjWqcHxQVosVaymPGuhtnTTW94fVApVanPH+eR9CJUVsHC+T8kI3qT6hx07s0LIPsNnmzYjI7GvIt80nQURCD1Lrg5X+aFlALk8/HftTtbBIOO+xIxMNteDUOEdzq1+6USREUgS3pYTItLj5JZhYhieiFglg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxzE49YI4rFYY9HPbCi30y3Gqh210HXkODZTHPVHV4A=;
 b=NhML4z3gv+21IdthZs95qu2Lh+C0OI9wvSe+ntkweDV01zTrfaBDoz+EgiQRZqHcSXsOgBjBGIkrWgfJKzQnPuNosVmXnIhnk5igAVanLjoLTm9JWWhvlTjiF07L6jO1yWU6yV3fJVUjSrKspm/0NS8dE5XdsQendkFm1H502skNPbGpEo37T88CByiNmV2hsau9AlqP7lp5jqiJlOJR98rqs+v8IypS8ffLerh63e4C+RhhvbznhrOeBbKU3GxnArF7xwqPu7NA2CIfISfgaDzPU3rMotQRikVDZ7wP/LFJtwMcNCrkWbyRb+EtDHf9nmQERQp5PRxFY4Trk3WBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxzE49YI4rFYY9HPbCi30y3Gqh210HXkODZTHPVHV4A=;
 b=ramAMNvSDDQRg6m1Z3SnsxXH9o0IzyaErPa8rwyz02jIF6wHeBOL7+g/AwIgeSWASsRvnWrRVV7zgphLqiQL75ZnM+t8atTD5SZLbC2JN+s85l8V7ygQrfpsrdWDyRqLyNLbu3+dcJKdqlS+V3FoMX4fjAj6S/EH9oCjNLX5B0M=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB0165.namprd12.prod.outlook.com (10.172.78.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 05:27:32 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::8dd:b2af:d63f:c339]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::8dd:b2af:d63f:c339%9]) with mapi id 15.20.2094.011; Fri, 19 Jul 2019
 05:27:32 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     EJ Hsu <ejh@nvidia.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.1 054/141] usb: gadget: storage: Remove warning
 message
Thread-Topic: [PATCH AUTOSEL 5.1 054/141] usb: gadget: storage: Remove warning
 message
Thread-Index: AQHVPerj9eL/ek7UjUKQfQb96yJnSg==
Date:   Fri, 19 Jul 2019 05:27:31 +0000
Message-ID: <CY4PR1201MB003731626E6A487A7CFC0E33AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com>
References: <20190719040246.15945-1-sashal@kernel.org>
 <20190719040246.15945-54-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [198.182.56.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce490a8a-9d11-4524-25f5-08d70c09cc71
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR1201MB0165;
x-ms-traffictypediagnostic: CY4PR1201MB0165:
x-microsoft-antispam-prvs: <CY4PR1201MB0165930174D0B3292E1D1592AACB0@CY4PR1201MB0165.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(39860400002)(346002)(396003)(136003)(366004)(376002)(199004)(189003)(186003)(76176011)(102836004)(486006)(6506007)(316002)(71200400001)(52536014)(54906003)(7696005)(15650500001)(110136005)(86362001)(4326008)(476003)(9686003)(53936002)(2501003)(446003)(6436002)(55016002)(99286004)(91956017)(71190400001)(14444005)(66556008)(66476007)(64756008)(76116006)(66946007)(66446008)(6246003)(229853002)(25786009)(478600001)(8676002)(26005)(6116002)(256004)(74316002)(14454004)(33656002)(68736007)(2201001)(81156014)(5660300002)(7736002)(2906002)(66066001)(305945005)(81166006)(8936002)(3846002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0165;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dJOT84xHBOEGI5EkBrXMrQ6/XqEKRaQEQrwIK3fMurZpRv5VieSge7b3JcsTYFexwYYLLFktWYJEmLrcYRNr93cOoOEronMiiXcjYkyK6zgYE6YkbcsEcWEF4bCOXRX5IyecQoPXb0D5j+SxXmmyZS7pivB2dHm9+24xUXlNjBm69diCSuKIgheOErh6Cx/e3E5Zw+fdOYutHYRlHTe0X9DXGrf4wqvkF72dKnjcacMqOH5n5ZcMXn5SrlbFYm/cUxV9qPczop3NAPRV501dWofzhpSVrbAKclBc6alvLGRx9IEuBFC+Nk2Om7eLL3JZmymsWbCQZkZqTYndiXY6Dhw/+HPbQSGLgJF00Fd3WEPXRBTmh10pJ+Kf4yVNRaB+0kjz8fo393cy4+W1OmLBO+bJUiGGgfMOXxNakOIuqmg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ce490a8a-9d11-4524-25f5-08d70c09cc71
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 05:27:31.9131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: thinhn@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0165
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,=0A=
=0A=
Sasha Levin wrote:=0A=
> From: EJ Hsu <ejh@nvidia.com>=0A=
>=0A=
> [ Upstream commit e70b3f5da00119e057b7faa557753fee7f786f17 ]=0A=
>=0A=
> This change is to fix below warning message in following scenario:=0A=
> usb_composite_setup_continue: Unexpected call=0A=
>=0A=
> When system tried to enter suspend, the fsg_disable() will be called to=
=0A=
> disable fsg driver and send a signal to fsg_main_thread. However, at=0A=
> this point, the fsg_main_thread has already been frozen and can not=0A=
> respond to this signal. So, this signal will be pended until=0A=
> fsg_main_thread wakes up.=0A=
>=0A=
> Once system resumes from suspend, fsg_main_thread will detect a signal=0A=
> pended and do some corresponding action (in handle_exception()). Then,=0A=
> host will send some setup requests (get descriptor, set configuration...)=
=0A=
> to UDC driver trying to enumerate this device. During the handling of "se=
t=0A=
> configuration" request, it will try to sync up with fsg_main_thread by=0A=
> sending a signal (which is the same as the signal sent by fsg_disable)=0A=
> to it. In a similar manner, once the fsg_main_thread receives this=0A=
> signal, it will call handle_exception() to handle the request.=0A=
>=0A=
> However, if the fsg_main_thread wakes up from suspend a little late and=
=0A=
> "set configuration" request from Host arrives a little earlier,=0A=
> fsg_main_thread might come across the request from "set configuration"=0A=
> when it handles the signal from fsg_disable(). In this case, it will=0A=
> handle this request as well. So, when fsg_main_thread tries to handle=0A=
> the signal sent from "set configuration" later, there will nothing left=
=0A=
> to do and warning message "Unexpected call" is printed.=0A=
>=0A=
> Acked-by: Alan Stern <stern@rowland.harvard.edu>=0A=
> Signed-off-by: EJ Hsu <ejh@nvidia.com>=0A=
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>=0A=
> Signed-off-by: Sasha Levin <sashal@kernel.org>=0A=
> ---=0A=
>  drivers/usb/gadget/function/f_mass_storage.c | 21 ++++++++++++++------=
=0A=
>  drivers/usb/gadget/function/storage_common.h |  1 +=0A=
>  2 files changed, 16 insertions(+), 6 deletions(-)=0A=
>=0A=
> diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/g=
adget/function/f_mass_storage.c=0A=
> index 043f97ad8f22..982c3e89eb0d 100644=0A=
> --- a/drivers/usb/gadget/function/f_mass_storage.c=0A=
> +++ b/drivers/usb/gadget/function/f_mass_storage.c=0A=
>=0A=
=0A=
This patch may have issue. It was reverted upstream. Please don't queue=0A=
to stable.=0A=
=0A=
BR,=0A=
Thinh=0A=
