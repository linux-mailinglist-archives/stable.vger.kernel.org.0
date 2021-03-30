Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DA834F180
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 21:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhC3TOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 15:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhC3TOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 15:14:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0F9C061574
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 12:14:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id o16so17336486wrn.0
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 12:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=v/XYLtDVXIStdXtXhc0/6eQvT1XaMmR12lJZ0LZE1I0=;
        b=DxMdOWE+oRT2B/5mm2k2OBREBRhiLz7tcW7Dy5C4s606izI4o1T6MTpJy3gli9Z3am
         BAkhd5BR3q+6EEjc2aw7nrtPMf/5IlSCpmg8rlYajy8FclahZQ9NiHZRTFekWD66qeyr
         ffB7DiB2KYe4kTTpjx3aPo6Fl743zrUB/kHMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=v/XYLtDVXIStdXtXhc0/6eQvT1XaMmR12lJZ0LZE1I0=;
        b=nEEV+c8WDTW0aM3td8Xi5jscGuZbA5TFUGE6WEDgeCZZROciLqf5Xf0i63Y9cvzM7L
         myutYM6YFKGk/Cuhzq9riDKogeS9bGYzTaSq4M8uMqwoEFh+bmFa8+wE4xGy3xasewIu
         9zJ6telYIw3NAW06KK/hiSl2ekL23PcUsuk77AUqMCd1lPjSDqsPphbJ0tkn7iR1W/3L
         f8FGyZsN0PuaXRSg39d2+Tr987HY6ZYsuFlO63mnbn5c4ZsjUxHo2XhGPQOo0go95qGv
         9kUzWZ+Diba7TfzlwtnWFUoPpRi/fft3dPVVIZE/6UPGPQxSa71Z8vnfoPM0DhthACa/
         Lq7Q==
X-Gm-Message-State: AOAM532t2MeUrVNXoXK1kfFDe7J9t454/qTAX4LcjrKBdckYWx+IOsrQ
        Wgf2iZdgVfuLf7qoFgvUtKcpsnOaCF0MkYtzpU9mlIcOv6sutg==
X-Google-Smtp-Source: ABdhPJzuFJq7Pm+A0ajqd7PtuWkC/bLuZj5UQCdX1mkUSZgkDxT1qejHvKvqO6uKVyzy7PImitfB4U0H8LHfe5Ht8fk=
X-Received: by 2002:adf:d20b:: with SMTP id j11mr35041102wrh.397.1617131653489;
 Tue, 30 Mar 2021 12:14:13 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Tue, 30 Mar 2021 12:14:01 -0700
Message-ID: <CAAjnzA=2AwmEfPVKb9qo2LyzhZnF5orb3DGubTy2dc0hbQBXVQ@mail.gmail.com>
Subject: stable/linux-5.10.y - 5.10.27
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

JOB ID     : 29cbaf7acada1e4b67b23f0841955606b597319a

JOB LOG    : /home/ci-hypervisor/avocado/job-results/job-2021-03-30T18.59-29cbaf7/job.log

 (1/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_nptl:
 PASS (6.21 s)

 (2/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_math:
 PASS (2.01 s)

 (3/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_hugetlb:
 PASS (0.08 s)

 (4/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_ipc:
 PASS (20.08 s)

 (5/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_uevent:
 PASS (0.06 s)

 (6/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_containers:
 PASS (36.90 s)

 (7/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_filecaps:
 PASS (0.11 s)

 (8/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_hyperthreading:
 PASS (71.20 s)

 (9/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/kpatch.sh:
 PASS (13.63 s)

RESULTS    : PASS 9 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT 0
| CANCEL 0
