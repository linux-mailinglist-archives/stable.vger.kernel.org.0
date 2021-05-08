Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BB0377222
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 15:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhEHNf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 09:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhEHNf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 09:35:26 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8037C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 06:34:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g14so13498963edy.6
        for <stable@vger.kernel.org>; Sat, 08 May 2021 06:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ZqX9LPJw1BbiXrGXr8Y1mMe/eT02VIDJ8nnh8rFdSME=;
        b=R1mK+I7aHIokeVVgXjkyId1E2fVkMFrN+fp3TxG6QWjf+tt/ABIZsc74YdRdHxs6e6
         Fn+OZOubzSIVr7U2/iNBIhX9PHSVrG4FfLl7LWcG6UKLRPlOnVGQcZrF3j7fJ4/UUVIJ
         7cIh1hzEPAM/P/UdJb4nY1zn/89vxPtbuYgAs+4hFqYUclDnSDYhGUPG2B99zEbKI8fd
         zDhr0OCvmD2vtmN1Gg/CK9x+JNaqxW632//0fhr1WTedzLQSBVIme6Us0uXk2BGSLnMz
         Icq5ULF1mJMHzSxuDOQyLLggkZBm9CzUQY2suc0V7ZQAwmXZOCquPwWQpSLVxH6gkfCB
         YZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=ZqX9LPJw1BbiXrGXr8Y1mMe/eT02VIDJ8nnh8rFdSME=;
        b=toTKnwomQnSvzyfENh65ZuZl7ldovDxAwkFu/b//Bf00dUe7iyVHWPG12dof2FL3QC
         uZB0yA+BSIggDZi9wGzyGwxEAVOaqgS952QawxzbqCRZjngY/h+fIAZ+zg7RiwRMqHQF
         mG8Op044oqqIGD7lh/qvFU7g3XXkULisgE+LNsgM29MGoEioE6t2IjH0DLu2cfq9YcFw
         OU8yheCXUGD9sDCxjI7rY/miK9trAXVxm7X1jbO4ON4OQFx6KwxVGURJm31O1ZB36zXr
         Knfqd64Om9TYYPpibMVdqh11RcKTSMWBtPSrpvP7S6R3AgOz5abQyZkc4yo0Ur35Alxv
         lH8g==
X-Gm-Message-State: AOAM532YNPRyTcIZ2YIiKyUiNgGYx4r+B0qs2+CuifRYfPzgWzJkI8s6
        17iotcCBgtQEww9kKJYA2Gs=
X-Google-Smtp-Source: ABdhPJzkkz5JIcU1npJAGMo/yygBQ6Ants3iOV5xu3mCY+GOmYY2LGM8libUXQEEa2MKQb2U6HZsCA==
X-Received: by 2002:aa7:d950:: with SMTP id l16mr17802202eds.374.1620480863666;
        Sat, 08 May 2021 06:34:23 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id h9sm6189243ede.93.2021.05.08.06.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 06:34:22 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 8 May 2021 15:34:21 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Chen Yu <yu.c.chen@intel.com>, Len Brown <len.brown@intel.com>
Subject: Please apply commit 301b1d3a9104 ("tools/power/turbostat: Fix
 turbostat for AMD Zen CPUs") to v5.10.y and later
Message-ID: <YJaTXf1b9IPj/5If@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

the following was commited in Linus tree a couple of days ago, but so
is not yet in a tagged version. 

But still please consider to queue up 301b1d3a9104
("tools/power/turbostat: Fix turbostat for AMD Zen CPUs") to v5.10.y
and later for the next round of updates, as it turbostat no lonwer
worked on those Zen based systems since 5.10.

Thank you for considering, I can otherwise reping once 5.13-rc1 is
tagged and released.

Regards,
Salvatore
