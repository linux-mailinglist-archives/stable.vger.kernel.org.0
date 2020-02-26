Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F9E1704DA
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgBZQwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 11:52:32 -0500
Received: from mail-eopbgr40076.outbound.protection.outlook.com ([40.107.4.76]:48645
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726151AbgBZQwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 11:52:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVFCcWr81WE+q2KcA8/+WNlRjoHnIwilTf681ccn85k=;
 b=zERmq0yiFPMC0wGIHj7FQ5EozMRNNTcC6J+2HWVqd2s+tttnm8dH1ZipUPG7Pz07PLKdwQ5KgUYX9SjyFMP04OOnoJQzT2gVdCW1Q67nuRLqsUjfyFTT4DiyuIQCl2XVLlKQLnmImyn4pDXLplaZqsf2qit0qr5eyHd+B1wzsN0=
Received: from DB6PR0801CA0062.eurprd08.prod.outlook.com (2603:10a6:4:2b::30)
 by VI1PR08MB3709.eurprd08.prod.outlook.com (2603:10a6:803:c3::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Wed, 26 Feb
 2020 16:52:28 +0000
Received: from DB5EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::206) by DB6PR0801CA0062.outlook.office365.com
 (2603:10a6:4:2b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend
 Transport; Wed, 26 Feb 2020 16:52:28 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT048.mail.protection.outlook.com (10.152.21.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Wed, 26 Feb 2020 16:52:28 +0000
Received: ("Tessian outbound d1ceabc7047e:v42"); Wed, 26 Feb 2020 16:52:28 +0000
X-CR-MTA-TID: 64aa7808
Received: from 9d48de8ce8f9.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 40EFE063-870A-4123-9DD0-72D59141AA39.1;
        Wed, 26 Feb 2020 16:52:23 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9d48de8ce8f9.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 26 Feb 2020 16:52:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAso1H5H7HxKIWoywEhZioyDIBOVkOaX58qhBZEHrWNyjyTK+3NX8EGvvmXjgaOpwPFa4JY1bhn2SwQ+Kcn79XUU5fw4WNP+E/+o+h4quxHKAc7O6RpjDPKPmEGGYswKis1xVnPyTLnjzS+8u3y70xMk6Cyk/o7ixw85x7nUnC9TNQhanwXYbCq8tp1gn8KOnWyHMAUyIuXa3l31Vo8mSHSOATSdtA/jI7lsZR2uvEnnQSAOJPyuGj3y8yoCoZK4/OhP6tOSgejpp+hVwSOZKNwKQf/zTo9ek999uiSOGswaPKpMIfCXUrHLLRSchh6xzEDqtn23YdXijyGM26Lw8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVFCcWr81WE+q2KcA8/+WNlRjoHnIwilTf681ccn85k=;
 b=a9UUee2tnufim+WHqOgyzBNrzsE84zf0dHf0nzsRtlWeFw4cLU6dTYFgJ7bonNcjTmYW+wbgh81OvRo6P6PRSMrsYsYfri28Mcmgb8KTy8vDGxa+zMz5melOiEY850pT3ODvlP26Kt7lqDBQlHXCysBX/EJFKAfYE734AMjPY+Vb/yUU5yO5Evqwgmb66QoM1z52WJakkLb6a4V9wsIZcLvJG1uVKW6v0339YmsgZ4NqOSc6OpEE0AcqiG0wl/Fr0Ax9cp+Z85OntjHC/JbPGD5jtqKl4Mx/KcOf34tb2QiiCpzxuVU51R1cAumYPLBlrGPW9M8g3Ln3SjV9rfb3tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVFCcWr81WE+q2KcA8/+WNlRjoHnIwilTf681ccn85k=;
 b=zERmq0yiFPMC0wGIHj7FQ5EozMRNNTcC6J+2HWVqd2s+tttnm8dH1ZipUPG7Pz07PLKdwQ5KgUYX9SjyFMP04OOnoJQzT2gVdCW1Q67nuRLqsUjfyFTT4DiyuIQCl2XVLlKQLnmImyn4pDXLplaZqsf2qit0qr5eyHd+B1wzsN0=
Received: from VI1PR0802MB2237.eurprd08.prod.outlook.com (10.172.12.145) by
 VI1PR0802MB2575.eurprd08.prod.outlook.com (10.172.255.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Wed, 26 Feb 2020 16:52:22 +0000
Received: from VI1PR0802MB2237.eurprd08.prod.outlook.com
 ([fe80::74dc:6713:1819:a113]) by VI1PR0802MB2237.eurprd08.prod.outlook.com
 ([fe80::74dc:6713:1819:a113%9]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 16:52:22 +0000
From:   Guillaume Gardet <Guillaume.Gardet@arm.com>
To:     Gerd Hoffmann <kraxel@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     "tzimmermann@suse.de" <tzimmermann@suse.de>,
        "gurchetansingh@chromium.org" <gurchetansingh@chromium.org>,
        "olvaffe@gmail.com" <olvaffe@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 2/3] drm/virtio: fix mmap page attributes
Thread-Topic: [PATCH v5 2/3] drm/virtio: fix mmap page attributes
Thread-Index: AQHV7LwkjpLu2iQNSEaItPZROfIBIKgtsI6A
Date:   Wed, 26 Feb 2020 16:52:22 +0000
Message-ID: <VI1PR0802MB223736CC0A877F9219E8B86383EA0@VI1PR0802MB2237.eurprd08.prod.outlook.com>
References: <20200226154752.24328-1-kraxel@redhat.com>
 <20200226154752.24328-3-kraxel@redhat.com>
In-Reply-To: <20200226154752.24328-3-kraxel@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 07625185-7287-4dd6-bc71-b5ebb70d91a9.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Guillaume.Gardet@arm.com; 
x-originating-ip: [2a01:e0a:d7:1620:d09c:e29d:cc48:6fa]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d2d2f5b6-df11-4b85-178a-08d7badc439e
X-MS-TrafficTypeDiagnostic: VI1PR0802MB2575:|VI1PR08MB3709:
X-Microsoft-Antispam-PRVS: <VI1PR08MB37090F2A945832286787D81A83EA0@VI1PR08MB3709.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:421;OLM:9508;
x-forefront-prvs: 0325F6C77B
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(186003)(86362001)(5660300002)(33656002)(2906002)(66446008)(478600001)(64756008)(76116006)(66476007)(66556008)(81166006)(81156014)(53546011)(8676002)(52536014)(66946007)(7696005)(6506007)(54906003)(110136005)(7416002)(9686003)(4326008)(8936002)(71200400001)(55016002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0802MB2575;H:VI1PR0802MB2237.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: H28jBxoVu8vCDf/BuNScEuqxN+RKU/4xgt9kPfo0ZrJNU86NiZ0sg3zmRV1y8F6oi6MKcHfwj5kjA4Q0RUiTwPs9ZFhTkZIp0sQRdmsKv4bkpEmapIZpw9EcF7s0lYGzViRhA0St5a+cWslptKlexAIE+ByVpsUx1Jg50I7/wRUvO5qm5rJz7K1KOhYcSe1oBbGRtG52Sg1qjGrjCOHwS4IgJEzkaP9RXM0K2fvSBpCqMotaZrfbTtXuDbez+HCN85xRaG942cmnvdxv0/4T1Hafo2WNnHSKCujlN1d9R5jZotKPu+mGKREOK7QdaKfQY+vSbzJNXE3kylyZE/30JioakgndAx4oERvSGbX0Bo1KLm5WlZdFRIT7dD2pt33LKMEu/i6seFrGiesDlIatoZ0nA8LfDb+/tFPJ212zTatfDRu8dQEt40qR+4+REzwn
x-ms-exchange-antispam-messagedata: HGBmvvh0Xjd5fNJRZ/IpVIQqeUxql4gHnlScZ3uIcgNua+1QQH1UCOH+stYD0YKUXsTRkKHnX/h4SCFRdEEXUZx+z9Lr6ur7f9LvxDaJ+AqaSFEyXPB8nmYBCZ8wOsjhPLqxSdFRJXzg1TQ04+GzQqAT4G2wNYvczcbP/Oj0VTPfWhA3fv4p9Izt0/EiLfYaKg8N512d8gyHmH1MXMW/sA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2575
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Guillaume.Gardet@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(39860400002)(189003)(199004)(70206006)(450100002)(356004)(336012)(4326008)(70586007)(5660300002)(33656002)(186003)(26826003)(6506007)(478600001)(316002)(53546011)(9686003)(7696005)(81166006)(110136005)(86362001)(8936002)(52536014)(2906002)(26005)(55016002)(81156014)(8676002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR08MB3709;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0691342b-d4f6-4e6b-d17c-08d7badc3fdc
X-Forefront-PRVS: 0325F6C77B
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YDZIEACBWornnMjGzhWR2dOSoQdvaMpYFKi0gzZeyTP2F7ohmnwsfY6AEM9xbns0aCIyzBgQioMjbcjGfo1S9IpTXekVYe1oeIh1EeESlM+PsGv5oYLnBfuQdYhqVLnwfjKAYwIFup6Ro81xF9bEWD2/4rRMY/wK3aQoUR1yPCYAb3y1uvo00jzro/Ip9jbBIQ5FKDY/d8vLEbAXaIb0fCKiFcTGdzV3KwCyMFA/hX8kt3iafteNXYb4YTNM04HO+zhzZe9JfhEPnZygmmTNUIcM29NmPP4epnx8mEcZGPHzOXxT6lmDFdwTqFuihZlxExhsy0gRtH9XX2zNDQ+SEhyiORwIdsfJNjWcxIS/tkpKuZzbnM4e60I/KhVg6fbAX55AG3alHYj1QHZYKVwvOALtVByye+Qpj+BNU3I81rBzZDcIQiYnkMvKH0BJgrrF
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 16:52:28.6130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d2f5b6-df11-4b85-178a-08d7badc439e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3709
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Gerd Hoffmann <kraxel@redhat.com>
> Sent: 26 February 2020 16:48
> To: dri-devel@lists.freedesktop.org
> Cc: tzimmermann@suse.de; gurchetansingh@chromium.org; olvaffe@gmail.com;
> Guillaume Gardet <Guillaume.Gardet@arm.com>; Gerd Hoffmann
> <kraxel@redhat.com>; stable@vger.kernel.org; David Airlie <airlied@linux.=
ie>;
> Daniel Vetter <daniel.vetter@ffwll.ch>; open list:VIRTIO GPU DRIVER
> <virtualization@lists.linux-foundation.org>; open list <linux-
> kernel@vger.kernel.org>
> Subject: [PATCH v5 2/3] drm/virtio: fix mmap page attributes
>
> virtio-gpu uses cached mappings, set
> drm_gem_shmem_object.map_cached accordingly.
>
> Cc: stable@vger.kernel.org
> Fixes: c66df701e783 ("drm/virtio: switch from ttm to gem shmem helpers")
> Reported-by: Gurchetan Singh <gurchetansingh@chromium.org>
> Reported-by: Guillaume Gardet <Guillaume.Gardet@arm.com>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Tested-by: Guillaume Gardet <Guillaume.Gardet@arm.com>

> ---
>  drivers/gpu/drm/virtio/virtgpu_object.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c
> b/drivers/gpu/drm/virtio/virtgpu_object.c
> index 3d2a6d489bfc..59319435218f 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_object.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_object.c
> @@ -119,6 +119,7 @@ struct drm_gem_object *virtio_gpu_create_object(struc=
t
> drm_device *dev,
>  return NULL;
>
>  bo->base.base.funcs =3D &virtio_gpu_gem_funcs;
> +bo->base.map_cached =3D true;
>  return &bo->base.base;
>  }
>
> --
> 2.18.2

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
