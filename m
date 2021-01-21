Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3510A2FE740
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbhAUKNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 05:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbhAUKNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 05:13:06 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432C3C061575
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 02:12:12 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id 3so1842750ljc.4
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 02:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MIqRoxpFirBTIX9NyDVMlxHduT/wTSz6bxp4ifB6OC8=;
        b=gYwxiEdwwG2T8KdvHxMXVXEGN1Z/IOiaqebJdO8VfVCb/4nhs9sAuAf6/DW12hxo1R
         uIifPbuqCgN0oLEy7c/2acoK24SlqQp2JpCFNExN0A/Sxq7b6qMq75+JD2looIx1/dZH
         uOg9XAfG4ZDC9hyerQzGTRyW1pyHO3VoJV9xU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MIqRoxpFirBTIX9NyDVMlxHduT/wTSz6bxp4ifB6OC8=;
        b=WK1KCWSGZDncMF8N3N6O52LZoaheNbCypI4lUpXHZ5fv8kTeuFpIAgYpLz75BYmTZB
         NkkylJxx5NjaQc8JB3frb8LqjTcgzW/5HdSDJDsZ0QzyuEloXTBjoN8V5vgKohCfVSu9
         Y1gbWntkaVIsN4YgXQc6Ty/MrG3ni7CAx0R1V1UgRNiuyoLjDd5BDVieoB/rPXKAZvaS
         w9hTt5cGe5zyaExGcVFogUghuwdbMdBnmKQwYGSwU5jNMboUieZV6eFbviEvgmRuNb7v
         ErHhYMFxGflztCKuoqckgWgX8gjWZHg2jmV6fRkZewYloSoqcYa1zmk8dS5F9fHllHhV
         4bhQ==
X-Gm-Message-State: AOAM5304ELemb2+SgTEOQCWnATHlzlu37KAhonwy5UTj04NdD6baW5Iv
        EXqgfTw4dH5M8IOPhmH8SjIKLlbSHe6+EDIZzoOfw0Q8MCf4pj48g5A=
X-Google-Smtp-Source: ABdhPJzcKL1tnzjZkJfwKEq83e9wck7j4Ecx8PG85+yb/XK4dYDnKzJPJ25SivjIb3f1zK0w6SRs5H05rOMJZVnviw8=
X-Received: by 2002:a2e:6c10:: with SMTP id h16mr6218874ljc.404.1611223930645;
 Thu, 21 Jan 2021 02:12:10 -0800 (PST)
MIME-Version: 1.0
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 21 Jan 2021 10:11:59 +0000
Message-ID: <CACAyw9-1HzyJikX7xfN9ixC=asjVzRO25+Wz3bGpausBqmvTJg@mail.gmail.com>
Subject: Please backport "bpf: Fix selftest compilation on clang 11" to 5.10
To:     stable@vger.kernel.org
Cc:     kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you please apply commit fb3558127cb6 ("bpf: Fix selftest
compilation on clang 11") to the 5.10 tree? Without it, compiling
selftests/bpf with clang-11 fails.

Thanks!
Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
