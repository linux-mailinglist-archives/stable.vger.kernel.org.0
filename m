Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384C93B9530
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 19:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhGARG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 13:06:27 -0400
Received: from 6.mo5.mail-out.ovh.net ([178.32.119.138]:40010 "EHLO
        6.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhGARG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 13:06:26 -0400
Received: from player791.ha.ovh.net (unknown [10.110.115.3])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id A6E732C8794
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 18:54:55 +0200 (CEST)
Received: from RCM-web7.webmail.mail.ovh.net (static-176-175-108-40.ftth.abo.bbox.fr [176.175.108.40])
        (Authenticated sender: adel.ks@zegrapher.com)
        by player791.ha.ovh.net (Postfix) with ESMTPSA id 3F1611FBF86D1;
        Thu,  1 Jul 2021 16:54:53 +0000 (UTC)
MIME-Version: 1.0
Date:   Thu, 01 Jul 2021 18:54:53 +0200
From:   adel.ks@zegrapher.com
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Kernel 5.12.10 and 5.12.9 freezing after boot-up with while sound
 output is looping
In-Reply-To: <754c7a20704ffb5fa1259035f29eff1b@zegrapher.com>
References: <d086de2a793eb2ea52acb11ed143675c@zegrapher.com>
 <YMbmeRH38Wp6BHPf@kroah.com>
 <b56d3d96-70d6-4ad5-9b8f-9b6fea958ad7@zegrapher.com>
 <f454b38b7987773caa72b656c4d2e3fb@zegrapher.com>
 <YMdgev1GDhmbAF4U@kroah.com>
 <13e1cfa157a63ff5dcacdbc0c4a41418@zegrapher.com>
 <fc8c123077a4892ca0c2e0d610d840f2@zegrapher.com>
 <754c7a20704ffb5fa1259035f29eff1b@zegrapher.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <b02b1c3e8bb378da56780ee91025a9b6@zegrapher.com>
X-Sender: adel.ks@zegrapher.com
X-Originating-IP: 176.175.108.40
X-Webmail-UserID: adel.ks@zegrapher.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17536735474727462587
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrfeeiiedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeggfffhvffujghffgfkgihitgfgsehtjehjtddtredvnecuhfhrohhmpegruggvlhdrkhhsseiivghgrhgrphhhvghrrdgtohhmnecuggftrfgrthhtvghrnhepgfeiveduuedvjeffudejveffleelkeeuvdffleefudejueduueffleehhfeigfegnecukfhppedtrddtrddtrddtpddujeeirddujeehrddutdekrdegtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejledurdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprgguvghlrdhkshesiigvghhrrghphhgvrhdrtghomhdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Kernel versions back to 5.9 were freezing on my machine. Which clearly 
indicated that something was wrong with my hardware: I pinpointed the 
issue to my BIOS. I had a few CPU options toggled on: "Global C states 
control", "Collaborative Processor Performance Control (CPPC)" and "CPPC 
Prefered cores". Toggling those settings back to "auto" (which means 
probably it's off ?) prevented the issue from happening since then. Note 
that the hardware these freezes was happening on is a AMD Ryzen 5950X 
with a X570 chipset motherboard.

Thank you

Kind regards,

Adel KARA SLIMANE
