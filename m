Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF5D3B0A61
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 18:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhFVQdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 12:33:06 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:59532 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhFVQdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 12:33:05 -0400
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 64FEFAF13D0;
        Tue, 22 Jun 2021 18:30:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1624379448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sh2dhai/9z9GM3mJ9c/d+WvHme3Ld9yW0Q4OCexvDac=;
        b=QSs8zNka59bRhHdZVr3sCBPaZh3WdTq++wZE2sDQHRS/rtKFWJikJrkNXg12cQRDGl4Lmc
        aDk4HET1CCA48QgMK3yp4NxOHJ6/9wWP33FlXXAK3ml9eq6YQAmIbrMOi6VGGLyuO1Thop
        NJxcx3WiALROBT1zaGb5Lh8ZV2d0y1E=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     stable@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Backport d583d360a6 into 5.12 stable
Date:   Tue, 22 Jun 2021 18:30:46 +0200
Message-ID: <11282373.oIR2C0Pl9h@spock>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

I'd like to nominate d583d360a6 ("psi: Fix psi state corruption when 
schedule() races with cgroup move") for 5.12 stable tree.

Recently, I've hit this:

```
kernel: psi: inconsistent task state! task=2667:clementine cpu=21 psi_flags=0 
clear=1 set=0
```

and after that PSI IO went crazy high. That seems to match the symptoms 
described in the commit message.

Thanks.

-- 
Oleksandr Natalenko (post-factum)


