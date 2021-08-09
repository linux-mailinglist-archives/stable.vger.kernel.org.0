Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001FE3E4D2C
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 21:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhHITkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 15:40:13 -0400
Received: from ixit.cz ([94.230.151.217]:45928 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234135AbhHITkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 15:40:13 -0400
Received: from [192.168.1.138] (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id AA1A62029F
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 21:39:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1628537990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=Lm+9FNT9EMJRQqQymBuJbCin7NQu3bA/quWaKPC5jg8=;
        b=X/8krVlUDZd2AD8iLWoT7ecObXTmOnnJksGA5g5EAL3HrJrFh2zkX+aN8dDecm8BJd8+rM
        MazvwVQrlwHO1Kd/xfgtfSkj3pSTDuJujOzRmsDP0lkZjYuHO3F774u2tfZG1zXeQgPrXx
        I1eIRxikRDql1NWIlAU7nJOYVFPeKn0=
Date:   Mon, 09 Aug 2021 21:38:45 +0200
From:   David Heidelberg <david@ixit.cz>
Subject: ARM: dts: qcom: apq8064: correct clock names
To:     stable@vger.kernel.org
Message-Id: <LW7LXQ.P4TOHDR1NF9O1@ixit.cz>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0dc6c59892ead17a9febd11202c9f6794aac1895

Hello!

since the commit b0530eb1191307e9038d75e5c83973a396137681 (just before 
5.10 LTS) - this fix is needed for running Linux kernel on the APQ8064 
and since is this fix apq8064 specific, shouldn't in worst case 
scenario break anything else and it's tested on the Nexus 7 2013 
tablet, I'm proposing backporting it to 5.10 kernel.

Without this fix 5.10 failing on dmesg panic (as described in commit):
msm_dsi 4700000.mdss_dsi: dev_pm_opp_set_clkname: Couldn't find clock: 
-2

For earlier kernels before 5.10 this patch shouldn't matter and 
delivers no functionality change.

Thank you
Best regards
David Heidelberg


