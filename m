Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD192E3096
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 10:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgL0J2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 04:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgL0J2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 04:28:48 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C0BC061798
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 01:28:07 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id u19so7276190edx.2
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 01:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iCXtlXm7QBtVZdLGpKU8z/j7zMAGxbS4S3ulgM+9+jI=;
        b=JTuvk3C6SJum8sD6Xm/xIpu7gqffptVPlBUdVuAoO1S2X2K5midvEAtlzVCcXBRNK5
         E7S5sl7wwgs6/UjXBmOsjS99+U53P6YciCYY+GN84QuFX+BRfvG8aGmHhe2sLDPwyQTZ
         hQn+Spgw2ehAujBf/XjulmokdJGqW/nw7N9oJls1gzoFSf000HeV1K7xNmo2qurP/2hU
         eKiQ91zwUGUm05KHrHA3d6QkA/efFl2oEiLcE8iACwzKeqV7bacSec1D/UXSYIPDItF3
         12cHCAUa2lWFpen9u5XIkrBipdebexnakLIR70O7saGbBmHAXrYjvcQ8LTSppK4ZpOLJ
         LxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=iCXtlXm7QBtVZdLGpKU8z/j7zMAGxbS4S3ulgM+9+jI=;
        b=FbTnPUprTEVAG3Wuix+aNRNWqZCjKq2PFObrWX8u4gDgwARy7fFItjctiW6VzyYHLc
         sMnPu4SUnM10r73+ETWcYQoI3a/t6qhuW0W48VbHJATzM5f9HjvBK12tbuuRjMs2y20d
         C6B6cy+5I7FL+l3O0KAhWQzEBYwZgSZjW12gJGwdeOXX3v3BGmwYP+1K2Mn+yOvSZRWc
         AlXEHEkSVYg8KjH1pN1EY+sOUhCDYiarPvmlg4Spy9enaN8zbHfwSzYMgBeGHiC4Q4jD
         c6UllsQFr3jJM2sHPQRri4CtFITB+8ehaxVmoy7uSX4+1yrpCQ/d3XyY+YvvviSXbIsF
         yRrg==
X-Gm-Message-State: AOAM533yzk1ohrML/ut5ADFPHVT0MXfk+Cg2FaB1V1efud1XIa+hV7Bm
        u72MGQ1/Zoany8ZNjT1+n5Y=
X-Google-Smtp-Source: ABdhPJztM4VkdjiEaRsnUqjlGi6o7w5qXuAosnMbaO5Pz9DgCDRYWsYP5FKGod5jXwUyCBDTUueVWg==
X-Received: by 2002:aa7:dc4b:: with SMTP id g11mr38932746edu.379.1609061286633;
        Sun, 27 Dec 2020 01:28:06 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id qp16sm15853281ejb.74.2020.12.27.01.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 01:28:05 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Leo Yan <leo.yan@linaro.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.19.y only 0/2] Fix perf build failures
Date:   Sun, 27 Dec 2020 10:27:43 +0100
Message-Id: <20201227092745.447945-1-carnil@debian.org>
X-Mailer: git-send-email 2.30.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha and all,

This is a resubmit of the patches already done in 
https://lore.kernel.org/stable/20201125201215.26455-1-carnil@debian.org/
and
https://lore.kernel.org/stable/20201125201215.26455-2-carnil@debian.org/

The issue can be explained as this. In

https://lore.kernel.org/stable/20201014135627.GA3698844@kroah.com/

on request 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global
variable from header file") was queued back to 4.19.y to fix build failures for
perf with more recent GCCs.

But for 4.19.y this was wrong because it missed to pick as well a dependency
needed, and in turn it caused build failures with older GCC (8.3.0 as used in
Debian stable in that case).

The commit was reverted in a later in 4.19.159.

It as though requested to try to allow as well compilation with more recent
GCCs (while obviously not breaking older GCC builds) and found that the cause
was just the missing dependency to pick up, namely pick 95c6fe970a01 ("perf
cs-etm: Change tuple from traceID-CPU# to traceID-metadata") before
168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable
from header file").

Regards,
Salvatore

Leo Yan (2):
  perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata
  perf cs-etm: Move definition of 'traceid_list' global variable from
    header file

 .../perf/util/cs-etm-decoder/cs-etm-decoder.c |  8 ++---
 tools/perf/util/cs-etm.c                      | 29 +++++++++++++++----
 tools/perf/util/cs-etm.h                      | 10 +++++--
 3 files changed, 33 insertions(+), 14 deletions(-)

-- 
2.30.0.rc2

