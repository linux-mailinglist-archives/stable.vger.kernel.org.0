Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEC44B6E2B
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 14:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiBON4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 08:56:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbiBON4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 08:56:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4951193C8;
        Tue, 15 Feb 2022 05:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644933384; x=1676469384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FJQFbMN+ZFFstt26jS8eFdEPRvrQzZ4rwdNEDu9DH14=;
  b=PSDrwfXNM2OAG9zz9Wmmac9t/K3bouS+TkunAtAl1vsdkkjPqNQ8wVP/
   w1xRXoiUpSfABMteIegTykf4A7SRIk1dXM9HalGu07qoHuyJW0Czq7dAH
   XwAAAjjYV10ek5Sc86GYw8YpM8oKm7fll1wZ0afq6xrSYU85bUPVrlmXQ
   X6cSP95QwXrTWtWI5kyZWfZbyDS+gjH6Jt8nOdx7TGIDdjaKliwl/FP1R
   QiC90neipWkCnlHLSqgWI0Y2cGWaewHZ6AIR3+uxvaiqLYKJUj0nZj6Hc
   BMxv+JE8nferslHkb5d7ULVtj30qa2OXbLxMblOTAUJ5y9MUSKz0ePakA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="250298090"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="250298090"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 05:56:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="703693700"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2022 05:56:24 -0800
Received: from lcsmsx601.ger.corp.intel.com (10.109.210.10) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 05:56:23 -0800
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 LCSMSX601.ger.corp.intel.com (10.109.210.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 15:56:21 +0200
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.2308.020;
 Tue, 15 Feb 2022 15:56:21 +0200
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        "Lubart, Vitaly" <vitaly.lubart@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [char-misc 1/4] mei: me: disable driver on the ign firmware
Thread-Topic: [char-misc 1/4] mei: me: disable driver on the ign firmware
Thread-Index: AQHYIkK1eugQcFyHPEaQF6vbL49PUayURk8AgABcR8A=
Date:   Tue, 15 Feb 2022 13:56:21 +0000
Message-ID: <c24005351be544268b6270ab91ca01ce@intel.com>
References: <20220215080438.264876-1-tomas.winkler@intel.com>
 <Ygt/Th1UeOkWpwlD@kroah.com>
In-Reply-To: <Ygt/Th1UeOkWpwlD@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



>=20
> On Tue, Feb 15, 2022 at 10:04:35AM +0200, Tomas Winkler wrote:
> > From: Alexander Usyskin <alexander.usyskin@intel.com>
> >
> > Add a quirk to disable MEI interface on Intel PCH Ignition (IGN) as
> > the IGN firmware doesn't support the protocol.
> >
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> >  drivers/misc/mei/hw-me-regs.h |  1 +
> >  drivers/misc/mei/hw-me.c      | 23 ++++++++++++-----------
> >  2 files changed, 13 insertions(+), 11 deletions(-)
>=20
> I see 2 different copies of this patch/email:
> 	https://lore.kernel.org/all/20220215075748.264195-1-
> tomas.winkler@intel.com/
> 	https://lore.kernel.org/all/20220215080438.264876-1-
> tomas.winkler@intel.com/
>=20
> which one is right?
>=20
> confused,
Sorry, they are the same, looks like a hiccup in a script, it was sent twic=
e.
Thanks
Tomas

