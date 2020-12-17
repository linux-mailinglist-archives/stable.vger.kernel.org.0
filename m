Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F132DD9A4
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 21:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgLQUHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 15:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgLQUG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 15:06:59 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BC8C0617A7
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 12:06:19 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p18so9465566pgm.11
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 12:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uber.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WrqmAvRW0Poep6vyf6Cgv+PX/xxdbDabVFsngcDQQZI=;
        b=2boYhnGZxs/pzR65PYh0P2RGhPfUd3oC9yTYr6CULfWF74aulDx4YVQz9Kiomzqfu2
         TH7WkN3sy10JJU2hO7iJN3Z+D8AHH0XMYD54wlhRjytHilxuQL454jri0K0cy+98FVOE
         Q09njH+jjEWwACG9qAhbYs06PxHubbREHiDsg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WrqmAvRW0Poep6vyf6Cgv+PX/xxdbDabVFsngcDQQZI=;
        b=be8W/dkJomM/Zki+gs2KrstW3u1iifIRwagYwTmaJrWiX6hMW6wzTNJ3nLTOxr8NuE
         e6xRPSHyoCEEcN64Qliee3n5vqBfuT1YyeXmVB3DEjhZ6KMYjpw4SphnYCrUfRdYxZUZ
         qyjVtJNQ/bk860YYandIQCrFDM3j0goSqVyjDyaW++22NKG+GC6h47uJt4zj+ebwGZ0H
         e5z03mAqZhCHAh9Cnk1htbJfAkOCKBUAOh529p5GzwwpJvDAhaPNGQfsid20O/PnnXUM
         bbXNRJJmLEOIXsis+88Z0KlBq2cyCpUpVeyuyIDCmjYfH6NZuYwiMdyhpZDcOueVw1YG
         tseA==
X-Gm-Message-State: AOAM531/3fs+Dyu+SJ2m6h00YIdQkTbiY0l2qmYfdPKCTceJskZTdLOX
        l5L3o4atUgl8QjR6KKXj8CqAevr0PX21Ec4q
X-Google-Smtp-Source: ABdhPJy3YPtrKPa4LirJemXr2XqyeMLXuG8ungUlyJztUNxSHNpJHrYGlzQ2J+NysF8qRT9ygSsL2Q==
X-Received: by 2002:a65:6492:: with SMTP id e18mr844932pgv.275.1608235578679;
        Thu, 17 Dec 2020 12:06:18 -0800 (PST)
Received: from [172.20.10.2] (223-141-64-125.emome-ip.hinet.net. [223.141.64.125])
        by smtp.gmail.com with ESMTPSA id l197sm6672995pfd.97.2020.12.17.12.06.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Dec 2020 12:06:18 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Question for AMD patches
From:   Young Hsieh <youngh@uber.com>
In-Reply-To: <1B44E762-F9F2-4E2B-BFEF-6F032BE8841E@uber.com>
Date:   Fri, 18 Dec 2020 04:05:45 +0800
Cc:     x86@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <83E7490A-EFB0-42C2-BD9D-B5E6E5BF440D@uber.com>
References: <1B44E762-F9F2-4E2B-BFEF-6F032BE8841E@uber.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,=20

This is Young Hsieh from Uber and currently I am in Uber infra team and =
in charge of server system design. Nice to e-meet you!  :)

We are working on AMD Milan platform with Debian, and notice there are =
some patches for performance and security improvements, which are not =
implemented in LTS kernels (4.14/4.19/5.4) yet. On our side, we prefer =
to use the general LTS kernel release instead of a customized kernel, in =
case we will not align on major fixes down the road. So would like to =
know if there is any plan to backport these patches and if so, what is =
the timeline?  Thanks a lot again for any advice. =20

Cheers,
****************************************
Young Hsieh
Uber Hardware Engineer
****************************************=
