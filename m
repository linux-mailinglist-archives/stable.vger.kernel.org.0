Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF95915C8
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 21:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbiHLTGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 15:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238120AbiHLTGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 15:06:47 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1CB92F44;
        Fri, 12 Aug 2022 12:06:45 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 26D131C000B; Fri, 12 Aug 2022 21:06:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1660331204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=viiBljOyyzkbB2ZLkcxCj98JgLeh89KU7/mfKjpfyWc=;
        b=J0HNiyQWC0gHluTwmdliFp17/KmtNP/SIaRAAsk6wVRxFq4887rWzm2g5HuKU/YewYmHkF
        ojmx9hWopxRyE8Em+PwmHIvfsmiLmykVmXqNoYqR4ivDP6x1thlGkiIZ4usw8zAQDKK6+Q
        pC/uRWcWptiO9wukdShEa2zwILX9lBM=
Date:   Fri, 12 Aug 2022 21:06:42 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH AUTOSEL 5.10 01/46] drm/r128: Fix undefined behavior due
 to shift overflowing the constant
Message-ID: <20220812190642.GB1347@bug>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

In this series, I only received patches up-to 42/46. Is problem at sender or receiver?

Best regards,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
