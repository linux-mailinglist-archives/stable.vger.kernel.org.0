Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53375377C72
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 08:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhEJGkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 02:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhEJGkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 02:40:08 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1788C061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 23:39:04 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id k127so14395302qkc.6
        for <stable@vger.kernel.org>; Sun, 09 May 2021 23:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=EWTBDnZZxXDWLHPc9bo5hAEMvp48nqb60XbDtZGDdMU=;
        b=AsiVBf+5yfq0mNSqRNvJTypUbGg7uLr2KSYeKhByagUjFd/z1iEYnCEFkxNkwJJlMo
         PZWGuTMfgeu0YqWEIb757SBDkBSxEs281CgU+7p955d8DHE0NdxF3bnoPM0nnyN1s9zE
         vj1UaEYunN9R39mmGVdODfJNqIs6JDHhAegNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=EWTBDnZZxXDWLHPc9bo5hAEMvp48nqb60XbDtZGDdMU=;
        b=HZ7JWi26/Z7bYlwbAfvqEDBysGBFhEhGSix6Jx9Fmy4oi1C6cHF2diu/2VN7nvgp5i
         0K5N/L7zq/GZX8/INVGSMPKWsEyC4tVfb/XCIgShw8MjI5c819wGHGs69U3hKy+7uEFj
         Q9KnYrRoIMYvKEvUuulzbEaGqtcY+uFOzq/q+IQ9hp+TCLbcckuWskwPygnWhwWd4WZv
         iCQaazjhAqHhr3a2vlzMxS2nIxKB78M43o3IsmEoDgEGyixB4B+YnP35JqgOZpkxxLrl
         ypjE9l3++CKO1lBBQZNB0MhUUxnEIULE8vcZ4mQRJPfBciPfiSO24a+gzS9fkGfVYmdv
         pHCQ==
X-Gm-Message-State: AOAM532yLX0v8jwv0a521Aum2Z2IacCPW8qLpOqtXhzZNdg5LykuPsQ3
        pW0N1KIHIPB2sAB4qBaiOPn3VfV9ikmLyDqp/O5cQZ++SnQ=
X-Google-Smtp-Source: ABdhPJw2vPTbgbA1Gjlnmv841Lf6N8koElKNlFPefnFOKCja6eTgBc4anoS1TOPPpNugIqjzQa4eVRor5YOMvGdqYPY=
X-Received: by 2002:a37:63d5:: with SMTP id x204mr21234234qkb.487.1620628743152;
 Sun, 09 May 2021 23:39:03 -0700 (PDT)
MIME-Version: 1.0
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 10 May 2021 06:38:51 +0000
Message-ID: <CACPK8Xe9K5QzfY5RnfhGeX_x7x7r69+uYSZLnafbh7j4B525jA@mail.gmail.com>
Subject: JFFS2 Backports
To:     stable@vger.kernel.org
Cc:     Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Can we please have the following jffs2 patches added to the stable tree:

960b9a8a7676 "jffs2: Fix kasan slab-out-of-bounds problem"
90ada91f4610 "jffs2: check the validity of dstlen in jffs2_zlib_compress()"

Both patches fix issues that date back to pre-git history. I am
interested in seeing them applied to v5.4 and v5.10.

Cheers,

Joel
