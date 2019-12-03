Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5CD111E73
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbfLCWzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:55:11 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:46888 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730113AbfLCWzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 17:55:10 -0500
Received: by mail-wr1-f54.google.com with SMTP id z7so5971942wrl.13
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 14:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GKv6Mm1oz85heCcxK130gbYAevNbCAAFo+nBJ320s1k=;
        b=BNICftiyB/oLxgHMXNIUGC179kJaTeQbulvl6WzQhcI8i0uzniODhsbp0eKX4KLSQT
         fE3c9TXh8ohBAfJIE3gOEoo5ZuPfe5nVRunegE7Aq9WYZfaYNa6xjdWyzr1lp8AGgLcB
         pQyS5IBkpsyt001jdmv43DvfQhn5DK1MSpCqGI427MwHmd4pVnrcczftSnucXlORiG98
         0tvLug0K8Jh5EaUC9ixBhFrDKZHBluYRObJNTgsRkkf1dMVvzHvVzNPsnXthoNVajTAe
         GMj6APWljeVrBBWjISPsNQPcM8wnNkZ3oneo8uzZ1w37Hc0iTQok6wlsFOn6lYCjGb+l
         TtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GKv6Mm1oz85heCcxK130gbYAevNbCAAFo+nBJ320s1k=;
        b=oyeTOM2HKnCnxlLT0a4f6k2kuhguwE7AbLNE4YesvZvXGzrQ/CIEzOZHvGcVFbZuNJ
         /WRwDnWvBhPbYPTY1+PZnYjLisu2wis4hiibDI9lYONwDgCD4TFw77yUKEDh7nCu3wvo
         KRtq38FyId9faFci/VRp4DF1xK5feJ22E00v1FN2LebFo07plhuFA+494x5w/S2IEIJa
         t+wMrb9bBbiXoKDPpxvG3W65+gHuf5R8GPijTzRwuFqmeIAKNRJChEwIMAgLyZelUByr
         eoLGSgaMWok7f/oke7kDdGqFA8VrI9+gzAPUtVKDOaTwSV/hRNrhBMph0YpPfZFw+CYK
         0pNg==
X-Gm-Message-State: APjAAAXm0xSZvZWb7qBX3exFdV1XfWqVYq1/UgSJF2L2bdka2/ENF6vq
        rsGNXHS+YJeZo4GlEQ9JyrTHWDBz8u4L3z3h1KuT2YWxzqo=
X-Google-Smtp-Source: APXvYqz/yaUK9H5ybilnrmS7l7L78HL0CtSjXpdnZ1XepNXg6Ai6PoNKOjU9HdXw33maJhu5e6AjbsOCU6EdXe5MxOw=
X-Received: by 2002:a5d:4b4e:: with SMTP id w14mr438283wrs.187.1575413708421;
 Tue, 03 Dec 2019 14:55:08 -0800 (PST)
MIME-Version: 1.0
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Tue, 3 Dec 2019 14:54:57 -0800
Message-ID: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
Subject: Request to backport 4929a4e6faa0 to stable tree
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Stable kernel maintainers,

I want to backport below patch to stable tree:
4929a4e6faa0 sched/fair: Scale bandwidth quota and period without
losing quota/period ratio precision

This Email is to follow the option 2 [1] to submit patches to stable kernel.

This patch is fixing a real bug affecting Kubernetes users [2].
The bug (2e8e19226398 sched/fair: Limit sched_cfs_period_timer() loop
to avoid hard lockup) was backported to all stable versions. So we
need this fix to be backported to all stable versions as well.

Thanks!
Xuewei

[1] https://github.com/torvalds/linux/blob/master/Documentation/process/stable-kernel-rules.rst#option-2
[2] https://github.com/kubernetes/kubernetes/issues/72878
