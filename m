Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3D2F2060
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 21:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391233AbhAKUG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 15:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391224AbhAKUG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 15:06:59 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14DDC061794
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:06:18 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v1so199941pjr.2
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktomJI0Y3ccVEtEneg9VJO0E7ZnZUFb5M4VAvOCOMZw=;
        b=n0MJ0FttSO2YKxFfpTcBfR041aNKF/9zqyn6MTzf4rORQCfywnBpMivzbed9wZZxZB
         +MSy1XyvSoq9WFz7Dv4hkNIjQsXscD3EdC8cInzNMuYCzqT4baGUMivXNxOMiT45v0Yl
         ncSHx1lY+x42P68L19OOHc5OL8D+yIA9mpfWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktomJI0Y3ccVEtEneg9VJO0E7ZnZUFb5M4VAvOCOMZw=;
        b=GiiFBtW6UP+UTc7l5GHC40PtHfm6b0HUliec97+mctE7+iqw4MI79f2OdGFUV7s5Ro
         tBm3fdfTE/HAG3T58KnpmVbJrB51iMWfWMFHWMQXPhLabzdy4/z7YB/ZUqf0ASUCYw7Z
         k67lJYl2AMwHKN/0glHJKbGBP7yuKu13Wv5uTVMU1zES3GiGw44uakhIh6InMGTiNWTz
         vWznF6S0bX84Gp8IUUD8qjw8IdJ3BhPwhYme82ae/3JnF0Yab7iY3iroBUonu64ECmKb
         iT9xOSeyxqoeb05gJoB4pxBELTiEwgkKXhw3IkwrbSULaaTmqSFGtx/wu4uXG+LN/9OI
         T9CQ==
X-Gm-Message-State: AOAM533qO541K/FkVkYH6zb7mreCerAd5FDSvRByvK1A6Haj1v/Fs8nI
        Uh/uC0eMFbFXVXoInUtjJLMroQ==
X-Google-Smtp-Source: ABdhPJx9KUzJPdrSmgRK68rL/HNzmi2SYBw1vAYyAwPBgAP8rppN3LS141j9MFjJucOJxO8ZuIseyg==
X-Received: by 2002:a17:90a:7e88:: with SMTP id j8mr511654pjl.217.1610395578551;
        Mon, 11 Jan 2021 12:06:18 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k7sm444187pfh.201.2021.01.11.12.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 12:06:17 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Paul Cercueil <paul@crapouillou.net>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] seccomp: Add missing return in non-void function
Date:   Mon, 11 Jan 2021 12:06:02 -0800
Message-Id: <161039555572.3147290.9535464378930231049.b4-ty@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111172839.640914-1-paul@crapouillou.net>
References: <20210111172839.640914-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 17:28:39 +0000, Paul Cercueil wrote:
> We don't actually care about the value, since the kernel will panic
> before that; but a value should nonetheless be returned, otherwise the
> compiler will complain.

Applied to for-linus/seccomp, thanks!

[1/1] seccomp: Add missing return in non-void function
      https://git.kernel.org/kees/c/04b38d012556

-- 
Kees Cook

