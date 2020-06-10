Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3411F4A43
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 02:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgFJACa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 20:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgFJACa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 20:02:30 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F33C05BD1E
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 17:02:29 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id j202so206805ybg.6
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 17:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=eGmp20l5a335mOiPPMzuKw3U2cmKlWKTFIpZ/61VxiE=;
        b=PjXMd2gm2my5oQalAQlka2x+nfvwTWKq8IVzApeHOpfRtj8qja9zUOBpEGOcE22W1c
         6xRnYmLa1FgpmDgQdgWn1+DgLvLJymLGmdajUCLvUYTrEPe9VpQsvx3gii0TS0iQ0gqj
         UAKcac9l43kL6GJG3+spn88tBB/BYhXXcGfGLaiTTx4T29V4iuJVMdeF7SJf+cRZefZY
         MDnFGhwh1YlGfMHKePDcxT6eo98opA05g0ibtnITbq3T+tQk7DFWxhtWEc0MXmWkv31g
         dRSqmiTASHkXH+BTDcv97FxhvBlyX9fIOqVU/UcvXK0giRREa7Pk6p9H5sC3QjTe6Kgy
         cB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=eGmp20l5a335mOiPPMzuKw3U2cmKlWKTFIpZ/61VxiE=;
        b=PEqkBIWexq0kJgkuP2/zObbY7oUR+4UXsBHispmFR3aYGAztLJmQBSEjqmaCgS3Nr+
         7+6n3c0s/g5b6QuxkbVkxx0ChBm6GIFiFaKJ9z+A4E4G8lU2+ywy7e50Jg7ZEz3yQHLj
         bi8fQa8gb6o603EznRcqlE3+M9/iPyvc7ZsAbhnKtAHsJ8Rtw6Rt73BRVp+4cNd6m1IU
         eXusbNLDQasQLs+K6Nkf5sRrsSSBTDInQxrdnCDCgg8r5WJlwdetL/9NLs3MQrNeuD0x
         tSzmaeK8O6ayMoNPSgCRa5QIeADP7Q5O8O0H5hwSfmp2CDvwQm+3AJWBiPwqyafv5lKj
         pduw==
X-Gm-Message-State: AOAM531jmAMKowFNzmJf2XsF23LQ28RawLt2r6cuHQ9BL5oZWar2yLz1
        S2Y51JJ3vEQIbErFnY3L8lpiAAnrDUFh9sFDbTc5RbXVVhM=
X-Google-Smtp-Source: ABdhPJwrSZAiIkQcbtbsus7okB0YzhBCmeT3bk+Pk++0eYR0r+STy7XCEQvEglep52HPkaYEJJBIYzgCR1T4VIMxv7o=
X-Received: by 2002:a25:7086:: with SMTP id l128mr1143933ybc.34.1591747346392;
 Tue, 09 Jun 2020 17:02:26 -0700 (PDT)
MIME-Version: 1.0
From:   Jeff Chase <jnchase@google.com>
Date:   Tue, 9 Jun 2020 17:02:15 -0700
Message-ID: <CALTkaQ1ABhqF2hS=SsUrJ5BgTCc-=JDhCMK_hbR=0DAKvDGmfg@mail.gmail.com>
Subject: Please apply commit 7b06a6909555 ("igb: improve handling of
 disconnected adapters") to v4.4.y/v4.9.y
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please apply upstream commit 7b06a6909555 ("igb: improve handling of
disconnected adapters") to v4.4.y and to v4.9.y. It fixes a kernel
panic observed in chromeos-4.4.

Thanks,
Jeff
