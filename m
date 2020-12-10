Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E8E2D5A5A
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 13:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgLJMUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 07:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgLJMUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 07:20:31 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A39DC061793
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 04:19:51 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id y17so5230684wrr.10
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 04:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=VI2T1cT8QgN0EW4/jHABU5I0ujRiAXcTUjtAl3tzEfg=;
        b=Hnrw75JHDoYdWc/siXQMGY7Cy4GAAM//pohEn3LE3YxtRbVFmydJnrudWqfbkFh43C
         1Krkmdm+fUXohGwS6NJEu4yue1ori0/h/bKnkL3iUO2ZouH10QpTg6X2La3HrI/KBDpA
         ZOKPRIcdYufnNmLwcwsqQIkK4Jkwd8w6Zuji6zFM15SBXTX26JOFLH8ziJtFO/aEoi3l
         SISNv6kcRLIjrSfVD5dw5cwi8v6ZnmEt/kHi2qpfDB4Pv5tDQ9TCBHlIJxOZesumzpQX
         6QwbXXiwyl3MW85hrVRP0spxBd2kLhRJIu44LhM00wHxvJqlnuUpwte/ZvGSnfXXkNOW
         HrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=VI2T1cT8QgN0EW4/jHABU5I0ujRiAXcTUjtAl3tzEfg=;
        b=NYlNZkMeb0c9vDpgUV6YMW8GnGpSN3210XcmFNumUghuHl1RYkbizYhEtciHZ3BXpV
         rMS6H3THUFI0AXo0dq+3fhlyiPaxAeXEJg9XdZtFMwySaHW9FaC+ZR6GEHlXea6heEH3
         Bf8VGjL9pog3gXyhPyYrFp1Ww5FsHZs77aCuNF8hJuN4zAnQujGa0kr7vvJVTPC4k6Jj
         Mt5KRdtqhQe/qpYeJV9lL5xQL68hP0pbFqPU4E4D2ivVkV56ydsjln3Fi0mBQx15rubn
         iHQGukbLCGqc9eQ00fbk8v9OmHWVHSfpET5+1T/lk149P51jzPlvJguG+ZLMuD3s2QGI
         iGdA==
X-Gm-Message-State: AOAM5300KnKGLtcyjMgmwmieY5MmAZ9bQtPl/C/jHGmt1nBELAnGI7Bx
        iY0Qxpe1c+bliMetdrioEewakXU2OJzM0h3W
X-Google-Smtp-Source: ABdhPJzesvphN3whkAtBDIjJBhW4dau2itstIoSOoc+Re/CBRXTbprUsM43veNugdZYsXeyOAP2rlQ==
X-Received: by 2002:adf:fd05:: with SMTP id e5mr8062622wrr.225.1607602789590;
        Thu, 10 Dec 2020 04:19:49 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id n126sm9300273wmn.21.2020.12.10.04.19.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 04:19:49 -0800 (PST)
Date:   Thu, 10 Dec 2020 12:19:47 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org
Subject: request for 5.9/5.4-stable: 4f134b89a24b ("lib/syscall: fix syscall
 registers retrieval on 32-bit platforms")
Message-ID: <20201210121947.shepiv5mqewbtdzu@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

4f134b89a24b ("lib/syscall: fix syscall registers retrieval on 32-bit platforms")
is not marked for stable but I guess it should be in stable.
Applies cleanly to 5.9-stable and 5.4-stable.

--
Regards
Sudip
