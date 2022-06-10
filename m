Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6885545AEE
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 06:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiFJEWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 00:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiFJEWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 00:22:05 -0400
Received: from mail-oa1-x49.google.com (mail-oa1-x49.google.com [IPv6:2001:4860:4864:20::49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378072BC4D3
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 21:22:03 -0700 (PDT)
Received: by mail-oa1-x49.google.com with SMTP id 586e51a60fabf-fdc4b531bfso983878fac.13
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 21:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=p3GoMTVXPNUomTRg5kWwEPmqFJRlSBdzBrIInDB9lY8=;
        b=E6PdI/Zs1u2vrzLtttmte7bBW6aXVChZR41TQD2BKzIykbvrdKkxvuKfkHuWfBW2ot
         udv4y/rSdZEVPr2gNufCjXUr7/ov0Y49W1bC42813n7U0wItHmJXaabXq4d8zIepKtcV
         z+OuhUDUT7LaCfjFeYpwAMUfHzzOKtS9Gx0/0/xXgVtiiL26z1l/ERg6YVyxPbM9KGtf
         3z8jhRXAs5iTLZFqurOV5LH00zpIL7hh5lhnbS2eZbDKWHLBxR3sn4GRgQoLmJsTuqjI
         Ya5ghEAtzJ7FVs4fKGlNdVPsW6N3v6ejYuLcDTz79KUxaafTyXQjW34w2q6Wi1g23lXW
         He4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p3GoMTVXPNUomTRg5kWwEPmqFJRlSBdzBrIInDB9lY8=;
        b=G6IOeG8dhJttvj3c/Ov3qZzE8ZTp1P3HU4zKC9iRWEevflc0NJ9mZb/IKvAcB93KwW
         7B7GXcR+pGsi9Yazfid0I5s9RcpkTGLCtIYHEAQnO0+los1x3IuSQiFh9KCC/MX1dTR9
         8K2a86AxjdaiejnZLs1JdQi0/5Hqd5q+Vbkd20Fma70CfGb6mxM38tisngfg5AB/sosg
         69E8y1/HEwXE5FLCtDQ0AkH4hpFXbj3XiyOSuJ8NSPHLkpcUyw2qF8rP1Mp5s+nz8VXS
         GEzZC8lGs24EEOFUtdCPU41mq0XeXYIYow6ypv5fCgc5uLl73/LJegTxdR8tQWF6q7ny
         bLvA==
X-Gm-Message-State: AOAM531oh2f3rWrqC4RTJgjeNYm5yOKVqYnKSQb/URQXNTJEho2I319A
        3aEqmR3vhr6v+8eSTR73k3JAPRw=
X-Google-Smtp-Source: ABdhPJzsNakIyUullb4mIHvyY/6pTAev8lz3aoDRj1UP3wcdy6KiJI5DZ37K4Kf1dHz2B+oQcwnx4Ew=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a05:6808:202a:b0:32e:f6b5:bbe1 with SMTP id
 q42-20020a056808202a00b0032ef6b5bbe1mr2403676oiw.266.1654834922205; Thu, 09
 Jun 2022 21:22:02 -0700 (PDT)
Date:   Fri, 10 Jun 2022 04:22:00 +0000
In-Reply-To: <20220603173816.944766454@linuxfoundation.org>
Message-Id: <20220610042200.2561917-1-ovt@google.com>
Mime-Version: 1.0
References: <20220603173816.944766454@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     gregkh@linuxfoundation.org
Cc:     keescook@chromium.org, sarthakkukreti@google.com,
        snitzer@kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I believe this commit introduced a regression in dm verity on systems
where data device is an NVME one. Loading table fails with the
following diagnostics:

device-mapper: table: table load rejected: including non-request-stackable devices

The same kernel works with the same data drive on the SCSI interface.
NVME-backed dm verity works with just this commit reverted.

I believe the presence of the immutable partition is used as an indicator
of special case NVME configuration and if the data device's name starts
with "nvme" the code tries to switch the target type to
DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).

The special NVME optimization case was removed in
5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
affected.
