Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35154307390
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 11:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhA1KVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 05:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhA1KVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 05:21:07 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D37C061574;
        Thu, 28 Jan 2021 02:20:26 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4DRGgM42CczQlXk;
        Thu, 28 Jan 2021 11:19:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :subject:subject:message-id:from:from:date:date:received; s=
        mail20150812; t=1611829196; bh=TIyoCrhlhokOiMepVtkuSZ0ldVFGFR3T+
        LN6c67DmIA=; b=aNyJUYfdbBX4f4I5kP8TjVn8vN4FTXIiWcMtaEXLn+04DkSUo
        JuaBnJ+fFWjUvcAYc/pgPn1LYvV901x0IihYK3wX+XMqHDcSZASOwGRFEb5BFr3i
        v4fi04xfApk9tOSMsxzov3qis6opWvV5OI/+zEuklSUHPPkS7LtOWtbZOQ0e98Px
        T6SiPR+sOa9qyC4mTYOne7GjU/NCr6zp147fX33ZxKaxAXMopzaSiQ4i+ZTj2Qj8
        RUCEgxYZZRQjWFbm1JCA935yXHbFhs+IEB4yEfiD05gs+zCVcP6L6o4UEVrxqosz
        LJ/8ix1YlCpsHs7P/WWb044Ak189VsG5oWaOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1611829197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TIyoCrhlhokOiMepVtkuSZ0ldVFGFR3T+LN6c67DmIA=;
        b=aEchQkDenNiCI6gNxFmdAV/niV/9z13mSzTgA3+8CEi8vrd5DRPvbDqsnOO5OBNVSIxSKi
        w03xBmbdGqM8ZtflYgGKutb5d6b5Vu3UDhMpqVW0awslFe5KHakoYL2Q/dGemUnxjXX405
        thoFRpK7zSLzEzwM9Vx1wltkV49YKO0nNz45l0Z2yWZRfXEzz4ntYjAfSSgJJsMWgWalT/
        R3rq3i4vexxB5Rh28Fdbf0OiF+b/IUEA7ebVWYOgjRH/xJvn0HesGVq+VjPHTqxX6dgYmX
        SC1jm8bc7ER7196bn7/1b22S3tlclE8btxg6ZUEe2uL+bJ5yyWc1ewb4QyBsjg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id GhJyJ65iZTU8; Thu, 28 Jan 2021 11:19:56 +0100 (CET)
Date:   Thu, 28 Jan 2021 11:19:54 +0100 (CET)
From:   torvic9@mailbox.org
To:     "chris2553@googlemail.com" <chris2553@googlemail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Message-ID: <916742573.14775.1611829195075@office.mailbox.org>
Subject: Re: linux-5.10.11 build failure
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4A30917CC
X-Rspamd-UID: 57d376
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Maybe you need something like this: https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/entry&id=5e6dca82bcaa49348f9e5fcb48df4881f6d6c4ae

Greetings,
Tor
