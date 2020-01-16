Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87A313FD74
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388820AbgAPX0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388660AbgAPX0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B396F20684;
        Thu, 16 Jan 2020 23:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217166;
        bh=JSkYMwublXIioF8nYCwyNBtuKyaSoZ5SYFQ1WufBYiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFPAqQGBG2ILPJm/jfvp/W4x63rYYYcjcMOQNmvqO90Ez1GgXR4fWnpL7HzNIt+aE
         7pvMs84vDAbvyNh/1ByWz/8yGSYuFAmdf3Vw6q91BWBaq1SVoSfBFu8OJ7aKlOgsMg
         i4oGJTWY7uCQWwXI8A4SpnhPdN/AaMJOJrndRNLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Victorien Molle <victorien.molle@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 175/203] sch_cake: Add missing NLA policy entry TCA_CAKE_SPLIT_GSO
Date:   Fri, 17 Jan 2020 00:18:12 +0100
Message-Id: <20200116231759.775066301@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victorien Molle <victorien.molle@wifirst.fr>

commit b3c424eb6a1a3c485de64619418a471dee6ce849 upstream.

This field has never been checked since introduction in mainline kernel

Signed-off-by: Victorien Molle <victorien.molle@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Fixes: 2db6dc2662ba "sch_cake: Make gso-splitting configurable from userspace"
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_cake.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2184,6 +2184,7 @@ static const struct nla_policy cake_poli
 	[TCA_CAKE_MPU]		 = { .type = NLA_U32 },
 	[TCA_CAKE_INGRESS]	 = { .type = NLA_U32 },
 	[TCA_CAKE_ACK_FILTER]	 = { .type = NLA_U32 },
+	[TCA_CAKE_SPLIT_GSO]	 = { .type = NLA_U32 },
 	[TCA_CAKE_FWMARK]	 = { .type = NLA_U32 },
 };
 


