Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164682DB0EB
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 17:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgLOQHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 11:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730624AbgLOQDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 11:03:34 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681E0C06179C
        for <stable@vger.kernel.org>; Tue, 15 Dec 2020 08:02:53 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id x23so1750742oop.1
        for <stable@vger.kernel.org>; Tue, 15 Dec 2020 08:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=lg+8ktKrlNAIkofIfM5AN9OTMqYNmCaRx1rMfOXbb+M=;
        b=EpcDy+GluHIjwJRgKxEKokfwvaDGaKgM0KLzPWu7xIpE/I4+DJg3YIbzO2Y0poY8x4
         3MicoERS+GPFsXVY0bqrWouQqSElTaQUOJkXRJ0UP7HgvbGAkzoU3vag1lnTcv78+aNx
         n8qYs1mB6ZSrYoyHhnsKhzylrJeMOVCD1o2O8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=lg+8ktKrlNAIkofIfM5AN9OTMqYNmCaRx1rMfOXbb+M=;
        b=I5qKjwQ96q8DSTqv7iS2jPwrgi6YKVFMm5oASr+PbN2c8lAYDDIJ6G39mys5lN1stn
         9dk1vyh2Xq1a2yJOn8vHtcO6esr/CsYXuDt6aRjsMUKifIeenv2LebjxG8CGCke6vjk5
         66AhwkO8cyDTamxUvOZ6cdWW8Bzl3Qdeih1enc/bPHn57vvX1ioSUEHCaTNjtgmVHbNp
         yUKnxoKMZ6FSw6aBpj/64bSLkjf4wqISE9Yv177AgnYoM1rFSwuQgECXt8J12ImwfotX
         gJ6KPe1gnV36FXkz0K5Y2Nz12dMgYeUM5y9f9nHShjocqQPixSN/YpN6+4/aF0EfzG7Z
         hcMw==
X-Gm-Message-State: AOAM532hasCtSnrSwfusK+nhKtMqnIrwtxh+UX0zHKQzbFh6sjl5hbaS
        s2xTN835D1cN+oEFrXjDE4PJwGFjNQMORAQrHY/t8Aev/hU0SQ==
X-Google-Smtp-Source: ABdhPJzGmyVSnRgskt0YhqEm84llRIlyrwDA+to1NpOFYkPCEI5LnVfOawKKGYIgR07SWgoYmZc5+ib2HHJxzpi+Occ=
X-Received: by 2002:a4a:c387:: with SMTP id u7mr18148534oop.89.1608048172256;
 Tue, 15 Dec 2020 08:02:52 -0800 (PST)
MIME-Version: 1.0
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 15 Dec 2020 17:02:41 +0100
Message-ID: <CAKMK7uFUbZ53RCDrYPJpmxYjevSB11NSqRVLNSX+XbzrojxaeQ@mail.gmail.com>
Subject: Backport request
To:     stable <stable@vger.kernel.org>
Cc:     "Wilson, Chris" <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable team (aka Greg)

Please backport

a04ac8273665 ("drm/i915/gt: Fixup tgl mocs for PTE tracking")

Note that this needs

4d8a5cfe3b13 ("drm/i915/gt: Initialize reserved and unspecified MOCS indices")

but that one has already a cc: stable, unfortunately the bugfix didn't.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
