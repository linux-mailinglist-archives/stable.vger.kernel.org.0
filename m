Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A418C31D273
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 23:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhBPWJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 17:09:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32518 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhBPWJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 17:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613513366; x=1645049366;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EkdA4P3+6f4nhO1ioorMAXmDvWtLpcJI9k/w4sPLgyE=;
  b=uTNo0BKNK0GsBCywbJzFzwGXnPEOhAjS0lg6xyByhZuF53Ps6tRwwvuR
   0ykHfE/HnIbl4P655tV5ngSoWjvkuyGmCy2FRvtVRc5Tdi9T815GXc7W1
   xy3Te/flYUFmbn4hL1WcZuhQ2S6UA/9e7h0wqFdO31mgL7ntpux1v49L2
   VlPBXLDl1l5VPFHkmRYqNs3q9PQnhGhotKShv1O0kvjJ+UVkYDtK7/z8V
   WqK3InvuJOobERrZtU2GIWPBArFyMtbGdtPc2CXAs/3GZ/VMdWkeznx9x
   dzLOi4wrJIrOvw+nCkaChWmmLDA8t+9aw3eCpUDhu4vqBYFV70fsTCzdz
   g==;
IronPort-SDR: NTohzzE1iJ5dUa3ih+H6KN48LS/39yJACw7ZEXE35cLl0a31yes/NOrGczBjfk7l9wiH4bw/rX
 rOEWOwLbK5ZdpBg+QbImIse4BTy880BC6oeZ4lEowyENXwNMTEgXnBb+rpqzoaCspckWce5htQ
 x/FgC+idrDs75NVt2t3tAPJDl/mjGi6Z1ccZ+pVXUhHrHIiMhkMUQw8B3q2kaDWpEJ5COjTZRi
 nT8NlKNJosYBWk2HmxtL+2GCnTIoq0K3dYV5WsY548Z7fyHf1HO1QRfM+PaE9TmPp74nVngbBH
 RPk=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="115337157"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 15:08:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 15:08:05 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 16 Feb 2021 15:08:05 -0700
Date:   Tue, 16 Feb 2021 23:08:04 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 098/104] switchdev: mrp: Remove
 SWITCHDEV_ATTR_ID_MRP_PORT_STAT
Message-ID: <20210216220804.iadtjpg7r3masi5m@soft-dev3.localdomain>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152722.633343806@linuxfoundation.org>
 <20210216213508.GA32671@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210216213508.GA32671@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 02/16/2021 22:35, Pavel Machek wrote:

Hi,

> Hi!
> 
> > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > 
> > commit 059d2a1004981dce19f0127dabc1b4ec927d202a upstream.
> > 
> > Now that MRP started to use also SWITCHDEV_ATTR_ID_PORT_STP_STATE to
> > notify HW, then SWITCHDEV_ATTR_ID_MRP_PORT_STAT is not used anywhere
> > else, therefore we can remove it.
> 
> Are you sure this is suitable for 5.10 backport? Unlike mainline,
> net/bridge use is not removed, so this will cause compile problem...?
> 
> pavel@amd:~/cip/krc$ grep -ri SWITCHDEV_ATTR_ID_MRP_PORT_STATE .
> ./include/net/switchdev.h:    SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
> ./net/bridge/br_mrp_switchdev.c:		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
> pavel@amd:~/cip/krc$ e ./net/bridge/br_mrp_switchdev.c

The usage of SWITCHDEV_ATTR_ID_MRP_PORT_STATE in
net/bridge/br_mrp_switchdev.c is removed in this patch:
https://www.spinics.net/lists/stable/msg443626.html

> 
> Best regards,
> 								Pavel
> 
> > --- a/include/net/switchdev.h
> > +++ b/include/net/switchdev.h
> > @@ -41,7 +41,6 @@ enum switchdev_attr_id {
> >  	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
> >  	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
> >  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > -	SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
> >  	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
> >  #endif
> >  };
> 
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany




-- 
/Horatiu
