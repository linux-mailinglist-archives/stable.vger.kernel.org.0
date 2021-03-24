Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6356D347E28
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 17:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhCXQsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 12:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbhCXQsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 12:48:02 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8723C061763
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 09:48:01 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id b14so19716551lfv.8
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 09:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=O1KXY8JgZSwYcL2PCWChjfgsQU3qHbreNaWpkKXWQ1k=;
        b=CSId1I3V/qfeoOrNOAlctWIIJk5E/Mbnh7+NCqO/YCittz5HRkfhCSoP1wPsLLlrEn
         rxgO8DSG0dQ314uyh3nbK58ZRIxfSkgbKmk7bThe5Aiapd0fphN2Byo4ANLap7t7PcCS
         M5RKjcT2aybuCNV2tYwI1VXDbVffG0WuvpxpKm3LBkJvvfBDCwYiGmLwGVsCb454Ingj
         TsoaxiX6uIelorr4JZaevM9wOODl57D1FuiSVjK6QpmaUeXg7AsjUGtjrXv0pjchRS6W
         kZKD+Kd+s/BCWN4QzYvHb1JenfY87qH4XqoiF9teqHzsuIGTOEIXr8n6ATx4rpkurxd/
         9n5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=O1KXY8JgZSwYcL2PCWChjfgsQU3qHbreNaWpkKXWQ1k=;
        b=OlV1vnc8F7ucPiEdt1YrGtQOdiPvE7/0Hv4vb6DfHgr5JkG/LY0t0SrDKMEhmTlpvW
         +MQNtoPR7qvnikKAMe3fYXCQtXwhGI76TiXX0FmvsXcPKJ+kMP5gmw6eNqBdOktObDNX
         oBxehSwUl9sUHpO6wsMR6ROOu+M4VGhvA3d+IL7XDxL/4vpV1X2Qmc/nDIubBIrdxS7o
         12I4UbRkfRh+W/16E06MY0hqlQvP8ngAK8MWmh+nuocW4zRu2LPiM9/twmzP5eE0yYBz
         wjRwzXjq3a7F8QYm8dVn33I1tEdY6CTThvSLlJhGfn1RAO4SQuub38YG61GDLTlIUQDl
         yNlA==
X-Gm-Message-State: AOAM530TiaFXT+26/mWgIlg7g1ZGwyL+ymjFxtZJ9ZVKUvw2EYktK1Fw
        kF9Cn/QL7b0v3DA8igU6vx8hAtGMGQjSDa69IbO2K2bqItg86Qc+
X-Google-Smtp-Source: ABdhPJyLyj6uTvwnkRoLiPKVqk0m03qPaSkR/4AS+Py7irpBrLqKjJq2Ty/oZ8n8GxNQdbcVwqUF3VcXnPrRDMH87HY=
X-Received: by 2002:a05:6512:985:: with SMTP id w5mr2387590lft.122.1616604480225;
 Wed, 24 Mar 2021 09:48:00 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 24 Mar 2021 09:47:49 -0700
Message-ID: <CAKwvOdmCpMf1Zp3tB=oqse6-Bsm_ybJQ=G5h__kEuOa47CjBHg@mail.gmail.com>
Subject: please pick 552546366a30 to 5.4.y
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        =?UTF-8?B?TWlsZXMgQ2hlbiAo6Zmz5rCR5qi6KQ==?= 
        <miles.chen@mediatek.com>, mike.kravetz@oracle.com,
        Nathan Chancellor <nathan@kernel.org>, dbueso@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,
Please consider cherry-picking
commit 552546366a30 ("hugetlbfs: hugetlb_fault_mutex_hash() cleanup")
to linux-5.4.y.  It first landed in v5.5-rc1 and fixes an instance of
the warning -Wsizeof-array-div.

It cherry picks cleanly, I verified that I can build
CONFIG_USERFAULTFD=y
CONFIG_HUGETLBFS=y
with it applied, and that none of the call sites of
hugetlb_fault_mutex_hash have an issue with the signature change once
applied to 5.4.y.

-- 
Thanks,
~Nick Desaulniers
