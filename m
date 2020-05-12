Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9908B1CFEE0
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 22:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgELUDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 16:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELUDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 16:03:43 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1431DC061A0C
        for <stable@vger.kernel.org>; Tue, 12 May 2020 13:03:43 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id j3so15109734ljg.8
        for <stable@vger.kernel.org>; Tue, 12 May 2020 13:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=TtHMtxk12z0lmJd8TayY7elcJRSVl4C6mKF6tMEotvA=;
        b=iNAClLpitxUhKFUamv/X3YxG2Y8txUOWKzpWFq0hwqvjGwkb3xabtc00ayIbmOPtx2
         iP5YaDFjkINowCcRjOhC3RYnjIQ8jRsDSlH/M2Nl2MCxb6Co+ZLnKao//7g4G3XTC1HH
         oRKHB6k8WAmGxMzqbJdFnKwgyPI8g3OrYqNlBKzP/X1Pwlg3HOBkVJ3zf6l0/0pGJZdR
         wfQaUnqCeMrqJ4N5RWjwHcjtknf8j0IS9E0lwGuNtMFingbg3XHoujA6KPuAc3V3xmpp
         0SBEd6+u4nJI7O5uDGk9CPo9HrpODO6zevL9/waidX4dnir/lC8vdCCucn7r42QQsygP
         4/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TtHMtxk12z0lmJd8TayY7elcJRSVl4C6mKF6tMEotvA=;
        b=Wa8tc04rUW3UNy4LoUuIpU5TdQnxkZv9oiaKZ3z8Dzpa65GuRXOBzAtkndMNYgqQoT
         AS4oJKShb6xDaYDURgvJj0+x+/eba5oKMSFKniffmArgtrkgj3SCeih6NlyXN0cW4wUQ
         QqAP52UPXrpT9oZa4tAPV3GMAoZ9MIekRy2fm9Ejs8DzRw/q0Qh4U2tnI7K5qBmDV24a
         mB3tcMoOHAXpycqgLS/DMW519T6zYhlA8LSj+V1TNzc50pihN7MbFbHm4WHrYFS0OySO
         2I/3AbhkmXmM13A3t7NQQ/HfRld7MMfsorhwObKnBB7x9hWKWI732nGSSaITIooKjFs2
         Hgmg==
X-Gm-Message-State: AOAM530kDojZork2oBXdNABSD5Xwx+Ip4Rpvb3ls6WB+Gz8CvL5Rc3NM
        3X9H7mkynDNUMXclhO/ulgdaRIbSc5ywiaj/vfzKwqzg1us=
X-Google-Smtp-Source: ABdhPJxwlkJvw2ROafeDqNwNrCoK8oWuPjIssnA/XWJz3/XyEJS0iHANKBVgi3iwQLbkLA099sGs30053Z2OpWWurK0=
X-Received: by 2002:a2e:b609:: with SMTP id r9mr1460732ljn.125.1589313821207;
 Tue, 12 May 2020 13:03:41 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 12 May 2020 22:03:30 +0200
Message-ID: <CACRpkdb3WrEp1uvzMUGebtdXYPv5sMNF_gd5_zcB+=n3P48GQg@mail.gmail.com>
Subject: Please apply Revert "serial/8250: Add support for NI-Serial
 PXI/PXIe+485 devices
To:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Stable folks,

please apply commit
27ed14d0ecb38516b6f3c6fdcd62c25c9454f979
Revert "serial/8250: Add support for NI-Serial PXI/PXIe+485 devices"
also to the stable tree.

My Fedora cannot switch baudrate or write to my serial port and
that makes me so sad.

I have this problem with kernel v5.6.11.

Thanks!
Linus Walleij
