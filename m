Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FB24469A4
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhKEU3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbhKEU3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 16:29:41 -0400
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88410C061714;
        Fri,  5 Nov 2021 13:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org
        ; s=ds202012; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c7xL3ULUvDEQY8y11JsWZ8qJvPv11YqU/ku2rqgY1ww=; b=iqUPoKkx2ggx9bqJoDGzYLoSFv
        ZTj25RKGAhdI0A7DLOIF2+4TH8ZVLKHUquDkvkhOx1W3Yg58DkzzhhNLeBFhfh4olfJMcU07scxQ6
        Yn2h7O+JoHEuxj+QUrQHL8mmD0RuqPpwPVfCvBHQ4LuIeqV3qafidcGwiSFUH3gby+FKwZEHvCxAA
        RcrRlxazQfnlaKoT0EULpKhBHlJCmu/MiQ84j0VB0fwk+7mH5kbL30e8B4S4ouDpkn8isCKpCh2WF
        m5lPL0D7s3v7KJtn2XRWABiG6h92aPjFc8Zgm2PM1EuFNBAMXPoYp77quZt3jhJaGupwbz++38H5c
        YUTNZofA==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:51024 helo=[192.168.10.61])
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <noralf@tronnes.org>)
        id 1mj5ne-0006rL-Lg; Fri, 05 Nov 2021 21:26:58 +0100
Subject: Re: [PATCH] staging/fbtft: Fix backlight
To:     gregkh@linuxfoundation.org
Cc:     linux-staging@lists.linux.dev, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, stable@vger.kernel.org
References: <20211030162901.17918-1-noralf@tronnes.org>
From:   =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>
Message-ID: <9915936e-8a02-2e7a-5c47-f048c1f0319b@tronnes.org>
Date:   Fri, 5 Nov 2021 21:26:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211030162901.17918-1-noralf@tronnes.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Den 30.10.2021 18.29, skrev Noralf Trønnes:
> Commit b4a1ed0cd18b ("fbdev: make FB_BACKLIGHT a tristate") forgot to
> update fbtft breaking its backlight support when FB_BACKLIGHT is a module.
> 
> Fix this by using IS_ENABLED().
> 
> Fixes: b4a1ed0cd18b ("fbdev: make FB_BACKLIGHT a tristate")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
> ---

I discovered that fb_ssd1351 also has this #ifdef, so need to fix that
as well. Will send a new version.

Noralf.
