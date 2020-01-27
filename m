Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8299414AC77
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 00:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgA0XOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 18:14:34 -0500
Received: from minas.morgul.net ([128.31.0.48]:36566 "EHLO minas.morgul.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgA0XOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 18:14:34 -0500
X-Greylist: delayed 738 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2020 18:14:33 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morgul.net;
         s=20141010; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t6etz7kZrLLFb8kbDbOp4NCRp7ChqyB2f0+ScI91Qog=; b=uZAH94f7ZUdegQ061m+urd1hAJ
        YKUVYjrUJZaC7muFXD7H6hHcydIaBpO6sCzgr6ohwyZh41utTHezEhQAy7KxxCkcTSE4stwFWMl6J
        M1S3vIIKKTWp4Iu1LsqjSrE7dEVcxOdz6SrvWHS/NWVRVnBxOaTQJCdAFqQ2LAhNN+0M=;
Received: from frodo by minas.morgul.net with local (Exim 4.92)
        (envelope-from <frodo@morgul.net>)
        id 1iwDOY-0006fe-TE
        for stable@vger.kernel.org; Mon, 27 Jan 2020 18:02:14 -0500
Date:   Mon, 27 Jan 2020 18:02:14 -0500
From:   Noah Meyerhans <noahm@debian.org>
To:     stable@vger.kernel.org
Subject: Please apply 50ee7529ec45 ("random: try to actively add entropy
 rather than passively wait for it") to 4.19.y
Message-ID: <20200127230214.GC25530@morgul.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As detailed in https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=948519 and
https://wiki.debian.org/BoottimeEntropyStarvation, lack of boot-time entropy
can contribute to multi-minute pauses during system initialization in some
hardware configurations.  While userspace workarounds, e.g. haveged, are
documented, the in-kernel jitter entropy collector eliminates the need for such
workarounds.

It cherry-picks cleanly to 4.19.y and 4.14.y.  I'm particularly interested
in the former.

Thanks for considering this.
noah

