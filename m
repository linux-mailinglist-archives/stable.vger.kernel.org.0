Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EA047FBA6
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 10:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhL0Jt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 04:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhL0Jt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 04:49:59 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5145DC06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 01:49:59 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D527F1EC02AD;
        Mon, 27 Dec 2021 10:49:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1640598592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=pRzFWhJ/Dx/HzF3eRqfPTmqihKjm0hmMsXbmgHVWfF4=;
        b=QAGr2Lrf7sisFplAjs2NhO4NhWjuOP1wabjfbqhdZSKmhuMGDgyioTFJQ0jQEFAjmzHNjn
        r40xZMWW0Xd2NVobwFZfVYX8hSmt4PmMRPxeBKnH7+p18RX/sOLq0foN2GeJiLCUT0vlsd
        p8yg6MgY/fwk/wDDCzNXPvF3PUqQnfI=
Date:   Mon, 27 Dec 2021 10:49:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     stable <stable@vger.kernel.org>
Subject: 5.15.y backporting request
Message-ID: <YcmMPjXU36oiVTfo@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable folks and happy holidays!

Can you please backport two patches to the 5.15 line by doing:

git cherry-pick fbe618399854
git cherry-pick 2f5b3514c33f

in that order. They apply cleanly ontop of 5.15.11.

The first one is a revert and the second one is the better fix. I
would've done the usual cc:stable thing but sending human-typed mail is
a lot better - it feels like sending physical letters back in the day. :-)

Thx!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
