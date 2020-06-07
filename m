Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE9F1F0976
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 05:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgFGDua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 23:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgFGDu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jun 2020 23:50:29 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3E7C08C5C2
        for <stable@vger.kernel.org>; Sat,  6 Jun 2020 20:50:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n2so5277986pld.13
        for <stable@vger.kernel.org>; Sat, 06 Jun 2020 20:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=2BWIVtw8Z1MTJsSx73FrWqbREl+p/WuybtXb9BPDcJ8=;
        b=T4Vz/o27B6nRP6an4MQFPIhNC3/hXGcSMGNhLBYXPw+lRZC0sWByx4ykkYPEUbBBbn
         fo/gZHhwSIIirnAlWtTldCs0pbKLYuil5EWesQhrLjxHiPf8lUSXb+B+A7MK9+7yjjzC
         u9coLBZpMl3Q5Orb/0F/SeaaNsbSCRJpdfxveOqwcIGiiGjnKofoXJa90nSJgjUYZQY2
         HfGkYW1tO7jaaC8mioVhbzudrSOj4yojjTkzgJ7qp0BdhmIy8tttOihLGyTN8siZyeD+
         QmkyxD5gh4gZR+iG6gV7alMupsgKDyeP8eFT4PR+g5kZWGd15acoo8oaBGtRMe+qXJyu
         tFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition;
        bh=2BWIVtw8Z1MTJsSx73FrWqbREl+p/WuybtXb9BPDcJ8=;
        b=Ky4vbh+Ij6c4xZ4jiZ0ncLISVoFZxvaAo7NAkbbLo7v4wVMmQdzU8xFCdA1q6EM7Gk
         SW7HMav1F/AQIdat6nEoWg4DVezffXVpBDPBjb/2xbSW4vYahxZN+3GWRsSmJfy6VFOv
         AphOw8vBeEvrWJ2oz4q7AebXnshelQA5CefR+30gRCEj3QwRikJG9A8+LjX+b+D1pfRY
         klDTHanUgbpxj0hSuYQ92VxomgZLowdLpsBwkHjtaRK2slSl8ciFXi2hgrE9a8noBQXF
         2mpG6+W/k7JWwdyPDnPqo6rdH5xWga/pdScvVz49uDhoim5oaobmcdQgQPpz0Si69weF
         kKTA==
X-Gm-Message-State: AOAM533XZSe8wgpESTG4s5rOrC7i/Us87KBgyhq45zIKYuzVXdthtBMb
        s6Pkx9dsgHV/09aux3B3lwadIO1pTrM=
X-Google-Smtp-Source: ABdhPJx3HYK3acoIWJir4ukOfU369P3EZwfrST34QLbzgCa3mkZh7OPmxxLTUbN4fSfnZDRTAIHnlQ==
X-Received: by 2002:a17:90b:1244:: with SMTP id gx4mr10576849pjb.136.1591501827459;
        Sat, 06 Jun 2020 20:50:27 -0700 (PDT)
Received: from taihen.jp ([2405:6580:2100:d00:e039:f876:9cfb:e6bd])
        by smtp.gmail.com with ESMTPSA id b19sm3345772pft.74.2020.06.06.20.50.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 20:50:26 -0700 (PDT)
Date:   Sun, 7 Jun 2020 12:50:55 +0900
From:   Mattia Dongili <malattia@linux.it>
To:     stable@vger.kernel.org
Subject: sony-laptop fix for 5.6 and 5.7
Message-ID: <20200607035055.GA8646@taihen.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 5.7.0-rc4+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 95e2c5b0fd6d7a022f37e7c762ea093aba7b8e34 upstream

platform/x86: sony-laptop: SNC calls should handle BUFFER types

After commit 6d232b29cfce ("ACPICA: Dispatcher: always generate buffer
objects for ASL create_field() operator") ACPICA creates buffers even
when new fields are small enough to fit into an integer.
Many SNC calls counted on the old behaviour.
Since sony-laptop already handles the INTEGER/BUFFER case in
sony_nc_buffer_call, switch sony_nc_int_call to use its more generic
function instead.

Fixes: 6d232b29cfce ("ACPICA: Dispatcher: always generate buffer objects for ASL create_field() operator")
Reported-by: Dominik Mierzejewski <dominik@greysector.net>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207491
Reported-by: William Bader <williambader@hotmail.com>
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1830150
Signed-off-by: Mattia Dongili <malattia@linux.it>

---

ACPICA broke resume from s2ram for some Vaio laptops in 5.6. The
platform drivers maintainers didn't send the fix for 5.7, so the commit
is needed both on 5.6 and on 5.7.

Thanks
-- 
mattia
:wq!
