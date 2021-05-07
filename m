Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76433761AD
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 10:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhEGIIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 04:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbhEGIIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 04:08:40 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59FAC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 01:07:39 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h127so7054562pfe.9
        for <stable@vger.kernel.org>; Fri, 07 May 2021 01:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=QoQVFiFCOER3C6C+2FyMcjq2JX0Ih0mmBEKDTwOhTdY=;
        b=lUgScMd1AzWDhvglM2nQtL/VOU3n3MFHwdZko8YHJHOKyBxnHoOclStWXldpvRJUgo
         uenYH4pnHvuOEfsu7P8jmdUSHrP4zX2v7DdSV6avpDgnIg8WpPZwKam4aT8GN6sk5tE/
         iVH/Y64h/Kk5JC1EnejBd6Iizkr5bs+qPEHBLjAHkwa8AWUZJvF5dkqXYoBwTFvNlpoI
         8PpbsWOgMxYj7fd6xitRoqWBq9qEcqODGRNY2OEhE+SoC77TUJfZD2W+a8XQKu2gKdEB
         ydBttwnJp0oIJ3tiEsMPWurfl0jUi8R6UIopsCP0dDGO93dKqaBnXT/asbNPrY6YU+bn
         uXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=QoQVFiFCOER3C6C+2FyMcjq2JX0Ih0mmBEKDTwOhTdY=;
        b=EIt8dxECPHzcAgnDAHpqjEmzM17XE5ZuDpJpYXyYf1Gd6S2vGHzEVdJtcc1jojQ6AM
         Jo7DgY9iSNUjRh/NSh771lybZJwlz/i5oZJbCtV053Ze+W5iwlw2cOtB0FChkmL7YsZc
         cEfTPbCAGNAjKob/O4k7Q/irmKUMP/DB2yAto9HjBmFJh4kpmtCAcsL0lJ5furJzdcMG
         HlYrZ62YFWLiA/V3BeiDu4ULJgOff5aWhDVRc4WmANn2zA6bp5c2X4jtHm/7Q1jL0ngS
         x403j3wBkRG2iHO1F03jGflr+nGlWAHZyQxchSZgKp/RnKCojXN3S28WKTyV3asgmmOL
         Ik6g==
X-Gm-Message-State: AOAM5304NPFDzpzhklEUAxIxQk5BcZD2QhNQ8pRZMQgmdIodigpWzvBT
        /4fOlrHWTJp7duh8GFA2DCOO
X-Google-Smtp-Source: ABdhPJwXOXrrPpYQPA52Lx3NdzN0KyFFh21qokJnn21gp6+8d80uXtgOnJ3u0tKezW4onT+8chVnDw==
X-Received: by 2002:a63:575a:: with SMTP id h26mr8992545pgm.35.1620374859146;
        Fri, 07 May 2021 01:07:39 -0700 (PDT)
Received: from work ([103.77.37.184])
        by smtp.gmail.com with ESMTPSA id x23sm569343pje.52.2021.05.07.01.07.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 May 2021 01:07:38 -0700 (PDT)
Date:   Fri, 7 May 2021 13:37:36 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: MHI v5.13 commits for stable backporting
Message-ID: <20210507080736.GA5646@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

As suggested by you in MHI v5.13 PR [1], please find the below commits that
got merged for v5.13 and should be backported to stable kernels:

683e77cadc83 ("bus: mhi: core: Fix shadow declarations")
5630c1009bd9 ("bus: mhi: pci_generic: Constify mhi_controller_config struct definitions")
ec32332df764 ("bus: mhi: core: Sanity check values from remote device before use")
47705c084659 ("bus: mhi: core: Clear configuration from channel context during reset")
70f7025c854c ("bus: mhi: core: remove redundant initialization of variables state and ee")
68731852f6e5 ("bus: mhi: core: Return EAGAIN if MHI ring is full")
4547a749be99 ("bus: mhi: core: Fix MHI runtime_pm behavior")
6403298c58d4 ("bus: mhi: core: Fix check for syserr at power_up")
8de5ad994143 ("bus: mhi: core: Add missing checks for MMIO register entries")
0ecc1c70dcd3 ("bus: mhi: core: Fix invalid error returning in mhi_queue")
0fccbf0a3b69 ("bus: mhi: pci_generic: Remove WQ_MEM_RECLAIM flag from state workqueue")

I'll make sure to tag stable list for future potential patches.

Thanks,
Mani

[1] https://lore.kernel.org/patchwork/patch/1411161/#1609631
