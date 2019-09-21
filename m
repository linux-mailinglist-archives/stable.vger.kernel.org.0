Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC71B9D83
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 13:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407500AbfIULFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 07:05:31 -0400
Received: from kadath.azazel.net ([81.187.231.250]:59680 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407497AbfIULFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 07:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2XCk3uvQkSBolkvcTLUwG7isIl94JNrVpriYmHDNPb8=; b=d/ArAaEIkyTP14IFxBZO9MPy53
        COxpakkj+HGSC71oxrJ6hbn0wyt4K+kQuYj2GJuXAG5+6l3I4QspN1P/O6HEGk9BcAFeFlSuaQgLY
        jqO40LEz+L5hmR5zO1al36IB5yWTGKb+D88HcW+y/EFvO8kUyrnAPhyz/cLbOQLMjEnYGiUCsEi0G
        00kVOI94Evdcxz22IMigvowk0wZhzsbBTFaBOKmFS97oI/Fp8Z8SRBrPOqf5TBjuKaVzLlkLS4KuS
        6geiKc1F5HIYn4/a8wmShyuNxvaQ8JIsTVKDBs6UxT7JslvJ4rduVmiBGYWdW8hme9+v7/IJwJTbx
        PKwLO41A==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBdCd-0007fj-6P; Sat, 21 Sep 2019 12:05:23 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH 0/1] netfilter: bridge: build fix for 5.3
Date:   Sat, 21 Sep 2019 12:05:22 +0100
Message-Id: <20190921110523.15085-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adam Borowski reported a build-failure in 5.3 when
CONFIG_NF_CONNTRACK_BRIDGE is set but CONFIG_NF_TABLES is not.  It was
introduced into the mainline by:

  3c171f496ef5 ("netfilter: bridge: add connection tracking system")

There is also a fix in the mainline:

  47e640af2e49 ("netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.")

I've cherry-picked it, and added the "Fixes:", "Reported-by:", "Link:"
and "Cc:" tags.

Please consider applying it to 5-3-y.

Jeremy Sowden (1):
  netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to
    header-file.

 include/net/netfilter/nf_tables.h | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.23.0

