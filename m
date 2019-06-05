Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EB23559E
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 05:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFEDUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 23:20:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35112 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfFEDUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 23:20:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so9153147plo.2
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 20:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=KQxqODuHQSQtSovTOjbNPCaPMCE8H5PhPgJ8g/Tl5K8=;
        b=TFBKmpMV7EF0aCUjJUfIw6n8vOUKtCRAD2rjDvT7B3eNZN3+Vynr+gc+weeg3cdbMc
         GmyvgqAuNBBG5F30zfe4tR37tZbfIpqT9NlHqMQ4ymdtnCAR0m2hmHaBlucR9u8rkpbp
         CjUbJ1Vd1YSASQHoRe9jClWUn5SVkgcsZTBrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=KQxqODuHQSQtSovTOjbNPCaPMCE8H5PhPgJ8g/Tl5K8=;
        b=g3YV4/UWyDAYCZt4LZFxVYXeons0qJGDuZZgsWzrsnICc3JKi+jk0gpaDeRCT3YPDP
         WftHrBBuajc4MWSovHgLubcA1y9ARz1yteiEz9a9tnHsdULkCnSZJqA+yHhprH3Fbte4
         xtaXelHG81iJHYbZzHm1b/P89rUUgyxeyWoIzPg+WzqClyCfVicIHhCcnhy5Gv2qfvYi
         uKnrcfjcFqsQGOwi2SNHlB5jz/yXj/I8+4QTCMW0fr/BYmi8e75jGMCT6PT9HrCR2+rV
         /YNfnCHWuNemFAMOuA5/13lmBdWEoajmkTugsr5pxeD7rcYXj3avfnpEpceoP+WbAOhR
         wZLg==
X-Gm-Message-State: APjAAAXIYiK0J6y0Kcd9+4llrV31z8p8MUnvmq7yd29qfKyFc3mdAtio
        8dHVd/5keYCp+61S9by00QovjkS8ZJA=
X-Google-Smtp-Source: APXvYqykLZu9VnTaUPCU45TKVYxiMnHtmMWT98CP2FahCw+wcqXd2E+4GI9WD2LayUPEOMq8WrJiYA==
X-Received: by 2002:a17:902:18a:: with SMTP id b10mr40528391plb.277.1559704823277;
        Tue, 04 Jun 2019 20:20:23 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o192sm13448583pgo.74.2019.06.04.20.20.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 20:20:22 -0700 (PDT)
Date:   Tue, 4 Jun 2019 20:20:21 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Pi-Hsun Shih <pihsun@chromium.org>, stable@vger.kernel.org
Subject: [GIT PULL] pstore fixes for v5.2-rc4
Message-ID: <201906042018.72255CAF94@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

Please pull these pstore fixes for v5.2-rc4. They've been in linux-next
for a bit now and catch some pstore corner cases found recently.

Thanks!

-Kees

The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/pstore-v5.2-rc4

for you to fetch changes up to 8880fa32c557600f5f624084152668ed3c2ea51e:

  pstore/ram: Run without kernel crash dump region (2019-05-31 01:19:06 -0700)

----------------------------------------------------------------
pstore fixes for v5.2-rc4

- Avoid NULL deref when unloading/reloading ramoops module (Pi-Hsun Shih)
- Run ramoops without crash dump region

----------------------------------------------------------------
Kees Cook (1):
      pstore/ram: Run without kernel crash dump region

Pi-Hsun Shih (1):
      pstore: Set tfm to NULL on free_buf_for_compression

 fs/pstore/platform.c |  7 +++++--
 fs/pstore/ram.c      | 36 +++++++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 15 deletions(-)

-- 
Kees Cook
