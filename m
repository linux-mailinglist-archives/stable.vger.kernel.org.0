Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5421CF40F
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 14:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgELMMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 08:12:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:14451 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgELMMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 08:12:20 -0400
IronPort-SDR: 8azslPMXDczy6mc+58q/mZ+H7wwTBjCm2dsvdwr6GbczwQ6juiZzgCqhE28vqr6kOPpXld2YN8
 2vW9O8yyGQJg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2020 05:12:19 -0700
IronPort-SDR: yo0G7GOG1QEVdhUUEBIxL+KuwesveUvfhex2c7OI2qzALoBvETfSuKj6ip7/PkxGz+MUS/EEb4
 LW39QS4AlwoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,383,1583222400"; 
   d="scan'208";a="280113930"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga002.jf.intel.com with ESMTP; 12 May 2020 05:12:19 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 May 2020 05:12:19 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 May 2020 05:12:18 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.59) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 12 May 2020 05:12:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fn9HASwennj3cma4WpcfwqSyB2yFEXQKz7DNG8go8uoaxfBcfun3AcrD8SlBW9S8JXmW0xmba03jF/t44iA43yYm5h72QtAuoI2V5pgTmDCHfu9sxpXe3CaZHAfhRSRe39zsB2qjwkZ0DqDsxe6fdIh0yeBhZk7eWHLCAZWkFd+rstIs+1Eav8BnC8zo5HvOG4CuZ7mwxdNyAvWhcRhcLTc7A3kA5O4qjbyoDfCK8T7rf9qXrZFoA6T2U5PK5si2Iu5W4b18uT8lT7SdoLCsywn35cja853YyGlaS+wUmkGx5bNVaaltugbDZN4BOfeqdgSSeiHM95lHoWqW1vgVdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afbWgLbOHMLhbQtDMJC/lVJOtcuRswdFGAnfzpxia54=;
 b=k5cbdMTcVWXO8rjchhW5SSFVP9HDqY3vwduMpHzHk1Gcv9oMPs2bDF9bQJ+1OooFRIjRg1ME7sGXp/R7rrq6De3PDGetjFVbi0ImnSHzPqtQVwgdWSgvXlt2y2vGOYu5sD2YXYaUI/XFCQdVOYc9zmmMSZKFvTTdQ9jRUhsqYV4yMre/hmeeZV3zNfu95amGvlscNpp4hblZBqTnDaicb9WTFV3FKe5687ZdLjC5mD1EbEBkLBYpGSJFBXKVzeHADypst7PUa5g3in2B0iIomt7AdhJogUhfpKcDhe1mpf/7Ms+5a6UqDGvpErJAFzBpYTqlAdXUr3MT9CyRUG4bEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afbWgLbOHMLhbQtDMJC/lVJOtcuRswdFGAnfzpxia54=;
 b=iBsGw6Nyo006jC8mY6vNELfkx1JCJUPeFiwuP5dnHg6nE7DJcXX7VSpug1SkO6APTaq8079UtEPhAn3vGwRCptHU3zI1Co/qnlekbxVwsqYh7S/BjKaGMxaTYmi/9TXoKspl+MBpv6xU06UjwwC7QQpd4W2l8l+8QV5NRy0wiv0=
Received: from MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12)
 by MW3PR11MB4586.namprd11.prod.outlook.com (2603:10b6:303:5e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 12:12:16 +0000
Received: from MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::29b3:892:eed1:2d0c]) by MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::29b3:892:eed1:2d0c%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 12:12:16 +0000
From:   "Wan, Kaike" <kaike.wan@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
CC:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH for-rc or next 2/3] IB/hfi1: Do not destroy link_wq when
 the device is shut down
Thread-Topic: [PATCH for-rc or next 2/3] IB/hfi1: Do not destroy link_wq when
 the device is shut down
Thread-Index: AQHWKAtb4SDOuMje+0itVYfmcswHaaij9DOAgABmr7A=
Date:   Tue, 12 May 2020 12:12:16 +0000
Message-ID: <MW3PR11MB466560A064FEC945C680DE14F4BE0@MW3PR11MB4665.namprd11.prod.outlook.com>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031322.189865.4129.stgit@awfm-01.aw.intel.com>
 <20200512055657.GB4814@unreal>
In-Reply-To: <20200512055657.GB4814@unreal>
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
x-ms-office365-filtering-correlation-id: 35875ad7-9456-4e16-ca85-08d7f66db66f
x-ms-traffictypediagnostic: MW3PR11MB4586:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4586F07BA0927052725E6277F4BE0@MW3PR11MB4586.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QTVBFDSB85UTctL7ITtnBUCPT6tV0AqyE/89CGw6AvzVivsnkXmzbOkSaRa675WMuOuBjZCpfIPUEpmtIjKIQwid+ukzvpDXbVKr8TCF2Efn5SL4Iyq8K9/wLhqvJ+3zZnG7zvPpXmrzP0Jklu9yVKc7F79rWTieIHooHYO1/bVzMKj4fNifBGubZML3cGS1FyFAlh24pHfZREdYrKgx+znEcxyMbPnWWYdAFK0BklnyGmIVRpoiHsf0CkVxnA38j7sZL6+PEbE7+2VAzNwavHf1vBVhsA6bSvRUZLt0SzWkSXwXjowXQejblR38jPYkSkjsPixBBv7BwnwbztJzwqb5IwbC2V1zylimJ0nE+dBn3eSfgocECag5OOjfavJGYNmLOqJQSpt4OqYqXxhCvqFht5WPLRNdChD8N/nAuR5Fw1rzrNcrV6PTEw9X2EaQLCMtcLAty6N/YDp8iU2FObRWN7//1Z18z2Z2XlGN4S/00W5OLIO0e5ozsH+ZHD+O+Kv7g+ynCiLIwIxPU4/jIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(376002)(136003)(366004)(396003)(33430700001)(6506007)(8936002)(478600001)(66476007)(64756008)(66556008)(66946007)(66446008)(8676002)(33656002)(186003)(33440700001)(6636002)(76116006)(54906003)(53546011)(110136005)(4326008)(52536014)(316002)(5660300002)(86362001)(2906002)(71200400001)(9686003)(26005)(7696005)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vRxvduOZpQlcJwkygkX/nc/8Q6X998Xe3TKGvNc3UuCPG2//yI60imXF7qC2mcXomUtztelDezZa+K84qQ2fnZGH5xwMG0MC730alIBdXfJM2EjZFMySEEGMn0010XIRcPLsZ1AXb5F4RUcOayTyFbtLHuz//TKD1xvmVVPnQenUHQb6h4uy0nPF1ewiwd1PCaKzwEairlOy62B5w8u4lyC8h4sICYlnyRps4WeWLw2rHbEqW56lOhJvbh28/v/i5PMh+Vc52s+CneGQH8M/tsRI6PxyBvBjYsBpNQpbBIzYQ52b9RcSmcqoYTbVai7p5dyMs92aBf84RAuApfa01UFvy3ilc0Q0bTSWSO5eiTLr1DHfvC6LOtLosVG7bPIrDF+BOqcgCRM01wzwCjeEhF74P7axnl2Aw2BHP8984hUxgkSA5OOiLWScr7rjMxoPAUlz2/7uZjBCXJu7J7LpQ+hxsDWUvkkhdJSqw3vJ9i8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 35875ad7-9456-4e16-ca85-08d7f66db66f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 12:12:16.7767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E60tyjRwmijNsu5QqVPYftIgfpeMkkuP0be7OpI9tiqzBsk0XyrnawQ+M1Uw+d9fjFUP5bHAobrPkT/9cUgrmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4586
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, May 12, 2020 1:57 AM
> To: Dalessandro, Dennis <dennis.dalessandro@intel.com>
> Cc: jgg@ziepe.ca; dledford@redhat.com; linux-rdma@vger.kernel.org;
> Marciniszyn, Mike <mike.marciniszyn@intel.com>; stable@vger.kernel.org;
> Wan, Kaike <kaike.wan@intel.com>
> Subject: Re: [PATCH for-rc or next 2/3] IB/hfi1: Do not destroy link_wq w=
hen
> the device is shut down
>=20
> On Mon, May 11, 2020 at 11:13:22PM -0400, Dennis Dalessandro wrote:
> > From: Kaike Wan <kaike.wan@intel.com>
> >
> > The workqueue link_wq should only be destroyed when the hfi1 driver is
> > unloaded, not when the device is shut down.
>=20
> It really doesn't make sense to keep workqueue if no devices exist.
>=20
Only to keep consistent with the other workqueue: hfi1_wq. Both workqueues =
are created when the probe function of the pci_driver is called and destroy=
ed when the remove function is called. In addition, we try not to free any =
data structure in the shutdown function, which is intended to change the po=
wer state of a device before reboot (include/linux/pci.h comment).

Kaike
