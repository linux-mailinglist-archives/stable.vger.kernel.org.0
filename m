Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D5E1B23B0
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 12:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgDUKZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 06:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgDUKZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 06:25:11 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CBBC061A0F
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 03:25:10 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x18so15879644wrq.2
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 03:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=8fJJInYYzc75EzpOQ+MP4cZi2gwZVx4USUV2GSLc1m4=;
        b=Z9k27AbR0qfrkKoHSgHnOqbpxsqrBQFHN8V0R2VyOHrb9ZKHZ/3ix+ThmmZYzfR6Dc
         fgFflSgy7pXJf/nXqbrC9Eqr3xjxqB2+sFTH8iEdKJyTk4Big8gT9NDrYl6aHtMIojp9
         MyhS2aO4+ZofWVL0OFL345Ls8rTLPOJkUnnCck24OegrtHjME4ZuWnUHxbgYJ+mo/3Bm
         SlO4Os2oBXWo4phRCw8j2nm3KD2nHgJoYhJiQJiF17hjb8bkb/k/aSZ8S6/RM7Ubfb6i
         IW3iNuL2/HwOMVJ0HYWJhJ3DhVeffUO/8AGjev/6So1eNFiheWMWzxF8LRl4F8TsCE8g
         DDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=8fJJInYYzc75EzpOQ+MP4cZi2gwZVx4USUV2GSLc1m4=;
        b=kWLUDTfHXo1rvGx2QrWy8jbQn6vgM8HDqbJzINE7jVRfUOqTN7RST4VMUEZbWMNhr+
         Lh6wQWvZO2xCQgRzJyjmksBar5hWTdBSQBgDNFGUbbsPO/zS7t+QrV/7UUmKvXbWCD02
         pgk8mQ6bw42wLsZwKtZtU0Xr0kqe6FLkCkPNnG/C+gaf30hLpgh8xC9Kj49ibWWJvL/m
         O8TOsLMNcYmpH0hLNlkNPv+dydCxFOe0ylonYtmzLnWSjGBIe0nHcpI3w181HwFuBWiK
         MUEkEiOfjrDCKXvcaNy92M1Y0n/rvnpvrqkPET/Yc1xNDNKUpzr1LtMUQuVYb4FqUEDd
         SbQg==
X-Gm-Message-State: AGi0Pub4Ut49tX/OiZz0I4iI8IJWjfxacjflbr8eb5o1qfwR0E8oS0B3
        DqCb5kFySPPQkaIZyXX3xKx0PFpkNOY=
X-Google-Smtp-Source: APiQypIwpCFcpolwVmQfaLbbnhJJ/nREXn+PUJE/2nWtW4S+eU0JGH3cIe03CMFR7D9vc9zbR22SPA==
X-Received: by 2002:adf:f844:: with SMTP id d4mr22908396wrq.362.1587464709052;
        Tue, 21 Apr 2020 03:25:09 -0700 (PDT)
Received: from [192.168.0.101] ([84.33.162.135])
        by smtp.gmail.com with ESMTPSA id n2sm3441709wrq.74.2020.04.21.03.25.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2020 03:25:08 -0700 (PDT)
From:   Paolo Valente <paolo.valente@linaro.org>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: block, bfq: port of fix commits to (at least) 5.6
Message-Id: <BD02F95A-0A08-4BEB-9309-9941998EE14C@linaro.org>
Date:   Tue, 21 Apr 2020 12:25:37 +0200
Cc:     Chris Evich <cevich@redhat.com>,
        Patrick Dung <patdung100@gmail.com>,
        jordanrussellx+kobz@gmail.com,
        Thorsten Schubert <tschubert@bafh.org>
To:     stable <stable@vger.kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
a bug reported for Fedora [1] goes away with the following fix
commits, currently available from 5.7-rc1.

4d38a87fbb77 block, bfq: invoke flush_idle_tree after =
reparent_active_queues in pd_offline
576682fa52cb block, bfq: make reparent_leaf_entity actually work only on =
leaf entities
c89977366500 block, bfq: turn put_queue into release_process_ref in =
__bfq_bic_change_cgroup

It would be useful for Fedora to have these fixes in (at least) 5.6.
No change should be needed for these commits to apply cleanly.

Thanks,
Paolo

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D205447#c84

