Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A591CF3C1
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgELLwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:52:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:52160 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729207AbgELLwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 07:52:37 -0400
IronPort-SDR: 6D3AA5opdKfEKlWR8sI4FIPAxe3W1kq8mqUN9rAzd0ZHuvf6o7gaIPE/ANWf8IbcOiCfSwCYsV
 3acgLmf6ulLQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2020 04:52:37 -0700
IronPort-SDR: kZylTL5V+s4llQEU63EWrKN9jzu6MZZTdOjHwO+oM4SUOATU3e7hCW/UWvesc80qds/ozcN41f
 WpaPqZVeeO/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,383,1583222400"; 
   d="scan'208";a="437074195"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga005.jf.intel.com with ESMTP; 12 May 2020 04:52:36 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 May 2020 04:52:36 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX121.amr.corp.intel.com (10.22.225.226) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 May 2020 04:52:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 May 2020 04:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XITM189BKGLitQwhge/c5KDJbmWtqLpsAMDT7l5owk6MRQZmKXmLJ9MOhZ0sH5MMpkLIuserDWd9M7MEukwxwUXB7oopUYZbiCcsUqHrrBPyG/ayCSXl9eKXAMzJheKmQlJWkz4qTlkwinEXwzm21pHOCLKeIIV2fDlb5nGU1eRG68E4MmpRXyPSU37l3WnIjjQEBq9ZB02KL4PxSeYiNFwiZGgLwZJaLM9W2e3h3GHpEAoz1W6aM+SFPrL4dIurVUsR7fKP/xb4b/w6FhDZvldbpyNZiHpFeGNw/D2+Pqdo6geaxtN24rX13eJM9wqMwTW6aEC9eYojehGApZ2ZQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJDTUpbsvtiyhLL23Jbgc5dLEV9a1O1ewos/8PD4NGE=;
 b=NSe0IJhYevPvVFVz2hXogbQWjV2WPnjOq96GuKFcUHrNrcqBGYveSueMg+BKdiYTI8pQzjAZR4FG+ALE8wdrPeAmpdvbLaKOS/uLGKc5sQcGyNKE8MqoCUewuDanEEdn4OpS2CQmu9jAiiY2JCX6t+PWQR0UprNmj3mniNvQDjmWRzYw171pibKBZ6dEwTIgnTzys6Mu98UPCReSFf8BV3+gs7Rv1AoZPB7Qm5HRKYWbfPCAzEnBSLbZIzOK4wzwEfSl1O0wUfHQukb23MXhhnYIJ0XPjq3p8Yv0s21fH/ZMAePJfLMznFgug7X5RknllskpoY2NIdfwgKncLsb++g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJDTUpbsvtiyhLL23Jbgc5dLEV9a1O1ewos/8PD4NGE=;
 b=vTnphUvquCBu05BncYC9zZyFsyawgsVI+TiaiRx9IA++QBToD0kdBbAo+xjQvnJGTEeVtcwfCbTrFS4+Yw+CGSx5QV4osXjQAImjz0g+CYrhk0kQh3EiQrYUMKUxZnikBUecwIsZLuXcW6bKuOqNIQCkIvoQNT4Y//46FIjKzuo=
Received: from MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12)
 by MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 11:52:34 +0000
Received: from MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::29b3:892:eed1:2d0c]) by MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::29b3:892:eed1:2d0c%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 11:52:34 +0000
From:   "Wan, Kaike" <kaike.wan@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
CC:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Thread-Topic: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Thread-Index: AQHWKAtYj9gYAc53PUOvXaZcprmNbqij88GAgABfNtA=
Date:   Tue, 12 May 2020 11:52:34 +0000
Message-ID: <MW3PR11MB4665BDCA7CA57498D631FF5EF4BE0@MW3PR11MB4665.namprd11.prod.outlook.com>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031315.189865.15477.stgit@awfm-01.aw.intel.com>
 <20200512055521.GA4814@unreal>
In-Reply-To: <20200512055521.GA4814@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [72.94.197.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2dded8cc-d532-40ef-832b-08d7f66af5b0
x-ms-traffictypediagnostic: MW3PR11MB4665:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB46653755E8E547A756CBC8EFF4BE0@MW3PR11MB4665.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4xDaWmcki78v6XrWkmsGufvKcBgyDRZ824QAniYyRdOsoSRmVsMBcpGcPh45FjKA2MqWZc/MEWdZ3HnwcN7O1GT8rrZQBbygeNAytPQqzi1QIP6AF6NN00S6rXg1FBA1oYcG3XbYspCxI6+rVaefsXccUEIJpJ3475zSgWtkq09xIGwvTMoLnEUmgpqiv4ysf4ugWp7HQY19uojyhK4NPgRmwy8DnX5DPHst5v+MM50L1HZvDGL+E9DH1BBIGy8kcaW8PqgrVJiwJuidMHO6yYs34/puyPoXRomk4tR2kbEF+OFYQdA7qZ/yUdPEFKXs08K2f6hwbDeazQLyq+WB/6r/OmrTWYmkvhIvPeVSjhD7cVpwIx4LR5XiKsQECNxlGsVeRcSFzhXbt8WEZeTyKYlLRogWNY+mAu1XZUe4qJZ3jTwY271WJ/BDSiViuNoAaImsdX3zn4Q9o+pU0yK5U+2UzppCz09tUD7fMWJCCj3LMEKqS6/b80pDoBYqE1KXpXq2GQCRPbqdykM/oi+O/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(33430700001)(66476007)(66446008)(33656002)(2906002)(8676002)(33440700001)(8936002)(64756008)(66946007)(52536014)(76116006)(110136005)(5660300002)(4326008)(478600001)(66556008)(316002)(53546011)(6506007)(6636002)(186003)(9686003)(55016002)(54906003)(7696005)(26005)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /vcIn6ub4vzJPM2GlJaYaKW2sOt/yDEbi4hmnn+2Ul3zWzOQjzs0DbFq9qSSOAISdfh60yu05iMxKSLAsISQsEsT8qRPSGPKR7RYfktYtNoxiAkNooMyqej14m2TtluZzkkIYiSPJX2FmSs9rwQnKN5Ah8ND4rbHs912pbPc5R0qMzu2I7ZZrzM/4pOzsws7/NxQsM++8BxyeFZKU306SyPuB4NUliwwz0BoSVSBWgk0sXunYArHJXEWCesJy5wlg/myn3dx1k1KFRw8XY5tPxvu8Uerp0C2ketx42o2mE3gKlu1xdkERFBcj7JLHxo+D/6S3yXW+D87WrqZX01Pr33OdwNre+F60/9QGJH/SKWRNO16lLoEQs4y3HZZ6GSdhGWLSbHYUgj0QkU8DKqIIk8s6kjL7brY09VEOQHEGhuFae5giu2X8U1KSdOb/thPd1PREU4hoVWbiLSbfePuujQvCdGUeywC35BA1LBEsY4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dded8cc-d532-40ef-832b-08d7f66af5b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 11:52:34.3304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+s/ngaf4pKDCuv0nT+nA/1qo8NsCva+tfzoz9eTlT5CcYPgHFJVaPxnGhDWlito4igII5GxdbK0U7nT/9jh9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4665
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> Sent: Tuesday, May 12, 2020 1:55 AM
> To: Dalessandro, Dennis <dennis.dalessandro@intel.com>
> Cc: jgg@ziepe.ca; dledford@redhat.com; linux-rdma@vger.kernel.org;
> Marciniszyn, Mike <mike.marciniszyn@intel.com>; stable@vger.kernel.org;
> Wan, Kaike <kaike.wan@intel.com>
> Subject: Re: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq w=
hen
> the device is shut down
>=20
> On Mon, May 11, 2020 at 11:13:15PM -0400, Dennis Dalessandro wrote:
> > From: Kaike Wan <kaike.wan@intel.com>
> >
> > The workqueue hfi1_wq is destroyed in function shutdown_device(),
> > which is called by either shutdown_one() or remove_one(). The function
> > shutdown_one() is called when the kernel is rebooted while
> > remove_one() is called when the hfi1 driver is unloaded. When the
> > kernel is rebooted, hfi1_wq is destroyed while all qps are still
> > active, leading to a kernel crash:
>=20
> I was under impression that kernel reboot should follow same logic as
> module removal. This is what graceful reboot will do anyway. Can you plea=
se
> give me a link where I can read about difference in those flows?
>=20
I used to think the same. However, by adding traces to the hfi driver, I fo=
und out that the shutdown function of the pci_driver was called when typing=
 "reboot"  while the remove function  of the pci_driver was called when typ=
ing "modprobe -r hfi1".=20

I am not an expert on kernel reboot and can someone give some hints?

Kaike




