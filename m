Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E5A467657
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 12:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbhLCLbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 06:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbhLCLa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 06:30:57 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA777C06173E
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 03:27:32 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id c32so5786893lfv.4
        for <stable@vger.kernel.org>; Fri, 03 Dec 2021 03:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=TzW6TXnfq8OtLTLQdwOY4LZWcnWKKswJe+qqMF/4SPw=;
        b=C5bFuejtBMZAuTiOq6qF3fWmYxFZHTh5xxDN5hH5XcJN2MrDhkfyQ2C9SRUKxj2SLm
         VGnacUUQX1VTZtdxej3S85D9H7rYr8W7BAdX2/ZitdI4ug2eow7SNTclzRz4j20PS4oW
         XLgJl/4BzQG7d8rYjLR+Z/2PJbPt39SdJR1r4FeZegSxdrmgOVFisWCPOykr2zWh3M82
         c5462eO7XMthx46cmTM2rp8GAmJt/rAO0kGjS4Gs2G8n1J+G1sctS/4uFb4hlhElcwyJ
         90eQ6p3j2wn15S6xp6FeqdLztYeYnWitwyzZVzgh62T/NOdT0kCNfvFAKFRIj8l5DIqF
         4Kow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=TzW6TXnfq8OtLTLQdwOY4LZWcnWKKswJe+qqMF/4SPw=;
        b=evsCHSJVOZ6opKMNmI+yC7dwCFyfzpFqu0oCmSM3CuavXRgPWD+ypQJZ3Fel5U+ygK
         ryxo9TE1ue0aV6Rfl45IKRCMYgRFD2HOBYEwaR9y3T4RTlqvdG6kbBqK7F1TDfF7PJbs
         AyiHcaDCgpA/j6u8jkbFarKQq7MoVCP1HkKJKHELGunExfO2daMtf1HvQ0VUv7SHvxxl
         PB74vbmLloKvsY7z64z3F1whCyB6PnaP1APa1oZiz4rqceLTdMuAKNoRgJYvYx4Q2cso
         IDhIvZLWXxdswZsSyCXAEY7rUWDVoXb51AYDpVoXPLSkhsSCBQDC7c6TzsQbwilRMF7t
         UCvg==
X-Gm-Message-State: AOAM531pjLotyZqCnhHch7oaxdM/pLGLtTcfJM9dJVDvu3sjs/4jKZtC
        VI1fIrp/91zDrhkhWBox106yS5t9XUaHnjh/3uw=
X-Google-Smtp-Source: ABdhPJww2aPhpjBmja/BbFqmizdCZWGM6ImWadqe+ThmOtMDhhIpw2UQoLDWoMY3Yzb6pVSXDrotXH3AxFy9J/YzxFM=
X-Received: by 2002:a05:6512:31d1:: with SMTP id j17mr17053385lfe.395.1638530851313;
 Fri, 03 Dec 2021 03:27:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:a68f:0:0:0:0:0 with HTTP; Fri, 3 Dec 2021 03:27:31 -0800 (PST)
Reply-To: rolandnyemih200@gmail.com
From:   Rowland Nyemih <tchanariyempaguidi@gmail.com>
Date:   Fri, 3 Dec 2021 12:27:31 +0100
Message-ID: <CALc1DuPuvcfqKQ-w7xG1ezDNpBRyzNQ01aS4ZjyzPLYfzZ8EhQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQpJIGNhbGxlZCB0byBrbm93IGlmIHlvdSByZWNlaXZlZCBteSBwcmV2aW91cyBlbWFp
bCwgcmVwbHkgdG8gbWUNCmFzYXAuDQpSb3dsYW5kDQoNCg0K7JWI64WV7ZWY7Iut64uI6rmMLA0K
7J207KCEIOydtOuplOydvOydhCDrsJvslZjripTsp4Ag7ZmV7J247ZWY6riwIOychO2VtCDsoITt
mZTtlojsirXri4jri6QuIOuLteyepeydhCDrs7TrgrTso7zshLjsmpQuDQrstZzrjIDtlZwg67mo
66asLg0K66Gk656c65OcDQo=
