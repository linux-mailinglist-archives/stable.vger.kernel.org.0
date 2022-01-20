Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D5B495479
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 19:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243580AbiATSzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 13:55:04 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:34006 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233413AbiATSzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jan 2022 13:55:03 -0500
Received: from bender.morinfr.org (unknown [82.65.130.196])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id AB9C4B0052C;
        Thu, 20 Jan 2022 19:55:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pNbjR1gimFgH1vkdj+yu4DtPcN4HiAzhg75JU7JC2eA=; b=JLXIRzW3TKHyzthwz0ivhSh3cn
        IiabYtb7YpJioseMMQf6M5xDoEB9OrzRbvfZZeEHXrTvKRs7sdhXXmLVtLsY8JD6n2OZM3Nh/XyEn
        plOhGZvbpLXt1FWLBNIW7583Y/qIfpY8ccOryoAvr0aBc+iY3RasCS5DwvBFdrMDFZds=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.94.2)
        (envelope-from <guillaume@morinfr.org>)
        id 1nAcaL-0000vi-0x; Thu, 20 Jan 2022 19:55:01 +0100
Date:   Thu, 20 Jan 2022 19:55:01 +0100
From:   Guillaume Morin <guillaume@morinfr.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        paulmck@kernel.org, neelx@redhat.com
Subject: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake() checks
Message-ID: <YemwBdpmBeC03JeT@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paul,

I believe commit 614ddad17f22a22e035e2ea37a04815f50362017 (slated for
5.17) should be queued for all 5.4+ stable branches as it fixes a
serious lockup bug. FWIW I have verified it applies cleanly on all 4
branches.

Does that make sense to you?

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
