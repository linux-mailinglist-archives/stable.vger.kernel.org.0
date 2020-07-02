Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E06212E93
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgGBVP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:15:57 -0400
Received: from 9.mo177.mail-out.ovh.net ([46.105.72.238]:33085 "EHLO
        9.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBVP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 17:15:57 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2020 17:15:56 EDT
Received: from player688.ha.ovh.net (unknown [10.110.171.49])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 1A322139050
        for <stable@vger.kernel.org>; Thu,  2 Jul 2020 22:56:50 +0200 (CEST)
Received: from etezian.org (213-243-141-64.bb.dnainternet.fi [213.243.141.64])
        (Authenticated sender: andi@etezian.org)
        by player688.ha.ovh.net (Postfix) with ESMTPSA id 50A4A13EA36AB;
        Thu,  2 Jul 2020 20:56:40 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-106R006635b2fdc-abca-48da-8777-caba1f020980,FB3D8E5C650F7CFAB96446367E683FB3BA96C23C) smtp.auth=andi@etezian.org
Date:   Thu, 2 Jul 2020 23:56:39 +0300
From:   Andi Shyti <andi@etezian.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andi Shyti <andi@etezian.org>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, andi.shyti@intel.com
Subject: Re: [Intel-gfx] [PATCH 01/23] drm/i915: Drop vm.ref for duplicate
 vma on construction
Message-ID: <20200702205639.GB1969@jack.zhora.eu>
References: <20200702083225.20044-1-chris@chris-wilson.co.uk>
 <20200702202545.GA1969@jack.zhora.eu>
 <159372232179.22925.7779642345726039521@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159372232179.22925.7779642345726039521@build.alporthouse.com>
X-Ovh-Tracer-Id: 5337047036431745545
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrtdeggdduhedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhguihcuufhhhihtihcuoegrnhguihesvghtvgiiihgrnhdrohhrgheqnecuggftrfgrthhtvghrnheptdfgudduhfefueeujeefieehtdeftefggeevhefgueellefhudetgeeikeduieefnecukfhppedtrddtrddtrddtpddvudefrddvgeefrddugedurdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheikeekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprghnughisegvthgviihirghnrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris,

> Ta, going to send that as a patch?

mine was a suggestion, it was easier to build the diff than
explain myself :)

If you want I can send it, though.

Andi
