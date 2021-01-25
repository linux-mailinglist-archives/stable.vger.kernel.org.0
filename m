Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED44F303010
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 00:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbhAYXZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 18:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732242AbhAYXZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 18:25:07 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831E7C061574
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 15:24:27 -0800 (PST)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611617065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=TO/uRQAj7KNjfnxwAqIacQ050Bk7n+fmYm03Ic1drGg=;
        b=nj0kmWpl2Dut2fKBF1jIAOxM0asxfUOdERt+InJQfowHz6PA1buVDpM0I374rJZKc5LwgX
        MSobFh1rwSB6rV6fCe7n8zvxg2VBofVJxQ/6eDaJwVGT09xPRUGv1SMJEY0+Ao5rP+gAW2
        K6sYv+036DKzNp1aYuYRhFsiBT9FuSkhwnkaXVgRg5PHJg8uJPdkLDRMnNbaaN+cQDVTIc
        wI2RJPhabYqtArBiMUaWHNkC6zUwxuaV31xsqIljMov53qOTk5NH2G0bFl1rrew5wy9FnD
        SduIhJRgoaSqk3gQlm+9C0C6wNvF9eopn2W1VNLP+bySSRloDDmKsdcbkQqbdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611617065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=TO/uRQAj7KNjfnxwAqIacQ050Bk7n+fmYm03Ic1drGg=;
        b=kcfZ+Yw1B27y1UbcAC2TGYcR2UO9M2Mn7FmT8y8JDp8nNSgerhVGnD9/Ce0BYcbhpmEnI3
        iuilMhT2aEgzOSCg==
To:     stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: printk: buffer overflow fixes
Date:   Tue, 26 Jan 2021 00:30:24 +0106
Message-ID: <878s8g38if.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable,

The following printk patches fixing a buffer overflow potential in 5.10
are now available in Linus' tree:

f0e386ee0c0b71ea6f7238506a4d0965a2dbef11 ("printk: fix buffer overflow
potential for print_text()")

08d60e5999540110576e7c1346d486220751b7f9 ("printk: fix string
termination for record_print_text()")

The first one (f0e386ee0c0b) was already queued up for 5.10-stable but I
requested it not be applied until this second one was accepted. Now they
are both accepted and both should be applied. Thanks.

John Ogness
