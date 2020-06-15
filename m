Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBAC1FA1A8
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbgFOUdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:33:19 -0400
Received: from ip-78-45-52-129.net.upcbroadband.cz ([78.45.52.129]:32944 "EHLO
        ixit.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgFOUdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 16:33:18 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2020 16:33:18 EDT
Received: from [192.168.1.102] (227.146.230.94.awnet.cz [94.230.146.227])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id A62E3250E5;
        Mon, 15 Jun 2020 22:23:59 +0200 (CEST)
Date:   Mon, 15 Jun 2020 22:23:53 +0200
From:   David Heidelberg <david@ixit.cz>
Reply-To: 20181129133119.29387-1-linus.walleij@linaro.org
Subject: [PATCH] irq: Request and release resources for chained IRQs
To:     Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Message-Id: <TZHZBQ.SOVDZ4DJB30O1@ixit.cz>
X-Mailer: geary/3.36.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

is there chance to get this patch included or could be this issue 
solved with different approach?

Actually this patch solve issue on two APQ8064 devices:
 * Nexus 7 2013
Tested-by: David Heidelberg <david@ixit.cz>
 * Nexus 4
Tested-by: Iskren Chernev
Best regards
David Heidelberg


