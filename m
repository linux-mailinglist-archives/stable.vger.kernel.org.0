Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B9A32FF7D
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 08:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhCGH3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 02:29:50 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:30398 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhCGH31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 02:29:27 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2021 02:29:27 EST
ARC-Seal: i=1; a=rsa-sha256; t=1615101810; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=PnGl+5HkBTC9mEtDSuQO9OWKZsSRP2b9rMyvV3etVzpXjGpwLyvW6hrrjhr6Ul9T6K
    Vt0xs4XUIGtliUr+YBFYCXx3MKq6aoIDyWWylLgLThSkH1s15ovQ71WxTpijVqPrW7Vo
    4lqsUKQyHOO6Wv4rkbRZ2mRi2mEE7Epvt8oUFy37lRYYwfkJgEzB25L3tmlGtJXkgZFT
    p1ZMG4y3ka+FnjayajAjf+kAXz18ecEG5WCiXmK1JC3uPILkXNNIlsTf6v+B2HzHAgOJ
    8tNKi9l93P9+nJnCQmPWuFuZuSk8eLwi/gYOeZY9y2QegZSDPZVbKXPntBAeV96vXZpl
    0eIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1615101810;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=DB+3TiD2XnGI/fIPXLP6SMkxEicSgBYiSiaio15OrG8=;
    b=KzqfCDAKXuVmP0ckSPYakSt535kLOrHdJ0N6g7GQ/VapJOelwhGQ1divkRskbmQW6R
    7LZ9roWSqWL4kU6WJGpuy7/u109wDTZI4tE56FBRtV0trOqjKYz6N6HHKIpDYKMDVQ9H
    TCopislodZ/WfXEns7BEbxBZZNz9vZeNZHi3EuHQrJ6aCPaItPxZnwIGG6KDPoITTRf8
    jl/+37sZykbFB94xFIajEi/YuJxA+xP1+7lBkFgYwROgqpt8lFdgaDYy6zxa4ZcR6GB8
    D8EYaRUQnChM5dv1PHhTw5vqxT5djqYq4Xxmjm/Tt3DkaIGWvwrmZjCAJdCxuqTvrQ7x
    p95g==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1615101810;
    s=strato-dkim-0002; d=schoebel-theuer.de;
    h=Message-Id:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=DB+3TiD2XnGI/fIPXLP6SMkxEicSgBYiSiaio15OrG8=;
    b=T+igv84KPfwdn5ctaOWjVoYTbfFx2E6Xu1padOIwEoDs6phhK+HOsZZRzBVxhO+mtI
    al+XVrU/idIywYnEHLsPnFV7ysPqrUgTwsJ6wtYv7PYfxrQzPMOQk6eIWnWfq6CuEzP0
    1R7YBdk8rRY1+xLIgHtKghJ9dFytCB8KgkWs10DWribOOEtGqH3bnP7t3BRA+PFkl7Y0
    mVipYBEhFaOzSAPeUm/EnQZ/E3dVEgynnP+mwRlHWRH0WSQ0k40mr5iyucBIQH5y1AOF
    6sFl8hLwsqhPOTNMDYl4+kGZHu9enF399isPHRnjZvAYQZE92FcEOVY91/ePMIAwovcS
    by1w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2e0bDjfg8SjapJoMy/ngEsCKWYLcLtzTI+/at5T6HYnAg=="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
    by smtp.strato.de (RZmta 47.20.3 DYNA|AUTH)
    with ESMTPSA id 6007d4x277NQ8fH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 7 Mar 2021 08:23:26 +0100 (CET)
From:   Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To:     tst@schoebel-theuer.de, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Schoebel-Theuer <tst@1und1.de>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RESEND v2 STABLE 4.4] futex: fix spin_lock() / spin_unlock_irq() imbalance
Date:   Sun,  7 Mar 2021 08:23:22 +0100
Message-Id: <20210307072322.5884-1-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Schoebel-Theuer <tst@1und1.de>

This patch and problem analysis is specific for 4.4 LTS, due to incomplete
backporting of other fixes. Later LTS series have different backports.

The following is obviously incorrect:

static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
             struct futex_hash_bucket *hb)
{
[...]
	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
[...]
	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
[...]
}

The 4.4-specific fix should probably go in the direction of
b4abf91047c,
making everything irq-safe.

Probably, backporting of b4abf91047c
to 4.4 LTS could thus be another good idea.

However, this might involve some more 4.4-specific work and
require thorough testing:

> git log --oneline v4.4..b4abf91047c -- kernel/futex.c kernel/locking/rtmutex.c | wc -l
10

So this patch is just an obvious quickfix for now.

Hint: the lock order is documented in 4.9.y and later. A similar
documenting is missing in 4.4.y. Please somebody either backport also,
or write a new description, if there would be some differences I cannot
easily see at the moment. Without reliable docs,
inspection of the locking correctness may become a pain.
 
Signed-off-by: Thomas Schoebel-Theuer <tst@1und1.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 394fc498142
Fixes: 6510e4a2d04
---
 kernel/futex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 70ad21bbb1d5..4a707bc7cceb 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1406,7 +1406,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 	if (pi_state->owner != current)
 		return -EINVAL;
 
-	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
-- 
2.26.2

