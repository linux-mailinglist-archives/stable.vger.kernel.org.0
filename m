Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B6A3CA4C7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 19:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhGORz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 13:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhGORz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 13:55:58 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483EEC06175F
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 10:53:05 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id v20so10660364eji.10
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 10:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=towY7CXYmAbBf7pyyIgXJtQArVRGwTZKLIGrFK+PL5M=;
        b=sf7dbj447uYAxbgB9EU5b36rzGbFpr82yM5WTwqISBbYwEos9CQP4skhmMJwWOtRCD
         DgPl11LHQnnmOOZV1OznCh1Fc+jeFtoajh5F2bbv2TgHJZV1LsfxsMWJMbQdoBPzAdku
         OIid2RyiOcdSdQBddJoP3TxWYxQ97h8c7vi//0/sivCgmpuvz/VBt1jRgW7HhjD5KBbs
         BlS636pt5SsUrUODLdrnQPdRzqrHHm5YVAnMyouCvUcSNnz66FpKowUKrDd2VXEf6Jql
         jf8iOGAPC7uFw3wcxz+DxLzAu7dReLsuKVyCqR2BgcUreOP2StokEEVkG63+eNO0UNOi
         aBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=towY7CXYmAbBf7pyyIgXJtQArVRGwTZKLIGrFK+PL5M=;
        b=gjnHqvaoyaU11OFe2+CQtdYXQ+2oIsaNOOiNrCJGRvehBcGvZg17vYiDo2UoSb7Hb+
         eWen7x4Y40RvktPVm04adur0oUiz0pT2jlbXye0Ph0KuZ9DjdSb1aW4b6VnM+Z4JPXds
         dJJ0SNRzv76jgK6DjxcqXLhfjavoTa8ijS3HHz3YNnLgdZKbFDLuuz+8blSmoMxkxsvs
         x7J/vvnlly0oWjc1xmsQsWl8Mxpn0idce37E3/bgUOSItG6cOwz+U8ScUx4smfZgdhbG
         tyQuOry2DsEmIiHHW2dBKXCwdiek1rghq0aAc7VqLR/J/SBYt9ea6fyyXi6DauO30s1/
         c6Sg==
X-Gm-Message-State: AOAM532FmehnvUkMBToKwbiXJlTXOatgtnK7GYlGpiSH4rcrwlT9sXXl
        spR+u32FT3uXyEn4t85ap5sjFGOy8/+Qh0eRf5tl6hNP6toNeKpK
X-Google-Smtp-Source: ABdhPJx024NaJdndVuc6vZtHYymdAAcsvJXPN47yX/oYT/qrK5PJ8V27RBElkZ38h6+CpaTkTj6wmMnE/0tyawi32Ms=
X-Received: by 2002:a17:906:844d:: with SMTP id e13mr6824521ejy.503.1626371583744;
 Thu, 15 Jul 2021 10:53:03 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 15 Jul 2021 23:22:52 +0530
Message-ID: <CA+G9fYud=G=NhZdCVrHbadbv2xmeUUmW9vQr_YJqSGBWtNRdfQ@mail.gmail.com>
Subject: coresight-tmc-etf.c:477:33: error: 'CORESIGHT_BARRIER_PKT_SIZE'
 undeclared (first use in this function)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
Regression detected on arm and arm64 due to the following patch
with CONFIG_CORESIGHT=3Dy enabled,

coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()
commit 5fae8a946ac2df879caf3f79a193d4766d00239b upstream.

Build error:
------------
drivers/hwtracing/coresight/coresight-tmc-etf.c: In function
'tmc_update_etf_buffer':
drivers/hwtracing/coresight/coresight-tmc-etf.c:477:33: error:
'CORESIGHT_BARRIER_PKT_SIZE' undeclared (first use in this function)
  477 |                 if (lost && i < CORESIGHT_BARRIER_PKT_SIZE) {
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

ref:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/142783=
4041#L384
https://builds.tuxbuild.com/1vMA3olyV9E6Yr1Ix0LWLlXinkv/

--
Linaro LKFT
https://lkft.linaro.org
